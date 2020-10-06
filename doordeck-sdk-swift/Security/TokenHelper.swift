//
//  TokenHelper.swift
//  doordeck-sdk-swift
//
//  Copyright © 2019 Doordeck. All rights reserved.
//

import Foundation

class TokenHelper {
    enum TokenType {
        case refreshToken
        case authToken
    }
    
    /// Change password call from the server
    ///
    /// - no: Do not change password
    /// - newUser: New user, change password
    /// - forceChange: Force change password of the user
    enum ChangePassword {
        case no
        case newUser
        case forceChange
    }
    
    fileprivate var token: AuthTokenClass!
    
    
    /// Init with AuthTokenClass
    ///
    /// - Parameter token: AuthTokenClass
    init(_ token: AuthTokenClass) {
        self.token = token
    }
    
    /// Check if the token is still active
    ///
    /// - Parameters:
    ///   - success: the token is active
    ///   - fail: the token is not active
    func tokenActive (_ success:() -> Void , fail: () -> Void) {
        
        self.decrypt() { (tokenDecrypt, error) in
            
            guard error == nil && tokenDecrypt != nil else {
                SDKEvent().event(.INVALID_AUTH_TOKEN)
                fail()
                return
            }
            if self.tokenStillActive(tokenDecrypt!) {
                success()
            } else {
                SDKEvent().event(.INVALID_AUTH_TOKEN)
                fail()
            }
        }
        
    }
    
    /// Return the UserID from the AuthTokenClass
    ///
    /// - Returns: return the UserID
    func returnUserID () -> String? {
        return returnTokenElement(key: "sub")
    }
    
    /// Return the users email from Auth Token
    ///
    /// - Returns: Email from Authtoken
    func returnUserEmail () -> String? {
        return returnTokenElement(key: "email")
    }
    
    /// Get the user session from the Auth token
    ///
    /// - Returns: Session
    func returnUserSession () -> String? {
        return returnTokenElement(key: "session")
    }
    
    /// Return the Element from the token
    ///
    /// - Parameter key: String of the element
    /// - Returns: return the value for key
    private func returnTokenElement (key: String) -> String? {
        var element = ""
        
        self.decrypt() { (tokenDecrypt, error) in
            
            guard error == nil && tokenDecrypt != nil else { return element = "" }
            guard let tempToken = tokenDecrypt else { return element = "" }
            guard let tempUserID: String = tempToken[key] as? String else { return element = "" }
            element = tempUserID
        }
        
        return element
    }
    
    /// Create token body
    ///
    /// - Parameter token: Token dictionary
    /// - Returns: return base64 token body
    func createTokenBody (_ token: [String:Any]) -> String {
        let payload = JsonHelper().jsonEncodeDictionary(token as NSDictionary)
        return payload.toBase64().URIbase64()
    }
    
    /// Decrypt base64 token into dictionary
    ///
    /// - Parameter completion: return token as dictionary
    private func decrypt (_ completion: ([String:Any]?, Error?) -> Void) {
    
        let token = self.token.getToken()
        let array = token.components(separatedBy: ".")
        if array.count == 3 {
            let body: String = array[1]
            let base64Decode = body.base64decode()
            let dict: [String:Any] = JsonHelper().jsonDecode(base64Decode!) as! [String:Any]
            completion(dict,nil)
        } else {
            completion(nil, NSError(domain: "Doordeck", code: 0, userInfo: nil))
        }
    }
    
    /// Check if the token is still active and alive
    ///
    /// - Parameter token: token
    /// - Returns: returns if the token is alive
    private func tokenStillActive (_ token: [String:Any]) -> Bool {
        print(PrintChannel.token, object: token["exp"] as Any)
        guard token["exp"] != nil else {
            return false
        }
        
        guard let tokenExpiryTime = token["exp"] as? Int else {
            return false
        }
        
        let date = Date().timeIntervalSince1970
        
        print(PrintChannel.token, object: "absolute time \(CFAbsoluteTimeGetCurrent()) \n tokenExpiryTime \(Double(tokenExpiryTime))")
        
        if (Double(tokenExpiryTime) > date) {
            return true
        } else {
            return false
        }
    }
}
