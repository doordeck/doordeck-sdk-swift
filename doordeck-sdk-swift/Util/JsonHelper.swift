//
//  JsonHelper.swift
//  doordeck-sdk-swift
//
//  Copyright © 2019 Doordeck. All rights reserved.
//

import Foundation

class JsonHelper {
    //MARK: Json special charachters remover
    //----------------------------------------------------------------------------------------------------------------------
    func removeSpecialCharacters (_ json:String) -> String {
        let new = json.replacingOccurrences(of: "\n", with: "", options: NSString.CompareOptions.literal, range: nil)
        return new
    }
    
    //MARK: JSON encode
    //----------------------------------------------------------------------------------------------------------------------
    func jsonEncode (_ dic:[String:String]) -> String {
        let json: Data?
        do {
            json = try JSONSerialization.data(withJSONObject: dic, options: JSONSerialization.WritingOptions.prettyPrinted)
        } catch _ {
            json = nil
        }
        if let datastring = NSString(data:json!, encoding:String.Encoding.utf8.rawValue) {
            return datastring as String
        }
        else {
            return ""
        }
    }
    
    func jsonEncodeDictionary (_ dict: NSDictionary) -> String {
        let json: Data?
        do {
            if #available(iOS 11.0, *) {
                json = try JSONSerialization.data(withJSONObject: dict, options: [.sortedKeys])
            } else {
                let sortedKeys = (dict.allKeys as! [String]).sorted(by: <)
                json = try JSONSerialization.data(withJSONObject: sortedKeys, options: [])
            }
        } catch _ {
            json = nil
        }
        if let datastring = NSString(data:json!, encoding:String.Encoding.utf8.rawValue) {
            return datastring as String
        }
        else {
            return ""
        }
    }
    
    func jsonEncodeArray (_ array: [[String: AnyObject]]) -> String {
        let dat = try? JSONSerialization.data(withJSONObject: array, options: JSONSerialization.WritingOptions.prettyPrinted)
        if let datastring = NSString(data:dat!, encoding:String.Encoding.utf8.rawValue) {
            return datastring as String
        }
        return ""
    }
    
    //MARK: JSON decode
    //----------------------------------------------------------------------------------------------------------------------
    func jsonDecode (_ json:String) -> Any
    {
        let jsonRemove = self.removeSpecialCharacters(json)
        let data = (jsonRemove as NSString).data(using: String.Encoding.utf8.rawValue)
        return jsonDecode(data!)
    }
    
    func jsonDecode (_ json:Data) -> Any {
        let jsonResult: Any!
        do {
            jsonResult = try JSONSerialization.jsonObject(with: json, options:JSONSerialization.ReadingOptions.mutableContainers)
        } catch _ {
            jsonResult = nil
        }
        
        return jsonResult as Any
    }
}
