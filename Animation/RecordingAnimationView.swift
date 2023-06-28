//
//  RecordingAnimationView.swift
//  EuphonizeProject
//
//  Created by Raffaele Martone on 28/06/23.
//

import SwiftUI

struct RecordingAnimationView: View {
    let timer = Timer
        .publish(every: 0.1, on: .main, in: .common)
        .autoconnect()
    @ObservedObject var audioRecorder : AudioRecorder
    
    var body: some View {
        GeometryReader{geo in
            HStack(spacing: 2){
                switch audioRecorder.isRecording{
                case true:
                    ForEach(0..<20){ index in
                        ProgessRect(height: geo.size.height)
                            .position(y: geo.size.height/2)
                    }
                case false:
                    ForEach(0..<20){ index in
                        NoProgessRect(height: geo.size.height)
                            .position(y: geo.size.height/2)
                    }
                }
            }.padding()
        }
    }
}
struct NoProgessRect: View{
    let height : Double
    var body: some View{
        
        RoundedRectangle(cornerRadius: 10)
            .frame(width: 6, height: 20.0)
            .animation(.linear, value: 20.0)
        
    }
}

struct ProgessRect: View{
    
    @State var progress = 20.0
    @State var reset = Bool.random()
    let height : Double
    @State var interval = Double.random(in: 0.3..<0.8)
    var body: some View{
        let timer = Timer
            .publish(every: interval, on: .main, in: .common)
            .autoconnect()
        RoundedRectangle(cornerRadius: 10)
            .frame(width: 6, height: progress)
            .animation(.linear, value: progress)
        
            .onReceive(timer){ _ in
                reset.toggle()
                if reset{
                    progress = Double.random(in: 50.0..<height)
                    withAnimation(.linear(duration: interval)){
                        progress = Double.random(in: 10.0..<30.0)
                    }
                }else{
                    progress = Double.random(in: 10.0..<30.0)
                    withAnimation(.linear(duration: interval)){
                        progress = Double.random(in: 50.0..<height)
                    }
                }
            }
    }
}



