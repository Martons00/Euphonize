//
//  AudioRecorder.swift
//  EuphonizeProject
//
//  Created by Raffaele Martone on 28/06/23.
//

import Foundation
import SwiftUI
import Combine
import AVFoundation



class AudioRecorder: NSObject, ObservableObject {
    
    
    override init() {
        super.init()
        fetchRecording()
    }
    
    var room : String = ""
    
    let objectWillChange = PassthroughSubject<AudioRecorder, Never>()
    
    var audioRecorder: AVAudioRecorder!
    
    var recordings = [Recording]()
    
    var isRecording = false {
        didSet {
            objectWillChange.send(self)
        }
    }
    
    func setRoomName(name: String){
        self.room = name
        fetchRecording()
    }
    
    func startRecording() {
        let recordingSession = AVAudioSession.sharedInstance()
        
        do {
            try recordingSession.setCategory(.playAndRecord, mode: .default)
            try recordingSession.setActive(true)
        } catch {
            print("Failed to set up recording session")
        }
        
        let documentPath = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0]
        let audioFilename = documentPath.appendingPathComponent(room + ".\(Date().toString(dateFormat: "dd-MM-YY 'at' HH:mm:ss")).m4a")
        let settings = [
            AVFormatIDKey: Int(kAudioFormatMPEG4AAC),
            AVSampleRateKey: 12000,
            AVNumberOfChannelsKey: 1,
            AVEncoderAudioQualityKey: AVAudioQuality.high.rawValue
        ]
        
        do {
            audioRecorder = try AVAudioRecorder(url: audioFilename, settings: settings)
            audioRecorder.record()

            isRecording = true
        } catch {
            print("Could not start recording")
        }
    }
    
    func stopRecording() {
        audioRecorder.stop()
        isRecording = false
        
        fetchRecording()
    }
    
    func fetchRecording() {
        recordings.removeAll()
        
        let fileManager = FileManager.default
        let documentDirectory = fileManager.urls(for: .documentDirectory, in: .userDomainMask)[0]
        let directoryContents = try! fileManager.contentsOfDirectory(at: documentDirectory, includingPropertiesForKeys: nil)
        for audio in directoryContents {
            if audio.lastPathComponent.contains(room + "." ) {
                let recording = Recording(fileURL: audio, createdAt: getFileDate(for: audio), name: "\(audio.lastPathComponent)")
                recordings.append(recording)
            }
        }
        
        recordings.sort(by: { $0.createdAt.compare($1.createdAt) == .orderedAscending})
        
        objectWillChange.send(self)
    }
    
    func editRecordingName(name: String, recording: Recording){
        
            let nuovoNomeAudio = room + ".\(name).m4a"
            
        let nuovoAudioURL = recording.fileURL.deletingLastPathComponent().appendingPathComponent(nuovoNomeAudio)

            do {
                try FileManager.default.moveItem(atPath: recording.fileURL.path, toPath: nuovoAudioURL.path)
            } catch {
                print("Errore durante la rinomina del file audio: \(error)")
            }
        
        
        let newRecording = Recording(fileURL: nuovoAudioURL, createdAt: recording.createdAt, name: "\(nuovoAudioURL.lastPathComponent)")
        
        recordings.append(recording)
        
        deleteRecording(urlsToDelete: [recording.fileURL])
    }
    
    func deleteRecording(urlsToDelete: [URL]) {
            
        for url in urlsToDelete {
            print(url)
            do {
               try FileManager.default.removeItem(at: url)
            } catch {
                print("File could not be deleted!")
            }
        }
        
        fetchRecording()
    }
}


extension Date
{
    func toString(dateFormat format: String ) -> String
    {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = format
        return dateFormatter.string(from: self)
    }

}


func getFileDate(for file: URL) -> Date {
    if let attributes = try? FileManager.default.attributesOfItem(atPath: file.path) as [FileAttributeKey: Any],
        let creationDate = attributes[FileAttributeKey.creationDate] as? Date {
        return creationDate
    } else {
        return Date()
    }
}


struct Recording : Hashable{
    var fileURL: URL
    let createdAt: Date
    var name : String
}
