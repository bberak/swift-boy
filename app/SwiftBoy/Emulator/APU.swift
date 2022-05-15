// TODO: Figure out a good default for master volume 🤔
// TODO: Startup sound is not working
// TODO: Super Mario sounds/music is not working
// TODO: Tetris main menu and Type-B music is not sounding correct
// TODO: Now that I've moved to a subscription-based model, I can remove some of the value != oldValue checks..

import Foundation
import AudioKit
import SoundpipeAudioKit

typealias AKAmplitudeEnvelope = SoundpipeAudioKit.AmplitudeEnvelope

func bitsToFrequency(bits: UInt16) -> Float {
    return 131072 / (2048 - Float(bits))
}

func frequencyToBits(frequency: Float) -> UInt16 {
    if frequency == 0 {
        return 0
    }
        
    return UInt16(2048 - (131072 / frequency))
}

func convertToSweepTime(byte: UInt8) -> Float {
    switch (byte) {
    case 0b000: return 0
    case 0b001: return 0.0078
    case 0b010: return 0.0156
    case 0b011: return 0.0234
    case 0b100: return 0.0313
    case 0b101: return 0.0391
    case 0b110: return 0.0469
    case 0b111: return 0.0547
    default: return -1
    }
}

func convertToPulseWidth(byte: UInt8) -> Float {
    switch (byte) {
    case 0b00000000: return 0.125
    case 0b01000000: return 0.25
    case 0b10000000: return 0.5
    case 0b11000000: return 0.75
    default: return -1
    }
}

protocol OscillatorNode: Node {
    var frequency: Float { get set }
    var amplitude: Float { get set }
    func rampFrequency(to: Float, duration: Float)
    func rampAmplitude(to: Float, duration: Float)
}

protocol Envelope: AnyObject  {
    var voice: Voice? { get set }
    func update(seconds: Float) -> Void
    func onTriggered() -> Void
}

class Voice {
    let oscillator: OscillatorNode
    let envelopes: [Envelope]
    
    var dacEnabled: Bool = true
    var enabled: Bool = true
    var amplitude: Float = 0
    var frequency: Float = 0
    
    var triggered: Bool = false {
        didSet {
            onTriggered()
        }
    }
    
    init(oscillator: OscillatorNode, envelopes: [Envelope]) {
        self.oscillator = oscillator
        self.oscillator.start()
        self.oscillator.amplitude = 0
        self.oscillator.frequency = 0
        self.envelopes = envelopes
        self.envelopes.forEach { $0.voice = self }
    }
    
    func onTriggered() {
        enabled = true
        envelopes.forEach { $0.onTriggered() }
    }
    
    func update(seconds: Float) -> Bool {
        envelopes.forEach { $0.update(seconds: seconds) }
        
        oscillator.rampFrequency(to: frequency, duration: 0.01)
        
        if !dacEnabled {
            oscillator.rampAmplitude(to: 0, duration: 0.01)
        } else if !enabled {
            oscillator.rampAmplitude(to: 0, duration: 0.01)
        } else {
            oscillator.rampAmplitude(to: amplitude, duration: 0.01)
        }
        
        return dacEnabled && enabled
    }
}

class Synthesizer {
    let engine: AudioEngine
    let channelsLeft: [AKAmplitudeEnvelope]
    let channelsRight: [AKAmplitudeEnvelope]
    let mixerLeft: Mixer
    let mixerRight: Mixer
    let mixerMain: Mixer
    
    public var volume: Float {
        get {
            self.mixerMain.volume
        }
        set {
            self.mixerMain.volume = newValue
        }
    }
    
    var enabled = false {
        didSet {
            if enabled && !engine.avEngine.isRunning {
                try? self.engine.start()
            }
            
            if !enabled && engine.avEngine.isRunning {
                self.engine.pause()
            }
        }
    }
    
    init(volume: Float = 0.5, voices: [Voice]) {
        self.channelsLeft = voices.map { AKAmplitudeEnvelope($0.oscillator) }
        self.channelsLeft.forEach { $0.openGate() }
        self.channelsRight = voices.map { AKAmplitudeEnvelope($0.oscillator) }
        self.channelsRight.forEach { $0.openGate() }
        self.mixerLeft = Mixer(self.channelsLeft)
        self.mixerLeft.pan = -1
        self.mixerRight = Mixer(self.channelsRight)
        self.mixerRight.pan = 1
        self.mixerMain = Mixer(self.mixerLeft, self.mixerRight)
        self.mixerMain.volume = volume
        self.engine = AudioEngine()
        self.engine.output = self.mixerMain
    }
    
    func setLeftChannelVolume(_ val: Float) {
        self.mixerLeft.volume = val
    }
    
    func setRightChannelVolume(_ val: Float) {
        self.mixerRight.volume = val
    }
    
    func enableChannels(index: Int, left: Bool, right: Bool) {
        let channelLeft = self.channelsLeft[index]
        let channelRight = self.channelsRight[index]
        
        left ? channelLeft.openGate() : channelLeft.closeGate()
        right ? channelRight.openGate() : channelRight.closeGate()
    }
}

class LengthEnvelope: Envelope {
    var voice: Voice?
    var maxDuration: Float = 0
    var enabled = false
    var duration: Float = 0
    
    init(voice: Voice? = nil) {
        self.voice = voice
    }
    
    func update(seconds: Float) {
        if !enabled {
            return
        }
        
        if duration > 0 {
            duration -= seconds
            
            if duration <= 0 {
                voice?.enabled = false
            }
        }
    }
    
    func onTriggered() {
        if duration <= 0 {
            duration = maxDuration
        }
    }
}

class AmplitudeEnvelope: Envelope {
    private var elapsedTime: Float = 0
    
    var voice: Voice?
    var startStep: Int = 0
    var increasing = false
    var stepDuration: Float = 0
    
    init(_ voice: Voice? = nil) {
        self.voice = voice
    }
    
    func update(seconds: Float) {
        if stepDuration == 0 {
            return
        }
        
        elapsedTime += seconds
        
        let deltaSteps = Int(elapsedTime / stepDuration) * (increasing ? 1 : -1)
        let currentStep = (startStep + deltaSteps).clamp(min: 0, max: 0x0F)
        
        voice?.amplitude = Float(currentStep) / 0x0F
    }
    
    func onTriggered() {
        elapsedTime = 0
        voice?.amplitude = Float(startStep) / 0x0F
    }
}

class FrequencySweepEnvelope: Envelope {
    private var elapsedTime: Float = 0
    private var adjustedFrequency: Float = 0 {
        didSet {
            if adjustedFrequency != oldValue {
                voice?.frequency = adjustedFrequency
            }
        }
    }
    
    var voice: Voice?
    
    var startFrequency: Float = 0 {
        didSet {
            if startFrequency != oldValue {
                onTriggered()
            }
        }
    }
    
    var sweepIncreasing = false {
        didSet {
            if sweepIncreasing != oldValue {
                onTriggered()
            }
        }
    }
    
    var sweepShifts: UInt8 = 0 {
        didSet {
            if sweepShifts != oldValue {
                onTriggered()
            }
        }
    }
    
    var sweepTime: Float = 0 {
        didSet {
            if  sweepTime != oldValue {
                onTriggered()
            }
        }
    }
    
    init(_ voice: Voice? = nil) {
        self.voice = voice
    }
    
    func update(seconds: Float) {
        if sweepTime == 0 {
            return
        }
        
        if sweepShifts == 0 {
            return
        }
        
        elapsedTime += seconds
        
        let sweeps = Int(elapsedTime / sweepTime)
        let totalShifts = sweeps > 0 ? sweeps * Int(sweepShifts) : 0
        let shiftedValue = sweepIncreasing ? frequencyToBits(frequency: startFrequency) << totalShifts : frequencyToBits(frequency: startFrequency) >> totalShifts
        
        if shiftedValue == 0 {
            return
        }
        
        if shiftedValue > 2047 {
            return
        }
        
        adjustedFrequency = bitsToFrequency(bits: shiftedValue)
    }
    
    func onTriggered() {
        elapsedTime = 0
        adjustedFrequency = startFrequency
    }
}

extension PWMOscillator: OscillatorNode {
    func rampFrequency(to: Float, duration: Float) {
        $frequency.ramp(to: to, duration: duration)
    }
    
    func rampAmplitude(to: Float, duration: Float) {
        $amplitude.ramp(to: to, duration: duration)
    }
}

class Pulse: Voice {
    let lengthEnvelope = LengthEnvelope()
    let amplitudeEnvelope = AmplitudeEnvelope()
    
    var pulseWidth: Float = 0 {
        didSet {
            if pulseWidth != oldValue {
                if let pwm = oscillator as? PWMOscillator {
                    pwm.pulseWidth = pulseWidth
                }
            }
        }
    }
    
    init(maxDuration: Float) {
        super.init(oscillator: PWMOscillator(), envelopes: [self.lengthEnvelope, self.amplitudeEnvelope])
        
        self.lengthEnvelope.maxDuration = maxDuration
    }
}

class PulseWithSweep: Voice {
    let lengthEnvelope = LengthEnvelope()
    let amplitudeEnvelope = AmplitudeEnvelope()
    let frequencySweepEnvelope = FrequencySweepEnvelope()
    
    var pulseWidth: Float = 0 {
        didSet {
            if pulseWidth != oldValue {
                if let pwm = oscillator as? PWMOscillator {
                    pwm.pulseWidth = pulseWidth
                }
            }
        }
    }
    
    init(maxDuration: Float) {
        super.init(oscillator: PWMOscillator(), envelopes: [self.lengthEnvelope, self.amplitudeEnvelope, self.frequencySweepEnvelope])
        
        self.lengthEnvelope.maxDuration = maxDuration
    }
}

extension DynamicOscillator: OscillatorNode {
    func rampFrequency(to: Float, duration: Float) {
        $frequency.ramp(to: to, duration: duration)
    }
    
    func rampAmplitude(to: Float, duration: Float) {
        $amplitude.ramp(to: to, duration: duration)
    }
}

class CustomWave: Voice {
    let lengthEnvelope = LengthEnvelope()
    
    var data = [Float]() {
        didSet {
            if data != oldValue {
                if let dyn = oscillator as? DynamicOscillator {
                    dyn.setWaveform(Table(data))
                }
            }
        }
    }
    
    init(maxDuration: Float) {
        super.init(oscillator: DynamicOscillator(waveform: Table(.sine)), envelopes: [self.lengthEnvelope])
        
        self.lengthEnvelope.maxDuration = maxDuration
    }
}

extension WhiteNoise: OscillatorNode {
    var frequency: Float {
        get { 0 }
        set { }
    }
    
    func rampFrequency(to: Float, duration: Float) { }
    
    func rampAmplitude(to: Float, duration: Float) {
        $amplitude.ramp(to: to, duration: duration)
    }
}

class Noise: Voice {
    let lengthEnvelope = LengthEnvelope()
    let amplitudeEnvelope = AmplitudeEnvelope()
    
    init(maxDuration: Float) {
        super.init(oscillator: WhiteNoise(), envelopes: [self.lengthEnvelope, self.amplitudeEnvelope])
        
        self.lengthEnvelope.maxDuration = maxDuration
    }
}

public class APU {
    private let mmu: MMU
    private let master: Synthesizer
    private let pulseA: PulseWithSweep
    private let pulseB: Pulse
    private let customWave: CustomWave
    private let noise: Noise
    private var waveformDataMemo = Memo<[Float]>()
    
    init(_ mmu: MMU) {
        self.mmu = mmu
        self.pulseA = PulseWithSweep(maxDuration: 0.25)
        self.pulseB = Pulse(maxDuration: 0.25)
        self.customWave = CustomWave(maxDuration: 1.0)
        self.noise = Noise(maxDuration: 0.25)
        self.master = Synthesizer(voices: [self.pulseA, self.pulseB, self.customWave, self.noise])
        self.master.volume = 0.125
        
        self.wireUpPulseA()
        self.wireUpPulseB()
        self.wireUpCustomWave()
        self.wireUpNoise()
        self.wireUpMaster()
    }
    
    func wireUpPulseA() {
        self.mmu.nr10.subscribe { nr10 in
            let sweepShifts = nr10 & 0b00000111
            let sweepIncreasing = nr10.bit(3)
            let sweepTime = convertToSweepTime(byte: (nr10 & 0b01110000) >> 4)
            
            self.pulseA.frequencySweepEnvelope.sweepShifts = sweepShifts
            self.pulseA.frequencySweepEnvelope.sweepIncreasing = sweepIncreasing
            self.pulseA.frequencySweepEnvelope.sweepTime = sweepTime
        }
        
        self.mmu.nr11.subscribe { nr11 in
            let pulseWidth = convertToPulseWidth(byte: nr11 & 0b11000000)
            let lengthEnvelopDuration = (64 - Float(nr11 & 0b00111111)) * (1 / 256)
            
            self.pulseA.pulseWidth = pulseWidth
            self.pulseA.lengthEnvelope.duration = lengthEnvelopDuration
        }
        
        self.mmu.nr12.subscribe { nr12 in
            let amplitudeEnvelopeStartStep = Int((nr12 & 0b11110000) >> 4)
            let amplitudeEnvelopeStepDuration = Float(nr12 & 0b00000111) * (1 / 64)
            let amplitudeEnvelopeIncreasing = nr12.bit(3)
            let dacEnabled = (nr12 & 0b11111000) != 0
            
            self.pulseA.dacEnabled = dacEnabled
            self.pulseA.amplitudeEnvelope.startStep = amplitudeEnvelopeStartStep
            self.pulseA.amplitudeEnvelope.stepDuration = amplitudeEnvelopeStepDuration
            self.pulseA.amplitudeEnvelope.increasing = amplitudeEnvelopeIncreasing
        }
        
        self.mmu.nr13.subscribe { nr13 in
            let bits = frequencyToBits(frequency: self.pulseA.frequencySweepEnvelope.startFrequency)
            let lsb = UInt16(nr13)
            let msb = bits & 0xFF00
            let frequency = bitsToFrequency(bits: lsb + msb)
            
            self.pulseA.frequencySweepEnvelope.startFrequency = frequency
        }
    
        self.mmu.nr14.subscribe { nr14 in
            let bits = frequencyToBits(frequency: self.pulseA.frequencySweepEnvelope.startFrequency)
            let lsb = bits & 0x00FF
            let msb = UInt16(nr14 & 0b00000111) << 8
            let frequency = bitsToFrequency(bits: lsb + msb)
            let lengthEnvelopEnabled = nr14.bit(6)
            let triggered = nr14.bit(7)
            
            self.pulseA.frequencySweepEnvelope.startFrequency = frequency
            self.pulseA.triggered = triggered
            self.pulseA.lengthEnvelope.enabled = lengthEnvelopEnabled
        }
    }
    
    func wireUpPulseB() {
        self.mmu.nr21.subscribe { nr21 in
            let pulseWidth = convertToPulseWidth(byte: nr21 & 0b11000000)
            let lengthEnvelopeDuration = (64 - Float(nr21 & 0b00111111)) * (1 / 256)
            
            self.pulseB.pulseWidth = pulseWidth
            self.pulseB.lengthEnvelope.duration = lengthEnvelopeDuration
        }
        
        self.mmu.nr22.subscribe { nr22 in
            let amplitudeEnvelopeStartStep = Int((nr22 & 0b11110000) >> 4)
            let amplitudeEnvelopeStepDuration = Float(nr22 & 0b00000111) * (1 / 64)
            let amplitudeEnvelopeIncreasing = nr22.bit(3)
            let dacEnabled = (nr22 & 0b11111000) != 0
            
            self.pulseB.dacEnabled = dacEnabled
            self.pulseB.amplitudeEnvelope.startStep = amplitudeEnvelopeStartStep
            self.pulseB.amplitudeEnvelope.stepDuration = amplitudeEnvelopeStepDuration
            self.pulseB.amplitudeEnvelope.increasing = amplitudeEnvelopeIncreasing
        }
        
        self.mmu.nr23.subscribe { nr23 in
            let bits = frequencyToBits(frequency: self.pulseB.frequency)
            let lsb = UInt16(nr23)
            let msb = bits & 0xFF00
            let frequency = bitsToFrequency(bits: lsb + msb)
            
            self.pulseB.frequency = frequency
        }
        
        self.mmu.nr24.subscribe { nr24 in
            let bits = frequencyToBits(frequency: self.pulseB.frequency)
            let lsb = bits & 0x00FF
            let msb = UInt16(nr24 & 0b00000111) << 8
            let frequency = bitsToFrequency(bits: lsb + msb)
            let lengthEnvelopeEnabled = nr24.bit(6)
            let triggered = nr24.bit(7)
            
            self.pulseB.triggered = triggered
            self.pulseB.frequency = frequency
            self.pulseB.lengthEnvelope.enabled = lengthEnvelopeEnabled
        }
    }
    
    func wireUpCustomWave() {
        self.mmu.nr30.subscribe { nr30 in
            let dacEnabled = nr30.bit(7)
            
            self.customWave.dacEnabled = dacEnabled
        }
        
        self.mmu.nr31.subscribe { nr31 in
            let lengthEnvelopeDuration = (256 - Float(nr31)) * (1 / 256)
            
            self.customWave.lengthEnvelope.duration = lengthEnvelopeDuration
        }
        
        self.mmu.nr33.subscribe { nr33 in
            let bits = frequencyToBits(frequency: self.pulseB.frequency)
            let lsb = UInt16(nr33)
            let msb = bits & 0xFF00
            let frequency = bitsToFrequency(bits: lsb + msb)
            
            self.customWave.frequency = frequency
        }
        
        self.mmu.nr34.subscribe { nr34 in
            let bits = frequencyToBits(frequency: self.pulseB.frequency)
            let lsb = bits & 0x00FF
            let msb = UInt16(nr34 & 0b00000111) << 8
            let frequency = bitsToFrequency(bits: lsb + msb)
            let lengthEnvelopEnabled = nr34.bit(6)
            let triggered = nr34.bit(7)
            
            self.customWave.triggered = triggered
            self.customWave.frequency = frequency
            self.customWave.lengthEnvelope.enabled = lengthEnvelopEnabled
        }
    }
    
    func wireUpNoise() {
        self.mmu.nr41.subscribe { nr41 in
            let lengthEnvelopeDuration = (64 - Float(nr41 & 0b00111111)) * (1 / 256)
            
            self.noise.lengthEnvelope.duration = lengthEnvelopeDuration
        }
        
        self.mmu.nr42.subscribe { nr42 in
            let amplitudeEnvelopeStartStep = Int((nr42 & 0b11110000) >> 4)
            let amplitudeEnvelopeStepDuration = Float(nr42 & 0b00000111) * 1 / 64
            let amplitudeEnvelopeIncreasing = nr42.bit(3)
            let dacEnabled = (nr42 & 0b11111000) != 0
            
            self.noise.dacEnabled = dacEnabled
            self.noise.amplitudeEnvelope.startStep = amplitudeEnvelopeStartStep
            self.noise.amplitudeEnvelope.stepDuration = amplitudeEnvelopeStepDuration
            self.noise.amplitudeEnvelope.increasing = amplitudeEnvelopeIncreasing
        }
        
        self.mmu.nr43.subscribe { nr43 in
            let temp = nr43 & 0b00000111
            let r = temp == 0 ? Float(0.5) : Float(temp)
            let s = Float(nr43 & 0b11100000)
            let frequency = Float(524288) / r / powf(2, s + 1.0)
            
            self.noise.frequency = frequency
        }
        
        self.mmu.nr44.subscribe { nr44 in
            let lengthEnvelopeEnabled = nr44.bit(6)
            let triggered = nr44.bit(7)
            
            self.noise.triggered = triggered
            self.noise.lengthEnvelope.enabled = lengthEnvelopeEnabled
        }
    }
    
    func wireUpMaster() {
        // Set left and right channel volumes
        self.mmu.nr50.subscribe { nr50 in
            self.master.setLeftChannelVolume(Float((nr50 & 0b01110000) >> 4) / 7.0)
            self.master.setRightChannelVolume(Float(nr50 & 0b00000111) / 7.0)
        }
        
        // Enabled left or right channel output for each voice
        self.mmu.nr51.subscribe { nr51 in
            self.master.enableChannels(index: 0, left: nr51.bit(4), right: nr51.bit(0))
            self.master.enableChannels(index: 1, left: nr51.bit(5), right: nr51.bit(1))
            self.master.enableChannels(index: 2, left: nr51.bit(6), right: nr51.bit(2))
            self.master.enableChannels(index: 3, left: nr51.bit(7), right: nr51.bit(3))
        }
        
        // Master sound output
        self.mmu.nr52.subscribe { nr52 in
            self.master.enabled = nr52.bit(7)
        }
    }
    
    func updateWaveform() {
        let nr32 = self.mmu.nr32.read()
        let outputLevel = (nr32 & 0b01100000) >> 5
        let waveformData = self.waveformDataMemo.get(deps: [self.mmu.waveformRam.version, outputLevel]) {
            let buffer = self.mmu.waveformRam.buffer
            return buffer.flatMap({ [Float($0.nibble(1) >> outputLevel) / 0b1111, Float($0.nibble(0) >> outputLevel) / 0b1111 ] }).map({ $0 * 2 - 1 })
        }
        
        self.customWave.data = waveformData
        self.customWave.amplitude = 1
    }

    
    public func run(seconds: Float) throws {
        if !self.master.enabled {
            return
        }
        
        // Custom waveform update
        self.updateWaveform()
        
        // Update all voices
        var nr52 = self.mmu.nr52.read()
        
        nr52[0] = self.pulseA.update(seconds: seconds)
        nr52[1] = self.pulseB.update(seconds: seconds)
        nr52[2] = self.customWave.update(seconds: seconds)
        nr52[3] = self.noise.update(seconds: seconds)
        
        // Write nr52 back into RAM
        self.mmu.nr52.write(nr52, publish: false)
    }
}
