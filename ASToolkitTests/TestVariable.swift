//
//  TestVariable.swift
//  ASToolkitFrankenbots
//
//  Created by andrzej semeniuk on 5/29/16.
//  Copyright © 2017 Andrzej Semeniuk. All rights reserved.
//

import XCTest

@testable import ASToolkit




class TestVariable: XCTestCase {

    override func setUp() {
        super.setUp()
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }

    func testVariable() {
        // This is an example of a functional test case.
        // Use XCTAssert and related functions to verify your tests produce the correct results.

        if true
        {
            let v1:VariableWithImmutableRange = VariableWithImmutableRange(0,1,2)
            
            XCTAssertEqual("[0.0,1.0=1.0]",v1.description)
            
            v1.setValueTo(0)
            XCTAssertEqual("[0.0,1.0=0.0]",v1.description)
            
            v1.setValueTo(0.5)
            XCTAssertEqual("[0.0,1.0=0.5]",v1.description)
            
            v1.setValueTo(1)
            XCTAssertEqual("[0.0,1.0=1.0]",v1.description)
            
            v1.setValueTo(1.5)
            XCTAssertEqual("[0.0,1.0=1.0]",v1.description)
            
            v1.setValueTo(-0.5)
            XCTAssertEqual("[0.0,1.0=0.0]",v1.description)
        }
        
        if true
        {
            let v1:VariableWithImmutableRange = VariableWithImmutableRange(0,0,0)
            
            XCTAssertEqual("[0.0,0.0=0.0]",v1.description)
            
            v1.setValueTo(0)
            XCTAssertEqual("[0.0,0.0=0.0]",v1.description)
            
            v1.setValueTo(0.5)
            XCTAssertEqual("[0.0,0.0=0.0]",v1.description)
            
            v1.setValueTo(-0.5)
            XCTAssertEqual("[0.0,0.0=0.0]",v1.description)
        }

        if true
        {
            XCTAssertEqual("[0.0,1.0=0.0]",VariableWithImmutableRange(1,0,0).description)
            XCTAssertEqual("[0.0,2.0=2.0]",VariableWithImmutableRange(2,0,3).description)
            XCTAssertEqual("[0.0,2.0=0.0]",VariableWithImmutableRange(2,0,-3).description)
        }
        
        if true
        {
            XCTAssertEqual      (1.0,VariableWithImmutableRange(0,1,1).range)
            XCTAssertNotEqual   (2.0,VariableWithImmutableRange(0,1,1).range)
            XCTAssertEqual      (0.0,VariableWithImmutableRange(0,0,1).range)
            XCTAssertEqual      (99.0,VariableWithImmutableRange(0,99,1).range)
            XCTAssertEqual      (99.0,VariableWithImmutableRange(0,-99,1).range)
            XCTAssertEqual      (99.0,VariableWithImmutableRange(-99,0,1).range)
        }
        
        
        if true
        {
            let v1:Variable01 = Variable01(value:0)
            let _:Variable01  = Variable01(0)
            let _:Variable01  = Variable01(2)
            
            XCTAssertEqual("[0.0,1.0=0.0]",v1.description)
            
            v1.setValueTo(0)
            XCTAssertEqual("[0.0,1.0=0.0]",v1.description)
            
            v1.setValueTo(1)
            XCTAssertEqual("[0.0,1.0=1.0]",v1.description)
            
            v1.setValueTo(0.5)
            XCTAssertEqual("[0.0,1.0=0.5]",v1.description)
            
            v1.setValueTo(-0.5)
            XCTAssertEqual("[0.0,1.0=0.0]",v1.description)
            
            v1.setValueTo(1.5)
            XCTAssertEqual("[0.0,1.0=1.0]",v1.description)
        }
        
        if true
        {
            XCTAssertEqual("[0.0,1.0=0.5]",Variable0n(n:1,value:0.5).description)
            XCTAssertEqual("[0.0,1.0=1.0]",Variable0n(n:1,value:1.0).description)
            XCTAssertEqual("[0.0,1.0=1.0]",Variable0n(n:1,value:1.000001).description)
            XCTAssertEqual("[0.0,5.0=5.0]",Variable0n(n:5,value:5.5).description)
            XCTAssertEqual("[0.0,1.0=0.0]",Variable0n(n:1,value:-0.5).description)
            XCTAssertEqual("[0.0,1.0=1.0]",Variable0n(n:1,value:1.5).description)
            XCTAssertEqual("[0.0,0.0=0.0]",Variable0n(n:-1,value:0.5).description)
        }
        
        // TODO other methods on Variable, lerp01, set01, etc
        
        if true
        {
            XCTAssertEqual("[0.0,1.0=0.0]",VariableWithImmutableRange(1,0,0).description)
        }
        
    }

    func testVariableWithMutableRange() {
        // This is an example of a functional test case.
        // Use XCTAssert and related functions to verify your tests produce the correct results.
        
        if true
        {
            XCTAssertEqual("[0.0,1.0=1.0]",VariableWithMutableRange(0,1,1).description)
        }

        if true
        {
            let _:VariableWithMutableRange = VariableWithMutableRange(0,1,0)
            let _:VariableWithMutableRange = VariableWithMutableRange(0,1,1)
        }
        

        if true
        {
            XCTAssertEqual      (1.0,VariableWithMutableRange(0,1,1).range)
            XCTAssertNotEqual   (2.0,VariableWithMutableRange(0,1,1).range)
            XCTAssertEqual      (0.0,VariableWithMutableRange(0,0,1).range)
            XCTAssertEqual      (99.0,VariableWithMutableRange(0,99,1).range)
            XCTAssertEqual      (99.0,VariableWithMutableRange(0,-99,1).range)
            XCTAssertEqual      (99.0,VariableWithMutableRange(-99,0,1).range)
        }
        
        if true
        {
            let v1:VariableWithMutableRange = VariableWithMutableRange(0,0,0)
            
            XCTAssertEqual("[0.0,0.0=0.0]",v1.description)
            
            v1.setValueTo(0)
            XCTAssertEqual("[0.0,0.0=0.0]",v1.description)
            
            v1.setValueTo(0.5)
            XCTAssertEqual("[0.0,0.0=0.0]",v1.description)
            
            v1.setValueTo(-0.5)
            XCTAssertEqual("[0.0,0.0=0.0]",v1.description)
        }
        
        if true
        {
            let v1:VariableWithMutableRange = VariableWithMutableRange(0,1,0)
            
            XCTAssertEqual("[0.0,1.0=0.0]",v1.description)
            
            v1.set(lowerbound:1, upperbound:2)
            XCTAssertEqual("[1.0,2.0=1.0]",v1.description)
            
            v1.set(lowerbound:11, upperbound:-2)
            XCTAssertEqual("[-2.0,11.0=1.0]",v1.description)
            
            v1.set(lowerbound:0, upperbound:0)
            XCTAssertEqual("[0.0,0.0=0.0]",v1.description)
            
            v1.lowerbound = -5
            XCTAssertEqual("[-5.0,0.0=0.0]",v1.description)
            
            v1.upperbound = -2
            XCTAssertEqual("[-5.0,-2.0=-2.0]",v1.description)
            
            v1.upperbound = 5
            XCTAssertEqual("[-5.0,5.0=-2.0]",v1.description)
            
            v1.set(lowerbound:1,upperbound:2)
            XCTAssertEqual("[1.0,2.0=1.0]",v1.description)
            
            v1.set(lowerbound:4,upperbound:5,value:0.5)
            XCTAssertEqual("[4.0,5.0=4.0]",v1.description)
            
            v1.set(lowerbound:4,upperbound:6,value:5.5)
            XCTAssertEqual("[4.0,6.0=5.5]",v1.description)
        }
        
        
    }

    func testPerformanceExample() {
        // This is an example of a performance test case.
        self.measure {
            // Put the code you want to measure the time of here.
        }
    }

}
