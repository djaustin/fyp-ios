//
//  UsageGoalError.swift
//  Digital Monitor
//
//  Created by Dan Austin on 29/01/2018.
//  Copyright © 2018 Dan Austin. All rights reserved.
//

import Foundation


/// Errors relating to usage goal operations
enum UsageGoalError : Error {
    
    /// Errors relating to saving usage goals
    enum SaveError : Error, CustomStringConvertible {
        // Errors
        case missingId
        
        
        /// Text descriptions of errors
        public var description: String {
            switch self {
            case .missingId:
                return "Usage goal ID required"
            }
        }
    }
}
