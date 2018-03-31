//
//  AddClientRequest.swift
//  Digital Monitor
//
//  Created by Dan Austin on 23/01/2018.
//  Copyright © 2018 Dan Austin. All rights reserved.
//

import Foundation

/// Request body of POST request to client endpoint
struct AddClientRequest : Encodable {
    let name: String
    let redirectUri: String
    let applicationId: String
    let platformId: String
}
