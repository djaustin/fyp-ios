//
//  DMPeriod.swift
//  Digital Monitor
//
//  Created by Dan Austin on 27/02/2018.
//  Copyright © 2018 Dan Austin. All rights reserved.
//

import Foundation

/// Represents a period in the Digital Monitor API
struct DMPeriod : Codable{
    
    // Member variables
    let name: String
    let duration: Int
    let key: String
    let id: String
    
    // coding keys to convert between object and JSON
    enum CodingKeys: String, CodingKey {
        case name
        case key
        case duration
        case id = "_id"
    }
    
    /// Get all periods from the web service
    ///
    /// - Parameter onCompletion: callback function to be called on completion
    static func getPeriods(_ onCompletion: @escaping ([DMPeriod]?, Error?) -> Void){
        let controller = PeriodController()
        controller.getPeriods(onCompletion)
    }
}
