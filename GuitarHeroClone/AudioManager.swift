import SwiftUI
import AVFoundation

class AudioManager: ObservableObject {
    private var engine = AVAudioEngine()
    private var sampler = AVAudioUnitSampler()
    private var backgroundMusicPlayer: AVAudioPlayer?
    private var timer: Timer?

    private var currentBendValue: Float = 0.0 // Start at neutral (no bend)
    private var targetBendValue: Float = 0.0
    private let bendSpeed: Float = 15 // Speed of interpolation for smooth bending

    private var currentSemitoneRange: Int = 0 // The semitone bend range for the active note
    private var currentNote: UInt8? = nil // The note currently being played
    
    init() {
        setupAudioEngine()
        loadSoundFont()
        startPitchBendLoop()
    }
    /// Smoothly interpolate towards the target pitch bend value
    private func updateBendSmoothly() {
        if abs(currentBendValue - targetBendValue) > 0.01 {
            currentBendValue += (targetBendValue - currentBendValue) / bendSpeed
            applyPitchBend(currentBendValue)
        }
    }

    /// Apply a pitch bend based on the current semitone range
    private func applyPitchBend(_ bendValue: Float) {
        guard let _ = currentNote else { return } // Only bend if a note is playing

        let channel: UInt8 = 0
        let midiBendRange: Float = 16383.0
        let bendCenter: Float = 8192.0

        // Ensure bendValue is within valid range
        let bendSemitones = max(-1.0, min(Float(currentSemitoneRange) * bendValue, 1.0))
        let midiBendValue = bendCenter + (bendSemitones * (midiBendRange / 2.0))

        let clampedBend = max(0, min(midiBendValue, midiBendRange)) // Clamp to valid range

        let lsb = UInt8(Int(clampedBend) & 0x7F)
        let msb = UInt8((Int(clampedBend) >> 7) & 0x7F)

        sampler.sendMIDIEvent(0xE0 | channel, data1: lsb, data2: msb)
    }

    /// Start a loop that gradually applies pitch bends
    private func startPitchBendLoop() {
        timer = Timer.scheduledTimer(withTimeInterval: 0.01, repeats: true) { _ in
            self.updateBendSmoothly()
        }
    }

    /// Update the pitch bend value based on capacitive touch input (0.0 - 1.0)
    func setBendValue(_ value: Float) {
        targetBendValue = value
    }


    private func setupAudioEngine() {
        engine.attach(sampler)
        engine.connect(sampler, to: engine.mainMixerNode, format: nil)

        do {
            try engine.start()
            print("✅ AVAudioEngine started successfully.")
        } catch {
            print("❌ Error starting AVAudioEngine: \(error)")
        }
    }

    private func loadSoundFont() {
        guard let url = Bundle.main.url(forResource: "FluidR3_GM", withExtension: "sf2") else {
            print("❌ SoundFont file not found in bundle.")
            return
        }

        do {
//            try sampler.loadInstrument(at: url)
            try sampler.loadSoundBankInstrument(at: url, program: 29, bankMSB: 0x79, bankLSB: 0)
            print("✅ Successfully loaded SoundFont")
        } catch {
            print("❌ Failed to load SoundFont: \(error.localizedDescription)")
        }
    }

    func playBackgroundMusic(_ track: String) {
        // Stop and deallocate any existing background music player
        backgroundMusicPlayer?.stop()
        backgroundMusicPlayer = nil

        guard let url = Bundle.main.url(forResource: track, withExtension: "mp3") else {
            print("❌ Background music file not found.")
            return
        }

        do {
            backgroundMusicPlayer = try AVAudioPlayer(contentsOf: url)
            backgroundMusicPlayer?.numberOfLoops = -1
            backgroundMusicPlayer?.prepareToPlay() // Ensures smooth playback start
            backgroundMusicPlayer?.play()
            print("🎶 Background music playing")
        } catch {
            print("❌ Error loading background music: \(error.localizedDescription)")
        }
    }


    func stopBackgroundMusic() {
        backgroundMusicPlayer?.stop()
    }

    func playNote(_ note: UInt8, loudness: UInt8, semitoneRange: Int) {
        guard engine.isRunning else {
            print("❌ AVAudioEngine is not running. Restarting...")
            try? engine.start()
            return
        }

        print("🎵 Playing note \(note)")
        sampler.startNote(note, withVelocity: loudness, onChannel: 0)
        
        currentNote = note
        // set the semitone Range
        currentSemitoneRange = semitoneRange
    }

    func stopNote(_ note: UInt8) {
        print("🎵 Stopping note \(note)")
        sampler.stopNote(note, onChannel: 0)
    }
}
