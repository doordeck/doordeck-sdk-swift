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
    var sdk = true
    
    
    fileprivate var countDownTimer: Timer = Timer()
    fileprivate var minTimer: Float  = 4.0
    
    @IBOutlet weak var lockUpdateMessage: UILabel!
    @IBOutlet weak var dismissButton: UIButton!
    @IBOutlet weak var loadingView: unlockAnimation!
    
    @IBOutlet weak var backgroundColourImage: UIImageView!
    @IBOutlet weak var widthConstraints: NSLayoutConstraint!
    @IBOutlet weak var heightConstraint: NSLayoutConstraint!
    
    
    
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
        
        view.backgroundColor = UIColor.doordeckPrimaryColour()
        dismissButton.doorButton(AppStrings.dismiss, textColour: .black, backgroundColour: .doorLightGrey(), cornerRadius: 10.0)
        
        guard let lockDetails = lockVariable else {
            showFailedScreen()
            return
        }
        connectDevice(lockDetails)
        readyDevice(lockDetails)
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return UserDefaults().getDarkUI() ? .lightContent : .default
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
            
            if update == .delayUnlock {
                self?.showWaitScreen(lockDestils.lock.delayUntilUnlock)
            }
            
            if update == .unlockFail {
                self?.showFailedScreen()
            }
            
            print(.lock, object: "progress \(update)")
            let updateString = AppStrings.messageForLockProgress(update)
            self?.lockUpdateMessage.attributedText = NSAttributedString.doordeckH2Bold(updateString)
            }, reset: { [weak self] in
                self?.dismissMe()
        })
    }
    
    @IBAction func dismissButtonClicked() {
        countDownTimer.invalidate()
        dismissMe()
    }
    
    func dismissMe() {
        self.dismiss(animated: true, completion: { [weak self] in
            if self?.sdk ?? true {
                doordeckNotifications().dismissLock()
            }
        })
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
            self?.backgroundColourImage.backgroundColor = UIColor.doordeckPrimaryColour()
            self?.dismissButtonClicked()
        })
    }
    
    private func startFailTimer () {
        countDownTimer = Timer.after(Double(minTimer).second, { [weak self] in
            self?.backgroundColourImage.backgroundColor = UIColor.doordeckPrimaryColour()
            self?.dismissButtonClicked()
        })
    }
    
    private func setNewColour (_ colour: UIColor) {
        widthConstraints.constant = self.view.bounds.width * 2
        heightConstraint.constant = self.view.bounds.height * 2
        backgroundColourImage.backgroundColor = colour
        backgroundColourImage.layer.cornerRadius = 120
        
        UIView.animate(withDuration: 0.30, delay: 0.5, options: .curveEaseIn, animations: { () -> Void in
            self.view.layoutIfNeeded()
        }, completion: nil)
    }
}


extension LockUnlockViewController {
    private func showWaitScreen (_ delay: Double) {
        loadingView.addDelayTimer(delay - 1)
    }
    
    private func showLoadingScreen () {
        loadingView.addLoadingAnimation()
    }
    
    private func showUnlockedScreen () {
        setNewColour(UIColor.doordeckSuccessGreen())
        loadingView.addSuccessAnimation()
    }
    
    private func showFailedScreen () {
        startFailTimer()
        setNewColour(UIColor.doordeckFailRed())
        loadingView.addFailAnimation()
    }
    
}
