//
//  SodiumHelper.swift
//  doordeck-sdk-swift
//
//  Created by Marwan on 27/03/2019.
//  Copyright © 2019 Doordeck. All rights reserved.
//

import Foundation
import Sodium

class SodiumHelper {
    fileprivate let sodium = Sodium()
    fileprivate let service = "signingKey"
    fileprivate let name = "Doordeck"
    fileprivate var token: AuthTokenClass!
    fileprivate var tokenHelper: TokenHelper!
    
    /// Sodium wrapper for doordeck
    ///
    /// - Parameter token: Auth class needs to be passed in to correctly get the required key
    init(_ token: AuthTokenClass) {
        self.token = token
        self.tokenHelper = TokenHelper(token)
    }
    
    /// Return
    ///
    /// - Returns: Returns Public key of the private public key pair
    func getKeyPair() -> String? {
        if let keyPair = getKeyPairFromKeychain() {
            return getPublicKey(keyPair)
        } else {
            return createAndSaveKeyPairReturnPublic()
        }
    }
    
    
    /// Create new key pair and save it
    ///
    /// - Returns: key as a base64 string, contains private and public key
    private func createAndSaveKeyPairReturnPublic() -> String? {
        let keyPair = sodium.sign.keyPair()!
        let combinByteKey = keyPair.secretKey
        if combinByteKey.count == 64 {
            let combinedKey = bytesToString(combinByteKey)
            if let email = tokenHelper.returnUserEmail() {
                let keychain = KeychainHelper(self.service, name: self.name, tag: email)
                do {
                    try keychain.saveKey(combinedKey)
                    return getPublicKey(combinedKey)
                } catch {
                    print("Unexpected error: \(error)")
                    return nil
                }
            } else {
                return nil
            }
            
        } else {
            return nil
        }
    }
    
    /// Return public key given a combined key
    ///
    /// - Parameter key: key with private public key
    /// - Returns: public key as a base64
    func getPublicKey (_ key: String) -> String {
        let bytes = stringTobytes(key)
        if bytes.count == 64 {
            return bytesToString(Array(bytes.suffix(32)))
        } else {
            return ""
        }
    }
    
    /// Return private key given a combined key
    ///
    /// - Parameter key: key with private public key
    /// - Returns: Private key as a base64
    func getPrivateKey (_ key: String) -> String {
        let bytes = stringTobytes(key)
        if bytes.count == 64 {
            return bytesToString(Array(bytes.prefix(32)))
        } else {
            return ""
        }
    }
    
    /// Returns key from keychain
    ///
    /// - Returns: combined base64 key
    private func getKeyPairFromKeychain() -> String? {
        if let email = tokenHelper.returnUserEmail() {
            let keychain = KeychainHelper(self.service, name: self.name, tag: email)
            return keychain.loadKey()
        } else {
            return nil
        }
    }
    
    /// Coverts bytes to base64
    ///
    /// - Parameter bytes: key as bytes
    /// - Returns: Key
    private func bytesToString (_ bytes: [UInt8]) -> String {
        return sodium.utils.bin2base64(bytes, variant: .URLSAFE_NO_PADDING)!
    }
    
    /// Converts base64 to bytes
    ///
    /// - Parameter key: key as a string
    /// - Returns: key
    private func stringTobytes (_ key: String) -> [UInt8] {
        return sodium.utils.base642bin(key, variant: .URLSAFE_NO_PADDING, ignore: " \n")!
    }
    
}

