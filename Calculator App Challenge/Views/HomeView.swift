//
//  ContentView.swift
//  Calculator App Challenge
//
//  Created by Eli Hartnett on 11/7/21.
//

import SwiftUI

struct HomeView: View {
    
    @EnvironmentObject var CalculatorModel: CalculatorModel
    
    var body: some View {
        GeometryReader { geo in
            
            VStack(alignment: .trailing, spacing: 20.0) {
                
                Spacer()
                
                Text(CalculatorModel.displayText)
                    .font(.system(size: 60))
                    .foregroundColor(Color.white)
                    .lineLimit(1)
                    .padding(.bottom)
                    .padding(.trailing, 45)
                    
                ButtonRow(labels: ["CE", "", "", String("\u{00f7}")], buttonColors: [Color("Gray"), Color("Gray"), Color("Gray"), Color("Orange")], textColors: [Color("Black"), Color("White"), Color("White"), Color("White")], geo: geo)
                
                ButtonRow(labels: ["7", "8", "9", String("\u{00d7}")], geo: geo)
                
                ButtonRow(labels: ["4", "5", "6", String("\u{00d7}")], geo: geo)
                
                ButtonRow(labels: ["1", "2", "3", String("\u{00d7}")], geo: geo)
                
                ButtonRow(labels: ["0", ".", String("\u{003d}")], geo: geo)
            }
            .frame(width: geo.size.width)
            .padding(.bottom)
        }
        .background(Color("Black"))
    }
}


struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        HomeView()
            .environmentObject(CalculatorModel())
    }
}