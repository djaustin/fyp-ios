//
//  UserError.swift
//  Digital Monitor
//
//  Created by Dan Austin on 14/01/2018.
//  Copyright © 2018 Dan Austin. All rights reserved.
//

import Foundation

enum UserError : Error {
    enum RegistrationError : Error, CustomStringConvertible {
        case missingEmail
        case missingPassword
        case missingFirstName
        case missingLastName
        
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
    
    enum QueryError : Error, CustomStringConvertible {
        case userNotFound
        case userNotSaved
        public var description: String {
            switch self {
            case .userNotFound:
                return "User not found"
            case .userNotSaved:
                return "User is not saved"
            }
        }
    }
    enum AuthenticationError : Error, CustomStringConvertible {
        case userNotLoggedIn
        public var description: String {
            switch self {
            case .userNotLoggedIn:
                return "User is not logged in"
            
            }
        }
    }
}
