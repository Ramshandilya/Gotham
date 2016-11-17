//
//  BackgroundObserver.swift
//  Gotham
//
//  Created by Ramsundar Shandilya on 11/16/16.
//  Copyright © 2016 Ramsundar Shandilya. All rights reserved.
//

import Foundation
import UIKit

class BackgroundObserver: OperationObserver {
    
    private var backgroundIdentifier = UIBackgroundTaskInvalid
    private var isInBackground = false
    
    init() {
        
        NotificationCenter.default.addObserver(self, selector: #selector(didEnterBackground(notification:)), name: NSNotification.Name.UIApplicationDidEnterBackground, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(willEnterForeground(notification:)), name: NSNotification.Name.UIApplicationWillEnterForeground, object: nil)
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
    
    @objc func didEnterBackground(notification: Notification) {
        if !isInBackground {
            isInBackground = true
            startBackgroundTask()
        }
    }
    
    @objc func willEnterForeground(notification: Notification) {
        if isInBackground {
            isInBackground = false
            endBackgroundTask()
        }
    }
    
    private func startBackgroundTask() {
        if backgroundIdentifier == UIBackgroundTaskInvalid {
            backgroundIdentifier = UIApplication.shared.beginBackgroundTask(withName: "BackgroundServer", expirationHandler: { [weak self] in
                self?.endBackgroundTask()
            })
        }
    }
    
    private func endBackgroundTask() {
        if backgroundIdentifier != UIBackgroundTaskInvalid {
            UIApplication.shared.endBackgroundTask(backgroundIdentifier)
            backgroundIdentifier = UIBackgroundTaskInvalid
        }
    }
    
    // MARK: Operation Observer
    
    func operationDidStart(_ operation: BaseOperation) {}
    
    func operationDidFinish(_ operation: BaseOperation, errors: [Error]) {
        endBackgroundTask()
    }
}

