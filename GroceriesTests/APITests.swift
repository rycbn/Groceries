//
//  APITests.swift
//  Groceries
//
//  Created by Roger Yong on 21/03/2016.
//  Copyright © 2016 rycbn. All rights reserved.
//

import XCTest
@testable import Groceries

class APITests: XCTestCase {
    
    override func setUp() {
        super.setUp()
    }
    
    override func tearDown() {
        super.tearDown()
    }
    
    func testDateNotEqual() {
        let date1 = NSDate(timeIntervalSince1970: 1458593529)
        let date2 = date1.dateByAddingTimeInterval(+3660)
        XCTAssertFalse(compareTwoDateEqual(date1, date2: date2))
    }
    
    func testDateEqual() {
        let date1 = NSDate(timeIntervalSince1970: 1458593529)
        let date2 = NSDate(timeIntervalSince1970: 1458593529)
        XCTAssertTrue(compareTwoDateEqual(date1, date2: date2))
    }

    func testTimestampNotEqual() {
        let timestamp1: NSTimeInterval = 1458593529
        let timestamp2: NSTimeInterval = 1458623289
        XCTAssertFalse(isTimeIntervalEqualToAnother(timestamp1: timestamp1, timestamp2: timestamp2))
    }
    
    func testTimestampEqual() {
        let timestamp1: NSTimeInterval = 1458593529
        let timestamp2: NSTimeInterval = 1458593529
        XCTAssertTrue(isTimeIntervalEqualToAnother(timestamp1: timestamp1, timestamp2: timestamp2))
    }

    func testUrlString() {
        let url = "http://apilayer.net/api/"
        XCTAssertNotEqual(url, NSURL(string: "http://apilayer.net/api/"))
    }
    
    func testUrl() {
        let url = NSURL(string: "http://apilayer.net/api/")
        XCTAssertEqual(url, NSURL(string: "http://apilayer.net/api/"))
    }
    
    func testPerformanceExample() {
        self.measureBlock {
        }
    }
    
}
