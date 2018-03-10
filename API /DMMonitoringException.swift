//
//  DMMonitoringException.swift
//  Digital Monitor
//
//  Created by Dan Austin on 09/03/2018.
//  Copyright © 2018 Dan Austin. All rights reserved.
//

import Foundation

struct DMMonitoringException : Codable {
    
    var id: String?
    var platform: DMPlatform?
    var application: DMApplication?
    var user: String
    var startTime: Date
    var endTime: Date
    
    private enum CodingKeys: String, CodingKey {
        case platform
        case application
        case user
        case startTime
        case endTime
        case id = "_id"
    }
    
    static func addNew(exception: DMMonitoringException, _ onCompletion: @escaping (DMMonitoringException?, Error?) -> Void){
        let controller = MonitoringExceptionController()
        controller.addNew(exception: exception, onCompletion: onCompletion)
    }
}