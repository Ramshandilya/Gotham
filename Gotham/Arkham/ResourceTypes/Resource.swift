//
//  Resource.swift
//  Gotham
//
//  Created by Ramsundar Shandilya on 11/10/16.
//  Copyright © 2016 Ramsundar Shandilya. All rights reserved.
//

import Foundation

/// A resource can be defined as something that your application will consume. For example, it could be a JSON or XML file, an image, a video, etc.
public protocol Resource {
    associatedtype Model
}

public protocol DataResource: Resource {
    
    /**
     Parse this resources Model from some data
     
     - parameter data: The data to parse
     
     - returns: An instantiated model wrapped in `Result`
     */
    
    func result(fromData data: Data) -> Result<Model>
}
