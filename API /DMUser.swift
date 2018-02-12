//
//  DMUser.swift
//  Digital Monitor
//
//  Created by Dan Austin on 13/01/2018.
//  Copyright © 2018 Dan Austin. All rights reserved.
//

import Foundation
import p2_OAuth2

class DMUser : Codable {
    
    var email: String?
    var password: String?
    var firstName: String?
    var lastName: String?
    var id: String?
    var usageGoals: [UsageGoal] = []
    
    private enum CodingKeys: String, CodingKey {
        case email
        case password
        case firstName
        case lastName
        case id = "_id"
        case usageGoals
    }
    
    struct UsageGoal : Codable {
        init(duration: Int, period: String, platform: String?, applicationId: String?) {
            self.duration = duration
            self.period = period
            self.platform = platform
            self.applicationId = applicationId
        }
        
        var id: String?
        var platform: String?
        var applicationId: String?
        var duration: Int
        var period: String
        var progress: Double?
        private enum CodingKeys: String, CodingKey {
            case platform
            case applicationId
            case duration
            case period
            case id = "_id"
            case progress
        }
    }

    
    init(email: String, password: String, firstName: String, lastName: String) {
        self.email = email
        self.password = password
        self.firstName = firstName
        self.lastName = lastName
    }
    
    static var authenticatedUser: DMUser? = nil
    
    private let userController = UserController()
    
    static func login(withEmail email: String, password: String, onCompletion: @escaping (DMUser?, Error?) -> Void){
        let userController = UserController()
        userController.login(withEmail: email, password: password) { (user, error) in
            if let user = user {
                if let tokenValue = UserDefaults.standard.string(forKey: "deviceToken"){
                    let deviceToken = DMDeviceToken(value: tokenValue)
                    deviceToken.associate(withUser: user, onCompletion: { (err) in
                        if let error = error {
                           print(error)
                        }
                    })
                }
            }
            onCompletion(user, error)
        }
        // if login successful, register this user against the device token on the server
    }
    
    func register(onCompletion: @escaping (Bool, Error?) -> Void) {
        userController.register(user: self, onCompletion: onCompletion)
    }
    
    static func getUser(byEmail email: String, onCompletion: @escaping (DMUser?, Error?) -> Void){
        let userController = UserController()
        userController.getUser(byEmail: email, onCompletion: onCompletion)
    }
    
    static func logout(){
        self.authenticatedUser = nil
        DigitalMonitorAPI.sharedInstance.oauth2PasswordGrant.forgetTokens()
    }
    
    static var userIsLoggedIn: Bool {
        get {
            return self.authenticatedUser != nil
        }
    }
    
    func getAuthorisedClients(_ onCompletion: @escaping ([DMClient]?, Error?) -> Void){
        userController.getAuthorisedClients(forUser: self, onCompletion)
    }
    
    
    func revokeAccess(fromClient client: DMClient, onCompletion: @escaping (Bool, Error?) -> Void) {
        userController.revokeAccess(fromClient: client, forUser: self, onCompletion: onCompletion)
    }
    
    func getOverallUsageInSeconds(onCompletion: @escaping (Int?, Error?) -> Void){
        userController.getOverallUsageInSeconds(forUser: self, onCompletion: onCompletion)
    }
    
    func getApplicationsMetrics(onCompletion: @escaping ([ApplicationUsageData]?, Error?) -> Void){
        userController.getApplicationsMetrics(forUser: self, onCompletion: onCompletion)
    }
    
    func getPlatformsMetrics(onCompletion: @escaping ([PlatformUsageData]?, Error?) -> Void){
        userController.getPlatforms(forUser: self, onCompletion: onCompletion)
    }
    
    func getApplicationMetrics(forPlatform platform: String, withQuery query: [String:String], onCompletion: @escaping ([ApplicationUsageData]?, Error?) -> Void){
        userController.getApplicationMetrics(forPlatform: platform, forUser: self, withQuery: query, onCompletion: onCompletion)
    }
    
    func getAggregatedMetrics(onCompletion: @escaping (AggregatedMetricsResponseData?, Error?) -> Void){
        userController.getAggregatedMetrics(forUser: self, onCompletion: onCompletion)
    }
    
    func getAggregatedMetrics(withQuery query: [String: String], onCompletion: @escaping (AggregatedMetricsResponseData?, Error?) -> Void){
        userController.getAggregatedMetrics(forUser: self, withQuery: query, onCompletion: onCompletion)
    }
    
    func getUsageGoalProgress(onCompletion: @escaping ([UsageGoal]?, Error?) -> Void){
        userController.getUsageGoalProgress(forUser: self, onCompletion: onCompletion)
    }
    
    func getAuthorisedApplications(onCompletion: @escaping ([DMApplication]?, Error?) -> Void ){
        userController.getAuthorisedApplications(forUser: self, onCompletion: onCompletion)
    }
    
    func add(usageGoal goal: UsageGoal, onCompletion: @escaping (UsageGoal?, Error?) -> Void){
        userController.add(usageGoal: goal, toUser: self, onCompletion: { (goal, error) in
            if let goal = goal {
                self.usageGoals.append(goal)
            }
            onCompletion(goal, error)
        })
    }
    
    func updateLocalGoal(_ goal: UsageGoal){
        if let index = self.usageGoals.index(where: { (element) -> Bool in element.id == goal.id }) {
            usageGoals.remove(at: index)
            usageGoals.insert(goal, at: index)
        }
    }
    
    func saveGoal(_ goal: UsageGoal, onCompletion: @escaping (Error?) -> Void){
        userController.save(usageGoal: goal, toUser: self, onCompletion: { error in
            if error != nil {
                self.updateLocalGoal(goal)
            }
            onCompletion(error)
        })
        
    }
}
