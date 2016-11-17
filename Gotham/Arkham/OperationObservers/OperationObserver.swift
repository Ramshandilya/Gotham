//
//  OperationObserver.swift
//  Gotham
//
//  Created by Ramsundar Shandilya on 11/10/16.
//  Copyright © 2016 Ramsundar Shandilya. All rights reserved.
//

import Foundation


/// A protocol that types may implement if they wish to be notified of significant operation lifecycle events.
protocol OperationObserver {
    
    /// Invoked immediately prior to the `Operation`'s `execute()` method.
    func operationDidStart(_ operation: BaseOperation)
    
    /// Invoked as an `Operation` finishes, along with any errors produced during execution (or readiness evaluation).
    func operationDidFinish(_ operation: BaseOperation, errors: [Error])
}
