//
//  OrganisationError.swift
//  Digital Monitor
//
//  Created by Dan Austin on 22/01/2018.
//  Copyright © 2018 Dan Austin. All rights reserved.
//

import Foundation

enum OrganisationError : Error {
    enum RegistrationError : Error, CustomStringConvertible {
        case missingPassword
        public var description: String {
            switch self {
            case .missingPassword:
                return"Password required"
            }
        }
    }
    
    enum QueryError : Error, CustomStringConvertible {
        case organisationNotFound
        case missingId
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
