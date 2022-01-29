import Foundation
import AVFoundation

public typealias Signal = (_ frequency: Float, _ time: Float) -> Float

let square: Signal = { freq, time in
    if (freq * time) <= 0.5 {
        return 1.0
    } else {
        return -1.0
    }
}

let noise: Signal = { freq, time in
    return ((Float(arc4random_uniform(UINT32_MAX)) / Float(UINT32_MAX)) * 2 - 1)
}

class Voice {
    let sampleRate: Double
    let deltaTime: Float
    
    var frequency: Float = 440
    var time: Float = 0
    var amplitude: Float = 1 // Similar to volume, but used for envelopes
    var signal: Signal
    
    var volume: Float {
        get {
            sourceNode.volume
        }
        set {
            sourceNode.volume = newValue
        }
    }
    
    var pan: Float {
        get {
            return sourceNode.pan
        }
        set {
            sourceNode.pan = newValue
        }
    }
    
    lazy var sourceNode = AVAudioSourceNode { _, _, frameCount, audioBufferList in
        let ablPointer = UnsafeMutableAudioBufferListPointer(audioBufferList)
        let period = 1 / self.frequency

        for frame in 0..<Int(frameCount) {
            let sample = self.signal(self.frequency, self.time) * self.amplitude
            self.time += self.deltaTime
            self.time = fmod(self.time, period) // This line ensures that 'time' corectly stays within the range of zero and one 'period'
            
            for buffer in ablPointer {
                let buf: UnsafeMutableBufferPointer<Float> = UnsafeMutableBufferPointer(buffer)
                buf[frame] = sample
            }
        }
                
        return noErr
    }
    
    init(format: AVAudioFormat, signal: @escaping Signal) {
        self.sampleRate = format.sampleRate
        self.deltaTime = 1 / Float(sampleRate)
        self.signal = signal
    }
}

// Source: https://github.com/GrantJEmerson/SwiftSynth/blob/master/Swift%20Synth/Audio/Synth.swift
public class Synth {
    public var volume: Float {
        get {
            audioEngine.mainMixerNode.outputVolume
        }
        set {
            audioEngine.mainMixerNode.outputVolume = newValue
        }
        
    }
        
    let voice1: Voice
    let voice2: Voice
    let voice3: Voice
    let voice4: Voice
    let voices: [Voice]
    
    private let audioEngine: AVAudioEngine
    
    init(volume: Float = 0.5) {
        audioEngine = AVAudioEngine()
        let mainMixer = audioEngine.mainMixerNode
        let outputNode = audioEngine.outputNode
        let format = outputNode.inputFormat(forBus: 0)
        
        voice1 = Voice(format: format, signal: square)
        voice2 = Voice(format: format, signal: square)
        voice3 = Voice(format: format, signal: noise) // TODO: This will be a custom wave signal
        voice4 = Voice(format: format, signal: noise)
        voices = [voice1, voice2, voice3, voice4]

        let inputFormat = AVAudioFormat(commonFormat: format.commonFormat,
                                        sampleRate: format.sampleRate,
                                        channels: 1,
                                        interleaved: format.isInterleaved)
        
        audioEngine.attach(voice1.sourceNode)
        audioEngine.connect(voice1.sourceNode, to: mainMixer, format: inputFormat)
        
        audioEngine.attach(voice2.sourceNode)
        audioEngine.connect(voice2.sourceNode, to: mainMixer, format: inputFormat)
        
        audioEngine.attach(voice3.sourceNode)
        audioEngine.connect(voice3.sourceNode, to: mainMixer, format: inputFormat)
        
        audioEngine.attach(voice4.sourceNode)
        audioEngine.connect(voice4.sourceNode, to: mainMixer, format: inputFormat)
        
        audioEngine.connect(mainMixer, to: outputNode, format: nil)
        
        mainMixer.outputVolume = volume
    }
    
    func start() {
        do {
            if !audioEngine.isRunning {
                try audioEngine.start()
            }
        } catch {
            print("Could not start engine: \(error.localizedDescription)")
        }
    }
    
    func stop() {
        if audioEngine.isRunning {
            audioEngine.stop()
        }
    }
    
    func setLeftChannelVolume(_ val: Float) {
        for voice in voices {
            if voice.pan < 0 || voice.pan == 0 {
                voice.volume = val
            }
        }
    }
    
    func setRightChannelVolume(_ val: Float) {
        for voice in voices {
            if voice.pan > 0 || voice.pan == 0 {
                voice.volume = val
            }
        }
    }
}

public class APU {
    private let mmu: MMU
    private let synth: Synth
    
    init(_ mmu: MMU) {
        self.mmu = mmu
        self.synth = Synth()
        self.synth.volume = 0.00125
        // TODO: remove amplitude setters below
        self.synth.voice1.amplitude = 0
        self.synth.voice2.amplitude = 1
        self.synth.voice3.amplitude = 0
        self.synth.voice4.amplitude = 0
    }
    
    public func run(for time: Int16) throws {
        let nr52 = self.mmu.nr52.read()
        let nr51 = self.mmu.nr51.read()
        let nr50 = self.mmu.nr50.read()
        
        // Sound on or off
        if nr52.bit(7) {
            self.synth.start()
        } else {
            self.synth.stop()
        }
        
        var pan: Float = nr51.bit(2) ? 1 : 0
        pan = pan + (nr51.bit(5) ? -1 : 0)
        self.synth.voice2.pan = pan
        
        /*
        if nr51.bit(2) && nr51.bit(5) {
            self.synth.voice2.pan = 0
        } else if nr51.bit(2) {
            self.synth.voice2.pan = 1
        } else if nr51.bit(5) {
            self.synth.voice2.pan = -1
        } else {
            self.synth.voice2.volume = 0
        }
        */
        
        // Left and right channel volume
        let leftChannelVolume: Float = Float(nr50 & 0b00000111) / 7.0
        let rightChannelVolume: Float = Float((nr50 & 0b01110000) >> 4) / 7.0
        
        self.synth.setLeftChannelVolume(leftChannelVolume)
        self.synth.setRightChannelVolume(rightChannelVolume)
        
        // Left, right, center or no channel output
        
        
        /*
        rarely {
            print("nr51", nr51)
            print("on", nr52.bit(7))
            print("channelVolumes", leftChannelVolume, rightChannelVolume)
        }
        */
        
        /*
        if on {
            let channelControl = self.mmu.nr50.read()
            let panning = self.mmu.nr51.read()
            let onOff = self.mmu.nr52.read()
            // Determine period
            // Build waves
            // Run synth
        }
        */
    }
}
