//
//  PostOrganisationsResponse.swift
//  Digital Monitor
//
//  Created by Dan Austin on 22/01/2018.
//  Copyright © 2018 Dan Austin. All rights reserved.
//

import Foundation

/// Response body of POST request to organisation endpoint
struct PostOrganisationResponse : Codable {
    var status: String
    var data: PostOrganisationResponseData
    
    struct PostOrganisationResponseData : Codable {
        var organisation: DMOrganisation
        var locations: [URL]
    }
}
