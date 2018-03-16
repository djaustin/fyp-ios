//
//  ResponseError.swift
//  Digital Monitor
//
//  Created by Dan Austin on 12/01/2018.
//  Copyright © 2018 Dan Austin. All rights reserved.
//

import Foundation

enum ResponseError : Error, CustomStringConvertible {
    case nilResponse
    case responseDecodeError
    case responseNotOK
    case noResponseData
    case errorOnStatusOk
    public var description: String {
        switch self {
        case .nilResponse:
            return "No response received from the server"
        case .responseDecodeError:
            return "Unable to decode the response from server"
        case .responseNotOK:
            return "Invalid response code from server"
        case .noResponseData:
            return "No data included in response"
        case .errorOnStatusOk:
            return "Error received with OK server response"
        }
    }
}
