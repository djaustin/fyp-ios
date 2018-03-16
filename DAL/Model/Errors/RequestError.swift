//
//  RequestError.swift
//  Digital Monitor
//
//  Created by Dan Austin on 12/01/2018.
//  Copyright © 2018 Dan Austin. All rights reserved.
//

import Foundation

enum RequestError : Error, CustomStringConvertible {
    case jsonEncodingError
    case urlError
    public var description: String {
        switch self {
        case .jsonEncodingError:
            return "Unable to encode request body to JSON"
        case .urlError:
            return "Unable to form URL for request"
        }
    }
}
