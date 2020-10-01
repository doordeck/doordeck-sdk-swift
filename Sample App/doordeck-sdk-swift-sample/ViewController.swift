//
//  ViewController.swift
//  doordeck-sdk-swift-sample
//
//  Copyright © 2019 Doordeck. All rights reserved.
//

import UIKit
import doordeck_sdk_swift

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
        NotificationCenter.default.addObserver(self, selector: #selector(self.doordeckEvents(_:)), name: SDKEvent().doordeckEventsName, object: nil)
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        NotificationCenter.default.removeObserver(self, name: SDKEvent().doordeckEventsName, object: nil)
    }

    @objc func doordeckEvents (_ event: NSNotification) {
        guard let eventAction = event.object as? SDKEvent.EventAction else {
            return
        }
        print(eventAction)
    }
    
    @IBAction func initButton(_ sender: Any) {
        doordeck?.Initialize()
    }
    
    @IBAction func showUnlockButton(_ sender: Any) {
        doordeck?.showUnlockScreen(.automatic, success: {
            
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
    
    func authenticated() {
        print("authenticated")
    }
}
