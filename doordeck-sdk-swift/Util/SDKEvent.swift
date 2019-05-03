//
//  SDKEvent.swift
//  doordeck-sdk-swift-sample
//
//  Copyright © 2019 Doordeck. All rights reserved.
//

import Foundation

class SDKEvent {
    
    enum EventAction {
        case TWO_FACTOR_AUTH_NEEDED
        case NO_INTERNET
        case INVALID_AUTH_TOKEN
        case NETWORK_ERROR
        case SDK_NETWORK_ERROR
        case CODE_VERIFICATION_SUCCESS
        case CODE_VERIFICATION_FAILED
        case UNLOCK_INVALID_TILE_ID
        case GET_CERTIFICATE_SUCCESS
        case UNLOCK_SUCCESS
        case UNLOCK_FAILED
        case RESOLVE_TILE_FAILED
        case RESOLVE_TILE_SUCCESS
        case CLOSE_QR_CODE_VIEW
        case CLOSE_NFC_VIEW
    }
    
    let nc = NotificationCenter.default
    let doordeckEventsName = NSNotification.Name(rawValue: "DoordeckEvents")
    
    func event(_ action: EventAction) {
        nc.post(name: doordeckEventsName, object: action)
    }
}
