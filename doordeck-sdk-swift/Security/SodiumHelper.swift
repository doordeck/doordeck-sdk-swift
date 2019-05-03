//
//  SodiumHelper.swift
//  doordeck-sdk-swift
//
//  Copyright © 2019 Doordeck. All rights reserved.
//

import Foundation
import Sodium

class SodiumHelper {
    fileprivate let sodium = Sodium()
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
    func getPublicKey() -> String? {
        if let keyPair = getKeyPairFromKeychain() {
            return getPublicKeyFromCombined(keyPair)
        } else {
            return createAndSaveKeyPairReturnPublic()
        }
    }
    
    func getPrivateKey() -> String? {
        if let keyPair = getKeyPairFromKeychain() {
            return keyPair
        } else {
            return nil
        }
    }
    
    func signVerificationCode(_ code: String) -> String? {
        return sign(code)
    }
    
    func signUnlock(_ jwt: String) -> String? {
        return sign(jwt)
    }
    
    private func sign (_ string: String) -> String? {
        guard let pKey = getPrivateKey(),
            let privateKeyBytes = stringTobytes(pKey) else {
                return nil
        }
        
        let bytes = Array(string.utf8)
        guard let signature = sodium.sign.signature(message: bytes, secretKey: privateKeyBytes) else {
            return nil
        }
        return bytesToString(signature)
    }
    
    /// Create new key pair and save it
    ///
    /// - Returns: key as a base64 string, contains private and public key
    private func createAndSaveKeyPairReturnPublic() -> String? {
        let keyPair = sodium.sign.keyPair()!
        let combinByteKey = keyPair.secretKey
        if combinByteKey.count == 64 {
            guard let combinedKey = bytesToString(combinByteKey) else {return nil}
            if let email = tokenHelper.returnUserEmail() {
                let keychain = KeychainHelper(self.name, tag: email)
                do {
                    try keychain.saveKey(combinedKey)
                    guard let publicKey = getPublicKeyFromCombined(combinedKey) else {return nil}
                    return publicKey
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
    private func getPublicKeyFromCombined (_ key: String) -> String? {
        guard let bytes = stringTobytes(key) else {return nil}
        if bytes.count == 64 {
            return bytesToString(Array(bytes.suffix(32)))
        } else {
            return nil
        }
    }
    
    /// Return private key given a combined key
    ///
    /// - Parameter key: key with private public key
    /// - Returns: Private key as a base64
    private func getPrivateKeyFromCombined (_ key: String) -> String? {
        guard let bytes = stringTobytes(key) else {return nil}
        if bytes.count == 64 {
            return bytesToString(Array(bytes.prefix(32)))
        } else {
            return nil
        }
    }
    
    /// Returns key from keychain
    ///
    /// - Returns: combined base64 key
    private func getKeyPairFromKeychain() -> String? {
        if let email = tokenHelper.returnUserEmail() {
            let keychain = KeychainHelper(self.name, tag: email)
            return keychain.loadKey()
        } else {
            return nil
        }
    }
    
    /// Coverts bytes to base64
    ///
    /// - Parameter bytes: key as bytes
    /// - Returns: Key
    func bytesToString (_ bytes: [UInt8]) -> String? {
        guard let string = sodium.utils.bin2base64(bytes, variant: .ORIGINAL) else {return nil}
        return string
    }
    
    /// Converts base64 to bytes
    ///
    /// - Parameter key: key as a string
    /// - Returns: key
    func stringTobytes (_ key: String) -> [UInt8]? {
        guard let bytes =  sodium.utils.base642bin(key, variant: .ORIGINAL, ignore: " \n") else {return nil}
        return bytes
    }
    
}

