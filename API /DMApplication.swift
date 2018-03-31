//
//  Application.swift
//  Digital Monitor
//
//  Created by Dan Austin on 11/01/2018.
//  Copyright © 2018 Dan Austin. All rights reserved.
//

import Foundation


/// Represents an application from the Digital Monitor API
struct DMApplication : Codable {
    // Member variables
    let name: String
    let id: String?
    let clientIds: [String]
    
    // Coding keys to convert between object and JSON
    enum CodingKeys: String, CodingKey {
        case name
        case clientIds
        case id = "_id"
    }
    
    
    /// Delete the application
    ///
    /// - Parameter onCompletion: Callback function to be run on completion of operation
    func delete(onCompletion: @escaping (Error?) -> Void){
        let applicationController = ApplicationController()
        applicationController.delete(application: self, onCompletion: onCompletion)
    }
    
    /// Get an application from the web service by application ID
    ///
    /// - Parameters:
    ///   - id: ID of application to search for
    ///   - onCompletion: Callback function to be run on search completion 
    static func getApplication(byId id: String, onCompletion: @escaping (DMApplication?, Error?) -> Void) {
        let applicationController = ApplicationController()
        applicationController.getApplication(byId: id, onCompletion: onCompletion)
    }
}

