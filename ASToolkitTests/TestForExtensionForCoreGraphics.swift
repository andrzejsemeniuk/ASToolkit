//
//  TestForExtensionForCoreGraphics.swift
//  ASToolkitTests
//
//  Created by andrzej semeniuk on 10/3/17.
//  Copyright © 2017 Andrzej Semeniuk. All rights reserved.
//

import XCTest
@testable import ASToolkit

class TestForExtensionForCoreGraphics: XCTestCase {
    
    override func setUp() {
        super.setUp()
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }
    
    func testCGPoint() {
        let a = CGPoint(1,3)
        XCTAssertEqual(a.x,CGFloat(1))
        XCTAssertEqual(a.y,CGFloat(3))
        
        XCTAssertEqual(a.asCGSize.width,CGFloat(1))
        XCTAssertEqual(a.asCGSize.height,CGFloat(3))
        
        let b = CGPoint(xy:2.34)
        XCTAssertEqual(b.x,CGFloat(2.34))
        XCTAssertEqual(b.y,CGFloat(2.34))
        
        XCTAssertEqual(CGPoint.almostZero, CGPoint(x: CGFloat.leastNormalMagnitude, y: CGFloat.leastNormalMagnitude))
    }
    
    func testCGSize() {
        let a = CGSize(side:1.23)
        XCTAssertEqual(a.width,CGFloat(1.23))
        XCTAssertEqual(a.height,CGFloat(1.23))
        XCTAssertEqual(a.diagonal, CGFloat(sqrt(1.23*1.23 + 1.23*1.23)))
        
        XCTAssertEqual(CGSize.almostZero, CGSize(side: CGFloat.leastNormalMagnitude))
    }
    
    func testCGRect() {
        let a = CGRect(CGPoint(x:1.21,y:1.31))
        XCTAssertEqual(a.origin.x, CGFloat(1.21))
        XCTAssertEqual(a.origin.y, CGFloat(1.31))
        
        let b = CGRect(x:1.21,y:1.31)
        XCTAssertEqual(b.origin.x, CGFloat(1.21))
        XCTAssertEqual(b.origin.y, CGFloat(1.31))
        
        let c = CGRect(CGSize(width:1.21,height:1.31))
        XCTAssertEqual(c.size.width,  CGFloat(1.21))
        XCTAssertEqual(c.size.height, CGFloat(1.31))
        
        let d = CGRect(side:1.23)
        XCTAssertEqual(d.size.width,  CGFloat(1.23))
        XCTAssertEqual(d.size.height, CGFloat(1.23))

        XCTAssertEqual(d.diagonal, CGFloat(sqrt(1.23*1.23 + 1.23*1.23)))

        XCTAssertEqual(CGRect.almostZero, CGRect(origin:CGPoint.almostZero, size:CGSize.almostZero))
    }
    
    func testCGAffineTransform() {
        let a = CGAffineTransform.init(scaleX: 1.23, y: 1.32)
        XCTAssertEqual(a.sx,1.23)
        XCTAssertEqual(a.sy,1.32)
    }
    
    func testPerformanceExample() {
        // This is an example of a performance test case.
        self.measure {
            // Put the code you want to measure the time of here.
        }
    }
    
}
