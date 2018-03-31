//
//  UserController.swift
//  Digital Monitor
//
//  Created by Dan Austin on 13/01/2018.
//  Copyright © 2018 Dan Austin. All rights reserved.
//

import Foundation
import p2_OAuth2
import UIKit


/// User controller to interact with the web API user related endpoints
class UserController {
    
    // Endpoint urls
    let usersEndpoint = URL(string: "https://digitalmonitor.tk/api/users")!
    let usersIdTemplate = "https://digitalmonitor.tk/api/users/%@"
    let userClientsEndpointTemplate = "https://digitalmonitor.tk/api/users/%@/clients"
    let userClientByIdEndpointTemplate = "https://digitalmonitor.tk/api/users/%@/clients/%@"
    let userOverallMetricsEndpointTemplate = "https://digitalmonitor.tk/api/users/%@/metrics/overall"
    let userApplicationsMetricsEndpointTemplate = "https://digitalmonitor.tk/api/users/%@/metrics/applications"
    let userApplicationPlatformsMetricsEndpointTemplate = "https://digitalmonitor.tk/api/users/%@/metrics/applications/%@"
    let userGoalProgressEndpointTemplate = "https://digitalmonitor.tk/api/users/%@/usage-goals/progress"
    let userGoalsEndpointTemplate = "https://digitalmonitor.tk/api/users/%@/usage-goals/"
    let userGoalsByIdEndpointTemplate = "https://digitalmonitor.tk/api/users/%@/usage-goals/%@"
    let userPlatformsMetricsEndpointTemplate = "https://digitalmonitor.tk/api/users/%@/metrics/platforms"
    let userPlatformApplicationsMetricsEndpointTemplate = "https://digitalmonitor.tk/api/users/%@/metrics/platforms/%@"
    let userAggregatedMetricsEndpointTemplate = "https://digitalmonitor.tk/api/users/%@/metrics/"
    let userApplicationsEndpointTemplate = "https://digitalmonitor.tk/api/users/%@/applications/"
    
    // Objects to manage the OAuth 2 access credentials
    let oauth2PasswordGrant = DigitalMonitorAPI.sharedInstance.oauth2PasswordGrant
    let oauth2ClientCredentials = DigitalMonitorAPI.sharedInstance.oauth2ClientCredentials
    
    
    /// Construct, send, and parse a request and response for user aggregated metrics from the web API
    ///
    /// - Parameters:
    ///   - user: User for which to get metrics
    ///   - query: Query used to limit metrics between a from and to time
    ///   - onCompletion: callback function to be called on completion
    func getAggregatedMetrics(forUser user: DMUser, withQuery query: [String:String], onCompletion: @escaping (AggregatedMetricsResponseData?, Error?) -> Void){
        // Decoder to convert JSON response to swift objects
        let jsonDecoder = JSONDecoder()
        
        // Ensure user is logged in and parameters are valid
        if !DMUser.userIsLoggedIn {
            return onCompletion(nil, UserError.AuthenticationError.userNotLoggedIn)
        }
        guard let id = user.id else {
            return onCompletion(nil, UserError.QueryError.userNotSaved)
        }
        
        // Generate URL from template
        guard let urlString = URL(string: String(format: userAggregatedMetricsEndpointTemplate, id)) else {
            return onCompletion(nil, RequestError.urlError)
        }
        
        // Convert query dictionary
        var queryItems: [URLQueryItem] = []
        for (key, value) in query {
            queryItems.append(URLQueryItem(name: key, value: value))
        }
        
        // Build the url with the query
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
    
    /// Construct, send, and parse a request and response for user aggregated metrics from the web API
    ///
    /// - Parameters:
    ///   - user: User for which to retrieve metrics
    ///   - onCompletion: callback function to be called on completion
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
    
    /// Construct, send, and parse a request and response for user application metrics from the web API
    ///
    /// - Parameters:
    ///   - user: user for which to retrieve application metrics
    ///   - onCompletion: callback function to be called on completion
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
                                return onCompletion(responseBody.data, nil)
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
    
    /// Construct, send, and parse a request and response for user platform metrics from the web API
    ///
    /// - Parameters:
    ///   - user: user for which to retrieve metrics
    ///   - onCompletion: callback function to be called on completion
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
    
    /// Construct, send, and parse a request and response for user overall metrics from the web API
    ///
    /// - Parameters:
    ///   - user: user for which to retrieve metrics
    ///   - onCompletion: callback function to be called on completion
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
    
    /// Construct, send, and parse a request and response for revocation of client access to user account from the web API
    ///
    /// - Parameters:
    ///   - client: client to revoke access from
    ///   - user: user revoking access
    ///   - onCompletion: callback function to be called on completion
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
    
    /// Construct, send, and parse a request and response for user authorised api clients from the web API
    ///
    /// - Parameters:
    ///   - user: user for which to retrieve clients
    ///   - onCompletion: callback function to be called on completion
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
    
    /// Construct, send, and parse a request and response for user query from the web API
    ///
    /// - Parameters:
    ///   - email: email used to search for user
    ///   - onCompletion: callback function to be called on completion
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
    
    /// Construct, send, and parse a request and response for user registration from the web API
    ///
    /// - Parameters:
    ///   - user: user to register
    ///   - onCompletion: callback function to be called on completion
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
    
    /// Construct, send, and parse a request and response for user authorisation via OAuth 2 password flow from the web API
    ///
    /// - Parameters:
    ///   - email: email address used to authenticate the user
    ///   - password: password used to authenticate the user
    ///   - onCompletion: callback function to be called on completion
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
    
    /// Construct, send, and parse a request and response for user usage goal progress from the web API
    ///
    /// - Parameters:
    ///   - user: user for which to retrieve usage goal progress
    ///   - onCompletion: callback function to call on completion
    func getUsageGoalProgress(forUser user: DMUser, onCompletion: @escaping ([DMUser.UsageGoal]?, Error?) -> Void){
        let jsonDecoder = JSONDecoder()
        if !DMUser.userIsLoggedIn {
            return onCompletion(nil, UserError.AuthenticationError.userNotLoggedIn)
        }
        guard let id = user.id else {
            return onCompletion(nil, UserError.QueryError.userNotSaved)
        }
        guard let URL = URL(string: String(format: userGoalProgressEndpointTemplate, id)) else {
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
                        if let responseBody = try? jsonDecoder.decode(GetGoalProgressResponse.self, from: data){
                            if responseBody.status == "success"{
                                return onCompletion(responseBody.data.usageGoals, nil)
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
    
    /// Construct, send, and parse a request and response for user authorised applications from the web API
    ///
    /// - Parameters:
    ///   - user: user for which to get authorised applications
    ///   - onCompletion: callback function to be called
    func getAuthorisedApplications(forUser user: DMUser, onCompletion: @escaping ([DMApplication]?, Error?) -> Void){
        let jsonDecoder = JSONDecoder()
        if !DMUser.userIsLoggedIn {
            return onCompletion(nil, UserError.AuthenticationError.userNotLoggedIn)
        }
        guard let id = user.id else {
            return onCompletion(nil, UserError.QueryError.userNotSaved)
        }
        guard let URL = URL(string: String(format: userApplicationsEndpointTemplate, id)) else {
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
                        if let responseBody = try? jsonDecoder.decode(GetApplicationsResponse.self, from: data){
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
    
    /// Construct, send, and parse a request and response for adding a user usage log from the web API
    ///
    /// - Parameters:
    ///   - goal: goal to be added to the user
    ///   - user: user to which to add the goal
    ///   - onCompletion: callback function to be called on completion
    func add(usageGoal goal: DMUser.UsageGoal, toUser user: DMUser, onCompletion: @escaping (DMUser.UsageGoal?, Error?) -> Void){
        let jsonEncoder = JSONEncoder()
        let jsonDecoder = JSONDecoder()
        
        guard let id = user.id else {
            return onCompletion(nil, UserError.QueryError.userNotSaved)
        }
        
        guard let URL = URL(string: String(format: userGoalsEndpointTemplate, id)) else {
            return onCompletion(nil, RequestError.urlError)
        }
        var req = oauth2ClientCredentials.request(forURL: URL)
        let body = PostUsageGoalRequest(duration: goal.duration, periodId: goal.period.id, platformId: goal.platform?.id, applicationId: goal.application?.id)
        req.httpMethod = "POST"
        guard let requestBodyJSON = try? jsonEncoder.encode(body) else {
            return onCompletion(nil, RequestError.jsonEncodingError)
        }
        
        req.setValue("application/json", forHTTPHeaderField: "content-type")
        req.httpBody = requestBodyJSON
        
        let loader = OAuth2DataLoader(oauth2: oauth2PasswordGrant)
        
        loader.perform(request: req) { (oauthResponse) in
            if let error = oauthResponse.error {
                onCompletion(nil, error)
            } else {
                if oauthResponse.response.statusCode == 201 {
                    if let data = oauthResponse.data {
                        
                        if let responseBody = try? jsonDecoder.decode(PostUsageGoalResponse.self, from: data){
                            onCompletion(responseBody.data.usageGoal, nil)
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
    
    /// Construct, send, and parse a request and response for saving a user usage goal from the web API
    ///
    /// - Parameters:
    ///   - goal: usage goal to save
    ///   - user: user to which to save the usage goal
    ///   - onCompletion: callback function to be called on completion
    func save(usageGoal goal: DMUser.UsageGoal, toUser user: DMUser, onCompletion: @escaping (Error?) -> Void){
        let jsonEncoder = JSONEncoder()
        guard let goalId = goal.id else {
            return onCompletion(UsageGoalError.SaveError.missingId)
        }
        guard let userId = user.id else {
            return onCompletion(UserError.QueryError.userNotSaved)
        }
        guard let url = URL(string: String(format: userGoalsByIdEndpointTemplate, userId, goalId)) else {
            return onCompletion(RequestError.urlError)
        }
        
        let body = PostUsageGoalRequest(duration: goal.duration, periodId: goal.period.id, platformId: goal.platform?.id, applicationId: goal.application?.id)
        
        guard let jsonEncodedBody = try? jsonEncoder.encode(body) else {
            return onCompletion(RequestError.jsonEncodingError)
        }
        
        var req = oauth2PasswordGrant.request(forURL: url)
        
        req.httpMethod = "PUT"
        
        req.httpBody = jsonEncodedBody
        
        req.setValue("application/json", forHTTPHeaderField: "content-type")
        
        let loader = OAuth2DataLoader(oauth2: oauth2PasswordGrant)
        
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
    
    /// Construct, send, and parse a request and response for user application metrics from the web API
    ///
    /// - Parameters:
    ///   - platform: platform for which to get application metrics
    ///   - user: user for which to get the metrics
    ///   - query: query to restrict metrics between a from and to time
    ///   - onCompletion: callback function to be called on completion
    func getApplicationMetrics(forPlatform platform: DMPlatform, forUser user: DMUser, withQuery query: [String:String], onCompletion: @escaping ([ApplicationUsageData]?, Error?) -> Void){
        let jsonDecoder = JSONDecoder()
        if !DMUser.userIsLoggedIn {
            return onCompletion(nil, UserError.AuthenticationError.userNotLoggedIn)
        }
        guard let id = user.id else {
            return onCompletion(nil, UserError.QueryError.userNotSaved)
        }
        guard let urlString = URL(string: String(format: userPlatformApplicationsMetricsEndpointTemplate, id, platform.id)) else {
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
                            let responseBody = try jsonDecoder.decode(ApplicationsMetricsResponse.self, from: data)
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
    
    /// Construct, send, and parse a request and response for saving a user from the web API
    ///
    /// - Parameters:
    ///   - user: user to save
    ///   - onCompletion: callback function to be called on completion
    func save(user: DMUser, onCompletion: @escaping (Error?) -> Void){
        let jsonEncoder = JSONEncoder()
        guard let firstName = user.firstName else {
            return onCompletion(UserError.RegistrationError.missingFirstName)
        }
        guard let userId = user.id else {
            return onCompletion(UserError.QueryError.userNotSaved)
        }
        guard let lastName = user.lastName else {
            return onCompletion(UserError.RegistrationError.missingLastName)
        }
        guard let url = URL(string: String(format: usersIdTemplate, userId)) else {
            return onCompletion(RequestError.urlError)
        }
        let requestBody = PutUserRequestBody(firstName: firstName, lastName: lastName, email: nil, password: nil)
        var req = oauth2PasswordGrant.request(forURL: url)
        
        req.httpMethod = "PUT"
        guard let requestBodyJSON = try? jsonEncoder.encode(requestBody) else {
            return onCompletion(RequestError.jsonEncodingError)
        }
        
        req.setValue("application/json", forHTTPHeaderField: "content-type")
        req.httpBody = requestBodyJSON
        
        let loader = OAuth2DataLoader(oauth2: oauth2ClientCredentials)
        
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
    
    /// Construct, send, and parse a request and response for deleting a user from the web API
    ///
    /// - Parameters:
    ///   - user: user to be deleted
    ///   - onCompletion: callback function to be called on completion
    func delete(user: DMUser, onCompletion: @escaping (Error?) -> Void){
        guard let userId = user.id else {
            return onCompletion(UserError.QueryError.userNotSaved)
        }
       
        guard let url = URL(string: String(format: usersIdTemplate, userId)) else {
            return onCompletion(RequestError.urlError)
        }
        var req = oauth2PasswordGrant.request(forURL: url)
        req.httpMethod = "DELETE"
        let loader = OAuth2DataLoader(oauth2: oauth2ClientCredentials)
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
    
    /// Construct, send, and parse a request and response for user platform metrics from the web API
    ///
    /// - Parameters:
    ///   - application: application for which to get platform metrics
    ///   - user: user for which to get metrics
    ///   - query: query to limit metrics search between a from time and to time
    ///   - onCompletion: callback function to be called on completion
    func getPlatformMetrics(forApplication application: DMApplication, forUser user: DMUser, withQuery query: [String:String], onCompletion: @escaping ([PlatformUsageData]?, Error?) -> Void){
        let jsonDecoder = JSONDecoder()
        if !DMUser.userIsLoggedIn {
            return onCompletion(nil, UserError.AuthenticationError.userNotLoggedIn)
        }
        guard let userId = user.id else {
            return onCompletion(nil, UserError.QueryError.userNotSaved)
        }
        guard let applicationId = application.id else {
            return onCompletion(nil, ApplicationError.QueryError.missingId)
        }
        guard let urlString = URL(string: String(format: userApplicationPlatformsMetricsEndpointTemplate, userId, applicationId)) else {
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
                            let responseBody = try jsonDecoder.decode(PlatformsMetricsResponse.self, from: data)
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
    
    /// Construct, send, and parse a request and response for deleting a user usage goal from the web API
    ///
    /// - Parameters:
    ///   - goal: goal to be deleted
    ///   - user: user from which to delete the goal
    ///   - onCompletion: callback funvtion to be called on completion
    func delete(usageGoal goal: DMUser.UsageGoal, fromUser user: DMUser, onCompletion: @escaping (Error?) -> Void){
        let jsonEncoder = JSONEncoder()
        guard let goalId = goal.id else {
            return onCompletion(UsageGoalError.SaveError.missingId)
        }
        guard let userId = user.id else {
            return onCompletion(UserError.QueryError.userNotSaved)
        }
        guard let url = URL(string: String(format: userGoalsByIdEndpointTemplate, userId, goalId)) else {
            return onCompletion(RequestError.urlError)
        }
        
        guard let body = try? jsonEncoder.encode(goal) else {
            return onCompletion(RequestError.jsonEncodingError)
        }
        
        var req = oauth2PasswordGrant.request(forURL: url)
        
        req.httpMethod = "DELETE"
        
        req.httpBody = body
        
        req.setValue("application/json", forHTTPHeaderField: "content-type")
        
        let loader = OAuth2DataLoader(oauth2: oauth2PasswordGrant)
        
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
    
    /// Construct, send, and parse a request and response for saving a user password from the web API
    ///
    /// - Parameters:
    ///   - password: new password to be saved
    ///   - user: user to which to save the password
    ///   - onCompletion: callback function to be called on completion
    func save(password: String, forUser user: DMUser, onCompletion: @escaping (Error?) -> Void){
        let jsonEncoder = JSONEncoder()
       
        guard let userId = user.id else {
            return onCompletion(UserError.QueryError.userNotSaved)
        }
        guard let url = URL(string: String(format: usersIdTemplate, userId)) else {
            return onCompletion(RequestError.urlError)
        }
        let requestBody = PutUserRequestBody(firstName: nil, lastName: nil, email: nil, password: password)
        var req = oauth2PasswordGrant.request(forURL: url)
        
        req.httpMethod = "PUT"
        guard let requestBodyJSON = try? jsonEncoder.encode(requestBody) else {
            return onCompletion(RequestError.jsonEncodingError)
        }
        
        req.setValue("application/json", forHTTPHeaderField: "content-type")
        req.httpBody = requestBodyJSON
        
        let loader = OAuth2DataLoader(oauth2: oauth2ClientCredentials)
        
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
