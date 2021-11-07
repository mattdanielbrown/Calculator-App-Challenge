//
//  LongButtonView.swift
//  Calculator App Challenge
//
//  Created by Eli Hartnett on 11/7/21.
//

import SwiftUI

struct LongButtonView: View {
    let label: String
    let buttonColor: Color
    let width: CGFloat
    let height: CGFloat
    let cornerRadius: CGFloat
    
    var body: some View {
        Button {
            //TODO: display button press on calculator
        } label: {
            ZStack {
                
                VStack {
                    Rectangle()
                        .fill(buttonColor)
                        .cornerRadius(cornerRadius)
                        .frame(width: width, height: height)
                }
                
                Text(label)
                    .font(.title)
                    .bold()
                    .foregroundColor(Color.white)
            }
        }
    }
}

struct LongButtonView_Previews: PreviewProvider {
    static var previews: some View {
        LongButtonView(label: "0", buttonColor: Color("Gray"), width: 220, height: 100, cornerRadius: 50)
            .previewLayout(.fixed(width: 220, height: 100))
    }
}
