//
//  UIApplication.swift
//  doordeck-sdk-swift
//
//  Copyright © 2019 Doordeck. All rights reserved.
//

import UIKit

extension UIApplication {
    
    class func appVersion() -> String {
        guard let appVersion = Bundle.main.object(forInfoDictionaryKey: "CFBundleShortVersionString") as? String else { return "0000" }
        return appVersion
    }
    
    class func appBuild() -> String {
        guard let appBuild = Bundle.main.object(forInfoDictionaryKey: "CFBundleVersion") as? String else { return "0000" }
        return appBuild
    }
    
    class func targetName() -> String {
        guard let targetName = Bundle.main.object(forInfoDictionaryKey: "CFBundleName") as? String else { return "" }
        return targetName
    }
    
    
    class func versionBuild() -> String {
        let version = appVersion(), build = appBuild()
        return version == build ? "v\(version)": "v\(version)(\(build))"
    }
    
    class func uuid() -> String {
        return UIDevice.current.identifierForVendor!.uuidString
    }
    
    class func environmentCheck (_ name:String) -> Bool {
        let dic = ProcessInfo.processInfo.environment
        return dic[name] != nil
    }
    
    class func staging () -> Bool {
        //    return stagingFlag()
        return environmentCheck("Staging")
    }
    
    class func debug () -> Bool {
        //    return debugFlag()
        return environmentCheck("Debug")
    }
    
    class func stagingFlag() -> Bool {
        #if STAGING
        return true
        #else
        return false
        #endif
    }
    
    class func debugFlag() -> Bool {
        #if DEBUG
        return true
        #else
        return false
        #endif
    }
}

extension UIDevice.BatteryState: CustomStringConvertible {
    public var description: String {
        switch self {
        case .unknown:
            return "Unknown"
        case .unplugged:
            return "Unplugged"
        case .charging:
            return "Charging"
        case .full:
            return "Full"
        @unknown default:
            return "Unknown"
        }
    }
}


