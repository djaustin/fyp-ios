//
//  PlatformController.swift
//  Digital Monitor
//
//  Created by Dan Austin on 28/02/2018.
//  Copyright © 2018 Dan Austin. All rights reserved.
//

import Foundation
import p2_OAuth2

/// Controller to interact with the web API for plaform related endpoints
class PlatformController {
    
    /// URL endpoint
    let platformsEndpoint = "https://digitalmonitor.tk/api/platforms"
    
    /// Manager for OAuth 2 access credentials
    let oauth2Credentials = DigitalMonitorAPI.sharedInstance.oauth2ClientCredentials
    
    /// Construct, send, and parse a request and response for platforms from the web API
    ///
    /// - Parameter onCompletion: callback function to be called on completion
    func getPlatforms(_ onCompletion: @escaping ([DMPlatform]?, Error?) -> Void){
        let jsonDecoder = JSONDecoder()
        
        
        guard let url = URL(string: platformsEndpoint) else {
            return onCompletion(nil, RequestError.urlError)
        }
        
        var req = oauth2Credentials.request(forURL: url)
        
        req.httpMethod = "GET"
        
        let loader = OAuth2DataLoader(oauth2: oauth2Credentials)
        
        loader.perform(request: req) { (oauthResponse) in
            if let error = oauthResponse.error {
                onCompletion(nil, error)
            } else {
                if oauthResponse.response.statusCode == 200 {
                    if let data = oauthResponse.data {
                        do{
                            let responseBody = try jsonDecoder.decode(GetPlatformsResponse.self, from: data)
                            if responseBody.status == "success"{
                                return onCompletion(responseBody.data.platforms, nil)
                            } else {
                                return onCompletion(nil, ResponseError.errorOnStatusOk)
                            }
                        }catch {
                            print(error)
                            onCompletion(nil, error)
                        }
                    } else {
                        onCompletion(nil, ResponseError.noResponseData)
                    }
                } else {
                    onCompletion(nil, ResponseError.responseNotOK)
                }
            }
        }
        
    }
}
