//
//  AppStrings.swift
//  doordeck-sdk-swift
//
//  Created by Marwan on 28/03/2019.
//  Copyright © 2019 Doordeck. All rights reserved.
//

import Foundation

struct AppStrings {
    static let error: String = NSLocalizedString("Error", comment: "")
    static let ok: String = NSLocalizedString("OK", comment: "")
    static let readerNotSupported: String = NSLocalizedString("Reader not supported by the current device", comment: "")
    static let NFCScanMessage: String = NSLocalizedString("Click to NFC Scan.", comment: "")
    static let dismiss: String = NSLocalizedString("Dismiss", comment: "")
    
    // lock updates
    static let lockInitilized: String = NSLocalizedString("Lock initilised", comment: "")
    static let lockConnecting: String = NSLocalizedString("Connecting to lock", comment: "")
    static let lockConnected: String = NSLocalizedString("Lock connected", comment: "")
    static let lockDisconnected: String = NSLocalizedString("Lock disconnected", comment: "")
    static let lockOffline: String = NSLocalizedString("Lock offline", comment: "")
    static let lockUnlocked: String = NSLocalizedString("Lock ulocked", comment: "")
    static let unlockSuccess: String = NSLocalizedString("Unlock success", comment: "")
    static let unlockFail: String = NSLocalizedString("Unlock failed", comment: "")
    static let gpsFailed: String = NSLocalizedString("GPS failed", comment: "")
    static let gpsSucess: String = NSLocalizedString("GPS sucess", comment: "")
    static let gpsSearching: String = NSLocalizedString("GPS searching", comment: "")
    static let gpsUnauthorized: String = NSLocalizedString("GPS usage is unauthorised", comment: "")
    static let timeWindowSucess: String = NSLocalizedString("Timer sucess", comment: "")
    static let timeWindowFailed: String = NSLocalizedString("Timer failed", comment: "")
    static let other: String = NSLocalizedString("Other errors", comment: "")
    
    static func messageForLockProgress(_ progress: LockDevice.currentUnlockProgress) -> String {
        switch progress {
        case .lockInitilized:
            return AppStrings.lockInitilized
        case .lockConnecting:
            return AppStrings.lockConnecting
        case .lockConnected:
            return AppStrings.lockConnected
        case .lockDisconnected:
            return AppStrings.lockDisconnected
        case .lockOffline:
            return AppStrings.lockOffline
        case .lockUnlocked:
            return AppStrings.lockUnlocked
        case .unlockSuccess:
            return AppStrings.unlockSuccess
        case .unlockFail:
            return AppStrings.unlockFail
        case .gpsFailed:
            return AppStrings.gpsFailed
        case .gpsSucess:
            return AppStrings.gpsSucess
        case .gpsSearching:
            return AppStrings.gpsSearching
        case .gpsUnauthorized:
            return AppStrings.gpsUnauthorized
        case .timeWindowSucess:
            return AppStrings.timeWindowSucess
        case .timeWindowFailed:
            return AppStrings.timeWindowFailed
        case .other:
            return AppStrings.other
        }
    }

}
