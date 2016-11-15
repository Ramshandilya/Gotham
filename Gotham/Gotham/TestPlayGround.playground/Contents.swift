//: Playground - noun: a place where people can play

import UIKit

var str = "Hello, playground"

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
    
}

protocol ResourceService {
    
    associatedtype ResourceType: Resource
    
    /**
     Fetch a resource
     
     - parameter resource:   The resource to fetch
     - parameter completion: A completion handler called with a Result type of the fetching computation
     */
    
    func fetch(resource: ResourceType, completion: @escaping (Result<ResourceType.Model>) -> Void)
    
}

public protocol Resource {
    associatedtype Model
}

public enum Result<T> {
    case success(T)
    case failure(Error)
}

