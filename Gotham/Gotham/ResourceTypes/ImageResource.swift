//
//  ImageResource.swift
//  Gotham
//
//  Created by Ramsundar Shandilya on 11/16/16.
//  Copyright © 2016 Ramsundar Shandilya. All rights reserved.
//

import Foundation
import UIKit

public enum ImageDownloadingError: Error {
    case invalidImageData
}

/**
 *  Defines a specific ResourceType for Image resources
 */
public protocol ImageResource: DataResource {
    
    associatedtype Model: UIImage
    
    /**
     Takes NSData and returns a result which is either Success with an Image or Failure with an error
     
     - parameter data: Input Image Data
     
     - returns: Result of image decoding.
     */
    func resultFrom(data: Data) -> Result<Model>
}

// MARK: - Convenince parsing functions
extension ImageResource {
    
    public func resultFrom(data: Data) -> Result<UIImage> {
        guard let image = UIImage(data: data) else {
            return Result.failure(ImageDownloadingError.invalidImageData)
        }
        return .success(image)
    }
}
