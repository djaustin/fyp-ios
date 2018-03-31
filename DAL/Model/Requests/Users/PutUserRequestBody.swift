//
//  PutUserRequestBody.swift
//  Digital Monitor
//
//  Created by Dan Austin on 17/03/2018.
//  Copyright © 2018 Dan Austin. All rights reserved.
//

import Foundation

/// Request body of PUT request to the users endpoint
struct PutUserRequestBody : Encodable {
    let firstName: String?
    let lastName: String?
    let email: String?
    let password: String?
}
