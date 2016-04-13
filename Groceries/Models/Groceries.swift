//
//  Groceries.swift
//  Groceries
//
//  Created by Roger Yong on 06/04/2016.
//  Copyright © 2016 rycbn. All rights reserved.
//

import UIKit

protocol GroceriesDelegate {
    func ApiError()
}

class Groceries: NSObject {
    var delegate: GroceriesDelegate!
    
    func getCurrencyExchangeFromAPI(source source: String) {
        TaskConfig().getLiveCurrency { (results, error) in
            if results == nil {
                self.delegate.ApiError()
            }
            else {
                let success: Bool = (results![JsonResponseKeys.Success] as? Bool)!
                let timestamp = results![JsonResponseKeys.TimeStamp] as? NSTimeInterval
                let downloadDate = NSUserDefaults.standardUserDefaults().objectForKey(UserDefaults.CurrencyDownloadDate) as? NSTimeInterval
                if success {
                    if isTimeIntervalEqualToAnother(timestamp1: downloadDate, timestamp2: timestamp) {
                        dispatch_async(dispatch_get_main_queue()) {
                            if source == ConstantKeys.Product {
                                NSNotificationCenter.defaultCenter().postNotificationName(Notification.ProductCurrencyExchangeNoChange, object: self)
                            }
                            else {
                                NSNotificationCenter.defaultCenter().postNotificationName(Notification.ProductDetailCurrencyExchangeNoChange, object: self)
                            }
                        }
                    }
                    else {
                        CurrencyExchange.delete()
                        CurrencyExchange.insert(results!, source: source)
                    }
                    NSUserDefaults.standardUserDefaults().setValue(timestamp, forKey: UserDefaults.CurrencyDownloadDate)
                    NSUserDefaults.standardUserDefaults().synchronize()
                }
                else {
                    dispatch_async(dispatch_get_main_queue()) {
                        if source == ConstantKeys.Product {
                            NSNotificationCenter.defaultCenter().postNotificationName(Notification.ProductInsertCurrencyExchangeFailed, object: self)
                        }
                        else {
                            NSNotificationCenter.defaultCenter().postNotificationName(Notification.ProductDetailInsertCurrencyExchangeFailed, object: self)
                        }
                        
                    }
                }
            }
        }
    }
}
