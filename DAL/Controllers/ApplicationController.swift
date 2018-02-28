//
//  ApplicationController.swift
//  Digital Monitor
//
//  Created by Dan Austin on 23/01/2018.
//  Copyright © 2018 Dan Austin. All rights reserved.
//

import Foundation
import p2_OAuth2

class ApplicationController{
    let organisationApplicationsEndpointTemplate = "https://digitalmonitor.tk/api/organisations/%@/applications"
    let applicationPlatformMetricsByIdTemplate = "https://digitalmonitor.tk/api/users/%@/applications"
    let applicationsEndpoint = URL(string: "https://digitalmonitor.tk/api/applications/")!
    let applicationsByIdEndpointTemplate =  "https://digitalmonitor.tk/api/applications/%@"
    let oauth2PasswordGrant = DigitalMonitorAPI.sharedInstance.oauth2PasswordGrant
    

    
    func getApplications(forOrganisation organisation: DMOrganisation, onCompletion: @escaping ([DMApplication]?, Error?) -> Void){
        
        guard let organisationId = organisation.id else {
            return onCompletion(nil, OrganisationError.QueryError.missingId)
        }
        
        let jsonDecoder = JSONDecoder()
        guard let url = URL(string: String(format: organisationApplicationsEndpointTemplate, organisationId)) else {
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
                        if let responseBody = try? jsonDecoder.decode(GetApplicationsResponse.self, from: data){
                            let applications = responseBody.data.applications
                            return onCompletion(applications, nil)
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
    
    func addApplication(withName name: String, toOrganisation organisation: DMOrganisation, onCompletion: @escaping (DMApplication?, Error?) -> Void){
        let jsonEncoder = JSONEncoder()
        let jsonDecoder = JSONDecoder()
        
        guard let organisationId = organisation.id else {
            return onCompletion(nil, OrganisationError.QueryError.missingId)
        }
        
        guard let url = URL(string: String(format: organisationApplicationsEndpointTemplate, organisationId)) else {
            return onCompletion(nil, RequestError.urlError)
        }

        
        let requestBody = AddApplicationRequest(name: name)
        var req = oauth2PasswordGrant.request(forURL: url)
        
        req.httpMethod = "POST"
        guard let requestBodyJSON = try? jsonEncoder.encode(requestBody) else {
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
                        
                        if let responseBody = try? jsonDecoder.decode(PostApplicationResponse.self, from: data){
                            onCompletion(responseBody.data.application, nil)
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
    
    func getApplication(byId id: String, onCompletion: @escaping (DMApplication?, Error?) -> Void) {
        let jsonDecoder = JSONDecoder()
        guard let url = URL(string: String(format: applicationsByIdEndpointTemplate, id)) else {
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
                        if let responseBody = try? jsonDecoder.decode(GetApplicationsResponse.self, from: data){
                            let applications = responseBody.data.applications
                            if applications.count < 1 {
                                onCompletion(nil, ApplicationError.QueryError.applicationNotFound)
                            } else {
                                onCompletion(applications[0], nil)
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
    
    
}
