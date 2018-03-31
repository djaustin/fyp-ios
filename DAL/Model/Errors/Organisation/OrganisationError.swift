//
//  OrganisationError.swift
//  Digital Monitor
//
//  Created by Dan Austin on 22/01/2018.
//  Copyright © 2018 Dan Austin. All rights reserved.
//

import Foundation

/// Errors relating to organisation operations
enum OrganisationError : Error {
    
    /// Errors relating to organisation registration
    enum RegistrationError : Error, CustomStringConvertible {
        // Errors
        case missingPassword
        
        /// Text description of the errors
        public var description: String {
            switch self {
            case .missingPassword:
                return"Password required"
            }
        }
    }
    
    /// Errors relating to querying of organisations
    enum QueryError : Error, CustomStringConvertible {
        
        // Errors
        case organisationNotFound
        case missingId
        
        
        /// Text description of errors
        public var description: String {
            switch self {
            case .missingId:
                return "Organisation ID required"
            case .organisationNotFound:
                return "Organisation not found"
            }
        }
    }
}
