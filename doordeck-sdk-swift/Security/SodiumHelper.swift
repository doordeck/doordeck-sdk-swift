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
    
    init(_ token: AuthTokenClass) {
        self.token = token
        self.tokenHelper = TokenHelper(token)
    }
    
    func getKeyPair() -> String? {
        if let keyPair = getKeyPairFromKeychain() {
            return getPublicKey(keyPair)
        } else {
            return createAndSaveKeyPairReturnPublic()
        }
    }
    
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
    
    private func getPublicKey (_ key: String) -> String {
        let bytes = stringTobytes(key)
        if bytes.count == 64 {
            return bytesToString(bytes.suffix(32))
        } else {
            return ""
        }
    }
    
    private func getKeyPairFromKeychain() -> String? {
        if let email = tokenHelper.returnUserEmail() {
            let keychain = KeychainHelper(self.service, name: self.name, tag: email)
            return keychain.loadKey()
        } else {
            return nil
        }
    }
    
    private func bytesToString (_ bytes: [UInt8]) -> String {
        return sodium.utils.bin2base64(bytes, variant: .URLSAFE_NO_PADDING)!
    }
    
    private func stringTobytes (_ key: String) -> [UInt8] {
        return sodium.utils.base642bin(key, variant: .URLSAFE_NO_PADDING, ignore: " \n")!
    }
    
}

