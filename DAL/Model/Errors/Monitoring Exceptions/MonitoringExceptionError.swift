//
//  MonitoringExceptionError.swift
//  Digital Monitor
//
//  Created by Dan Austin on 10/03/2018.
//  Copyright © 2018 Dan Austin. All rights reserved.
//

import Foundation

enum MonitoringExceptionError : Error {
    enum SaveError : Error, CustomStringConvertible {
        case missingId
        public var description: String {
            switch self {
            case .missingId:
                return "Monitoring exception ID required"
            }
        }
    }
}
