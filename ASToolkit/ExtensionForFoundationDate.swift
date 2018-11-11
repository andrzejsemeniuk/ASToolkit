//
//  ExtensionForFoundationDate.swift
//  ASToolkit
//
//  Created by andrzej semeniuk on 12/15/16.
//  Copyright © 2017 Andrzej Semeniuk. All rights reserved.
//

import Foundation

extension Date {
    
    public func componentDelta(to other:Date, units:[Calendar.Component] = [
        Calendar.Component.year,
        Calendar.Component.weekOfYear,
        Calendar.Component.day,
        Calendar.Component.hour,
        Calendar.Component.minute,
        Calendar.Component.second
        ]) -> Calendar.Component? {
        
        for component in units
        {
            if Calendar.current.component(component, from: self) != Calendar.current.component(component, from: other) {
                return component
            }
        }
        
        return nil
    }
    
    public func componentDeltas(to other:Date, units:[Calendar.Component] = [
        Calendar.Component.year,
        Calendar.Component.weekOfYear,
        Calendar.Component.day,
        Calendar.Component.hour,
        Calendar.Component.minute,
        Calendar.Component.second
        ]) -> [Calendar.Component] {
        
        var r:[Calendar.Component] = []
        
        for component in units
        {
            if Calendar.current.component(component, from: self) != Calendar.current.component(component, from: other) {
                r.append(component)
            }
        }
        
        return r
    }
    
    public func adding  (withCalendar calendar:Calendar = Calendar(identifier: .iso8601), years:Int = 0, months:Int = 0, days:Int = 0, hours:Int = 0, minutes:Int = 0, seconds:Int = 0) -> Date? {
        var components      = DateComponents()
        
        components.year     = years
        components.month    = months
        components.day      = days
        components.hour     = hours
        components.minute   = minutes
        components.second   = seconds
        
        return calendar.date(byAdding: components, to: self)
    }

    public func year   (withCalendar calendar:Calendar = Calendar(identifier: .iso8601)) -> Int { return calendar.component(.year, from: self) }
    public func month  (withCalendar calendar:Calendar = Calendar(identifier: .iso8601)) -> Int { return calendar.component(.month, from: self) }
    public func day    (withCalendar calendar:Calendar = Calendar(identifier: .iso8601)) -> Int { return calendar.component(.day, from: self) }
    public func hour   (withCalendar calendar:Calendar = Calendar(identifier: .iso8601)) -> Int { return calendar.component(.hour, from: self) }
    public func minute (withCalendar calendar:Calendar = Calendar(identifier: .iso8601)) -> Int { return calendar.component(.minute, from: self) }
    public func second (withCalendar calendar:Calendar = Calendar(identifier: .iso8601)) -> Int { return calendar.component(.second, from: self) }
    public func millisecond (withCalendar calendar:Calendar = Calendar(identifier: .iso8601)) -> Int {
        return Int(Int64(timeIntervalSinceReferenceDate * 1000) % 1000)
    }

}

extension Date {
    public static let iso8601Formatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.calendar = Calendar(identifier: .iso8601)
        formatter.locale = Locale(identifier: "en_US_POSIX")
//        formatter.timeZone = TimeZone.local
        formatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSSXXXXX"
        return formatter
    }()
    
    public var iso8601: String {
        return Date.iso8601Formatter.string(from: self)
    }
}

extension String {
    public var dateFromISO8601: Date? {
        return Date.iso8601Formatter.date(from: self)
    }
}

extension Date {
    
    public static func create   (withCalendar calendar:Calendar = Calendar(identifier: .iso8601), year:Int, month:Int, day:Int, hour:Int = 0, minute:Int = 0, second:Int = 0) -> Date? {
        var components      = DateComponents()
        
        components.year     = year
        components.month    = month
        components.day      = day
        components.hour     = hour
        components.minute   = minute
        components.second   = second
        
        return calendar.date(from:components)
    }
    
    public func valid           (withCalendar calendar:Calendar = Calendar(identifier: .iso8601), year:Int, month:Int, day:Int, hour:Int = 0, minute:Int = 0, second:Int = 0) -> Bool {
        return year     == self.year(withCalendar: calendar)
            && month    == self.month(withCalendar: calendar)
            && day      == self.day(withCalendar: calendar)
            && hour     == self.hour(withCalendar: calendar)
            && minute   == self.minute(withCalendar: calendar)
            && second   == self.second(withCalendar: calendar)
    }
    
    
    public static func valid    (withCalendar calendar:Calendar = Calendar(identifier: .iso8601), year:Int, month:Int, day:Int, hour:Int = 0, minute:Int = 0, second:Int = 0) -> Bool {
        if let date = Date.create(withCalendar: calendar, year: year, month: month, day: day, hour: hour, minute: minute, second: second) {
            return date.valid(withCalendar:calendar, year:year, month:month, day:day, hour:hour, minute:minute, second:second)
        }
        return false
    }
}

extension Date {
    
    public var asYYYYMMDDHHMMSSMS : UInt64 {
        let yyyy = UInt64(year())   * 10000000000000
        let   mm = UInt64(month())  *   100000000000
        let   dd = UInt64(day())    *     1000000000
        let   hh = UInt64(hour())   *       10000000
        let   mi = UInt64(minute()) *         100000
        let   ss = UInt64(second()) *           1000
        let   ms = UInt64(millisecond())
        return yyyy + mm + dd + hh + mi + ss + ms
    }

}

extension Date {

	enum WeekDay : Int {
		case sunday = 0, monday, tuesday, wednesday, thursday, friday, saturday
	}

	var weekday:WeekDay {
		return WeekDay(rawValue:Calendar(identifier: .gregorian).component(.weekday, from: self))!
	}
}

