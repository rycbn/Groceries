//
//  CartItem.swift
//  Groceries
//
//  Created by Roger Yong on 19/03/2016.
//  Copyright © 2016 rycbn. All rights reserved.
//

import Foundation
import CoreData

class CartItem: NSManagedObject {
    
    // MARK:- GET
    class func getTotal() -> (cart: Int, amount: Double) {
        let fetchRequest = NSFetchRequest(entityName: EntityName.CartItem)
        fetchRequest.returnsObjectsAsFaults = false
        var totalCartItem: Int = 0
        var subTotal: Double = 0.0
        var grandTotal: Double = 0.0
        do {
            let items = try AppDelegate().coreDataStack.context.executeFetchRequest(fetchRequest) as! [CartItem]
            for item in items {
                totalCartItem = totalCartItem + Int(item.quantity!)
                subTotal = Double(item.quantity!) * Double(item.amount!)
                grandTotal = grandTotal + subTotal
            }
        }
        catch let error as NSError {
            print("Error: \(error)" + "description: \(error.localizedDescription)")
        }
        return (totalCartItem, Double(grandTotal))
    }
    class func getData(id: Int) -> (data: CartItem?, qty: String, total: Double) {
        var data: CartItem!
        var qty: String!
        var total: Double!
        let fetchRequest = NSFetchRequest(entityName: EntityName.CartItem)
        fetchRequest.predicate = NSPredicate(format: "id = %li", id)
        do {
            let results = try appDelegate().coreDataStack.context.executeFetchRequest(fetchRequest) as! [CartItem]
            if results.count > 0 {
                data = results.first!
                qty = String(data!.quantity!)
                total = Double(qty)! * Double(data!.amount!)
            }
            else {
                qty = "0"
            }
        }
        catch let error as NSError {
            print("Error: \(error)" + "description: \(error.localizedDescription)")
        }
        return (data!, qty!, total!)
    }
    // MARK:- DELETE
    class func deleteCart(dataObj: NSManagedObject) {
        appDelegate().coreDataStack.context.deleteObject(dataObj)
        appDelegate().coreDataStack.saveContext()
    }
    // MARK: - DELETE
    class func delete() {
        let fetchRequest = NSFetchRequest(entityName: EntityName.CartItem)
        let deleteRequest = NSBatchDeleteRequest(fetchRequest: fetchRequest)
        do {
            try appDelegate().coreDataStack.context.executeRequest(deleteRequest)
        }
        catch let error as NSError {
            print("Error: unable to delete data \(error)")
        }
    }
    // MARK:- UPDATE
    class func updateCartQty(id: Int, qty: Int) {
        let fetchRequest = NSFetchRequest(entityName: EntityName.CartItem)
        fetchRequest.predicate = NSPredicate(format: "id = %li", id)
        do {
            let results = try appDelegate().coreDataStack.context.executeFetchRequest(fetchRequest) as! [CartItem]
            let cartData = results.first!
            cartData.quantity = qty
            appDelegate().coreDataStack.saveContext()
        }
        catch let error as NSError {
            print("Error: \(error)" + "description: \(error.localizedDescription)")
        }
    }
}
