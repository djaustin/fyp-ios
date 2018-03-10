//
//  PostMonitoringExceptionRequest.swift
//  Digital Monitor
//
//  Created by Dan Austin on 10/03/2018.
//  Copyright © 2018 Dan Austin. All rights reserved.
//

import Foundation
struct PostMonitoringExceptionRequest : Encodable{
    var startTime: Int
    var endTime: Int
    var platformId: String?
    var applicationId: String?
}
