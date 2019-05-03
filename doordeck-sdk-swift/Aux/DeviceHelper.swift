//
//  AppStrings.swift
//  doordeck-sdk-swift
//
//  Copyright © 2019 Doordeck. All rights reserved.
//

import UIKit

public extension UIDevice {
    
    /// retruns model names of the apple device being used
    var modelName: String {
        var systemInfo = utsname()
        uname(&systemInfo)
        let machineMirror = Mirror(reflecting: systemInfo.machine)
        let identifier = machineMirror.children.reduce("") { identifier, element in
            guard let value = element.value as? Int8, value != 0 else { return identifier }
            return identifier + String(UnicodeScalar(UInt8(value)))
        }
        
        switch identifier {
        // iPod http://theiphonewiki.com/wiki/IPod
        case "iPod1,1":                                 return "iPod Touch 1"
        case "iPod2,1":                                 return "iPod Touch 2"
        case "iPod3,1":                                 return "iPod Touch 3"
        case "iPod4,1":                                 return "iPod Touch 4"
        case "iPod5,1":                                 return "iPod Touch 5"
        case "iPod7,1":                                 return "iPod Touch 6"
            
        // iPhone http://theiphonewiki.com/wiki/IPhone
        case "iPhone3,1", "iPhone3,2", "iPhone3,3":     return "iPhone 4"
        case "iPhone4,1":                               return "iPhone 4s"
        case "iPhone5,1", "iPhone5,2":                  return "iPhone 5"
        case "iPhone5,3", "iPhone5,4":                  return "iPhone 5c"
        case "iPhone6,1", "iPhone6,2":                  return "iPhone 5s"
        case "iPhone7,2":                               return "iPhone 6"
        case "iPhone7,1":                               return "iPhone 6 Plus"
        case "iPhone8,1":                               return "iPhone 6s"
        case "iPhone8,2":                               return "iPhone 6s Plus"
        case "iPhone9,1", "iPhone9,3":                  return "iPhone 7"
        case "iPhone9,2", "iPhone9,4":                  return "iPhone 7 Plus"
        case "iPhone8,4":                               return "iPhone SE"
        case "iPhone10,1", "iPhone10,4":                return "iPhone 8"
        case "iPhone10,2", "iPhone10,5":                return "iPhone 8 Plus"
        case "iPhone10,3", "iPhone10,6":                return "iPhone X"
        case "iPhone11,2":                              return "iPhone XS"
        case "iPhone11,4":                              return "iPhone XS Max"
        case "iPhone11,6":                              return "iPhone XS Max (China)"
        case "iPhone11,8":                              return "iPhone XR"
            
        // iPad http://theiphonewiki.com/wiki/IPad
        case "iPad1,1":                                  return "iPad 1"
        case "iPad2,1", "iPad2,2", "iPad2,3", "iPad2,4": return "iPad 2"
        case "iPad3,1", "iPad3,2", "iPad3,3":            return "iPad 3"
        case "iPad3,4", "iPad3,5", "iPad3,6":            return "iPad 4"
        case "iPad4,1", "iPad4,2", "iPad4,3":            return "iPad Air"
        case "iPad5,3", "iPad5,4":                       return "iPad Air 2"
        case "iPad6,11", "iPad6,12":                     return "iPad 5"
        case "iPad2,5", "iPad2,6", "iPad2,7":            return "iPad Mini"
        case "iPad4,4", "iPad4,5", "iPad4,6":            return "iPad Mini 2"
        case "iPad4,7", "iPad4,8", "iPad4,9":            return "iPad Mini 3"
        case "iPad5,1", "iPad5,2":                       return "iPad Mini 4"
        case "iPad6,3", "iPad6,4":                       return "iPad Pro 9.7 Inch"
        case "iPad6,7", "iPad6,8":                       return "iPad Pro 12.9 Inch"
        case "iPad7,1", "iPad7,2":                       return "iPad Pro 12.9 Inch 2. Generation"
        case "iPad7,3", "iPad7,4":                       return "iPad Pro 10.5 Inch"
        case "iPad8,1", "iPad8,2", "iPad8,3", "iPad8,4": return "iPad Pro 11 Inch"
        case "iPad8,5", "iPad8,6", "iPad8,7", "iPad8,8": return "iPad Pro 12.9 Inch 3. Generation"
            
        // Apple TV https://www.theiphonewiki.com/wiki/Apple_TV
        case "AppleTV5,3":                              return "Apple TV"
        case "AppleTV6,2":                              return "Apple TV 4K"
        case "AudioAccessory1,1":                       return "HomePod"
            
        // Simulator
        case "i386", "x86_64":                          return "Simulator"
        default:                                        return identifier
        }
    }
    
    /// does the device support NFC
    ///
    /// - Returns: True if it supports NFC
    class func supportNFC() -> Bool {
        var NFC = false
        let device = UIDevice.current.modelName
        if #available(iOS 11, *) {
            if (
                //iphones
                device == "iPhone 5s" ||
                    device == "iPhone 6" ||
                    device == "iPhone 6 Plus" ||
                    device == "iPhone 6s" ||
                    device == "iPhone 6s Plus" ||
                    device == "iPhone SE" ||
                    
                    // ipods
                    device == "iPod Touch 1" ||
                    device == "iPod Touch 2" ||
                    device == "iPod Touch 3" ||
                    device == "iPod Touch 4" ||
                    device == "iPod Touch 5" ||
                    device == "iPod Touch 6" ||
                    
                    // ipads
                    device == "iPad 1" ||
                    device == "iPad 2" ||
                    device == "iPad 3" ||
                    device == "iPad 4" ||
                    device == "iPad Air" ||
                    device == "iPad Air 2" ||
                    device == "iPad 5" ||
                    device == "iPad Mini" ||
                    device == "iPad Mini 2" ||
                    device == "iPad Mini 3" ||
                    device == "iPad Mini 4" ||
                    device == "iPad Pro 9.7 Inch" ||
                    device == "iPad Pro 12.9 Inch" ||
                    device == "iPad Pro 12.9 Inch 2. Generation" ||
                    device == "iPad Pro 10.5 Inch" ||
                    device == "iPad Pro 11 Inch" ||
                    device == "iPad Pro 12.9 Inch 3. Generation" ||
                    
                    // Aux
                    device == "Apple TV" ||
                    device == "Apple TV 4K" ||
                    device == "HomePod" ||
                    
                    // simulator
                    device == "Simulator") {
                
                NFC = false
            } else {
                NFC = true
            }
        } else {
            NFC = false
        }
        return NFC
    }
    
}
