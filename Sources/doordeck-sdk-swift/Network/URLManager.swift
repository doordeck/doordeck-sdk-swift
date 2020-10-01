//
//  URLManager.swift
//  doordeck-sdk-swift
//
//  Copyright © 2019 Doordeck. All rights reserved.
//

import UIKit

struct URLManager {
    
    enum verificationMethod {
        case sms
        case phone
        case email
        case whatapp
        case auto
    }
    
    static let httpsBase = "https://"
    static let webBase = "doordeck.com"
    
    #if os(iOS)
    static let api = (UIApplication.staging() == true) ? "api.staging." : "api."
    #else
    static let api = "api."
    #endif
    
    static let GET = "GET"
    static let PUT = "PUT"
    static let POST = "POST"
    
    static let auth = "/auth"
    static let account = "/account"
    static let certificate = "/certificate"
    static let destroy = "/destroy"
    static let email = "/email"
    static let login = "/login"
    static let register = "/register"
    static let refresh = "/refresh"
    static let token = "/token"
    static let verify = "/verify"
    static let share = "/share"
    static let favourite = "/favourite"
    static let invite = "/invite"
    static let device = "/device"
    static let site = "/site"
    static let tile = "/tile"
    static let execute = "/execute"
    static let key = "/key"
    static let password = "/password"
    static let shareable = "/shareable"
    static let check = "/check"
    static let force = "?force"
    static let method = "?method="
    static let smsMethod = "SMS"
    static let telephoneMethod  = "TELEPHONE"
    static let emailMethod  = "EMAIL"
    static let whatspapMethod  = "WHATSAPP"
    
    /// URL string for Device retreval from UUID
    ///
    /// - Parameter uuid: Device UUID
    /// - Returns: URL
    static func getDeviceForTile (_ uuid: String) -> String {
        return "\(httpsBase)\(api)\(webBase)\(tile)/\(uuid)" }
    
    /// Update lock details
    ///
    /// - Parameter uuid: Device UUID
    /// - Returns: URL
    static func updateLock (_ uuid: String) -> String {
        return "\(httpsBase)\(api)\(webBase)\(device)/\(uuid)" }
    
    /// Device control URL
    ///
    /// - Parameter uuid: Device UUID
    /// - Returns: URL
    static func lockContol (_ uuid: String) -> String {
        return "\(httpsBase)\(api)\(webBase)\(device)/\(uuid)\(execute)" }
    
    /// Register new public key with the server
    ///
    /// - Returns: URL
    static func registrationWithKey () -> String {
        return "\(httpsBase)\(api)\(webBase)\(auth)\(certificate)" }
    
    
    /// start verification process
    ///
    /// - Parameter method: the method you would like to be contacted
    /// - Returns: a string of the URL
    static func startVerificationProcess (_ methodOfContact: verificationMethod = .auto) -> String {
        
        switch methodOfContact {
        case .auto:
            return "\(httpsBase)\(api)\(webBase)\(auth)\(certificate)\(verify)"
        case .sms:
            return "\(httpsBase)\(api)\(webBase)\(auth)\(certificate)\(verify)\(method)\(smsMethod)"
        case .phone:
            return "\(httpsBase)\(api)\(webBase)\(auth)\(certificate)\(verify)\(method)\(telephoneMethod)"
        case .email:
            return "\(httpsBase)\(api)\(webBase)\(auth)\(certificate)\(verify)\(method)\(emailMethod)"
        case .whatapp:
            return "\(httpsBase)\(api)\(webBase)\(auth)\(certificate)\(verify)\(method)\(whatspapMethod)"
        }
    }
    
    /// Submit the code sent to the user by the Doordeck servers
    ///
    /// - Returns: string of the URL
    static func checkVerificationProcess () -> String {
        return "\(httpsBase)\(api)\(webBase)\(auth)\(certificate)\(check)"
    }
    
}
