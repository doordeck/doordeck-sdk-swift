//
//  AppStrings.swift
//  doordeck-sdk-swift
//
//  Copyright © 2019 Doordeck. All rights reserved.
//

import Foundation

/// Strings used by Doordeck.
struct AppStrings {
    static let error: String = NSLocalizedString("Error", comment: "")
    static let ok: String = NSLocalizedString("OK", comment: "")
    static let readerNotSupported: String = NSLocalizedString("Reader not supported by the current device", comment: "")
    static let NFCScanMessage: String = NSLocalizedString("Click to NFC Scan.", comment: "")
    static let touchNFC: String = NSLocalizedString("Touch NFC", comment: "")
    static let touchNFCMessage: String = NSLocalizedString("Touch the screen to activate the scanner, Then touch the NFC Tile next to the door to unlock", comment: "")
    
    static let touchQR: String = NSLocalizedString("Scan QR", comment: "")
    static let touchQRMessage: String = NSLocalizedString("Please scan the QR Tile next to the door to unlock", comment: "")
    
    static let dismiss: String = NSLocalizedString("Dismiss", comment: "")
    
    // verification Screen
    static let resendCode: String = NSLocalizedString("RE-SEND CODE", comment: "")
    static let send: String = NSLocalizedString("SEND", comment: "")
    static let verificationTitle: String = NSLocalizedString("Verify your new device", comment: "")
    static let verification: String = NSLocalizedString("Enter the verification code that has been sent to you", comment: "")
    
    // lock updates
    static let lockInitilized: String = NSLocalizedString("Lock initilised", comment: "")
    static let lockConnecting: String = NSLocalizedString("Connecting to lock", comment: "")
    static let lockConnected: String = NSLocalizedString("Lock connected", comment: "")
    static let lockDisconnected: String = NSLocalizedString("Lock disconnected", comment: "")
    static let lockOffline: String = NSLocalizedString("Lock offline", comment: "")
    static let lockUnlocked: String = NSLocalizedString("Lock ulocked", comment: "")
    static let unlockSuccess: String = NSLocalizedString("Unlock success", comment: "")
    static let delayUnlock: String = NSLocalizedString("Please wait", comment: "")
    static let unlockFail: String = NSLocalizedString("Unlock failed", comment: "")
    static let gpsFailed: String = NSLocalizedString("GPS failed", comment: "")
    static let gpssuccess: String = NSLocalizedString("GPS success", comment: "")
    static let gpsSearching: String = NSLocalizedString("GPS searching", comment: "")
    static let gpsUnauthorized: String = NSLocalizedString("GPS usage is unauthorised", comment: "")
    static let timeWindowsuccess: String = NSLocalizedString("Timer success", comment: "")
    static let timeWindowFailed: String = NSLocalizedString("Timer failed", comment: "")
    static let other: String = NSLocalizedString("Other errors", comment: "")
    static let nfcString: String = NSLocalizedString("Touch tile to unlock", comment: "")
}
