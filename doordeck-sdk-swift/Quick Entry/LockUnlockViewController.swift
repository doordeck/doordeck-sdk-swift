//
//  LockUnlockViewController.swift
//  Doordeck
//
//  Copyright © 2018 Doordeck. All rights reserved.
//

import UIKit

struct lockUnlockScreen {
    enum executionOrigin {
        case internalApp
        case qrCamera
        case nfc
        case other
    }
    var origin: executionOrigin = .other
    var lock: LockDevice
}

class LockUnlockViewController: UIViewController {
    var lockVariable: lockUnlockScreen!
    var certificateChain: CertificateChainClass!
    var sodium: SodiumHelper!
    
    
    fileprivate var countDownTimer: Timer = Timer()
    fileprivate var minTimer: Float  = 2.0
    
    @IBOutlet weak var lockUpdateMessage: UILabel!
    @IBOutlet weak var lockNameLabel: UILabel!
    @IBOutlet weak var dismissButton: UIButton!
    @IBOutlet weak var loadingView: unlockAnimations!
    
    init(_ lockVariableTemp: lockUnlockScreen,
         chain: CertificateChainClass, sodiumTemp: SodiumHelper) {
        self.sodium = sodiumTemp
        self.certificateChain = chain
        self.lockVariable = lockVariableTemp
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        guard let lockDetails = lockVariable else {return}
        connectDevice(lockDetails)
        readyDevice(lockDetails)
        
        dismissButton.doorButton(AppStrings.dismiss, textColour: .black, backgroundColour: .doorLightGrey(), cornerRadius: 10.0)
    }
    
    func connectDevice(_ lockDestils: lockUnlockScreen) {
        lockDestils.lock.deviceConnect({ (json, deviceError) in
            if (deviceError != nil) {
                
            }
            
            print(.lock, object: "json \(String(describing: json)) error \(String(describing: deviceError))")
        }, progress: { (progress) in
            //                print(.lock, object: "progress \(progress)")
        }, currentLockStatus: { [weak self] (update) in
            if update == .lockConnecting {
                self?.showLoadingScreen()
            }
                        if update == .unlockSuccess {
                            self?.lockSuceesfullyUnlocked(lockDestils.lock)
                        }
                        if update == .unlockFail {
                            self?.showFailedScreen()
                        }
            print(.lock, object: "progress \(update)")
            let updateString = AppStrings.messageForLockProgress(update)
            self?.lockUpdateMessage.attributedText = NSAttributedString.doorStandard(updateString, colour: .black)
            }, reset: {
                self.dismiss(animated: true, completion: {
                    
                })
        })
    }
    
    @IBAction func dismissButtonClicked() {
        countDownTimer.invalidate()
        self.dismiss(animated: true, completion: nil)
    }
    
    func readyDevice(_ lockDestils: lockUnlockScreen) {
        switch lockDestils.origin {
        case .internalApp, .nfc , .qrCamera :
            unlock(true, lock: lockDestils.lock)
        default:
            unlock(false, lock: lockDestils.lock)
        }
    }
    
    func unlock(_ autoUnlock: Bool, lock: LockDevice) {
        lock.deviceUnlock(certificateChain, sodium: sodium) { [weak self]  (data, apiError, deviceError) in
            self?.showLoadingScreen()
        }
    }
    
    
    
    func lockSuceesfullyUnlocked(_ lock: LockDevice) {
        showUnlockedScreen()
        startTimer(lock)
    }
    
    func startTimer(_ lock: LockDevice) {
        if minTimer > lock.unlockTime {
            minTimer = lock.unlockTime
        }
        
        countDownTimer = Timer.after(Double(minTimer).second, { [weak self] in
            self?.dismissButtonClicked()
        })
    }
}


extension LockUnlockViewController {
    private func showLoadingScreen () {
        loadingView.addLoadingAnimation()
    }
    
    private func showUnlockedScreen () {
        loadingView.addSuccessAnimation()
        
    }
    
    private func showFailedScreen () {
        loadingView.addFailAnimation()
    }
    
}
