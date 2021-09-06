//
//  AppStringsSDKExtension.swift
//  Doordeck
//
//  Created by Marwan on 10/05/2019.
//  Copyright © 2019 Doordeck. All rights reserved.
//

import Foundation

extension AppStrings {
    
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
        case .delayUnlock:
            return AppStrings.delayUnlock
        case .unlockFail:
            return AppStrings.unlockFail
        case .gpsFailed:
            return AppStrings.gpsFailed
        case .gpssuccess:
            return AppStrings.gpssuccess
        case .gpsSearching:
            return AppStrings.gpsSearching
        case .gpsUnauthorized:
            return AppStrings.gpsUnauthorized
        case .timeWindowsuccess:
            return AppStrings.timeWindowsuccess
        case .timeWindowFailed:
            return AppStrings.timeWindowFailed
        case .other:
            return AppStrings.other
        case .lockInfoRetrieved:
            return AppStrings.lockInfoRetrieved
        case .lockInfoRetrievalFailed:
            return AppStrings.lockInfoRetrievalFailed
        }
    }
}
