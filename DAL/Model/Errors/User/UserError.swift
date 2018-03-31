//
//  UserError.swift
//  Digital Monitor
//
//  Created by Dan Austin on 14/01/2018.
//  Copyright © 2018 Dan Austin. All rights reserved.
//

import Foundation

/// Errors relating to user operations
enum UserError : Error {
    
    /// Errors relating to registration of users
    enum RegistrationError : Error, CustomStringConvertible {
        
        // Errors
        case missingEmail
        case missingPassword
        case missingFirstName
        case missingLastName
        
        /// Text description of errors
        public var description: String {
            switch self {
            case .missingEmail:
                return "Email required"
            case .missingPassword:
                return "Password required"
            case .missingFirstName:
                return "First name required"
            case .missingLastName:
                return "Last name required"
            }
        }
    }
    
    /// Errors relating to querying of users
    enum QueryError : Error, CustomStringConvertible {
        
        // Errors
        case userNotFound
        case userNotSaved
        
        /// Text description of errors
        public var description: String {
            switch self {
            case .userNotFound:
                return "User not found"
            case .userNotSaved:
                return "User is not saved"
            }
        }
    }
    
    /// Errors relating to authentication of users
    enum AuthenticationError : Error, CustomStringConvertible {
        
        // Errors
        case userNotLoggedIn
        
        /// Text description of errors
        public var description: String {
            switch self {
            case .userNotLoggedIn:
                return "User is not logged in"
            }
        }
    }
}
