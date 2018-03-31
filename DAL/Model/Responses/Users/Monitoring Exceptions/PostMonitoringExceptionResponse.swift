//
//  PostMonitoringExceptionResponse.swift
//  Digital Monitor
//
//  Created by Dan Austin on 10/03/2018.
//  Copyright © 2018 Dan Austin. All rights reserved.
//

import Foundation

/// Response body of POST request to monitoring exceptions endpoint
struct PostMonitoringExceptionResponse : Codable {
    var status: String
    var data: PostMonitoringExceptionResponseData
    
    struct PostMonitoringExceptionResponseData : Codable {
        var monitoringException: DMMonitoringException
    }
}


