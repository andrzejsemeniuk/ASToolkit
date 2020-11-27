//
//  TestExtensionForDictionary.swift
//  ASToolkitTests
//
//  Created by andrzej semeniuk on 11/27/20.
//  Copyright © 2020 Andrzej Semeniuk. All rights reserved.
//

import XCTest

class TestExtensionForDictionary: XCTestCase {
    
    override func setUp() {
        super.setUp()
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }

    func testForEachValue() {
        var some = [
            "A" : 1,
            "B" : 2,
            "C" : 3,
        ]
        
        some.forEachValue {
            $0 *= 2
        }
        
        XCTAssertEqual(some["A"], 2)
        XCTAssertEqual(some["B"], 4)
        XCTAssertEqual(some["C"], 6)
    }
}
