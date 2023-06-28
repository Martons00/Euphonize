//
//  PlayerView.swift
//  Euphonize
//
//  Created by Raffaele Martone on 27/06/23.
//

import SwiftUI

struct PlayerView: View {
    @Binding var TimerModalIsPresented : Bool
    @Binding var audio : Int
    @ObservedObject var audioRecorder : AudioRecorder
    @ObservedObject var player = EuphoManager.shared
    let roomName : String
    
    init(TimerModalIsPresented: Binding<Bool>, audio: Binding<Int>,audioRecorder : AudioRecorder,roomName: String) {
        self._TimerModalIsPresented = TimerModalIsPresented
        self._audio = audio
        self.audioRecorder = audioRecorder
        self.roomName = roomName
    }
    
    
    var recordings: [Recording] {
            return [
                Recording(fileURL: Bundle.main.url(forResource: roomName + "1", withExtension: ".mp3")!, createdAt: Date(), name: roomName + "1"),
                Recording(fileURL: Bundle.main.url(forResource: roomName + "2", withExtension: ".mp3")!, createdAt: Date(), name: roomName + "2"),
                Recording(fileURL: Bundle.main.url(forResource: roomName + "3", withExtension: ".mp3")!, createdAt: Date(), name: roomName + "3")
            ] + audioRecorder.recordings
    }
    
    var body: some View {
        GeometryReader{geo in
            ZStack{
                Color("PlayerBackgroundColor")
                VStack{
                    HStack{
                        Text(((recordings[audio].name.replacingOccurrences(of: roomName + ".", with: "")) as NSString).deletingPathExtension)
                            .font(.title3)
                            .foregroundColor(.white)
                            .padding()
                        Spacer()
                    }.frame(width: geo.size.width,height: geo.size.height * 0.39)
                    VStack{
                        ProgressAudioBarView(recording: recordings[audio], indexAudio: $audio)
                    }.frame(width: geo.size.width,height: geo.size.height * 0.02)
                    VStack{
                        
                    HStack(spacing: 40){
                        Button(action: {
                            audio = Int.random(in: 0..<recordings.count)
                            player.stopPlaying()
                            player.startPlaying(recording: recordings[audio])
                        }) {
                            ZStack {
                                Image(systemName: "shuffle")
                                    .font(.system(size: 20))
                                    .foregroundColor(Color("AnimationColor"))
                            }
                        }
                        Button(action: {
                            if audio != 0{
                                audio = audio - 1
                            }else{
                                audio = recordings.count - 1
                            }
                            player.startPlaying(recording: recordings[audio])
                        }) {
                            ZStack {
                                Image("previousButton")
                                    .font(.system(size: 20))
                                    .foregroundColor(.white)
                            }
                        }
                            Button(action: {
                                if player.isPlaying == false {
                                    player.startPlaying(recording: recordings[audio])
                                }else{
                                    player.stopPlaying()
                                }
                            }) {
                                ZStack {
                                    Circle()
                                        .fill(Color.gray)
                                        .frame(width: 50, height: 50)
                                    
                                    Image(systemName: player.isPlaying ? "stop.fill" : "play.fill")
                                        .font(.system(size: 20))
                                        .foregroundColor(.white)
                                }
                            }
                        Button(action: {
                                if audio != recordings.count - 1 {
                                    audio = audio + 1
                                }else{
                                    audio = 0
                                }
                                player.startPlaying(recording: recordings[audio])
                        }) {
                            ZStack {
                                Image("nextButton")
                                    .font(.system(size: 20))
                                    .foregroundColor(.white)
                            }
                        }
                        Button(action: {
                            player.stopLoop()
                            self.TimerModalIsPresented = true
                        }) {
                            ZStack {
                                Image(systemName: "timer")
                                    .font(.system(size: 20))
                                    .foregroundColor(player.isInLoop ? .white : Color("AnimationColor"))
                            }
                        }
                    }
                    }.frame(width: geo.size.width,height: geo.size.height * 0.59)
                }
            }.cornerRadius(10.0)
        }
    }
}


