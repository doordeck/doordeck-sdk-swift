import Foundation

struct shareableLocks {
    var ID: String = ""
    var name: String = ""
    var locks: [LockDevice]?
}

class LockManager {
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
    
    
    fileprivate var locks: [LockDevice] = []
    fileprivate var sites: [Site] = []
    var apiClient: APIClient!
    
    init(_ apiClient: APIClient) {
        self.apiClient = apiClient
    }
    
    func findLock(_ uuid: String,
                  sucess: @escaping (LockDevice) -> Void,
                  fail: @escaping () -> Void) {
        
        if let lock: LockDevice = locks.filter({$0.ID.lowercased() == uuid.lowercased()}).first {
            sucess(lock)
            return
        }
        
        for siteTemp in sites {
            if let lock: LockDevice = siteTemp.locks.filter({$0.ID.lowercased() == uuid.lowercased()}).first {
                sucess(lock)
                return
            }
        }
        
        apiClient.getDeviceForTile(uuid) { (json, error) in
            if error == nil {
                guard let jsonLock: [String: AnyObject] = json else {
                    fail()
                    return
                }
                
                let tempLock = LockDevice(self.apiClient)
                tempLock.populateFromJson(jsonLock, index: 0, completion: { (json, error) in
                    if error == nil {
                        sucess(tempLock)
                    } else {
                        fail()
                    }
                })
            } else {
                fail()
            }
        }
        
    }
    
}
