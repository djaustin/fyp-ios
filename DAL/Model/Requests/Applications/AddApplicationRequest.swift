//
//  AddApplicationRequest.swift
//  Digital Monitor
//
//  Created by Dan Austin on 23/01/2018.
//  Copyright © 2018 Dan Austin. All rights reserved.
//

import Foundation

/// Request body of POST request to applications endpoint
struct AddApplicationRequest : Encodable {
    let name: String
}
