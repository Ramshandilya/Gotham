//
//  NetworkObserver.swift
//  Gotham
//
//  Created by Ramsundar Shandilya on 11/14/16.
//  Copyright © 2016 Ramsundar Shandilya. All rights reserved.
//

import Foundation

/**
 `NetworkObserver` is an `OperationObserver` that will cause the network activity indicator to appear as long as the `BaseOperation` to which it is attached is executing.
 */
struct NetworkObserver: OperationObserver {
    
    func operationDidStart(_ operation: BaseOperation) {
        DispatchQueue.main.async {
            NetworkActivityIndicatorManager.shared.networkActivityDidStart()
        }
    }
    
    func operationDidFinish(_ operation: BaseOperation, errors: [Error]) {
        DispatchQueue.main.async {
            NetworkActivityIndicatorManager.shared.networkActivityDidEnd()
        }
    }
    
}
