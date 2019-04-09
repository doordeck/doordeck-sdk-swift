import Foundation

class TokenHelper {
    enum TokenType {
        case refreshToken
        case authToken
    }
    
    enum ChangePassword {
        case no
        case newUser
        case forceChange
    }
    
    fileprivate var token: AuthTokenClass!
    
    init(_ token: AuthTokenClass) {
        self.token = token
    }
    
    func tokenActive (_ sucess:() -> Void , fail: () -> Void) {
        
        self.decrypt() { (tokenDecrypt, error) in
            
            guard error == nil && tokenDecrypt != nil else {
                fail()
                return
            }
            if self.tokenStillActive(tokenDecrypt!) {
                sucess()
            } else {
                fail()
            }
        }
        
    }
    
    func returnUserID () -> String? {
        return returnTokenElement(key: "sub")
    }
    
    func returnUserEmail () -> String? {
        return returnTokenElement(key: "email")
    }
    
    func returnUserSession () -> String? {
        return returnTokenElement(key: "session")
    }
    
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
    
    func createTokenBody (_ token: [String:Any]) -> String {
        let payload = JsonHelper().jsonEncodeDictionary(token as NSDictionary)
        return payload.toBase64()
    }
    
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
