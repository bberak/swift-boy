// TODO: Figure out a good default for master volume 🤔
// TODO: Get rid of unecessary 'self' references? Or at least be consistent..
// TODO: Startup sound is still a bit off
// TODO: Super Mario menu produces a high pitched sound.. I think this is somehow related to the sweepTime on the FrequencySweepEnvelop
// TODO: Think there is something wrong with how amplitudes are set and or the amplitude envelope. Pulse A and B sound so hollow now. If you hardcode their amplitudes to 1 you will see what I mean..
// TODO: Don't forget to uncomment code that supresses the custom and noise waves

import Foundation
import AudioKit
import SoundpipeAudioKit

typealias AKAmplitudeEnvelope = SoundpipeAudioKit.AmplitudeEnvelope

func bitsToFrequency(bits: UInt16) -> Float {
    return 131072 / (2048 - Float(bits))
}

func frequencyToBits(frequency: Float) -> UInt16 {
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

class Voice {
    let oscillator: OscillatorNode
    let lengthEnvelope: LengthEnvelope
    
    var dacEnabled: Bool = true
    var enabled: Bool = true
    var amplitude: Float = 0
    var frequency: Float = 0
    
    var triggered: Bool = false {
        didSet {
            if triggered && triggered != oldValue {
                onTriggered()
            }
        }
    }
    
    init(oscillator: OscillatorNode, maxDuration: Float) {
        self.oscillator = oscillator
        self.oscillator.start()
        self.oscillator.amplitude = 0
        self.oscillator.frequency = 0
        self.lengthEnvelope = LengthEnvelope(maxDuration: maxDuration)
        self.lengthEnvelope.voice = self
    }
    
    func onTriggered() {
        enabled = dacEnabled
        lengthEnvelope.reset()
    }
    
    func update() -> Bool {
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

protocol Envelope {
    var voice: Voice? { get set }
    func advance(seconds: Float) -> Void
    func reset() -> Void
}

class LengthEnvelope: Envelope {
    private var maxDuration: Float = 0
    private var elapsedTime: Float = 0
    
    var voice: Voice?
    
    var enabled = false {
        didSet {
            if enabled != oldValue {
                reset()
            }
        }
    }
    
    var duration: Float = 0 {
        didSet {
            if duration != oldValue {
                reset()
            }
        }
    }
    
    init(maxDuration: Float, voice: Voice? = nil) {
        self.maxDuration = maxDuration
        self.voice = voice
    }
    
    func advance(seconds: Float) {
        if !enabled {
            return
        }
        
        if duration == 0 {
            return
        }
        
        if elapsedTime < duration {
            elapsedTime += seconds
            
            if elapsedTime > duration {
                voice?.enabled = false
            }
        }
    }
    
    func reset() {
        elapsedTime = 0
        
        if duration == 0 {
            duration = maxDuration
        }
    }
}

class AmplitudeEnvelope: Envelope {
    private var elapsedTime: Float = 0
    
    var voice: Voice?
    
    var startStep: Int = 0 {
        didSet {
            if startStep != oldValue {
                reset()
            }
        }
    }
    
    var increasing = false {
        didSet {
            if increasing != oldValue {
                reset()
            }
        }
    }
    
    var stepDuration: Float = 0 {
        didSet {
            if stepDuration != oldValue {
                reset()
            }
        }
    }
    
    init(_ voice: Voice? = nil) {
        self.voice = voice
    }
    
    func advance(seconds: Float) {
        if stepDuration == 0 {
            return
        }
        
        elapsedTime += seconds
          
        let deltaSteps = Int(elapsedTime / stepDuration) * (increasing ? 1 : -1)
        let currentStep = (startStep + deltaSteps).clamp(min: 0, max: 0x0F)
        
        voice?.amplitude = Float(currentStep) / 0x0F
    }
    
    func reset() {
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
                reset()
            }
        }
    }
    
    var sweepIncreasing = false {
        didSet {
            if sweepIncreasing != oldValue {
                reset()
            }
        }
    }
    
    var sweepShifts: UInt8 = 0 {
        didSet {
            if sweepShifts != oldValue {
                reset()
            }
        }
    }
    
    var sweepTime: Float = 0 {
        didSet {
            if  sweepTime != oldValue {
                reset()
            }
        }
    }
    
    init(_ voice: Voice? = nil) {
        self.voice = voice
    }
    
    func advance(seconds: Float) {
        if startFrequency == 0 {
            return
        }
        
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
    
    func reset() {
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
        super.init(oscillator: PWMOscillator(), maxDuration: maxDuration)
        
        amplitudeEnvelope.voice = self
    }
    
    override func onTriggered() {
        super.onTriggered()
        
        amplitudeEnvelope.reset()
    }
}

class PulseWithSweep: Pulse {
    let frequencySweepEnvelope = FrequencySweepEnvelope()
        
    override init(maxDuration: Float) {
        super.init(maxDuration: maxDuration)
        
        frequencySweepEnvelope.voice = self
    }
    
    override func onTriggered() {
        super.onTriggered()
        
        frequencySweepEnvelope.reset()
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
        super.init(oscillator: DynamicOscillator(waveform: Table(.sine)), maxDuration: maxDuration)
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
    let amplitudeEnvelope = AmplitudeEnvelope()
    
    init(maxDuration: Float) {
        super.init(oscillator: WhiteNoise(), maxDuration: maxDuration)
        
        amplitudeEnvelope.voice = self
    }
    
    override func onTriggered() {
        super.onTriggered()
        
        amplitudeEnvelope.reset()
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
        self.master = Synthesizer(voices: [self.pulseA, self.pulseB, self.customWave /*, self.noise */])
        self.master.volume = 0.125
    }
    
    func updatePulseA(seconds: Float) -> Bool {
        let nr10 = self.mmu.nr10.read()
        let nr11 = self.mmu.nr11.read()
        let nr12 = self.mmu.nr12.read()
        let nr13 = self.mmu.nr13.read()
        let nr14 = self.mmu.nr14.read()
        
        let sweepShifts = nr10 & 0b00000111
        let sweepIncreasing = nr10.bit(3)
        let sweepTime = convertToSweepTime(byte: (nr10 & 0b01110000) >> 4)
        let pulseWidth = convertToPulseWidth(byte: nr11 & 0b11000000)
        let lengthEnvelopDuration = (64 - Float(nr11 & 0b00111111)) * (1 / 256)
        let amplitudeEnvelopeStartStep = Int((nr12 & 0b11110000) >> 4)
        let amplitudeEnvelopeStepDuration = Float(nr12 & 0b00000111) * (1 / 64)
        let amplitudeEnvelopeIncreasing = nr12.bit(3)
        let dacEnabled = (nr12 & 0b11111000) != 0
        let frequency = bitsToFrequency(bits: UInt16(nr13) + (UInt16(nr14 & 0b00000111) << 8))
        let lengthEnvelopEnabled = nr14.bit(6)
        let triggered = nr14.bit(7)
        
        self.pulseA.dacEnabled = dacEnabled
        self.pulseA.triggered = triggered
        self.pulseA.frequencySweepEnvelope.startFrequency = frequency
        self.pulseA.frequencySweepEnvelope.sweepShifts = sweepShifts
        self.pulseA.frequencySweepEnvelope.sweepIncreasing = sweepIncreasing
        self.pulseA.frequencySweepEnvelope.sweepTime = sweepTime
        self.pulseA.pulseWidth = pulseWidth
        self.pulseA.amplitudeEnvelope.startStep = amplitudeEnvelopeStartStep
        self.pulseA.amplitudeEnvelope.stepDuration = amplitudeEnvelopeStepDuration
        self.pulseA.amplitudeEnvelope.increasing = amplitudeEnvelopeIncreasing
        self.pulseA.lengthEnvelope.enabled = lengthEnvelopEnabled
        self.pulseA.lengthEnvelope.duration = lengthEnvelopDuration
        
        self.pulseA.amplitudeEnvelope.advance(seconds: seconds)
        self.pulseA.frequencySweepEnvelope.advance(seconds: seconds)
        self.pulseA.lengthEnvelope.advance(seconds: seconds)
        
        return self.pulseA.update()
    }
    
    func updatePulseB(seconds: Float) -> Bool {
        let nr21 = self.mmu.nr21.read()
        let nr22 = self.mmu.nr22.read()
        let nr23 = self.mmu.nr23.read()
        let nr24 = self.mmu.nr24.read()
        
        let pulseWidth = convertToPulseWidth(byte: nr21 & 0b11000000)
        let lengthEnvelopeDuration = (64 - Float(nr21 & 0b00111111)) * (1 / 256)
        let amplitudeEnvelopeStartStep = Int((nr22 & 0b11110000) >> 4)
        let amplitudeEnvelopeStepDuration = Float(nr22 & 0b00000111) * (1 / 64)
        let amplitudeEnvelopeIncreasing = nr22.bit(3)
        let dacEnabled = (nr22 & 0b11111000) != 0
        let frequency = bitsToFrequency(bits: UInt16(nr23) + (UInt16(nr24 & 0b00000111) << 8))
        let lengthEnvelopeEnabled = nr24.bit(6)
        let triggered = nr24.bit(7)
        
        self.pulseB.dacEnabled = dacEnabled
        self.pulseB.triggered = triggered
        self.pulseB.frequency = frequency
        self.pulseB.pulseWidth = pulseWidth
        self.pulseB.amplitudeEnvelope.startStep = amplitudeEnvelopeStartStep
        self.pulseB.amplitudeEnvelope.stepDuration = amplitudeEnvelopeStepDuration
        self.pulseB.amplitudeEnvelope.increasing = amplitudeEnvelopeIncreasing
        self.pulseB.lengthEnvelope.enabled = lengthEnvelopeEnabled
        self.pulseB.lengthEnvelope.duration = lengthEnvelopeDuration
        
        self.pulseB.amplitudeEnvelope.advance(seconds: seconds)
        self.pulseB.lengthEnvelope.advance(seconds: seconds)
        
        return self.pulseB.update()
    }
    
    func updateWaveform(seconds: Float) -> Bool {
        let nr30 = self.mmu.nr30.read()
        let nr31 = self.mmu.nr31.read()
        let nr32 = self.mmu.nr32.read()
        let nr33 = self.mmu.nr33.read()
        let nr34 = self.mmu.nr34.read()
        
        let dacEnabled = nr30.bit(7)
        let lengthEnvelopeDuration = (256 - Float(nr31)) * (1 / 256)
        let outputLevel = (nr32 & 0b01100000) >> 5
        let frequency = bitsToFrequency(bits: UInt16(nr33) + (UInt16(nr34 & 0b00000111) << 8))
        let lengthEnvelopEnabled = nr34.bit(6)
        let triggered = nr34.bit(7)
        let waveformData = self.waveformDataMemo.get(deps: [self.mmu.waveformRam.version, outputLevel]) {
            let buffer = self.mmu.waveformRam.buffer
            return buffer.flatMap({ [Float($0.nibble(1) >> outputLevel) / 0b1111, Float($0.nibble(0) >> outputLevel) / 0b1111 ] }).map({ $0 * 2 - 1 })
        }
        
        self.customWave.dacEnabled = dacEnabled
        self.customWave.triggered = triggered
        self.customWave.data = waveformData
        self.customWave.amplitude = 1
        self.customWave.frequency = frequency
        self.customWave.lengthEnvelope.enabled = lengthEnvelopEnabled
        self.customWave.lengthEnvelope.duration = lengthEnvelopeDuration
        
        self.customWave.lengthEnvelope.advance(seconds: seconds)
        
        return self.customWave.update()
    }
    
    func updateNoise(seconds: Float) -> Bool {
        let nr41 = self.mmu.nr41.read()
        let nr42 = self.mmu.nr42.read()
        let nr43 = self.mmu.nr43.read()
        let nr44 = self.mmu.nr44.read()
        
        let lengthEnvelopeDuration = (64 - Float(nr41 & 0b00111111)) * (1 / 256)
        let amplitudeEnvelopeStartStep = Int((nr42 & 0b11110000) >> 4)
        let amplitudeEnvelopeStepDuration = Float(nr42 & 0b00000111) * 1 / 64
        let amplitudeEnvelopeIncreasing = nr42.bit(3)
        let dacEnabled = (nr42 & 0b11111000) != 0
        let temp = nr43 & 0b00000111
        let r = temp == 0 ? Float(0.5) : Float(temp)
        let s = Float(nr43 & 0b11100000)
        let frequency = Float(524288) / r / powf(2, s + 1.0)
        let lengthEnvelopeEnabled = nr44.bit(6)
        let triggered = nr44.bit(7)
        
        self.noise.dacEnabled = dacEnabled
        self.noise.triggered = triggered
        self.noise.frequency = frequency
        self.noise.amplitudeEnvelope.startStep = amplitudeEnvelopeStartStep
        self.noise.amplitudeEnvelope.stepDuration = amplitudeEnvelopeStepDuration
        self.noise.amplitudeEnvelope.increasing = amplitudeEnvelopeIncreasing
        self.noise.lengthEnvelope.enabled = lengthEnvelopeEnabled
        self.noise.lengthEnvelope.duration = lengthEnvelopeDuration
        
        self.noise.amplitudeEnvelope.advance(seconds: seconds)
        self.noise.lengthEnvelope.advance(seconds: seconds)
        
        return self.noise.update()
    }
    
    public func run(seconds: Float) throws {        
        // Master sound registers
        let nr50 = self.mmu.nr50.read()
        let nr51 = self.mmu.nr51.read()
        var nr52 = self.mmu.nr52.read()
        
        // Master sound output
        self.master.enabled = nr52.bit(7)
        
        if !self.master.enabled {
            return
        }
        
        // Voice specific controls
        nr52[0] = updatePulseA(seconds: seconds)
        nr52[1] = updatePulseB(seconds: seconds)
        nr52[2] = updateWaveform(seconds: seconds)
        nr52[3] = updateNoise(seconds: seconds)
        
        // Left or right channel output for each voice
        self.master.enableChannels(index: 0, left: nr51.bit(4), right: nr51.bit(0))
        self.master.enableChannels(index: 1, left: nr51.bit(5), right: nr51.bit(1))
        self.master.enableChannels(index: 2, left: nr51.bit(6), right: nr51.bit(2))
        //self.master.enableChannels(index: 3, left: nr51.bit(7), right: nr51.bit(3))
        
        // Set left and right channel volumes
        self.master.setLeftChannelVolume(Float((nr50 & 0b01110000) >> 4) / 7.0)
        self.master.setRightChannelVolume(Float(nr50 & 0b00000111) / 7.0)
        
        // Write nr52 back into RAM
        self.mmu.nr52.write(nr52)
    }
}
