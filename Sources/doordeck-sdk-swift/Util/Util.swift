//
//  Util.swift
//  doordeck-sdk-swift
//
//  Copyright © 2019 Doordeck. All rights reserved.
//

import Foundation
#if os(iOS)
import AudioToolbox.AudioServices
#endif

class Util {
    func onMain(_ block: @escaping () -> Void) {
        DispatchQueue.main.async(execute: block)
    }
    
    func vibrateNow () {
        #if os(iOS)
        AudioServicesPlaySystemSound(kSystemSoundID_Vibrate)
        #endif
    }
    
    func isLowPowerModeEnabled() -> Bool {
        guard ProcessInfo.processInfo.isLowPowerModeEnabled == false else { return true }
        return false
    }
    
    func getBundle() -> URL? {
        #if SWIFT_PACKAGE
        var url = Bundle.main.bundleURL
        url.appendPathComponent("doordeck-sdk-swift_doordeck-sdk-swift.bundle")
        return url
        #else
        return nil
        #endif
    }
    
    func getNSBundle() -> Bundle? {
        #if SWIFT_PACKAGE
        return Bundle(url: getBundle()!)
        #else
        return nil
        #endif
    }
    
    func getCertsFolder() -> URL {
        #if SWIFT_PACKAGE
        var url = Util().getBundle()!
        url.appendPathComponent("CER")
        return url
        #endif
    }
    
    func getStoryBoardFolder() -> URL {
        #if SWIFT_PACKAGE
        var url = Util().getBundle()!
        url.appendPathComponent("Base.lproj")
        return url
        #endif
    }
}

