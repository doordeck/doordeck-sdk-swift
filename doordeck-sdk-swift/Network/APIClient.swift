import Foundation
import SwiftyRSA

class APIClient {
    enum error: Error {
        case unsuccessfulHTTPStatusCode(statusCode: Int)
        case invalidJSON(jsonError: NSError)
        case invalidJSONError
        case invalidData(data: AnyObject?)
        case network(networkError: NSError)
        case invalidAuthToken
        case noInternet
    }
    
    enum deviceStatus {
        case lock
        case unlock
    }
    
    
    fileprivate var header: [String : String]!
    fileprivate var token: AuthTokenClass!
    fileprivate var tokenHelper: TokenHelper!
    fileprivate var afrequest: AFRequest!
    
    init(_ header: [String: String],
         token: AuthTokenClass) {
        
        self.header = header
        self.token = token
        self.tokenHelper = TokenHelper(token)
        self.afrequest = AFRequest()
    }
    
    func registrationWithKey(_ key: String,
                             completion: @escaping ([String:AnyObject]?, APIClient.error?) -> Void) {
        
        let URL = URLManager.registrationWithKey()
        
        AFRequest().request(URL,
                            method: .post,
                            params: QueryManager.registerKey(key),
                            headers: self.header,
                            jsonReply: false,
                            onSuccess: { (jsonData) in
                                
        }) { (error) in
            completion(nil, error)
        }
    }
    
    func getDeviceForTile (_ uuid:String,
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
    
    func lockUnlock (_ device: LockDevice,
                     control: (APIClient.deviceStatus),
                     completion: @escaping ([AnyObject]?, APIClient.error?) -> Void) {
        
        let operationArray = [
            "type":"MUTATE_LOCK",
            "locked":(control == APIClient.deviceStatus.lock) ? true : false,
            "duration":Int(device.unlockTime)] as [String : Any]
        tokenHelper.tokenActive({
            deviceControl(device, operation: operationArray as [String : Any], completion: completion)
        }) {
            completion(nil, APIClient.error.invalidAuthToken)
        }
        
    }
    
    fileprivate func deviceControl (_ device: LockDevice,
                                    operation: [String: Any],
                                    completion: @escaping ([AnyObject]?, APIClient.error?) -> Void) {
        
        let startTime = Date().timeIntervalSince1970.millisecond
        
        var userID = ""
        guard let pemCert: String = "" //SecuritySinglton.shared.getPemCert()
            else { return completion (nil, APIClient.error.invalidAuthToken) }
    
        
        if userID.count < 30 {
            return completion(nil, error.invalidAuthToken)
        }
        
        
        let BODY = ["iss":userID,
                    "sub":device.ID,
                    "nbf": Int(Date().timeIntervalSince1970),
                    "iat": Int(Date().timeIntervalSince1970),
                    "exp": Int(Date().timeIntervalSince1970 + 60.0),
                    "operation":operation] as [String : Any]
        
        let HeaderString = "eyJhbGciOiJSUzI1NiIsInR5cCI6IkpXVCJ9"
        let payload = tokenHelper.createTokenBody(BODY)
        let payloadArr = payload.components(separatedBy: ".")
        
        var fudgedToken = ""
        
        if (payloadArr.count) > 1 {
            fudgedToken = HeaderString + "." + (payloadArr[1])
        } else {
            completion(nil, error.invalidAuthToken)
        }
        
        let data = fudgedToken.data(using: String.Encoding(rawValue: String.Encoding.utf8.rawValue))!
        let clear = ClearMessage(data: data)
        do {
            let privateKey = try PrivateKey(pemEncoded: pemCert)
            let digestSignature = try clear.signed(with: privateKey, digestType: .sha256)
            let datastringTemp = digestSignature.base64String.URIbase64()
            
            fudgedToken = fudgedToken + "." + datastringTemp
            print(PrintChannel.token, object: "fudgedToken \(fudgedToken)")
            
            let URL = "\(URLManager.lockContol(device.ID))"
            let endTime = Date().timeIntervalSince1970.millisecond
            let timeDifference = endTime - startTime
            
            
            AFRequest().request(URL,
                                method: .post,
                                params: nil,
                                encoding: fudgedToken,
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
        } catch {
            completion(nil, APIClient.error.invalidAuthToken)
        }
        
    }
    
    fileprivate func requestCompletion<T>(_ URL: String?,
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
