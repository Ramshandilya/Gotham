//
//  ServiceOperation.swift
//  Gotham
//
//  Created by Ramsundar Shandilya on 11/11/16.
//  Copyright © 2016 Ramsundar Shandilya. All rights reserved.
//

import Foundation

public final class ServiceOperation <T: ResourceService> : BaseOperation, ResourceFetchable {
    
    public typealias ResourceServiceType = T
    public typealias DidFinishFetchingResourceCallback = (ServiceOperation<ResourceServiceType>, Result<ResourceServiceType.ResourceType.Model>) -> Void
    
    private let resource: ResourceServiceType.ResourceType
    private let service: ResourceServiceType
    private let didFinishFetchingResourceCallback: DidFinishFetchingResourceCallback
    
    public init(resource: ResourceServiceType.ResourceType, service: ResourceServiceType = ResourceServiceType(), didFinishFetchingResourceCallback: @escaping DidFinishFetchingResourceCallback) {
        
        self.resource = resource
        self.service = service
        self.didFinishFetchingResourceCallback = didFinishFetchingResourceCallback
        
        super.init()
    }
    
    public override func execute() {
        fetch(resource: resource, usingService: service)
    }
    
    public override func cancel() {
        service.cancel()
        super.cancel()
    }
    
    public func didFinishFetchingResource(result: Result<ResourceServiceType.ResourceType.Model>) {
        didFinishFetchingResourceCallback(self, result)
    }
}

