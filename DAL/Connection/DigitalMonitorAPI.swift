//
//  DigitalMonitorAPI.swift
//  Digital Monitor
//
//  Created by Dan Austin on 11/01/2018.
//  Copyright © 2018 Dan Austin. All rights reserved.
//

import Foundation
import OAuth2

class DigitalMonitorAPI{
    
    let jsonDecoder = JSONDecoder()
    let jsonEncoder = JSONEncoder()
    let oauth2ClientCredentials: OAuth2ClientCredentials
    let baseUrl: URL
    let userEndpoint: String = "/api/users"
    

    private init(baseUrl: URL) {
        self.baseUrl = baseUrl
        let client = OAuth2ClientCredentials(settings: [
            "token_uri": "https://digitalmonitor.tk/api/oauth2/token",
            "client_id": "dmios",
            "client_secret": "password"
            ] as OAuth2JSON)
        
        client.logger = OAuth2DebugLogger(.trace)
        
        self.oauth2ClientCredentials = client
    }
    
    static let sharedInstance = DigitalMonitorAPI(baseUrl: URL(string: "https://digitalmonitor.tk")!)
    
    func registerUser(email: String, password: String, firstName: String, lastName: String, onCompletion: @escaping (PostUserResponse.PostUserResponseData?, Error?) -> Void ) {
        debugPrint("in registeUser", email, password, firstName, lastName)
        var req = oauth2ClientCredentials.request(forURL: URL(string: userEndpoint, relativeTo: baseUrl)!)
        let requestBody = RegistrationRequestBody(firstName: firstName, lastName: lastName, email: email, password: password)
        req.httpMethod = "POST"
        guard let requestBodyJSON = try? jsonEncoder.encode(requestBody) else {
            return onCompletion(nil, RequestError.jsonEncodingError)
        }
        
        req.setValue("application/json", forHTTPHeaderField: "content-type")
        req.httpBody = requestBodyJSON
        debugPrint("About to create dataTask")
        let task = oauth2ClientCredentials.session.dataTask(with: req) { (data, response, error) in
            if let error = error {
                onCompletion(nil, error)
            } else {
                guard let response = response as? HTTPURLResponse else {
                    return onCompletion(nil, ResponseError.nilResponse)
                }
                
                if response.statusCode == 201 {
                    if let data = data {
                        
                        if let responseBody = try? self.jsonDecoder.decode(PostUserResponse.self, from: data){
                            onCompletion(responseBody.data, nil)
                        } else {
                            onCompletion(nil, ResponseError.responseDecodeError)
                        }
                        
                    }
                } else {
                    onCompletion(nil, ResponseError.responseNotOK)
                }
            }
        }
        
        debugPrint("'Resuming' task")
        task.resume()
        
    }
    
    func obtainClientCredentialsToken() {
        oauth2ClientCredentials.obtainAccessToken { (json, error) in
            if let error = error {
                print(error)
            }
        }
    }

}
