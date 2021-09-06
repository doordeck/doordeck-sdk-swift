//
//  APIClient.swift
//  doordeck-sdk-swift
//
//  Copyright © 2019 Doordeck. All rights reserved.
//

import Foundation

class APIClient {
    enum error: Error {
        case unsuccessfulHTTPStatusCode(statusCode: Int)
        case invalidJSON(jsonError: NSError)
        case invalidJSONError
        case invalidData(data: AnyObject?)
        case network(networkError: NSError)
        case invalidAuthToken
        case twoFactorAuthenticationNeeded
        case noInternet
        
    }
    
    enum deviceStatus {
        case lock
        case unlock
    }
    
    
    var header: [String : String]!
    var token: AuthTokenClass!
    var tokenHelper: TokenHelper!
    var afrequest: AFRequest!
    
    /// init for Api class both a header and a Token has to be passed in
    ///
    /// - Parameters:
    ///   - header: the header containing token and
    ///   - token: Auth Token
    init(_ header: [String: String],
         token: AuthTokenClass) {
        
        self.header = header
        self.token = token
        self.tokenHelper = TokenHelper(token)
        self.afrequest = AFRequest()
    }
    
    /// Register the users public key from device
    ///
    /// - Parameters:
    ///   - key: The String represention of the public key in base64
    ///   - completion: completion call back with error
    func registrationWithKey(_ key: String,
                             completion: @escaping ([String:AnyObject]?, APIClient.error?) -> Void) {
        
        let URL = URLManager.registrationWithKey()
        
        AFRequest().request(URL,
                            method: .post,
                            params: QueryManager.registerKey(key),
                            headers: self.header,
                            jsonReply: true,
                            onSuccess: { (jsonData) in
                                
                                self.requestCompletion(URL,
                                                       data: jsonData,
                                                       rootKey: nil,
                                                       completion: completion)
                                
        }) { (error) in
            completion(nil, error)
        }
    }
    
    
    /// Start the process of 2FA
    ///
    /// - Parameters:
    ///   - key: the public ephemeralKey
    ///   - method: the method you would like to recieve the conformation
    ///   - completion: completion call back with error
    func startVerificationProcess(_ key: String,
                                  method: URLManager.verificationMethod = .auto,
                                  completion: @escaping ([String:AnyObject]?, APIClient.error?) -> Void) {
        
        let URL = URLManager.startVerificationProcess(method)
        
        AFRequest().request(URL,
                            method: .post,
                            params: QueryManager.registerKey(key),
                            headers: self.header,
                            jsonReply: true,
                            onSuccess: { (jsonData) in
                                
                                self.requestCompletion(URL,
                                                       data: jsonData,
                                                       rootKey: nil,
                                                       completion: completion)
                                
        }) { (error) in
            completion(nil, error)
        }
    }
    
    /// Check 2FA code
    ///
    /// - Parameters:
    ///   - key: the public ephemeralKey
    ///   - method: the method you would like to recieve the conformation
    ///   - completion: completion call back with error
    func checkVerificationProcess(_ key: String,
                                  completion: @escaping ([String:AnyObject]?, APIClient.error?) -> Void) {
        
        let URL = URLManager.checkVerificationProcess()
        
        AFRequest().request(URL,
                            method: .post,
                            params: QueryManager.checkKey(key),
                            headers: self.header,
                            jsonReply: true,
                            onSuccess: { (jsonData) in
                                
                                self.requestCompletion(URL,
                                                       data: jsonData,
                                                       rootKey: nil,
                                                       completion: completion)
                                
        }) { (error) in
            completion(nil, error)
        }
    }
    
    /// Get device from UUIs
    /// - Parameters:
    ///   - uuid: UUID
    ///   - completion: Returns Lock
    func getDevicesForUUID (_ uuid:String,
                               completion: @escaping ([String: AnyObject]?, APIClient.error?) -> Void) {
        
        let URL = URLManager.getDevicesForUUID(uuid)
        
        afrequest.request (URL,
                           method: .get,
                           params:nil,
                           headers: self.header,
                           onSuccess: { (jsonData) in
                            
                            self.requestCompletion(URL,
                                                   data: jsonData,
                                                   rootKey: nil,
                                                   completion: completion)
                            
        }) { (error) in
            completion(nil, error)
        }
    }
    
    
    /// Find a device from the UUID of a tile
    ///
    /// - Parameters:
    ///   - uuid: UUID of the device
    ///   - completion: completion call back with error
    func getDeviceForTile (_ uuid: String,
                           completion: @escaping ([String:AnyObject]?, APIClient.error?) -> Void) {
        
        let URL = URLManager.getDeviceForTile(uuid)
        
        afrequest.request (URL,
                           method: .get,
                           params: nil,
                           headers: self.header,
                           onSuccess: { (jsonData) in
                            
                            self.requestCompletion(URL,
                                                   data: jsonData,
                                                   rootKey: nil,
                                                   completion: completion)
                            
        }) { (error) in
            completion(nil, error)
        }
    }
    
    /// Update the colour of the lock, this is not currenly used by the SDK
    ///
    /// - Parameters:
    ///   - device: lock device object
    ///   - colour: new hex colour
    ///   - completion: completion call back with error
    func updateLockColour (_ device: LockDevice,
                           colour: String,
                           completion: @escaping ([AnyObject]?, APIClient.error?) -> Void) {
        
        let URL = URLManager.updateLock(device.ID)
        
        afrequest.request (URL,
                           method: .put,
                           params: QueryManager.updateLockColour(colour),
                           headers: self.header,
                           onSuccess: { (jsonData) in
                            
                            self.requestCompletion(URL,
                                                   data: jsonData,
                                                   rootKey: nil,
                                                   completion: completion)
                            
        }) { (error) in
            completion(nil, error)
        }
    }
    
    /// Unlock device or Lock device
    ///
    /// - Parameters:
    ///   - device: Device object
    ///   - control: The call does support both lock and unlock but we currenly only use unlock
    ///   - completion: completion call back with error
    func lockUnlock (_ device: LockDevice,
                     sodium: SodiumHelper,
                     chain: CertificateChainClass,
                     control: (APIClient.deviceStatus),
                     completion: @escaping ([AnyObject]?, APIClient.error?) -> Void) {
        
        let operationArray = [
            "type":"MUTATE_LOCK",
            "locked":(control == APIClient.deviceStatus.lock) ? true : false] as [String : Any]
        tokenHelper.tokenActive({
            deviceControl(device,sodium: sodium,chain: chain, operation: operationArray as [String : Any], completion: completion)
        }) {
            completion(nil, APIClient.error.invalidAuthToken)
        }
        
    }
    
    /// Device unlcok call after check
    ///
    /// - Parameters:
    ///   - device: Device object
    ///   - control: The call does support both lock and unlock but we currenly only use unlock
    ///   - completion: completion call back with error
    func deviceControl (_ device: LockDevice,
                                    sodium: SodiumHelper,
                                    chain: CertificateChainClass,
                                    operation: [String: Any],
                                    completion: @escaping ([AnyObject]?, APIClient.error?) -> Void) {
        
        guard let userID: String = chain.getUserID(),
            let chainTemp: [String] = chain.getCertificateCahin()
            else { return completion (nil, APIClient.error.invalidAuthToken) }
        
        
        if userID.count < 30 {
            return completion(nil, error.invalidAuthToken)
        }
        
        let header = [
            "typ": "jwt",
            "x5c": chainTemp,
            "alg": "EdDSA"
            ] as [String : Any]
        
        let headerJson = JsonHelper().jsonEncodeDictionary(header as NSDictionary)
        let header64URI = headerJson.toBase64().URIbase64()
        
        let BODY = ["iss":userID,
                    "sub":device.ID,
                    "nbf": Int(Date().timeIntervalSince1970),
                    "iat": Int(Date().timeIntervalSince1970),
                    "exp": Int(Date().timeIntervalSince1970 + 60.0),
                    "operation":operation,
                    "jti": UUID().uuidString
            ] as [String : Any]
        
        
        let payload = tokenHelper.createTokenBody(BODY)
        
        var jwtToken = header64URI + "." + payload
        
        let signature = sodium.signUnlock(jwtToken)
        
        guard let signatureCheck: String = signature else {
            completion(nil, APIClient.error.invalidAuthToken)
            return
        }
        
        jwtToken = jwtToken + "." + signatureCheck
        
        jwtToken = jwtToken.URIbase64()
        
        print(PrintChannel.token, object: "jwtToken \(jwtToken)")
        
        let URL = "\(URLManager.lockContol(device.ID))"
        
        AFRequest().request(URL,
                            method: .post,
                            params: nil,
                            encoding: jwtToken,
                            headers: self.header,
                            jsonReply: true,
                            onSuccess: { (jsonData) in
                                
                                self.requestCompletion(URL,
                                                       data: jsonData,
                                                       rootKey: nil,
                                                       completion: completion)
                                
        }) { (error) in
            completion(nil, error)
        }
    }
    
    /// Complete request after sanity check on the data has been performed
    ///
    /// - Parameters:
    ///   - URL: URL string
    ///   - data: The Data
    ///   - rootKey: The root of the data if different
    ///   - completion: completion call back with error
    func requestCompletion<T>(_ URL: String?,
                                          data: AnyObject,
                                          rootKey: String?,
                                          completion: (T?, APIClient.error?) -> Void) {
        
        let json: AnyObject
        let error: NSError? = nil
        
        if data is [String:AnyObject] {
            guard let jsonTemp = data as? [String:AnyObject] else { return completion(nil, .invalidJSON(jsonError: error!)) }
            json = jsonTemp as AnyObject
        } else if data is [AnyObject] {
            guard let jsonTemp = data as? [AnyObject] else { return completion(nil, .invalidJSON(jsonError: error!)) }
            json = jsonTemp as AnyObject
        } else {
            guard let errorGuard = error else {
                return completion(nil, nil)
            }
            return completion(nil, .invalidJSON(jsonError: errorGuard))
        }
        
        if rootKey == nil {
            return completion(json as? T, nil)
        }
        
        guard let root = json[rootKey!] as? T else {
            return completion(nil, .invalidData(data: json))
        }
        
        completion(root, nil)
    }
    
}
