//
//  DeviceTokenController.swift
//  Digital Monitor
//
//  Created by Dan Austin on 05/02/2018.
//  Copyright © 2018 Dan Austin. All rights reserved.
//

import Foundation
import p2_OAuth2

/// Controller to interact with the web API for device token related endpoints
class DeviceTokenController {

    // URL endpoint templaye
    let organisationApplicationsEndpointTemplate = "https://digitalmonitor.tk/api/device-tokens/%@"
    
    // Manager for OAuth access tokens
    let oauth2Credentials = DigitalMonitorAPI.sharedInstance.oauth2ClientCredentials
    
    
    /// Construct, send, and parse a request and response for associating a device token with a user from the web API
    ///
    /// - Parameters:
    ///   - token: APNs device token of the current device
    ///   - user: user to associate with the device token
    ///   - onCompletion: callback function to called on completion
    func associate(token: String, withUser user: DMUser, onCompletion: @escaping (Error?) -> Void){
        let jsonEncoder = JSONEncoder()

        guard let userId = user.id else {
            return onCompletion(UserError.QueryError.userNotSaved)
        }
        guard let url = URL(string: String(format: organisationApplicationsEndpointTemplate, token)) else {
            return onCompletion(RequestError.urlError)
        }
        
        let requestBody = PutDeviceTokenRequest(userId: userId)
        
        guard let body = try? jsonEncoder.encode(requestBody) else {
            return onCompletion(RequestError.jsonEncodingError)
        }
        
        var req = oauth2Credentials.request(forURL: url)
        
        req.httpMethod = "PUT"
        
        req.httpBody = body
        
        req.setValue("application/json", forHTTPHeaderField: "content-type")
        
        let loader = OAuth2DataLoader(oauth2: oauth2Credentials)
        
        loader.perform(request: req) { (oauthResponse) in
            if let error = oauthResponse.error {
                onCompletion(error)
            } else {
                if oauthResponse.response.statusCode == 200 {
                    onCompletion(nil)
                } else {
                    onCompletion(ResponseError.responseNotOK)
                }
            }
        }
        
    }
  
}
