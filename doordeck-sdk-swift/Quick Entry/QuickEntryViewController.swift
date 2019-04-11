//
//  QuickEntryViewController.swift
//  Doordeck
//
//  Created by Marwan on 17/12/2018.
//  Copyright © 2018 Doordeck. All rights reserved.
//

import UIKit

class QuickEntryViewController: UIViewController {
    fileprivate var lockMan: LockManager!
    var apiClient: APIClient!
    var delegate: DoordeckProtocol?
    var readerType: Doordeck.ReaderType = Doordeck.ReaderType.automatic
    
    fileprivate let quickStoryboard = "QuickEntryStoryboard"
    fileprivate let bottomNFCView = "bottomViewNFC"
    fileprivate let bottomQRView = "bottomViewQR"
    fileprivate let VerificationScreen = "VerificationScreen"
    fileprivate let lockUnlockStoryboard =  "LockUnlockScreen"
    fileprivate let lockUnlockIdentifier = "LockUnlock"
    
    init(_ apiClient: APIClient) {
        self.apiClient = apiClient
        self.lockMan = LockManager(self.apiClient)
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        setUpQuickEntry()
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
            let storyboard: UIStoryboard = UIStoryboard(name: quickStoryboard, bundle:nil )
            let bottomViewVC = storyboard.instantiateViewController(withIdentifier: bottomNFCView) as! BottomViewController
            bottomViewVC.view.frame = self.view.frame
            bottomViewVC.view.layoutIfNeeded()
            bottomViewVC.delegate = self
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
        let storyboard: UIStoryboard = UIStoryboard(name: quickStoryboard, bundle:nil )
        let bottomViewVC = storyboard.instantiateViewController(withIdentifier: bottomQRView) as! BottomViewControllerQR
        bottomViewVC.view.frame = self.view.frame
        bottomViewVC.view.layoutIfNeeded()
        bottomViewVC.delegate = self
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
        lockMan.findLock(UUID, success: { [weak self] (lock) in
            self?.showLockScreen(lock)
        }) {
            //to-do need to do something 
            return
        }
    }
    
    func showLockScreen(_ lockTemp: LockDevice)  {
        if let viewController = UIStoryboard(name: lockUnlockStoryboard, bundle: nil).instantiateViewController(withIdentifier: lockUnlockIdentifier) as? LockUnlockViewController {
            viewController.lockVariable = lockUnlockScreen(origin: .internalApp, lock: lockTemp)
            present(viewController, animated: true, completion: nil)
        }
        
    }
    
}
