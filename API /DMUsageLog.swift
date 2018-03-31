//
//  DMUsageLog.swift
//  Digital Monitor
//
//  Created by Dan Austin on 15/01/2018.
//  Copyright © 2018 Dan Austin. All rights reserved.
//

import Foundation

/// Represents a user usage log in the Digital Monitor API
struct DMUsageLog : Codable {
    
    // Member variables
    var id: String
    var userId: String
    var clientId: String
    var log: DMUsageLogLog
   
    // Coding keys used to convert between object and JSON
    private enum CodingKeys: String, CodingKey {
        case userId
        case clientId
        case log
        case id = "_id"
    }
    
    // Log details 
    struct DMUsageLogLog : Codable {
        var startTime: Date
        var endTime: Date
    }
}
