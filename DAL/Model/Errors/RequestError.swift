//
//  RequestError.swift
//  Digital Monitor
//
//  Created by Dan Austin on 12/01/2018.
//  Copyright © 2018 Dan Austin. All rights reserved.
//

import Foundation

/// Errors relating to HTTP requests made to the web API
enum RequestError : Error, CustomStringConvertible {
    
    // Errors
    case jsonEncodingError
    case urlError
    
    /// Text description of errors
    public var description: String {
        switch self {
        case .jsonEncodingError:
            return "Unable to encode request body to JSON"
        case .urlError:
            return "Unable to form URL for request"
        }
    }
}
