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
    func authenticated()
}

protocol DoordeckUI {
    func openVerificationStoryboard(_ delegate: DoordeckInternalProtocol,
                                    sdkMode: Bool,
                                    controlDelegate: DoordeckControl?,
                                    apiClient:APIClient,
                                    sodiumHelper: SodiumHelper )
    
    func showUnlockScreenSuccess (_ lockManager: LockManager,
                                  readerType: Doordeck.ReaderType,
                                  delegate: DoordeckProtocol?,
                                  controlDelegate: DoordeckControl?,
                                  apiClient: APIClient,
                                  chain: CertificateChainClass,
                                  sodium: SodiumHelper)
    
}

protocol DoordeckInternalProtocol {
    func verificationSuccessful(_ chain: CertificateChainClass)
    func verificationUnsuccessful()
}

struct DoordeckControl {
    var showCloseButton: Bool
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
    var uiDelegate: DoordeckUI?
    var token: AuthTokenClass
    var chain: CertificateChainClass?
    var readerType: ReaderType = ReaderType.automatic
    var currentState: State = State.notAuthenticated
    var apiClient: APIClient!
    var sodium: SodiumHelper!
    var doordeckControl: DoordeckControl!
    var sdk = true
    

    /// The doordeck init expects an AuthToken, this is something expected from to be retrieved from the host application server
    ///
    /// - Parameters:
    ///   - token: AuthTokenClass contains user Auth Token.
    ///   - darkMode: shoudl the SDK load in Dark or Light mode
    ///   - closeButton: When the SDK is not used in a TabBar, you can have close buttons on the VC's
    public init(_ token: AuthTokenClass,
                darkMode: Bool = true,
                closeButton: Bool = false) {
        
        self.token = token
        let header = Header().createSDKAuthHeader(.v1,
                                                  token: token)
        
        self.apiClient = APIClient(header,
                                   token: token)
        
        self.sodium = SodiumHelper(token)
        self.uiDelegate = DoordeckSDKUI()
        self.doordeckControl = DoordeckControl(showCloseButton: closeButton)
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
                self?.delegate?.authenticated()
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
    public func showUnlockScreen(_ readerType: ReaderType = ReaderType.automatic,
                                 success:@escaping () -> Void,
                                 fail: @escaping () -> Void)  {
        
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
    func showVerificationScreen (_ success:() -> Void,
                                 fail: () -> Void) {
        
        if #available(iOS 10, *) {
        success()
            uiDelegate?.openVerificationStoryboard(self,
                                                   sdkMode: sdk,
                                                   controlDelegate: self.doordeckControl,
                                                   apiClient: self.apiClient,
                                                   sodiumHelper: self.sodium)
        } else {
            return
        }
    }
    
    /// Show Doordeck reader and unlock UI, authentications have been completed
    ///
    /// - Parameters:
    ///   - success: called on success
    ///   - fail: called on failure
    fileprivate func preInitializeShowUnlock (_ success:() -> Void,
                                              fail: () -> Void) {
        
        success()
        self.showUnlockScreenSuccess()
    }
    
    
    /// Check if token is valid followed by unlock reader.
    ///
    /// - Parameters:
    ///   - success: called on success
    ///   - fail: called on failure
    fileprivate func initializeShowUnlock (_ success:@escaping () -> Void,
                                           fail: @escaping () -> Void) {
        
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
    func updateAuthToken (_ token: AuthTokenClass?) {
        guard let tokenTemp: AuthTokenClass = token else { return }
        self.token = tokenTemp
        let header = Header().createSDKAuthHeader(.v1, token: self.token)
        self.apiClient = APIClient(header, token: self.token)
        self.sodium = SodiumHelper(self.token)
    }
    
    /// Return Certificate chain when SDK is being used in different format.
    ///
    /// - Parameter Certificate chain
    func getCertificateChain() -> CertificateChainClass? {
        guard let chainTemp = self.chain else {
            return nil
        }
        if sdk == false {
            return chainTemp
        } else {
            return nil
        }
    }
    
    /// Show unlock reader, this will be added to the top view controller.
    fileprivate func showUnlockScreenSuccess () {
        if #available(iOS 10, *) {
            guard let certificateChainCheck: CertificateChainClass = self.chain else {
                self.currentState = .notAuthenticated
                self.updateAuthToken(self.delegate?.newAuthTokenRequired())
                return
            }
            
            uiDelegate?.showUnlockScreenSuccess(LockManager(self.apiClient),
                                                readerType: self.readerType,
                                                delegate: self.delegate,
                                                controlDelegate: self.doordeckControl,
                                                apiClient: self.apiClient,
                                                chain: certificateChainCheck,
                                                sodium: self.sodium)
            
        } else {
            return
        }
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
        if sdk {
            showUnlockScreenSuccess()
        } else {
            self.delegate?.authenticated()
        }
    }
    
    func verificationUnsuccessful() {
        self.currentState = .verificationRequired
    }
}

