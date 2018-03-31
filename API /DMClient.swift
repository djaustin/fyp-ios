//
//  Client.swift
//  Digital Monitor
//
//  Created by Dan Austin on 11/01/2018.
//  Copyright © 2018 Dan Austin. All rights reserved.
//

import Foundation

/// Represents a client from the Digital Monitor API
class DMClient : Codable {
    
    // Member variables
    let id: String
    var name: String
    var redirectUri: String
    let secret: String?
    let clientId: String?
    var applicationId: String
    var isThirdParty: Bool
    var platform: String
    
    private let clientController = ClientController()
    
    
    /// Create a new client object
    ///
    /// - Parameters:
    ///   - id: Document ID of the client object
    ///   - name: Client name
    ///   - redirectUri: Redirect URI used for OAuth 2 flows
    ///   - secret: Client secret used to authenticate the client with OAuth 2 flows
    ///   - clientId: Client ID used to authenticate the client with OAuth 2 flows
    ///   - applicationId: ID of the application that owns this client
    ///   - isThirdParty: Whether it is a third party client or a Digital Monitor client
    ///   - platform: The ID of the platform on which this client is registered
    init(id: String, name: String, redirectUri: String, secret: String, clientId: String, applicationId: String, isThirdParty: Bool, platform: String) {
        self.id = id
        self.name = name
        self.redirectUri = redirectUri
        self.secret = secret
        self.clientId = clientId
        self.applicationId = applicationId
        self.isThirdParty = isThirdParty
        self.platform = platform
    }
    
    
    /// Coding keys used to convert between object and JSON
    enum CodingKeys: String, CodingKey {
        case name
        case redirectUri
        case secret
        case clientId = "id"
        case applicationId
        case id = "_id"
        case isThirdParty
        case platform
    }
    
    
    /// Save the client to the web service under the specified application
    ///
    /// - Parameters:
    ///   - application: The application that owns this client
    ///   - onCompletion: Callback function to be run on completion of save
    func save(toApplication application: DMApplication, onCompletion: @escaping (Error?) -> Void){
        // Return error if no organisation is currently logged in
        guard let organisation = DMOrganisation.authenticatedOrganisation else {
            return onCompletion(OrganisationError.QueryError.organisationNotFound)
        }
        // Save the client to the web service
        clientController.save(client: self, toApplication: application, ownedBy: organisation, onCompletion: onCompletion)
    }
    
    
    /// Delete a client from the web service
    ///
    /// - Parameter onCompletion: Function to be run on completion of deletion
    func delete(onCompletion: @escaping (Error?) -> Void){
        clientController.delete(client: self, onCompletion: onCompletion)
    }
    
    
    /// Add a new client to the web service
    ///
    /// - Parameters:
    ///   - name: The client name
    ///   - redirectUri: The redirect URI used for OAuth 2 flows
    ///   - applicationId: ID of the application that owns this client
    ///   - platformId: ID of the platform on which this client is registered
    ///   - onCompletion: Function to be run on completion of the save
    static func addClient(name: String, redirectUri: String, applicationId: String, platformId: String, onCompletion: @escaping (DMClient?, Error?) -> Void) {
        let clientController = ClientController()
        clientController.addClient(name: name, redirectUri: redirectUri, applicationId: applicationId, platformId: platformId, onCompletion: onCompletion)
    }


}
