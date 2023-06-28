//
//  FocusAnimationView.swift
//  EuphonizeProject
//
//  Created by Raffaele Martone on 28/06/23.
//

import SwiftUI

struct FocusAnimationView: View {
    
    @ObservedObject var player = EuphoManager.shared
    @State var start: Double = 0.0
    @State var progress: Double = 0.0
    @State var andata = true
    @State var time : Double = 0.0
    let timer = Timer
        .publish(every: 0.3, on: .main, in: .common)
        .autoconnect()
    var body: some View {
        VStack {
            ZStack {
                TriangularProgressView(progress: progress, start: start, angle: 0)
                TriangularProgressView(progress: progress, start: start, angle: 180)
            }
            .onReceive(timer) { time in
                if self.player.isPlaying{
                if andata{
                    progress = progress + 0.01
                    
                    if progress >= 1 {
                        progress = 1
                        start = start + 0.01
                        
                        if start >= 1 {
                            start = 1
                            andata = false
                        }
                        
                    }
                } else {
                    start = start - 0.01
                    
                    if start <= 0 {
                        start = 0
                        progress = progress - 0.01
                        
                        if progress <= 0 {
                            andata = true
                            progress = 0
                        }
                    }
               }
            }
        }
        }
    }
    
}


struct TriangularProgressView: View {
    @State private var rotation: Double = 0.0
    let progress : Double
    let start: Double
    let angle : Double
    
    
    var body: some View {
        Triangle()
            .trim(from: start, to: progress)
            .stroke(
                style: StrokeStyle(
                    lineWidth: 2,
                    lineCap: .round
                )
            )
            .rotationEffect(.degrees(rotation))
            .frame(width: 200,height: 200)
            .animation(.easeOut, value: progress)
            .animation(.easeOut, value: start)
            .animation(Animation.linear(duration: 10).repeatForever(autoreverses: false))
            .onAppear {
                self.rotation = 360.0
            }
            .rotationEffect(Angle(degrees: angle + rotation))
       Triangle()
            .trim(from: start, to: progress)
            .stroke(
                style: StrokeStyle(
                    lineWidth: 2,
                    lineCap: .round
                )
            )
            .rotationEffect(.degrees(rotation))
            .frame(width: 200,height: 200)
            .animation(.easeOut, value: progress)
            .animation(.easeOut, value: start)
            .animation(Animation.linear(duration: 10).repeatForever(autoreverses: false))
            .onAppear {
                self.rotation = 360.0
            }
            .rotationEffect(Angle(degrees: angle + 30  + rotation))
        Triangle()
            .trim(from: start, to: progress)
            .stroke(
                style: StrokeStyle(
                    lineWidth: 2,
                    lineCap: .round
                )
            )
            .rotationEffect(.degrees(rotation))
            .frame(width: 200,height: 200)
            .animation(.easeOut, value: progress)
            .animation(.easeOut, value: start)
            .animation(Animation.linear(duration: 10).repeatForever(autoreverses: false))
            .onAppear {
                self.rotation = 360.0
            }

            .rotationEffect(Angle(degrees: angle + 60  + rotation))
        Triangle()
            .trim(from: start, to: progress)
            .stroke(
                style: StrokeStyle(
                    lineWidth: 2,
                    lineCap: .round
                )
            )
            .rotationEffect(.degrees(rotation))
            .frame(width: 200,height: 200)
            .animation(.easeOut, value: progress)
            .animation(.easeOut, value: start)
            .animation(Animation.linear(duration: 10).repeatForever(autoreverses: false))
            .onAppear {
                self.rotation = 360.0
            }

            .rotationEffect(Angle(degrees: angle + 90  + rotation))
        Triangle()
            .trim(from: start, to: progress)
            .stroke(
                style: StrokeStyle(
                    lineWidth: 2,
                    lineCap: .round
                )
            )
            .rotationEffect(.degrees(rotation))
            .frame(width: 200,height: 200)
            .animation(.easeOut, value: progress)
            .animation(.easeOut, value: start)
            .animation(Animation.linear(duration: 10).repeatForever(autoreverses: false))
            .onAppear {
                self.rotation = 360.0
            }

            .rotationEffect(Angle(degrees: angle + 120  + rotation))
        Triangle()
            .trim(from: start, to: progress)
            .stroke(
                style: StrokeStyle(
                    lineWidth: 2,
                    lineCap: .round
                )
            )
            .rotationEffect(.degrees(rotation))
            .frame(width: 200,height: 200)
            .animation(.easeOut, value: progress)
            .animation(.easeOut, value: start)
            .animation(Animation.linear(duration: 10).repeatForever(autoreverses: false))
            .onAppear {
                self.rotation = 360.0
            }

            .rotationEffect(Angle(degrees: angle + 150  + rotation))
        
    }
}


struct Triangle: Shape {
    func path(in rect: CGRect) -> Path {
        var path = Path()
        path.move(to: CGPoint(x: rect.midX, y: rect.minY))
        path.addLine(to: CGPoint(x: rect.maxX, y: rect.maxY))
        path.addLine(to: CGPoint(x: rect.minX, y: rect.maxY))
        path.addLine(to: CGPoint(x: rect.midX, y: rect.minY))
        return path
    }
}


struct FocusAnimationView_Previews: PreviewProvider {
    static var previews: some View {
        FocusAnimationView()
    }
}
