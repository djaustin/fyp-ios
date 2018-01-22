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
    
    
    func register(onCompletion: @escaping (Bool?, Error?) -> Void){
        organisationController.register(organisation: self, onCompletion: onCompletion)
    }
    
    static func login(withEmail email: String, password: String, onCompletion: @escaping (DMOrganisation?, Error?) -> Void){
        let organisationController = OrganisationController()
        
        organisationController.login(email: email, password: password, onCompletion: onCompletion)
    }
    
}

