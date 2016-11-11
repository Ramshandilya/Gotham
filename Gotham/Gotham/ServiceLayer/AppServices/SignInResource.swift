//
//  OnboardingService.swift
//  Gotham
//
//  Created by Ramsundar Shandilya on 11/11/16.
//  Copyright © 2016 Ramsundar Shandilya. All rights reserved.
//

import Foundation

struct SignInRequest: NetworkRequestable {
    
    var endpoint: String {
        return "/signIn"
    }
    
    var method: HTTPMethod {
        return HTTPMethod.post
    }
    
    var queryItems: [URLQueryItem]? {
        return nil
    }
    
    var parameters: [String : Any]?
    
    var headers: [String : String]? {
        return defaultJSONHeaders()
    }
}

struct SignInResource: JSONResource {
    
    typealias Model = SignInItem
    
    let request: NetworkRequestable
    
    let email: String
    let password: String
    
    
    init(email: String, password: String) {
        self.email = email
        self.password = password
        
        request = SignInRequest(parameters: ["email": email, "password": password])
    }
}

struct SignInItem {
    var token: String
}
