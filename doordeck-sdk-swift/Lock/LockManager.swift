//
//  LockManager.swift
//  doordeck-sdk-swift
//
//  Copyright © 2019 Doordeck. All rights reserved.
//

import Foundation

/// A shareable lock object is used to share bare bones lock object
struct shareableLocks {
    var ID: String = ""
    var name: String = ""
    var locks: [LockDevice]?
}

/// The lock manager will help with organising, finding and updating locks
class LockManager {
    
    /// possible errors for the device
    ///
    /// - unsuccessfull: Unsuccessfull error on unlock
    /// - deviceAlreadyUnlocked: Device has already been unlocked and has not locked yet
    /// - deviceAlreadyLocked: Device has already been locked
    /// - gpsDenied: The device does not have permission to access the GPS
    /// - gpsNotDetermined: GPS caanot be obtined
    /// - gpsFailedPosition: The GPS lock has timed out or failed
    /// - gpsOutsideArea: Outside the permitted area to unlock this device
    /// - deviceVistorPassEarly: The visitor pass is not yet active
    /// - deviceVistorPassExpired: The visitor pass has expired
    /// - invalidToken: The Token used in invalid
    /// - invalidDevice: The device is invalid
    /// - invalidData: The data returned by the server is invalid
    enum deviceError {
        case unsuccessfull
        case deviceAlreadyUnlocked
        case deviceAlreadyLocked
        case gpsDenied
        case gpsNotDetermined
        case gpsFailedPosition
        case gpsOutsideArea
        case deviceVistorPassEarly
        case deviceVistorPassExpired
        case invalidToken
        case invalidDevice
        case invalidData
    }
    
    var locks: [LockDevice] = []
    var sites: [Site] = []
    var apiClient: APIClient!
    
    /// init of the Lock manager, a api class needs to be passed in
    ///
    /// - Parameter apiClient: Api class needs to passed in
    init(_ apiClient: APIClient) {
        self.apiClient = apiClient
    }
    
    /// Find a lock from the UUID of a "Tile"
    ///
    /// - Parameters:
    ///   - uuid: UUID of the devie
    ///   - success: The lock has been found
    ///   - fail: The lock has not been found
    func findLock(_ uuid: String,
                  success: @escaping (LockDevice) -> Void,
                  fail: @escaping () -> Void) {
        
        if let lock: LockDevice = locks.filter({$0.ID.lowercased() == uuid.lowercased()}).first {
            success(lock)
            return
        }
        
        if let lock: LockDevice = locks.filter({ $0.tiles.contains(uuid.lowercased())}).first {
            success(lock)
            return
        }
        
        for siteTemp in sites {
            if let lock: LockDevice = siteTemp.locks.filter({$0.ID.lowercased() == uuid.lowercased()}).first {
                success(lock)
                return
            }
            
            if let lock: LockDevice = siteTemp.locks.filter({ $0.tiles.contains(uuid.lowercased())}).first {
                success(lock)
                return
            }
        }
        
        guard let tokenTemp: AuthTokenClass = apiClient.token else { return }
        let header = Header().createSDKAuthHeader(.v3, token: tokenTemp)
        let apiclientTemp = APIClient(header, token: tokenTemp)
        
        apiclientTemp.getDeviceForTile(uuid) { [self] (json, error) in
            if error == nil {
                guard let jsonLock: [String: AnyObject] = json else {
                    fail()
                    return
                }
                
                if let tempLocks = jsonLock["deviceIds"] as? [String]  {
                var locksCollection: [LockDevice] = [LockDevice]()
                    for lockUUID in tempLocks{
                        let tempLock = LockDevice(self.apiClient, uuid: lockUUID)
                        locksCollection.append(tempLock)
                    }
                    print(.debug, object: locksCollection)
                    
                } else {
                    fail()
                }
                

                
            } else {
                fail()
            }
        }
        
    }
    
}
