//
//  MainAnimationView.swift
//  Euphonize
//
//  Created by Raffaele Martone on 26/06/23.
//

import Foundation
import SwiftUI

struct MainAnimationView: View {
    @State var start: Double = 0
    @State var progress: Double = 0
    @State var andata = true
    
    let timer = Timer
        .publish(every: 0.2, on: .main, in: .common)
        .autoconnect()
    
    var body: some View {
        VStack {
            ZStack {
                EllipseProgressView(start: start, progress: progress,angle: 0)
                EllipseProgressView(start: start, progress: progress,angle: 90)
                EllipseProgressView(start: start, progress: progress,angle: 180)
                EllipseProgressView(start: start, progress: progress,angle: 270)
            }
            .onReceive(timer) { time in
                if andata{
                    progress = progress + 0.05
                    if progress >= 1.0 {
                        progress = 1.0
                        start = start + 0.05
                        if start >= 1.0 {
                            andata = false
                        }
                    }
                } else {
                    start = start - 0.05
                    if start <= 0.0 {
                        start = 0.0
                        progress = progress - 0.05
                        if progress <= 0.0 {
                            andata = true
                        }
                    }
                }
            }
        }
    }
}

struct EllipseProgressView: View {
    let start : Double
    let progress: Double
    let angle: Double
    
    
    var body: some View {
        if !(start == 1 && progress == 1) {
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
                Ellipse()
                    .trim(from: start, to: progress)
                    .stroke(
                         
                        style: StrokeStyle(
                            lineWidth: 2,
                            lineCap: .round
                        )
                    )
                    .rotationEffect(.degrees(angle + 30))
                    .animation(.easeOut, value: progress)
                    .animation(.easeOut, value: start)
                Ellipse()
                    .trim(from: start, to: progress)
                    .stroke(
                         
                        style: StrokeStyle(
                            lineWidth: 2,
                            lineCap: .round
                        )
                    )
                    .rotationEffect(.degrees(angle + 60))
                    .animation(.easeOut, value: progress)
                    .animation(.easeOut, value: start)
                
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
                Ellipse()
                    .trim(from: start, to: progress)
                    .stroke(
                        style: StrokeStyle(
                            lineWidth: 2,
                            lineCap: .round
                        )
                    )
                    .rotationEffect(.degrees(angle + 15))
                    .animation(.easeOut, value: progress)
                    .animation(.easeOut, value: start)
                Ellipse()
                    .trim(from: start, to: progress)
                    .stroke(
                        style: StrokeStyle(
                            lineWidth: 2,
                            lineCap: .round
                        )
                    )
                    .rotationEffect(.degrees(angle + 45))
                    .animation(.easeOut, value: progress)
                    .animation(.easeOut, value: start)
                Ellipse()
                    .trim(from: start, to: progress)
                    .stroke(
                        style: StrokeStyle(
                            lineWidth: 2,
                            lineCap: .round
                        )
                    )
                    .rotationEffect(.degrees(angle + 75))
                    .animation(.easeOut, value: progress)
                    .animation(.easeOut, value: start)
            }
        }
    }
}

struct MainAnimationView_Previews: PreviewProvider {
    static var previews: some View {
        MainAnimationView()
    }
}
