import Foundation
import Reachability

class ReachabilityHelper {
    fileprivate let reachability: Reachability?
    
    init()
    {
        guard let tempReach = Reachability() else {
            print(PrintChannel.error, object: "Unable to create Reachability")
            reachability = nil
            return
        }
        
        reachability = tempReach
    }
    
    var connectionType: String {
        
        return (reachability?.connection.description)!
    }
    
    var isConnectedToWiFi: Bool {
        return reachability?.connection == .wifi ? true : false
    }
    
    var isConnected: Bool {
        return reachability?.connection != .none ? true : false
    }
    
    func startNotifier() {
        do {
            try reachability?.startNotifier()
        } catch {
            print(PrintChannel.error, object: "Unable to start notifier")
        }
    }
    
    func  stopNotifier() {
        reachability?.stopNotifier()
    }
}
