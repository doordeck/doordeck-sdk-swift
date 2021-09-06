//
//  QuickEntryViewController.swift
//  Doordeck
//
//  Copyright © 2018 Doordeck. All rights reserved.
//

import UIKit

protocol DoordeckMultiLock {
    func failedToPick ()
    func pickedALock (lock: LockDevice)
}

class QuickEntryViewController: UIViewController {
    var lockMan: LockManager!
    var apiClient: APIClient!
    var certificateChain: CertificateChainClass!
    var delegate: DoordeckProtocol?
    var controlDelegate: DoordeckControl?
    var readerType: Doordeck.ReaderType = Doordeck.ReaderType.automatic
    var sodium: SodiumHelper!
    
    fileprivate let quickStoryboard = "QuickEntryStoryboard"
    fileprivate let bottomNFCView = "bottomViewNFC"
    fileprivate let bottomQRView = "bottomViewQR"
    fileprivate let VerificationScreen = "VerificationScreen"
    fileprivate let lockUnlockStoryboard =  "LockUnlockScreen"
    fileprivate let lockUnlockIdentifier = "LockUnlock"
    
    init(_ apiClient: APIClient,
         chain: CertificateChainClass,
         sodiumTemp: SodiumHelper) {
        
        self.sodium = sodiumTemp
        self.apiClient = apiClient
        self.certificateChain = chain
        self.lockMan = LockManager(self.apiClient)
        super.init(nibName: nil, bundle: Bundle(for: type(of: self)))
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        setUpQuickEntry()
        setupUI()
    }
    
    func setupUI() {
        view.backgroundColor = .doordeckPrimaryColour()
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return UserDefaults().getDarkUI() ? .lightContent : .default
    }
}

extension QuickEntryViewController: quickEntryDelegate {
    func showQRCode() {
        
    }
    
    func checkQuickEntryChoice() {
        setUpQuickEntry()
    }
    
    fileprivate func setUpQuickEntry() {
        if UIDevice.supportNFC() == true {
            
            if view.subviews.count > 0 {
                for view in view.subviews {
                    view.removeFromSuperview()
                }
            }
            if readerType == Doordeck.ReaderType.qr {
                addQRVC()
            } else {
                addNFCVC()
            }
        } else {
            addQRVC()
        }
    }

    fileprivate func addNFCVC () {
        if #available(iOS 11, *) {
            let storyboard: UIStoryboard = UIStoryboard(name: quickStoryboard, bundle: Bundle(for: type(of: self)) )
            let bottomViewVC = storyboard.instantiateViewController(withIdentifier: bottomNFCView) as! BottomViewController
            bottomViewVC.view.frame = self.view.frame
            bottomViewVC.view.layoutIfNeeded()
            bottomViewVC.delegate = self
            bottomViewVC.controlDelegate = self.controlDelegate
            addChild(bottomViewVC)
            self.view.addSubview(bottomViewVC.view)
            
            UIView.animate(withDuration: 0.2, delay: 0.0, options: .curveEaseIn, animations: { [weak self] () -> Void in
                self?.view.layoutIfNeeded()
                }, completion: nil)
            
        } else {
            addQRVC()
        }
    }
    
    fileprivate func addQRVC () {
        let storyboard: UIStoryboard = UIStoryboard(name: quickStoryboard, bundle: Bundle(for: type(of: self)) )
        let bottomViewVC = storyboard.instantiateViewController(withIdentifier: bottomQRView) as! BottomViewControllerQR
        bottomViewVC.view.frame = self.view.frame
        bottomViewVC.view.layoutIfNeeded()
        bottomViewVC.delegate = self
        bottomViewVC.controlDelegate = self.controlDelegate
        addChild(bottomViewVC)
        self.view.addSubview(bottomViewVC.view)
        
        UIView.animate(withDuration: 0.2, delay: 0.0, options: .curveEaseIn, animations: { [weak self]  () -> Void in
            self?.view.layoutIfNeeded()
            }, completion: nil)
    }
    
    func lockDetected(_ UUID: String) {
        showLockVerificationScreen(UUID, autoUnlock: true)
    }
    
    
    func showLockVerificationScreen(_ UUID: String, autoUnlock:Bool = false) {
        lockMan.findLock(UUID, success: { [weak self] (locks) in
            SDKEvent().event(.RESOLVE_TILE_SUCCESS)
            if locks.count == 0 {
                SDKEvent().event(.RESOLVE_TILE_FAILED)
                self?.showLockScreenFail()
                return
            } else if locks.count == 1 {
                guard let lock = locks.first else {
                    SDKEvent().event(.RESOLVE_TILE_FAILED)
                    self?.showLockScreenFail()
                    return
                }
                self?.showLockScreen(lock)
            } else {
                print(.debug, object: locks)
                self?.showMultiLockScreen(locks)
            }
        }) { [weak self] in
            SDKEvent().event(.RESOLVE_TILE_FAILED)
            self?.showLockScreenFail()
            return
        }
    }
    
    func showMultiLockScreen(_ locks: [LockDevice]) {
        let vc = MultiDoorUnlockViewController(locks, delegate: self)
        present(vc, animated: true, completion: nil)
    }
    
    func showLockScreen(_ lockTemp: LockDevice)  {
        if let vc = UIStoryboard(name: lockUnlockStoryboard, bundle: Bundle(for: type(of: self))).instantiateViewController(withIdentifier: lockUnlockIdentifier) as? LockUnlockViewController {
            vc.certificateChain = self.certificateChain
            vc.sodium = self.sodium
            vc.lockVariable = lockUnlockScreen(origin: .internalApp, lock: lockTemp)
            present(vc, animated: true, completion: nil)
        }
    }
    
    func showLockScreenFail()  {
        if let vc = UIStoryboard(name: lockUnlockStoryboard, bundle: Bundle(for: type(of: self))).instantiateViewController(withIdentifier: lockUnlockIdentifier) as? LockUnlockViewController {
            vc.certificateChain = self.certificateChain
            vc.sodium = self.sodium
            present(vc, animated: true, completion: nil)
        }
    }
}


extension QuickEntryViewController: DoordeckMultiLock {
    func failedToPick() {
        SDKEvent().event(.RESOLVE_TILE_FAILED)
        self.showLockScreenFail()
    }
    
    func pickedALock(lock: LockDevice) {
        self.showLockScreen(lock)
    }
}
