//
//  ApplicationError.swift
//  Digital Monitor
//
//  Created by Dan Austin on 23/01/2018.
//  Copyright © 2018 Dan Austin. All rights reserved.
//

import Foundation

enum ApplicationError : Error {
    enum QueryError : Error {
        case missingId
        case applicationNotFound
    }
}
