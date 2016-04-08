//
//  NetworkTests.swift
//  Groceries
//
//  Created by Roger Yong on 21/03/2016.
//  Copyright © 2016 rycbn. All rights reserved.
//

import XCTest
@testable import Groceries

class NetworkTests: XCTestCase {
    
    override func setUp() {
        super.setUp()
    }
    
    override func tearDown() {
        super.tearDown()
    }
    
    func testNetworkOnline() {
        XCTAssertTrue(isNetworkOrCellularCoverageReachable())
    }
    
    func testNetworkNoConnection() {
        XCTAssertFalse(!isNetworkOrCellularCoverageReachable())
    }

    func testHasCellularCoverage() {
        XCTAssertFalse(hasCellularCoverage())
    }

    func testHasNoCellularCoverage() {
        XCTAssertTrue(!hasCellularCoverage())
    }

    func testHasWifi() {
        XCTAssertTrue(isReachableViaWifi())
    }
    
    func testHasNoWifi() {
        XCTAssertFalse(!isReachableViaWifi())
    }
    
    func testPerformanceExample() {
        self.measureBlock {
        }
    }
}
