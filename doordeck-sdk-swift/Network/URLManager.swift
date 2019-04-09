import UIKit

struct URLManager {
    
    fileprivate static let httpsBase = "https://"
    fileprivate static let webBase = "doordeck.com"
    
//    #if os(iOS)
////    fileprivate static let api = (UIApplication.staging() == true) ? "api.staging." : "api."
//    fileprivate static let api = (UIApplication.staging() == true) ? "api.dev." : "api."
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
    fileprivate static let force = "?force"
    
    static func getDeviceForTile (_ uuid: String) -> String {
        return "\(httpsBase)\(api)\(webBase)\(tile)/\(uuid)" }
    
    static func updateLock (_ uuid: String) -> String {
        return "\(httpsBase)\(api)\(webBase)\(device)/\(uuid)" }
    
    static func lockContol (_ uuid: String) -> String {
        return "\(httpsBase)\(api)\(webBase)\(device)/\(uuid)\(execute)" }
    
    static func registrationWithKey () -> String {
        return "\(httpsBase)\(api)\(webBase)\(auth)\(certificate)" }
    
}
