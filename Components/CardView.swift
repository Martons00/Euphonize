//
//  CardView.swift
//  Euphonize
//
//  Created by Raffaele Martone on 27/06/23.
//

import SwiftUI

struct CardView: View {
    
    var icon : Image
    var text : Text
    var ns: Namespace.ID
    
    init(icon: Image, text: Text, namespace: Namespace.ID) {
        self.icon = icon
        self.text = text
        self.ns = namespace
    }
    
    
    var body: some View{
        GeometryReader{ geo in
            ZStack{
                Color("ButtonTopColor")
                VStack(spacing: 0){
                    ZStack{
                        Color("ButtonTopColor")
                        VStack{
                            icon
                                .resizable()
                                .foregroundColor(.white)
                                .aspectRatio(contentMode: .fit)
                                .frame(width: geo.size.width * 0.6 , height: geo.size.width * 0.6)
                            
                        }
                    }.frame(width: geo.size.width , height: geo.size.height * 0.7)
                    VStack{
                        ZStack{
                            Color("ButtonBottomColor")
                            text
                                .font(.title3)
                                .bold()
                                .foregroundColor(.white)
                        }
                    }.frame(width: geo.size.width , height: geo.size.height * 0.3)
                }
            }.frame(width: geo.size.width , height: geo.size.height)
                .cornerRadius(10.0)
        }
    }
}




struct CardView_Previews: PreviewProvider {
    static var previews: some View {
        CardView(icon: Image("ImgCardFocus"), text: Text("Ciao"), namespace: Namespace.init().wrappedValue)
    }
}
