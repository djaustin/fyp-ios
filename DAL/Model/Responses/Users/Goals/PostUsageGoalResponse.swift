//
//  PostUsageGoalResponse.swift
//  Digital Monitor
//
//  Created by Dan Austin on 29/01/2018.
//  Copyright © 2018 Dan Austin. All rights reserved.
//

import Foundation

struct PostUsageGoalResponse : Codable {
    var status: String
    var data: PostUsageGoalData
    
    struct PostUsageGoalData : Codable {
        var usageGoal: DMUser.UsageGoal
    }
}


