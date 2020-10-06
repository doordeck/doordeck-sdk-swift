//
//  AuthTokenClass.swift
//  doordeck-sdk-swift
//
//  Copyright © 2019 Doordeck. All rights reserved.
//

import Foundation

/// Auth token struct
public struct AuthTokenClass {
    fileprivate var token: String!
    
    /// init
    ///
    /// - Parameter token: auth token from the host app
    public init(_ token: String) {
        self.token = token
    }
    
    /// return token stored
    ///
    /// - Returns: return token
    public func getToken() -> String {
        return token
    }
    
}
