//
//  BackendService.swift
//  Gotham
//
//  Created by Ramsundar Shandilya on 11/10/16.
//  Copyright © 2016 Ramsundar Shandilya. All rights reserved.
//

import Foundation

final class BackendJSONService <Resource: JSONResource> {
    
    fileprivate var configuration: BackendConfiguration
    fileprivate let networkService = NetworkService()
    
    init(_ conf: BackendConfiguration) {
        configuration = conf
    }
    
    private func resultFrom(resource: Resource, data: Data?, URLResponse: URLResponse?, error: Error?) -> Result<Resource.Model> {
        
//        guard let data = data else {
//            return .Failure(NetworkJSONServiceError.NoData)
//        }
        
        //TODO: Use guard
        return resource.result(fromData: data!)
    }
    
    
    func performRequest(withRequest request: NetworkRequestable,
                        completion: (Result<Resource.Model>) -> Void ) {
        
        let url = configuration.baseURL.appendingPathComponent(request.endpoint)
        
        networkService.performRequest(withUrl: url, method: request.method, params: request.parameters, queryItems: request.queryItems, headers: request.headers,
                                      success: { data in
//                                        let result = Resource.
        },
                                      failure: { error in
        
        })
    }
}

extension BackendJSONService: ResourceService {
    
    convenience init() {
        self.init(BackendConfiguration.shared)
    }
    
    func fetch(resource: Resource, completion: (Result<Resource.Model>) -> Void) {
        
        let request = resource.request
        let url = configuration.baseURL.appendingPathComponent(request.endpoint)
        
        networkService.performRequest(withUrl: url, method: request.method, params: request.parameters, queryItems: request.queryItems, headers: request.headers,
                                      success: { data in
                        completion(self.resultFrom(resource: resource, data: data, URLResponse: URLResponse, error: error))
        },
                                      failure: { error in
                                        
        })
    }
    
    func cancel() {
        networkService.cancel()
    }
}
