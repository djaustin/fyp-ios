//
//  GetUsersResponse.swift
//  Digital Monitor
//
//  Created by Dan Austin on 15/01/2018.
//  Copyright © 2018 Dan Austin. All rights reserved.
//

import Foundation

struct GetUsersResponse : Codable {
    var status: String
    var data: GetUsersResponseData
    
    struct GetUsersResponseData : Codable {
        var users: [DMUser]
    }
}

