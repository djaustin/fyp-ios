//
//  OverallMetricsResponse.swift
//  Digital Monitor
//
//  Created by Dan Austin on 16/01/2018.
//  Copyright © 2018 Dan Austin. All rights reserved.
//

import Foundation

struct OverallMetricsResponse : Codable {
    let status : String
    let data : OverallMetricsResponseData
    
    struct OverallMetricsResponseData : Codable {
        let duration : Int
    }
}
