//
//  Organisation.swift
//  Digital Monitor
//
//  Created by Dan Austin on 11/01/2018.
//  Copyright © 2018 Dan Austin. All rights reserved.
//

import Foundation

struct DMOrganisation : Codable {
    var name: String
    var email: String
    var password: String
    var id: String?
    var applicationIds: [String]
    
    enum CodingKeys: String, CodingKey {
        case name
        case email
        case password
        case applicationIds
        case id = "_id"
    }
}

