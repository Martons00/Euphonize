//
//  CustomTopBarNavigationView.swift
//  EuphonizeProject
//
//  Created by Raffaele Martone on 28/06/23.
//

import SwiftUI

struct CustomTopBarNavigationView: View {
    
    @Binding var screens : Screens
    let roomName : String
    @Binding var RecordingModalIsPresented : Bool
    @ObservedObject var player = EuphoManager.shared
    
    var body: some View {
        HStack{
            HStack{
                Button(action: {
                    player.stopLoop()
                    player.stopPlaying()
                    withAnimation{
                        screens = .main
                    }
                }, label: {
                    HStack(alignment:.top) {
                        Text(Image(systemName: "chevron.left"))
                            .font(.title3)
                            .fontWeight(.semibold)
                            .foregroundColor(.white)
                        +
                        Text(NSLocalizedString(".Back", comment: ""))
                            .font(.title3)
                            .fontWeight(.semibold)
                            .foregroundColor(.white)
                    }
                })
                Spacer()
            }
            HStack{
                Text(NSLocalizedString(roomName, comment: ""))
                    .font(.title2)
                    .bold()
                    .foregroundColor(.white)
                    .multilineTextAlignment(.center)
            }
            HStack{
                Spacer()
                Button(action: {
                    player.stopLoop()
                    player.stopPlaying()
                    RecordingModalIsPresented = true
                }, label: {
                    Text("+")
                        .font(.title2)
                        .bold()
                        .padding(.horizontal)
                        .foregroundColor(.white)
                })
            }
        }
        .padding()
    }
}

