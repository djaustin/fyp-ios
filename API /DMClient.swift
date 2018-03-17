//
//  Client.swift
//  Digital Monitor
//
//  Created by Dan Austin on 11/01/2018.
//  Copyright © 2018 Dan Austin. All rights reserved.
//

import Foundation

class DMClient : Codable {
    let id: String
    var name: String
    var redirectUri: String
    let secret: String?
    let clientId: String?
    var applicationId: String
    var isThirdParty: Bool
    var platform: String
    
    private let clientController = ClientController()
    
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
    
    func save(toApplication application: DMApplication, onCompletion: @escaping (Error?) -> Void){
        guard let organisation = DMOrganisation.authenticatedOrganisation else {
            return onCompletion(OrganisationError.QueryError.organisationNotFound)
        }
        clientController.save(client: self, toApplication: application, ownedBy: organisation, onCompletion: onCompletion)
    }
    
    func delete(onCompletion: @escaping (Error?) -> Void){
        clientController.delete(client: self, onCompletion: onCompletion)
    }
    
    static func addClient(name: String, redirectUri: String, applicationId: String, platformId: String, onCompletion: @escaping (DMClient?, Error?) -> Void) {
        let clientController = ClientController()
        clientController.addClient(name: name, redirectUri: redirectUri, applicationId: applicationId, platformId: platformId, onCompletion: onCompletion)
    }
//
//    func getSecret(onCompletion: @escaping (String?, Error?) -> Void) {
//        clientController.getSecret(forClient: self, onCompletion: onCompletion)
//    }

}
