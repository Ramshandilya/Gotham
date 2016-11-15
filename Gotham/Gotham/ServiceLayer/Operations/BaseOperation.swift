//
//  BaseOperation.swift
//  Gotham
//
//  Created by Ramsundar Shandilya on 11/10/16.
//  Copyright © 2016 Ramsundar Shandilya. All rights reserved.
//

import UIKit

class BaseOperation: Operation {
    
    override var isAsynchronous: Bool {
        return true
    }
    
    //Executing
    private var _executing: Bool = false
    override var isExecuting: Bool {
        get { return _executing }
        set {
            willChangeValue(forKey: "isExecuting")
            _executing = newValue
            didChangeValue(forKey: "isExecuting")
            if _cancelled == true {
                self.isFinished = true
            }
        }
    }
    
    //Finished
    private var _finished: Bool = false
    override var isFinished: Bool {
        get { return _finished }
        set {
            willChangeValue(forKey: "isFinished")
            _finished = newValue
            didChangeValue(forKey: "isFinished")
        }
    }
    
    //Cancelled
    private var _cancelled: Bool = false
    override var isCancelled: Bool {
        get { return _cancelled }
        set {
            willChangeValue(forKey: "isCancelled")
            _cancelled = newValue
            didChangeValue(forKey: "isCancelled")
        }
    }
    
    private(set) var observers = [OperationObserver]()
    func addObserver(observer: OperationObserver) {
        assert(!isExecuting, "Cannot modify observers after execution has begun.")
        
        observers.append(observer)
    }
    
    final override func start() {
        super.start()
        isExecuting = true
    }
    
    final override func main() {
        if isCancelled {
            isExecuting = false
            isFinished = true
            return
        }
        
        for observer in observers {
            observer.operationDidStart(self)
        }
        
        execute()
    }
    
    func execute() {
        assertionFailure("execute must be overriden")
        finish()
    }
    
    final func finish(errors: [Error] = []) {
        self.isFinished = true
        self.isExecuting = false
        
        for observer in observers {
            observer.operationDidFinish(self, errors: errors)
        }
    }
    
    override func cancel() {
        super.cancel()
        
        isCancelled = true
        
        if isExecuting {
            isExecuting = false
            isFinished = true
        }
    }
}
