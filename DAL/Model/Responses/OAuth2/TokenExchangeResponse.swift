//
//  TokenExchangeResponse.swift
//  Digital Monitor
//
//  Created by Dan Austin on 14/01/2018.
//  Copyright © 2018 Dan Austin. All rights reserved.
//

import Foundation

struct TokenExchangeResponse : Codable {
    var accessToken: String
    var refreshToken: String
    var expiresIn: Int
  
    private enum CodingKeys: String, CodingKey {
        case accessToken = "access_token"
        case refreshToken = "refresh_token"
        case expiresIn = "expires"
    }
}
