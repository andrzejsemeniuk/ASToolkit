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
        Calendar.Component.month,
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
        Calendar.Component.month,
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
    
    public func adding  (withCalendar calendar:Calendar = Calendar(identifier: .iso8601), years:Int = 0, quarter:Int = 0, months:Int = 0, days:Int = 0, hours:Int = 0, minutes:Int = 0, seconds:Int = 0) -> Date? {
        var components      = DateComponents()
        
        components.year     = years
        components.quarter  = quarter
        components.month    = months
        components.day      = days
        components.hour     = hours
        components.minute   = minutes
        components.second   = seconds
        
        return calendar.date(byAdding: components, to: self)
    }
    
    public  func  year         (withCalendar  calendar:Calendar  =  Calendar(identifier:  .iso8601))  ->  Int  {  return  calendar.component(.year,                        from:    self)  }
    public  func  month        (withCalendar  calendar:Calendar  =  Calendar(identifier:  .iso8601))  ->  Int  {  return  calendar.component(.month,                       from:    self)  }
    public  func  week         (withCalendar  calendar:Calendar  =  Calendar(identifier:  .iso8601))  ->  Int  {  return  calendar.component(.weekOfYear,                  from:    self)  }
    public  func  day          (withCalendar  calendar:Calendar  =  Calendar(identifier:  .iso8601))  ->  Int  {  return  calendar.component(.day,                         from:    self)  }
    public  func  dayOfYear    (withCalendar  calendar:Calendar  =  Calendar(identifier:  .iso8601))  ->  Int  {  return  Int(Date.dateFormatterForDayOfYear.string(from:  self))!  }
    public  func  weekOfYear   (withCalendar  calendar:Calendar  =  Calendar(identifier:  .iso8601))  ->  Int  {  return  Int(Date.dateFormatterForWeekOfYear.string(from:  self))!  }
    public  func  monthOfYear  (withCalendar  calendar:Calendar  =  Calendar(identifier:  .iso8601))  ->  Int  {  return  Int(Date.dateFormatterForMonthOfYear.string(from:  self))!  }
    public  func  hour         (withCalendar  calendar:Calendar  =  Calendar(identifier:  .iso8601))  ->  Int  {  return  calendar.component(.hour,                        from:    self)  }
    public  func  minute       (withCalendar  calendar:Calendar  =  Calendar(identifier:  .iso8601))  ->  Int  {  return  calendar.component(.minute,                      from:    self)  }
    public  func  second       (withCalendar  calendar:Calendar  =  Calendar(identifier:  .iso8601))  ->  Int  {  return  calendar.component(.second,                      from:    self)  }
    public  func  millisecond  (withCalendar  calendar:Calendar  =  Calendar(identifier:  .iso8601))  ->  Int  {
        return Int(Int64(timeIntervalSinceReferenceDate * 1000) % 1000)
    }
    
    public  static  let  dateFormatterForDayOfYear    :  DateFormatter  =  .init(withFormat:  "DDD")
    public  static  let  dateFormatterForWeekOfYear   :  DateFormatter  =  .init(withFormat:  "w")
    public  static  let  dateFormatterForMonthOfYear  :  DateFormatter  =  .init(withFormat:  "MM")
    
    public var monthLetter : String {
        month3Letters[0].string
    }
    public var month3Letters : String {
        ["JAN","FEB","MAR","APR","MAY","JUN","JUL","AUG","SEP","OCT","NOV","DEC"][month()-1]
    }
    public var monthName : String {
        ["January","February","March","April","May","June","July","August","September","October","November","December"][month()-1]
    }
    
    // "2018-06-01 00:00:00 +0000"
    public var GMTYear          : Int? { asString[0...3].asInt }
    public var GMTMonth         : Int? { asString[5...6].asInt }
    public var GMTDay           : Int? { asString[8...9].asInt }
    public var GMTHour          : Int? { asString[11...12].asInt }
    public var GMTMinute        : Int? { asString[14...15].asInt }
    public var GMTSecond        : Int? { asString[17...18].asInt }

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
        Date.iso8601Formatter.string(from: self)
    }

    public func formatted(_ format:String) -> String {
        // "yyyy-MM-dd'T'HH:mm:ssZZZZZ"
        let formatter = DateFormatter()
        formatter.calendar = Calendar(identifier: .iso8601)
        formatter.locale = Locale(identifier: "en_US_POSIX")
        //        formatter.timeZone = TimeZone.local
        formatter.dateFormat = format
        return formatter.string(from: self)
    }

    public func formatted(_ formatter: DateFormatter) -> String {
        formatter.string(from: self)
    }
    
    public func formattedYYYYMMddHHmmss() -> String {
        formatted("YYYY-MM-dd HH:mm:ss")
    }
    
	public static func formatter(withFormat format:String) -> DateFormatter {
		let formatter = DateFormatter()
		formatter.calendar = Calendar(identifier: .iso8601)
		formatter.locale = Locale(identifier: "en_US_POSIX")
		//        formatter.timeZone = TimeZone.local
		formatter.dateFormat = format
		return formatter
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

public extension Date {
    
    var idWithNanoseconds : UInt64 {
        (self.timeIntervalSince1970 * 1000000000.0).asUInt64
    }

    var nanoseconds : UInt64 {
        (self.timeIntervalSince1970 * 1000000000.0).asUInt64 - (self.timeIntervalSince1970.asUInt64 * 1000000000)
    }
    
    var toYYYYMMDDHHMMSSMSNS : String {
        toYYYYMMDDHHMMSS.asString + nanoseconds.asString.prefixed(upToLength: 9, with: "0")
    }

    var toYYYYMMDDHHMMSSMS : UInt64 {
        let yyyy = UInt64(year())   * 10000000000000
        let   mm = UInt64(month())  *   100000000000
        let   dd = UInt64(day())    *     1000000000
        let   hh = UInt64(hour())   *       10000000
        let   mi = UInt64(minute()) *         100000
        let   ss = UInt64(second()) *           1000
        let   ms = UInt64(millisecond())
        return yyyy + mm + dd + hh + mi + ss + ms
    }

    var toYYYYMMDDHHMMSS : UInt64 {
        let yyyy = UInt64(year())   * 10000000000
        let   mm = UInt64(month())  *   100000000
        let   dd = UInt64(day())    *     1000000
        let   hh = UInt64(hour())   *       10000
        let   mi = UInt64(minute()) *         100
        let   ss = UInt64(second())
        return yyyy + mm + dd + hh + mi + ss
    }

    var toYYYYMMDDHHMM : UInt64 {
        let yyyy = UInt64(year())   * 100000000
        let   mm = UInt64(month())  *   1000000
        let   dd = UInt64(day())    *     10000
        let   hh = UInt64(hour())   *       100
        let   mi = UInt64(minute())
        return yyyy + mm + dd + hh + mi
    }

    var toYYYYMMDDHH : UInt64 {
        let yyyy = UInt64(year())   * 1000000
        let   mm = UInt64(month())  *   10000
        let   dd = UInt64(day())    *     100
        let   hh = UInt64(hour())
        return yyyy + mm + dd + hh
    }

    var toYYYYMMDD : UInt64 {
        let yyyy = UInt64(year())   * 10000
        let   mm = UInt64(month())  *   100
        let   dd = UInt64(day())
        return yyyy + mm + dd
    }

    var toYYYYMM : UInt64 {
        let yyyy = UInt64(year())   * 100
        let   mm = UInt64(month())
        return yyyy + mm
    }

    var toHHMM : UInt {
        let   hh = UInt(hour())   *       100
        let   mi = UInt(minute())
        return hh + mi
    }

    struct Components : Codable {
        
        var YYYY    : String
        var MM      : String
        var DD      : String
        var HH      : String
        var mm      : String
        var ss      : String
        
        init(_ date: Date) {
            YYYY = DateFormatter.init(withFormat: "yyyy").string(from: date)
            MM   = DateFormatter.init(withFormat: "MM").string(from: date)
            DD   = DateFormatter.init(withFormat: "DD").string(from: date)
            HH   = DateFormatter.init(withFormat: "HH").string(from: date)
            mm   = DateFormatter.init(withFormat: "mm").string(from: date)
            ss   = DateFormatter.init(withFormat: "ss").string(from: date)
        }
    }
    
    var toComponents : Components {
        .init(self)
    }
}

extension Date {

	enum WeekDay : Int {
		case sunday = 1, monday, tuesday, wednesday, thursday, friday, saturday
        
        var code : String {
            switch self {
                case .sunday    : return "N"
                case .monday    : return "M"
                case .tuesday   : return "T"
                case .wednesday : return "W"
                case .thursday  : return "R"
                case .friday    : return "F"
                case .saturday  : return "S"
            }
        }
        
        var name : String {
            switch self {
                case .sunday    : return "Sunday"
                case .monday    : return "Monday"
                case .tuesday   : return "Tuesday"
                case .wednesday : return "Wednesday"
                case .thursday  : return "Thursday"
                case .friday    : return "Friday"
                case .saturday  : return "Saturday"
            }
        }
	}

	var weekday : WeekDay {
		return WeekDay(rawValue:Calendar(identifier: .gregorian).component(.weekday, from: self))!
	}
}

public extension Date {

	var midnight : Date {
//		let calendar = Calendar.current
//
//		var components      = DateComponents()
//
//        components.hour        =  -self.hour()
//        components.minute      =  -self.minute()
//        components.second      =  -self.second()
//        
//		return calendar.date(byAdding: components, to: self)!
        
        formatted("yyyy-MM-dd").asDateWithFormat("yyyy-MM-dd")!
	}
    
    var normalizedToWeekday : Date {
        switch self.weekday {
            case .monday, .tuesday, .wednesday, .thursday, .friday: return self
            case .saturday: return .yesterday
            case .sunday: return .yesterday.yesterday
        }
    }
    
    var normalizedToMonth : Date {
        let calendar = Calendar.current
        var components = calendar.dateComponents([.year, .month], from: self)
        components.day = 1
        return calendar.date(from: components)!
    }
    
    
    var utc : Date {
        self.convertToUTC() ?? self
    }
    
    var normalizedToDay : Date { midnight }
    
    var normalizedToHour : Date {
        let calendar            = Calendar.current
        var components          = DateComponents()

        components.minute       =  -self.minute()
        components.second       =  -self.second()

        return calendar.date(byAdding: components, to: self)!
    }
    
    var normalizedToMinute : Date {
        let calendar            = Calendar.current
        var components          = DateComponents()

        components.second       =  -self.second()

        return calendar.date(byAdding: components, to: self)!
    }
    
    static var midnight : Date {
        Date().midnight
    }
    
    static var today : Date {
        Date().midnight
    }
    
    static var timestamp : TimeInterval {
        Date().timeIntervalSince1970
    }
    
    static var yesterday : Date {
        Date().yesterday
    }
    
    var yesterday : Date {
        adding(days: -1)!
    }

    func collect(days: Int, delta: Int, condition: (Date)->Bool) -> [Date] {
        collect(component: .day, count: days, delta: delta, condition: condition)
    }

    func collect(component: Calendar.Component, count: Int, delta: Int, condition: (Date)->Bool = { _ in true }) -> [Date] {
        var r : [Date] = []
        var date0 = self
        let delta = delta
        while r.count < count {
            var date1 : Date!
            switch component {
                case  .year:        date1  =  date0.adding(years:    delta)
                case  .month:       date1  =  date0.adding(months:   delta)
                case  .weekOfYear:  date1  =  date0.adding(days:     delta * 7)
                case  .day:         date1  =  date0.adding(days:     delta)
                case  .hour:        date1  =  date0.adding(hours:    delta)
                case  .minute:      date1  =  date0.adding(minutes:  delta)
                case  .second:      date1  =  date0.adding(seconds:  delta)
                default:
                    break
            }
            guard date1 != nil else { break }
            date0 = date1
            if condition(date0) {
                r.append(date0)
            }
        }
        return r
    }

    static  let  sunday     =  1
    static  let  monday     =  2
    static  let  tuesday    =  3
    static  let  wednesday  =  4
    static  let  thursday   =  5
    static  let  friday     =  6
    static  let  saturday   =  7

    var isWeekday : Bool {
        !Calendar.current.component(.weekday, from: self).in([Date.saturday,Date.sunday])
    }
    
    var isWeekend : Bool {
        Calendar.current.component(.weekday, from: self).in([Date.saturday,Date.sunday])
    }
    
    var isMonday : Bool { Calendar.current.component(.weekday, from: self) == Date.monday }
    var isTuesday : Bool { Calendar.current.component(.weekday, from: self) == Date.tuesday }
    var isWednesday : Bool { Calendar.current.component(.weekday, from: self) == Date.wednesday }
    var isThursday : Bool { Calendar.current.component(.weekday, from: self) == Date.thursday }
    var isFriday : Bool { Calendar.current.component(.weekday, from: self) == Date.friday }
    var isSaturday : Bool { Calendar.current.component(.weekday, from: self) == Date.saturday }
    var isSunday : Bool { Calendar.current.component(.weekday, from: self) == Date.sunday }
    
    static let secondsIn1Hour   : TimeInterval = 60.0 * 60.0
    static let secondsIn1Day    : TimeInterval = 24.0 * secondsIn1Hour
}

public extension TimeInterval {
    
    var asDate : Date { Date.init(timeIntervalSince1970: self) }
    
    static var timestamp : TimeInterval {
        Date().timeIntervalSince1970
    }

    static var now : TimeInterval {
        Date().timeIntervalSince1970
    }
    
    static var secondsInHour : TimeInterval { 60 * 60 }
    static var secondsInDay  : TimeInterval { 60 * 60 * 24 }
    static var secondsInWeek : TimeInterval { 60 * 60 * 24 * 7 }
    static var secondsInMonth : TimeInterval { 60 * 60 * 24 * 30 }
    static var secondsInYear : TimeInterval { 60 * 60 * 24 * 365 }


}

public extension Date {

    func convert(timeZoneFrom: TimeZone, timeZoneTo: TimeZone) -> Date? {
        let formatter = DateFormatter()
        formatter.calendar = .current
        formatter.timeZone = timeZoneFrom
        formatter.dateFormat = "yyyy-MM-dd hh:mm:ss"
        let string = formatter.string(from: self)
        formatter.timeZone = timeZoneTo
        return formatter.date(from: string)
    }
    
    func convertToUTC(timeZoneFrom: TimeZone = .current) -> Date? {
        convert(timeZoneFrom: timeZoneFrom, timeZoneTo: TimeZone(abbreviation: "UTC")!)
    }
    
}

public extension Date {
    
        // "2018-06-01 00:00:00 +0000"
    var asString        : String { "\(self)" }
    var asStringGMT     : String { "\(self)" }
    
    func asString(withFormat format: String) -> String {
        DateFormatter.init(withFormat: format).string(from: self)
    }
    
    @available(iOS 15, *)
    func asStringOfElapsedTimeInSecondsAsHHMMSS(from: Date = .now, limit: Int = 5) -> String {
        abs(from.timeIntervalSince1970 - self.timeIntervalSince1970).asInt.asStringOfElapsedTimeInSecondsAsHHMMSS(limit: limit)
    }
    
    @available(iOS 15, *)
    func asStringComponentsOfElapsedTime(from: Date = .now, minimum: TimeInterval = 0.0) -> [String] {
        var R : [String] = []
        var dT = abs(from.timeIntervalSince1970 - self.timeIntervalSince1970)
        for (duration,suffix,limit) in [
            (TimeInterval.secondsInYear,"y",999.0),
            (TimeInterval.secondsInMonth,"m",12.0),
            (TimeInterval.secondsInWeek,"w",4.0),
            (TimeInterval.secondsInDay,"d",7.0),
            (TimeInterval.secondsInHour,"h",24.0),
            (60.0,"m",60.0),
            (1.0,"s",60.0),
        ] {
            guard duration >= minimum else {
                break
            }
            if dT > duration {
                let V = dT / duration
                if V < limit {
                    let V = V.floor
                    R.append("\(V.format0)\(suffix)")
                    dT -= V * duration
                } else {
                    break
                }
            }
        }
        return R
    }
    
}

public extension Int {
    
    func asStringOfElapsedTimeInSecondsAsHHMMSS(limit: Int = 5) -> String {
        let SECONDS = self
        var r = ""
        let HH = SECONDS / 3600
        let MM = (SECONDS - HH * 3600) / 60
        let SS = (SECONDS - HH * 3600 - MM * 60)
        
        if HH > 0 {
            r += "\(HH)h"
        }
        if MM > 0 {
            if r.isNotEmpty {
                r += " "
            }
            r += "\(MM)m"
        }
        if HH == 0, MM < limit {
            if r.isNotEmpty {
                r += " "
            }
            r += "\(SS)s"
        }
        
        return r
    }

}
