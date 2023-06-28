//
//  AudioPlayer.swift
//  EuphonizeProject
//
//  Created by Raffaele Martone on 28/06/23.
//

import Foundation

import SwiftUI
import Combine
import AVFoundation

class AudioPlayer: NSObject, ObservableObject, AVAudioPlayerDelegate {
    static let shared = AudioPlayer()
    
    let objectWillChange = PassthroughSubject<AudioPlayer, Never>()
    
    var isPlaying = false {
        didSet {
            objectWillChange.send(self)
        }
    }
    
    var audioPlayer: AVAudioPlayer!
    
    func startPlayback(audio: URL) {
        let playbackSession = AVAudioSession.sharedInstance()
        
        do {
            try playbackSession.overrideOutputAudioPort(AVAudioSession.PortOverride.speaker)
        } catch {
            print("Playing over the device's speakers failed")
        }
        
        do {
            audioPlayer = try AVAudioPlayer(contentsOf: audio)
            audioPlayer.delegate = self
            audioPlayer.play()
            isPlaying = true
        } catch {
            print("Playback failed.")
        }
    }
    
    func stopPlayback() {
            audioPlayer.stop()
            isPlaying = false
    }
    
    
    func getDuration(url: URL) -> Double{
        var dur : Double = 0.0
        do{
            dur = try Double(AVAudioPlayer(contentsOf: url ).duration)
        } catch {
            print("Error")
        }
        return dur
    }
    
    
    
    func audioPlayerDidFinishPlaying(_ player: AVAudioPlayer, successfully flag: Bool) {
        if flag {
            isPlaying = false
        }
    }

}


