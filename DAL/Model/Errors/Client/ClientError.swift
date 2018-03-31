//
//  ClientError.swift
//  Digital Monitor
//
//  Created by Dan Austin on 23/01/2018.
//  Copyright © 2018 Dan Austin. All rights reserved.
//

import Foundation

/// Errors relating to client operations
enum ClientError : Error {
    
    /// Errors relating to registration of new clients
    enum RegistrationError : Error, CustomStringConvertible {
        
        // Errors
        case missingSecret
        case missingClientId
        
        
        /// Text description of errors
        public var description: String {
            switch self {
            case .missingSecret:
                return "Client secret required"
            case .missingClientId:
                return "Client ID required"
            }
        }
    }
}
