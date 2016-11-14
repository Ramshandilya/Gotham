//
//  NetworkActivityIndicatorManager.swift
//  Gotham
//
//  Created by Ramsundar Shandilya on 11/14/16.
//  Copyright © 2016 Ramsundar Shandilya. All rights reserved.
//

import Foundation
import UIKit

final class NetworkActivityIndicatorManager {
    
    static let shared = NetworkActivityIndicatorManager()
    
    private var activityCount = 0
    private var visibilityTimer: Timer?
    
    private init () { }
    
    //MARK:- Public Methods
    func networkActivityDidStart() {
        assert(Thread.isMainThread, "Altering network activity indicator state can only be done on the main thread.")
        
        activityCount += 1
        
        updateIndicatorVisibility()
    }
    
    func networkActivityDidEnd() {
        assert(Thread.isMainThread, "Altering network activity indicator state can only be done on the main thread.")
        
        activityCount -= 1
        
        updateIndicatorVisibility()
    }
    
    //MARK:- Private Methods
    private func updateIndicatorVisibility() {
        if activityCount > 0 {
            showIndicator()
        }
        else {
            /*
             To prevent the indicator from flickering on and off, we delay the
             hiding of the indicator by one second. This provides the chance
             to come in and invalidate the timer before it fires.
             */
            visibilityTimer = Timer(interval: 1.0) {
                self.hideIndicator()
            }
        }
    }
    
    private func showIndicator() {
        visibilityTimer?.cancel()
        visibilityTimer = nil
        UIApplication.shared.isNetworkActivityIndicatorVisible = true
    }
    
    private func hideIndicator() {
        visibilityTimer?.cancel()
        visibilityTimer = nil
        UIApplication.shared.isNetworkActivityIndicatorVisible = false
    }
}

/// Essentially a cancellable `Dispatch After`.
private final class Timer {
    // MARK: Properties
    
    private var isCancelled = false
    
    // MARK: Initialization
    
    init(interval: TimeInterval, handler: @escaping () -> Void) {
        let when = DispatchTime.now() + DispatchTimeInterval.milliseconds(Int(interval * 1000))
        
        DispatchQueue.main.asyncAfter(deadline: when, execute: { [weak self] in
            if self?.isCancelled == false {
                handler()
            }
        })
    }
    
    func cancel() {
        isCancelled = true
    }
}
