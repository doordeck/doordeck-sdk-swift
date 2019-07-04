//
//  DoordeckSDKUIViewController.swift
//  doordeck-sdk-swift-sample
//
//  Created by Marwan on 03/07/2019.
//  Copyright © 2019 Doordeck. All rights reserved.
//

import UIKit

class DoordeckSDKUI: DoordeckUI {
    
    func openVerificationStoryboard(_ delegate: DoordeckInternalProtocol,
                                    apiClient:APIClient,
                                    sodiumHelper: SodiumHelper )  {
        
        guard let view : UIViewController = UIApplication.topViewController() else { return }
        
        let vc = getVerificationScreen(delegate, apiClient: apiClient, sodiumHelper: sodiumHelper)
        
        let navigationController = UINavigationController(rootViewController: vc)
        navigationController.isNavigationBarHidden = true
        view.addChild(navigationController)
    }
    
    func getVerificationScreen(_ delegate: DoordeckInternalProtocol,
                               apiClient:APIClient,
                               sodiumHelper: SodiumHelper ) -> VerificationViewController {
        
        let storyboard : UIStoryboard = UIStoryboard(name: "VerificationStoryboard", bundle: nil)
        let vc : VerificationViewController = storyboard.instantiateViewController(withIdentifier: "VerificationNoNavigation") as! VerificationViewController
        vc.delegate = delegate
        vc.apiClient = apiClient
        vc.sodium = sodiumHelper
        
        return vc
    }
    
    func showUnlockScreenSuccess (_ lockManager: LockManager,
                                              readerType: Doordeck.ReaderType,
                                              delegate: DoordeckProtocol?,
                                              apiClient: APIClient,
                                              chain: CertificateChainClass,
                                              sodium: SodiumHelper) {
        
        guard let view : UIViewController = UIApplication.topViewController() else { return }
        
        let quickEntryView = getQuickEntryVC(lockManager, readerType: readerType, delegate: delegate, apiClient: apiClient, chain: chain, sodium: sodium)
        
        let navigationController = UINavigationController(rootViewController: quickEntryView)
        navigationController.isNavigationBarHidden = true
        view.present(navigationController, animated: true, completion: nil)
    }
    
    func getQuickEntryVC(_ lockManager: LockManager,
                         readerType: Doordeck.ReaderType,
                         delegate: DoordeckProtocol?,
                         apiClient: APIClient,
                         chain: CertificateChainClass,
                         sodium: SodiumHelper) -> QuickEntryViewController {
        
        let storyboard : UIStoryboard = UIStoryboard(name: "QuickEntryStoryboard", bundle: nil)
        let vc : QuickEntryViewController = storyboard.instantiateViewController(withIdentifier: "QuickEntryNoNavigation") as! QuickEntryViewController
        vc.lockMan = lockManager
        vc.readerType = readerType
        vc.delegate = delegate
        vc.apiClient = apiClient
        vc.certificateChain = chain
        vc.sodium = sodium
        
        return vc
    }
}
