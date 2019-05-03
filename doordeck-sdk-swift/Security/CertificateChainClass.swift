//
//  CertificateChainClass.swift
//  doordeck-sdk-swift-sample
//
//  Copyright © 2019 Doordeck. All rights reserved.
//

import Foundation

/// certificate chain struct
struct CertificateChainClass {
    fileprivate var certificateChain: [String:AnyObject]!
    
    /// init
    ///
    /// - Parameter certificate chain recieved on registration or 2FA
    init(_ chain: [String:AnyObject]) {
        self.certificateChain = chain
    }
    
    /// return chain stored
    ///
    /// - Returns: return certificate chain
    func getToken() -> [String:AnyObject] {
        return certificateChain
    }
    
    /// userID
    ///
    /// - Returns: will return the user ID
    func getUserID() -> String? {
        guard let userID: String = certificateChain["userId"] as? String  else {return nil}
        return userID
    }
    
    /// Certificate chain
    ///
    /// - Returns: returnes only the certificate chain
    func getCertificateCahin() -> [String]? {
        guard let chain: [String] = certificateChain["certificateChain"] as? [String]  else {return nil}
        return chain
    }
    
}
