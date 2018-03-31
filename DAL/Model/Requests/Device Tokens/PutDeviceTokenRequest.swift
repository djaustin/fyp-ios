//
//  File.swift
//  Digital Monitor
//
//  Created by Dan Austin on 05/02/2018.
//  Copyright © 2018 Dan Austin. All rights reserved.
//

import Foundation

/// Request body of PUT request to device token endpoint
struct PutDeviceTokenRequest : Encodable {
    var userId: String
}
