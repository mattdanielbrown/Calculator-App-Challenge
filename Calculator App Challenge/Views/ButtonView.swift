//
//  ButtonView.swift
//  Calculator App Challenge
//
//  Created by Eli Hartnett on 11/7/21.
//

import SwiftUI

// Main button
struct ButtonView: View {
    
    @EnvironmentObject var CalculatorModel: CalculatorModel
    @Environment(\.colorScheme) var currentMode

    let label: String
    let buttonColor: Color
    var textColor = Color("White")
    
    let geo: GeometryProxy
    var width: CGFloat {
        geo.size.width/5
    }
    var height: CGFloat {
        geo.size.width/5
    }
    
    // For 0 on bottom row
    var longButton = false
    var cornerRadius: CGFloat {
        height/2
    }

    var body: some View {
        Button {
            
            CalculatorModel.buttonPressed(label: self.label)
            
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
                    // Higlight operator white if in use
                        .fill((
                            // Operator and button are either +, -, *, or /
                            ((label == Constants.addition && CalculatorModel.op == Constants.addition)
                             || (label == Constants.subtraction && CalculatorModel.op == Constants.subtraction)
                             || (label == Constants.multiplication && CalculatorModel.op == Constants.multiplication)
                             || (label == Constants.division && CalculatorModel.op == Constants.division))
                            
                            // No new numbers after operator
                            && CalculatorModel.currentNumber == nil) ? (currentMode == .dark ? Color.white : Color.black) : buttonColor)
                        .frame(width: width, height: height)
                }
                
                Text(label)
                    .font(.title)
                    .bold()
                // Switch text color to button color if button highlighted
                    .foregroundColor((
                        // Operator and button are either +, -, *, or /
                        ((label == Constants.addition && CalculatorModel.op == Constants.addition)
                         || (label == Constants.subtraction && CalculatorModel.op == Constants.subtraction)
                         || (label == Constants.multiplication && CalculatorModel.op == Constants.multiplication)
                         || (label == Constants.division && CalculatorModel.op == Constants.division))
                        
                        // No new numbers after operator
                        && CalculatorModel.currentNumber == nil) ? buttonColor : textColor)
            }
        }
    }
}

struct ButtonView_Previews: PreviewProvider {
    static var previews: some View {
        GeometryReader { geo in
            ButtonView(label: "0", buttonColor: Color("Gray"), geo: geo, longButton: false)            .environmentObject(CalculatorModel())

        }
    }
}
