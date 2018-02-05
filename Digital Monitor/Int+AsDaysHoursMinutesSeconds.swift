//
//  Int+AsDaysHoursMinutesSeconds.swift
//  Digital Monitor
//
//  Created by Dan Austin on 29/01/2018.
//  Copyright © 2018 Dan Austin. All rights reserved.
//

import Foundation
extension Int {
    func asDaysHoursMinutesSeconds() -> (Int, Int, Int, Int) {
        return (self / (3600*24), (self % (3600*24)) / 3600, (self % 3600) / 60, self % 60)
    }

}
