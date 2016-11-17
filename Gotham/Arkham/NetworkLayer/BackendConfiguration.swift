//
//  BackendConfiguration.swift
//  Gotham
//
//  Created by Ramsundar Shandilya on 11/10/16.
//  Copyright © 2016 Ramsundar Shandilya. All rights reserved.
//

import Foundation

fileprivate enum Server: String {
    case Development = "http://52.25.202.94/dev/"
    case Staging = "http://52.39.62.12/staging"
    case Production = "http://52.25.202.94/prod/"
    
    func baseURL() -> URL {
        return URL(string: self.rawValue)!
    }
}

fileprivate enum Environment: Int {
    
    case Development = 101
    case Staging = 102
    case Production = 103
    
    var baseURL: URL {
        switch self {
        case .Development:
            return Server.Development.baseURL()
        case .Staging:
            return Server.Production.baseURL()
        case .Production:
            return Server.Production.baseURL()
        }
    }
}


public final class BackendConfiguration {
    
    private static var environment: Environment {
        
        var environment: Environment!
        let value = UserDefaults.standard.integer(forKey: "ENVIRONMENT")
        
        switch value {
        case Environment.Development.rawValue :
            environment = .Development
        case Environment.Staging.rawValue:
            environment = .Staging
        case Environment.Production.rawValue:
            environment = .Production
        default :
            #if DEVELOPMENT
                environment = .Development
                UserDefaults.standard.set(Environment.Development.rawValue, forKey: "ENVIRONMENT")
            #else
                environment = .Production
                UserDefaults.standard.set(Environment.Production.rawValue, forKey: "ENVIRONMENT")
            #endif
        }
        
        return environment
    }
    
    public static var shared: BackendConfiguration = BackendConfiguration(baseURL: BackendConfiguration.environment.baseURL)
    
    let baseURL: URL
    
    public init(baseURL: URL) {
        self.baseURL = baseURL
    }
}

