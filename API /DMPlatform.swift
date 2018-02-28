//
//  DMPlatform.swift
//  Digital Monitor
//
//  Created by Dan Austin on 27/02/2018.
//  Copyright © 2018 Dan Austin. All rights reserved.
//

import Foundation

struct DMPlatform : Codable{
    let name: String
    let id: String
    
    enum CodingKeys: String, CodingKey {
        case name
        case id = "_id"
    }
    
    static func getPlatforms(_ onCompletion: @escaping ([DMPlatform]?, Error?) -> Void){
        let controller = PlatformController()
        controller.getPlatforms(onCompletion)
    }
}
