//
//  String+FromSeconds.swift
//  Digital Monitor
//
//  Created by Dan Austin on 17/01/2018.
//  Copyright © 2018 Dan Austin. All rights reserved.
//

import Foundation

extension String {
    init(digitalClockFormatFromSeconds seconds: Int){
        func hoursMinutesSeconds(fromSeconds seconds: Int) -> (Int, Int, Int) {
            return (seconds / 3600, (seconds % 3600) / 60, seconds % 60)
        }
        
        let (h,m,s) = hoursMinutesSeconds(fromSeconds: seconds)
        
        let timeString = String(format: "%u:%02u:%02u", h, m, s)

        self.init(timeString)
        
    }
}
