//
//  LockDevice.swift
//  doordeck-sdk-swift
//
//  Copyright © 2019 Doordeck. All rights reserved.
//

import Foundation
import UIKit
import CoreLocation

struct VisitorPass {
    var tempLock = false
    var startDate: Int? = nil
    var endDate: Int? = nil
}

struct LocationServices {
    var accuracy = 200
    var enabled = false
    var latitude: Double = 0.0
    var longitude: Double = 0.0
    var radius = 0
}

class LockDevice {
    
    enum currentUnlockProgress {
        case lockInitilized
        case lockConnecting
        case lockConnected
        case lockDisconnected
        case lockOffline
        case lockUnlocked
        case unlockSuccess
        case unlockFail
        case gpsFailed
        case gpssuccess
        case gpsSearching
        case gpsUnauthorized
        case timeWindowsuccess
        case timeWindowFailed
        case other
    }
    
    enum lockSizeOptions {
        case large
        case medium
        case small
    }
    
    fileprivate var apiClient: APIClient!
    var ID: String = "00000000-0000-0000-0000-000000000000"
    var name: String = "Home"
    var admin: Bool = false
    var locked: Bool = true
    var connected: Bool = true
    var unlockTime: Float = 20.00
    var favourite: Bool = false
    var colour: UIColor = UIColor.doorBlue()
    var tiles: [String] = []
    
    var currentlyLocked: Bool = true
    var expireTime: Data? = nil
    var visitorLock: VisitorPass?
    var locationServices: LocationServices?
    
    var indexPath: IndexPath?
    
    var locksize: lockSizeOptions = .small
    
    var countDownTimer: Timer = Timer()
    var countDownTime : Int = 20
    
    var gpsCountDownTimer: Timer = Timer()
    
    var completion: (([AnyObject]?, LockManager.deviceError?) -> Void)? 
    var progress: ((Double) -> Void)?
    var lockStatus: ((currentUnlockProgress) -> Void)?
    var reset: (() -> Void)?
    
    init(_ apiClient: APIClient) {
        self.apiClient = apiClient
    }
    
    func populateFromJson (_ lock: [String: AnyObject], index:Int, locksize: lockSizeOptions = .small,
                           completion: ([String: AnyObject]?, LockManager.deviceError?) -> Void) {
        
        guard
            let idTemp = lock["id"] as? String,
            let nameTemp = lock["name"] as? String,
            let role = lock["role"] as? String,
            let startDate = lock["start"] as AnyObject?,
            let endDate = lock["end"] as AnyObject?,
            let favouriteTemp = lock["favourite"] as? Bool,
            let settingsTemp = lock["settings"] as? [String: AnyObject],
            let unlockTimeTemp = settingsTemp["unlockTime"] as? Float,
            let stateTemp = lock["state"] as? [String: AnyObject]
            else {
                completion(nil, .invalidData)
                return
        }
        
        var locationData: [String:AnyObject] = [:]
        
        if let usageRequirements = settingsTemp["usageRequirements"] {
            if let locations: [String:AnyObject] = usageRequirements["location"] as? [String:AnyObject] {
                self.locationServices = createLocationService(locations)
                locationData = locations
            }
        }
        
        if settingsTemp.keys.contains("tiles") {
            if let tilesTemp: [String] = settingsTemp["tiles"] as? [String] {
                self.tiles = tilesTemp
            }
        }
        
        
        var connectedTemp: Bool = true
        if let connectedTempCheck = stateTemp["connected"] {
            connectedTemp = connectedTempCheck as! Bool
        }
        
        
        self.ID = idTemp
        self.name = nameTemp
        self.connected = connectedTemp
        self.unlockTime = unlockTimeTemp
        self.countDownTime = Int(round(self.unlockTime))
        self.favourite = favouriteTemp
        self.visitorLock = createTempLock(startDate, endDate: endDate)
        
        let sanatizedStartDate = !(startDate is NSNull) ? startDate : ("" as AnyObject)
        let sanatizedEndDate = !(endDate is NSNull) ? endDate : ("" as AnyObject)
        
        
        
        var colourString = UIColor.returnColourForIndex(index: index)
        if let tempColor:String = (lock["colour"] as? String) {
            colourString = tempColor
        } else {
            self.updateColour(hexColour: colourString)
        }
        
        self.colour = UIColor.hexStringToUIColor(colourString)
        
        if role == "ADMIN" {
            self.admin = true
        }
        
        self.locksize = locksize
        
        let strippedLock: [String: AnyObject] = ["ID": idTemp as AnyObject,
                                                 "name": nameTemp as AnyObject,
                                                 "connected": connectedTemp as AnyObject,
                                                 "unlockTime": unlockTimeTemp as AnyObject,
                                                 "colour": colourString as AnyObject,
                                                 "startDate": sanatizedStartDate as AnyObject,
                                                 "endtDate": sanatizedEndDate as AnyObject,
                                                 "role": role as AnyObject,
                                                 "LocationData": locationData as AnyObject,
                                                 "favourite": favouriteTemp as AnyObject]
        
        
        completion(strippedLock, nil)
    }
    
    fileprivate func createLocationService(_ location: [String:AnyObject]) -> LocationServices? {
        guard
            let accuracy = location["accuracy"] as? Int,
            let enabled = location["enabled"] as? Bool,
            let latitude = location["latitude"] as? Double,
            let longitude = location["longitude"] as? Double,
            let radius = location["radius"] as? Int else {return nil}
        
        return LocationServices (accuracy: accuracy, enabled: enabled, latitude: latitude, longitude: longitude, radius: radius)
    }
    
    func deviceConnect(_ completion: @escaping ([AnyObject]?, LockManager.deviceError?) -> Void,
                       progress: @escaping (Double) -> Void,
                       currentLockStatus: @escaping (currentUnlockProgress) -> Void,
                       reset: @escaping () -> Void ) {
        
        self.completion = completion
        self.progress = progress
        self.reset = reset
        self.lockStatus = currentLockStatus
        deviceStatusUpdate(.lockInitilized)
        print(.debug, object: "deviceConnect")
    }
    
    
    fileprivate func deviceStatusUpdate(_ status: currentUnlockProgress) {
        guard let update  = self.lockStatus else { return }
        update(status)
    }
    
    fileprivate func GPSCheck(_ success: @escaping () -> Void, fail : @escaping (LockManager.deviceError) -> Void) {
        if let locServices = locationServices {
            if locServices.enabled == true {
                deviceStatusUpdate(.gpsSearching)
                #if os(iOS)
                let connectivityManager = ReachabilityHelper()
                if !connectivityManager.isConnected {
                    self.deviceStatusUpdate(.lockOffline)
                    fail(.unsuccessfull)
                }
                #endif
                if (!WhereAmI.userHasBeenPromptedForLocationUse()) {
                    WhereAmI.sharedInstance.locationAuthorization = .inUseAuthorization
                    self.deviceStatusUpdate(.gpsFailed)
                    fail(.gpsNotDetermined)
                }
                
                WhereAmI.sharedInstance.continuousUpdate = true
                
                gpsCountDownTimer = Timer.after(15.seconds) {
                    WhereAmI.sharedInstance.stopUpdatingLocation()
                    self.deviceStatusUpdate(.gpsFailed)
                    fail(.gpsFailedPosition)
                }
                
                WhereAmI.sharedInstance.horizontalAccuracy = Double(locServices.accuracy)
                whereAmI { response in
                    
                    switch response {
                    case .locationUpdated(let watchLocation):
                        print(.debug, object: watchLocation.horizontalAccuracy)
                        WhereAmI.sharedInstance.stopUpdatingLocation()
                        self.gpsCountDownTimer.invalidate()
                        let lockLocation = CLLocation(latitude: locServices.latitude, longitude: locServices.longitude)
                        let distance = watchLocation.distance(from: lockLocation)
                        if (distance < Double(locServices.radius)) {
                            self.deviceStatusUpdate(.gpssuccess)
                            success()
                        } else {
                            self.deviceStatusUpdate(.gpsFailed)
                            fail(.gpsOutsideArea)
                        }
                    case .locationFail( _):
                        WhereAmI.sharedInstance.stopUpdatingLocation()
                        self.gpsCountDownTimer.invalidate()
                        self.deviceStatusUpdate(.gpsFailed)
                        fail(.gpsFailedPosition)
                    case .unauthorized:
                        WhereAmI.sharedInstance.stopUpdatingLocation()
                        self.gpsCountDownTimer.invalidate()
                        self.deviceStatusUpdate(.gpsUnauthorized)
                        fail(.gpsDenied)
                    }
                }
            } else {
                success()
            }
        } else {
            success()
        }
    }
    
    func deviceUnlock(_ certificatechain: CertificateChainClass, sodium: SodiumHelper, completion: @escaping ([AnyObject]?, APIClient.error?, LockManager.deviceError?) -> Void)  {
        deviceStatusUpdate(.lockConnecting)
        GPSCheck({
            if self.currentlyLocked == true {
                if  let VP = self.visitorLock {
                    if let startDateInt:Int = VP.startDate {
                        if startDateInt > Int(Date().timeIntervalSince1970) {
                            self.deviceStatusUpdate(.timeWindowFailed)
                            self.deviceCompletion(nil, error: .deviceVistorPassEarly)
                            self.deviceReset()
                            return
                        }
                    }
                    if let endDateInt:Int = VP.endDate {
                        if endDateInt < Int(Date().timeIntervalSince1970) {
                            self.deviceStatusUpdate(.timeWindowFailed)
                            self.deviceCompletion(nil, error: .deviceVistorPassExpired)
                            self.deviceReset()
                            return
                        }
                    }
                }
                
                self.currentlyLocked = false
                self.apiClient.lockUnlock(self, sodium: sodium,  chain: certificatechain,  control: .unlock, completion: { (json, error) in
                    if (error != nil) {
                        SDKEvent().event(.UNLOCK_FAILED)
                        self.currentlyLocked = true
                        self.deviceStatusUpdate(.unlockFail)
                        self.deviceCompletion(nil, error: .unsuccessfull)
                        self.deviceReset()
                    } else {
                        SDKEvent().event(.UNLOCK_SUCCESS)
                        self.deviceStatusUpdate(.unlockSuccess)
                        let expiryTime = Date().timeIntervalSince1970 + Double(self.unlockTime)
                        self.timeKeeper(expiryTime)
                    }
                })
            } else {
                self.deviceStatusUpdate(.lockUnlocked)
                self.deviceCompletion(nil, error: .deviceAlreadyUnlocked)
            }
        }) { (deviceError) in
            SDKEvent().event(.UNLOCK_FAILED)
            self.deviceStatusUpdate(.unlockFail)
            self.deviceReset()
            self.deviceCompletion(nil, error: deviceError)
        }
    }
    
    fileprivate func timeKeeper(_ expiryTime: Double) {
        #if os(iOS)
        Util().onMain {
            Util().vibrateNow()
        }
        #endif
        let currentTime = Date().timeIntervalSince1970
        let countDownTimer = expiryTime - currentTime
        startTimer(countDownTimer)
    }
    
    fileprivate func startTimer(_ countDown: Double) {
        countDownTime = Int(round(countDown))
        countDownTimer = Timer.every(1.seconds) { (timer: Timer) in
            if self.countDownTime <= 0 {
                self.stopTimer()
            } else {
                self.countDownTime = self.countDownTime - 1
                let progressView: Double = (Double(self.countDownTime) / Double(self.unlockTime))
                self.deviceProgress(progressView)
            }
        }
    }
    
    fileprivate func stopTimer() {
        countDownTimer.invalidate()
        currentlyLocked = true
        countDownTime = Int(unlockTime)
        self.deviceReset()
    }
    
    fileprivate func deviceCompletion(_ object: [AnyObject]?, error: LockManager.deviceError?) {
        guard let comp = self.completion else {
            doordeckNotifications().refreshLocks()
            return
        }
        comp(object, error)
    }
    
    fileprivate func deviceReset() {
        guard let resetDevice  = self.reset else {
            doordeckNotifications().refreshLocks()
            return
        }
        resetDevice()
    }
    
    fileprivate func deviceProgress(_ percentage: Double) {
        guard let progressDevice = self.progress else {return}
        progressDevice(percentage)
    }
    
    fileprivate func createTempLock(_ startDate: AnyObject?,
                                    endDate: AnyObject?)  -> VisitorPass {
        
        var VP = VisitorPass()
        var temp = false
        
        if startDate != nil {
            if let SD: Int = startDate as? Int {
                VP.startDate = SD
                temp = true
            }
        }
        
        if endDate != nil {
            if let ED: Int = endDate as? Int {
                VP.endDate = ED
                temp = true
            }
        }
        
        VP.tempLock = temp
        
        print(.temp, object: "Temp Lock \(String(describing: startDate)), \(String(describing: endDate)) VP \(VP)")
        return VP
    }
    
    func updateColour(hexColour: String) {
        apiClient.updateLockColour(self, colour: hexColour) { (json, error) in
            
        }
    }
}

