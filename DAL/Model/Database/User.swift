//
//  User.swift
//  Digital Monitor
//
//  Created by Dan Austin on 11/01/2018.
//  Copyright © 2018 Dan Austin. All rights reserved.
//

import Foundation

struct User : Codable{
    var email: String
    var password: String?
    var firstName: String
    var lastName: String
    var id: String?
    
    enum CodingKeys: String, CodingKey {
        case email
        case password
        case firstName
        case lastName
        case id = "_id"
    }
}
