//
//  DMUsageLog.swift
//  Digital Monitor
//
//  Created by Dan Austin on 15/01/2018.
//  Copyright © 2018 Dan Austin. All rights reserved.
//

import Foundation

struct DMUsageLog : Codable {
    var id: String
    var userId: String
    var clientId: String
    var log: DMUsageLogLog
   
    private enum CodingKeys: String, CodingKey {
        case userId
        case clientId
        case log
        case id = "_id"
    }
    
    struct DMUsageLogLog : Codable {
        var startTime: Date
        var endTime: Date
    }
}
