import Foundation

struct QueryManager {
    
    private static let unlockTime = "unlockTime"
    private static let email = "email"
    private static let password = "password"
    private static let oldPassword = "oldPassword"
    private static let newPassword = "newPassword"
    private static let name = "name"
    private static let favourite = "favourite"
    private static let key = "key"
    private static let displayName = "displayName"
    private static let colour = "colour"
    private static let inviteCode = "inviteCode"
    private static let ephemeralKey = "ephemeralKey"
    
    static func login (_ email: String,
                       password: String) -> [String: AnyObject] {
        
        return [
            self.email: email as AnyObject,
            self.password: password as AnyObject
        ]
    }
    
    static func registerKey (_ key: String) -> [String: AnyObject] {
        
        return [ self.ephemeralKey: key as AnyObject ]
    }
    
    static func register (_ email: String,
                          password: String,
                          displayName: String) -> [String: AnyObject] {
        
        return [
            self.email: email as AnyObject,
            self.password: password as AnyObject,
            self.displayName: displayName as AnyObject
        ]
    }
    
    static func registerInvitation (_ email: String,
                                    password: String,
                                    displayName: String,
                                    inviteCode: String) -> [String: AnyObject] {
        
        return [
            self.email: email as AnyObject,
            self.password: password as AnyObject,
            self.displayName: displayName as AnyObject,
            self.inviteCode: inviteCode as AnyObject
        ]
    }
    
    static func changePassword (_ oldPassword: String,
                                newPassword: String) -> [String: AnyObject] {
        
        return [
            self.oldPassword: oldPassword as AnyObject,
            self.newPassword: newPassword as AnyObject
        ]
    }
    
    static func updateDisplayName (_ displayName: String) -> [String: AnyObject] {
        
        return [ self.displayName: displayName as AnyObject ]
    }
    
    static func addLock (_ name: String,
                         key: String,
                         time: Int) -> [String: AnyObject] {
        
        return [
            self.name: name as AnyObject,
            self.key: key as AnyObject,
            self.unlockTime: time as AnyObject
        ]
    }
    
    static func updateLock (_ name: String,
                            favourite: Bool,
                            colour: String) -> [String: AnyObject] {
        
        return [
            self.name: name as AnyObject,
            self.favourite: favourite as AnyObject,
            self.colour: colour as AnyObject
        ]
    }
    
    static func updateLockName (_ name: String) -> [String: AnyObject] {
        
        return [ self.name: name as AnyObject ]
    }
    
    static func updateLockFavourite (_ favourite: Bool) -> [String: AnyObject] {
        
        return [ self.favourite: favourite as AnyObject ]
    }
    
    static func updateLockColour (_ colour: String) -> [String: AnyObject] {
        
        return [ self.colour: colour as AnyObject ]
    }
}

class Header {
    enum HeaderType {
        case unautheticated
        case unautheticatedPem
        case refreshToken
        case token
        case tokenJson
    }
    
    enum version {
        case v1
        case v2
    }
    
    fileprivate var token: AuthTokenClass?
    fileprivate let ContentType = "Content-Type"
    fileprivate let applicationJson = "application/json"
    fileprivate let applicationPemFile = "application/x-pem-file"
    fileprivate let authorization = "Authorization"
    fileprivate let bearer = "Bearer"
    fileprivate let accept = "Accept"
    fileprivate let origin = "origin"
    fileprivate let v2 = "application/vnd.doordeck.api-v2+json"
    
    func createSDKAuthHeader(_ version: version,
                             token: AuthTokenClass) -> [String : String] {
        
        self.token = token
        var typeHeader = getAuthSDK()
        let version = addVersion(version)
        typeHeader.merge(version, uniquingKeysWith: +)
        return typeHeader
        
    }
    
    func getAuthSDK() -> [String : String] {
        guard let authToken = token?.getToken() else {
            return [:]
        }
        return [self.authorization: "\(self.bearer) \(authToken)" ]
    }
    
    func addVersion (_ version: version) -> [String : String] {
        switch version {
        case .v1 :
            return [:]
        case .v2 :
            return [self.accept: self.v2]
        }
    }
    
}
