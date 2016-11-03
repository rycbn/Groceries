//
//  GroceriesTests.swift
//  GroceriesTests
//
//  Created by Roger Yong on 19/03/2016.
//  Copyright © 2016 rycbn. All rights reserved.
//

import XCTest
@testable import Groceries

class GroceriesTests: XCTestCase {
    
    override func setUp() {
        super.setUp()
    }
    
    override func tearDown() {
        super.tearDown()
    }
    
    func testProductDataNotEqual1() {
        let id = 3
        XCTAssertNotEqual(3, Product.getData(id))
    }
    
    func testCartItemAmountEqualToZero() {
        XCTAssertEqual(0, CartItem.getTotal().amount)
    }
    
    func testCartItemAmountNotEqualZero() {
        XCTAssertNotEqual(1, CartItem.getTotal().amount)
    }
    
    func testCartItemEqualToZero() {
        XCTAssertEqual(0, CartItem.getTotal().cart)
    }

    func testCartItemNotEqualToZero() {
        XCTAssertNotEqual(1, CartItem.getTotal().cart)
    }
    
    func testConversionNotEqual() {
        let convertedRate = CurrencyExchange.conversion(2, rate: 3)
        XCTAssertNotEqual(6, convertedRate)
    }
    
    func testConversionEqual() {
        let convertedRate = CurrencyExchange.conversion(1, rate: 1)
        XCTAssertEqual(1, convertedRate)
    }

    func testCurrencyExchange() {
        XCTAssertFalse(getDefaultCurrencyExchange().found)
    }
    
    func testCurrencyStyle() {
        let price = 1234.56
        XCTAssertEqual("1,234.56", currencyValueStyle(price))
    }
}
