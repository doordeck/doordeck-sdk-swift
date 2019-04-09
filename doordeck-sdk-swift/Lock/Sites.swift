import Foundation


struct SiteLocation {
    var enabled = false
    var latitude: Double = 0.0
    var longitude: Double = 0.0
    var radius = 0
}

class Site {
    
    var pinnedLocks: [LockDevice]  {
        return locks.filter({$0.favourite == true})
    }
    
    fileprivate var apiClient: APIClient!
    var locks: [LockDevice] = []
    var ID: String = "00000000-0000-0000-0000-000000000000"
    var name: String = "Home"
    var colour: UIColor = UIColor.doorBlue()
    var passBackground: String?
    var siteLocation: SiteLocation?
    
    init(_ apiClient: APIClient) {
        self.apiClient = apiClient
    }
    
}

