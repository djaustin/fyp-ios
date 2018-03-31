//
//  Organisation.swift
//  Digital Monitor
//
//  Created by Dan Austin on 11/01/2018.
//  Copyright © 2018 Dan Austin. All rights reserved.
//

import Foundation


/// Represents an organisation from the Digital Monitor API
class DMOrganisation : Codable {
    
    // Member variables
    var name: String
    var email: String
    var password: String?
    var id: String?
    var applicationIds: [String]
    
    
    /// Coding keys used to convert between object and JSON
    enum CodingKeys: String, CodingKey {
        case name
        case email
        case password
        case applicationIds
        case id = "_id"
    }
    
    
    /// Create a new organisation object
    ///
    /// - Parameters:
    ///   - name: The name of the organisation
    ///   - email: The email of the organisation used as a username
    ///   - password: The password used for authentication
    init(name: String, email: String, password: String) {
        self.name = name
        self.email = email
        self.password = password
        // Initialise with no registered applications
        self.applicationIds = []
    }
    
    
    /// Class variable to contain the instance of the currently authenticated organisation
    static var authenticatedOrganisation: DMOrganisation? = nil
    
    // Controllers used to communicate with the Digital Monitor API
    private let organisationController = OrganisationController()
    private let applicationController = ApplicationController()
    private let clientController = ClientController()
    
    
    /// Register a new organisation with the web service
    ///
    /// - Parameter onCompletion: Callback function to be run on completion
    func register(onCompletion: @escaping (Bool?, Error?) -> Void){
        organisationController.register(organisation: self, onCompletion: onCompletion)
    }
    
    /// Attempt to log the organisation in using the email and password provided
    ///
    /// - Parameters:
    ///   - email: Organisation email used to authenticate the organisation
    ///   - password: Organisation password used to authenticate the organisation
    ///   - onCompletion: Callback function to be run on server response
    static func login(withEmail email: String, password: String, onCompletion: @escaping (DMOrganisation?, Error?) -> Void){
        let organisationController = OrganisationController()
        
        organisationController.login(email: email, password: password, onCompletion: onCompletion)
    }
    
    
    /// Retrieve the applications owned by this organisation from the web service
    ///
    /// - Parameter onCompletion: Callback function to be run on completion
    func getApplications(onCompletion: @escaping ([DMApplication]?, Error?) -> Void){
        applicationController.getApplications(forOrganisation: self, onCompletion: onCompletion)
    }
    
    
    /// Log the current organisation out
    static func logout() {
        // Remove the current authenticated organisation
        self.authenticatedOrganisation = nil
        // Remove password based access tokens
        DigitalMonitorAPI.sharedInstance.oauth2PasswordGrant.forgetTokens()
    }
    
    
    /// Add a new application to the organisation
    ///
    /// - Parameters:
    ///   - name: Name of the application to be added
    ///   - onCompletion: Callback function to be run on completion
    func addApplication(withName name: String, onCompletion: @escaping (DMApplication?, Error?) -> Void){
        applicationController.addApplication(withName: name, toOrganisation: self, onCompletion: onCompletion)
    }
    
    /// Get all clients owned by the provided application
    ///
    /// - Parameters:
    ///   - application: The application for which to fetch clients
    ///   - onCompletion: Callback function to be run on completion
    func getClients(forApplication application: DMApplication, onCompletion: @escaping ([DMClient]?, Error?) -> Void ){
        clientController.getClients(forApplication: application, ownedBy: self, onCompletion: onCompletion)
    }
    
}

