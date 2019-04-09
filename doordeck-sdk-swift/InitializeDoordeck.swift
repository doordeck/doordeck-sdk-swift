//
//  InitializeDoordeck.swift
//  doordeck-sdk-swift
//
//  Created by Marwan on 28/03/2019.
//  Copyright © 2019 Doordeck. All rights reserved.
//

import Foundation
import UIKit

protocol DoordeckProtocol {
    func newAuthTokenRequired() -> AuthTokenClass
    func unlockSuccessful()
}


public class Doordeck {
    
    public enum ReaderType {
        case automatic
        case nfc
        case qr
    }
    
    enum State {
        case authenticated
        case verificationRequired
        case notAuthenticated
    }
    
    
    fileprivate var token: AuthTokenClass
    fileprivate var delegate: DoordeckProtocol?
    fileprivate var readerType: ReaderType = ReaderType.automatic
    fileprivate var currentState: State = State.notAuthenticated
    fileprivate var apiClient: APIClient!
    fileprivate var sodium: SodiumHelper!
    
    public init(_ token: AuthTokenClass) {
        self.token = token
        let header = Header().createSDKAuthHeader(.v1, token: token)
        self.apiClient = APIClient(header, token: token)
        self.sodium = SodiumHelper(token)
    }
    
    public func Initialize() {
        checkTokenIsValid({ [weak self] in
            self?.currentState = .authenticated
            
        }) { [weak self] in
            self?.currentState = .notAuthenticated
            self?.updateAuthToken(self?.delegate?.newAuthTokenRequired())
        }
    }
    
    public func showUnlockScreen(_ readerType: ReaderType = ReaderType.automatic, sucess:@escaping () -> Void , fail: @escaping () -> Void)  {
        self.readerType = readerType
        switch currentState {
        case .authenticated:
            preInitializeShowUnlock(sucess, fail: fail)
            break
            
        case .notAuthenticated:
            initializeShowUnlock(sucess, fail: fail)
            break
            
        case .verificationRequired :
            showVerificationScreen(sucess, fail: fail)
            break
        }
    }
    
    fileprivate func showVerificationScreen (_ sucess:() -> Void , fail: () -> Void) {
        
    }
    
    fileprivate func preInitializeShowUnlock (_ sucess:() -> Void , fail: () -> Void) {
        sucess()
        self.showUnlockScreenSucess()
    }
    
    fileprivate func initializeShowUnlock (_ sucess:@escaping () -> Void , fail: @escaping () -> Void) {
        checkTokenIsValid({ [weak self] in
            sucess()
            self?.showUnlockScreenSucess()
        }) { [weak self] in
            fail()
            self?.updateAuthToken(self?.delegate?.newAuthTokenRequired())
        }
    }
    
    fileprivate func updateAuthToken (_ token: AuthTokenClass?) {
        guard let tokenTemp: AuthTokenClass = token else { return }
        self.token = tokenTemp
        let header = Header().createSDKAuthHeader(.v1, token: self.token)
        self.apiClient = APIClient(header, token: self.token)
        self.sodium = SodiumHelper(self.token)
    }
    
    fileprivate func showUnlockScreenSucess () {
        guard let view:UIViewController = UIApplication.topViewController() else { return }
        let storyboard : UIStoryboard = UIStoryboard(name: "QuickEntryStoryboard", bundle: nil)
        let vc : QuickEntryViewController = storyboard.instantiateViewController(withIdentifier: "QuickEntryNoNavigation") as! QuickEntryViewController
        vc.readerType = self.readerType
        vc.delegate = self.delegate
        vc.apiClient = self.apiClient
        
        let navigationController = UINavigationController(rootViewController: vc)
        view.present(navigationController, animated: true, completion: nil)
    }
    
    fileprivate func checkTokenIsValid(_ sucess:@escaping () -> Void , fail: @escaping () -> Void) {
        TokenHelper(token).tokenActive( { [weak self] in
            self?.sendKeyToServer({
                sucess()
            }, fail: {
                fail()
            })
        }) {
            fail()
        }
    }
    
    fileprivate func sendKeyToServer(_ sucess:@escaping () -> Void , fail: @escaping () -> Void) {
        
        guard let publicKey = sodium.getKeyPair() else {
            fail()
            return
        }
        
        apiClient.registrationWithKey(publicKey) { [weak self]  (Json, error) in
            if error != nil {
                fail()
                self?.currentState = .notAuthenticated
            } else {
                sucess()
                self?.currentState = .authenticated
            }
            
        }
    }
}

