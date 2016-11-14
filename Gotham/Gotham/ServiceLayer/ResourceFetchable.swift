//
//  ResourceFetchable.swift
//  Gotham
//
//  Created by Ramsundar Shandilya on 11/11/16.
//  Copyright © 2016 Ramsundar Shandilya. All rights reserved.
//

import Foundation

/// Define a type that is cancellable
public protocol Cancellable: class {
    /// Returns whether or not the type has been cancelled
    var isCancelled: Bool { get }
}

public protocol Finishable: class {
    /**
     Method to be called when the type finished all it's work
     
     - parameter errors: Any error from the work done
     */
    func finish(errors: [Error])
}

protocol ResourceFetchable: Cancellable, Finishable {
    
    associatedtype ResourceType: Resource
    
    /**
     Fetches a resource using the provided service
     
     - parameter resource: The resource to fetch
     - parameter service:  The service to be used for fetching the resource
     */
    func fetch<Service: ResourceService>(resource: ResourceType, usingService service: Service) where Service.ResourceType == ResourceType
    
    /**
     Called when the operation has finished
     
     - parameter result: The result of the operation
     */
    func didFinishFetchingResource(result: Result<ResourceType.Model>)
}

extension ResourceFetchable {
    
    func fetch<Service: ResourceService>(resource: ResourceType, usingService service: Service) where Service.ResourceType == ResourceType {
        
        if isCancelled { return }
        
        service.fetch(resource: resource) { [weak self] (result) in
            
            self?.executeOnMain { [weak self] in
                
                guard let strongSelf = self else { return }
                
                if strongSelf.isCancelled { return }
                
                strongSelf.finish(errors: [])
                strongSelf.didFinishFetchingResource(result: result)
            }
        }
    }
    
    private func executeOnMain(mainThreadClosure: () -> Void) {
        if Thread.current.isMainThread {
            mainThreadClosure()
        } else {
            
            let queue = DispatchQueue.main
            queue.sync(execute: {
                mainThreadClosure()
            })
        }
    }
}

