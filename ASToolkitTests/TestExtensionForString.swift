//
//  TestExtensionForString.swift
//  ASToolkit
//
//  Created by andrzej semeniuk on 9/3/17.
//  Copyright © 2017 Andrzej Semeniuk. All rights reserved.
//

import XCTest

class TestExtensionForString: XCTestCase {
    
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
    
    func test_tweened() {
        XCTAssertEqual("abc".tweened(with:" "),"a b c")
        XCTAssertEqual("ab".tweened(with:" "),"a b")
        XCTAssertEqual("a".tweened(with:" "),"a")
        XCTAssertEqual("".tweened(with:" "),"")
    }
    
    func test_appended() {
        XCTAssertEqual("abc".appended(with:"d",delimiter:"/"),"abc/d")
        XCTAssertEqual("abc".appended(with:"",delimiter:"/"),"abc")
        XCTAssertEqual("".appended(with:"d",delimiter:"/"),"d")
        XCTAssertEqual("".appended(with:"",delimiter:"/"),"")
    }
    
    func testPerformanceExample() {
        // This is an example of a performance test case.
        self.measure {
            // Put the code you want to measure the time of here.
        }
    }

	func testRegex() {

		XCTAssertTrue("abcd".matches(regex: "[ab][ab]c[d]"))
		XCTAssertTrue("abcd".matches(regex: "[ab][ab]..$"))
		XCTAssertTrue("abcd".matches(regex: "^[ab].*$"))
		XCTAssertFalse("abcd".matches(regex: "b[ab]..$"))
		XCTAssertFalse("abcd".matches(regex: "^...$"))
		XCTAssertTrue("abcd".matches(regex: "^...."))
		XCTAssertTrue("abcd".matches(regex: "[^cd]b..$"))
	}
    
    func testSubstringTo() {
        
        XCTAssertEqual("abcd".substring(to: 1), "a")
        XCTAssertEqual("abcd".substring(to: 3), "abc")
        XCTAssertEqual("abcd".substring(to: 4), "abcd")
        XCTAssertEqual("abcd".substring(to: 0), "")

        XCTAssertEqual("abcd".substring(to: -1), "abc")
        XCTAssertEqual("abcd".substring(to: -3), "a")
        XCTAssertEqual("abcd".substring(to: 6), "abcd")

    }
    
    func testSubstringFrom() {
        
        XCTAssertEqual("abcd".substring(from: 1), "bcd")
        XCTAssertEqual("abcd".substring(from: 3), "d")
        XCTAssertEqual("abcd".substring(from: 4), "")
        XCTAssertEqual("abcd".substring(from: 0), "abcd")
        
        XCTAssertEqual("abcd".substring(from: -1), "d")
        XCTAssertEqual("abcd".substring(from: -3), "bcd")
        XCTAssertEqual("abcd".substring(from: 6), "")
    }

}
