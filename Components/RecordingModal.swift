//
//  RecordingModal.swift
//  EuphonizeProject
//
//  Created by Raffaele Martone on 28/06/23.
//

import SwiftUI

struct RecordingModal: View {
    @ObservedObject var audioRecorder : AudioRecorder
    @Binding var recordingName : String
    @Binding var SaveAlertIsPresented : Bool
    
    var body: some View {
        GeometryReader{geo in
            ZStack{
                Color("ButtonTopColor").ignoresSafeArea()
                VStack{
                    HStack{
                        RoundedRectangle(cornerRadius: 10)
                            .frame(width: 50,height: 5)
                            .foregroundColor(.gray)
                    }.frame(height: 50)
                    Text(LocalizedStringKey(".RecordYourAudioTitle"))
                        .font(.title)
                        .foregroundColor(.white)
                        .padding()
                    Text(NSLocalizedString(".RecordYourAudioSubTitle", comment: ""))
                        .foregroundColor(.white)
                        .multilineTextAlignment(.center)
                    RecordingAnimationView(audioRecorder : audioRecorder)
                        .foregroundColor(.white)
                        .frame(width: geo.size.width * 0.8,height: geo.size.height * 0.2)
                        .padding()
                    Spacer()
                    Button(action: {
                        if audioRecorder.isRecording == false {
                            self.audioRecorder.startRecording()
                        }else{
                            self.audioRecorder.stopRecording()
                            self.recordingName = ""
                            self.SaveAlertIsPresented = true
                        }
                    }) {
                        Image(systemName:audioRecorder.isRecording ? "stop.circle.fill" : "record.circle.fill")
                            .resizable()
                            .frame(width: 50,height: 50)
                            .foregroundColor(.white)
                    }
                    
                    Spacer()
                }
            }
        }
    }
}
//
//struct RecordingModal_Previews: PreviewProvider {
//    static var previews: some View {
//        RecordingModal()
//    }
//}
