//
//  CartItem+CoreDataProperties.swift
//  Groceries
//
//  Created by Roger Yong on 21/03/2016.
//  Copyright © 2016 rycbn. All rights reserved.
//
//  Choose "Create NSManagedObject Subclass…" from the Core Data editor menu
//  to delete and recreate this implementation file for your updated model.
//

import Foundation
import CoreData

extension CartItem {

    @NSManaged var amount: NSNumber?
    @NSManaged var id: NSNumber?
    @NSManaged var quantity: NSNumber?

}
