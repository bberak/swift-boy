import Foundation
import AVFoundation

public typealias Signal = (_ frequency: Float, _ time: Float) -> Float

let twoPi = 2 * Float.pi

let sine: Signal = { freq, time in
    return sin(twoPi * freq * time)
}

let whiteNoise: Signal = { freq, time in
    return ((Float(arc4random_uniform(UINT32_MAX)) / Float(UINT32_MAX)) * 2 - 1)
}

let sawtoothUp: Signal = { freq, time in
    return 1.0 - 2.0 * (freq * time * (1.0 / twoPi))
}

let sawtoothDown: Signal = { freq, time in
    return (2.0 * (freq * time * (1.0 / twoPi))) - 1.0
}

let square: Signal = { freq, time in
    if (freq * time) <= Float.pi {
        return 1.0
    } else {
        return -1.0
    }
}

let triangle: Signal = { freq, time in
    var value = (2.0 * (freq * time * (1.0 / twoPi))) - 1.0
    if value < 0.0 {
        value = -value
    }
    return 2.0 * (value - 0.5)
}

class Voice {
    let sampleRate: Double
    let deltaTime: Float
    
    var frequency: Float = 440
    var time: Float = 0
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
            let sample = self.signal(self.frequency, self.time)
            self.time += self.deltaTime
            self.time = fmod(self.time, period) // This line ensures that 'time' corectly stays within the range of zero to 'period'
            
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
    
    private let audioEngine: AVAudioEngine
    
    init(signal: @escaping Signal = sine) {
        audioEngine = AVAudioEngine()
        let mainMixer = audioEngine.mainMixerNode
        let outputNode = audioEngine.outputNode
        let format = outputNode.inputFormat(forBus: 0)
        
        voice1 = Voice(format: format, signal: sine)
        voice2 = Voice(format: format, signal: triangle)
        voice3 = Voice(format: format, signal: sine)
        voice4 = Voice(format: format, signal: triangle)

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
        
        mainMixer.outputVolume = 0.5
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
        if voice1.pan < 0 {
            voice1.volume = val
        }
        
        if voice2.pan < 0 {
            voice2.volume = val
        }
        
        if voice3.pan < 0 {
            voice3.volume = val
        }
        
        if voice4.pan < 0 {
            voice4.volume = val
        }
    }
    
    func setRightChannelVolume(_ val: Float) {
        if voice1.pan > 0 {
            voice1.volume = val
        }
        
        if voice2.pan > 0 {
            voice2.volume = val
        }
        
        if voice3.pan > 0 {
            voice3.volume = val
        }
        
        if voice4.pan > 0 {
            voice4.volume = val
        }
    }
}

public class APU {
    private let mmu: MMU
    private let synth: Synth
        
    init(_ mmu: MMU) {
        self.mmu = mmu
        self.synth = Synth()
        self.synth.volume = 0.01
    }
    
    public func run(for time: Int16) throws {
        let nr52 = self.mmu.nr52.read()
        let nr51 = self.mmu.nr51.read()
        let nr50 = self.mmu.nr50.read()
        
        if nr52.bit(7) {
            self.synth.start()
        } else {
            self.synth.stop()
        }
        
        let leftChannelVolume: Float = Float(nr50 & 0b00000111) / 7.0
        let rightChannelVolume: Float = Float((nr50 & 0b01110000) >> 4) / 7.0
        
        self.synth.setLeftChannelVolume(leftChannelVolume)
        self.synth.setRightChannelVolume(rightChannelVolume)
        
        rarely {
            print("nr51", nr51)
            print("on", nr52.bit(7))
            print("channelVolumes", leftChannelVolume, rightChannelVolume)
        }
        
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
