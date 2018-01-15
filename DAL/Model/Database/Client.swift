//
//  Client.swift
//  Digital Monitor
//
//  Created by Dan Austin on 11/01/2018.
//  Copyright © 2018 Dan Austin. All rights reserved.
//

import Foundation

struct Client : Codable {
    let id: String
    let name: String
    let redirectUri: String
    let secret: String?
    let clientId: String?
    let applicationId: String
    
    enum CodingKeys: String, CodingKey {
        case name
        case redirectUri
        case secret
        case clientId = "id"
        case applicationId
        case id = "_id"
    }
}