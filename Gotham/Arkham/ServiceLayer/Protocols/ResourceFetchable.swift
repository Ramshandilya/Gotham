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

public protocol ResourceFetchable: Cancellable, Finishable {
    
    associatedtype ResourceServiceType: ResourceService
    
    /**
     Fetches a resource using the provided service
     
     - parameter resource: The resource to fetch
     - parameter service:  The service to be used for fetching the resource
     */
    func fetch(resource: ResourceServiceType.ResourceType, usingService service: ResourceServiceType)
    
    /**
     Called when the operation has finished
     
     - parameter result: The result of the operation
     */
    func didFinishFetchingResource(result: Result<ResourceServiceType.ResourceType.Model>)
}

public extension ResourceFetchable {
    
    func fetch(resource: ResourceServiceType.ResourceType, usingService service: ResourceServiceType) {
        
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
