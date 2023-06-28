//
//  ContentView.swift
//  EuphonizeProject
//
//  Created by Raffaele Martone on 27/06/23.
//

import SwiftUI

enum Screens {
    case main
    case rooms
}

enum Rooms {
    case relax
    case focus
}
struct ContentView: View {
    @State var screens : Screens = .main
    @State var rooms : Rooms = .relax
    @State var opacity = 0.0
    @Namespace var ns
    
    var body: some View {
        ZStack{
            Color("BackgroundColor").ignoresSafeArea()
            switch screens{
            case .main:
                MainView(screens: $screens, rooms: $rooms, ns: ns)
                    .opacity(opacity)
            case .rooms:
                RoomsLobbyView(screens: $screens, rooms: $rooms, ns: ns)
            }
            
        }
        .onChange(of: screens){ _ in
                opacity = 0.0
            withAnimation(.linear(duration: 1.5)){
                opacity = 1.0
            }
        }
        .onAppear(){
            withAnimation(.linear(duration: 1)){
                opacity = 1.0
            }
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
