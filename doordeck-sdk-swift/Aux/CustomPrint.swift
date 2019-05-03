//
//  AppStrings.swift
//  doordeck-sdk-swift
//
//  Copyright © 2019 Doordeck. All rights reserved.
//
import UIKit

enum PrintChannel {
    case constraints
    case lock
    case sites
    case temp
    case error
    case debug
    case token
    case beacons
    case url
    case cells
    case pushNotifications
    case widget
    case watch
    case keychain
    case deeplinking
    case share
    case NFC
    case GPS
}

fileprivate func debug () -> Bool {
#if os(iOS)
        return UIApplication.debug()
#else
        return true
#endif
}

/// print function to replace apples built in ones, channels allow you to silence certain aspects of the print
/// on anything but debug all the print is disabled.
///
/// - Parameters:
///   - channel: specify a print channel to all print only important output
///   - object: the object you would like to print to the console
func print(_ channel: PrintChannel, object: Any) {
    if debug() {
        var printOut: Bool = false
        var channelPre: String = ""
        
        switch channel {
        case .constraints:
            channelPre = "😩 Constraints"
            printOut = false
            
        case .error:
            channelPre = "❗❎❌😫😰😱😲😡❌❎❗Error"
            printOut = true
            
        case .debug:
            channelPre = "✅😍😈😎✅ Debug"
            printOut = true
            
        case .token:
            channelPre = "😋 Token"
            printOut = false
            
        case .url:
            channelPre = "😜 URL"
            printOut = false
            
        case .beacons:
            channelPre = "😜😈😍 Beacons found"
            printOut = false
            
        case .cells:
            channelPre = "😳 Cells"
            printOut = false
            
        case .pushNotifications:
            channelPre = "😎 PushNotifications"
            printOut = false
            
        case .lock:
            channelPre = "😎 Lock"
            printOut = false
            
        case .sites:
            channelPre = "✅✅ site"
            printOut = false
            
        case .widget:
            channelPre = "😩 widget"
            printOut = false
            
        case .watch:
            channelPre = "✅✅ watch ✅✅"
            printOut = false
            
        case .keychain:
            channelPre = "😱😱 Keychain 😱😱"
            printOut = false
            
        case .deeplinking:
            channelPre = "😱✅ Deeplink ✅😱"
            printOut = false
            
        case .share:
            channelPre = "😈😈😈 share 😈😈😈"
            printOut = false
            
        case .temp:
            channelPre = "😎😎😎 temp 😎😎😎"
            printOut = false
            
            
        case .NFC:
            channelPre = "😱😱😱 NFC 😱😱😱"
            printOut = false
            
        case .GPS:
            channelPre = "😱😈😱 GPS 😱😈😱"
            printOut = false
            
        }
        
        if printOut {
            print("\(channelPre) \n \(object)")
        }
    }
}


