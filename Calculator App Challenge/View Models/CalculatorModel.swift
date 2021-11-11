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
    
    var negated = false
    
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
        if decimalFlag && ((label != Constants.negation) && label != Constants.percentage) {
            decimalPlace += 1
        }
    }
    
    // Logic to turn string input into number
    func buildNumber (number: String) {
        
        // Not dealing with negatives
        if !negated {
            // No decimal used, number will increase by a power of 10 each time (1, 1x, 1xx)
            if !decimalFlag {
                currentNumber = (currentNumber ?? 0) * pow(10, 1) + (Double(number)!)
            }
            
            // Decimal used, decimal power will increase making the increment amount decrease by a power of 10 each time (1, 1.x, 1.xx)
            else {
                currentNumber = (currentNumber ?? 0) + (Double(number)! / (pow(10, Double(decimalPlace))))
            }
        }
        
        // Dealing with negatives
        else {
            // No decimal used, number will decrease by a power of 10 each time (1, 1x, 1xx)
            if !decimalFlag {
                currentNumber = (currentNumber ?? 0) * pow(10, 1) - (Double(number)!)
            }
            
            // Decimal used, decimal power will decrease making the increment amount decrease by a power of 10 each time (1, 1.x, 1.xx)
            else {
                currentNumber = (currentNumber ?? 0) - (Double(number)! / (pow(10, Double(decimalPlace))))
            }
        }
    }
    
    // Improves a number's asthetic for a calculator
    func formatNumber (number: Double) -> String {
        
        let numberFormatter = NumberFormatter()
        
        // Adds commas if number is long enough
        numberFormatter.numberStyle = .decimal
        
        // Special case for if user types something such as 0.0, .00, .000, etc. where trailing 0s are needed
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
            
            // Calculating without operator (negation, equals, percent), applies current number into total
        default:
            if currentNumber != nil {
                total = currentNumber!
            }
            else {
                total = previousNumber!
            }
            
            displayText = formatNumber(number: total)
        }
        
        // Reset for next number
        self.op = nil
        previousNumber = total
        currentNumber = nil
    }
    
    func setOp (op: String) {
        switch op {
            
        case Constants.addition, Constants.subtraction, Constants.multiplication, Constants.division:
            self.op = op
            
            // Reset for next number
            decimalPlace = 0
            decimalFlag = false
            negated = false
            
            // Transfer number before operator to previous number and get ready for next number
            previousNumber = (previousNumber ?? 0) + (currentNumber ?? 0)
            currentNumber = nil
            
        case "CE":
            clearCalculator()
            
        case Constants.equals:
            calculate()
            displayText = formatNumber(number: total)
            
        case ".":
            
            // Only allow 1 decimal to be adder per number; have to update display here with concatination and actually account for decimal in the currentNumber (double) in buildNumber() after decimal flag has been set
            if !decimalFlag {
                
                decimalFlag = true
                
                // Nil -> 0.0
                if currentNumber == nil {
                    currentNumber = 0.0
                    if negated {
                        displayText = "-0."
                    }
                    else {
                        displayText = "0."
                    }
                }
                // Number -> Number + .
                else
                {
                    if negated {
                        displayText = "-" + displayText + "."
                    }
                    else {
                        displayText = displayText + "."
                    }
                }
            }
            
        case Constants.negation:
            
            negated.toggle()
            
            // Before pressing equals or an operator
            if currentNumber != nil {
                currentNumber?.negate()
                displayText = formatNumber(number: currentNumber!)
            }
            
            // After pressing equals or an operator
            else {
                total.negate()
                displayText = formatNumber(number: total)
            }
            
            // No numbers have been inputted
            if previousNumber == nil && currentNumber == nil {
                if negated {
                    displayText = "-0"
                }
                else {
                    displayText = "0"
                }
                if decimalFlag {
                    displayText += "."
                }
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
    
    // Reset all properties
    func clearCalculator () {
        self.op = nil
        previousNumber = nil
        currentNumber = nil
        total = 0
        decimalFlag = false
        decimalPlace = 0
        displayText = "0"
        negated = false
    }
}

