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
    
    fileprivate static let httpsBase = "https://"
    fileprivate static let webBase = "doordeck.com"
    
    //    #if os(iOS)
    ////    fileprivate static let api = (UIApplication.staging() == true) ? "api.staging." : "api."
    //    #else
    fileprivate static let api = "api.dev."
    //    #endif
    
    static let GET = "GET"
    static let PUT = "PUT"
    static let POST = "POST"
    
    fileprivate static let auth = "/auth"
    fileprivate static let account = "/account"
    fileprivate static let certificate = "/certificate"
    fileprivate static let destroy = "/destroy"
    fileprivate static let email = "/email"
    fileprivate static let login = "/login"
    fileprivate static let register = "/register"
    fileprivate static let refresh = "/refresh"
    fileprivate static let token = "/token"
    fileprivate static let verify = "/verify"
    fileprivate static let share = "/share"
    fileprivate static let favourite = "/favourite"
    static let invite = "/invite"
    fileprivate static let device = "/device"
    fileprivate static let site = "/site"
    fileprivate static let tile = "/tile"
    fileprivate static let execute = "/execute"
    fileprivate static let key = "/key"
    fileprivate static let password = "/password"
    fileprivate static let shareable = "/shareable"
    fileprivate static let check = "/check"
    fileprivate static let force = "?force"
    fileprivate static let method = "?method="
    fileprivate static let smsMethod = "SMS"
    fileprivate static let telephoneMethod  = "TELEPHONE"
    fileprivate static let emailMethod  = "EMAIL"
    fileprivate static let whatspapMethod  = "WHATSAPP"
    
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
