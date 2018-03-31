//
//  GetMonitoringExceptionsResponse.swift
//  Digital Monitor
//
//  Created by Dan Austin on 09/03/2018.
//  Copyright © 2018 Dan Austin. All rights reserved.
//

import Foundation

/// Response body of GET request to monitoring exceptions endpoint
struct GetMonitoringExceptionsResponse : Decodable {
    var status: String
    var data: GetMonitoringExceptionsResponseData
    
    struct GetMonitoringExceptionsResponseData : Codable {
        var monitoringExceptions: [DMMonitoringException]
    }
}



