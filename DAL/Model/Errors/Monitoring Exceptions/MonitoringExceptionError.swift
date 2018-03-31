//
//  MonitoringExceptionError.swift
//  Digital Monitor
//
//  Created by Dan Austin on 10/03/2018.
//  Copyright © 2018 Dan Austin. All rights reserved.
//

import Foundation

/// Errors relating to monitoring exception operations
enum MonitoringExceptionError : Error {
    
    /// Errors relating to saving of monitoring exceptions
    enum SaveError : Error, CustomStringConvertible {
        // Errors
        case missingId
        
        /// Text descriptions of the errors
        public var description: String {
            switch self {
            case .missingId:
                return "Monitoring exception ID required"
            }
        }
    }
}
