//
//  TimeoutObserver.swift
//  Gotham
//
//  Created by Ramsundar Shandilya on 11/14/16.
//  Copyright © 2016 Ramsundar Shandilya. All rights reserved.
//

import Foundation

/**
 `TimeoutObserver` is a way to make an `Operation` automatically time out and
 cancel after a specified time interval.
 */
struct TimeoutObserver: OperationObserver {
    
    // MARK:- Properties
    private let timeout: TimeInterval
    
    // MARK: Init
    init(timeout: TimeInterval) {
        self.timeout = timeout
    }
    
    // MARK:- OperationObserver
    func operationDidStart(_ operation: BaseOperation) {
        // When the operation starts, queue up a block to cause it to time out.
        let when = DispatchTime.now() + DispatchTimeInterval.milliseconds(Int(timeout * 1000))
        
        DispatchQueue.main.asyncAfter(deadline: when, execute: {
            /*
             Cancel the operation if it hasn't finished and hasn't already
             been cancelled.
             */
            if !operation.isFinished && !operation.isCancelled {
                operation.cancel()
            }
        })
    }
    
    func operationDidFinish(_ operation: BaseOperation, errors: [Error]) {
        
    }
}
