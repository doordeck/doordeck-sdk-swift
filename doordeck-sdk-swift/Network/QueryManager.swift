//
//  QueryManager.swift
//  doordeck-sdk-swift
//
//  Copyright © 2019 Doordeck. All rights reserved.
//

import Foundation

struct QueryManager {
    
    private static let unlockTime = "unlockTime"
    static let email = "email"
    private static let password = "password"
    private static let oldPassword = "oldPassword"
    private static let newPassword = "newPassword"
    private static let name = "name"
    private static let favourite = "favourite"
    private static let key = "key"
    private static let displayName = "displayName"
    private static let colour = "colour"
    private static let inviteCode = "inviteCode"
    private static let ephemeralKey = "ephemeralKey"
    private static let verificationSignature = "verificationSignature"
    
    /// Login Query
    ///
    /// - Parameters:
    ///   - email: user email
    ///   - password: user passwors
    /// - Returns: Query object
    static func login (_ email: String,
                       password: String) -> [String: AnyObject] {
        
        return [
            self.email: email as AnyObject,
            self.password: password as AnyObject
        ]
    }
    
    /// User public key Query
    ///
    /// - Parameter key: Key as a base64 string
    /// - Returns: Query object
    static func registerKey (_ key: String) -> [String: AnyObject] {
        
        return [ self.ephemeralKey: key as AnyObject ]
    }
    
    /// User public key Query
    ///
    /// - Parameter key: Key as a base64 string
    /// - Returns: Query object
    static func checkKey (_ key: String) -> [String: AnyObject] {
        
        return [ self.verificationSignature: key as AnyObject ]
    }
    
    /// Register new user
    ///
    /// - Parameters:
    ///   - email: email address
    ///   - password: password
    ///   - displayName: display name of user
    /// - Returns: Query object
    static func register (_ email: String,
                          password: String,
                          displayName: String) -> [String: AnyObject] {
        
        return [
            self.email: email as AnyObject,
            self.password: password as AnyObject,
            self.displayName: displayName as AnyObject
        ]
    }
    
    /// register invitation
    ///
    /// - Parameters:
    ///   - email: email
    ///   - password: password
    ///   - displayName: display name of user
    ///   - inviteCode: invite code
    /// - Returns: Query object
    static func registerInvitation (_ email: String,
                                    password: String,
                                    displayName: String,
                                    inviteCode: String) -> [String: AnyObject] {
        
        return [
            self.email: email as AnyObject,
            self.password: password as AnyObject,
            self.displayName: displayName as AnyObject,
            self.inviteCode: inviteCode as AnyObject
        ]
    }
    
    /// Change password
    ///
    /// - Parameters:
    ///   - oldPassword: old pass
    ///   - newPassword: new password
    /// - Returns: Query object
    static func changePassword (_ oldPassword: String,
                                newPassword: String) -> [String: AnyObject] {
        
        return [
            self.oldPassword: oldPassword as AnyObject,
            self.newPassword: newPassword as AnyObject
        ]
    }
    
    /// Update user display name
    ///
    /// - Parameter displayName: dispaly name
    /// - Returns: Query object
    static func updateDisplayName (_ displayName: String) -> [String: AnyObject] {
        
        return [ self.displayName: displayName as AnyObject ]
    }
    
    /// Add lock
    ///
    /// - Parameters:
    ///   - name: name
    ///   - key: key
    ///   - time: time
    /// - Returns: Query object
    static func addLock (_ name: String,
                         key: String,
                         time: Int) -> [String: AnyObject] {
        
        return [
            self.name: name as AnyObject,
            self.key: key as AnyObject,
            self.unlockTime: time as AnyObject
        ]
    }
    
    /// update device details
    ///
    /// - Parameters:
    ///   - name: name
    ///   - favourite: favorite device
    ///   - colour: colour
    /// - Returns: Query object
    static func updateLock (_ name: String,
                            favourite: Bool,
                            colour: String) -> [String: AnyObject] {
        
        return [
            self.name: name as AnyObject,
            self.favourite: favourite as AnyObject,
            self.colour: colour as AnyObject
        ]
    }
    
    /// update lock name
    ///
    /// - Parameter name: name
    /// - Returns: Query object
    static func updateLockName (_ name: String) -> [String: AnyObject] {
        
        return [ self.name: name as AnyObject ]
    }
    
    static func updateLockFavourite (_ favourite: Bool) -> [String: AnyObject] {
        
        return [ self.favourite: favourite as AnyObject ]
    }
    
    static func updateLockColour (_ colour: String) -> [String: AnyObject] {
        
        return [ self.colour: colour as AnyObject ]
    }
}

class Header {
    enum HeaderType {
        case unautheticated
        case unautheticatedPem
        case refreshToken
        case token
        case tokenJson
        case integration
    }
    
    enum version {
        case v1
        case v2
        case v3
    }
    
    var token: AuthTokenClass?
    let ContentType = "Content-Type"
    let applicationJson = "application/json"
    let applicationPemFile = "application/x-pem-file"
    let applicationForm = "application/x-www-form-urlencoded"
    let authorization = "Authorization"
    let bearer = "Bearer"
    let accept = "Accept"
    let origin = "origin"
    let v2 = "application/vnd.doordeck.api-v2+json"
    let v3 = "application/vnd.doordeck.api-v3+json"
    
    /// create SDK header that would contain whats needed
    ///
    /// - Parameters:
    ///   - version: header version
    ///   - token: token
    /// - Returns: Header object
    func createSDKAuthHeader(_ version: version,
                             token: AuthTokenClass) -> [String : String] {
        
        self.token = token
        var typeHeader = getAuthSDK()
        let version = addVersion(version)
        typeHeader.merge(version, uniquingKeysWith: +)
        return typeHeader
        
    }
    
    /// Get token
    ///
    /// - Returns: returns empty dictoinary on failure other wise header
    func getAuthSDK() -> [String : String] {
        guard let authToken = token?.getToken() else {
            return [:]
        }
        return [self.authorization: "\(self.bearer) \(authToken)",
            self.ContentType: self.applicationJson ]
    }
    
    /// Api version
    ///
    /// - Parameter version: version
    /// - Returns: returns header
    func addVersion (_ version: version) -> [String : String] {
        switch version {
        case .v1 :
            return [:]
        case .v2 :
            return [self.accept: self.v2]
        case .v3 :
            return [self.accept: self.v3]
        }
    }
    
}
