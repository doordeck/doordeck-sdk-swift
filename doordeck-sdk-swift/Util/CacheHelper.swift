//
//  cacheHelper.swift
//  doordeck-sdk-swift
//
//  Copyright © 2019 Doordeck. All rights reserved.
//

import Foundation
import Cache

class cacheHelper {
    var storege: Storage<Data>?
    let sites = "Sites"
    
    init() {
        let diskConfig = DiskConfig(
            name: sites,
            expiry: .never,
            maxSize: 200 * 1024 * 1024,
            directory: try! FileManager.default.url(for: .documentDirectory,
                                                    in: .userDomainMask,
                                                    appropriateFor: nil,
                                                    create: true),
            protectionType: .complete)
        
        let memoryConfig = MemoryConfig(expiry: .never, countLimit: 0, totalCostLimit: 0)
        
        storege = try? Storage(
            diskConfig: diskConfig,
            memoryConfig: memoryConfig,
            transformer: TransformerFactory.forCodable(ofType: Data.self)
        )
    }
    
    func storeLocks(_ locksData: Data, siteName: String) {
        store(locksData, key: siteName)
    }
    
    func getStoredLocks(_ siteName: String) -> Data? {
        return retreive(siteName)
    }
    
    func storeSites(_ siteJson: Data) {
        store(siteJson, key: sites)
    }
    
    func getStoredSites() -> Data? {
        return retreive(sites)
    }
    
    
    fileprivate func store (_ object: Data, key: String) {
        ((try? storege?.setObject(object, forKey: key)) as ()??)
    }
    
    fileprivate func retreive (_ key: String) -> Data? {
        guard let store = ((try? storege?.object(forKey: key)) as Data??) else { return nil }
        return store
    }
    
    fileprivate func removeObject (_ key:String) {
        ((try? storege?.removeObject(forKey: key)) as ()??)
    }
    
    func removeAll() {
        ((try? storege?.removeAll()) as ()??)
    }
}
