//
//  AnimationLobbyView.swift
//  EuphonizeProject
//
//  Created by Raffaele Martone on 28/06/23.
//

import SwiftUI

struct AnimationLobbyView: View {
    @Binding var rooms : Rooms
    var ns: Namespace.ID
    var body: some View {
        GeometryReader{ geo in
            switch rooms {
            case .relax:
                RelaxAnimationView()
                    .foregroundColor(Color("AnimationColor"))
                    .frame(width: geo.size.width,height: geo.size.height)
            case .focus:
                FocusAnimationView().foregroundColor(Color("AnimationColor"))
                    .frame(width: geo.size.width,height: geo.size.height)
            }
        }
    }
}

struct AnimationLobbyView_Previews: PreviewProvider {
    static var previews: some View {
        AnimationLobbyView( rooms: .constant(.relax), ns: Namespace.init().wrappedValue)
    }
}
