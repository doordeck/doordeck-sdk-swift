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
}


