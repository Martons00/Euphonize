//
//  EuphoManager.swift
//  EuphonizeProject
//
//  Created by Raffaele Martone on 28/06/23.
//

import Foundation
import Combine
import AVFAudio

class EuphoManager: NSObject, ObservableObject {
    
    var hapticManager = HapticManager.shared
    var audioManager = AudioPlayer.shared
    
    static let shared = EuphoManager()
    
    let objectWillChange = PassthroughSubject<EuphoManager, Never>()
    
    var isPlaying = false {
        didSet {
            objectWillChange.send(self)
        }
    }
    var isInLoop = false
    
    func startPlaying (recording: Recording){
        if isPlaying {
            self.stopPlaying()
        }
        hapticManager?.playAudio(audioAssetURL: recording.fileURL)
        audioManager.startPlayback(audio: recording.fileURL)
        self.isPlaying = true
        
        DispatchQueue.main.asyncAfter(deadline: .now() + audioManager.getDuration(url: recording.fileURL)) {
            if self.isPlaying{
                self.isPlaying = false
            }
        }
    }
    
    
    func stopPlaying (){
        self.isPlaying = false
        hapticManager?.stopHapticFeedback()
        audioManager.stopPlayback()
    }
    
    func stopLoop(){
        if isInLoop{
            isInLoop = false
            self.stopPlaying()
        }
    }
    
    func audioPlayerDidFinishPlaying(_ player: AVAudioPlayer, successfully flag: Bool) {
        if flag {
            isPlaying = false
        }
    }
    
    func startPlayingInLoop(recording: Recording, selectedInterval: Int){
        let duration = audioManager.getDuration(url: recording.fileURL)
        let numberOfLoop = Int(Double(selectedInterval)/duration)
        isInLoop = true
        self.startPlaying(recording: recording)
        var timeOfLoop = 0
        var timer : Timer?
        timer = Timer.scheduledTimer(withTimeInterval: duration + 1, repeats: true){ _ in
            if self.isInLoop == false || timeOfLoop == numberOfLoop{
                timer?.invalidate()
            }else{
                self.startPlaying(recording: recording)
            }
            timeOfLoop = timeOfLoop + 1
        }
    }
}

