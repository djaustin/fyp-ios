//
//  RegistrationRequest.swift
//  Digital Monitor
//
//  Created by Dan Austin on 10/01/2018.
//  Copyright © 2018 Dan Austin. All rights reserved.
//

import Foundation

/// Request body of POST request to users endpoint
struct UserRegistrationRequestBody : Encodable {
    let firstName: String
    let lastName: String
    let email: String
    let password: String
}

