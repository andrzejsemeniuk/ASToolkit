//
//  TestExtensionForFoundationDate.swift
//  ASToolkit
//
//  Created by andrzej semeniuk on 8/6/17.
//  Copyright © 2017 Andrzej Semeniuk. All rights reserved.
//

import XCTest
@testable import ASToolkit

class TestExtensionForFoundationDate: XCTestCase {
    
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
    
    func test_create() {
        
        let calendar = Calendar.init(identifier: .iso8601)
        
        if true {
            let date1 = Date.create(withCalendar:calendar, year:2001, month:1, day:1)
            XCTAssertNotNil(date1)
            XCTAssertEqual(date1!.year(withCalendar: calendar),         2001)
            XCTAssertEqual(date1!.month(withCalendar: calendar),        1)
            XCTAssertEqual(date1!.day(withCalendar: calendar),          1)
            XCTAssertEqual(date1!.hour(withCalendar: calendar),         0)
            XCTAssertEqual(date1!.minute(withCalendar: calendar),       0)
            XCTAssertEqual(date1!.second(withCalendar: calendar),       0)
        }
    }
    
    func test_adding() {
        
        let calendar = Calendar.init(identifier: .iso8601)
                
        let date1 = Date.create(withCalendar:calendar, year:2001, month:1, day:1, hour:15, minute:34, second:51)
        
        XCTAssertNotNil(date1)
        
        XCTAssertEqual(date1!.year(withCalendar: calendar),         2001)
        XCTAssertEqual(date1!.month(withCalendar: calendar),        1)
        XCTAssertEqual(date1!.day(withCalendar: calendar),          1)
        XCTAssertEqual(date1!.hour(withCalendar: calendar),         15)
        XCTAssertEqual(date1!.minute(withCalendar: calendar),       34)
        XCTAssertEqual(date1!.second(withCalendar: calendar),       51)

        XCTAssertEqual(date1!.adding(withCalendar: calendar, years: 0)?.year(withCalendar: calendar) ?? 0, 2001)
        XCTAssertEqual(date1!.adding(withCalendar: calendar, years: +1)?.year(withCalendar: calendar) ?? 0, 2002)
        XCTAssertEqual(date1!.adding(withCalendar: calendar, years: +100)?.year(withCalendar: calendar) ?? 0, 2101)
        XCTAssertEqual(date1!.adding(withCalendar: calendar, years: +101)?.year(withCalendar: calendar) ?? 0, 2102)
        XCTAssertEqual(date1!.adding(withCalendar: calendar, years: -1)?.year(withCalendar: calendar) ?? 0, 2000)
        XCTAssertEqual(date1!.adding(withCalendar: calendar, years: -100)?.year(withCalendar: calendar) ?? 0, 1901)
        XCTAssertEqual(date1!.adding(withCalendar: calendar, years: -101)?.year(withCalendar: calendar) ?? 0, 1900)
        XCTAssertEqual(date1!.adding(withCalendar: calendar, years: -102)?.year(withCalendar: calendar) ?? 0, 1899)
        
        XCTAssertEqual(date1!.adding(withCalendar: calendar, months: 0)?.month(withCalendar: calendar) ?? 0, 1)
        XCTAssertEqual(date1!.adding(withCalendar: calendar, months: +1)?.month(withCalendar: calendar) ?? 0, 2)
        XCTAssertEqual(date1!.adding(withCalendar: calendar, months: +2)?.month(withCalendar: calendar) ?? 0, 3)
        XCTAssertEqual(date1!.adding(withCalendar: calendar, months: +12)?.month(withCalendar: calendar) ?? 0, 1)
        XCTAssertEqual(date1!.adding(withCalendar: calendar, months: +13)?.month(withCalendar: calendar) ?? 0, 2)
        XCTAssertEqual(date1!.adding(withCalendar: calendar, months: +24)?.month(withCalendar: calendar) ?? 0, 1)
        XCTAssertEqual(date1!.adding(withCalendar: calendar, months: -1)?.month(withCalendar: calendar) ?? 0, 12)
        XCTAssertEqual(date1!.adding(withCalendar: calendar, months: -2)?.month(withCalendar: calendar) ?? 0, 11)
        XCTAssertEqual(date1!.adding(withCalendar: calendar, months: -12)?.month(withCalendar: calendar) ?? 0, 1)
        XCTAssertEqual(date1!.adding(withCalendar: calendar, months: -13)?.month(withCalendar: calendar) ?? 0, 12)
        XCTAssertEqual(date1!.adding(withCalendar: calendar, months: -24)?.month(withCalendar: calendar) ?? 0, 1)
        
        XCTAssertEqual(date1!.adding(withCalendar: calendar, days: 0)?.day(withCalendar: calendar) ?? 0, 1)
        XCTAssertEqual(date1!.adding(withCalendar: calendar, days: +1)?.day(withCalendar: calendar) ?? 0, 2)
        XCTAssertEqual(date1!.adding(withCalendar: calendar, days: +2)?.day(withCalendar: calendar) ?? 0, 3)
        XCTAssertEqual(date1!.adding(withCalendar: calendar, days: +10)?.day(withCalendar: calendar) ?? 0, 11)
        XCTAssertEqual(date1!.adding(withCalendar: calendar, days: +20)?.day(withCalendar: calendar) ?? 0, 21)
        XCTAssertEqual(date1!.adding(withCalendar: calendar, days: +30)?.day(withCalendar: calendar) ?? 0, 31)
        XCTAssertEqual(date1!.adding(withCalendar: calendar, days: +31)?.day(withCalendar: calendar) ?? 0, 1)
        XCTAssertEqual(date1!.adding(withCalendar: calendar, days: -1)?.day(withCalendar: calendar) ?? 0, 31)
        XCTAssertEqual(date1!.adding(withCalendar: calendar, days: -2)?.day(withCalendar: calendar) ?? 0, 30)
        XCTAssertEqual(date1!.adding(withCalendar: calendar, days: -10)?.day(withCalendar: calendar) ?? 0, 22)
        XCTAssertEqual(date1!.adding(withCalendar: calendar, days: -20)?.day(withCalendar: calendar) ?? 0, 12)
        XCTAssertEqual(date1!.adding(withCalendar: calendar, days: -30)?.day(withCalendar: calendar) ?? 0, 2)
        XCTAssertEqual(date1!.adding(withCalendar: calendar, days: -31)?.day(withCalendar: calendar) ?? 0, 1)
        
        XCTAssertEqual(date1!.adding(withCalendar: calendar, hours: 0)?.hour(withCalendar: calendar) ?? 0, 15)
        XCTAssertEqual(date1!.adding(withCalendar: calendar, hours: +1)?.hour(withCalendar: calendar) ?? 0, 16)
        XCTAssertEqual(date1!.adding(withCalendar: calendar, hours: +3)?.hour(withCalendar: calendar) ?? 0, 18)
        XCTAssertEqual(date1!.adding(withCalendar: calendar, hours: +6)?.hour(withCalendar: calendar) ?? 0, 21)
        XCTAssertEqual(date1!.adding(withCalendar: calendar, hours: +12)?.hour(withCalendar: calendar) ?? 0, 3)
        XCTAssertEqual(date1!.adding(withCalendar: calendar, hours: +18)?.hour(withCalendar: calendar) ?? 0, 9)
        XCTAssertEqual(date1!.adding(withCalendar: calendar, hours: +24)?.hour(withCalendar: calendar) ?? 0, 15)
        XCTAssertEqual(date1!.adding(withCalendar: calendar, hours: -1)?.hour(withCalendar: calendar) ?? 0, 14)
        XCTAssertEqual(date1!.adding(withCalendar: calendar, hours: -3)?.hour(withCalendar: calendar) ?? 0, 12)
        XCTAssertEqual(date1!.adding(withCalendar: calendar, hours: -6)?.hour(withCalendar: calendar) ?? 0, 9)
        XCTAssertEqual(date1!.adding(withCalendar: calendar, hours: -12)?.hour(withCalendar: calendar) ?? 0, 3)
        XCTAssertEqual(date1!.adding(withCalendar: calendar, hours: -18)?.hour(withCalendar: calendar) ?? 0, 21)
        XCTAssertEqual(date1!.adding(withCalendar: calendar, hours: -24)?.hour(withCalendar: calendar) ?? 0, 15)
        
        XCTAssertEqual(date1!.adding(withCalendar: calendar, minutes: 0)?.minute(withCalendar: calendar) ?? 0, 34)
        XCTAssertEqual(date1!.adding(withCalendar: calendar, minutes: +1)?.minute(withCalendar: calendar) ?? 0, 35)
        XCTAssertEqual(date1!.adding(withCalendar: calendar, minutes: +11)?.minute(withCalendar: calendar) ?? 0, 45)
        XCTAssertEqual(date1!.adding(withCalendar: calendar, minutes: +31)?.minute(withCalendar: calendar) ?? 0, 5)
        XCTAssertEqual(date1!.adding(withCalendar: calendar, minutes: +62)?.minute(withCalendar: calendar) ?? 0, 36)
        XCTAssertEqual(date1!.adding(withCalendar: calendar, minutes: +183)?.minute(withCalendar: calendar) ?? 0, 37)
        XCTAssertEqual(date1!.adding(withCalendar: calendar, minutes: -1)?.minute(withCalendar: calendar) ?? 0, 33)
        XCTAssertEqual(date1!.adding(withCalendar: calendar, minutes: -11)?.minute(withCalendar: calendar) ?? 0, 23)
        XCTAssertEqual(date1!.adding(withCalendar: calendar, minutes: -31)?.minute(withCalendar: calendar) ?? 0, 3)
        XCTAssertEqual(date1!.adding(withCalendar: calendar, minutes: -62)?.minute(withCalendar: calendar) ?? 0, 32)
        XCTAssertEqual(date1!.adding(withCalendar: calendar, minutes: -183)?.minute(withCalendar: calendar) ?? 0, 31)
        
        XCTAssertEqual(date1!.adding(withCalendar: calendar, seconds: 0)?.second(withCalendar: calendar) ?? 0, 51)
        XCTAssertEqual(date1!.adding(withCalendar: calendar, seconds: +1)?.second(withCalendar: calendar) ?? 0, 52)
        XCTAssertEqual(date1!.adding(withCalendar: calendar, seconds: +10)?.second(withCalendar: calendar) ?? 0, 1)
        XCTAssertEqual(date1!.adding(withCalendar: calendar, seconds: +60)?.second(withCalendar: calendar) ?? 0, 51)
        XCTAssertEqual(date1!.adding(withCalendar: calendar, seconds: +121)?.second(withCalendar: calendar) ?? 0, 52)
        XCTAssertEqual(date1!.adding(withCalendar: calendar, seconds: -1)?.second(withCalendar: calendar) ?? 0, 50)
        XCTAssertEqual(date1!.adding(withCalendar: calendar, seconds: -10)?.second(withCalendar: calendar) ?? 0, 41)
        XCTAssertEqual(date1!.adding(withCalendar: calendar, seconds: -60)?.second(withCalendar: calendar) ?? 0, 51)
        XCTAssertEqual(date1!.adding(withCalendar: calendar, seconds: -121)?.second(withCalendar: calendar) ?? 0, 50)
        
        if true {
            let date2 = date1!.adding(withCalendar:calendar, years:1, months:1, days:1, hours:1, minutes:1, seconds:1)
            XCTAssertNotNil(date2)
            XCTAssertEqual(date2!.year(withCalendar:calendar), 2002)
            XCTAssertEqual(date2!.month(withCalendar:calendar), 2)
            XCTAssertEqual(date2!.day(withCalendar:calendar), 2)
            XCTAssertEqual(date2!.hour(withCalendar:calendar), 16)
            XCTAssertEqual(date2!.minute(withCalendar:calendar), 35)
            XCTAssertEqual(date2!.second(withCalendar:calendar), 52)
        }
        
        if true {
            let date2 = date1!.adding(withCalendar:calendar, years:-1, months:-1, days:-1, hours:-1, minutes:-1, seconds:-1)
            XCTAssertNotNil(date2)
            XCTAssertEqual(date2!.year(withCalendar:calendar), 1999)
            XCTAssertEqual(date2!.month(withCalendar:calendar), 11)
            XCTAssertEqual(date2!.day(withCalendar:calendar), 30)
            XCTAssertEqual(date2!.hour(withCalendar:calendar), 14)
            XCTAssertEqual(date2!.minute(withCalendar:calendar), 33)
            XCTAssertEqual(date2!.second(withCalendar:calendar), 50)
        }

    }
    
    func test_valid() {
        
        let calendar = Calendar.init(identifier: .iso8601)
        
        XCTAssertTrue(Date.valid(withCalendar: calendar, year: 2001, month: 1, day: 1, hour: 1, minute: 1, second: 1))
        XCTAssertTrue(Date.valid(withCalendar: calendar, year: 2000, month: 1, day: 1, hour: 1, minute: 1, second: 1))
        XCTAssertTrue(Date.valid(withCalendar: calendar, year: 1899, month: 1, day: 1, hour: 1, minute: 1, second: 1))
        XCTAssertTrue(Date.valid(withCalendar: calendar, year:  999, month: 1, day: 1, hour: 1, minute: 1, second: 1))

        XCTAssertFalse(Date.valid(withCalendar: calendar, year: 2001, month: 0, day: 1, hour: 1, minute: 1, second: 1))
        XCTAssertFalse(Date.valid(withCalendar: calendar, year: 2001, month: 13, day: 1, hour: 1, minute: 1, second: 1))
        
        XCTAssertFalse(Date.valid(withCalendar: calendar, year: 2001, month: 1, day: 0, hour: 1, minute: 1, second: 1))
        XCTAssertFalse(Date.valid(withCalendar: calendar, year: 2001, month: 1, day: 32, hour: 1, minute: 1, second: 1))

        XCTAssertFalse(Date.valid(withCalendar: calendar, year: 2001, month: 1, day: 1, hour: -1, minute: 1, second: 1))
        XCTAssertFalse(Date.valid(withCalendar: calendar, year: 2001, month: 1, day: 1, hour: 24, minute: 1, second: 1))
        XCTAssertFalse(Date.valid(withCalendar: calendar, year: 2001, month: 1, day: 1, hour: 25, minute: 1, second: 1))
        
        XCTAssertFalse(Date.valid(withCalendar: calendar, year: 2001, month: 1, day: 1, hour: 1, minute: -1, second: 1))
        XCTAssertFalse(Date.valid(withCalendar: calendar, year: 2001, month: 1, day: 1, hour: 1, minute: 60, second: 1))
        XCTAssertFalse(Date.valid(withCalendar: calendar, year: 2001, month: 1, day: 1, hour: 1, minute: 61, second: 1))
        
        XCTAssertFalse(Date.valid(withCalendar: calendar, year: 2001, month: 1, day: 1, hour: 1, minute: 1, second: -1))
        XCTAssertFalse(Date.valid(withCalendar: calendar, year: 2001, month: 1, day: 1, hour: 1, minute: 1, second: 60))
        XCTAssertFalse(Date.valid(withCalendar: calendar, year: 2001, month: 1, day: 1, hour: 1, minute: 1, second: 61))
    }
    
    func test_measure_create() {
        self.measure {
            for _ in 0...999 {
                self.test_create()
            }
        }
    }
    
    func test_measure_adding() {
        self.measure {
            for _ in 0...999 {
                self.test_adding()
            }
        }
    }
    
    func test_measure_valid() {
        self.measure {
            for _ in 0...999 {
                self.test_valid()
            }
        }
    }
    
}
