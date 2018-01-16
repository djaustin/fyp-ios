//
//  ResponseError.swift
//  Digital Monitor
//
//  Created by Dan Austin on 12/01/2018.
//  Copyright © 2018 Dan Austin. All rights reserved.
//

import Foundation

enum ResponseError : Error {
    case nilResponse
    case responseDecodeError
    case responseNotOK
    case noResponseData
    case errorOnStatusOk
}
