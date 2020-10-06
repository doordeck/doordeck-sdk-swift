//
//  KeychainService.swift
//  doordeck-sdk-swift
//
//  Copyright © 2019 Doordeck. All rights reserved.
//

import Foundation
import Security

enum KeychainError: Error {
    case unhandledError(status: OSStatus)
}

/// Keychain Helper protocal
protocol KeychainHelperProtocol {
    func saveKey(_ key: String) throws
    func loadKey() -> String?
}

/// Keychain helper
class KeychainHelper: KeychainHelperProtocol {
    private var name: String!
    private var tag: String!
  
    
    /// init
    ///
    /// - Parameters:
    ///   - service: Service string
    ///   - name: name string
    ///   - tag: tag string
    init(_ name: String,
         tag: String) {
      
      
      self.name = name
        self.tag = tag
    }
    
    
    /// Save key to the keychian and allow it to be shared through icloud of user
    ///
    /// - Parameter key: combined key as base64
    /// - Throws: can throw and error
    func saveKey(_ key: String) throws {
        
        guard let keyData = key.data(using: .utf8) else {
            fatalError("Key can't be convert to expected object")
        }
        
        guard let tagData = tag.data(using: .utf8) else {
            fatalError("Tag can't be convert to expected object")
        }

        guard let nameData = name.data(using: .utf8) else {
            fatalError("Tag can't be convert to expected object")
        }
        
        // 1
        let attributes: [String: Any] = [kSecClass as String: kSecClassKey,
                                         kSecAttrApplicationTag as String: tagData,
                                         kSecAttrApplicationLabel as String: nameData,
                                         kSecAttrCanSign as String: true,
                                         kSecAttrCanDecrypt as String: true,
                                         kSecAttrCanEncrypt as String: true,
                                         kSecAttrKeyType as String: kSecAttrKeyTypeEC,
                                         kSecAttrAccessible as String : kSecAttrAccessibleAfterFirstUnlock,
                                         kSecValueData as String: keyData]
        
        
        
        
        // 2
        _ = SecItemDelete(attributes as CFDictionary)
        
        // 3
        let status = SecItemAdd(attributes as CFDictionary, nil)
        guard status == errSecSuccess else {
            throw KeychainError.unhandledError(status: status)
        }
        
    }
    
    /// search keychian for the key
    ///
    /// - Returns: retrun key if available
    func loadKey() -> String? {
        
        guard let tagData = tag.data(using: .utf8) else {
            fatalError("Tag can't be convert to expected object")
        }
        
        guard let nameData = name.data(using: .utf8) else {
            fatalError("Tag can't be convert to expected object")
        }
        
        // 1
        let attributes: [String: Any] = [kSecClass as String: kSecClassKey,
                                         kSecAttrApplicationTag as String: tagData,
                                         kSecAttrApplicationLabel as String: nameData,
                                         kSecMatchLimit as String: kSecMatchLimitOne,
                                         kSecReturnData as String: true]
        
        // 2
        var item: CFTypeRef?
        let status = SecItemCopyMatching(attributes as CFDictionary, &item)
        guard status == errSecSuccess else {
            //f "Cannot find saved key in Keychain"
            return nil
        }
        
        // 3
        guard let keyData = item as? Data else {
            // "Key was found, but can't be convert to expected object "
            return nil
        }
        let value = String(data: keyData, encoding: .utf8)!
        return value
    }
}
