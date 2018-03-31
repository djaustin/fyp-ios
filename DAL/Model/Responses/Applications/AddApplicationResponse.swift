//
//  AddApplicationResponse.swift
//  Digital Monitor
//
//  Created by Dan Austin on 23/01/2018.
//  Copyright © 2018 Dan Austin. All rights reserved.
//

import Foundation

/// Response body of POST request to applications endpoint
struct PostApplicationResponse : Codable {
    var status: String
    var data: PostApplicationResponseData
    
    struct PostApplicationResponseData : Codable {
        var application: DMApplication
        var locations: [URL]
    }
}
