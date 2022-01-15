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

// Source: https://github.com/GrantJEmerson/SwiftSynth/blob/master/Swift%20Synth/Audio/Synth.swift
public class Synth {
    public static let shared = Synth()
    
    public var volume: Float {
        set {
            audioEngine.mainMixerNode.outputVolume = newValue
        }
        get {
            audioEngine.mainMixerNode.outputVolume
        }
    }
    
    public var frequencyRampValue: Float = 0
    
    public var frequency: Float = 440 {
        didSet {
            if oldValue != 0 {
                frequencyRampValue = frequency - oldValue
            } else {
                frequencyRampValue = 0
            }
        }
    }

    private var audioEngine: AVAudioEngine
    private lazy var sourceNode = AVAudioSourceNode { _, _, frameCount, audioBufferList in
        let ablPointer = UnsafeMutableAudioBufferListPointer(audioBufferList)
                
        let localRampValue = self.frequencyRampValue
        let localFrequency = self.frequency - localRampValue
        
        let period = 1 / localFrequency

        for frame in 0..<Int(frameCount) {
            let percentComplete = self.time / period
            let sampleVal = self.signal(localFrequency + localRampValue * percentComplete, self.time)
            self.time += self.deltaTime
            self.time = fmod(self.time, period)
            
            for buffer in ablPointer {
                let buf: UnsafeMutableBufferPointer<Float> = UnsafeMutableBufferPointer(buffer)
                buf[frame] = sampleVal
            }
        }
        
        self.frequencyRampValue = 0
        
        return noErr
    }
    
    private var time: Float = 0
    private let sampleRate: Double
    private let deltaTime: Float
    
    private var signal: Signal
    
    init(signal: @escaping Signal = sine) {
        audioEngine = AVAudioEngine()
        
        let mainMixer = audioEngine.mainMixerNode
        let outputNode = audioEngine.outputNode
        let format = outputNode.inputFormat(forBus: 0)

        sampleRate = format.sampleRate
        deltaTime = 1 / Float(sampleRate)
        
        self.signal = signal
        
        let inputFormat = AVAudioFormat(commonFormat: format.commonFormat,
                                        sampleRate: format.sampleRate,
                                        channels: 1,
                                        interleaved: format.isInterleaved)
        
        audioEngine.attach(sourceNode)
        audioEngine.connect(sourceNode, to: mainMixer, format: inputFormat)
        audioEngine.connect(mainMixer, to: outputNode, format: nil)
        mainMixer.outputVolume = 0
        
        do {
            try audioEngine.start()
        } catch {
            print("Could not start engine: \(error.localizedDescription)")
        }
    }
        
    public func setWaveformTo(_ signal: @escaping Signal) {
        self.signal = signal
    }
}

struct Voice {
    var control: UInt8 = 0
    var freq: UInt8 = 0
    var volume: UInt8 = 0
    var length: UInt8 = 0
    var sweep: UInt8 = 0
}

public class APU {
    private let mmu: MMU
    
    private var pulseA = Voice()
    private var pulseB = Voice()
    private var wave = Voice()
    private var noise = Voice()
    
    private var channelControl: UInt8 = 0
    private var panning: UInt8 = 0
    private var on = false
    
    init(mmu: MMU) {
        self.mmu = mmu
        
        self.mmu.subscribe({ address, _ in address.isBetween(0xFF10, 0xFF3F) }) { address, byte in
            
        }
    }
}
