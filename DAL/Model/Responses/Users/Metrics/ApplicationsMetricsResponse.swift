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
    let data: [ApplicationUsageData]

}

struct ApplicationUsageData : Codable {
    let application: DMApplication
    let duration: Int
}
