//
//  DMMonitoringException.swift
//  Digital Monitor
//
//  Created by Dan Austin on 09/03/2018.
//  Copyright © 2018 Dan Austin. All rights reserved.
//

import Foundation

/// Represents a monitoring exception in the Digital Monitor API
struct DMMonitoringException : Codable {
    
    // Member variables
    var id: String?
    var platform: DMPlatform?
    var application: DMApplication?
    var user: String
    var startTime: Date
    var endTime: Date
    
    // Contoller to communicate with the web API
    let controller = MonitoringExceptionController()
    
    // Coding keys to convert between object and JSON
    private enum CodingKeys: String, CodingKey {
        case platform
        case application
        case user
        case startTime
        case endTime
        case id = "_id"
    }
    
    /// Add a new monitoring exception to the currently authenticated user
    ///
    /// - Parameters:
    ///   - exception: monitoring exception to be added
    ///   - onCompletion: callback function to be called on completion
    static func addNew(exception: DMMonitoringException, _ onCompletion: @escaping (DMMonitoringException?, Error?) -> Void){
        let controller = MonitoringExceptionController()
        controller.addNew(exception: exception, onCompletion: onCompletion)
    }
    
    
    /// Save changes to the monitoring excepetion
    ///
    /// - Parameter onCompletion: callback function to be called on completion
    func save(_ onCompletion: @escaping (Error?) -> Void){
        controller.save(exception: self, onCompletion: onCompletion)
    }
    
    /// Delete a user monitoring exception
    ///
    /// - Parameter onCompletion: callback function to be called on completion
    func delete(_ onCompletion: @escaping(Error?) -> Void){
        controller.delete(exception: self, onCompletion: onCompletion)
    }
    
    
}
