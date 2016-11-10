//
//  NetworkService.swift
//  Gotham
//
//  Created by Ramsundar Shandilya on 11/10/16.
//  Copyright © 2016 Ramsundar Shandilya. All rights reserved.
//

import Foundation

enum HTTPMethod: String {
    
    case get = "GET"
    case post = "POST"
    case put = "PUT"
    case delete = "DELETE"
    
    case head = "HEAD"
    case patch = "PATCH"
    case trace = "TRACE"
    case connect = "CONNECT"
    case options = "OPTIONS"
}

enum NetworkServiceError: Error {
    case networkingError(Error?)
    case clientError(Error?, statusCode: Int)
    case serverError(Error?, statusCode: Int)
    case unknown(Error?)
}

/// Vanilla networking class. Returns plain data or failure.
final class NetworkService {
    
    private var task: URLSessionDataTask!
    private var successCodes: Range<Int> = 200..<299
    private var clientErrorCodes: Range<Int> = 400..<499
    private var serverErrorCodes: Range<Int> = 500..<599
    
    func performRequest(withUrl url: URL,
                 method: HTTPMethod,
                 params: [String: Any]? = nil,
                 queryItems: [URLQueryItem]? = nil,
                 headers: [String: String]? = nil,
                 success: ((Data?) -> Void)? = nil,
                 failure: ((_ error: NetworkServiceError) -> Void)? = nil) {
        
        var finalURL = url
        
        //Add query items
        if let queryItems = queryItems {
            var components = URLComponents(url: url, resolvingAgainstBaseURL: false)
            components?.queryItems = queryItems
            finalURL = (components?.url)!
        }
        
        var request = URLRequest(url: finalURL, cachePolicy: .reloadIgnoringLocalAndRemoteCacheData,
                                        timeoutInterval: 10.0)
        
        request.httpMethod = method.rawValue
        request.allHTTPHeaderFields = headers
        
        //Add request HTTP body
        if let body = params {
            request.httpBody = try? JSONSerialization.data(withJSONObject: body, options: JSONSerialization.WritingOptions.prettyPrinted)
        }
        
        let session = URLSession.shared
        
        task = session.dataTask(with: request, completionHandler: { (data, response, error) in
            
            if let error = error {
                failure?(.networkingError(error))
                return
            }
            
            guard let httpResponse = response as? HTTPURLResponse else {
                failure?(.networkingError(error))
                return
            }
            
            switch httpResponse.statusCode {
            
            case self.successCodes:
                success?(data)
            case self.clientErrorCodes:
                failure?(.clientError(error, statusCode: httpResponse.statusCode))
            case self.serverErrorCodes:
                failure?(.serverError(error, statusCode: httpResponse.statusCode))
            default:
                failure?(.unknown(error))
            }
        })
        
        task?.resume()
    }
}
