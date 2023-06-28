//
//  MainView.swift
//  Euphonize
//
//  Created by Raffaele Martone on 27/06/23.
//

import SwiftUI

struct MainView: View {
    
    @Binding var screens : Screens
    @Binding var rooms : Rooms
    var ns: Namespace.ID
    
    var body: some View {
        GeometryReader{ geo in
            ZStack{
                Color("BackgroundColor").ignoresSafeArea()
                VStack{
                    VStack{
                        MainAnimationView()
                            .foregroundColor(Color("AnimationColor"))
                            .frame(width: geo.size.width * 0.8, height: geo.size.width * 0.3)
                    }
                    .frame(height: geo.size.height * 0.5)
                    VStack{
                        Text("Rooms")
                            .foregroundColor(.white)
                            .font(.largeTitle)
                            .bold()
                        HStack(spacing: 20.0){
                            Button(action: {
                                withAnimation{
                                    screens = .rooms
                                    rooms = .focus
                                }
                            }){
                                CardView(icon: Image("ImgCardFocus"), text: Text("Focus"), namespace: ns)
                                    .frame(width: geo.size.width * 0.4, height: geo.size.height * 0.25)
                                    .matchedGeometryEffect(id: "CardFocus", in: ns)
                            }
                            Button(action: {
                                withAnimation{
                                    screens = .rooms
                                    rooms = .relax
                                }
                            }){
                                CardView(icon: Image("ImgCardRelax"), text: Text("Relax"), namespace: ns)
                                    .frame(width: geo.size.width * 0.4, height: geo.size.height * 0.25)
                                    .matchedGeometryEffect(id: "CardRelax", in: ns)
                            }
                        }
                        .frame(height: geo.size.height * 0.4)
                    }
                    .frame(height: geo.size.height * 0.5)
                }
            }
        }
    }
}

struct MainView_Previews: PreviewProvider {
    static var previews: some View {
        MainView(screens: .constant(.main), rooms: .constant(.relax), ns: Namespace.init().wrappedValue)
    }
}

