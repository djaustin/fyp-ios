//
//  PlatformsMetricsResponse.swift
//  Digital Monitor
//
//  Created by Dan Austin on 18/01/2018.
//  Copyright © 2018 Dan Austin. All rights reserved.
//

import Foundation

struct PlatformsMetricsResponse : Codable {
    let status: String
    let data: PlatformsMetricsResponseData
    
}

struct PlatformsMetricsResponseData : Codable {
    let platforms: [PlatformUsageData]
    
    
}

struct PlatformUsageData : Codable {
    let platform: DMPlatform
    let duration: Int
}
