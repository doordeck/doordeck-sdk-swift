//
//  LockUnlockViewController.swift
//  Doordeck
//
//  Copyright © 2018 Doordeck. All rights reserved.
//

import UIKit
import DoordeckSDK
import CoreLocation

/// possible errors for the device
///
/// - unsuccessfull: Unsuccessfull error on unlock
/// - gpsDenied: The device does not have permission to access the GPS
/// - gpsNotDetermined: GPS caanot be obtined
/// - gpsFailedPosition: The GPS lock has timed out or failed
/// - gpsOutsideArea: Outside the permitted area to unlock this device
enum deviceError {
    case unsuccessful
    case gpsDenied
    case gpsNotDetermined
    case gpsFailedPosition
    case gpsOutsideArea
}


struct lockUnlockScreen {
    enum executionOrigin {
        case internalApp
        case qrCamera
        case nfc
        case other
    }
    var origin: executionOrigin = .other
    var lock: LockResponse
}

class LockUnlockViewController: UIViewController {

    var lockVariable: lockUnlockScreen!
    var doordeck: DoordeckSDK.Doordeck?
    var sdk = true
    var gpsCountDownTimer: Timer = Timer()


    fileprivate var countDownTimer: Timer = Timer()
    fileprivate var minTimer: Float  = 4.0

    @IBOutlet weak var lockUpdateMessage: UILabel!
    @IBOutlet weak var dismissButton: UIButton!
    @IBOutlet weak var loadingView: unlockAnimation!

    @IBOutlet weak var backgroundColourImage: UIImageView!
    @IBOutlet weak var widthConstraints: NSLayoutConstraint!
    @IBOutlet weak var heightConstraint: NSLayoutConstraint!



    init(_ lockVariableTemp: lockUnlockScreen,
         doordeck: DoordeckSDK.Doordeck) {

        self.doordeck = doordeck
        self.lockVariable = lockVariableTemp
        super.init(nibName: nil, bundle: Bundle(for: type(of: self)))
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        view.backgroundColor = UIColor.doordeckPrimaryColour()
        dismissButton.doorButton(AppStrings.dismiss, textColour: .black, backgroundColour: .doorLightGrey(), cornerRadius: 10.0)

        guard let lockDetails = lockVariable else {
            showFailedScreen(.unsuccessful)
            return
        }
        connectDevice(lockDetails)
    }

    override var preferredStatusBarStyle: UIStatusBarStyle {
        return UserDefaults().getDarkUI() ? .lightContent : .default
    }

    func connectDevice(_ lockDestils: lockUnlockScreen) {
        self.showLoadingScreen()
        GPSCheck(lockDestils.lock) {
            self.doordeck?.lockOperations().unlock(
                unlockOperation: LockOperations.UnlockOperation(
                    baseOperation: LockOperations.BaseOperationBuilder().setLockId(lockId: lockDestils.lock.id).build(),
                    directAccessEndpoints: nil
                ),
                completionHandler: { error in
                    DispatchQueue.main.async {
                        if error != nil {
                            self.showFailedScreen(.unsuccessfull)
                        } else {
                            self.lockSuccessfullyUnlocked(lockDestils.lock)
                        }
                    }
                }
            )
        } fail: { error in
            self.showFailedScreen(error)
        }
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

    func lockSuccessfullyUnlocked(_ lock: LockResponse) {
        showUnlockedScreen()
        startTimer(lock)
    }

    func startTimer(_ lock: LockResponse) {
        if let unlockTime = lock.unlockTime?.floatValue, minTimer > unlockTime {
            minTimer = unlockTime
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

    func GPSCheck(_ lock: LockResponse,
                  success: @escaping () -> Void,
                  fail : @escaping (deviceError) -> Void) {

        guard let location = lock.settings.usageRequirements?.location else {
            success()
            return
        }

        if location.enabled == true {
            #if os(iOS)
            let connectivityManager = ReachabilityHelper()
            if !connectivityManager.isConnected {
                fail(.unsuccessful)
                return
            }
            #endif
            if (!WhereAmI.userHasBeenPromptedForLocationUse()) {
                WhereAmI.sharedInstance.locationAuthorization = .inUseAuthorization
                fail(.gpsNotDetermined)
            }

            WhereAmI.sharedInstance.continuousUpdate = true

            gpsCountDownTimer = Timer.after(15.seconds) {
                WhereAmI.sharedInstance.stopUpdatingLocation()
                fail(.gpsFailedPosition)
            }

            WhereAmI.sharedInstance.horizontalAccuracy = Double(location.accuracy)
            whereAmI { response in

                switch response {
                case .locationUpdated(let watchLocation):
                    WhereAmI.sharedInstance.stopUpdatingLocation()
                    self.gpsCountDownTimer.invalidate()
                    let lockLocation = CLLocation(latitude: location.latitude, longitude: location.longitude)
                    let distance = watchLocation.distance(from: lockLocation)
                    if (distance < Double(location.radius)) {
                        success()
                    } else {
                        fail(.gpsOutsideArea)
                    }
                case .locationFail( _):
                    WhereAmI.sharedInstance.stopUpdatingLocation()
                    self.gpsCountDownTimer.invalidate()
                    fail(.gpsFailedPosition)
                case .unauthorized:
                    WhereAmI.sharedInstance.stopUpdatingLocation()
                    self.gpsCountDownTimer.invalidate()
                    fail(.gpsDenied)
                }
            }
        } else {
            success()
        }

    }
}

extension LockUnlockViewController {
    private func showWaitScreen (_ delay: Double) {
        loadingView.addDelayTimer(delay)
    }

    private func showLoadingScreen () {
        loadingView.addLoadingAnimation()
        lockUpdateMessage.text = AppStrings.lockConnecting
    }

    private func showUnlockedScreen () {
        setNewColour(UIColor.doordeckSuccessGreen())
        loadingView.addSuccessAnimation()
        lockUpdateMessage.text = AppStrings.unlockSuccess
    }

    private func showFailedScreen (_ deviceError: deviceError) {
        startFailTimer()
        setNewColour(UIColor.doordeckFailRed())
        loadingView.addFailAnimation()
        switch(deviceError) {
        case .unsuccessful:
            lockUpdateMessage.text = AppStrings.unlockFail
            break
        case .gpsDenied, .gpsFailedPosition:
            lockUpdateMessage.text = AppStrings.gpsFailed
            break;
        case .gpsOutsideArea:
            lockUpdateMessage.text = AppStrings.gpsOutsideArea
            break;
        case .gpsNotDetermined:
            lockUpdateMessage.text = AppStrings.gpsUnauthorized
            break;
        }
    }

}

