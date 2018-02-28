//
//  PostUsageGoalRequest.swift
//  Digital Monitor
//
//  Created by Dan Austin on 28/02/2018.
//  Copyright © 2018 Dan Austin. All rights reserved.
//

import Foundation

struct PostUsageGoalRequest : Codable {
    init(duration: Int, periodId: String, platformId: String?, applicationId: String?) {
        self.duration = duration
        self.periodId = periodId
        self.platformId = platformId
        self.applicationId = applicationId
    }

    var platformId: String?
    var applicationId: String?
    var duration: Int
    var periodId: String
    private enum CodingKeys: String, CodingKey {
        case platformId
        case applicationId
        case duration
        case periodId
    }
}
