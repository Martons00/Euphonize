//
//  RoomsLobbyView.swift
//  EuphonizeProject
//
//  Created by Raffaele Martone on 27/06/23.
//

import SwiftUI

struct RoomsLobbyView: View {
    @Binding var screens : Screens
    @Binding var rooms : Rooms
    var ns: Namespace.ID
    var body: some View {
        GeometryReader{ geo in
            switch rooms {
            case .relax:
                RoomView(screens: $screens, rooms: $rooms,roomName: "Relax", ns: ns)
                    .matchedGeometryEffect(id: "CardRelax", in: ns)
                    .position(x: geo.size.width/2,y: geo.size.height/2)
            case .focus:
                RoomView(screens: $screens, rooms: $rooms,roomName: "Focus", ns: ns)
                    .matchedGeometryEffect(id: "CardFocus", in: ns)
                    .position(x: geo.size.width/2,y: geo.size.height/2)
            }
        }
    }
}

struct RoomsLobbyView_Previews: PreviewProvider {
    static var previews: some View {
        RoomsLobbyView(screens: .constant(.main), rooms: .constant(.relax), ns: Namespace.init().wrappedValue)
    }
}
