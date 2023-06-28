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
    
    var body: some View {
        HStack{
            HStack{
                Button(action: {
                    withAnimation{
                        screens = .main
                    }
                }, label: {
                    Text("< Back")
                        .font(.title3)
                        .bold()
                        .foregroundColor(.white)
                })
                Spacer()
            }
            HStack{
                Text(roomName)
                    .font(.title2)
                    .bold()
                    .foregroundColor(.white)
                    .multilineTextAlignment(.center)
            }
            HStack{
                Spacer()
                Button(action: {
                    RecordingModalIsPresented = true
                }, label: {
                    Text("+")
                        .font(.title3)
                        .bold()
                        .padding(.horizontal)
                        .foregroundColor(.white)
                })
            }
        }
        .padding()
    }
}

