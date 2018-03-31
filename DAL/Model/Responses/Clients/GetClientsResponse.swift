//
//  GetClientsResponse.swift
//  Digital Monitor
//
//  Created by Dan Austin on 15/01/2018.
//  Copyright © 2018 Dan Austin. All rights reserved.
//

import Foundation

/// Response body of GET request to clients endpoint
struct GetClientsResponse : Codable {
    var status: String
    var data: GetClientsResponseData
    
    struct GetClientsResponseData : Codable {
        var clients: [DMClient]
    }
}
