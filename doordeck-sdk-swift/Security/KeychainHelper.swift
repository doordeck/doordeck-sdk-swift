
//
//  KeychainService.swift
//  doordeck-sdk-swift
//
//  Created by Marwan on 04/04/2019.
//  Copyright © 2019 Doordeck. All rights reserved.
//
import Foundation
import Security

enum KeychainError: Error {
    case unhandledError(status: OSStatus)
}

protocol KeychainHelperProtocol {
    func saveKey(_ key: String) throws
    func loadKey() -> String?
}

class KeychainHelper: KeychainHelperProtocol {
    private var name: String!
    private var tag: String!
    private var service: String!
    
    init(_ service: String,
         name: String,
         tag: String) {
        
        self.service = service
        self.name = name
        self.tag = tag
    }
    
    func saveKey(_ key: String) throws {
        
        guard let keyData = key.data(using: .utf8) else {
            fatalError("Key can't be convert to expected object")
        }
        
        guard let tagData = tag.data(using: .utf8) else {
            fatalError("Tag can't be convert to expected object")
        }

        guard let serviceData = service.data(using: .utf8) else {
            fatalError("Tag can't be convert to expected object")
        }

        guard let nameData = name.data(using: .utf8) else {
            fatalError("Tag can't be convert to expected object")
        }
        
        // 1
        let attributes: [String: Any] = [kSecClass as String: kSecClassKey,
                                         kSecAttrApplicationTag as String: tagData,
                                         kSecAttrService as String: serviceData,
                                         kSecAttrAccount as String: nameData,
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
    
    func loadKey() -> String? {
        
        guard let tagData = tag.data(using: .utf8) else {
            fatalError("Tag can't be convert to expected object")
        }
        
        guard let serviceData = service.data(using: .utf8) else {
            fatalError("Tag can't be convert to expected object")
        }
        
        guard let nameData = name.data(using: .utf8) else {
            fatalError("Tag can't be convert to expected object")
        }
        
        // 1
        let attributes: [String: Any] = [kSecClass as String: kSecClassKey,
                                         kSecAttrApplicationTag as String: tagData,
                                         kSecAttrService as String: serviceData,
                                         kSecAttrAccount as String: nameData,
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
