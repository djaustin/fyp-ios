//
//  GetPlatformsResponse.swift
//  Digital Monitor
//
//  Created by Dan Austin on 28/02/2018.
//  Copyright © 2018 Dan Austin. All rights reserved.
//

import Foundation

struct GetPlatformsResponse : Codable {
    var status: String
    var data: GetPlatformsResponseData
    
    struct GetPlatformsResponseData : Codable {
        var platforms: [DMPlatform]
    }
}
