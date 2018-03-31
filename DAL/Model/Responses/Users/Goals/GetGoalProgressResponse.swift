//
//  GoalProgressResponse.swift
//  Digital Monitor
//
//  Created by Dan Austin on 28/01/2018.
//  Copyright © 2018 Dan Austin. All rights reserved.
//

import Foundation

/// Response body of GET request to usage goal progress endpoint
struct GetGoalProgressResponse : Codable {
    var status: String
    var data: GetGoalProgressResponseData
    
    struct GetGoalProgressResponseData : Codable {
        var usageGoals: [DMUser.UsageGoal]
    }
}


