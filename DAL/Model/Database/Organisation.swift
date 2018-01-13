//
//  Organisation.swift
//  Digital Monitor
//
//  Created by Dan Austin on 11/01/2018.
//  Copyright © 2018 Dan Austin. All rights reserved.
//

import Foundation

struct Organisation : Codable {
    let name: String
    let email: String
    let password: String
    let id: String?
    let applicationIds: [String]
    
    enum CodingKeys: String, CodingKey {
        case name
        case email
        case password
        case applicationIds
        case id = "_id"
    }
}

