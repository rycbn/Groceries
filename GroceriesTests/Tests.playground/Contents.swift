//: Playground - noun: a place where people can play

import UIKit

// Test Date
let date1 = NSDate(timeIntervalSince1970: 1458593529)
let date2 = NSDate(timeIntervalSince1970: 1458636549)
func compareTwoDateEqual(date1: NSDate, date2: NSDate) -> Bool {
    return date1.timeIntervalSince1970 == date2.timeIntervalSince1970
}
compareTwoDateEqual(date1, date2: date2)

func isTimeIntervalEqualToAnother(timestamp1 timestamp1: NSTimeInterval?, timestamp2: NSTimeInterval?) -> Bool {
    return timestamp1 == timestamp2
}
isTimeIntervalEqualToAnother(timestamp1: 1458593529, timestamp2: 1458636549)

// Test currency style
let price = 0 // 123.45 // 1234567.89
func currencyValueStyle(price: NSNumber) -> String {
    var string = String()
    let formatter = NumberFormatter()
    formatter.numberStyle = .currency
    if let price = formatter.string(from: price) {
        string = price
    }
    let cuurectIndex = string.startIndex
    let index: String.Index = string.index(after: cuurectIndex)
    string = string.substring(from: index)
    return string
}
currencyValueStyle(price)

// Test Quantity
let qty = "//" // "T" //"."
func validateQuantity(candidate: String) -> Bool {
    var isValid = false
    let regex = "([1-9][0-9])|(0?[1-9])"
    let predicate = NSPredicate(format: "SELF MATCHES %@", regex)
    if predicate.evaluateWithObject(candidate) {
        isValid = true
    }
    return isValid
}
validateQuantity(qty)

let qry = "1"

extension String {
    func toInt() -> Int {
        return Int(self)!
    }
    func toDouble() -> Double {
        return Double(self)!
    }
}

print(qry.toInt())
qry.toDouble()
