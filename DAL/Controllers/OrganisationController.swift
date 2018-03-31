//
//  OrganisationController.swift
//  Digital Monitor
//
//  Created by Dan Austin on 22/01/2018.
//  Copyright © 2018 Dan Austin. All rights reserved.
//

import Foundation
import p2_OAuth2

/// Controller to interact with the web API for organisation related calls
class OrganisationController{
    // Organisation resource endpoint URL
    let organisationsEndpoint = URL(string: "https://digitalmonitor.tk/api/organisations")!
    
    // Objects to manage OAuth 2 access tokens
    let oauth2ClientCredentials = DigitalMonitorAPI.sharedInstance.oauth2ClientCredentials
    let oauth2PasswordGrant = DigitalMonitorAPI.sharedInstance.oauth2PasswordGrant
    
    
    /// Construct, send, and parse a request and response for organisation registration from the web API
    ///
    /// - Parameters:
    ///   - organisation: organisation to register
    ///   - onCompletion: callback function to be called on completion
    func register(organisation: DMOrganisation, onCompletion: @escaping (Bool?, Error?) -> Void){
        let jsonEncoder = JSONEncoder()
        let jsonDecoder = JSONDecoder()
        
        guard let password = organisation.password else {
            return onCompletion(false, OrganisationError.RegistrationError.missingPassword)
        }
       
        
        let requestBody = OrganisationRegistrationRequestBody(name: organisation.name, email: organisation.email, password: password)
        var req = oauth2ClientCredentials.request(forURL: organisationsEndpoint)
        
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
                        do {
                            let responseBody = try jsonDecoder.decode(PostOrganisationResponse.self, from: data)
                            organisation.id = responseBody.data.organisation.id
                            onCompletion(true, nil)
                        } catch {
                            print(error)
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
    
    /// Construct, send, and parse a request and response for an organisation email query from the web API
    ///
    /// - Parameters:
    ///   - email: email to search for
    ///   - onCompletion: callback function on completion
    func getOrganisation(byEmail email: String, onCompletion: @escaping (DMOrganisation?, Error?) -> Void){
        let jsonDecoder = JSONDecoder()
        var urlComponents = URLComponents(url: organisationsEndpoint, resolvingAgainstBaseURL: false)!
        urlComponents.queryItems = [URLQueryItem(name: "email", value: email)]
        let req = oauth2PasswordGrant.request(forURL: urlComponents.url!)
        let loader = OAuth2DataLoader(oauth2: oauth2PasswordGrant)
        
        loader.perform(request: req) { (oauthResponse) in
            if let error = oauthResponse.error {
                onCompletion(nil, error)
            } else {
                if oauthResponse.response.statusCode == 200 {
                    if let data = oauthResponse.data {
                        if let responseBody = try? jsonDecoder.decode(GetOrganisationsResponse.self, from: data){
                            let organisations = responseBody.data.organisations
                            if organisations.count < 1 {
                                onCompletion(nil, OrganisationError.QueryError.organisationNotFound)
                            } else {
                                onCompletion(organisations[0], nil)
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
    
    /// Construct, send, and parse a request and response for organisation login using the OAuth 2 from the web API
    ///
    /// - Parameters:
    ///   - email: organisation email used for authentication
    ///   - password: organisation password used for
    ///   - onCompletion: callback function to be called on completion
    func login(email: String, password: String, onCompletion: @escaping (DMOrganisation?, Error?) -> Void) {
        oauth2PasswordGrant.forgetTokens()
        oauth2PasswordGrant.username = email
        oauth2PasswordGrant.password = password
        
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
                self.getOrganisation(byEmail: email) { (organisation, error) in
                    print("finished trying to get organisation")
                    if let error = error {
                        onCompletion(nil, error)
                    } else {
                        if let organisation = organisation {
                            DMOrganisation.authenticatedOrganisation = organisation
                            onCompletion(organisation, nil)
                        }
                    }
                }
            }
        }
    }

    
}
