//
//  HapticManager.swift
//  Euphonize
//
//  Created by Raffaele Martone on 26/06/23.
//

import Foundation
import CoreHaptics
import AVFAudio

class HapticManager {
    static let shared = HapticManager()
    let hapticEngine: CHHapticEngine
    let audioPlayer = AudioPlayer.shared
    
    
    private init?() {
        let hapticCapability = CHHapticEngine.capabilitiesForHardware()
        guard hapticCapability.supportsHaptics else {
            return nil
        }
        
        do {
            hapticEngine = try CHHapticEngine()
        } catch let error {
            print("DEBUG: Haptic engine Creation Error: \(error)")
            return nil
        }
        do {
            try hapticEngine.start()
        } catch let error {
            print("DEBUG: Haptic failed to start Error: \(error)")
        }
        hapticEngine.isAutoShutdownEnabled = true
        
    }
    
    
    func triggerHaptic() {
        do {
            let intensity = CHHapticEventParameter(parameterID: .hapticIntensity, value: 0.7)
            let sharpness = CHHapticEventParameter(parameterID: .hapticSharpness, value: 1)
            let duration = 0.2 // Durata in secondi
            let pattern = try CHHapticPattern(events: [CHHapticEvent(eventType: .hapticContinuous, parameters: [intensity, sharpness], relativeTime: 0, duration: duration)], parameters: [])
            let player = try hapticEngine.makePlayer(with: pattern)
            try player.start(atTime: 0)
            hapticEngine.notifyWhenPlayersFinished { _ in
                return .stopEngine
            }
        } catch {
            print("DEBUG: Error during reproducing of the feedback: \(error.localizedDescription)")
        }
    }
    
    private func createHapticEvent() -> CHHapticEvent {
        let intensity = CHHapticEventParameter(parameterID: .hapticIntensity, value: 0.7)
        let sharpness = CHHapticEventParameter(parameterID: .hapticSharpness, value: 1)
        let duration = 0.2 // Durata in secondi
        
        return CHHapticEvent(eventType: .hapticContinuous, parameters: [intensity, sharpness], relativeTime: 0, duration: duration)
    }
    
    func playAudio(audioAssetURL: URL) {
        var duration : Float = 0.0
        do{
            duration = try Float(AVAudioPlayer(contentsOf: audioAssetURL ).duration)
        } catch {
            print("Error")
        }
        let numberOfSamples = duration * 10
        guard let waveformAnalyzer = WaveformAnalyzer(audioAssetURL: audioAssetURL) else {
            print("Error")
            return
        }
        waveformAnalyzer.samples(count: Int(numberOfSamples)) { samples in
            guard let samples = samples else {
                print("Error")
                return
            }
            self.createAndPlayFromSamples(samples: samples)
        }
    }
    
    
    
    
    func stopHapticFeedback() {
        try hapticEngine.stop()
    }
    
    private func createAndPlayFromSamples(samples: [Float]){
        
        let count = samples.count
        
        let intensity = CHHapticEventParameter(parameterID: .hapticIntensity, value: 1.0)
        let sharpness = CHHapticEventParameter(parameterID: .hapticSharpness, value: 0.0)
        let totalDuration: TimeInterval = Double(count) * 0.1
        var dynamicIntensity = [CHHapticDynamicParameter]()
        var dynamicSharpness = [CHHapticDynamicParameter]()
        
        for (_, sample) in samples.enumerated() {
            if sample > 0.2{
                dynamicIntensity.append(CHHapticDynamicParameter(parameterID: .hapticIntensityControl, value: sample, relativeTime: 0))
                dynamicSharpness.append(CHHapticDynamicParameter(parameterID: .hapticSharpnessControl, value: 0, relativeTime: 0))
            } else {
                dynamicIntensity.append(CHHapticDynamicParameter(parameterID: .hapticIntensityControl, value: 0.1, relativeTime: 0))
                dynamicSharpness.append(CHHapticDynamicParameter(parameterID: .hapticSharpnessControl, value: 0, relativeTime: 0))
            }
        }
        
        let event = CHHapticEvent(eventType: .hapticContinuous, parameters: [intensity, sharpness], relativeTime: 0, duration: totalDuration)
        
        do {
            let pattern = try CHHapticPattern(events: [event], parameters: [])
            let player = try hapticEngine.makePlayer(with: pattern)
            try player.start(atTime: CHHapticTimeImmediate)
            hapticEngine.notifyWhenPlayersFinished { _ in
                return .stopEngine
            }
            
            for (index, _ ) in samples.enumerated() {
                let relativeInterval: TimeInterval = 0.1 * Double(index)
                
                DispatchQueue.main.asyncAfter(deadline: .now() + relativeInterval) {
                    if self.audioPlayer.isPlaying{
                        do {
                            try player.sendParameters([dynamicIntensity[index], dynamicSharpness[index]], atTime: CHHapticTimeImmediate)
                        } catch {
                            print("qui0" + error.localizedDescription)
                        }
                    }
                }
            }
        } catch {
            print(error.localizedDescription)
        }
    }
}

