//
//  TestForBindingValue.swift
//  ASToolkitTests
//
//  Created by andrzej semeniuk on 10/5/17.
//  Copyright © 2017 Andrzej Semeniuk. All rights reserved.
//

import XCTest
@testable import ASToolkit

class TestForBindingValue: XCTestCase {
    
    override func setUp() {
        super.setUp()
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }
    
    func testInitializer() {
        let a = BindingValue<Int>()
        XCTAssertNil(a.value)
        XCTAssertNil(a.listener)
        let b = BindingValue<Int>(3)
        XCTAssertNotNil(b.value)
        XCTAssertEqual(b.value!, 3)
    }
    
    func testListener1() {
        let expectation = XCTestExpectation(description:"listener")
        expectation.expectedFulfillmentCount = 1
        
        let number = 2
        
        let a = BindingValue<Int>() { value in
            if let value = value, value == number {
                expectation.fulfill()
            }
        }
        XCTAssertNotNil(a.listener)
        a.value = number
        
        wait(for: [expectation], timeout:1.0)
    }
    
    func testListener2() {
        let expectation = XCTestExpectation(description:"listener")
        expectation.expectedFulfillmentCount = 1

        let number = 5
        
        let listener: (Int?)->() = { value in
            if let value = value, value == number {
                expectation.fulfill()
            }
        }
        
        let a = BindingValue<Int>(listener:listener)
        XCTAssertNotNil(a.listener)
        a.value = number
        
        wait(for: [expectation], timeout:1.0)
    }
    
    func testListener3() {
        let expectation = XCTestExpectation(description:"listener")
        expectation.expectedFulfillmentCount = 1
        
        let number = 6
        
        let listener: (Int?)->() = { value in
            if let value = value, value == number {
                expectation.fulfill()
            }
        }
        
        let a = BindingValue<Int>()
        XCTAssertNil(a.listener)
        a.listener = listener
        XCTAssertNotNil(a.listener)
        a.value = number
        
        wait(for: [expectation], timeout:1.0)
    }
    
    func testfire() {
        let expectation = XCTestExpectation(description:"listener")
        expectation.expectedFulfillmentCount = 1
        
        let number = 7
        
        let listener: (Int?)->() = { value in
            if let value = value, value == number {
                expectation.fulfill()
            }
        }
        
        let a = BindingValue<Int>(number)
        XCTAssertNil(a.listener)
        a.listener = listener
        
        a.fire()
        
        wait(for: [expectation], timeout:1.0)
    }
    

    func testPerformanceExample() {
        // This is an example of a performance test case.
        self.measure {
            // Put the code you want to measure the time of here.
        }
    }
    
}
