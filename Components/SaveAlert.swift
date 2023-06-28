//
//  SaveAlert.swift
//  EuphonizeProject
//
//  Created by Raffaele Martone on 28/06/23.
//

import SwiftUI

struct SaveAlert: View {
    @ObservedObject var audioRecorder : AudioRecorder
    @Binding var recordingName : String
    @Binding var SaveAlertIsPresented : Bool
    
    var body: some View {
        TextField(NSLocalizedString("Recording name", comment: ""), text: $recordingName)
            .padding()
            .foregroundColor(.black)
        Button(action: {
            self.audioRecorder.deleteRecording(urlsToDelete: [audioRecorder.recordings.last!.fileURL])
            self.SaveAlertIsPresented = false
        }) {
            Text(NSLocalizedString("Cancel", comment: ""))
                .foregroundColor(.white)
        }
        
        Button(action: {
            self.audioRecorder.editRecordingName(name: recordingName, recording: audioRecorder.recordings.last!)
            self.SaveAlertIsPresented = false
        }) {
            Text(NSLocalizedString("Save", comment: ""))
                .foregroundColor(.white)
        }
    }
}

//struct SaveAlert_Previews: PreviewProvider {
//    static var previews: some View {
//        SaveAlert()
//    }
//}
