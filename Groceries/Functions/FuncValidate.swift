//
//  FuncValidate.swift
//  Groceries
//
//  Created by Roger Yong on 22/03/2016.
//  Copyright © 2016 rycbn. All rights reserved.
//

import UIKit
import CoreTelephony
import CoreData

func validateQuantity(candidate: String) -> Bool {
    var isValid = false
    let regex = "([1-9][0-9])|(0?[1-9])"
    let predicate = NSPredicate(format: "SELF MATCHES %@", regex)
    if predicate.evaluateWithObject(candidate) {
        isValid = true
    }
    return isValid
}

func hasCellularCoverage() -> Bool {
    let carrier = CTCarrier()
    let subscriber = CTSubscriber()
    if !(carrier.mobileCountryCode != nil) { return false }
    if !(subscriber.carrierToken != nil) { return false }
    return true
}

func isNetworkOrCellularCoverageReachable() -> Bool  {
    let reachability = Reachability.reachabilityForInternetConnection()
    return (reachability!.isReachable() || hasCellularCoverage())
}

func isReachableViaWifi() -> Bool {
    let reachability = Reachability.reachabilityForInternetConnection()
    return reachability!.isReachableViaWiFi()
}

func getDefaultCurrencyExchange() -> (code: String?, rate: Double?, found: Bool) {
    let currencyCode = NSUserDefaults.standardUserDefaults().objectForKey(UserDefaults.CurrencyCode) as? String
    let currencyRate = NSUserDefaults.standardUserDefaults().objectForKey(UserDefaults.CurrencyRate) as? Double
    var isFound = true
    if currencyCode == nil && currencyRate == nil {
        isFound = false
    }
    return (currencyCode, currencyRate, isFound)
}

func compareTwoDateEqual(date1: NSDate, date2: NSDate) -> Bool {
    return date1.timeIntervalSince1970 == date2.timeIntervalSince1970
}

func isTimeIntervalEqualToAnother(timestamp1 timestamp1: NSTimeInterval?, timestamp2: NSTimeInterval?) -> Bool {
    return timestamp1 == timestamp2
}

func currencyValueStyle(price: NSNumber) -> String {
    var string = String()
    let formatter = NSNumberFormatter()
    formatter.numberStyle = .CurrencyStyle
    string = formatter.stringFromNumber(price)!
    let index: String.Index = string.startIndex.advancedBy(1)
    string = string.substringFromIndex(index)
    return string
}