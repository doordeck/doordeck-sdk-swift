//
//  ReachabilityHelper.swift
//  doordeck-sdk-swift
//
//  Copyright © 2019 Doordeck. All rights reserved.
//

import Foundation
import Reachability

class ReachabilityHelper {
    fileprivate let reachability: Reachability?
    
    /// Reachability wrapper init
    init()
    {
        guard let tempReach = Reachability() else {
            print(PrintChannel.error, object: "Unable to create Reachability")
            reachability = nil
            return
        }
        
        reachability = tempReach
    }
    
    /// The type of connection
    var connectionType: String {
        
        return (reachability?.connection.description)!
    }
    
    /// Is it connected to Wifi
    var isConnectedToWiFi: Bool {
        return reachability?.connection == .wifi ? true : false
    }
    
    /// Is there a Data connection
    var isConnected: Bool {
        return reachability?.connection != .none ? true : false
    }
    
    /// Notification of Data drops
    func startNotifier() {
        do {
            try reachability?.startNotifier()
        } catch {
            print(PrintChannel.error, object: "Unable to start notifier")
        }
    }
    
    /// stop notifier
    func  stopNotifier() {
        reachability?.stopNotifier()
    }
}
