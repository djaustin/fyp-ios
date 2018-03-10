//
//  DMPeriod.swift
//  Digital Monitor
//
//  Created by Dan Austin on 27/02/2018.
//  Copyright © 2018 Dan Austin. All rights reserved.
//

import Foundation

struct DMPeriod : Codable{
    let name: String
    let duration: Int
    let key: String
    let id: String
    
    enum CodingKeys: String, CodingKey {
        case name
        case key
        case duration
        case id = "_id"
    }
    
    static func getPeriods(_ onCompletion: @escaping ([DMPeriod]?, Error?) -> Void){
        let controller = PeriodController()
        controller.getPeriods(onCompletion)
    }
}
