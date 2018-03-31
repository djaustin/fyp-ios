//
//  ApplicationError.swift
//  Digital Monitor
//
//  Created by Dan Austin on 23/01/2018.
//  Copyright © 2018 Dan Austin. All rights reserved.
//

import Foundation


/// Errors relating to application operations
enum ApplicationError : Error {
    
    /// Errors relating to querying for applications
    enum QueryError : Error, CustomStringConvertible {
        
        // Errors
        case missingId
        case applicationNotFound
        
        
        /// Text description of errors
        public var description: String {
            switch self {
            case .missingId:
                return "Application ID required"
            case .applicationNotFound:
                return "Application not found"
            }
        }
    }
}
