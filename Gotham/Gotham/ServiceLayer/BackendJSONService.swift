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
}

extension BackendJSONService: ResourceService {
    
    convenience init() {
        self.init(BackendConfiguration.shared)
    }
    
    func fetch(resource: Resource, completion: @escaping (Result<Resource.Model>) -> Void) {
        
        let request = resource.request
        let url = configuration.baseURL.appendingPathComponent(request.endpoint)
        
        networkService.performRequest(withUrl: url, method: request.method, params: request.parameters, queryItems: request.queryItems, headers: request.headers,
                                      success: { data in
                        completion(resource.result(fromData: data!))
        },
                                      failure: { error in
                                        let result = Result<Resource.Model>.failure(error)
                                        completion(result)
        })
    }
    
    func cancel() {
        networkService.cancel()
    }
}
