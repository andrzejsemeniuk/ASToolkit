//
//  TestForCGFloat01.swift
//  ASToolkitTests
//
//  Created by andrzej semeniuk on 10/3/17.
//  Copyright © 2017 Andrzej Semeniuk. All rights reserved.
//

import XCTest
@testable import ASToolkit

class TestForCGFloat01: XCTestCase {
    
    override func setUp() {
        super.setUp()
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }
    
    func testInitializers() {
        XCTAssertEqual(CGFloat01().value, CGFloat(0))
        XCTAssertEqual(CGFloat01(0.5).value, CGFloat(0.5))
        XCTAssertEqual(CGFloat01(1).value, CGFloat(1))
        XCTAssertEqual(CGFloat01(1.5).value, CGFloat(1))
        XCTAssertEqual(CGFloat01(0.0).value, CGFloat(0))
        XCTAssertEqual(CGFloat01(-0.1).value, CGFloat(0))
    }
    
    func testValue() {
        let a = CGFloat01()
        a.value = 0
        XCTAssertEqual(a.value, CGFloat(0))
        a.value = 1
        XCTAssertEqual(a.value, CGFloat(1))
        a.value = 0.4
        XCTAssertEqual(a.value, CGFloat(0.4))
        a.value = 1.2
        XCTAssertEqual(a.value, CGFloat(1))
        a.value = -2.4
        XCTAssertEqual(a.value, CGFloat(0))
    }
    
    func testOperators() {
        let a = CGFloat01()
        a.value = 0
        a += 0.5
        XCTAssertEqual(a.value, CGFloat(0.5))
        a += 0.4
        XCTAssertEqual(a.value, CGFloat(0.9))
        a -= 0.1
        XCTAssertEqual(a.value, CGFloat(0.8))
        a += 0.5
        XCTAssertEqual(a.value, CGFloat(1.0))
        a -= 0.2
        XCTAssertEqual(a.value, CGFloat(0.8))
        a -= 0.9
        XCTAssertEqual(a.value, CGFloat(0))
    }
    
    func testPerformanceExample() {
        // This is an example of a performance test case.
        self.measure {
            // Put the code you want to measure the time of here.
        }
    }
    
}
