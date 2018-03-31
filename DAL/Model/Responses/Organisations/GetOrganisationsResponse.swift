//
//  GetOrganisationsResponse.swift
//  Digital Monitor
//
//  Created by Dan Austin on 22/01/2018.
//  Copyright © 2018 Dan Austin. All rights reserved.
//

import Foundation

/// Response body of GET request to organisations endpoint
struct GetOrganisationsResponse : Codable {
    var status: String
    var data: GetOrganisationsResponseData
    
    struct GetOrganisationsResponseData : Codable {
        var organisations: [DMOrganisation]
    }
}
