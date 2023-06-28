//
//  RelaxAnimationView.swift
//  EuphonizeProject
//
//  Created by Raffaele Martone on 28/06/23.
//

import SwiftUI

struct RelaxAnimationView: View {
    @ObservedObject var player = EuphoManager.shared
    @State var start: Double = 0.3
    @State var progress: Double = 0.3
    @State var start2: Double = 0.7
    @State var progress2: Double = 0.7
    @State var andata = true
    @State var time : Double = 0.0
    let timer = Timer
        .publish(every: 0.3, on: .main, in: .common)
        .autoconnect()
    var body: some View {
        VStack {
            ZStack {
                FlowerProgressView(start: start, progress: progress,start2: progress2,progress2: start2,angle: 0)
                FlowerProgressView(start: start, progress: progress,start2: progress2,progress2: start2,angle: 0)
                    .rotationEffect(Angle(degrees: 90))
                FlowerProgressView(start: start, progress: progress,start2: progress2,progress2: start2,angle: 0)
                    .rotationEffect(Angle(degrees: 180))
                FlowerProgressView(start: start, progress: progress,start2: progress2,progress2: start2,angle: 0)
                    .rotationEffect(Angle(degrees: 270))
            }.frame(width: 100, height: 300)
                .onReceive(timer) { time in
                    if self.player.isPlaying {
                        if andata{
                            progress = progress + 0.01
                            progress2 = progress2 - 0.01
                            
                            if progress >= 0.7 {
                                progress = 0.7
                                progress2 = 0.3
                                start = start + 0.01
                                start2 = start2 - 0.01
                                
                                if start >= 0.7 {
                                    start = 0.7
                                    start2 = 0.3
                                    andata = false
                                }
                                
                            }
                        } else {
                            start = start - 0.01
                            start2 = start2 + 0.01
                            
                            if start <= 0.3 {
                                start = 0.3
                                start2 = 0.7
                                progress = progress - 0.01
                                progress2 = progress2 + 0.01
                                
                                if progress <= 0.3 {
                                    andata = true
                                    progress = 0.3
                                    progress2 = 0.7
                                }
                            }
                        }
                   }
                }
        }
    }
    
}


struct FlowerProgressView: View {
    let start : Double
    let progress: Double
    let start2 : Double
    let progress2: Double
    let angle: Double
    
    
    var body: some View {
        ZStack {
            Ellipse()
                .trim(from: start, to: progress)
                .stroke(
                    style: StrokeStyle(
                        lineWidth: 2,
                        lineCap: .round
                    )
                )
                .rotationEffect(.degrees(angle))
                .animation(.easeOut, value: progress)
                .animation(.easeOut, value: start)
                .padding(.leading, 24.0)
            
            Ellipse()
                .trim(from: start2, to: progress2)
                .stroke(
                    style: StrokeStyle(
                        lineWidth: 2,
                        lineCap: .round
                    )
                )
                .rotationEffect(.degrees(angle + 180))
                .animation(.easeOut, value: progress2)
                .animation(.easeOut, value: start2)
                .padding(.trailing, 24.0)
        }.padding(.bottom,150)
        
        ZStack {
            Ellipse()
                .trim(from: start, to: progress)
                .stroke(
                    style: StrokeStyle(
                        lineWidth: 2,
                        lineCap: .round
                    )
                )
                .rotationEffect(.degrees(angle))
                .animation(.easeOut, value: progress)
                .animation(.easeOut, value: start)
                .padding(.leading, 24.0)
            
            Ellipse()
                .trim(from: start2, to: progress2)
                .stroke(
                    style: StrokeStyle(
                        lineWidth: 2,
                        lineCap: .round
                    )
                )
                .rotationEffect(.degrees(angle + 180))
                .animation(.easeOut, value: progress2)
                .animation(.easeOut, value: start2)
                .padding(.trailing, 24.0)
        }.padding(.bottom,150)
            .rotationEffect(Angle(degrees: angle+15))
        ZStack {
            Ellipse()
                .trim(from: start, to: progress)
                .stroke(
                    style: StrokeStyle(
                        lineWidth: 2,
                        lineCap: .round
                    )
                )
                .rotationEffect(.degrees(angle))
                .animation(.easeOut, value: progress)
                .animation(.easeOut, value: start)
                .padding(.leading, 24.0)
            
            Ellipse()
                .trim(from: start2, to: progress2)
                .stroke(
                    style: StrokeStyle(
                        lineWidth: 2,
                        lineCap: .round
                    )
                )
                .rotationEffect(.degrees(angle + 180))
                .animation(.easeOut, value: progress2)
                .animation(.easeOut, value: start2)
                .padding(.trailing, 24.0)
        }.padding(.bottom,150)
            .rotationEffect(Angle(degrees: angle+30))
        ZStack {
            Ellipse()
                .trim(from: start, to: progress)
                .stroke(
                    style: StrokeStyle(
                        lineWidth: 2,
                        lineCap: .round
                    )
                )
                .rotationEffect(.degrees(angle))
                .animation(.easeOut, value: progress)
                .animation(.easeOut, value: start)
                .padding(.leading, 24.0)
            
            Ellipse()
                .trim(from: start2, to: progress2)
                .stroke(
                    style: StrokeStyle(
                        lineWidth: 2,
                        lineCap: .round
                    )
                )
                .rotationEffect(.degrees(angle + 180))
                .animation(.easeOut, value: progress2)
                .animation(.easeOut, value: start2)
                .padding(.trailing, 24.0)
        }.padding(.bottom,150)
            .rotationEffect(Angle(degrees: angle+45))
        ZStack {
            Ellipse()
                .trim(from: start, to: progress)
                .stroke(
                    style: StrokeStyle(
                        lineWidth: 2,
                        lineCap: .round
                    )
                )
                .rotationEffect(.degrees(angle))
                .animation(.easeOut, value: progress)
                .animation(.easeOut, value: start)
                .padding(.leading, 24.0)
            
            Ellipse()
                .trim(from: start2, to: progress2)
                .stroke(
                    style: StrokeStyle(
                        lineWidth: 2,
                        lineCap: .round
                    )
                )
                .rotationEffect(.degrees(angle + 180))
                .animation(.easeOut, value: progress2)
                .animation(.easeOut, value: start2)
                .padding(.trailing, 24.0)
        }.padding(.bottom,150)
            .rotationEffect(Angle(degrees: angle+60))
        ZStack {
            Ellipse()
                .trim(from: start, to: progress)
                .stroke(
                    style: StrokeStyle(
                        lineWidth: 2,
                        lineCap: .round
                    )
                )
                .rotationEffect(.degrees(angle))
                .animation(.easeOut, value: progress)
                .animation(.easeOut, value: start)
                .padding(.leading, 24.0)
            
            Ellipse()
                .trim(from: start2, to: progress2)
                .stroke(
                    style: StrokeStyle(
                        lineWidth: 2,
                        lineCap: .round
                    )
                )
                .rotationEffect(.degrees(angle + 180))
                .animation(.easeOut, value: progress2)
                .animation(.easeOut, value: start2)
                .padding(.trailing, 24.0)
        }.padding(.bottom,150)
            .rotationEffect(Angle(degrees: angle + 75))
        
    }
}

struct RelaxAnimationView_Previews: PreviewProvider {
    static var previews: some View {
        RelaxAnimationView()
    }
}
