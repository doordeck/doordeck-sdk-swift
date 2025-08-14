//
//  InitializeDoordeck.swift
//  doordeck-sdk-swift
//
//  Copyright © 2019 Doordeck. All rights reserved.
//

import Foundation
import DoordeckSDK

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
                                    doordeck: DoordeckSDK.Doordeck)
    
    func showUnlockScreenSuccess (_ readerType: Doordeck.ReaderType,
                                  delegate: DoordeckProtocol?,
                                  controlDelegate: DoordeckControl?,
                                  doordeck: DoordeckSDK.Doordeck)
}

protocol DoordeckInternalProtocol {
    func verificationSuccessful()
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
    var readerType: ReaderType = ReaderType.automatic
    var doordeckSDK: DoordeckSDK.Doordeck
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
                closeButton: Bool = false) async {
        
        doordeckSDK = try! await KDoordeckFactory().initialize(sdkConfig: SdkConfig.Builder().setCloudAuthToken(cloudAuthToken: token.getToken()).build())
        setKeyPairIfNeeded()
        
        #if os(iOS)
        self.uiDelegate = DoordeckSDKUI()
        #endif
        self.doordeckControl = DoordeckControl(showCloseButton: closeButton)
        darkModeActive(darkMode)
    }
    
    /// Use this method to pre-initialise the server checks, this will make unlocking faster.
    public func Initialize() {
        switch currentState {
        case .authenticated:
            self.delegate?.authenticated()
            break
        case .notAuthenticated:
            self.updateAuthToken(self.delegate?.newAuthTokenRequired())
            break
        case .verificationRequired:
            self.delegate?.verificationNeeded()
            break
        }
    }
    
    /// This method can be used to push tile UUID to the SDK to process
    ///
    /// - Parameters:
    ///   - tileID: Tile UUID is UUID for a tile from a deeplink or QR or background NFC
    public func unlockTileID (_ tileID: String) {
        NotificationCenter.default.post(name: .deeplinkSDKCheck, object: tileID)
    }
    
    /// Dark mode
    ///
    /// - Parameter bool: set dark mode on init. 
    private func darkModeActive (_ bool: Bool) {
        UserDefaults.setDarkUI(bool)
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
                                                   doordeck: doordeckSDK)
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
        switch currentState {
        case .authenticated:
            success()
            self.showUnlockScreenSuccess()
            break
        case .notAuthenticated:
            fail()
            self.updateAuthToken(self.delegate?.newAuthTokenRequired())
            break
        case .verificationRequired:
            fail()
            self.showVerificationScreen(success, fail: fail)
            self.delegate?.verificationNeeded()
            break
        }
    }
    
    
    /// If a token is invalid the delegate will request a new token from the host app.
    ///
    /// - Parameter token: new AuthTokenClass from the Host application
    func updateAuthToken (_ token: AuthTokenClass?) {
        guard let tokenTemp: AuthTokenClass = token else { return }
        doordeckSDK.contextManager().setCloudAuthToken(token: tokenTemp.getToken())
    }
    
    var currentState: State {
        if (doordeckSDK.contextManager().isCloudAuthTokenInvalidOrExpired()) {
            return .notAuthenticated
        } else if (doordeckSDK.contextManager().isCertificateChainInvalidOrExpired()) {
            return .verificationRequired
        } else {
            return .authenticated
        }
    }
    
    /// Show unlock reader, this will be added to the top view controller.
    fileprivate func showUnlockScreenSuccess () {
        if #available(iOS 10, *) {
            guard let certificateChainCheck: [String] = doordeckSDK.contextManager().getCertificateChain() else {
                self.updateAuthToken(self.delegate?.newAuthTokenRequired())
                return
            }
            
            uiDelegate?.showUnlockScreenSuccess(self.readerType,
                                                delegate: self.delegate,
                                                controlDelegate: self.doordeckControl,
                                                doordeck: doordeckSDK)
            
        } else {
            return
        }
    }
    
    private func setKeyPairIfNeeded() {
        if (doordeckSDK.contextManager().getKeyPair() == nil) {
            let newKeyPair = doordeckSDK.crypto().generateKeyPair()
            doordeckSDK.contextManager().setKeyPair(
                publicKey: newKeyPair.public_,
                privateKey: newKeyPair.private_
            )
        }
    }
}

extension Doordeck: DoordeckInternalProtocol {
    func verificationSuccessful() {
        SDKEvent().event(.GET_CERTIFICATE_SUCCESS)
        if sdk {
            showUnlockScreenSuccess()
        } else {
            self.delegate?.authenticated()
        }
    }
    
    func verificationUnsuccessful() {
        
    }
}

