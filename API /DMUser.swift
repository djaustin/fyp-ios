//
//  DMUser.swift
//  Digital Monitor
//
//  Created by Dan Austin on 13/01/2018.
//  Copyright © 2018 Dan Austin. All rights reserved.
//

import Foundation
import OAuth2

class DMUser : Codable {
    
    var email: String?
    var password: String?
    var firstName: String?
    var lastName: String?
    var id: String?
    
    private enum CodingKeys: String, CodingKey {
        case email
        case password
        case firstName
        case lastName
        case id = "_id"
    }
    
    static let endpoint = URL(string: "https://digitalmonitor.tk/api/users")!
    
    init(email: String, password: String, firstName: String, lastName: String) {
        self.email = email
        self.password = password
        self.firstName = firstName
        self.lastName = lastName
    }
    
    static var authenticatedUser: DMUser? = nil
    
    
    static func login(withEmail email: String, password: String, onCompletion: @escaping (DMUser?, Error?) -> Void){
        // Use supplied credentials to attempt to get an access token for this user
        DigitalMonitorAPI.sharedInstance.obtainResouceOwnerCredentialsToken(username: email, password: password) { (error) in
            print("completion")
            if let error = error {
                print("error found")
                onCompletion(nil, error)
            } else {
                print("no error found")
                // If successful, lookup the user details for the provided email to get a user object
                // Assign user object to authenticatedUser property
                print("About to get user")
                getUser(byEmail: email) { (user, error) in
                    print("finished trying to get user")
                    if let error = error {
                        onCompletion(nil, error)
                    } else {
                        if let user = user {
                            DMUser.authenticatedUser = user
                            onCompletion(user, nil)
                        }
                    }
                }
            }
        }

  
        
    }
    
    func register(onCompletion: @escaping (Bool, Error?) -> Void) {
        let jsonEncoder = JSONEncoder()
        let jsonDecoder = JSONDecoder()
        let oauth2ClientCredentials = DigitalMonitorAPI.sharedInstance.oauth2ClientCredentials
        guard let email = email else {
            return onCompletion(false, UserError.RegistrationError.missingEmail)
        }
    
        guard let password = password else {
            return onCompletion(false, UserError.RegistrationError.missingPassword)
        }
        
        guard let firstName = firstName else {
            return onCompletion(false, UserError.RegistrationError.missingFirstName)
        }
        
        guard let lastName = lastName else {
            return onCompletion(false, UserError.RegistrationError.missingPassword)
        }
        
        let requestBody = RegistrationRequestBody(firstName: firstName, lastName: lastName, email: email, password: password)
        var req = oauth2ClientCredentials.request(forURL: DMUser.endpoint)
        
        req.httpMethod = "POST"
        guard let requestBodyJSON = try? jsonEncoder.encode(requestBody) else {
            return onCompletion(false, RequestError.jsonEncodingError)
        }

        req.setValue("application/json", forHTTPHeaderField: "content-type")
        req.httpBody = requestBodyJSON
        debugPrint("About to create dataTask")
        let task = oauth2ClientCredentials.session.dataTask(with: req) { (data, response, error) in
            if let error = error {
                onCompletion(false, error)
            } else {
                guard let response = response as? HTTPURLResponse else {
                    return onCompletion(false, ResponseError.nilResponse)
                }

                if response.statusCode == 201 {
                    if let data = data {

                        if let responseBody = try? jsonDecoder.decode(PostUserResponse.self, from: data){
                            self.id = responseBody.data.user.id
                            onCompletion(true, nil)
                        } else {
                            onCompletion(false, ResponseError.responseDecodeError)
                        }

                    } else {
                        onCompletion(false, ResponseError.noResponseData)
                    }
                } else {
                    onCompletion(false, ResponseError.responseNotOK)
                }
            }
        }
        task.resume()
    }
    
    static func getUser(byEmail email: String, onCompletion: @escaping (DMUser?, Error?) -> Void){
        print("Getting user")
        let jsonDecoder = JSONDecoder()
        let oauth2ClientCredentials = DigitalMonitorAPI.sharedInstance.oauth2ClientCredentials
        var urlComponents = URLComponents(url: DMUser.endpoint, resolvingAgainstBaseURL: false)!
        urlComponents.queryItems = [URLQueryItem(name: "email", value: email)]
        let req = oauth2ClientCredentials.request(forURL: urlComponents.url!)

        let task = oauth2ClientCredentials.session.dataTask(with: req) { (data, response, error) in
            if let error = error {
                onCompletion(nil, error)
            } else {
                guard let response = response as? HTTPURLResponse else {
                    return onCompletion(nil, ResponseError.nilResponse)
                }
                
                if response.statusCode == 200 {
                    if let data = data {
                        if let responseBody = try? jsonDecoder.decode(GetUsersResponse.self, from: data){
                            let users = responseBody.data.users
                            if users.count < 1 {
                                onCompletion(nil, UserError.QueryError.userNotFound)
                            } else {
                                onCompletion(users[0], nil)
                            }
                        } else {
                            onCompletion(nil, ResponseError.responseDecodeError)
                        }
                        
                    } else {
                        onCompletion(nil, ResponseError.noResponseData)
                    }
                } else {
                    onCompletion(nil, ResponseError.responseNotOK)
                }
            }
        }
        
        task.resume()
    }
    
    
}
