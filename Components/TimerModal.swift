//
//  TimerModal.swift
//  EuphonizeProject
//
//  Created by Raffaele Martone on 28/06/23.
//

import SwiftUI

struct TimerModal: View {
    @Binding var selectedInterval : Int
    @Binding var TimerModalIsPresented : Bool
    @ObservedObject var audioRecorder : AudioRecorder
    @Binding var audio : Int
    let roomName : String
    var recordings: [Recording] {
            return [
                Recording(fileURL: Bundle.main.url(forResource: roomName + "1", withExtension: ".mp3")!, createdAt: Date(), name: roomName + "1"),
                Recording(fileURL: Bundle.main.url(forResource: roomName + "2", withExtension: ".mp3")!, createdAt: Date(), name: roomName + "2"),
                Recording(fileURL: Bundle.main.url(forResource: roomName + "3", withExtension: ".mp3")!, createdAt: Date(), name: roomName + "3")
            ] + audioRecorder.recordings
    }
    
    let euphoManager = EuphoManager.shared
    
    var body: some View {
        ZStack{
            Color("ButtonTopColor").ignoresSafeArea()
            VStack{
                HStack{
                    Button(action: {
                        TimerModalIsPresented = false
                    }) {
                        VStack{
                            Text(NSLocalizedString(".Cancel", comment: ""))
                        }.frame(width: 100)
                    }
                    Spacer()
                    RoundedRectangle(cornerRadius: 10)
                        .frame(width: 50,height: 5)
                        .foregroundColor(.gray)
                    Spacer()
                    Button(action: {
                        TimerModalIsPresented = false
                        if euphoManager.isPlaying{
                            euphoManager.stopPlaying()
                        }
                        euphoManager.startPlayingInLoop(recording: recordings[audio],selectedInterval: selectedInterval)
                    }) {
                        VStack{
                            Text(NSLocalizedString(".Done", comment: ""))
                        }.frame(width: 100)
                    }
                }
                .padding()
                .frame(height: 50)
                Text(NSLocalizedString(".TimerTitle", comment: ""))
                    .font(.title)
                    .foregroundColor(.white)
                    .padding()
                Text(NSLocalizedString(".TimerSubTitle", comment: ""))
                    .foregroundColor(.white)
                    .multilineTextAlignment(.center)
                Spacer()
                let minutes = Array(stride(from: 10, through: 60, by: 5))
                Picker("Minuti", selection: $selectedInterval) {
                    ForEach(minutes, id: \.self) { minute in
                        Text("\(minute) m")
                            .foregroundColor(.white)
                    }
                }.pickerStyle(.wheel)
                
            }
        }
    }
}

