//
//  GetApplicationResponse.swift
//  Digital Monitor
//
//  Created by Dan Austin on 08/03/2018.
//  Copyright © 2018 Dan Austin. All rights reserved.
//

import Foundation

struct GetApplicationResponse : Codable {
    var status: String
    var data: GetApplicationResponseData
    
    struct GetApplicationResponseData : Codable {
        var application: DMApplication
    }
}
