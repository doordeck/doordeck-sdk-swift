//
//  InitializeDoordeck.swift
//  doordeck-sdk-swift
//
//  Created by Marwan on 28/03/2019.
//  Copyright © 2019 Doordeck. All rights reserved.
//

import Foundation
import UIKit

/**
 Backgrounds colour for Light (Light Grey) and Dark (primary dark blue)
 
 - Parameters:
 - Used for all backgrounds
 - Dark: primary dark blue
 - Light: Light Grey
 - Returns: UIColor
 */
protocol DoordeckProtocol {
    func newAuthTokenRequired() -> AuthTokenClass
    func unlockSuccessful()
}


/**
 `Doordeck` is the main class initialised by the application object.
 We recommend this is initialised as soon as possible, the `Initialize` method, we will start the necessary checks to check verifying the AuthToken.
 If you do not pre initialise Doordeck this will done when the user unlocks a lock.
 */
public class Doordeck {
    
    /**
     The reader type is the Quick scan option, if the application wishes to override the default, if an option is chosen that is not supported it will be ignored.
     */
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
    

    /// The doordeck init expects an AuthToken, this is something expected from to be retrieved from the host application server,
    ///
    /// - Parameter token: AuthTokenClass contains user Auth Token.
    public init(_ token: AuthTokenClass) {
        self.token = token
        let header = Header().createSDKAuthHeader(.v1, token: token)
        self.apiClient = APIClient(header, token: token)
        self.sodium = SodiumHelper(token)
    }
    

    /// Use this method to pre-initialise the server checks, this will make unlocking faster.
    public func Initialize() {
        checkTokenIsValid({ [weak self] in
            self?.currentState = .authenticated
            
        }) { [weak self] in
            self?.currentState = .notAuthenticated
            self?.updateAuthToken(self?.delegate?.newAuthTokenRequired())
        }
    }
    
    /// will start unlock procedure.
    ///
    /// - Parameters:
    ///   - readerType: Reader type can be specified to .nfc or .QR Or automatic
    ///   - success: This is called on success of device unlock
    ///   - fail: This is called on fail device unlock
    public func showUnlockScreen(_ readerType: ReaderType = ReaderType.automatic, success:@escaping () -> Void , fail: @escaping () -> Void)  {
        self.readerType = readerType
        switch currentState {
        case .authenticated:
            preInitializeShowUnlock(success, fail: fail)
            break
            
        case .notAuthenticated:
            initializeShowUnlock(success, fail: fail)
            break
            
        case .verificationRequired :
            showVerificationScreen(success, fail: fail)
            break
        }
    }
    
    /// Will be called, if the state of the app is .verificationRequired, this will mean the user will get a 2FA request
    ///
    /// - Parameters:
    ///   - success: called on success
    ///   - fail: called on failure
    fileprivate func showVerificationScreen (_ success:() -> Void , fail: () -> Void) {
        
    }
    
    /// Show Doordeck reader and unlock UI, authentications have been completed
    ///
    /// - Parameters:
    ///   - success: called on success
    ///   - fail: called on failure
    fileprivate func preInitializeShowUnlock (_ success:() -> Void , fail: () -> Void) {
        success()
        self.showUnlockScreensuccess()
    }
    
    
    /// Check if token is valid followed by unlock reader.
    ///
    /// - Parameters:
    ///   - success: called on success
    ///   - fail: called on failure
    fileprivate func initializeShowUnlock (_ success:@escaping () -> Void , fail: @escaping () -> Void) {
        checkTokenIsValid({ [weak self] in
            success()
            self?.showUnlockScreensuccess()
        }) { [weak self] in
            fail()
            self?.updateAuthToken(self?.delegate?.newAuthTokenRequired())
        }
    }
    
    
    /// If a token is invalid the delegate will request a new token from the host app.
    ///
    /// - Parameter token: new AuthTokenClass from the Host application
    fileprivate func updateAuthToken (_ token: AuthTokenClass?) {
        guard let tokenTemp: AuthTokenClass = token else { return }
        self.token = tokenTemp
        let header = Header().createSDKAuthHeader(.v1, token: self.token)
        self.apiClient = APIClient(header, token: self.token)
        self.sodium = SodiumHelper(self.token)
    }
    
    /// Show unlock reader, this will be added to the top view controller.
    fileprivate func showUnlockScreensuccess () {
        guard let view:UIViewController = UIApplication.topViewController() else { return }
        let storyboard : UIStoryboard = UIStoryboard(name: "QuickEntryStoryboard", bundle: nil)
        let vc : QuickEntryViewController = storyboard.instantiateViewController(withIdentifier: "QuickEntryNoNavigation") as! QuickEntryViewController
        vc.readerType = self.readerType
        vc.delegate = self.delegate
        vc.apiClient = self.apiClient
        
        let navigationController = UINavigationController(rootViewController: vc)
        view.present(navigationController, animated: true, completion: nil)
    }
    
    /// Check if a token is valid, the date of expiry is first checked on device, the device then sends the key to the server on success of token check.
    ///
    /// - Parameters:
    ///   - success: Sucess
    ///   - fail: Token is invalid or out of date, or the key has not been sent to the server
    fileprivate func checkTokenIsValid(_ success:@escaping () -> Void , fail: @escaping () -> Void) {
        TokenHelper(token).tokenActive( { [weak self] in
            self?.sendKeyToServer({
                success()
            }, fail: {
                fail()
            })
        }) {
            fail()
        }
    }
    
    /// Send the key to the server. The key is created if it does not exist and sent to the server
    /// if it does exist the key is retrived and sent to the server.
    ///
    /// - Parameters:
    ///   - success: sucess
    ///   - fail: fail could mean an error retrieving the key or sending it to the server.
    fileprivate func sendKeyToServer(_ success:@escaping () -> Void , fail: @escaping () -> Void) {
        guard let publicKey = sodium.getKeyPair() else {
            fail()
            return
        }
        
        apiClient.registrationWithKey(publicKey) { [weak self]  (Json, error) in
            if error != nil {
                fail()
                self?.currentState = .notAuthenticated
            } else {
                success()
                self?.currentState = .authenticated
            }
            
        }
    }
}

