//
//  DMDeviceToken.swift
//  Digital Monitor
//
//  Created by Dan Austin on 05/02/2018.
//  Copyright © 2018 Dan Austin. All rights reserved.
//

import Foundation

struct DMDeviceToken {
    var value: String
    var userId: String?
    
    init(value: String) {
        self.value = value
        userId = nil
    }
    
    func associate(withUser user: DMUser, onCompletion: @escaping (Error?) -> Void){
        let controller = DeviceTokenController()
        controller.associate(token: value, withUser: user, onCompletion: onCompletion)
    }
}
