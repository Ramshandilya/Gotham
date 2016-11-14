//
//  ViewController.swift
//  Gotham
//
//  Created by Ramsundar Shandilya on 11/10/16.
//  Copyright © 2016 Ramsundar Shandilya. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        let signInResource = SignInResource(email: "johnny@apple.com", password: "TEST123")
        
        let signInOperation = SignInResourceOperation(resource: signInResource, didFinishFetchingResourceCallback: { (operation, result) in
        
            if case .success(let conferences) = result {
                print(conferences)
            } else {
                print(result)
            }
            
        })
        
        let operationQueue = OperationQueue()
        operationQueue.addOperation(signInOperation)
        
    }

}

