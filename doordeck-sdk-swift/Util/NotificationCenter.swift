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
}

class doordeckNotifications {
    let nc = NotificationCenter.default
    
    func refreshLocks() {
        nc.post(name: .refreshLocksName, object: nil)
    }
    
    func logout() {
        nc.post(name: .logOut, object: nil)
    }
}


