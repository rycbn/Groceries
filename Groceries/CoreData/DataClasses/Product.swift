//
//  Product.swift
//  Groceries
//
//  Created by Roger Yong on 19/03/2016.
//  Copyright © 2016 rycbn. All rights reserved.
//
import UIKit
import Foundation
import CoreData

class Product: NSManagedObject {

    // MARK:- GET
    class func count() -> Int {
        var error: NSError? = nil
        let fetchRequest = NSFetchRequest(entityName: EntityName.Product)
        let count = objContext().countForFetchRequest(fetchRequest, error: &error)
        return count
    }
    class func getData(id: Int) -> Product {
        var data: Product!
        let fetchRequest = NSFetchRequest(entityName: EntityName.Product)
        fetchRequest.predicate = NSPredicate(format: "id = %li", id)
        do {
            let results = try objContext().executeFetchRequest(fetchRequest) as! [Product]
            data = results[0]
        }
        catch let error as NSError {
            print("Error: \(error)" + "description: \(error.localizedDescription)")
        }
        return data
    }
    // MARK:- INSERT
    class func insert(data: [String: AnyObject]) {
        if let entity = NSEntityDescription.entityForName(EntityName.Product, inManagedObjectContext: objContext()) {
            let products = data[JsonResponseKeys.Products] as! NSArray
            for product in products {
                let item = Product(entity: entity, insertIntoManagedObjectContext: objContext())
                item.id = product[JsonResponseKeys.Id] as? NSNumber
                item.name = product[JsonResponseKeys.Name] as? String
                item.price = product[JsonResponseKeys.Price] as? NSNumber
                item.priceInfo = product[JsonResponseKeys.PriceInfo] as? String
            }
            appDelegate().coreDataStack.saveContext()
        }
    }
}
