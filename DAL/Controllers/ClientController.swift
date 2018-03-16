//
//  ClientController.swift
//  Digital Monitor
//
//  Created by Dan Austin on 23/01/2018.
//  Copyright © 2018 Dan Austin. All rights reserved.
//

import Foundation
import p2_OAuth2

class ClientController {
    let jsonDecoder = JSONDecoder()
    let jsonEncoder = JSONEncoder()
    let oauth2PasswordGrant = DigitalMonitorAPI.sharedInstance.oauth2PasswordGrant
    
    let applicationClientEndpointTemplate = "https://digitalmonitor.tk/api/organisations/%@/applications/%@/clients/"
    
    func getClients(forApplication application: DMApplication, ownedBy organisation: DMOrganisation, onCompletion: @escaping ([DMClient]?, Error?) -> Void){
        guard let appId = application.id else {
            return onCompletion(nil, ApplicationError.QueryError.missingId)
        }
        
        guard let orgId = organisation.id else {
            return onCompletion(nil, OrganisationError.QueryError.missingId)
        }
        
        guard let url = URL(string: String(format: applicationClientEndpointTemplate, orgId, appId)) else {
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
                        
                        if let responseBody = try? self.jsonDecoder.decode(GetClientsResponse.self, from: data){
                            onCompletion(responseBody.data.clients, nil)
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

    func save(client: DMClient, toApplication application: DMApplication, ownedBy organisation: DMOrganisation, onCompletion: @escaping (Error?) -> Void) {
        guard let appId = application.id else {
            return onCompletion(ApplicationError.QueryError.missingId)
        }
        
        guard let orgId = organisation.id else {
            return onCompletion(OrganisationError.QueryError.missingId)
        }
        
        guard let url = URL(string: String(format: applicationClientEndpointTemplate, orgId, appId) + client.id) else {
            return onCompletion(RequestError.urlError)
        }
        
        guard let body = try? jsonEncoder.encode(client) else {
            return onCompletion(RequestError.jsonEncodingError)
        }
        
        var req = oauth2PasswordGrant.request(forURL: url)
        req.httpMethod = "PUT"
        
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
    
    func addClient(name: String, redirectUri: String, applicationId: String, platformId: String, onCompletion: @escaping (DMClient?, Error?) -> Void){
        
        guard let organisation = DMOrganisation.authenticatedOrganisation else {
            return onCompletion(nil, OrganisationError.QueryError.organisationNotFound)
        }
        
        guard let url = URL(string: String(format: applicationClientEndpointTemplate, organisation.id!, applicationId)) else {
            return onCompletion(nil, RequestError.urlError)
        }
    
        let client = AddClientRequest(name: name, redirectUri: redirectUri, applicationId: applicationId, platformId: platformId)
        
        guard let body = try? jsonEncoder.encode(client) else {
            return onCompletion(nil, RequestError.jsonEncodingError)
        }
        
        var req = oauth2PasswordGrant.request(forURL: url)
        
        req.httpMethod = "POST"
        
        req.addValue("application/json", forHTTPHeaderField: "content-type")
        
        req.httpBody = body
        
        let loader = OAuth2DataLoader(oauth2: oauth2PasswordGrant)
        
        loader.perform(request: req) { (oauthResponse) in
            if let error = oauthResponse.error {
                onCompletion(nil, error)
            } else {
                if oauthResponse.response.statusCode == 201 {
                    if let data = oauthResponse.data {
                        
                        if let responseBody = try? self.jsonDecoder.decode(PostClientResponse.self, from: data){
                            onCompletion(responseBody.data.client, nil)
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
    
//    func getSecret(forClient client: DMClient, onCompletion: @escaping (String?, Error?) -> Void) {
//        guard let organisation = DMOrganisation.authenticatedOrganisation else {
//            return onCompletion(nil, OrganisationError.QueryError.organisationNotFound)
//        }
//
//        let appId = client.applicationId
//
//        guard let orgId = organisation.id else {
//            return onCompletion(nil, OrganisationError.QueryError.missingId)
//        }
//
//        guard let url = URL(string: String(format: applicationClientEndpointTemplate, orgId, appId) + client.id) else {
//            return onCompletion(nil, RequestError.urlError)
//        }
//
//        let req = oauth2PasswordGrant.request(forURL: url)
//
//        let loader = OAuth2DataLoader(oauth2: oauth2PasswordGrant)
//
//        loader.perform(request: req) { (oauthResponse) in
//            if let error = oauthResponse.error {
//                onCompletion(nil, error)
//            } else {
//                if oauthResponse.response.statusCode == 200 {
//                    if let data = oauthResponse.data {
//
//                        if let responseBody = try? self.jsonDecoder.decode(GetClientsResponse.self, from: data){
//                            onCompletion(responseBody.data.clients, nil)
//                        } else {
//                            onCompletion(nil, ResponseError.responseDecodeError)
//                        }
//
//                    } else {
//                        onCompletion(nil, ResponseError.noResponseData)
//                    }
//                } else {
//                    onCompletion(nil, ResponseError.responseNotOK)
//                }
//            }
//        }
//    }
}

