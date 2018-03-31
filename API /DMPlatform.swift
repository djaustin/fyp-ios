//
//  DMPlatform.swift
//  Digital Monitor
//
//  Created by Dan Austin on 27/02/2018.
//  Copyright © 2018 Dan Austin. All rights reserved.
//

import Foundation

/// Represents a platform on the Digital Monitor API
struct DMPlatform : Codable{
    // Member variables
    let name: String
    let id: String
    
    // Coding keys to be used for conversion between object and JSON
    enum CodingKeys: String, CodingKey {
        case name
        case id = "_id"
    }
    
    /// Get all platforms from the web service
    ///
    /// - Parameter onCompletion: callback function to be called on completion 
    static func getPlatforms(_ onCompletion: @escaping ([DMPlatform]?, Error?) -> Void){
        let controller = PlatformController()
        controller.getPlatforms(onCompletion)
    }
}
