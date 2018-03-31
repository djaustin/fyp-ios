//
//  Date+StartAndEndOfDay.swift
//  Digital Monitor
//
//  Created by Dan Austin on 28/01/2018.
//  Copyright © 2018 Dan Austin. All rights reserved.
//

import Foundation

extension Date {
    
    /// Get the start of the day from the date
    var startOfDay: Date {
        return Calendar.current.startOfDay(for: self)
    }
    
    /// Get the end of the day from the date
    var endOfDay: Date? {
        var components = DateComponents()
        components.day = 1
        components.second = -1
        return Calendar.current.date(byAdding: components, to: startOfDay)
    }
    
    /// Convert the date into a string using the format provided
    ///
    /// - Parameter format: String format to produce from date
    /// - Returns: String of date
    func toString( dateFormat format  : String ) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = format
        return dateFormatter.string(from: self)
    }
        
    
}
