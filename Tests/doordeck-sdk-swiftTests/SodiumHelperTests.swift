//
//  SodiumHelperTests.swift
//  doordeck-sdk-swiftTests
//
//  Created by Marwan on 05/04/2019.
//  Copyright © 2019 Doordeck. All rights reserved.
//

import XCTest
import Foundation
import Sodium

class SodiumHelperTests: XCTestCase {
    func testSodium() {
        let dummyToken = "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJzdWIiOiIxMjM0NTY3ODkwIiwibmFtZSI6IkpvaG4gRG9lIiwiaWF0IjoxNTE2MjM5MDIyLCJlbWFpbCI6IlN1cHBvcnRAZG9vcmRlY2suY29tIn0.qRnj46F2qmD5SE9HXJAhgG5V1iPrzBvL91SEG5XH5t0"
        let token = AuthTokenClass(dummyToken)
        _ = SodiumHelper(token).getPublicKey()
    }


}
