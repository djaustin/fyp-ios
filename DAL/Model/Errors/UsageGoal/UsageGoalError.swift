//
//  UsageGoalError.swift
//  Digital Monitor
//
//  Created by Dan Austin on 29/01/2018.
//  Copyright © 2018 Dan Austin. All rights reserved.
//

import Foundation
enum UsageGoalError : Error {
    enum SaveError : Error, CustomStringConvertible {
        case missingId
        public var description: String {
            switch self {
            case .missingId:
                return "Usage goal ID required"
            }
        }
    }
}
