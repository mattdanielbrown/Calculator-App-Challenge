//
//  Calculator_App_ChallengeApp.swift
//  Calculator App Challenge
//
//  Created by Eli Hartnett on 11/7/21.
//

import SwiftUI

@main
struct Calculator_App_Challenge: App {
    var body: some Scene {
        WindowGroup {
            HomeView().environmentObject(CalculatorModel())
        }
    }
}
