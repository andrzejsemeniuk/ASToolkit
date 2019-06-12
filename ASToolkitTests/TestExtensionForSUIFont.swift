//
//  TestExtensionForUIFont.swift
//  ASToolkit
//
//  Created by andrzej semeniuk on 9/3/17.
//  Copyright © 2017 Andrzej Semeniuk. All rights reserved.
//

import XCTest

class TestExtensionForUIFont: XCTestCase {
    
    override func setUp() {
        super.setUp()
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }

	func testFamily()
	{
		print("families=\(UIFont.familyNames.sorted())")
		print("compacted-families=\(UIFont.compactedFamilyNames)")
		print("faces=\(UIFont.faceNames)")
		print("names=\(UIFont.fontNames)")
	}

	func testSibling()
	{
		let font0 = UIFont.init(name: "Futura", size: 12)!
		let siblings = font0.siblings()
		print("siblings for \(font0.fontName) are \(siblings)")
		print("bold siblings for \(font0.fontName) are \(font0.boldSiblings())")
		print("italic siblings for \(font0.fontName) are \(font0.italicSiblings())")
		print("empty siblings for \(font0.fontName) are \(font0.siblings(withPhrase: ""))")
	}

	func testFontNames() {
		for family in ["Times New Roman", "Futura", "Symbol", "Avenir"] {
			print("fonts for family (\(family)) are (\(UIFont.fontNames(forFamilyName: family)))")
		}
	}

	func testFamiliesAndNames() {
		print("0 familiesAndNames=\(UIFont.familiesAndNames)")

		let r1 = UIFont.familiesAndNames(families: ["Futura"], names: ["Bold", "Italic", "Plain"])
		print("1 familiesAndNames=\(r1)")

		let r2 = UIFont.familiesAndNames(families: ["Futura"], names: [])
		print("2 familiesAndNames=\(r2)")

		let r3 = UIFont.familiesAndNames(families: [], names: ["Bold", "Italic", "Plain"])
		print("3 familiesAndNames=\(r3)")

		let r4 = UIFont.familiesAndNames(families: [], names: [])
		print("4 familiesAndNames=\(r4)")

		let r5 = UIFont.familiesAndNames(families: ["Futura","Gill Sans"], names: ["Bold"])
		print("5 familiesAndNames=\(r5)")
	}

}
