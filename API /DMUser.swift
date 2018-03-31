//
//  DMUser.swift
//  Digital Monitor
//
//  Created by Dan Austin on 13/01/2018.
//  Copyright © 2018 Dan Austin. All rights reserved.
//

import Foundation
import p2_OAuth2


/// Represents a user from the Digital Monitor API
class DMUser : Codable {
    
    // Member variables
    var email: String?
    var password: String?
    var firstName: String?
    var lastName: String?
    var id: String?
    var usageGoals: [UsageGoal] = []
    
    // Coding keys for conversion between object and JSON
    private enum CodingKeys: String, CodingKey {
        case email
        case password
        case firstName
        case lastName
        case id = "_id"
        case usageGoals
    }
    
    
    /// Represents a user's usage goal from the Digital Monitor API
    struct UsageGoal : Codable {
        
        /// Create a new usage goal
        ///
        /// - Parameters:
        ///   - duration: goal duration in seconds
        ///   - period: period over which to track the goal
        ///   - platform: platform on which the goal is applied. Leave as nil for all platforms
        ///   - application: application on which the goal is applied. Leave as nil for all applications
        init(duration: Int, period: DMPeriod, platform: DMPlatform?, application: DMApplication?) {
            self.duration = duration
            self.period = period
            self.platform = platform
            self.application = application
        }
        
        // Member variables
        var id: String?
        var platform: DMPlatform?
        var application: DMApplication?
        var duration: Int
        var period: DMPeriod
        var progress: Double?
        
        // Coding keys for conversion between object and JSON
        private enum CodingKeys: String, CodingKey {
            case platform
            case application
            case duration
            case period
            case id = "_id"
            case progress
        }
    }

    
    /// Create a new user
    ///
    /// - Parameters:
    ///   - email: User email address used for authentication
    ///   - password: User password used for authentication
    ///   - firstName: User first name
    ///   - lastName: User last name
    init(email: String, password: String, firstName: String, lastName: String) {
        self.email = email
        self.password = password
        self.firstName = firstName
        self.lastName = lastName
    }
    
    
    /// Class variable to hold currently authenticated user
    static var authenticatedUser: DMUser? = nil
    
    
    /// User controller to interact with the web API
    private let userController = UserController()
    
    
    /// Log user in. Retrieve the access token and assign the user object to the currently authenticated user.
    ///
    /// - Parameters:
    ///   - email: User email used for authentication
    ///   - password: User password used for authentication
    ///   - onCompletion: Callback function to be called on completion of login
    static func login(withEmail email: String, password: String, onCompletion: @escaping (DMUser?, Error?) -> Void){
        let userController = UserController()
        // Login with web service
        userController.login(withEmail: email, password: password) { (user, error) in
            if let user = user {
                // if login successful, register this user against the device token on the server
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
    }
    
    
    /// Register a new user with the web service
    ///
    /// - Parameter onCompletion: Callback function to be called on completion
    func register(onCompletion: @escaping (Bool, Error?) -> Void) {
        userController.register(user: self, onCompletion: onCompletion)
    }
    
    /// Get a user by their email address
    ///
    /// - Parameters:
    ///   - email: Email address to search for
    ///   - onCompletion: Callback function to be called on search completion
    static func getUser(byEmail email: String, onCompletion: @escaping (DMUser?, Error?) -> Void){
        let userController = UserController()
        userController.getUser(byEmail: email, onCompletion: onCompletion)
    }
    
    /// Log out the currently authenticated user
    static func logout(){
        // Remove the authenticated user from the class variablw
        self.authenticatedUser = nil
        // Remove existing password grant
        DigitalMonitorAPI.sharedInstance.oauth2PasswordGrant.forgetTokens()
    }
    
    
    /// Returns whether a user is currently logged in or not
    static var userIsLoggedIn: Bool {
        get {
            return self.authenticatedUser != nil
        }
    }
    
    
    /// Get all authorised clients for the currently authenticated
    ///
    /// - Parameter onCompletion: Callback function to be called on completion
    func getAuthorisedClients(_ onCompletion: @escaping ([DMClient]?, Error?) -> Void){
        userController.getAuthorisedClients(forUser: self, onCompletion)
    }
    
    
    /// Revoke access to the user's account from an API client
    ///
    /// - Parameters:
    ///   - client: API client from which to revoke access
    ///   - onCompletion: Callback function to be called on completion
    func revokeAccess(fromClient client: DMClient, onCompletion: @escaping (Bool, Error?) -> Void) {
        userController.revokeAccess(fromClient: client, forUser: self, onCompletion: onCompletion)
    }
    
    /// Get user's overall usage in seconds
    ///
    /// - Parameter onCompletion: Callback function to be called on completion
    func getOverallUsageInSeconds(onCompletion: @escaping (Int?, Error?) -> Void){
        userController.getOverallUsageInSeconds(forUser: self, onCompletion: onCompletion)
    }
    
    /// Get user's application metrics across all platforms
    ///
    /// - Parameter onCompletion: Callback function to be called on completion
    func getApplicationsMetrics(onCompletion: @escaping ([ApplicationUsageData]?, Error?) -> Void){
        userController.getApplicationsMetrics(forUser: self, onCompletion: onCompletion)
    }
    
    /// Get user's platform metrics across all applications
    ///
    /// - Parameter onCompletion: Callback funcion to be called on completion
    func getPlatformsMetrics(onCompletion: @escaping ([PlatformUsageData]?, Error?) -> Void){
        userController.getPlatforms(forUser: self, onCompletion: onCompletion)
    }
    
    /// Get user's application metrics for a specific platform
    ///
    /// - Parameters:
    ///   - platform: platform for which to get application metrics
    ///   - query: query specifying from and to time for metrics. If empty, it searches across all time
    ///   - onCompletion: callback function to be called on completion
    func getApplicationMetrics(forPlatform platform: DMPlatform, withQuery query: [String:String], onCompletion: @escaping ([ApplicationUsageData]?, Error?) -> Void){
        userController.getApplicationMetrics(forPlatform: platform, forUser: self, withQuery: query, onCompletion: onCompletion)
    }
    
    /// Get user's platform metrics for a specific application
    ///
    /// - Parameters:
    ///   - application: application for which to get platform metrics
    ///   - query: query specifying from and to time for metrics. If empty, it searches across all time
    ///   - onCompletion: callback function to be called on completion
    func getPlatformMetrics(forApplication application: DMApplication, withQuery query: [String:String], onCompletion: @escaping([PlatformUsageData]?, Error?) -> Void){
        userController.getPlatformMetrics(forApplication: application, forUser: self, withQuery: query, onCompletion: onCompletion)
    }
    
    /// Get user's aggregated metrics. This includes overall, application, and platform metrics
    ///
    /// - Parameter onCompletion: Callback function to be called on completion
    func getAggregatedMetrics(onCompletion: @escaping (AggregatedMetricsResponseData?, Error?) -> Void){
        userController.getAggregatedMetrics(forUser: self, onCompletion: onCompletion)
    }
    
    
    /// Get user's aggregated metrics. This includes overall, application, and platform metrics
    ///
    /// - Parameters:
    ///   - query: query specifying from and to time for metrics. If empty, it searches across all time
    ///   - onCompletion: Callback function to be called on completion
    func getAggregatedMetrics(withQuery query: [String: String], onCompletion: @escaping (AggregatedMetricsResponseData?, Error?) -> Void){
        userController.getAggregatedMetrics(forUser: self, withQuery: query, onCompletion: onCompletion)
    }
    
    /// Get user usage goal progress for all of their goals
    ///
    /// - Parameter onCompletion: Callback function to be called on completion
    func getUsageGoalProgress(onCompletion: @escaping ([UsageGoal]?, Error?) -> Void){
        userController.getUsageGoalProgress(forUser: self, onCompletion: onCompletion)
    }
    
    /// Get applications that the user has authorised to send monitoring data
    ///
    /// - Parameter onCompletion: Callback function to be called on completion
    func getAuthorisedApplications(onCompletion: @escaping ([DMApplication]?, Error?) -> Void ){
        userController.getAuthorisedApplications(forUser: self, onCompletion: onCompletion)
    }
    
    /// Add a new usage goal to the user
    ///
    /// - Parameters:
    ///   - goal: Usage goal to be added to the user
    ///   - onCompletion: Callback function to be called on completion
    func add(usageGoal goal: UsageGoal, onCompletion: @escaping (UsageGoal?, Error?) -> Void){
        userController.add(usageGoal: goal, toUser: self, onCompletion: { (goal, error) in
            if let goal = goal {
                self.usageGoals.append(goal)
            }
            onCompletion(goal, error)
        })
    }
    
    /// Change the local representation of a usage goal when the goal is changed. This avoids having to fetch the entire user every time a goal is changed
    ///
    /// - Parameter goal: <#goal description#>
    func updateLocalGoal(_ goal: UsageGoal){
        if let index = self.usageGoals.index(where: { (element) -> Bool in element.id == goal.id }) {
            usageGoals.remove(at: index)
            usageGoals.insert(goal, at: index)
        }
    }
    
    /// Save a user's usage goal
    ///
    /// - Parameters:
    ///   - goal: Usage goal to be saved
    ///   - onCompletion: Callback function to be called on completion
    func saveGoal(_ goal: UsageGoal, onCompletion: @escaping (Error?) -> Void){
        userController.save(usageGoal: goal, toUser: self, onCompletion: { error in
            if error != nil {
                // If API save successful, change the goal locally as well
                self.updateLocalGoal(goal)
            }
            onCompletion(error)
        })
    }
    
    /// Delete a usage goal from a user
    ///
    /// - Parameters:
    ///   - goal: Goal to be deleted
    ///   - onCompletion: Callback function to be called on completion
    func deleteGoal(_ goal: UsageGoal, onCompletion: @escaping (Error?) -> Void){
        userController.delete(usageGoal: goal, fromUser: self) { (error) in
            if error != nil {
                if let index = self.usageGoals.index(where: { (element) -> Bool in
                    element.id == goal.id
                }){
                    self.usageGoals.remove(at: index)
                }
            }
            onCompletion(error)
        }
    }
    
    /// Save the user object to the web API
    ///
    /// - Parameter onCompletion: Callback function to be called on completion
    func save(onCompletion: @escaping (Error?) -> Void) {
        userController.save(user: self) { (error) in
            if error == nil {
                // Set the user as the currently authenticated user
                DMUser.authenticatedUser = self
            }
            onCompletion(error)
        }
    }
    
    /// Delete the user
    ///
    /// - Parameter onCompletion: Callback function to be called on completion
    func delete(onCompletion: @escaping (Error?) -> Void){
        userController.delete(user: self, onCompletion: onCompletion)
    }
    
    /// Change the user's password
    ///
    /// - Parameters:
    ///   - password: new password to be saved
    ///   - onCompletion: callback function to be called on completion
    func save(password: String, onCompletion: @escaping (Error?) -> Void){
        userController.save(password: password, forUser: self, onCompletion: onCompletion)
    }
    
    /// Get all user's monitoring exceptions
    ///
    /// - Parameter onCompletion: callback function to be called on completion
    func getMonitoringExceptions(_ onCompletion: @escaping ([DMMonitoringException]?, Error?) -> Void){
        let controller = MonitoringExceptionController()
        controller.getMonitoringExceptions(forUser: self, onCompletion: onCompletion)
    }
}
