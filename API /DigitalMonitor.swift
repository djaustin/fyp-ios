//
//  DMConfig.swift
//  Digital Monitor
//
//  Created by Dan Austin on 14/01/2018.
//  Copyright © 2018 Dan Austin. All rights reserved.
//

import Foundation
import OAuth2

class DigitalMonitor {
    
    static let sharedInstance = DigitalMonitor()
    
    var tokenUri: String
    var clientId: String
    var clientSecret: String
    
    /// Initilise with provided OAuth2 client configuration values
    ///
    /// - Parameters:
    ///   - tokenUri: URI to which to post to receive a token
    ///   - clientId: Client ID registered in the API database
    ///   - clientSecret: Client secret registered in the database
    init(tokenUri: String, clientId: String, clientSecret: String) {
        self.tokenUri = tokenUri
        self.clientId = clientId
        self.clientSecret = clientSecret
    }
    /**
    * Initialise with
    */
    convenience init(){
        self.init(tokenUri: "https://digitalmonitor.tk/api/oauth2/token", clientId: "dmios", clientSecret: "password")
    }
    
}
