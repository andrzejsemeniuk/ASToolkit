//
//  ExtensionForFoundationDate.swift
//  ASToolkit
//
//  Created by andrzej semeniuk on 12/15/16.
//  Copyright © 2017 Andrzej Semeniuk. All rights reserved.
//

import Foundation

public extension Date {
    
    func componentDelta(to other:Date, units:[Calendar.Component] = [
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
    
    func componentDeltas(to other:Date, units:[Calendar.Component] = [
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
    
    func adding  (withCalendar calendar:Calendar = Calendar(identifier: .iso8601), years:Int = 0, quarter:Int = 0, months:Int = 0, days:Int = 0, hours:Int = 0, minutes:Int = 0, seconds:Int = 0) -> Date? {
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
    
    var componentsOfYYYYMMDDHHMMSS: [String] {
        let calendar = Calendar.current
        let components = calendar.dateComponents([.year, .month, .day, .hour, .minute, .second], from: self)
        
        return [
            String(format: "%04d", components.year ?? 0),
            String(format: "%02d", components.month ?? 0),
            String(format: "%02d", components.day ?? 0),
            String(format: "%02d", components.hour ?? 0),
            String(format: "%02d", components.minute ?? 0),
            String(format: "%02d", components.second ?? 0)
        ]
    }
    
    func  year         (withCalendar  calendar:Calendar  =  Calendar(identifier:  .iso8601))  ->  Int  {  return  calendar.component(.year,                        from:    self)  }
    func  month        (withCalendar  calendar:Calendar  =  Calendar(identifier:  .iso8601))  ->  Int  {  return  calendar.component(.month,                       from:    self)  }
    func  week         (withCalendar  calendar:Calendar  =  Calendar(identifier:  .iso8601))  ->  Int  {  return  calendar.component(.weekOfYear,                  from:    self)  }
    func  day          (withCalendar  calendar:Calendar  =  Calendar(identifier:  .iso8601))  ->  Int  {  return  calendar.component(.day,                         from:    self)  }
    func  dayOfYear    (withCalendar  calendar:Calendar  =  Calendar(identifier:  .iso8601))  ->  Int  {  return  Int(Date.dateFormatterForDayOfYear.string(from:  self))!  }
    func  weekOfYear   (withCalendar  calendar:Calendar  =  Calendar(identifier:  .iso8601))  ->  Int  {  return  Int(Date.dateFormatterForWeekOfYear.string(from:  self))!  }
    func  monthOfYear  (withCalendar  calendar:Calendar  =  Calendar(identifier:  .iso8601))  ->  Int  {  return  Int(Date.dateFormatterForMonthOfYear.string(from:  self))!  }
    func  hour         (withCalendar  calendar:Calendar  =  Calendar(identifier:  .iso8601))  ->  Int  {  return  calendar.component(.hour,                        from:    self)  }
    func  minute       (withCalendar  calendar:Calendar  =  Calendar(identifier:  .iso8601))  ->  Int  {  return  calendar.component(.minute,                      from:    self)  }
    func  second       (withCalendar  calendar:Calendar  =  Calendar(identifier:  .iso8601))  ->  Int  {  return  calendar.component(.second,                      from:    self)  }
    func  millisecond  (withCalendar  calendar:Calendar  =  Calendar(identifier:  .iso8601))  ->  Int  {
        return Int(Int64(timeIntervalSinceReferenceDate * 1000) % 1000)
    }
    
    static  let  dateFormatterForDayOfYear    :  DateFormatter  =  .init(withFormat:  "DDD")
    static  let  dateFormatterForWeekOfYear   :  DateFormatter  =  .init(withFormat:  "w")
    static  let  dateFormatterForMonthOfYear  :  DateFormatter  =  .init(withFormat:  "MM")
    
    var monthLetter : String {
        month3Letters[0].string
    }
    var month3Letters : String {
        ["JAN","FEB","MAR","APR","MAY","JUN","JUL","AUG","SEP","OCT","NOV","DEC"][month()-1]
    }
    var monthName : String {
        ["January","February","March","April","May","June","July","August","September","October","November","December"][month()-1]
    }
    
        // "2018-06-01 00:00:00 +0000"
    var GMTYear          : Int? { asString[0...3].asInt }
    var GMTMonth         : Int? { asString[5...6].asInt }
    var GMTDay           : Int? { asString[8...9].asInt }
    var GMTHour          : Int? { asString[11...12].asInt }
    var GMTMinute        : Int? { asString[14...15].asInt }
    var GMTSecond        : Int? { asString[17...18].asInt }
    
    static let zero : Date = .init(timeIntervalSince1970: 0)
    
    static func GMTCreateDate(year: Int, month: Int, day: Int, hour: Int, minute: Int, second: Int) -> Date? {
        var dateComponents = DateComponents()
        dateComponents.year = year
        dateComponents.month = month
        dateComponents.day = day
        dateComponents.hour = hour
        dateComponents.minute = minute
        dateComponents.second = second
        
            // Set the time zone to GMT
        dateComponents.timeZone = TimeZone(abbreviation: "GMT")
        
            // Create the date using the calendar
        let calendar = Calendar(identifier: .gregorian)
        return calendar.date(from: dateComponents)
    }
    
    static func GMTCreateDate(YYYYMMDDHHMMSS compactDate: UInt64) -> Date? {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyyMMddHHmmss"
        formatter.timeZone = TimeZone(identifier: "GMT")
        
        let dateString = String(format: "%014llu", compactDate)
        return formatter.date(from: dateString)
    }
    
        //    static public var GMTnow : Date {
        //        let now = Date.now
        //        let gmtTimeZone = TimeZone(abbreviation: "GMT")!
        //        let gmtCalendar = Calendar(identifier: .gregorian)
        //        var dateComponents = gmtCalendar.dateComponents(in: gmtTimeZone, from: now)
        //
        //        dateComponents.timeZone = gmtTimeZone
        //        return gmtCalendar.date(from: dateComponents)!
        //    }
    
    static var GMTnow: Date {
        let now = Date.now
        return now.convertToGMT()
    }
    
    func convertToGMT() -> Date {
        let timezone = TimeZone.current
        let seconds = TimeInterval(timezone.secondsFromGMT())
        return self.addingTimeInterval(-seconds)
    }
    
    
    var GMTtoYYYYMMDDHHMMSS: UInt64 {
        toYYYYMMDDHHMMSS(timeZone: TimeZone(abbreviation: "GMT")!)
    }

}

public extension Date {
    
    static func UTCCreateDate(year: Int, month: Int, day: Int, hour: Int, minute: Int, second: Int) -> Date? {
        var dateComponents = DateComponents()
        dateComponents.year = year
        dateComponents.month = month
        dateComponents.day = day
        dateComponents.hour = hour
        dateComponents.minute = minute
        dateComponents.second = second
        
        // Set the time zone to UTC
        dateComponents.timeZone = TimeZone(abbreviation: "UTC")
        
        // Create the date using the calendar
        let calendar = Calendar(identifier: .gregorian)
        return calendar.date(from: dateComponents)
    }

    static func UTCCreateDate(YYYYMMDDHHMMSS compactDate: UInt64) -> Date? {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyyMMddHHmmss"
        formatter.timeZone = TimeZone(identifier: "UTC")
        
        let dateString = String(format: "%014llu", compactDate)
        return formatter.date(from: dateString)
    }
    
    static var UTCnow: Date {
        // Date objects are already in UTC internally
        return Date()
    }
    
    func toYYYYMMDDHHMMSS(timeZone: TimeZone = .UTC) -> UInt64 {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyyMMddHHmmss"
        formatter.timeZone = timeZone
        
        let dateString = formatter.string(from: self)
        return UInt64(dateString) ?? 0
    }

    var UTCtoYYYYMMDDHHMMSS: UInt64 {
        toYYYYMMDDHHMMSS(timeZone: TimeZone(abbreviation: "UTC")!)
    }
     
    var toLocal2: Date {
        let calendar = Calendar.current
        let components = calendar.dateComponents(in: TimeZone.current, from: self)
        return calendar.date(from: components) ?? self
    }
    var toLocal: Date {
        let timezone = TimeZone.current
        let seconds = TimeInterval(timezone.secondsFromGMT(for: self))
        return Date(timeInterval: seconds, since: self)
    }
    var toLocal3: Date {
        let timeZoneOffset = TimeZone.current.secondsFromGMT()
        guard let localDate = Calendar.current.date(byAdding: .second, value: timeZoneOffset, to: self) else {
            return self
        }
        return localDate
    }
}

public extension TimeZone {
    static let GMT = TimeZone(abbreviation: "GMT")!
    static let UTC = TimeZone(abbreviation: "UTC")!
}

public extension Date {
    
    /// Calculates the difference in seconds between two dates, accounting for different time zones
    /// - Parameter other: The date to compare against
    /// - Returns: TimeInterval representing the number of seconds between the dates
    func secondsFrom(_ other: Date) -> TimeInterval {
            // Convert both dates to UTC/GMT to ensure accurate time difference calculation
        let calendar = Calendar.current
        let thisUTC = calendar.date(byAdding: .second, value: TimeZone.current.secondsFromGMT(), to: self)!
        let otherUTC = calendar.date(byAdding: .second, value: TimeZone.current.secondsFromGMT(), to: other)!
        
            // Calculate difference using timeIntervalSince which returns seconds
        return thisUTC.timeIntervalSince(otherUTC)
    }
    
    
    var timeZoneAbbreviation: String {
        timeZoneAbbreviation(in: .current, fallback: "")
    }
        
        // If you want more control, you can also specify the timezone:
    func timeZoneAbbreviation(in timeZone: TimeZone, fallback: String = "") -> String {
        timeZone.abbreviation(for: self) ?? fallback
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
        formatted("yyyy-MM-dd HH:mm:ss")
//        formatted("YYYY-MM-dd HH:mm:ss")
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
    
    var toYYYYMMDDHHMMSSMSNSLocalTime : String {
        toYYYYMMDDHHMMSSLocalTime.asString + nanoseconds.asString.prefixed(upToLength: 9, with: "0")
    }

    var toYYYYMMDDHHMMSSMSLocalTime : UInt64 {
        let yyyy = UInt64(year())   * 10000000000000
        let   mm = UInt64(month())  *   100000000000
        let   dd = UInt64(day())    *     1000000000
        let   hh = UInt64(hour())   *       10000000
        let   mi = UInt64(minute()) *         100000
        let   ss = UInt64(second()) *           1000
        let   ms = UInt64(millisecond())
        return yyyy + mm + dd + hh + mi + ss + ms
    }

    var toYYYYMMDDHHMMSSLocalTime : UInt64 {
        let yyyy = UInt64(year())   * 10000000000
        let   mm = UInt64(month())  *   100000000
        let   dd = UInt64(day())    *     1000000
        let   hh = UInt64(hour())   *       10000
        let   mi = UInt64(minute()) *         100
        let   ss = UInt64(second())
        return yyyy + mm + dd + hh + mi + ss
    }

    var toYYYYMMDDHHMMLocalTime : UInt64 {
        let yyyy = UInt64(year())   * 100000000
        let   mm = UInt64(month())  *   1000000
        let   dd = UInt64(day())    *     10000
        let   hh = UInt64(hour())   *       100
        let   mi = UInt64(minute())
        return yyyy + mm + dd + hh + mi
    }

    var toYYYYMMDDHHLocalTime : UInt64 {
        let yyyy = UInt64(year())   * 1000000
        let   mm = UInt64(month())  *   10000
        let   dd = UInt64(day())    *     100
        let   hh = UInt64(hour())
        return yyyy + mm + dd + hh
    }

    var toYYYYMMDDLocalTime : UInt64 {
        let yyyy = UInt64(year())   * 10000
        let   mm = UInt64(month())  *   100
        let   dd = UInt64(day())
        return yyyy + mm + dd
    }

    var toYYYYMMLocalTime : UInt64 {
        let yyyy = UInt64(year())   * 100
        let   mm = UInt64(month())
        return yyyy + mm
    }

    var toHHMM : UInt {
        let   hh = UInt(hour())   *       100
        let   mi = UInt(minute())
        return hh + mi
    }
    
    var asYYYYMMDD : UInt32 {
        Date.now.formatted("yyyyMMdd").asInt?.asUInt32 ?? 0
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
    
    
    var asStringYYYYMMDDHHMMSS: String {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy/MM/dd HH:mm:ss"
        return formatter.string(from: self)
    }
    
    var asStringHHMM: String {
        let formatter = DateFormatter()
        formatter.dateFormat = "HH:mm"
        return formatter.string(from: self)
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
        
        var short2 : String {
            name[0...1].asString
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

    var tomorrow : Date {
        adding(days: +1)!
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
    
    static let minutesIn1Day    : TimeInterval = 24.0 * 60.0
}

public extension TimeInterval {
    
    var asDate : Date { Date.init(timeIntervalSince1970: self) }
    var asDateValidated : Date? { self.isValidTimestamp ? Date.init(timeIntervalSince1970: self) : nil }
    
    static var timestamp : TimeInterval {
        Date().timeIntervalSince1970
    }

    static var now : TimeInterval {
        Date().timeIntervalSince1970
    }
    
    static let secondsInHour    : TimeInterval = 60 * 60
    static let secondsInDay     : TimeInterval = 60 * 60 * 24
    static let secondsInWeek    : TimeInterval = 60 * 60 * 24 * 7
    static let secondsInMonth   : TimeInterval = 60 * 60 * 24 * 31
    static let secondsInYear    : TimeInterval = 60 * 60 * 24 * 365

    var isValidTimestamp : Bool {
        self != 0.0
    }

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
    
    func remainingDaysHoursMinutes(until endDate: Date) -> (days: Int, hours: Int, minutes: Int) {
        let calendar = Calendar.current
        let components = calendar.dateComponents([.day, .hour, .minute], from: self, to: endDate)
        
        return (
            days: components.day ?? 0,
            hours: components.hour ?? 0,
            minutes: components.minute ?? 0
        )
    }
    
    func remainingDaysHoursMinutesFormatted(until endDate: Date) -> (days: String?, hours: String?, minutes: String?) {
        let remaining = self.remainingDaysHoursMinutes(until: endDate)
        
        if remaining.days > 0 {
            return ("\(remaining.days) day" + (remaining.days > 1 ? "s" : ""), nil, nil)
        } else if remaining.hours > 0 {
            return (nil, "\(remaining.hours) hour" + (remaining.hours > 1 ? "s" : ""), nil)
        } else {
            return (nil, nil, "\(remaining.minutes) minute" + (remaining.minutes != 1 ? "s" : ""))
        }
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

    var asStringOfElapsedTimeFromSeconds : String {
        let seconds = self
        
        // Convert to various time units
        let years = seconds / (365 * 24 * 3600)
        let months = seconds / (30 * 24 * 3600)
        let days = seconds / (24 * 3600)
        let hours = seconds / 3600
        let minutes = seconds / 60
        
        // Return the most significant non-zero unit
        if years > 0 {
            return "Over \(years) year\(String.s(years))"
        } else if months > 0 {
            return "Over \(months) month\(String.s(months))"
        } else if days > 0 {
            return "Over \(days) day\(String.s(days))"
        } else if hours > 0 {
            return "Over \(hours) hour\(String.s(hours))"
        } else if minutes > 0 {
            return "Over \(minutes) minute\(String.s(minutes))"
        } else {
            return "\(Swift.max(seconds, 0)) second\(String.s(seconds))"
        }
    }

    var asBriefStringOfElapsedTimeFromSeconds : String {
        let seconds = self
        
        // Convert to various time units
        let years = seconds / (365 * 24 * 3600)
        let months = seconds / (30 * 24 * 3600)
        let days = seconds / (24 * 3600)
        let hours = seconds / 3600
        let minutes = seconds / 60
        
        // Return the most significant non-zero unit
        if years > 0 {
            return "\(years)a"
        } else if months > 0 {
            return "\(months)mo"
        } else if days > 0 {
            return "\(days)d"
        } else if hours > 0 {
            return "\(hours)h"
        } else if minutes > 0 {
            return "\(minutes)m"
        } else {
            return "\(Swift.max(seconds, 0))s"
        }
    }

    var asBriefStringOfAllElapsedComponentsFromSeconds: String {
        var totalSeconds = Swift.max(self, 0)
        let years = totalSeconds / (365 * 24 * 3600)
        totalSeconds -= years * (365 * 24 * 3600)
        let months = totalSeconds / (30 * 24 * 3600)
        totalSeconds -= months * (30 * 24 * 3600)
        let days = totalSeconds / (24 * 3600)
        totalSeconds -= days * (24 * 3600)
        let hours = totalSeconds / 3600
        totalSeconds -= hours * 3600
        let minutes = totalSeconds / 60
        totalSeconds -= minutes * 60
        let seconds = totalSeconds
        var parts: [String] = []
        if years > 0 { parts.append("\(years)a") }
        if months > 0 { parts.append("\(months)mo") }
        if days > 0 { parts.append("\(days)d") }
        if hours > 0 { parts.append("\(hours)h") }
        if minutes > 0 { parts.append("\(minutes)m") }
        if seconds > 0 { parts.append("\(seconds)s") }
        if parts.isEmpty { return "0s" }
        return parts.joined(separator: " ")
    }
}


public extension Calendar {
    func isWeekend(_ date: Date) -> Bool {
        let weekday = component(.weekday, from: date)
        return weekday == 1 || weekday == 7 // Sunday or Saturday
    }

    func isWeekday(_ date: Date) -> Bool {
        !isWeekend(date)
    }
}


public extension Date {
    
    static let referenceDate200001010000: Date = {
        var comps = DateComponents()
        comps.year = 2000; comps.month = 1; comps.day = 1;
        comps.hour = 0; comps.minute = 0;
        return Calendar.current.date(from: comps)!
    }()

}

public extension Date {
    
    var asBriefStringOfAllElapsedComponentsFromSecondsSinceNow : String {
        (Date.timestamp - self.timeIntervalSince1970).asInt.asBriefStringOfAllElapsedComponentsFromSeconds
    }
    
    var asStringOfAllElapsedComponentsAgo : String {
        asBriefStringOfAllElapsedComponentsFromSecondsSinceNow
    }
    
    var asBriefStringOfElapsedTimeFromSeconds : String {
        (Date.timestamp - self.timeIntervalSince1970).asInt.asBriefStringOfElapsedTimeFromSeconds
    }
    
    var asStringAgo : String {
        asBriefStringOfElapsedTimeFromSeconds
    }
    
    var ago : String {
        asBriefStringOfElapsedTimeFromSeconds + " ago"
    }
    
}

