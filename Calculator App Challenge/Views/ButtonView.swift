//
//  ButtonView.swift
//  Calculator App Challenge
//
//  Created by Eli Hartnett on 11/7/21.
//

import SwiftUI

struct ButtonView: View {
    let label: String
    let buttonColor: Color
    var textColor = Color("White")
    
    var geo: GeometryProxy
    var width: CGFloat {
        geo.size.width/5
    }
    var height: CGFloat {
        geo.size.width/5
    }
    
    var longButton = false
    var cornerRadius: CGFloat {
        height/2
    }

    var body: some View {
        Button {
            //TODO: display button press on calculator
        } label: {
            ZStack {
                
                if longButton {
                    Rectangle()
                        .fill(buttonColor)
                        .cornerRadius(cornerRadius)
                        .frame(width: (width*2) + 10, height: height)
                }
                else {
                    Circle()
                        .fill(buttonColor)
                        .frame(width: width, height: height)
                }
                
                Text(label)
                    .font(.title)
                    .bold()
                    .foregroundColor(textColor)
            }
        }
    }
}

struct ButtonView_Previews: PreviewProvider {
    static var previews: some View {
        GeometryReader { geo in
            ButtonView(label: "0", buttonColor: Color("Gray"), geo: geo, longButton: false)
        }
    }
}
