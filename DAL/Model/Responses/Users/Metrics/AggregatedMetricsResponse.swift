//
//  AggregatedMetricsResponse.swift
//  Digital Monitor
//
//  Created by Dan Austin on 18/01/2018.
//  Copyright © 2018 Dan Austin. All rights reserved.
//

import Foundation

struct AggregatedMetricsResponse : Codable {
    let status: String
    let data: AggregatedMetricsResponseData
    
}

struct AggregatedMetricsResponseData : Codable {
    let overall: OverallMetricsResponseData
    let applications: [ApplicationUsageData]
    let platforms: [PlatformUsageData]
}

