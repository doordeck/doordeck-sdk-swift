//
//  TokenHelperTests.swift
//  doordeck-sdk-swiftTests
//
//  Created by Marwan on 06/04/2019.
//  Copyright © 2019 Doordeck. All rights reserved.
//

import XCTest

class TokenHelperTests: XCTestCase {
    
    let dummyToken = "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJzdWIiOiIxMjM0NTY3ODkwIiwibmFtZSI6IkpvaG4gRG9lIiwiaWF0IjoxNTE2MjM5MDIyLCJlbWFpbCI6IlN1cHBvcnRAZG9vcmRlY2suY29tIn0.qRnj46F2qmD5SE9HXJAhgG5V1iPrzBvL91SEG5XH5t0"
    
    func testGetUserID() {
        let authToken = AuthTokenClass(dummyToken)
        let userID = TokenHelper(authToken).returnUserID()
        
        XCTAssertEqual(userID,"1234567890")
    }
    
    func testGetEmail() {
        let authToken = AuthTokenClass(dummyToken)
        let email = TokenHelper(authToken).returnUserEmail()
        
        XCTAssertEqual(email,"Support@doordeck.com")
    }
    
    
    func testTokenActiveTrue() {
      let dummyTokenTimeLeft = "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJzdWIiOiIxMjM0NTY3ODkwIiwibmFtZSI6IkpvaG4gRG9lIiwiaWF0IjoxNTE2MjM5MDIyLCJlbWFpbCI6IlN1cHBvcnRAZG9vcmRlY2suY29tIiwiZXhwIjoxNzc1NDM2NjY2fQ.ejQYldsLGGjfhZXbtRkmojYpD9uCkDBA5tyOPAymk3M"
        
        let authToken = AuthTokenClass(dummyTokenTimeLeft)
        TokenHelper(authToken).tokenActive({
            XCTAssertTrue(true)
        }) {
            XCTAssertTrue(false)
        }
    }
    
    func testTokenActiveFalse() {
        let dummyTokenTimeLeft = "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJzdWIiOiIxMjM0NTY3ODkwIiwibmFtZSI6IkpvaG4gRG9lIiwiaWF0IjoxNTE2MjM5MDIyLCJlbWFpbCI6IlN1cHBvcnRAZG9vcmRlY2suY29tIiwiZXhwIjoxMzAyMDUxMDY2fQ.58I8HW7keMqNv5tH6Mtl9QZZS2JvBK8Mv47jFbyWkhQ"
        
        let authToken = AuthTokenClass(dummyTokenTimeLeft)
        TokenHelper(authToken).tokenActive({
            XCTAssertTrue(false)
        }) {
            XCTAssertTrue(true)
        }
    }
    
    func testCreateTokenBody() {
        let dict: [String : Any] = ["sub": "1234567890",
                    "name": "John Doe",
                    "iat": 1516239022,
                    "email": "Support@doordeck.com",
                    "exp": 1302051066]
        
        let authToken = AuthTokenClass(dummyToken)
        let body = TokenHelper(authToken).createTokenBody(dict)
        XCTAssertEqual(body,"ewogICJlbWFpbCIgOiAiU3VwcG9ydEBkb29yZGVjay5jb20iLAogICJleHAiIDogMTMwMjA1MTA2NiwKICAiaWF0IiA6IDE1MTYyMzkwMjIsCiAgIm5hbWUiIDogIkpvaG4gRG9lIiwKICAic3ViIiA6ICIxMjM0NTY3ODkwIgp9")
    }


}
