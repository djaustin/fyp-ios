//
//  PostClientResponse.swift
//  Digital Monitor
//
//  Created by Dan Austin on 23/01/2018.
//  Copyright © 2018 Dan Austin. All rights reserved.
//

import Foundation

struct PostClientResponse : Codable {
    var status: String
    var data: PostClientResponseData
    
    struct PostClientResponseData : Codable {
        var client: DMClient
        var locations: [URL]
    }
}

