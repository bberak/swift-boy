import Foundation
import AVFoundation

protocol Oscillator {
    func signal(_ frequency: Float, _ time: Float) -> Float
}

class Pulse: Oscillator {
    var duty: Float = 0.5
    
    func signal(_ frequency: Float, _ time: Float) -> Float {
        if (frequency * time) <= duty {
            return 1.0
        } else {
            return -1.0
        }
    }
}

class Noise: Oscillator {
    func signal(_ frequency: Float, _ time: Float) -> Float {
        return ((Float(arc4random_uniform(UINT32_MAX)) / Float(UINT32_MAX)) * 2 - 1)
    }
}

enum EnvelopeStatus {
    case active
    case deactivated
    case notApplicable
}

protocol Envelope: Oscillator {
    func advance(seconds: Float) -> EnvelopeStatus
    func restart() -> Void
}

class AmplitudeEnvelope: Envelope {
    private let inner: Oscillator
    private var elapsedTime: Float = 0
    private var amplitude: Float = 0
    
    var startStep: Int = 0 {
        didSet {
            if startStep != oldValue {
                restart()
            }
        }
    }
    
    var increasing = false {
        didSet {
            if increasing != oldValue {
                restart()
            }
        }
    }
    
    var stepDuration: Float = 0 {
        didSet {
            if stepDuration != oldValue {
                restart()
            }
        }
    }
    
    init(_ inner: Oscillator) {
        self.inner = inner
    }
    
    func signal(_ frequency: Float, _ time: Float) -> Float {
        return inner.signal(frequency, time) * amplitude
    }
    
    @discardableResult func advance(seconds: Float) -> EnvelopeStatus {
        if stepDuration == 0 {
            return .notApplicable
        }
        
        elapsedTime += seconds
          
        let deltaSteps = Int(elapsedTime / stepDuration) * (increasing ? 1 : -1)
        let currentStep = (startStep + deltaSteps).clamp(min: 0, max: 0x0F)
        
        amplitude = Float(currentStep) / 0x0F
        
        return .notApplicable
    }
    
    func restart() {
        elapsedTime = 0
        amplitude = Float(startStep) / 0x0F
    }
}

class LengthEnvelope: Envelope {
    private var inner: Oscillator
    private var elapsedTime: Float = 0
    
    var enabled = false {
        didSet {
            if enabled != oldValue {
                restart()
            }
        }
    }
    
    var duration: Float = 0 {
        didSet {
            if duration != oldValue {
                restart()
            }
        }
    }
    
    init(_ inner: Oscillator) {
        self.inner = inner
    }
    
    func signal(_ frequency: Float, _ time: Float) -> Float {
        if enabled {
            return elapsedTime < duration ? inner.signal(frequency, time) : 0
        } else {
            return inner.signal(frequency, time)
        }
    }
    
    func advance(seconds: Float) -> EnvelopeStatus {
        if !enabled {
            return .notApplicable
        }
        
        if duration == 0 {
            return .notApplicable
        }
        
        if elapsedTime < duration {
            elapsedTime += seconds
            
            return .active
        }
        
        return .deactivated
    }
    
    func restart() {
        elapsedTime = 0
    }
}

class Voice {
    private(set) var leftChannelOutput = true
    private(set) var rightChannelOutput = true
    
    var sampleRate: Float = 44100
    var frequency: Float = 0 // TODO: I think frequency needs to be interpolated/eased to avoid pops and clicks?
    var time: Float = 0
    var oscillator: Oscillator
    var enabled = false
        
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
        let deltaTime = 1 / self.sampleRate
        
        for frame in 0..<Int(frameCount) {
            var sample: Float = 0
            
            if self.enabled && (self.leftChannelOutput || self.rightChannelOutput) {
                sample = self.oscillator.signal(self.frequency, self.time)
                self.time += deltaTime
                self.time = fmod(self.time, period) // This line ensures that 'time' corectly stays within the range of zero and one 'period'
            }
            
            for buffer in ablPointer {
                let buf: UnsafeMutableBufferPointer<Float> = UnsafeMutableBufferPointer(buffer)
                buf[frame] = sample
            }
        }
                
        return noErr
    }
    
    init(oscillator: Oscillator) {
        self.oscillator = oscillator
    }
    
    func setChannels(left: Bool, right: Bool) {
        if left && right {
            pan = 0
        } else if left {
            pan = -1
        } else if right {
            pan = 1
        }
        
        self.leftChannelOutput = left
        self.rightChannelOutput = right
    }
}

// Source: https://github.com/GrantJEmerson/SwiftSynth/blob/master/Swift%20Synth/Audio/Synth.swift
class Synth {
    let voices: [Voice]
    let audioEngine: AVAudioEngine
    
    public var volume: Float {
        get {
            audioEngine.mainMixerNode.outputVolume
        }
        set {
            audioEngine.mainMixerNode.outputVolume = newValue
        }
    }
    
    var enabled = false {
        didSet {
            if enabled && !audioEngine.isRunning {
                do {
                    try self.audioEngine.start()
                } catch {
                    print("Could not start engine: \(error.localizedDescription)")
                }
            }
            
            if !enabled && audioEngine.isRunning {
                self.audioEngine.stop()
            }
        }
    }
    
    init(volume: Float = 0.5, voices: [Voice]) {
        self.voices = voices
        self.audioEngine = AVAudioEngine()
        
        let mainMixer = audioEngine.mainMixerNode
        let outputNode = audioEngine.outputNode
        let format = outputNode.inputFormat(forBus: 0)
        let inputFormat = AVAudioFormat(commonFormat: format.commonFormat,
                                        sampleRate: format.sampleRate,
                                        channels: 1,
                                        interleaved: format.isInterleaved)
        
        for voice in voices {
            voice.sampleRate = Float(format.sampleRate)
            audioEngine.attach(voice.sourceNode)
            audioEngine.connect(voice.sourceNode, to: mainMixer, format: inputFormat)
        }
                
        audioEngine.connect(mainMixer, to: outputNode, format: nil)
        
        mainMixer.outputVolume = volume
    }
    
    func setLeftChannelVolume(_ val: Float) {
        for voice in voices {
            if voice.leftChannelOutput {
                voice.volume = val
            }
        }
    }
    
    func setRightChannelVolume(_ val: Float) {
        for voice in voices {
            if voice.rightChannelOutput {
                voice.volume = val
            }
        }
    }
}

class PulseB: Voice {
    let signal: Pulse
    let amplitudeEnvelope: AmplitudeEnvelope
    let lengthEnvelope: LengthEnvelope
    
    override var enabled: Bool {
        didSet {
            if enabled && !oldValue {
                amplitudeEnvelope.restart()
                lengthEnvelope.restart()
            }
        }
    }
    
    init() {
        self.signal = Pulse()
        self.amplitudeEnvelope = AmplitudeEnvelope(self.signal)
        self.lengthEnvelope = LengthEnvelope(self.amplitudeEnvelope)
        
        super.init(oscillator: self.lengthEnvelope)
    }
}

class PulseA: PulseB {
    // TODO: Need to add sweep functionality
}

public class APU {
    private let mmu: MMU
    private let master: Synth
    private let pulseA: PulseA
    private let pulseB: PulseB
    
    init(_ mmu: MMU) {
        self.mmu = mmu
        self.pulseA = PulseA()
        self.pulseB = PulseB()
        self.master = Synth(voices: [self.pulseA, self.pulseB])
        self.master.volume = 0.125 // TODO: What's a good default here? 🤔
    }
    
    func playPulseA(seconds: Float) -> Bool {
        var playing = true
        
        let nr14 = self.mmu.nr14.read()
        let nr13 = self.mmu.nr13.read()
        let nr12 = self.mmu.nr12.read()
        let nr11 = self.mmu.nr11.read()
        _ = self.mmu.nr10.read()
        
        self.pulseA.frequency = 131072 / (2048 - Float(UInt16(nr13) + (UInt16(nr14 & 0b00000111) << 8)))
        
        self.pulseA.amplitudeEnvelope.startStep = Int((nr12 & 0b11110000) >> 4)
        self.pulseA.amplitudeEnvelope.stepDuration = Float(nr12 & 0b00000111) * 1 / 64
        self.pulseA.amplitudeEnvelope.increasing = nr12.bit(3)
        self.pulseA.amplitudeEnvelope.advance(seconds: seconds)
        
        self.pulseA.lengthEnvelope.enabled = nr14.bit(6)
        self.pulseA.lengthEnvelope.duration = (64 - Float(nr11 & 0b00111111)) * (1 / 256)
        let pulseALengthStatus = self.pulseA.lengthEnvelope.advance(seconds: seconds)
        
        if pulseALengthStatus == .deactivated {
           playing = false
       }
        
        switch(nr11 & 0b11000000) {
        case 0b00000000: self.pulseA.signal.duty = 0.125
        case 0b01000000: self.pulseA.signal.duty = 0.25
        case 0b10000000: self.pulseA.signal.duty = 0.5
        case 0b11000000: self.pulseA.signal.duty = 0.75
        default: print("Duty pattern not handled for PulseA")
        }
        
        let pulseAEnabledPrev = self.pulseA.enabled
        let pulseAEnabledNext = nr14.bit(7)
        
        self.pulseA.enabled = pulseAEnabledNext
        
        if pulseAEnabledNext && !pulseAEnabledPrev {
            playing = true
        }
        
        return playing
    }
    
    func playPulseB(seconds: Float) -> Bool {
        var playing = true
        
        let nr24 = self.mmu.nr24.read()
        let nr23 = self.mmu.nr23.read()
        let nr22 = self.mmu.nr22.read()
        let nr21 = self.mmu.nr21.read()
        
        self.pulseB.frequency = 131072 / (2048 - Float(UInt16(nr23) + (UInt16(nr24 & 0b00000111) << 8)))
        
        self.pulseB.amplitudeEnvelope.startStep = Int((nr22 & 0b11110000) >> 4)
        self.pulseB.amplitudeEnvelope.stepDuration = Float(nr22 & 0b00000111) * 1 / 64
        self.pulseB.amplitudeEnvelope.increasing = nr22.bit(3)
        self.pulseB.amplitudeEnvelope.advance(seconds: seconds)
        
        self.pulseB.lengthEnvelope.enabled = nr24.bit(6)
        self.pulseB.lengthEnvelope.duration = (64 - Float(nr21 & 0b00111111)) * (1 / 256)
        let pulseBLengthStatus = self.pulseB.lengthEnvelope.advance(seconds: seconds)
        
        if pulseBLengthStatus == .deactivated {
           playing = false
       }
        
        switch(nr21 & 0b11000000) {
        case 0b00000000: self.pulseB.signal.duty = 0.125
        case 0b01000000: self.pulseB.signal.duty = 0.25
        case 0b10000000: self.pulseB.signal.duty = 0.5
        case 0b11000000: self.pulseB.signal.duty = 0.75
        default: print("Duty pattern not handled for PulseB")
        }
        
        let pulseBEnabledPrev = self.pulseB.enabled
        let pulseBEnabledNext = nr24.bit(7)
        
        self.pulseB.enabled = pulseBEnabledNext
        
        if pulseBEnabledNext && !pulseBEnabledPrev {
            playing = true
        }
        
        return playing
    }
    
    func playWave(seconds: Float) -> Bool {
        return false
    }
    
    func playNoise(seconds: Float) -> Bool {
        return false
    }
    
    public func run(for time: Int16) throws {
        let seconds = Float(time) / 4000000
        
        // Master sound registers
        var nr52 = self.mmu.nr52.read()
        let nr51 = self.mmu.nr51.read()
        let nr50 = self.mmu.nr50.read()
        
        // Master sound output
        let masterEnabledPrev = self.master.enabled
        let masterEnabledNext = nr52.bit(7)
        
        self.master.enabled = masterEnabledNext
        
        if !masterEnabledNext && masterEnabledPrev {
            // Clear all registers except
            self.mmu.nr10.write(0)
            self.mmu.nr11.write(0)
            self.mmu.nr12.write(0)
            self.mmu.nr13.write(0)
            self.mmu.nr14.write(0)
            self.mmu.nr21.write(0)
            self.mmu.nr22.write(0)
            self.mmu.nr23.write(0)
            self.mmu.nr24.write(0)
            self.mmu.nr30.write(0)
            self.mmu.nr31.write(0)
            self.mmu.nr32.write(0)
            self.mmu.nr33.write(0)
            self.mmu.nr34.write(0)
            self.mmu.nr41.write(0)
            self.mmu.nr42.write(0)
            self.mmu.nr43.write(0)
            self.mmu.nr44.write(0)
            self.mmu.nr50.write(0)
            self.mmu.nr51.write(0)
            self.mmu.nr52.write(0)
        } else if !masterEnabledNext  {
            // Exit early
            return
        }
        
        // Left or right channel output
        self.pulseA.setChannels(left: nr51.bit(4), right: nr51.bit(0))
        self.pulseB.setChannels(left: nr51.bit(5), right: nr51.bit(1))
        
        // Left and right channel master volume
        let leftChannelVolume: Float = Float(nr50 & 0b00000111) / 7.0
        let rightChannelVolume: Float = Float((nr50 & 0b01110000) >> 4) / 7.0
        
        self.master.setLeftChannelVolume(leftChannelVolume)
        self.master.setRightChannelVolume(rightChannelVolume)
        
        // Voice specific controls
        nr52[0] = playPulseA(seconds: seconds)
        nr52[1] = playPulseB(seconds: seconds)
        nr52[2] = playWave(seconds: seconds)
        nr52[3] = playNoise(seconds: seconds)
        
        self.mmu.nr52.write(nr52)
    }
}
