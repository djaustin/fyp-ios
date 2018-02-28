//
//  PeriodController.swift
//  Digital Monitor
//
//  Created by Dan Austin on 28/02/2018.
//  Copyright © 2018 Dan Austin. All rights reserved.
//

import Foundation
import p2_OAuth2

class PeriodController {
    
    let periodsEndpoint = "https://digitalmonitor.tk/api/periods"
    let oauth2Credentials = DigitalMonitorAPI.sharedInstance.oauth2ClientCredentials
    
    func getPeriods(_ onCompletion: @escaping ([DMPeriod]?, Error?) -> Void){
        let jsonDecoder = JSONDecoder()

        
        guard let url = URL(string: periodsEndpoint) else {
            return onCompletion(nil, RequestError.urlError)
        }
    
        
        var req = oauth2Credentials.request(forURL: url)
        
        req.httpMethod = "GET"
        
        let loader = OAuth2DataLoader(oauth2: oauth2Credentials)
        
        loader.perform(request: req) { (oauthResponse) in
            if let error = oauthResponse.error {
                onCompletion(nil, error)
            } else {
                if oauthResponse.response.statusCode == 200 {
                    if let data = oauthResponse.data {
                        do{
                            let responseBody = try jsonDecoder.decode(GetPeriodsResponse.self, from: data)
                            if responseBody.status == "success"{
                                return onCompletion(responseBody.data.periods, nil)
                            } else {
                                return onCompletion(nil, ResponseError.errorOnStatusOk)
                            }
                        }catch {
                            print(error)
                            onCompletion(nil, error)
                        }
                    } else {
                        onCompletion(nil, ResponseError.noResponseData)
                    }
                } else {
                    onCompletion(nil, ResponseError.responseNotOK)
                }
            }
        }
        
    }
}
