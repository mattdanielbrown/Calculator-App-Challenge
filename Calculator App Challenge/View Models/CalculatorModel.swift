//
//  CalculatorModel.swift
//  Calculator App Challenge
//
//  Created by Eli Hartnett on 11/7/21.
//

import Foundation

class CalculatorModel: ObservableObject {
    
    @Published var displayText = "0"
    
    // Published so ButtonView knows to stop highlighting an operator when a number is being typed
    @Published var currentNumber:Double?
    var previousNumber:Double?
    
    var total:Double = 0
    // Published so ButtonView knows to stop highlighting an operator when a number is being typed
    @Published var op:String?
    
    var decimalPlace = 0
    var decimalFlag = false
    
    // Called each time any input is received
    func buttonPressed (label: String) {
        
        // Input is a number
        if Double(label) != nil {
            
            // Building first number
            if previousNumber == nil {
                buildNumber(number: label)
            }
            // Building second number
            else {
                buildNumber(number: label)
            }
            
            // Display updated input after formatting (current number is always what is being typed, current switches to previous after an operator)
            displayText = formatNumber(number: currentNumber!)
        }
        
        // Input is an operator
        else {
            
            // If numbers and operators chained together, update total and display formatted value before pressing equals
            if previousNumber != nil && currentNumber != nil && (label == Constants.addition || label == Constants.subtraction || label == Constants.multiplication || label == Constants.division) {
                calculate()
                displayText = formatNumber(number: total)
            }
            
            setOp(op: label)
        }
        
        // Start counting decimal places if operator was a decimal
        if decimalFlag {
            decimalPlace += 1
        }
    }
    
    // Logic to turn string input into number
    func buildNumber (number: String) {
        // No decimal used, number will increase by a power of 10 each time (1, 1x, 1xx)
        if !decimalFlag {
            currentNumber = (currentNumber ?? 0) * pow(10, 1) + (Double(number)!)
        }
        
        // Decimal used, decimal power will increase making the increment amount decrease by a power of 10 each time (1, 1.x, 1.xx)
        else {
            currentNumber = (currentNumber ?? 0) + (Double(number)! / (pow(10, Double(decimalPlace))))
        }
    }
    
    // Adds commas, keeps track of decimal rounding, keeps track of trailing 0's
    func formatNumber (number: Double) -> String {
        
        let numberFormatter = NumberFormatter()
        
        // Adds commas if number is long enough
        numberFormatter.numberStyle = .decimal
        
        // Special case for if user types something such as 0.0, .00, .000, etc. because trailing 0s are needed here
        if currentNumber == 0 && decimalFlag {
            //Keep trailing zeros if typing long decimal with no current numbers
            numberFormatter.maximumFractionDigits = 10
            numberFormatter.minimumFractionDigits = decimalPlace <= 10 ? decimalPlace : 10
        }
        else {
            numberFormatter.maximumFractionDigits = 10
        }
        
        return numberFormatter.string(from: NSNumber(value:number))!
    }
    
    // Use values to perform specified operation
    func calculate () {
        switch self.op {
            
        case Constants.addition:
            total = (previousNumber ?? 0) + (currentNumber ?? 0)
            
        case Constants.subtraction:
            total = (previousNumber ?? 0) - (currentNumber ?? 0)
            
        case Constants.multiplication:
            total = (previousNumber ?? 0) * (currentNumber ?? 1)
            
        case Constants.division:
            if currentNumber == 0 {
                displayText = "Error"
            }
            else {
                total = (previousNumber ?? 0) / (currentNumber ?? 1)
            }
            
            // Equals pressed without operator, saves current number into total
        default:
            if currentNumber != nil {
                total = currentNumber!
            }
            
            // If negation has been applied a number, total needs to be updated
            else if previousNumber != nil {
                total = previousNumber!
            }
            displayText = formatNumber(number: total)
        }
        
        self.op = nil
        previousNumber = total
        currentNumber = nil
    }
    
    func setOp (op: String) {
        switch op {
            
        case Constants.addition, Constants.subtraction, Constants.multiplication, Constants.division:
            self.op = op
            decimalPlace = 0
            decimalFlag = false
            
            if previousNumber == nil {
                previousNumber = 0
            }
            
            previousNumber! += Double(currentNumber ?? 0)
            
            currentNumber = nil
            
        case "CE":
            self.op = nil
            previousNumber = nil
            currentNumber = nil
            total = 0
            decimalFlag = false
            decimalPlace = 0
            displayText = "0"
            
        case Constants.equals:
            calculate()
            displayText = formatNumber(number: total)
            
        case ".":
            if !decimalFlag {
                decimalFlag = true
                
                // Nil -> 0.0
                if currentNumber == nil {
                    currentNumber = 0.0
                    displayText = "0."
                }
                // Number -> Number + .
                else
                {
                    displayText = displayText + "."
                }
            }
            
        case Constants.negation:
            
            //Before pressing equals - negation applies to current number
            if currentNumber != nil {
                currentNumber!.negate()
                displayText = formatNumber(number: currentNumber!)
            }
            //After pressing equals - negation applies to total
            else if previousNumber != nil {
                previousNumber!.negate()
                displayText = formatNumber(number: previousNumber!)
            }
            
        case Constants.percentage:
            //Before pressing equals - percentage applies to current number
            if currentNumber != nil {
                currentNumber = currentNumber!/100
                displayText = formatNumber(number: currentNumber!)
            }
            //After pressing equals - percentage applies to total
            else if previousNumber != nil {
                previousNumber = previousNumber!/100
                displayText = formatNumber(number: previousNumber!)
            }
            
        default:
            break
        }
    }
}

