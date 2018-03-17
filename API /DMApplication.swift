//
//  Application.swift
//  Digital Monitor
//
//  Created by Dan Austin on 11/01/2018.
//  Copyright © 2018 Dan Austin. All rights reserved.
//

import Foundation


struct DMApplication : Codable {
    let name: String
    let id: String?
    let clientIds: [String]
    
    enum CodingKeys: String, CodingKey {
        case name
        case clientIds
        case id = "_id"
    }
    
    func delete(onCompletion: @escaping (Error?) -> Void){
        let applicationController = ApplicationController()
        applicationController.delete(application: self, onCompletion: onCompletion)
    }
    
    static func getApplication(byId id: String, onCompletion: @escaping (DMApplication?, Error?) -> Void) {
        let applicationController = ApplicationController()
        applicationController.getApplication(byId: id, onCompletion: onCompletion)
    }
}

