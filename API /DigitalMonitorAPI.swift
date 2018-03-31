//
//  DigitalMonitorAPI.swift
//  Digital Monitor
//
//  Created by Dan Austin on 11/01/2018.
//  Copyright © 2018 Dan Austin. All rights reserved.
//

import Foundation
import p2_OAuth2


/// API Class used to obtain access tokens from the web API
class DigitalMonitorAPI{
    
    // Encoder and decoder used to convert between
    let jsonDecoder = JSONDecoder()
    let jsonEncoder = JSONEncoder()
    
    // Object to manage the access tokens obtained from client credentials flow. This is used for operations like
    let oauth2ClientCredentials: OAuth2ClientCredentials
    // Object to manage the access tokens obtained from user password flow. This is used for both organisation and user login
    let oauth2PasswordGrant: OAuth2PasswordGrant
    
    // API URL base
    let baseUrl = URL(string: "https://digitalmonitor.tk/api")!
    
    // Extension to base url for user resource
    let userEndpoint = "/api/users"
    
    static let sharedInstance = DigitalMonitorAPI()
    
    
    /// Settings for retrieving access tokens via the OAuth 2 flow
    let settings = [
        "token_uri": "https://digitalmonitor.tk/api/oauth2/token", // URI to send credentials for access token
        "client_id": "dmios", // ID for client authentication
        "client_secret": "password" // Secret for client authentication
        ] as OAuth2JSON
    
    
    /// Create new instance. Initialise the client credentials and password grant objects
    private init() {
        let clientCredentialsClient = OAuth2ClientCredentials(settings: settings)
        let passwordGrant = OAuth2PasswordGrant(settings: settings)
        passwordGrant.logger = OAuth2DebugLogger(.trace)
        clientCredentialsClient.logger = OAuth2DebugLogger(.trace)
        self.oauth2ClientCredentials = clientCredentialsClient
        self.oauth2PasswordGrant = passwordGrant
    }
   
    
    /// Obtain an access token from the API endpoint using the client credentials flow
    func obtainClientCredentialsToken() {
        oauth2ClientCredentials.obtainAccessToken { (json, error) in
            if let error = error {
                print(error)
            }
        }
    }
    
    /// Obtain access token from the API endpoint using the password grant OAuth flow
    ///
    /// - Parameters:
    ///   - username: username used to authenticate users
    ///   - password: password used to authenticate users
    ///   - onCompletion: Callback function to be called on completion
    func obtainResouceOwnerCredentialsToken(username: String, password: String, onCompletion: @escaping (OAuth2Error?) -> Void) {
        oauth2PasswordGrant.username = username
        oauth2PasswordGrant.password = password
        oauth2PasswordGrant.obtainAccessToken { (json, error) in
            onCompletion(error)
        }

    }

}
