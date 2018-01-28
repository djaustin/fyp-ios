//
//  Date+StartAndEndOfDay.swift
//  Digital Monitor
//
//  Created by Dan Austin on 28/01/2018.
//  Copyright © 2018 Dan Austin. All rights reserved.
//

import Foundation

extension Date {
    var startOfDay: Date {
        return Calendar.current.startOfDay(for: self)
    }
    
    var endOfDay: Date? {
        var components = DateComponents()
        components.day = 1
        components.second = -1
        return Calendar.current.date(byAdding: components, to: startOfDay)
    }
}
