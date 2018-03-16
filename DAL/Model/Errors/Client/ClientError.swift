//
//  ClientError.swift
//  Digital Monitor
//
//  Created by Dan Austin on 23/01/2018.
//  Copyright © 2018 Dan Austin. All rights reserved.
//

import Foundation

enum ClientError : Error {
    enum RegistrationError : Error, CustomStringConvertible {
        case missingSecret
        case missingClientId
        public var description: String {
            switch self {
            case .missingSecret:
                return "Client secret required"
            case .missingClientId:
                return "Client ID required"
            }
        }
    }
}
