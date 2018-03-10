//
//  MonitoringExceptionError.swift
//  Digital Monitor
//
//  Created by Dan Austin on 10/03/2018.
//  Copyright © 2018 Dan Austin. All rights reserved.
//

import Foundation

enum MonitoringExceptionError : Error {
    enum SaveError : Error {
        case missingId
    }
}
