//
//  Site.swift
//  doordeck-sdk-swift
//
//  Copyright © 2019 Doordeck. All rights reserved.
//

import UIKit


/// A site can have a location associated with it
struct SiteLocation {
    var enabled = false
    var latitude: Double = 0.0
    var longitude: Double = 0.0
    var radius = 0
}

/// This is the site object class, this is nit currently used in the SDK
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

