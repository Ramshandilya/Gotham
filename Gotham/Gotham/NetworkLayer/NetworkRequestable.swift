//
//  NetworkResource.swift
//  Gotham
//
//  Created by Ramsundar Shandilya on 11/10/16.
//  Copyright © 2016 Ramsundar Shandilya. All rights reserved.
//

import Foundation

public protocol NetworkRequestable {

    var endpoint: String { get }
    var method: HTTPMethod { get }
    var queryItems: [URLQueryItem]? { get }
    var parameters: [String: Any]? { get }
    var headers: [String: String]? { get }
}

extension NetworkRequestable {
    private func defaultJSONHeaders() -> [String: String] {
        return ["Content-Type": "application/json"]
    }
    
    var headers: [String: String]? {
        return defaultJSONHeaders()
    }
    
    var queryItems: [URLQueryItem]? {
        return nil
    }
    
    var parameters: [String: Any]? {
        return nil
    }
}
