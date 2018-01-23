//
//  Organisation.swift
//  Digital Monitor
//
//  Created by Dan Austin on 11/01/2018.
//  Copyright © 2018 Dan Austin. All rights reserved.
//

import Foundation

class DMOrganisation : Codable {
    var name: String
    var email: String
    var password: String?
    var id: String?
    var applicationIds: [String]
    
    enum CodingKeys: String, CodingKey {
        case name
        case email
        case password
        case applicationIds
        case id = "_id"
    }
    
    init(name: String, email: String, password: String) {
        self.name = name
        self.email = email
        self.password = password
        self.applicationIds = []
    }
    
    static var authenticatedOrganisation: DMOrganisation? = nil
    private let organisationController = OrganisationController()
    private let applicationController = ApplicationController()
    private let clientController = ClientController()
    
    
    func register(onCompletion: @escaping (Bool?, Error?) -> Void){
        organisationController.register(organisation: self, onCompletion: onCompletion)
    }
    
    static func login(withEmail email: String, password: String, onCompletion: @escaping (DMOrganisation?, Error?) -> Void){
        let organisationController = OrganisationController()
        
        organisationController.login(email: email, password: password, onCompletion: onCompletion)
    }
    
    func getApplications(onCompletion: @escaping ([DMApplication]?, Error?) -> Void){
        applicationController.getApplications(forOrganisation: self, onCompletion: onCompletion)
    }
    
    static func logout() {
        self.authenticatedOrganisation = nil
        DigitalMonitorAPI.sharedInstance.oauth2PasswordGrant.forgetTokens()
    }
    
    func addApplication(withName name: String, onCompletion: @escaping (DMApplication?, Error?) -> Void){
        applicationController.addApplication(withName: name, toOrganisation: self, onCompletion: onCompletion)
        
    }
    
    func getClients(forApplication application: DMApplication, onCompletion: @escaping ([DMClient]?, Error?) -> Void ){
        clientController.getClients(forApplication: application, ownedBy: self, onCompletion: onCompletion)
    }
    
}

