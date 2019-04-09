//
//  AuthTokenClass.swift
//  doordeck-sdk-swift
//
//  Created by Marwan on 05/04/2019.
//  Copyright © 2019 Doordeck. All rights reserved.
//

import Foundation

public struct AuthTokenClass {
    fileprivate var token: String!
    
    public init(_ token: String) {
        self.token = token
    }
    
    public func getToken() -> String {
        return token
    }
    
}
