//
//  ApplicationController.swift
//  Digital Monitor
//
//  Created by Dan Austin on 23/01/2018.
//  Copyright © 2018 Dan Austin. All rights reserved.
//

import Foundation
import OAuth2

class ApplicationController{
    let organisationApplicationsEndpoint = "https://digitalmonitor.tk/api/organisations/%@/applications"
    let oauth2PasswordGrant = DigitalMonitorAPI.sharedInstance.oauth2PasswordGrant
    
//    func register(organisation: DMOrganisation, onCompletion: @escaping (Bool?, Error?) -> Void){
//        let jsonEncoder = JSONEncoder()
//        let jsonDecoder = JSONDecoder()
//
//        guard let password = organisation.password else {
//            return onCompletion(false, OrganisationError.RegistrationError.missingPassword)
//        }
//
//
//        let requestBody = OrganisationRegistrationRequestBody(name: organisation.name, email: organisation.email, password: password)
//        var req = oauth2ClientCredentials.request(forURL: organisationsEndpoint)
//
//        req.httpMethod = "POST"
//        guard let requestBodyJSON = try? jsonEncoder.encode(requestBody) else {
//            return onCompletion(false, RequestError.jsonEncodingError)
//        }
//
//        req.setValue("application/json", forHTTPHeaderField: "content-type")
//        req.httpBody = requestBodyJSON
//
//        let loader = OAuth2DataLoader(oauth2: oauth2ClientCredentials)
//
//        loader.perform(request: req) { (oauthResponse) in
//            if let error = oauthResponse.error {
//                onCompletion(false, error)
//            } else {
//                if oauthResponse.response.statusCode == 201 {
//                    if let data = oauthResponse.data {
//                        do {
//                            let responseBody = try jsonDecoder.decode(PostOrganisationResponse.self, from: data)
//                            organisation.id = responseBody.data.organisation.id
//                            onCompletion(true, nil)
//                        } catch {
//                            print(error)
//                            onCompletion(false, ResponseError.responseDecodeError)
//                        }
//                    } else {
//                        onCompletion(false, ResponseError.noResponseData)
//                    }
//                } else {
//                    onCompletion(false, ResponseError.responseNotOK)
//                }
//            }
//        }
//    }
    
    func getApplications(forOrganisation organisation: DMOrganisation, onCompletion: @escaping ([DMApplication]?, Error?) -> Void){
        
        guard let organisationId = organisation.id else {
            return onCompletion(nil, OrganisationError.QueryError.missingId)
        }
        
        let jsonDecoder = JSONDecoder()
        guard let url = URL(string: String(format: organisationApplicationsEndpoint, organisationId)) else {
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
        
        guard let url = URL(string: String(format: organisationApplicationsEndpoint, organisationId)) else {
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
    
//    func login(email: String, password: String, onCompletion: @escaping (DMOrganisation?, Error?) -> Void) {
//        oauth2PasswordGrant.forgetTokens()
//        oauth2PasswordGrant.username = email
//        oauth2PasswordGrant.password = password
//
//        oauth2PasswordGrant.authorize { (json, error) in
//            print("completion")
//            if let error = error {
//                print("error found")
//                onCompletion(nil, error)
//            } else {
//                print("no error found")
//                // If successful, lookup the user details for the provided email to get a user object
//                // Assign user object to authenticatedUser property
//                print("About to get user")
//                self.getOrganisation(byEmail: email) { (organisation, error) in
//                    print("finished trying to get organisation")
//                    if let error = error {
//                        onCompletion(nil, error)
//                    } else {
//                        if let organisation = organisation {
//                            DMOrganisation.authenticatedOrganisation = organisation
//                            onCompletion(organisation, nil)
//                        }
//                    }
//                }
//            }
//        }
//    }
    
}
