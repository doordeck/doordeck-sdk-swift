//
//  DoordeckSDKUIViewController.swift
//  doordeck-sdk-swift-sample
//
//  Created by Marwan on 03/07/2019.
//  Copyright © 2019 Doordeck. All rights reserved.
//

import UIKit
import DoordeckSDK

class DoordeckSDKUI: DoordeckUI {

    func openVerificationStoryboard(_ delegate: DoordeckInternalProtocol,
                                    sdkMode: Bool,
                                    controlDelegate: DoordeckControl?,
                                    doordeck: DoordeckSDK.Doordeck)  {

        guard let view : UIViewController = UIApplication.topViewController() else { return }

        let vc = getVerificationScreen(delegate,
                                       controlDelegate: controlDelegate,
                                       doordeck: doordeck)

        let navigationController = UINavigationController(rootViewController: vc)
        navigationController.isNavigationBarHidden = true
        if sdkMode == false {
            view.addChild(navigationController)
        } else {
            view.present(navigationController, animated: true, completion: nil)
        }
    }

    func getVerificationScreen(_ delegate: DoordeckInternalProtocol,
                                 controlDelegate: DoordeckControl?,
                                 doordeck: DoordeckSDK.Doordeck) -> VerificationViewController {

        let storyboard : UIStoryboard = UIStoryboard(name: "VerificationStoryboard", bundle: Bundle(for: type(of: self)))
        let vc : VerificationViewController = storyboard.instantiateViewController(withIdentifier: "VerificationNoNavigation") as! VerificationViewController
        vc.delegate = delegate
        vc.doordeck = doordeck
        vc.controlDelegate = controlDelegate

        return vc
    }

    func showUnlockScreenSuccess (_ readerType: Doordeck.ReaderType,
                                    delegate: DoordeckProtocol?,
                                    controlDelegate: DoordeckControl?,
                                    doordeck: DoordeckSDK.Doordeck) {

        guard let view : UIViewController = UIApplication.topViewController() else { return }

        let quickEntryView = getQuickEntryVC(readerType,
                                             delegate: delegate,
                                             controlDelegate: controlDelegate,
                                             doordeck: doordeck)

        let navigationController = UINavigationController(rootViewController: quickEntryView)
        navigationController.isNavigationBarHidden = true
        view.present(navigationController, animated: true, completion: nil)
    }

    func getQuickEntryVC(_ readerType: Doordeck.ReaderType,
                         delegate: DoordeckProtocol?,
                         controlDelegate: DoordeckControl?,
                         doordeck: DoordeckSDK.Doordeck) -> QuickEntryViewController {

        let storyboard : UIStoryboard = UIStoryboard(name: "QuickEntryStoryboard", bundle: Bundle(for: type(of: self)))
        let vc : QuickEntryViewController = storyboard.instantiateViewController(withIdentifier: "QuickEntryNoNavigation") as! QuickEntryViewController
        vc.readerType = readerType
        vc.delegate = delegate
        vc.controlDelegate = controlDelegate
        vc.doordeck = doordeck

        return vc
    }
}
