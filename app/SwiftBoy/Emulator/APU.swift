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

class AmplitudeEnvelope: Oscillator {
    var inner: Oscillator
    
    init(_ inner: Oscillator) {
        self.inner = inner
    }
    
    func signal(_ frequency: Float, _ time: Float) -> Float {
        return inner.signal(frequency, time)
    }
}

class DurationEnvelope: Oscillator {
    var inner: Oscillator
    
    init(_ inner: Oscillator) {
        self.inner = inner
    }
    
    func signal(_ frequency: Float, _ time: Float) -> Float {
        return inner.signal(frequency, time)
    }
}

class Voice {
    private(set) var leftChannelOutput = true
    private(set) var rightChannelOutput = true

    let sampleRate: Double
    let deltaTime: Float
    
    var frequency: Float = 0
    var time: Float = 0
    var oscillator: Oscillator
    lazy var enabled = Observable<Bool>(false) { next, _ in
        if next {
            self.frequency = 0
            self.time = 0
            self.amplitudeEnvelopeElapsedTime = 0
            self.lengthEnvelopeElapsedTime = 0
            
            maybe {
                self.diagnose()
            }
        }
    }
    
    // TODO: Refactor these to use an envelope class (see above) and the maybe "time" from the AVSourceNode
    var amplitude: Float = 0
    var amplitudeEnvelopeElapsedTime: Float = 0
    lazy var amplitudeEnvelopeStartStep = Observable<Int>(0) { next, _ in
        self.amplitudeEnvelopeElapsedTime = 0
        self.amplitude = Float(next) / 0x0F
    }
    lazy var amplitudeEnvelopeIncreasing = Observable<Bool>(false) { _, _ in
        self.amplitudeEnvelopeElapsedTime = 0
    }
    lazy var amplitudeEnvelopeStepDuration = Observable<Float>(0) { _, _ in
        self.amplitudeEnvelopeElapsedTime = 0
    }
    
    // TODO: Refactor these to use an envelope class (see above) and the maybe "time" from the AVSourceNode
    var lengthEnvelopeElapsedTime: Float = 0
    var lengthEnvelopeSatisfied: Bool {
        get {
            if !lengthEnvelopeEnabled.value {
                return true // The length envelope is disabled, so the envelope conditions do no apply
            }
            
            if lengthEnvelopeElapsedTime < lengthEnvelopDuration.value {
                return true
            }
            
            return false
        }
    }
    lazy var lengthEnvelopeEnabled = Observable<Bool>(false) { _, _ in
        self.lengthEnvelopeElapsedTime = 0
    }
    lazy var lengthEnvelopDuration = Observable<Float>(0) { _, _ in
        self.lengthEnvelopeElapsedTime = 0
    }
    
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
    
    func diagnose() {
        print("----🔊-Diagnosis-Start-🔊----")
        print("enabled", enabled.value)
        print("leftChannelOutput", leftChannelOutput)
        print("rightChannelOutput", rightChannelOutput)
        print("sampleRate", sampleRate)
        print("deltaTime", deltaTime)
        print("frequency", frequency)
        print("time", time)
        print("amplitude", amplitude)
        print("amplitudeEnvelopeElapsedTime", amplitudeEnvelopeElapsedTime)
        print("amplitudeEnvelopeStartStep", amplitudeEnvelopeStartStep.value)
        print("amplitudeEnvelopeIncreasing", amplitudeEnvelopeIncreasing.value)
        print("amplitudeEnvelopeStepDuration", amplitudeEnvelopeStepDuration.value)
        print("lengthEnvelopeElapsedTime", lengthEnvelopeElapsedTime)
        print("lengthEnvelopeSatisfied", lengthEnvelopeSatisfied)
        print("lengthEnvelopeEnabled", lengthEnvelopeEnabled.value)
        print("lengthEnvelopDuration", lengthEnvelopDuration.value)
        print("volume", volume)
        print("pan", pan)
        print("----🔊-Diagnosis-Stop--🔊----")
    }
    
    lazy var sourceNode = AVAudioSourceNode { _, _, frameCount, audioBufferList in
        let ablPointer = UnsafeMutableAudioBufferListPointer(audioBufferList)
        let period = 1 / self.frequency

        for frame in 0..<Int(frameCount) {
            var sample: Float = 0
            
            if self.enabled.value && self.lengthEnvelopeSatisfied && (self.leftChannelOutput || self.rightChannelOutput) && self.amplitude > 0 {
                sample = self.oscillator.signal(self.frequency, self.time) * self.amplitude
                self.time += self.deltaTime
                self.time = fmod(self.time, period) // This line ensures that 'time' corectly stays within the range of zero and one 'period'
            }
            
            for buffer in ablPointer {
                let buf: UnsafeMutableBufferPointer<Float> = UnsafeMutableBufferPointer(buffer)
                buf[frame] = sample
            }
        }
                
        return noErr
    }
    
    init(format: AVAudioFormat, oscillator: Oscillator) {
        self.sampleRate = format.sampleRate
        self.deltaTime = 1 / Float(sampleRate)
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
    
    func advanceAmplitudeEnvelope(seconds: Float) {
        if !enabled.value {
            return
        }
        
        if amplitudeEnvelopeStepDuration.value == 0 {
            return
        }

        amplitudeEnvelopeElapsedTime += seconds
        let deltaSteps = Int(amplitudeEnvelopeElapsedTime / amplitudeEnvelopeStepDuration.value) * (amplitudeEnvelopeIncreasing.value ? 1 : -1)
        let currentStep = (amplitudeEnvelopeStartStep.value + deltaSteps).clamp(min: 0, max: 0x0F)
        
        amplitude = Float(currentStep) / 0x0F
    }
    
    func advanceLengthEnvelope(seconds: Float) -> Bool {
        // TODO: The return boolean indicates expiry.. Probably should be more explicit with the return type.
        
        if !enabled.value {
            return false
        }
        
        if !lengthEnvelopeEnabled.value {
            return false
        }
        
        if lengthEnvelopDuration.value == 0 {
            return false
        }
        
        if lengthEnvelopeElapsedTime < lengthEnvelopDuration.value {
            lengthEnvelopeElapsedTime += seconds
            
            if lengthEnvelopeElapsedTime > lengthEnvelopDuration.value {
                return true
            }
        }
        
        return false
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
        
        voice1 = Voice(format: format, oscillator: Pulse())
        voice2 = Voice(format: format, oscillator: Pulse())
        voice3 = Voice(format: format, oscillator: Noise()) // TODO: This will be a custom wave signal
        voice4 = Voice(format: format, oscillator: Noise())
        
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
    
    lazy var enabled = Observable<Bool>(audioEngine.isRunning) { next, prev in
        if next {
            do {
                try self.audioEngine.start()
            } catch {
                print("Could not start engine: \(error.localizedDescription)")
            }
        } else {
            self.audioEngine.stop()
        }
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

public class APU {
    private let mmu: MMU
    private let synth: Synth
    
    init(_ mmu: MMU) {
        self.mmu = mmu
        self.synth = Synth()
        self.synth.volume = 0.125 // TODO: What's a good default here? 🤔
        
        // TODO: Remove temporary statements below
        self.synth.voice1.enabled.value = false
        self.synth.voice3.enabled.value = false
        self.synth.voice4.enabled.value = false
    }
    
    public func run(for time: Int16) throws {
        let seconds = Float(time) / 4000000
        
        // Master sound output
        var nr52 = self.mmu.nr52.read()
        let masterEnabledTx = self.synth.enabled.setValue(nr52.bit(7))
        
        if !masterEnabledTx.next && masterEnabledTx.prev {
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
        } else if !masterEnabledTx.next {
            // Exit early
            return
        }
        
        // Master controls
        let nr51 = self.mmu.nr51.read()
        let nr50 = self.mmu.nr50.read()
        
        // Left or right channel output
        self.synth.voice1.setChannels(left: nr51.bit(4), right: nr51.bit(0))
        self.synth.voice2.setChannels(left: nr51.bit(5), right: nr51.bit(1))
        self.synth.voice3.setChannels(left: nr51.bit(6), right: nr51.bit(2))
        self.synth.voice4.setChannels(left: nr51.bit(7), right: nr51.bit(3))
        
        // Left and right channel master volume
        let leftChannelVolume: Float = Float(nr50 & 0b00000111) / 7.0
        let rightChannelVolume: Float = Float((nr50 & 0b01110000) >> 4) / 7.0
        
        self.synth.setLeftChannelVolume(leftChannelVolume)
        self.synth.setRightChannelVolume(rightChannelVolume)
        
        // Voice specific controls
        let nr24 = self.mmu.nr24.read()
        let nr23 = self.mmu.nr23.read()
        let nr22 = self.mmu.nr22.read()
        let nr21 = self.mmu.nr21.read()
        
        synth.voice2.frequency = 131072 / (2048 - Float(UInt16(nr23) + (UInt16(nr24 & 0b00000111) << 8)))
        synth.voice2.amplitudeEnvelopeStartStep.value = Int((nr22 & 0b11110000) >> 4)
        synth.voice2.amplitudeEnvelopeIncreasing.value = nr22.bit(3)
        synth.voice2.amplitudeEnvelopeStepDuration.value = Float(nr22 & 0b00000111) * 1 / 64
        synth.voice2.advanceAmplitudeEnvelope(seconds: seconds)
        
        if let pulse = synth.voice2.oscillator as? Pulse {
            switch(nr21 & 0b11000000) {
            case 0b00000000: pulse.duty = 0.125
            case 0b01000000: pulse.duty = 0.25
            case 0b10000000: pulse.duty = 0.5
            case 0b11000000: pulse.duty = 0.75
            default: print("Duty pattern not handled for voice2")
            }
        }
        
        synth.voice2.lengthEnvelopeEnabled.value = nr24.bit(6)
        synth.voice2.lengthEnvelopDuration.value = (64 - Float(nr21 & 0b00111111)) * (1 / 256)
        let voice2LengthExpired = synth.voice2.advanceLengthEnvelope(seconds: seconds)
        let voice2EnabledTx = synth.voice2.enabled.setValue(nr24.bit(7))
        
        if voice2EnabledTx.next && !voice2EnabledTx.prev {
            nr52 = nr52.set(1)
        }els if voice2LengthExpired {
            nr52 = nr52.reset(1)
        }
        
        self.mmu.nr52.write(nr52)
    }
}
