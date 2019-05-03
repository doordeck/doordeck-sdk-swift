//
//  DateExtension.swift
//  doordeck-sdk-swift
//
//  Copyright © 2019 Doordeck. All rights reserved.
//

import Foundation

extension Date {
    /// Returns the amount of years from another date
    func years(from date: Date) -> Int {
        return Calendar.current.dateComponents([.year], from: date, to: self).year ?? 0
    }
    /// Returns the amount of months from another date
    func months(from date: Date) -> Int {
        return Calendar.current.dateComponents([.month], from: date, to: self).month ?? 0
    }
    /// Returns the amount of weeks from another date
    func weeks(from date: Date) -> Int {
        return Calendar.current.dateComponents([.weekOfYear], from: date, to: self).weekOfYear ?? 0
    }
    /// Returns the amount of days from another date
    func days(from date: Date) -> Int {
        return Calendar.current.dateComponents([.day], from: date, to: self).day ?? 0
    }
    /// Returns the amount of hours from another date
    func hours(from date: Date) -> Int {
        return Calendar.current.dateComponents([.hour], from: date, to: self).hour ?? 0
    }
    /// Returns the amount of minutes from another date
    func minutes(from date: Date) -> Int {
        return Calendar.current.dateComponents([.minute], from: date, to: self).minute ?? 0
    }
    /// Returns the amount of seconds from another date
    func seconds(from date: Date) -> Int {
        return Calendar.current.dateComponents([.second], from: date, to: self).second ?? 0
    }
    /// Returns the a custom time interval description from another date
    func offset(from date: Date) -> String {
        if years(from: date)   > 0 { return "\(years(from: date))y"   }
        if months(from: date)  > 0 { return "\(months(from: date))M"  }
        if weeks(from: date)   > 0 { return "\(weeks(from: date))w"   }
        if days(from: date)    > 0 { return "\(days(from: date))d"    }
        if hours(from: date)   > 0 { return "\(hours(from: date))h"   }
        if minutes(from: date) > 0 { return "\(minutes(from: date))m" }
        if seconds(from: date) > 0 { return "\(seconds(from: date))s" }
        return ""
    }
    
    public func setTime(hour: Int, min: Int, sec: Int, timeZoneAbbrev: String = "GMT") -> Date? {
        let x: Set<Calendar.Component> = [.year, .month, .day, .hour, .minute, .second]
        let cal = Calendar.current
        var components = cal.dateComponents(x, from: self)
        
        components.timeZone = TimeZone(abbreviation: timeZoneAbbrev)
        components.hour = hour
        components.minute = min
        components.second = sec
        
        return cal.date(from: components)
    }
}

extension UUID {
    
    var isTimeUUID: Bool {
        return (uuid.8 & 0xC0) == 0x80 && (uuid.6 & 0xF0) == 0x10 
    }
    
    var generationDate: Date? {
        guard isTimeUUID else {return nil}
        
        let dateInt: UInt64 = (
            UInt64(uuid.3)        * 0x1 +
                UInt64(uuid.2)        * 0x100 +
                UInt64(uuid.1)        * 0x10000 +
                UInt64(uuid.0)        * 0x1000000 +
                UInt64(uuid.5)        * 0x100000000 +
                UInt64(uuid.4)        * 0x10000000000 +
                UInt64(uuid.7)        * 0x1000000000000 +
                UInt64(uuid.6 & 0x0F) * 0x100000000000000
        )
        
        return Date(timeInterval: TimeInterval(dateInt)/10000000, since: Date(timeIntervalSince1970: TimeInterval(-12219292800.0)))
    }
    
}
