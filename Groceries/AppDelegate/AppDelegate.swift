//
//  AppDelegate.swift
//  Groceries
//
//  Created by Roger Yong on 19/03/2016.
//  Copyright © 2016 rycbn. All rights reserved.
//

import UIKit
import CoreData

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?
    lazy var coreDataStack = CoreDataStack()

    func application(application: UIApplication, didFinishLaunchingWithOptions launchOptions: [NSObject: AnyObject]?) -> Bool {

        importProductJsonDataIfNeeded()
        
        UINavigationBar.appearance().titleTextAttributes = [NSFontAttributeName: UIFont(name: FontNameCalibri.Bold, size: FontSize.Small)!]
        UIBarButtonItem.appearance().setTitleTextAttributes([NSFontAttributeName: UIFont(name: FontNameCalibri.Bold, size: FontSize.Tiny)!], forState: .Normal)
        UIBarButtonItem.appearance().tintColor = UIColor.colorFromHexRGB(Color.Blue)
        
        return true
    }

    func applicationWillResignActive(application: UIApplication) {}

    func applicationDidEnterBackground(application: UIApplication) {}

    func applicationWillEnterForeground(application: UIApplication) {}

    func applicationDidBecomeActive(application: UIApplication) {}

    func applicationWillTerminate(application: UIApplication) {}
}
// MARK:- Import Product
extension AppDelegate {
    func importProductJsonDataIfNeeded() {
        let count = Product.count()
        if count == 0 {
            importProductJsonData()
        }
    }
    func importProductJsonData() {
        let jsonFilePath = JsonDefault.Product
        let jsonFileData = NSData(contentsOfFile: jsonFilePath!)
        do {
            let jsonFile = try NSJSONSerialization.JSONObjectWithData(jsonFileData!, options: .MutableContainers)
            insertJsonProductData(jsonFile as? [String : AnyObject])
        }
        catch let error as NSError {
            print("Erorr: \(error.localizedDescription)")
        }
    }
    func insertJsonProductData(results: [String: AnyObject]?) {
        Product.insert(results!)
    }
}

