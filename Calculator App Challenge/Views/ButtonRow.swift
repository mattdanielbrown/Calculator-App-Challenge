//
//  ButtonRow.swift
//  Calculator App Challenge
//
//  Created by Eli Hartnett on 11/7/21.
//

import SwiftUI

struct ButtonRow: View {
    var labels: [String]
    var buttonColors: [Color] = [Color("DarkGray"), Color("DarkGray"), Color("DarkGray"), Color("Orange")]
    var textColors: [Color] = [Color("White"), Color("White"), Color("White"), Color("White")]
    var geo: GeometryProxy
    
    var body: some View {
        
        HStack {
            Spacer()
            // Main rows
            if labels.count == 4 {
                ForEach(0..<labels.count) { index in
                    ButtonView(label: labels[index], buttonColor: buttonColors[index], textColor: textColors[index], geo: geo)
                }
            }
            
            // Last row with long button
            else if labels.count == 3 {
                ButtonView(label: labels[0], buttonColor: buttonColors[0], geo: geo, longButton: true)
                
                ButtonView(label: labels[1], buttonColor: buttonColors[1], geo: geo)
                
                ButtonView(label: labels[2], buttonColor: buttonColors[2], geo: geo)
            }
            
            // Error
            else {
                Text("Error")
            }
            
            Spacer()
        }
    }
}

struct ButtonRow_Previews: PreviewProvider {
    static var previews: some View {
        GeometryReader { geo in
            ButtonRow(labels: ["1", "3", String("\u{00d7}")], geo: geo)
        }
    }
}
