//
//  FuncGlobal.swift
//  Groceries
//
//  Created by Roger Yong on 22/03/2016.
//  Copyright © 2016 rycbn. All rights reserved.
//

import UIKit
import CoreData

func appDelegate() -> AppDelegate {
    return UIApplication.sharedApplication().delegate as! AppDelegate
}
func objContext() -> NSManagedObjectContext {
    return appDelegate().coreDataStack.context
}
func objSaveContext(){
    appDelegate().coreDataStack.saveContext()
}
