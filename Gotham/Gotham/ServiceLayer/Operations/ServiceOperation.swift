//
//  ServiceOperation.swift
//  Gotham
//
//  Created by Ramsundar Shandilya on 11/11/16.
//  Copyright © 2016 Ramsundar Shandilya. All rights reserved.
//

import Foundation

final class ServiceOperation <Service: ResourceService> : BaseOperation, ResourceFetchable {
    
    typealias ResourceType = Service.ResourceType
    typealias DidFinishFetchingResourceCallback = (ServiceOperation<Service>, Result<ResourceType.Model>) -> Void
    
    private let resource: ResourceType
    private let service: Service
    private let didFinishFetchingResourceCallback: DidFinishFetchingResourceCallback
    
    init(resource: Service.ResourceType, service: Service = Service(), didFinishFetchingResourceCallback: @escaping DidFinishFetchingResourceCallback) {
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
    
    func didFinishFetchingResource(result: Result<ResourceType.Model>) {
        didFinishFetchingResourceCallback(self, result)
    }
}

