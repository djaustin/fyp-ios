//
//  MonitoringExceptionController.swift
//  Digital Monitor
//
//  Created by Dan Austin on 09/03/2018.
//  Copyright © 2018 Dan Austin. All rights reserved.
//

import Foundation
import p2_OAuth2

class MonitoringExceptionController {
    
    let monitoringExceptionsEndpointTemplate = "https://digitalmonitor.tk/api/users/%@/monitoring-exceptions/"
    let oauth2Credentials = DigitalMonitorAPI.sharedInstance.oauth2PasswordGrant
    let jsonDecoder: JSONDecoder = {
        let jsonDecoder = JSONDecoder()
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSSZ"
        jsonDecoder.dateDecodingStrategy = .formatted(formatter)
        return jsonDecoder
    }()
    let jsonEncoder = JSONEncoder()
    
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
