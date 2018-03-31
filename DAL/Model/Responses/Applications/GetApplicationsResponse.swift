//
//  GetApplicationsResponse.swift
//  Digital Monitor
//
//  Created by Dan Austin on 23/01/2018.
//  Copyright © 2018 Dan Austin. All rights reserved.
//

import Foundation

/// Response body of GET request to applications endpoint
struct GetApplicationsResponse : Codable {
    var status: String
    var data: GetApplicationsResponseData
    
    struct GetApplicationsResponseData : Codable {
        var applications: [DMApplication]
    }
}
