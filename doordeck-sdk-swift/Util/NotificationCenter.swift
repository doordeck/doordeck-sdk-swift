//
//  NotificationCenter.swift
//  doordeck-sdk-swift
//
//  Copyright © 2019 Doordeck. All rights reserved.
//

import Foundation

extension NSNotification.Name {
    static let refreshLocksName = NSNotification.Name(rawValue: "refreshLocks")
    static let logOut = NSNotification.Name(rawValue: "logOut")
    static let colourChange = NSNotification.Name(rawValue: "colourChange")
    static let readerChange = NSNotification.Name(rawValue: "readerChange")
    static let showNFCReader = NSNotification.Name(rawValue: "showNFCReader")
    static let hideNFCReader = NSNotification.Name(rawValue: "hideNFCReader")
    static let deeplinkCheck = NSNotification.Name(rawValue: "deepLinkCheck")
    static let dismissLockUnlockScreen = NSNotification.Name(rawValue: "dismissLockUnlockScreen")
    static let updateStores = NSNotification.Name(rawValue: "updateStores")
}

class doordeckNotifications {
    let nc = NotificationCenter.default
    
    func refreshLocks() {
        nc.post(name: .refreshLocksName, object: nil)
    }
    
    func logout() {
        nc.post(name: .logOut, object: nil)
    }
    
    func colourChange() {
        nc.post(name: .colourChange, object: nil)
    }
    
    func readerChange() {
        nc.post(name: .readerChange, object: nil)
    }
    
    func showNFCReader() {
        nc.post(name: .showNFCReader, object: nil)
    }
    
    func hideNFCReader() {
        nc.post(name: .hideNFCReader, object: nil)
    }
    
    func deeplinkCheck() {
        nc.post(name: .deeplinkCheck, object: nil)
    }
    
    func dismissLock() {
        nc.post(name: .dismissLockUnlockScreen, object: nil)
    }
    
    func updateStores() {
        nc.post(name: .updateStores, object: nil)
    }
}


