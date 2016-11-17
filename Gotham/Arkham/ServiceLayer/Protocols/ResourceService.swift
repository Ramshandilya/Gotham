//
//  ResourceService.swift
//  Gotham
//
//  Created by Ramsundar Shandilya on 11/11/16.
//  Copyright © 2016 Ramsundar Shandilya. All rights reserved.
//

import Foundation

public protocol ResourceService {
    
    associatedtype ResourceType: Resource
    
    /**
     Designated initialzer for constructing a ResourceServiceType
     */
    init()
    
    /**
     Fetch a resource
     
     - parameter resource:   The resource to fetch
     - parameter completion: A completion handler called with a Result type of the fetching computation
     */
    func fetch(resource: ResourceType, completion: @escaping (Result<ResourceType.Model>) -> Void)
    
    func cancel() 
}
