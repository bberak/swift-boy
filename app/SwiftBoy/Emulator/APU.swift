// TODO: Figure out a good default for master volume 🤔
// TODO: I think frequency needs to be interpolated/eased to avoid pops and clicks (see FrequencyRampEnvelope class)
// TODO: I think amplitude needs to be interpolated/eased to avoid pops and clicks
// TODO: Should sample returned from AmplitudeEnvelope be lerped between -1 an 1?
// TODO: I think there is something wrong with PulseA's envelopes. I'm pretty sure it should be playing the Nintento ping during boot - but it doesn't. Check the amplitude envelope.
// TODO: Frequency sweep doesn't seem to be working at all
// TODO: Still experiencing the weird pops and clicks when changing music tracks on Tetris
// TODO: Get rid of unecessary 'self' references? Or at least be consisten!

import Foundation
import AudioKit
import SoundpipeAudioKit

func bitsToFrequency(bits: UInt16) -> Float {
    return 131072 / (2048 - Float(bits))
}

func frequencyToBits(frequency: Float) -> UInt16 {
    return UInt16(2048 - (131072 / frequency))
}

//protocol Oscillator: AnyObject {
//    func signal(_ frequency: Float, _ time: Float) -> Float
//}
//

class Square {
    var duty: Float = 0.5

    func signal(_ frequency: Float, _ time: Float) -> Float {
        if (frequency * time) <= duty {
            return 1.0
        } else {
            return -1.0
        }
    }
}

//
//class Noise: Oscillator {
//    func signal(_ frequency: Float, _ time: Float) -> Float {
//        return ((Float(arc4random_uniform(UINT32_MAX)) / Float(UINT32_MAX)) * 2 - 1)
//    }
//}

enum EnvelopeStatus {
    case active
    case deactivated
    case notApplicable
}

protocol Envelope {
    var inner: Node? { get set }
    func advance(seconds: Float) -> EnvelopeStatus
    func restart() -> Void
}

class AmplitudeEnvelope: Envelope {
    private var elapsedTime: Float = 0
    private var amplitude: Float = 0
    
    var inner: Node?
    
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
    
    init(_ inner: Oscillator? = nil) {
        self.inner = inner
    }
    
//    func signal(_ frequency: Float, _ time: Float) -> Float {
//        return (inner?.signal(frequency, time) ?? 0) * amplitude
//    }
    
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
    private var elapsedTime: Float = 0
    
    var inner: Node?
    
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
    
    init(_ inner: Oscillator? = nil) {
        self.inner = inner
    }
    
//    func signal(_ frequency: Float, _ time: Float) -> Float {
//        if enabled {
//            return elapsedTime < duration ? inner?.signal(frequency, time) ?? 0 : 0
//        } else {
//            return inner?.signal(frequency, time) ?? 0
//        }
//    }
    
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

class FrequencyRampEnvelope {
    var inner: Node?
    var frequencyRamped: Float = 0
    var rampFactor: Float = 0.01
    
    init(_ inner: Oscillator? = nil) {
        self.inner = inner
    }
    
//    func signal(_ frequency: Float, _ time: Float) -> Float {
//        frequencyRamped = frequencyRamped + (frequency - frequencyRamped) * rampFactor
//
//        return inner?.signal(frequencyRamped, time) ?? 0
//    }
    
    @discardableResult func advance(seconds: Float) -> EnvelopeStatus {
        return .notApplicable
    }
    
    func restart() { }
}

class FrequencySweepEnvelope: Envelope {
    private var elapsedTime: Float = 0
    
    private var adjustedFrequency: Float = 0
    
    private var startFrequency: Float = 0 {
        didSet {
            if startFrequency != oldValue {
                restart()
            }
        }
    }
    
    var inner: Node?
    
    var sweepIncreasing = false {
        didSet {
            if sweepIncreasing != oldValue {
                restart()
            }
        }
    }
    
    var sweepShifts: UInt8 = 0 {
        didSet {
            if sweepShifts != oldValue {
                restart()
            }
        }
    }
    
    var sweepTime: Float = 0 {
        didSet {
            if  sweepTime != oldValue {
                restart()
            }
        }
    }
    
    init(_ inner: Oscillator? = nil) {
        self.inner = inner
    }
    
//    func signal(_ frequency: Float, _ time: Float) -> Float {
//        startFrequency = frequency
//
//        return inner?.signal(adjustedFrequency, time) ?? 0
//    }
    
    @discardableResult func advance(seconds: Float) -> EnvelopeStatus {
        if startFrequency == 0 {
            restart()
            return .notApplicable
        }
        
        if sweepTime == 0 {
            restart()
            return .notApplicable
        }
        
        if sweepShifts == 0 {
            restart()
            return .notApplicable
        }
        
        elapsedTime += seconds
        
        let sweeps = Int(elapsedTime / sweepTime)
        let totalShifts = sweeps > 0 ? sweeps * Int(sweepShifts) : 0
        let shiftedValue = sweepIncreasing ? frequencyToBits(frequency: startFrequency) << totalShifts : frequencyToBits(frequency: startFrequency) >> totalShifts
        
        if shiftedValue == 0 {
            return .deactivated
        }
        
        if shiftedValue > 2047 {
            return .deactivated
        }
        
        adjustedFrequency = bitsToFrequency(bits: shiftedValue)
        
        return .active
    }
    
    func restart() {
        elapsedTime = 0
        adjustedFrequency = startFrequency
    }
}

class Voice {
    private(set) var oscillator: Oscillator
    private(set) var panner: Panner
    private(set) var leftChannelOn = true
    private(set) var rightChannelOn = true
    private var targetVolume: Float = 0
    
    var frequency: Float {
        get { oscillator.frequency }
        set {
            oscillator.$frequency.ramp(to: newValue, duration: 0.01)
        }
    }
    
    var volume: Float {
        get {
            oscillator.amplitude
        }
        set {
            oscillator.$amplitude.ramp(to: newValue, duration: 0.01)
            targetVolume = newValue
        }
    }
    
    var pan: Float {
        get {
            return panner.pan
        }
        set {
            panner.$pan.ramp(to: newValue, duration: 0.01)
        }
    }
    
    var enabled: Bool = false {
        didSet {
            if enabled {
                oscillator.amplitude = targetVolume
            }
            
            if !enabled {
                oscillator.amplitude = 0
            }
        }
    }
    
    init(oscillator: Oscillator) {
        self.oscillator = oscillator
        self.oscillator.start()
        self.panner = Panner(oscillator)
    }
    
    func setChannels(left: Bool, right: Bool) {
        if left && right {
            pan = 0
        } else if left {
            pan = -1
        } else if right {
            pan = 1
        }
        
        if !left && !right {
            oscillator.amplitude = 0
        } else {
            oscillator.amplitude = targetVolume
        }
        
        leftChannelOn = left
        rightChannelOn = right
    }
}

class Pulse: Voice {
    let wave: Square
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
        wave = Square()
        amplitudeEnvelope = AmplitudeEnvelope()
        lengthEnvelope = LengthEnvelope()
        
//        amplitudeEnvelope.inner = wave
//        lengthEnvelope.inner = amplitudeEnvelope
        
        super.init(oscillator: Oscillator(waveform: Table(.square)))
    }
}

class PulseWithSweep: Voice {
    let wave: Square
    let amplitudeEnvelope: AmplitudeEnvelope
    let lengthEnvelope: LengthEnvelope
    let frequencySweepEnvelope: FrequencySweepEnvelope
    
    override var enabled: Bool {
        didSet {
            if enabled && !oldValue {
                amplitudeEnvelope.restart()
                lengthEnvelope.restart()
                frequencySweepEnvelope.restart()
            }
        }
    }
    
    init() {
        wave = Square()
        amplitudeEnvelope = AmplitudeEnvelope()
        lengthEnvelope = LengthEnvelope()
        frequencySweepEnvelope = FrequencySweepEnvelope()
        
//        amplitudeEnvelope.inner = wave
//        lengthEnvelope.inner = amplitudeEnvelope
//        frequencySweepEnvelope.inner = lengthEnvelope
        
        super.init(oscillator: Oscillator(waveform: Table(.square)))
    }
}

// Source: https://github.com/GrantJEmerson/SwiftSynth/blob/master/Swift%20Synth/Audio/Synth.swift
class Synthesizer {
    let voices: [Voice]
    let engine: AudioEngine
    let mixer: Mixer
    
    public var volume: Float {
        get {
            engine.mainMixerNode?.volume ?? 0
        }
        set {
            engine.mainMixerNode?.volume  = newValue
        }
    }
    
    var enabled = false {
        didSet {
            if enabled && !engine.avEngine.isRunning {
                try? self.engine.start()
            }
            
            if !enabled && engine.avEngine.isRunning {
                self.engine.stop()
            }
        }
    }
    
    init(volume: Float = 0.5, voices: [Voice]) {
        self.voices = voices
        self.mixer = Mixer(voices.map({ $0.panner }))
        self.engine = AudioEngine()
        self.engine.output = mixer
        self.engine.mainMixerNode?.volume = volume
    }
    
    func setLeftChannelVolume(_ val: Float) {
        for voice in voices {
            if voice.leftChannelOn {
                voice.volume = val
            }
        }
    }
    
    func setRightChannelVolume(_ val: Float) {
        for voice in voices {
            if voice.rightChannelOn {
                voice.volume = val
            }
        }
    }
}

public class APU {
    private let mmu: MMU
    private let master: Synthesizer
    private let pulseA: PulseWithSweep
    private let pulseB: Pulse
    
    init(_ mmu: MMU) {
        self.mmu = mmu
        self.pulseA = PulseWithSweep()
        self.pulseB = Pulse()
        self.master = Synthesizer(voices: [self.pulseA, self.pulseB])
        self.master.volume = 0.125
    }
    
    func playPulseA(seconds: Float) -> Bool {
        var playing = true
        
        let nr14 = self.mmu.nr14.read()
        let nr13 = self.mmu.nr13.read()
        let nr12 = self.mmu.nr12.read()
        let nr11 = self.mmu.nr11.read()
        let nr10 = self.mmu.nr10.read()
        
        self.pulseA.frequencySweepEnvelope.sweepShifts = nr10 & 0b00000111
        self.pulseA.frequencySweepEnvelope.sweepIncreasing = nr10.bit(3)
        
        switch ((nr10 & 0b01110000) >> 4) {
        case 0b000: self.pulseA.frequencySweepEnvelope.sweepTime = 0
        case 0b001: self.pulseA.frequencySweepEnvelope.sweepTime = 0.0078
        case 0b010: self.pulseA.frequencySweepEnvelope.sweepTime = 0.0156
        case 0b011: self.pulseA.frequencySweepEnvelope.sweepTime = 0.0234
        case 0b100: self.pulseA.frequencySweepEnvelope.sweepTime = 0.0313
        case 0b101: self.pulseA.frequencySweepEnvelope.sweepTime = 0.0391
        case 0b110: self.pulseA.frequencySweepEnvelope.sweepTime = 0.0469
        case 0b111: self.pulseA.frequencySweepEnvelope.sweepTime = 0.0547
        default: print("Sweep time not handled for PulseA")
        }
        
        let pulseASweetStatus = self.pulseA.frequencySweepEnvelope.advance(seconds: seconds)
        
        if pulseASweetStatus == .deactivated {
            playing = false
        }
        
        self.pulseA.frequency = bitsToFrequency(bits: UInt16(nr13) + (UInt16(nr14 & 0b00000111) << 8))
        
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
        
        switch (nr11 & 0b11000000) {
        case 0b00000000: self.pulseA.wave.duty = 0.125
        case 0b01000000: self.pulseA.wave.duty = 0.25
        case 0b10000000: self.pulseA.wave.duty = 0.5
        case 0b11000000: self.pulseA.wave.duty = 0.75
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
        
        self.pulseB.frequency = bitsToFrequency(bits: UInt16(nr23) + (UInt16(nr24 & 0b00000111) << 8))
        
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
        case 0b00000000: self.pulseB.wave.duty = 0.125
        case 0b01000000: self.pulseB.wave.duty = 0.25
        case 0b10000000: self.pulseB.wave.duty = 0.5
        case 0b11000000: self.pulseB.wave.duty = 0.75
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
