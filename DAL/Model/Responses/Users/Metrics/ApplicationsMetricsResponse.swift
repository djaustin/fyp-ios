//
//  ApplicationsMetricsResponse.swift
//  Digital Monitor
//
//  Created by Dan Austin on 17/01/2018.
//  Copyright © 2018 Dan Austin. All rights reserved.
//

import Foundation

struct ApplicationsMetricsResponse : Codable {
    let status: String
    let data: ApplicationsMetricsResponseData

}

struct ApplicationsMetricsResponseData : Codable {
    let applications: [ApplicationUsageData]
    
    
}

struct ApplicationUsageData : Codable {
    let id: String
    let name: String
    let duration: Int
    
    private enum CodingKeys: String, CodingKey {
        case id = "_id"
        case name
        case duration
    }
    
}
