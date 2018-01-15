//
//  DMClient.swift
//  Digital Monitor
//
//  Created by Dan Austin on 15/01/2018.
//  Copyright © 2018 Dan Austin. All rights reserved.
//

import Foundation

struct DMClient : Codable {
    
    var name: String
    var clientd: String
    var applicationId: String
    var redirectUri: String
    var isThirdParty: Bool
    
}
