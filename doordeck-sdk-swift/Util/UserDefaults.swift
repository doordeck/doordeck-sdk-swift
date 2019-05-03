//
//  UserDefaults.swift
//  doordeck-sdk-swift
//
//  Copyright © 2019 Doordeck. All rights reserved.
//

import UIKit

extension UserDefaults {
    func getDarkUI() -> Bool {
        guard let granted = Foundation.UserDefaults(suiteName: "group.com.doordeck.ios")?.bool(forKey: "darkUI") else {
            return true
        }
        return granted
    }
    
    class func setDarkUI (_ enabled: Bool) {
        guard let userDefaults = Foundation.UserDefaults(suiteName: "group.com.doordeck.ios") else {
            fatalError("Unable to create UserDefaults")
        }
        userDefaults.set(enabled, forKey: "darkUI")
    }
}
