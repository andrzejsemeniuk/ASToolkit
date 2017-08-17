//
//  TestExtensionForUIKitUIColor.swift
//  ASToolkit
//
//  Created by andrzej semeniuk on 8/17/17.
//  Copyright © 2017 Andrzej Semeniuk. All rights reserved.
//

import XCTest
@testable import ASToolkit

class TestExtensionForUIKitUIColor: XCTestCase {
    
    override func setUp() {
        super.setUp()
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }
    
    func testCMYK() {
        var CMYK : UIColor.CMYKTuple
        
        CMYK = UIColor.cyan.CMYK
        
        XCTAssertEqual(CMYK.cyan, 1.0)
        XCTAssertEqual(CMYK.magenta, 0.0)
        XCTAssertEqual(CMYK.yellow, 0.0)
        XCTAssertEqual(CMYK.key, 0.0)
        
        
        CMYK = UIColor.magenta.CMYK
        
        XCTAssertEqual(CMYK.cyan, 0.0)
        XCTAssertEqual(CMYK.magenta, 1.0)
        XCTAssertEqual(CMYK.yellow, 0.0)
        XCTAssertEqual(CMYK.key, 0.0)

        
        CMYK = UIColor.yellow.CMYK
        
        XCTAssertEqual(CMYK.cyan, 0.0)
        XCTAssertEqual(CMYK.magenta, 0.0)
        XCTAssertEqual(CMYK.yellow, 1.0)
        XCTAssertEqual(CMYK.key, 0.0)
        
        
        CMYK = UIColor.red.CMYK
        
        XCTAssertEqual(CMYK.cyan, 0.0)
        XCTAssertEqual(CMYK.magenta, 1.0)
        XCTAssertEqual(CMYK.yellow, 1.0)
        XCTAssertEqual(CMYK.key, 0.0)

        
        CMYK = UIColor.green.CMYK
        
        XCTAssertEqual(CMYK.cyan, 1.0)
        XCTAssertEqual(CMYK.magenta, 0.0)
        XCTAssertEqual(CMYK.yellow, 1.0)
        XCTAssertEqual(CMYK.key, 0.0)

        
        CMYK = UIColor.blue.CMYK
        
        XCTAssertEqual(CMYK.cyan, 1.0)
        XCTAssertEqual(CMYK.magenta, 1.0)
        XCTAssertEqual(CMYK.yellow, 0.0)
        XCTAssertEqual(CMYK.key, 0.0)

        
        CMYK = UIColor.black.CMYK
        
        XCTAssertEqual(CMYK.cyan, 0.0)
        XCTAssertEqual(CMYK.magenta, 0.0)
        XCTAssertEqual(CMYK.yellow, 0.0)
        XCTAssertEqual(CMYK.key, 1.0)

        
        CMYK = UIColor.white.CMYK
        
        XCTAssertEqual(CMYK.cyan, 0.0)
        XCTAssertEqual(CMYK.magenta, 0.0)
        XCTAssertEqual(CMYK.yellow, 0.0)
        XCTAssertEqual(CMYK.key, 0.0)
        
    }
    
    func testPerformanceExample() {
        // This is an example of a performance test case.
        self.measure {
            // Put the code you want to measure the time of here.
        }
    }
    
}
