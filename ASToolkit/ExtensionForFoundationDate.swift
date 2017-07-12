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
    
    public func added(days:Double = 0, hours:Double = 0, minutes:Double = 0, seconds:Double = 0) -> Date {
        return Date(timeIntervalSinceNow: self.timeIntervalSinceNow + seconds + minutes * 60.0 + hours * 3600.0 + days * 86400.0)
    }
    
}

extension Date {
    public static let iso8601Formatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.calendar = Calendar(identifier: .iso8601)
        formatter.locale = Locale(identifier: "en_US_POSIX")
        formatter.timeZone = TimeZone(secondsFromGMT: 0)
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
