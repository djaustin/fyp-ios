//
//  RevokeClientAccessResponse.swift
//  Digital Monitor
//
//  Created by Dan Austin on 16/01/2018.
//  Copyright © 2018 Dan Austin. All rights reserved.
//

import Foundation

/// Response body of DELETE request to user clients endpoint
struct RevokeClientAccessResponse : Codable {
    var status: String
    var data: String?
}

