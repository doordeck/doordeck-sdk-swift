//
//  QuickEntryViewController.swift
//  Doordeck
//
//  Copyright © 2018 Doordeck. All rights reserved.
//

import UIKit
import DoordeckSDK

protocol DoordeckMultiLock {
    func failedToPick ()
    func pickedALock (lock: LockResponse)
}

class QuickEntryViewController: UIViewController {
    var doordeck: DoordeckSDK.Doordeck?
    var delegate: DoordeckProtocol?
    var controlDelegate: DoordeckControl?
    var readerType: Doordeck.ReaderType = Doordeck.ReaderType.automatic

    fileprivate let quickStoryboard = "QuickEntryStoryboard"
    fileprivate let bottomNFCView = "bottomViewNFC"
    fileprivate let bottomQRView = "bottomViewQR"
    fileprivate let VerificationScreen = "VerificationScreen"
    fileprivate let lockUnlockStoryboard =  "LockUnlockScreen"
    fileprivate let lockUnlockIdentifier = "LockUnlock"

    init(_ doordeck: DoordeckSDK.Doordeck) {

        self.doordeck = doordeck
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

    override func viewDidLoad() {
        super.viewDidLoad()
        setupNotifications()
    }

    func setupNotifications() {
        let notificationCenter = NotificationCenter.default
        notificationCenter.addObserver(self,
                                       selector: #selector(appWillResignActive),
                                       name: UIApplication.didEnterBackgroundNotification,
                                       object: nil)

        notificationCenter.addObserver(self,
                                       selector: #selector(deeplinkCheck(_:)),
                                       name: .deeplinkSDKCheck,
                                       object: nil)
    }

    @objc func deeplinkCheck(_ notification: NSNotification) {
        if let tileUUID = notification.object as? String {
            lockDetected(tileUUID)
        }
    }

    @objc func appWillResignActive() {
        self.dismiss(animated: true, completion: nil)
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
        doordeck?.tiles().getLocksBelongingToTile(tileId: UUID) { locksResponse, error in
            if (error != nil) {
                SDKEvent().event(.RESOLVE_TILE_FAILED)
                self.showLockScreenFail()
            } else {
                guard let deviceIds = locksResponse?.deviceIds else {
                    self.showLockScreenFail()
                    return
                }

                SDKEvent().event(.RESOLVE_TILE_SUCCESS)

                self.getLockResponses(for: deviceIds) { lockResponses, error in
                    if (error != nil) {
                        self.showLockScreenFail()
                    } else {
                        if (lockResponses.count == 0) {
                            SDKEvent().event(.RESOLVE_TILE_FAILED)
                            self.showLockScreenFail()
                        } else if (lockResponses.count == 1) {
                            guard let lock = lockResponses.first else {
                                SDKEvent().event(.RESOLVE_TILE_FAILED)
                                self.showLockScreenFail()
                                return
                            }
                            self.showLockScreen(lock)
                        } else {
                            print(.debug, object: lockResponses)
                            self.showMultiLockScreen(lockResponses)
                        }
                    }
                }

            }
        }
    }

    func showMultiLockScreen(_ locks: [LockResponse]) {
        let vc = MultiDoorUnlockViewController(locks, delegate: self)
        present(vc, animated: true, completion: nil)
    }

    func showLockScreen(_ lockTemp: LockResponse)  {
        if let vc = UIStoryboard(name: lockUnlockStoryboard, bundle: Bundle(for: type(of: self))).instantiateViewController(withIdentifier: lockUnlockIdentifier) as? LockUnlockViewController {
            vc.doordeck = doordeck
            vc.lockVariable = lockUnlockScreen(origin: .internalApp, lock: lockTemp)
            present(vc, animated: true, completion: nil)
        }
    }

    func showLockScreenFail()  {
        if let vc = UIStoryboard(name: lockUnlockStoryboard, bundle: Bundle(for: type(of: self))).instantiateViewController(withIdentifier: lockUnlockIdentifier) as? LockUnlockViewController {
            present(vc, animated: true, completion: nil)
        }
    }

    private func getLockResponses(
        for lockIds: [String],
        completion: @escaping ([LockResponse], Error?) -> Void
    ) {
        let group = DispatchGroup()
        var responses: [LockResponse] = []
        var capturedError: Error? = nil
        let queue = DispatchQueue(label: "lockResponses.sync")

        for id in lockIds {
            group.enter()
            doordeck?.lockOperations().getSingleLock(lockId: id) { response, error in
                queue.async {
                    if let response = response {
                        responses.append(response)
                    } else if let error = error {
                        if capturedError == nil {
                            capturedError = error
                        }
                    }
                    group.leave()
                }
            }
        }

        group.notify(queue: .main) {
            completion(responses, capturedError)
        }
    }
}


extension QuickEntryViewController: DoordeckMultiLock {
    func failedToPick() {
        SDKEvent().event(.RESOLVE_TILE_FAILED)
        self.showLockScreenFail()
    }

    func pickedALock(lock: LockResponse) {
        self.showLockScreen(lock)
    }
}
