//
//  CurrencyExchange.swift
//  Groceries
//
//  Created by Roger Yong on 21/03/2016.
//  Copyright © 2016 rycbn. All rights reserved.
//

import UIKit
import CoreData

class CurrencyExchange: NSManagedObject {

    // MARK:- GET
    class func conversion(source: Double, rate: Double) -> Double  {
        var base = NSUserDefaults.standardUserDefaults().objectForKey(UserDefaults.BaseCurrencyRate) as? NSNumber
        if base == nil {
            base = 1
        }
        let converted = rate / Double(base!)
        return source * converted
    }
    class func count() -> Int {
        var error: NSError? = nil
        let fetchRequest = NSFetchRequest(entityName: EntityName.CurrencyExchange)
        let count = objContext().countForFetchRequest(fetchRequest, error: &error)
        return count
    }
    // MARK:- INSERT
    class func insert(data: [String: AnyObject], source: String) {
        let entity = NSEntityDescription.entityForName(EntityName.CurrencyExchange, inManagedObjectContext: objContext())
        let quotes = data[JsonResponseKeys.Quotes] as! [String: AnyObject]
        for quote in quotes {
            let item = CurrencyExchange(entity: entity!, insertIntoManagedObjectContext: objContext())
            var itemKey = quote.0
            let index: String.Index = itemKey.startIndex.advancedBy(3)
            itemKey = itemKey.substringFromIndex(index)
            item.code = itemKey
            item.rate = quote.1 as? NSNumber
            if item.code == ConstantKeys.GBP {
                NSUserDefaults.standardUserDefaults().setValue(item.code!, forKey: UserDefaults.CurrencyCode)
                NSUserDefaults.standardUserDefaults().setValue(item.rate!, forKey: UserDefaults.CurrencyRate)
                NSUserDefaults.standardUserDefaults().setValue(item.rate!, forKey: UserDefaults.BaseCurrencyRate)
                NSUserDefaults.standardUserDefaults().synchronize()
            }
        }
        appDelegate().coreDataStack.saveContext()
        dispatch_async(dispatch_get_main_queue()) {
            if source == ConstantKeys.Product {
                NSNotificationCenter.defaultCenter().postNotificationName(Notification.ProductInsertCurrencyExchangeCompleted, object: self)
            }
            else {
                NSNotificationCenter.defaultCenter().postNotificationName(Notification.ProductDetailInsertCurrencyExchangeCompleted, object: self)
            }
        }
    }
    // MARK: - DELETE
    class func delete() {
        let fetchRequest = NSFetchRequest(entityName: EntityName.CurrencyExchange)
        let deleteRequest = NSBatchDeleteRequest(fetchRequest: fetchRequest)
        do {
            try objContext().executeRequest(deleteRequest)
        }
        catch let error as NSError {
            print("Error: unable to delete data \(error)")
        }
    }
}
