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
    static let lockConnecting: String = NSLocalizedString("Connecting to lock", comment: "")
    static let unlockSuccess: String = NSLocalizedString("Unlock success", comment: "")
    static let unlockFail: String = NSLocalizedString("Unlock failed", comment: "")
    static let gpsFailed: String = NSLocalizedString("GPS failed", comment: "")
    static let gpsOutsideArea: String = NSLocalizedString("GPS outside area", comment: "")
    static let gpsUnauthorized: String = NSLocalizedString("GPS usage is unauthorised", comment: "")
    static let nfcString: String = NSLocalizedString("Touch tile to unlock", comment: "")

    static let pickOne: String = NSLocalizedString("Pick a lock", comment: "")
    static let permission: String = NSLocalizedString("You have not been granted permission to this device", comment: "")
}
