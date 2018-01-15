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
}

