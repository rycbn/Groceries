//
//  QuantityTests.swift
//  Groceries
//
//  Created by Roger Yong on 21/03/2016.
//  Copyright © 2016 rycbn. All rights reserved.
//

import XCTest
@testable import Groceries

class QuantityTests: XCTestCase {
    
    override func setUp() {
        super.setUp()
    }
    
    override func tearDown() {
        super.tearDown()
    }
    
    func testValidQuantity() {
        let qty = "99"
        XCTAssertTrue(validateQuantity(qty))
    }
    
    func testInvalidQuantity() {
        let qty = "199"
        XCTAssertFalse(validateQuantity(qty), "Maximum 99")
    }
    
    func testInvalidQuantity2() {
        let qty = "K"
        XCTAssertFalse(validateQuantity(qty))
    }
    
    func testInvalidQuantity3() {
        let qty = "."
        XCTAssertFalse(validateQuantity(qty))
    }
}
