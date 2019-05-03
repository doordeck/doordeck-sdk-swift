//
//  InitializeDoordeck.swift
//  doordeck-sdk-swift
//
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
public protocol DoordeckProtocol {
    func newAuthTokenRequired() -> AuthTokenClass
    func verificationNeeded()
    func unlockSuccessful()
}

protocol DoordeckInternalProtocol {
    func verificationSuccessful(_ chain: CertificateChainClass)
    func verificationUnsuccessful()
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
    
    /// Current state of Doordeck
    ///
    /// - authenticated: The auth token has been autheticated
    /// - verificationRequired: verification is required from the user, this means the used key has changed
    /// - notAuthenticated: The auhtoken has not been validated with the server. 
    enum State {
        case authenticated
        case verificationRequired
        case notAuthenticated
    }
    
    public var delegate: DoordeckProtocol?
    fileprivate var token: AuthTokenClass
    fileprivate var chain: CertificateChainClass?
    fileprivate var readerType: ReaderType = ReaderType.automatic
    fileprivate var currentState: State = State.notAuthenticated
    fileprivate var apiClient: APIClient!
    fileprivate var sodium: SodiumHelper!
    
    
    /// The doordeck init expects an AuthToken, this is something expected from to be retrieved from the host application server,
    ///
    /// - Parameter token: AuthTokenClass contains user Auth Token.
    public init(_ token: AuthTokenClass, darkMode: Bool = true) {
        self.token = token
        let header = Header().createSDKAuthHeader(.v1, token: token)
        self.apiClient = APIClient(header, token: token)
        self.sodium = SodiumHelper(token)
        darkModeActive(darkMode)
    }
    
    
    /// Dark mode
    ///
    /// - Parameter bool: set dark mode on init. 
    private func darkModeActive (_ bool: Bool) {
        UserDefaults.setDarkUI(bool)
    }
    
    /// Use this method to pre-initialise the server checks, this will make unlocking faster.
    public func Initialize() {
        checkTokenIsValid { [weak self] (currentState) in
            switch currentState {
            case .authenticated:
                break
            case .notAuthenticated:
                self?.updateAuthToken(self?.delegate?.newAuthTokenRequired())
                break
            case .verificationRequired:
                self?.delegate?.verificationNeeded()
                break
            }
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
        success()
        guard let view:UIViewController = UIApplication.topViewController() else { return }
        let storyboard : UIStoryboard = UIStoryboard(name: "VerificationStoryboard", bundle: nil)
        let vc : VerificationViewController = storyboard.instantiateViewController(withIdentifier: "VerificationNoNavigation") as! VerificationViewController
        vc.delegate = self
        vc.apiClient = self.apiClient
        vc.sodium = self.sodium
        
        let navigationController = UINavigationController(rootViewController: vc)
        navigationController.isNavigationBarHidden = true
        view.present(navigationController, animated: true, completion: nil)
    }
    
    /// Show Doordeck reader and unlock UI, authentications have been completed
    ///
    /// - Parameters:
    ///   - success: called on success
    ///   - fail: called on failure
    fileprivate func preInitializeShowUnlock (_ success:() -> Void , fail: () -> Void) {
        success()
        self.showUnlockScreenSuccess()
    }
    
    
    /// Check if token is valid followed by unlock reader.
    ///
    /// - Parameters:
    ///   - success: called on success
    ///   - fail: called on failure
    fileprivate func initializeShowUnlock (_ success:@escaping () -> Void , fail: @escaping () -> Void) {
        checkTokenIsValid { [weak self] (currentState) in
            switch currentState {
            case .authenticated:
                success()
                self?.showUnlockScreenSuccess()
                break
            case .notAuthenticated:
                fail()
                self?.updateAuthToken(self?.delegate?.newAuthTokenRequired())
                break
            case .verificationRequired:
                fail()
                self?.showVerificationScreen(success, fail: fail)
                self?.delegate?.verificationNeeded()
                break
            }
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
    fileprivate func showUnlockScreenSuccess () {
        guard let certificateChainCheck: CertificateChainClass = self.chain else {
            self.currentState = .notAuthenticated
            self.updateAuthToken(self.delegate?.newAuthTokenRequired())
            return
        }
        
        guard let view:UIViewController = UIApplication.topViewController() else { return }
        let storyboard : UIStoryboard = UIStoryboard(name: "QuickEntryStoryboard", bundle: nil)
        let vc : QuickEntryViewController = storyboard.instantiateViewController(withIdentifier: "QuickEntryNoNavigation") as! QuickEntryViewController
        vc.lockMan = LockManager(self.apiClient)
        vc.readerType = self.readerType
        vc.delegate = self.delegate
        vc.apiClient = self.apiClient
        vc.certificateChain = certificateChainCheck
        vc.sodium = self.sodium
        
        let navigationController = UINavigationController(rootViewController: vc)
        navigationController.isNavigationBarHidden = true
        view.present(navigationController, animated: true, completion: nil)
    }
    
    /// Check if a token is valid, the date of expiry is first checked on device, the device then sends the key to the server on success of token check.
    ///
    /// - Parameters:
    ///   - success: Sucess
    ///   - fail: Token is invalid or out of date, or the key has not been sent to the server
    fileprivate func checkTokenIsValid(_ completion:@escaping (_ state: State) -> Void) {
        TokenHelper(token).tokenActive( { [weak self] in
            self?.sendKeyToServer({ (currentState) in
                switch currentState {
                case .authenticated:
                    completion(.authenticated)
                    break
                case .notAuthenticated:
                    completion(.notAuthenticated)
                    break
                case .verificationRequired:
                    SDKEvent().event(.TWO_FACTOR_AUTH_NEEDED)
                    completion(.verificationRequired)
                    break
                }
            })
        }) {
            self.currentState = .notAuthenticated
            completion(.notAuthenticated)
        }
    }
    
    /// Send the key to the server. The key is created if it does not exist and sent to the server
    /// if it does exist the key is retrived and sent to the server.
    ///
    /// - Parameters:
    ///   - success: Completion will return if that was sucessful or the issue
    fileprivate func sendKeyToServer(_ completion:@escaping (_ state: State) -> Void) {
        guard let publicKey = sodium.getPublicKey() else {
            self.currentState = .notAuthenticated
            completion(.notAuthenticated)
            return
        }
        
        apiClient.registrationWithKey(publicKey) { [weak self]  (certificateChain, error) in
            if error != nil {
                if let authError = error, case .twoFactorAuthenticationNeeded = authError {
                    self?.currentState = .verificationRequired
                    completion(.verificationRequired)
                } else {
                    self?.currentState = .notAuthenticated
                    completion(.notAuthenticated)
                }
                
            } else {
                guard let certificateChainTemp = certificateChain else {
                    self?.currentState = .notAuthenticated
                    completion(.notAuthenticated)
                    return
                }
                SDKEvent().event(.GET_CERTIFICATE_SUCCESS)
                self?.chain = CertificateChainClass(certificateChainTemp)
                self?.currentState = .authenticated
                completion(.authenticated)
            }
            
        }
    }
}

extension Doordeck: DoordeckInternalProtocol {
    func verificationSuccessful(_ chain: CertificateChainClass) {
        SDKEvent().event(.GET_CERTIFICATE_SUCCESS)
        self.currentState = .authenticated
        self.chain = chain
        showUnlockScreenSuccess()
    }
    
    func verificationUnsuccessful() {
        self.currentState = .verificationRequired
    }
    
    
}

