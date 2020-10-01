//
//  URLManager.swift
//  doordeck-sdk-swiftTests
//
//  Created by Marwan on 26/03/2019.
//  Copyright © 2019 Doordeck. All rights reserved.
//

import XCTest

class URLManagerTests: XCTestCase {
    
    func testRegistrationWithKey()  {
        let registrationURL = URLManager.registrationWithKey()
        XCTAssertEqual(registrationURL,"https://api.dev.doordeck.com/auth/certificate" )
    }
    
    func testGetDeviceForTile()  {
        let uuid = UUID().uuidString
        let registrationURL = URLManager.getDeviceForTile(uuid)
        XCTAssertEqual(registrationURL,"https://api.dev.doordeck.com/tile/\(uuid)" )
    }

    func testUpdateLock()  {
        let uuid = UUID().uuidString
        let registrationURL = URLManager.updateLock(uuid)
        XCTAssertEqual(registrationURL,"https://api.dev.doordeck.com/device/\(uuid)" )
    }
    
    func testLockContol()  {
        let uuid = UUID().uuidString
        let registrationURL = URLManager.lockContol(uuid)
        XCTAssertEqual(registrationURL,"https://api.dev.doordeck.com/device/\(uuid)/execute" )
    }
}
