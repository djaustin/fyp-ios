//
//  MonitoringExceptionController.swift
//  Digital Monitor
//
//  Created by Dan Austin on 09/03/2018.
//  Copyright © 2018 Dan Austin. All rights reserved.
//

import Foundation
import p2_OAuth2

/// Controller to interact with the web API for monitoring exception related endpoints
class MonitoringExceptionController {
    
    /// Endpoint URL template
    let monitoringExceptionsEndpointTemplate = "https://digitalmonitor.tk/api/users/%@/monitoring-exceptions/"
    
    /// Manager for OAuth 2 access tokens
    let oauth2Credentials = DigitalMonitorAPI.sharedInstance.oauth2PasswordGrant
    
    /// Decoder to convert from JSON to swift objects
    let jsonDecoder: JSONDecoder = {
        let jsonDecoder = JSONDecoder()
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSSZ"
        jsonDecoder.dateDecodingStrategy = .formatted(formatter)
        return jsonDecoder
    }()
    
    /// Encoder to convert from swift object to JSON
    let jsonEncoder = JSONEncoder()
    
    /// Construct, send, and parse a request and response for monitoring exceptions from the web API
    ///
    /// - Parameters:
    ///   - user: user for which to retrieve monitoring exceptions
    ///   - onCompletion: callback function to be called on completion
    func getMonitoringExceptions(forUser user: DMUser, onCompletion: @escaping ([DMMonitoringException]?, Error?) -> Void){
        
        guard let userId = user.id else {
            return onCompletion(nil, UserError.QueryError.userNotSaved)
        }
        guard let url = URL(string: String(format: monitoringExceptionsEndpointTemplate, userId)) else {
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
                        do {
                            let responseBody = try self.jsonDecoder.decode(GetMonitoringExceptionsResponse.self, from: data)
                            if responseBody.status == "success"{
                                return onCompletion(responseBody.data.monitoringExceptions, nil)
                            } else {
                                return onCompletion(nil, ResponseError.errorOnStatusOk)
                            }
                        } catch {
                            print(error)
                            return onCompletion(nil, ResponseError.responseDecodeError)
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
    
    
    /// Construct, send, and parse a request and response for adding a new monitoring exceptio from the web API
    ///
    /// - Parameters:
    ///   - exception: exception to be added
    ///   - onCompletion: callback function to be called on completion
    func addNew(exception: DMMonitoringException, onCompletion: @escaping (DMMonitoringException?, Error?) -> Void) {
        guard let url = URL(string: String(format: monitoringExceptionsEndpointTemplate, exception.user)) else {
            return onCompletion(nil, RequestError.urlError)
        }
        
        var requestBody = PostMonitoringExceptionRequest(startTime: Int(exception.startTime.timeIntervalSince1970*1000), endTime: Int(exception.endTime.timeIntervalSince1970*1000), platformId: exception.platform?.id, applicationId: exception.application?.id)
        
        guard let body = try? jsonEncoder.encode(requestBody) else {
            return onCompletion(nil, RequestError.jsonEncodingError)
        }
        
        var req = oauth2Credentials.request(forURL: url)
        print(String(data: body, encoding: .utf8))
        req.httpMethod = "POST"
        
        req.httpBody = body
        
        req.setValue("application/json", forHTTPHeaderField: "content-type")
        
        let loader = OAuth2DataLoader(oauth2: oauth2Credentials)
        
        loader.perform(request: req) { (oauthResponse) in
            if let error = oauthResponse.error {
                onCompletion(nil, error)
            } else {
                if oauthResponse.response.statusCode == 201 {
                    if let data = oauthResponse.data {
                        if let responseBody = try? self.jsonDecoder.decode(PostMonitoringExceptionResponse.self, from: data){
                            onCompletion(responseBody.data.monitoringException, nil)
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
    
    /// Construct, send, and parse a request and response for saving monitoring from the web API
    ///
    /// - Parameters:
    ///   - exception: monitoring exception to be saved
    ///   - onCompletion: callback function to be called on completion
    func save(exception: DMMonitoringException, onCompletion: @escaping (Error?) -> Void) {
        
        guard let exceptionId = exception.id else {
            return onCompletion(MonitoringExceptionError.SaveError.missingId)
        }
        guard let url = URL(string: String(format: monitoringExceptionsEndpointTemplate, exception.user) + exceptionId) else {
            return onCompletion(RequestError.urlError)
        }
        
        var requestBody = PostMonitoringExceptionRequest(startTime: Int(exception.startTime.timeIntervalSince1970*1000), endTime: Int(exception.endTime.timeIntervalSince1970*1000), platformId: exception.platform?.id, applicationId: exception.application?.id)
        
        guard let body = try? jsonEncoder.encode(requestBody) else {
            return onCompletion(RequestError.jsonEncodingError)
        }
        
        var req = oauth2Credentials.request(forURL: url)
        print(String(data: body, encoding: .utf8))
        req.httpMethod = "PUT"
        
        req.httpBody = body
        
        req.setValue("application/json", forHTTPHeaderField: "content-type")
        
        let loader = OAuth2DataLoader(oauth2: oauth2Credentials)
        
        loader.perform(request: req) { (oauthResponse) in
            if let error = oauthResponse.error {
                onCompletion(error)
            } else {
                if oauthResponse.response.statusCode == 200 {
                    return onCompletion(nil)
                } else {
                    onCompletion(ResponseError.responseNotOK)
                }
            }
        }
    }
    
    /// Construct, send, and parse a request and response for deleting a monitoring exception from the web API
    ///
    /// - Parameters:
    ///   - exception: exception to be deleted
    ///   - onCompletion: callback function to be called on completion
    func delete(exception: DMMonitoringException, onCompletion: @escaping (Error?) -> Void) {
        guard let exceptionId = exception.id else {
            return onCompletion(MonitoringExceptionError.SaveError.missingId)
        }
        guard let url = URL(string: String(format: monitoringExceptionsEndpointTemplate, exception.user) + exceptionId) else {
            return onCompletion(RequestError.urlError)
        }
        
        var req = oauth2Credentials.request(forURL: url)
        req.httpMethod = "DELETE"
    
        let loader = OAuth2DataLoader(oauth2: oauth2Credentials)
        
        loader.perform(request: req) { (oauthResponse) in
            if let error = oauthResponse.error {
                onCompletion(error)
            } else {
                if oauthResponse.response.statusCode == 200 {
                    return onCompletion(nil)
                } else {
                    onCompletion(ResponseError.responseNotOK)
                }
            }
        }
    }
    
    
}
