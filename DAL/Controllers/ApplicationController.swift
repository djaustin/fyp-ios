//
//  ApplicationController.swift
//  Digital Monitor
//
//  Created by Dan Austin on 23/01/2018.
//  Copyright © 2018 Dan Austin. All rights reserved.
//

import Foundation
import p2_OAuth2

/// Controller to interact with the web API for application related endpoints
class ApplicationController{
    
    // Endpoint URLS and templates
    let organisationApplicationsEndpointTemplate = "https://digitalmonitor.tk/api/organisations/%@/applications"
    let applicationPlatformMetricsByIdTemplate = "https://digitalmonitor.tk/api/users/%@/applications"
    let applicationsEndpoint = URL(string: "https://digitalmonitor.tk/api/applications/")!
    let applicationsByIdEndpointTemplate =  "https://digitalmonitor.tk/api/applications/%@"
    
    // Manager for OAuth 2 access tokens
    let oauth2PasswordGrant = DigitalMonitorAPI.sharedInstance.oauth2PasswordGrant
    

    
    /// Construct, send, and parse a request and response organisation applications from the web API
    ///
    /// - Parameters:
    ///   - organisation: organisation for which to get the applications
    ///   - onCompletion: callback function to be called on completion
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
    
    /// Construct, send, and parse a request and response for adding a new application to an organisation from the web API
    ///
    /// - Parameters:
    ///   - name: name of application to be added to the organisation
    ///   - organisation: organisation to which to add the application
    ///   - onCompletion: callback function to be called on completion
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
    
    /// Construct, send, and parse a request and response for application by ID query from the web API
    ///
    /// - Parameters:
    ///   - id: ID of application to search for
    ///   - onCompletion: callback function to be called on completion
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
                        if let responseBody = try? jsonDecoder.decode(GetApplicationResponse.self, from: data){
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
    
    /// Construct, send, and parse a request and response for deleting an organisation application from the web API
    ///
    /// - Parameters:
    ///   - application: application to be deleted
    ///   - onCompletion: callback function to be called on completion
    func delete(application: DMApplication, onCompletion: @escaping (Error?) -> Void) {
        guard let orgId = DMOrganisation.authenticatedOrganisation?.id else {
            return onCompletion(OrganisationError.QueryError.missingId)
        }
        guard let appId = application.id else {
            return onCompletion(ApplicationError.QueryError.missingId)
        }
        guard let url = URL(string: String(format: organisationApplicationsEndpointTemplate, orgId) + "/" + appId) else {
            return onCompletion(RequestError.urlError)
        }
        var req = oauth2PasswordGrant.request(forURL: url)
        req.httpMethod = "DELETE"
        let loader = OAuth2DataLoader(oauth2: oauth2PasswordGrant)
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
