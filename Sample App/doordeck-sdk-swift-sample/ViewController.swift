//
//  ViewController.swift
//  doordeck-sdk-swift-sample
//
//  Created by Marwan on 18/04/2019.
//  Copyright © 2019 Doordeck. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
    let token = ""

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        let token = AuthTokenClass(self.token)
        let doordeck = Doordeck(token)
        doordeck.delegate = self
        doordeck.Initialize()
    }


}

extension ViewController: DoordeckProtocol {
    func newAuthTokenRequired() -> AuthTokenClass {
        return AuthTokenClass(self.token)
    }
    
    func unlockSuccessful() {
        
    }
    
    
}
