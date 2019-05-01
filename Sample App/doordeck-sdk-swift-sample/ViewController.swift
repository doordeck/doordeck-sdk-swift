//
//  ViewController.swift
//  doordeck-sdk-swift-sample
//
//  Created by Marwan on 18/04/2019.
//  Copyright © 2019 Doordeck. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
    let token = MyToken().token //your token as a string
    
    var doordeck:Doordeck?

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        let token = AuthTokenClass(self.token)
        doordeck = Doordeck(token)
        doordeck?.delegate = self
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)

    }

    @IBAction func initButton(_ sender: Any) {
        doordeck?.Initialize()
    }
    
    @IBAction func showUnlockButton(_ sender: Any) {
        doordeck?.showUnlockScreen(.qr, success: {
            
        }, fail: {
            
        })
    }
}

extension ViewController: DoordeckProtocol {
    func verificationNeeded() {
        print("verificationNeeded")
    }
    
    func newAuthTokenRequired() -> AuthTokenClass {
        print("newAuthTokenRequired")
        return AuthTokenClass(self.token)
    }
    
    func unlockSuccessful() {
        print("unlockSuccessful")
    }
}
