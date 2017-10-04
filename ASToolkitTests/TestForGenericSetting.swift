//
//  TestForGenericSetting.swift
//  ASToolkit
//
//  Created by andrzej semeniuk on 8/28/17.
//  Copyright © 2017 Andrzej Semeniuk. All rights reserved.
//

import XCTest
import ASToolkit

class TestForGenericSetting: XCTestCase {
    
    override func setUp() {
        super.setUp()
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }
    
    func testExample() {
        // This is an example of a functional test case.
        // Use XCTAssert and related functions to verify your tests produce the correct results.
    }
    
    func testStore1() {
        let a = GenericSetting<String>(key:"theme",first:"Default")
        XCTAssertEqual(a.value,"Default")
        XCTAssertTrue(UserDefaults.standard.synchronize())
        XCTAssertEqual(UserDefaults.standard.string(forKey: "theme"), "Default")
        a.value = "Grape"
        XCTAssertTrue(UserDefaults.standard.synchronize())
        XCTAssertEqual(UserDefaults.standard.string(forKey: "theme"), "Grape")
        XCTAssertEqual(a.value,"Grape")
    }
    
    func testStore2() {
        let a = GenericSetting<String>(key:"theme",first:"Default")
        XCTAssertEqual(a.value,"Grape")
        XCTAssertTrue(UserDefaults.standard.synchronize())
        XCTAssertEqual(a.value,"Grape")
        XCTAssertEqual(UserDefaults.standard.string(forKey: "theme"), "Grape")
        a.value = a.first
        XCTAssertTrue(UserDefaults.standard.synchronize())
        XCTAssertEqual(UserDefaults.standard.string(forKey: "theme"), "Default")
        XCTAssertEqual(a.value,"Default")
    }
    
    func testPerformanceExample() {
        // This is an example of a performance test case.
        self.measure {
            // Put the code you want to measure the time of here.
        }
    }
    
}
