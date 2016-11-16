//
//  ServiceOperation.swift
//  Gotham
//
//  Created by Ramsundar Shandilya on 11/11/16.
//  Copyright © 2016 Ramsundar Shandilya. All rights reserved.
//

import Foundation

final class ServiceOperation <T: ResourceService> : BaseOperation, ResourceFetchable {
    
    typealias ResourceServiceType = T
    typealias DidFinishFetchingResourceCallback = (ServiceOperation<ResourceServiceType>, Result<ResourceServiceType.ResourceType.Model>) -> Void
    
    private let resource: ResourceServiceType.ResourceType
    private let service: ResourceServiceType
    private let didFinishFetchingResourceCallback: DidFinishFetchingResourceCallback
    
    init(resource: ResourceServiceType.ResourceType, service: ResourceServiceType = ResourceServiceType(), didFinishFetchingResourceCallback: @escaping DidFinishFetchingResourceCallback) {
        
        self.resource = resource
        self.service = service
        self.didFinishFetchingResourceCallback = didFinishFetchingResourceCallback
        
        super.init()
    }
    
    override func execute() {
        fetch(resource: resource, usingService: service)
    }
    
    override func cancel() {
        service.cancel()
        super.cancel()
    }
    
    func didFinishFetchingResource(result: Result<ResourceServiceType.ResourceType.Model>) {
        didFinishFetchingResourceCallback(self, result)
    }
}

