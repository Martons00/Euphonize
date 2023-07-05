//
//  ProgressAudioBarView.swift
//  EuphonizeProject
//
//  Created by Raffaele Martone on 28/06/23.
//

import SwiftUI

struct ProgressAudioBarView: View {
    let recording: Recording
    @Binding var indexAudio : Int
    @ObservedObject var player = AudioPlayer.shared
    @State var progress = 0.0
    let timer = Timer
        .publish(every: 0.1, on: .main, in: .common)
        .autoconnect()
    
    var duration: Double {
        return self.player.getDuration(url: recording.fileURL)
    }

    
    var body: some View {
        VStack {
            ZStack {
                ProgressBarView(duration: duration, progress: progress)
            }
            .onChange(of: indexAudio){ _ in
                progress = 0.0
            }
            .onReceive(timer) { time in
                if player.isPlaying {
                    progress = progress + 0.1
                } else {
                        progress = 0.0
                    }
            }
        }
    }
    
}


struct ProgressBarView: View {
    let duration : Double
    let progress : Double
    
       
    var body: some View {
        let proportion = (progress * 360)/duration
        ZStack{
            Color("BackgroundColor")
            HStack{
                if(progress/duration) < 1{
                    Rectangle()
                        .frame(width:CGFloat(proportion),height: 4)
                        .foregroundColor(.white)
                        .animation(.easeOut, value: proportion)
                    Spacer()
                }else{
                        Rectangle()
                            .frame(width:360,height: 4)
                            .foregroundColor(.white)
                }
            }
        }.frame(width: 360,height: 4)
    }
}



