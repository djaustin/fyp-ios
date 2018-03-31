//
//  OrganisationRegistrationRequest.swift
//  Digital Monitor
//
//  Created by Dan Austin on 22/01/2018.
//  Copyright © 2018 Dan Austin. All rights reserved.
//

import Foundation

/// Request body of POST request to organisations endpoint
struct OrganisationRegistrationRequestBody : Encodable {
    let name: String
    let email: String
    let password: String
}
