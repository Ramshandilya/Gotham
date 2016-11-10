//
//  Result.swift
//  Gotham
//
//  Created by Ramsundar Shandilya on 11/10/16.
//  Copyright © 2016 Ramsundar Shandilya. All rights reserved.
//

import Foundation

/**
 A generic result type.
 
 - Success: Wraps with the generic value.
 - Failure: Wraps with an error type.
 */
public enum Result<T> {
    case Success(T)
    case Failure(Error)
}
