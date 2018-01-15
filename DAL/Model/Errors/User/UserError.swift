//
//  UserError.swift
//  Digital Monitor
//
//  Created by Dan Austin on 14/01/2018.
//  Copyright © 2018 Dan Austin. All rights reserved.
//

import Foundation

enum UserError : Error {
    enum RegistrationError : Error {
        case missingEmail
        case missingPassword
        case missingFirstName
        case missingLastName
    }

    enum QueryError : Error {
        case userNotFound
        case userNotSaved
    }
    enum AuthenticationError : Error {
        case userNotLoggedIn
    }
}
