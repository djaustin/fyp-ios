//
//  DMDeviceToken.swift
//  Digital Monitor
//
//  Created by Dan Austin on 05/02/2018.
//  Copyright © 2018 Dan Austin. All rights reserved.
//

import Foundation

/// Represents a device token in the Digital Monitor API
struct DMDeviceToken {
    
    // Member variables
    var value: String
    var userId: String?
    
    /// Create a new device token
    ///
    /// - Parameter value: device token value
    init(value: String) {
        self.value = value
        userId = nil
    }
    
    
    /// Associate this device token with a user on the web service
    ///
    /// - Parameters:
    ///   - user: user to associate with the token
    ///   - onCompletion: callback function to be called on completion
    func associate(withUser user: DMUser, onCompletion: @escaping (Error?) -> Void){
        let controller = DeviceTokenController()
        controller.associate(token: value, withUser: user, onCompletion: onCompletion)
    }
}
