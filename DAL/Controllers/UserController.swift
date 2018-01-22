//
//  UserController.swift
//  Digital Monitor
//
//  Created by Dan Austin on 13/01/2018.
//  Copyright © 2018 Dan Austin. All rights reserved.
//

import Foundation
import OAuth2
import UIKit

class UserController {
    
    
    
    let usersEndpoint = URL(string: "https://digitalmonitor.tk/api/users")!
    let userClientsEndpointTemplate = "https://digitalmonitor.tk/api/users/%@/clients"
    let userClientByIdEndpointTemplate = "https://digitalmonitor.tk/api/users/%@/clients/%@"
    let userOverallMetricsEndpointTemplate = "https://digitalmonitor.tk/api/users/%@/metrics/overall"
    let userApplicationsMetricsEndpointTemplate = "https://digitalmonitor.tk/api/users/%@/metrics/applications"
    let userPlatformsMetricsEndpointTemplate = "https://digitalmonitor.tk/api/users/%@/metrics/platforms"
    let userAggregatedMetricsEndpointTemplate = "https://digitalmonitor.tk/api/users/%@/metrics/"
    let oauth2PasswordGrant = DigitalMonitorAPI.sharedInstance.oauth2PasswordGrant
    let oauth2ClientCredentials = DigitalMonitorAPI.sharedInstance.oauth2ClientCredentials
    
    
    func getAggregatedMetrics(forUser user: DMUser, withQuery query: [String:String], onCompletion: @escaping (AggregatedMetricsResponseData?, Error?) -> Void){
        let jsonDecoder = JSONDecoder()
        if !DMUser.userIsLoggedIn {
            return onCompletion(nil, UserError.AuthenticationError.userNotLoggedIn)
        }
        guard let id = user.id else {
            return onCompletion(nil, UserError.QueryError.userNotSaved)
        }
        guard let urlString = URL(string: String(format: userAggregatedMetricsEndpointTemplate, id)) else {
            return onCompletion(nil, RequestError.urlError)
        }
        
        var queryItems: [URLQueryItem] = []
        for (key, value) in query {
            queryItems.append(URLQueryItem(name: key, value: value))
        }
        
        guard var urlComponents = URLComponents(url: urlString, resolvingAgainstBaseURL: false) else {
            return onCompletion(nil, RequestError.urlError)
        }
        
        urlComponents.queryItems = queryItems
        
        guard let url = urlComponents.url else {
            return onCompletion(nil, RequestError.urlError)
        }
        
        let req = oauth2PasswordGrant.request(forURL: url)
        let loader = OAuth2DataLoader(oauth2: oauth2PasswordGrant)
        
        loader.perform(request: req) { (oauthResponse) in
            if let error = oauthResponse.error {
                onCompletion(nil, error)
            } else {
                if oauthResponse.response.statusCode == 200 {
                    if let data = oauthResponse.data {
                        
                        do{
                            let responseBody = try jsonDecoder.decode(AggregatedMetricsResponse.self, from: data)
                            if responseBody.status == "success"{
                                return onCompletion(responseBody.data, nil)
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
    
    func getAggregatedMetrics(forUser user: DMUser, onCompletion: @escaping (AggregatedMetricsResponseData?, Error?) -> Void){
        let jsonDecoder = JSONDecoder()
        if !DMUser.userIsLoggedIn {
            return onCompletion(nil, UserError.AuthenticationError.userNotLoggedIn)
        }
        guard let id = user.id else {
            return onCompletion(nil, UserError.QueryError.userNotSaved)
        }
        guard let URL = URL(string: String(format: userAggregatedMetricsEndpointTemplate, id)) else {
            return onCompletion(nil, RequestError.urlError)
        }
        let req = oauth2PasswordGrant.request(forURL: URL)
        let loader = OAuth2DataLoader(oauth2: oauth2PasswordGrant)
        
        loader.perform(request: req) { (oauthResponse) in
            if let error = oauthResponse.error {
                onCompletion(nil, error)
            } else {
                if oauthResponse.response.statusCode == 200 {
                    if let data = oauthResponse.data {
                        do{
                            let responseBody = try jsonDecoder.decode(AggregatedMetricsResponse.self, from: data)
                            if responseBody.status == "success"{
                                return onCompletion(responseBody.data, nil)
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
    
    func getApplicationsMetrics(forUser user: DMUser, onCompletion: @escaping ([ApplicationUsageData]?, Error?) -> Void){
        let jsonDecoder = JSONDecoder()
        if !DMUser.userIsLoggedIn {
            return onCompletion(nil, UserError.AuthenticationError.userNotLoggedIn)
        }
        guard let id = user.id else {
            return onCompletion(nil, UserError.QueryError.userNotSaved)
        }
        guard let URL = URL(string: String(format: userApplicationsMetricsEndpointTemplate, id)) else {
            return onCompletion(nil, RequestError.urlError)
        }
        let req = oauth2PasswordGrant.request(forURL: URL)
        let loader = OAuth2DataLoader(oauth2: oauth2PasswordGrant)
        
        loader.perform(request: req) { (oauthResponse) in
            if let error = oauthResponse.error {
                onCompletion(nil, error)
            } else {
                if oauthResponse.response.statusCode == 200 {
                    if let data = oauthResponse.data {
                        if let responseBody = try? jsonDecoder.decode(ApplicationsMetricsResponse.self, from: data){
                            if responseBody.status == "success"{
                                return onCompletion(responseBody.data.applications, nil)
                            } else {
                                return onCompletion(nil, ResponseError.errorOnStatusOk)
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
    }
    
    func getPlatforms(forUser user: DMUser, onCompletion: @escaping ([PlatformUsageData]?, Error?) -> Void){
        let jsonDecoder = JSONDecoder()
        if !DMUser.userIsLoggedIn {
            return onCompletion(nil, UserError.AuthenticationError.userNotLoggedIn)
        }
        guard let id = user.id else {
            return onCompletion(nil, UserError.QueryError.userNotSaved)
        }
        guard let URL = URL(string: String(format: userPlatformsMetricsEndpointTemplate, id)) else {
            return onCompletion(nil, RequestError.urlError)
        }
        let req = oauth2PasswordGrant.request(forURL: URL)
        let loader = OAuth2DataLoader(oauth2: oauth2PasswordGrant)
        
        loader.perform(request: req) { (oauthResponse) in
            if let error = oauthResponse.error {
                onCompletion(nil, error)
            } else {
                if oauthResponse.response.statusCode == 200 {
                    if let data = oauthResponse.data {
                        if let responseBody = try? jsonDecoder.decode(PlatformsMetricsResponse.self, from: data){
                            if responseBody.status == "success"{
                                return onCompletion(responseBody.data.platforms, nil)
                            } else {
                                return onCompletion(nil, ResponseError.errorOnStatusOk)
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
    }
    
    func getOverallUsageInSeconds(forUser user: DMUser, onCompletion: @escaping (Int?, Error?) -> Void){
        let jsonDecoder = JSONDecoder()
        if !DMUser.userIsLoggedIn {
            return onCompletion(nil, UserError.AuthenticationError.userNotLoggedIn)
        }
        guard let id = user.id else {
            return onCompletion(nil, UserError.QueryError.userNotSaved)
        }
        guard let URL = URL(string: String(format: userOverallMetricsEndpointTemplate, id)) else {
            return onCompletion(nil, RequestError.urlError)
        }
        let req = oauth2PasswordGrant.request(forURL: URL)
        let loader = OAuth2DataLoader(oauth2: oauth2PasswordGrant)
        
        loader.perform(request: req) { (oauthResponse) in
            if let error = oauthResponse.error {
                onCompletion(nil, error)
            } else {
                if oauthResponse.response.statusCode == 200 {
                    if let data = oauthResponse.data {
                        if let responseBody = try? jsonDecoder.decode(OverallMetricsResponse.self, from: data){
                            if responseBody.status == "success"{
                                return onCompletion(responseBody.data.duration, nil)
                            } else {
                                return onCompletion(nil, ResponseError.errorOnStatusOk)
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
    }
    
    func revokeAccess(fromClient client: DMClient, forUser user: DMUser, onCompletion: @escaping (Bool, Error?) -> Void) {
        let jsonDecoder = JSONDecoder()
        if !DMUser.userIsLoggedIn {
            return onCompletion(false, UserError.AuthenticationError.userNotLoggedIn)
        }
        guard let id = user.id else {
            return onCompletion(false, UserError.QueryError.userNotSaved)
        }
        guard let URL = URL(string: String(format: userClientByIdEndpointTemplate, id, client.id)) else {
            return onCompletion(false, RequestError.urlError)
        }
        
        var req = oauth2PasswordGrant.request(forURL: URL)
        req.httpMethod = "DELETE"
        
        let loader = OAuth2DataLoader(oauth2: oauth2PasswordGrant)
        
        loader.perform(request: req) { (oauthResponse) in
            if let error = oauthResponse.error {
                onCompletion(false, error)
            } else {
                
                if oauthResponse.response.statusCode == 200 {
                    if let data = oauthResponse.data {
                        if let responseBody = try? jsonDecoder.decode(RevokeClientAccessResponse.self, from: data){
                            if responseBody.status == "success"{
                                return onCompletion(true, nil)
                            } else {
                                return onCompletion(false, ResponseError.errorOnStatusOk)
                            }
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
    }
    
    func getAuthorisedClients(forUser user: DMUser, _ onCompletion: @escaping ([DMClient]?, Error?) -> Void){
        let jsonDecoder = JSONDecoder()
        if !DMUser.userIsLoggedIn {
            return onCompletion(nil, UserError.AuthenticationError.userNotLoggedIn)
        }
        guard let id = user.id else {
            return onCompletion(nil, UserError.QueryError.userNotSaved)
        }
        guard let URL = URL(string: String(format: userClientsEndpointTemplate, id)) else {
            return onCompletion(nil, RequestError.urlError)
        }
        
        let req = oauth2PasswordGrant.request(forURL: URL)
        let loader = OAuth2DataLoader(oauth2: oauth2PasswordGrant)
        
        loader.perform(request: req) { (oauthResponse) in
            if let error = oauthResponse.error {
                onCompletion(nil, error)
            } else {
                if oauthResponse.response.statusCode == 200 {
                    if let data = oauthResponse.data {
                        if let responseBody = try? jsonDecoder.decode(GetClientsResponse.self, from: data){
                            let clients = responseBody.data.clients
                            return onCompletion(clients, nil)
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
    }
    
    func getUser(byEmail email: String, onCompletion: @escaping (DMUser?, Error?) -> Void){
        print("Getting user")
        let jsonDecoder = JSONDecoder()
        var urlComponents = URLComponents(url: usersEndpoint, resolvingAgainstBaseURL: false)!
        urlComponents.queryItems = [URLQueryItem(name: "email", value: email)]
        let req = oauth2PasswordGrant.request(forURL: urlComponents.url!)
        let loader = OAuth2DataLoader(oauth2: oauth2PasswordGrant)
        
        loader.perform(request: req) { (oauthResponse) in
            if let error = oauthResponse.error {
                onCompletion(nil, error)
            } else {
                if oauthResponse.response.statusCode == 200 {
                    if let data = oauthResponse.data {
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
    }
    
    func register(user: DMUser, onCompletion: @escaping (Bool, Error?) -> Void) {
        let jsonEncoder = JSONEncoder()
        let jsonDecoder = JSONDecoder()
        guard let email = user.email else {
            return onCompletion(false, UserError.RegistrationError.missingEmail)
        }
        
        guard let password = user.password else {
            return onCompletion(false, UserError.RegistrationError.missingPassword)
        }
        
        guard let firstName = user.firstName else {
            return onCompletion(false, UserError.RegistrationError.missingFirstName)
        }
        
        guard let lastName = user.lastName else {
            return onCompletion(false, UserError.RegistrationError.missingPassword)
        }
        
        let requestBody = UserRegistrationRequestBody(firstName: firstName, lastName: lastName, email: email, password: password)
        var req = oauth2ClientCredentials.request(forURL: usersEndpoint)
        
        req.httpMethod = "POST"
        guard let requestBodyJSON = try? jsonEncoder.encode(requestBody) else {
            return onCompletion(false, RequestError.jsonEncodingError)
        }
        
        req.setValue("application/json", forHTTPHeaderField: "content-type")
        req.httpBody = requestBodyJSON
        
        let loader = OAuth2DataLoader(oauth2: oauth2ClientCredentials)
        
        loader.perform(request: req) { (oauthResponse) in
            if let error = oauthResponse.error {
                onCompletion(false, error)
            } else {
                if oauthResponse.response.statusCode == 201 {
                    if let data = oauthResponse.data {
                        
                        if let responseBody = try? jsonDecoder.decode(PostUserResponse.self, from: data){
                            user.id = responseBody.data.user.id
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
    }
    
    func login(withEmail email: String, password: String, onCompletion: @escaping (DMUser?, Error?) -> Void){
        // Delete existing tokens as we only want resource owner token now and want to make sure its for the newly authenticated user and not a different user
        oauth2PasswordGrant.forgetTokens()
        // Use supplied credentials to attempt to get an access token for this user
        oauth2PasswordGrant.password = password
        oauth2PasswordGrant.username = email
        oauth2PasswordGrant.authorize { (json, error) in
            print("completion")
            if let error = error {
                print("error found")
                onCompletion(nil, error)
            } else {
                print("no error found")
                // If successful, lookup the user details for the provided email to get a user object
                // Assign user object to authenticatedUser property
                print("About to get user")
                self.getUser(byEmail: email) { (user, error) in
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
}
