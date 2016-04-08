//
//  CoreDataStack.swift
//  Groceries
//
//  Created by Roger Yong on 19/03/2016.
//  Copyright © 2016 rycbn. All rights reserved.
//

import CoreData

class CoreDataStack {
    
    let modelName = "Groceries"
    
    private lazy var applicationDocumentDirectory: NSURL = {
        let urls = NSFileManager.defaultManager().URLsForDirectory(.DocumentDirectory, inDomains: .UserDomainMask)
        return urls[urls.count-1]
    }()
    
    lazy var context: NSManagedObjectContext = {
        var managedObjectContext = NSManagedObjectContext(concurrencyType: .MainQueueConcurrencyType)
        managedObjectContext.persistentStoreCoordinator = self.persistentStoreCoordinator
        return managedObjectContext
    }()
    
    private lazy var persistentStoreCoordinator: NSPersistentStoreCoordinator = {
        let coordinator = NSPersistentStoreCoordinator(managedObjectModel: self.managedObjectModel)
        let url = self.applicationDocumentDirectory.URLByAppendingPathComponent(String(format:"%@.sqlite", self.modelName))
        do {
            let options = [NSMigratePersistentStoresAutomaticallyOption : true]
            try coordinator.addPersistentStoreWithType(NSSQLiteStoreType, configuration: nil, URL: url, options: options)
        }
        catch {
            print("Error adding persisten store.")
        }
        return coordinator
    }()
    
    private lazy var managedObjectModel: NSManagedObjectModel = {
        let modelURL = NSBundle.mainBundle().URLForResource(self.modelName, withExtension: "momd")!
        return NSManagedObjectModel(contentsOfURL: modelURL)!
    }()
    
    func saveContext() {
        if context.hasChanges {
            do {
                try context.save()
            }
            catch let error as NSError {
                print("Error: \(error.localizedDescription)")
            }
        }
    }
}