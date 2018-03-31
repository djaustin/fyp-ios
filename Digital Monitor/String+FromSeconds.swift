//
//  String+FromSeconds.swift
//  Digital Monitor
//
//  Created by Dan Austin on 17/01/2018.
//  Copyright © 2018 Dan Austin. All rights reserved.
//

import Foundation

extension String {
    
    /// Convert seconds as integer to string displaying time in human readable format
    ///
    /// - Parameter seconds: number of seconds as integer
    init(digitalClockFormatFromSeconds seconds: Int){
        func hoursMinutesSeconds(fromSeconds seconds: Int) -> (Int, Int, Int) {
            return (seconds / 3600, (seconds % 3600) / 60, seconds % 60)
        }
        
        let (h,m,s) = hoursMinutesSeconds(fromSeconds: seconds)
        var timeString = "\(h)h \(m)m"
        if h < 1 {
            if m < 1 {
                timeString = "\(s)s"
            } else {
                timeString = "\(m)m \(s)s"
            }
        }
    
        self.init(timeString)
        
    }
}

