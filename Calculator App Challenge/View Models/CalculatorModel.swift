//
//  CalculatorModel.swift
//  Calculator App Challenge
//
//  Created by Eli Hartnett on 11/7/21.
//

import Foundation

class CalculatorModel: ObservableObject {
    
    @Published var displayText = "0"
    
    @Published var currentNumber:Double?
    var previousNumber:Double?
    
    var total:Double = 0
    @Published var op:String?
    
    var decimalPlace = 0
    var decimalFlag = false
    
    func buttonPressed (label: String) {
        
        // Input is a number, display appropriately
        if Double(label) != nil {
            
            // Building first number
            if previousNumber == nil {
                buildNumber(number: label)
            }
            // Building second number
            else {
                buildNumber(number: label)
            }
            
            displayText = formatNumber(number: currentNumber ?? 0)
            
            if !decimalFlag {
                decimalPlace += 1
            }
        }
        
        // Input is an operator
        else {
            
            // If numbers and operators chained together, update total and display value
            if previousNumber != nil && currentNumber != nil && (label == Constants.addition || label == Constants.subtraction || label == Constants.multiplication || label == Constants.division) {
                calculate()
                displayText = formatNumber(number: total)
            }
            
            setOp(op: label)
        }
    }
    
    // Represent numbers typed as a string
    func buildNumber (number: String) {
        // No decimal used
        if !decimalFlag {
            currentNumber = (currentNumber ?? 0) * pow(10, 1) + (Double(number)!)
        }
        
        // Decimal in number, account for location
        else {
            if currentNumber == 0.0 {
                currentNumber = Double(number)!/10
            }
            else {
                currentNumber = (currentNumber ?? 0) + (Double(number)! / (pow(10, Double(decimalPlace))))
            }
        }
    }
    
    // Adds commas, keeps track of decimal rounding, keeps track of trailing 0's
    func formatNumber (number: Double) -> String {
        
        let numberFormatter = NumberFormatter()
        numberFormatter.numberStyle = .decimal
        numberFormatter.maximumFractionDigits = 6
        let formattedNumber = numberFormatter.string(from: NSNumber(value:number))
        
        return formattedNumber!
    }
    
    // Use values to perform specified operation
    func calculate () {
        switch self.op {
            
        case Constants.addition:
            total = (previousNumber ?? 0) + (currentNumber ?? 0)
            
        case Constants.subtraction:
            total = (previousNumber ?? 0) - (currentNumber ?? 0)

        case Constants.multiplication:
            total = (previousNumber ?? 0) * (currentNumber ?? 0)

        case Constants.division:
            if currentNumber == 0 {
                displayText = "Error"
            }
            else {
                total = (previousNumber ?? 0) / currentNumber!
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
                
                if currentNumber == nil {
                    currentNumber = 0.0
                    displayText = "0."
                }
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

