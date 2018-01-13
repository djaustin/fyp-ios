//
//  PostUserResponse.swift
//  Digital Monitor
//
//  Created by Dan Austin on 13/01/2018.
//  Copyright © 2018 Dan Austin. All rights reserved.
//

import Foundation

struct PostUserResponse : Codable {
    var status: String
    var data: PostUserResponseData
    
    struct PostUserResponseData : Codable {
        var user: User
        var locations: [URL]
    }
}
