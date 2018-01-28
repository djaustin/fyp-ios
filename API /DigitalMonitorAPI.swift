//
//  DigitalMonitorAPI.swift
//  Digital Monitor
//
//  Created by Dan Austin on 11/01/2018.
//  Copyright © 2018 Dan Austin. All rights reserved.
//

import Foundation
import p2_OAuth2

class DigitalMonitorAPI{
    
    let jsonDecoder = JSONDecoder()
    let jsonEncoder = JSONEncoder()
    let oauth2ClientCredentials: OAuth2ClientCredentials
    let oauth2PasswordGrant: OAuth2PasswordGrant
    let baseUrl = URL(string: "https://digitalmonitor.tk/api")!
    let userEndpoint = "/api/users"

    static let sharedInstance = DigitalMonitorAPI()
    let settings = [
        "token_uri": "https://digitalmonitor.tk/api/oauth2/token",
        "client_id": "dmios",
        "client_secret": "password"
        ] as OAuth2JSON
    static let oauthSettings = [
        "token_uri": "https://digitalmonitor.tk/api/oauth2/token",
        "client_id": "dmios",
        "client_secret": "password"
        ] as OAuth2JSON
    private init() {
        
        let clientCredentialsClient = OAuth2ClientCredentials(settings: settings)
        let passwordGrant = OAuth2PasswordGrant(settings: settings)
        passwordGrant.logger = OAuth2DebugLogger(.trace)
        clientCredentialsClient.logger = OAuth2DebugLogger(.trace)
        self.oauth2ClientCredentials = clientCredentialsClient
        self.oauth2PasswordGrant = passwordGrant
    }
   
    func obtainClientCredentialsToken() {
        oauth2ClientCredentials.obtainAccessToken { (json, error) in
            if let error = error {
                print(error)
            }
        }
    }
    
    func obtainResouceOwnerCredentialsToken(username: String, password: String, onCompletion: @escaping (OAuth2Error?) -> Void) {
        oauth2PasswordGrant.username = username
        oauth2PasswordGrant.password = password
        oauth2PasswordGrant.obtainAccessToken { (json, error) in
            onCompletion(error)
        }

    }

}
