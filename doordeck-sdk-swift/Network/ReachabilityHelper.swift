//
//  ReachabilityHelper.swift
//  doordeck-sdk-swift
//
//  Copyright © 2019 Doordeck. All rights reserved.
//

import Foundation
#if os(iOS)
import Reachability
#endif

class ReachabilityHelper {
    fileprivate let reachability: Reachability?
    
    /// Reachability wrapper init
    init()
    {
        do {
            let tempReach = try Reachability()
            reachability = tempReach
        } catch  {
            print(PrintChannel.error, object: "Unable to create Reachability")
            reachability = nil
            return
        }
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
        return reachability?.connection != Reachability.Connection.unavailable ? true : false
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
