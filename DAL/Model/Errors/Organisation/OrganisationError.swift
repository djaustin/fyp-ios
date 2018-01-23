//
//  OrganisationError.swift
//  Digital Monitor
//
//  Created by Dan Austin on 22/01/2018.
//  Copyright © 2018 Dan Austin. All rights reserved.
//

import Foundation

enum OrganisationError : Error {
    enum RegistrationError : Error {
        case missingPassword
    }
    
    enum QueryError : Error {
        case organisationNotFound
        case missingId
    }
}
