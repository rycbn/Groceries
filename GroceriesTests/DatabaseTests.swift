//
//  DatabaseTests.swift
//  Groceries
//
//  Created by Roger Yong on 21/03/2016.
//  Copyright © 2016 rycbn. All rights reserved.
//

import XCTest
import CoreData

@testable import Groceries

class DatabaseTests: XCTestCase {
    
    var testData: NSData!
    
    override func setUp() {
        super.setUp()
        
        if let file = NSBundle.mainBundle().pathForResource("products", ofType: "json") {
            testData = NSData(contentsOfFile: file)
        } else {
            XCTFail("Can't find the test json file")
        }
    }
    
    override func tearDown() {
        super.tearDown()
    }

    func testProductCount() {
        let count = Product.count()
        XCTAssertNotEqual(0, count)
    }
    
    func testEntityName() {
        let fetchRequest = NSFetchRequest(entityName: "Product")
        do {
            try objContext().executeFetchRequest(fetchRequest) as! [Product]
        }
        catch let error as NSError {
            print("Error: \(error)" + "description: \(error.localizedDescription)")
        }
        XCTAssertTrue(true)
    }
    
}
