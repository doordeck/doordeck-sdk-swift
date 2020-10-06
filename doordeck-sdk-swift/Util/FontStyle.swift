//
//  FontStyle.swift
//  doordeck-sdk-swift
//
//  Copyright © 2019 Doordeck. All rights reserved.
//

import Foundation
import UIKit

//example self.favsLabel.attributedText = NSAttributedString.samH1Light(doorStrings.Favs.rawValue)

extension NSAttributedString {
    
    class func createAttributeWithSystemFont (_ uiFont: UIFont,
                                              colour: UIColor,
                                              kerning: CGFloat) ->  [NSAttributedString.Key: AnyObject] {
        
        return  [.font : uiFont,
                 .foregroundColor : colour,
                 .kern : kerning as AnyObject]
    }
    
}



extension NSAttributedString {
    
    /// returns size 11 attributed String
    ///
    /// - Parameters:
    ///   - string: string
    ///   - colour: text colour
    /// - Returns: NSAttributedString
    class func doordeckTextFieldDefault (_ colour: UIColor = UIColor.doordeckTextColour(0.9)) -> [NSAttributedString.Key: AnyObject]   {
        
        return createAttributeWithSystemFont(UIFont.systemFont(ofSize: 14),
                                             colour: colour,
                                             kerning: 0.2)
    }
    
    
    
    /// returns size 11 attributed String
    ///
    /// - Parameters:
    ///   - string: string
    ///   - colour: text colour
    /// - Returns: NSAttributedString
    class func doordeckH5Bold (_ string: String, colour: UIColor = UIColor.doordeckTextColour(0.9)) -> NSAttributedString  {
        
        let preferredDescriptor = UIFont.preferredFont(forTextStyle: UIFont.TextStyle.caption2)
        let attrs = createAttributeWithSystemFont(UIFont.systemFont(ofSize: preferredDescriptor.pointSize, weight: UIFont.Weight.bold),
                                                  colour: colour,
                                                  kerning: 0.2)
        
        return NSAttributedString (string: string.capitalized, attributes: attrs)
        
    }
    
    /// returns size 12 Bold attributed String
    ///
    /// - Parameters:
    ///   - string: string
    ///   - colour: text colour
    /// - Returns: NSAttributedString
    class func doordeckH4Bold (_ string: String, colour: UIColor = UIColor.doordeckTextColour(0.9)) -> NSAttributedString  {
        
        let preferredDescriptor = UIFont.preferredFont(forTextStyle: UIFont.TextStyle.caption2)
        let attrs = createAttributeWithSystemFont(UIFont.systemFont(ofSize: preferredDescriptor.pointSize, weight: UIFont.Weight.bold),
                                                  colour: colour,
                                                  kerning: 0.2)
        
        return NSAttributedString (string: string, attributes: attrs)
        
    }
    
    /// returns size 12 attributed String
    ///
    /// - Parameters:
    ///   - string: string
    ///   - colour: text colour
    /// - Returns: NSAttributedString
    class func doordeckH4 (_ string: String, colour: UIColor = UIColor.doordeckTextColour(0.9)) -> NSAttributedString  {
        
        let preferredDescriptor = UIFont.preferredFont(forTextStyle: UIFont.TextStyle.caption2)
        let attrs = createAttributeWithSystemFont(UIFont.systemFont(ofSize: preferredDescriptor.pointSize, weight: UIFont.Weight.regular),
                                                  colour: colour,
                                                  kerning: 0.2)
        
        return NSAttributedString (string: string, attributes: attrs)
        
    }
    
    /// returns size 15 Bold attributed String
    ///
    /// - Parameters:
    ///   - string: string
    ///   - colour: text colour
    /// - Returns: NSAttributedString
    class func doordeckH3Bold (_ string: String, colour: UIColor = UIColor.doordeckTextColour(0.9)) -> NSAttributedString  {
        
        let preferredDescriptor = UIFont.preferredFont(forTextStyle: UIFont.TextStyle.subheadline)
        let attrs = createAttributeWithSystemFont(UIFont.systemFont(ofSize: preferredDescriptor.pointSize, weight: UIFont.Weight.bold),
                                                  colour: colour,
                                                  kerning: 0.2)
        
        return NSAttributedString (string: string, attributes: attrs)
        
    }
    
    /// returns size 15 attributed String
    ///
    /// - Parameters:
    ///   - string: string
    ///   - colour: text colour
    /// - Returns: NSAttributedString
    class func doordeckH3 (_ string: String, colour: UIColor = UIColor.doordeckTextColour(0.9)) -> NSAttributedString  {
        
        let preferredDescriptor = UIFont.preferredFont(forTextStyle: UIFont.TextStyle.subheadline)
        let attrs = createAttributeWithSystemFont(UIFont.systemFont(ofSize: preferredDescriptor.pointSize, weight: UIFont.Weight.regular),
                                                  colour: colour,
                                                  kerning: 0.2)
        
        return NSAttributedString (string: string, attributes: attrs)
        
    }
    
    /// returns size 17 Bold attributed String
    ///
    /// - Parameters:
    ///   - string: string
    ///   - colour: text colour
    /// - Returns: NSAttributedString
    class func doordeckH2Bold (_ string: String, colour: UIColor = UIColor.doordeckTextColour(1)) -> NSAttributedString  {
        
        let preferredDescriptor = UIFont.preferredFont(forTextStyle: UIFont.TextStyle.headline)
        let attrs = createAttributeWithSystemFont(UIFont.systemFont(ofSize: preferredDescriptor.pointSize, weight: UIFont.Weight.bold),
                                                  colour: colour,
                                                  kerning: 0.2)
        
        return NSAttributedString (string: string, attributes: attrs)
        
    }
    
    /// returns size 22 Bold attributed String
    ///
    /// - Parameters:
    ///   - string: string
    ///   - colour: text colour
    /// - Returns: NSAttributedString
    class func doordeckH1Bold (_ string: String, colour: UIColor = UIColor.doordeckTextColour(1)) -> NSAttributedString  {
        
        let preferredDescriptor = UIFont.preferredFont(forTextStyle: UIFont.TextStyle.title2)
        let attrs = createAttributeWithSystemFont(UIFont.systemFont(ofSize: preferredDescriptor.pointSize, weight: UIFont.Weight.bold),
                                                  colour: colour,
                                                  kerning: 0.6)
        
        return NSAttributedString (string: string, attributes: attrs)
        
    }
    
    /////////////////////////////////////////////////////////////////////////////////////////////////////////
    /////////////////////////////////////////////////////////////////////////////////////////////////////////
    /////////////////////////////////////////////////////////////////////////////////////////////////////////
    
    
    /// returns size 16 attributed String
    ///
    /// - Parameters:
    ///   - string: string
    ///   - colour: text colour
    /// - Returns: NSAttributedString
    class func doorFootnote (_ string: String, colour: UIColor) -> NSAttributedString  {
        
        let preferredDescriptor = UIFont.preferredFont(forTextStyle: UIFont.TextStyle.footnote)
        let attrs = createAttributeWithSystemFont(UIFont.systemFont(ofSize: preferredDescriptor.pointSize, weight: UIFont.Weight.bold),
                                                  colour: colour,
                                                  kerning: 0)
        
        return NSAttributedString (string: string, attributes: attrs)
        
    }
    
    /// returns size 17 attributed String
    ///
    /// - Parameters:
    ///   - string: string
    ///   - colour: text colour
    /// - Returns: NSAttributedString
    class func doorStandard (_ string: String, colour: UIColor) -> NSAttributedString  {
        
        let preferredDescriptor = UIFont.preferredFont(forTextStyle: UIFont.TextStyle.body)
        let attrs = createAttributeWithSystemFont(UIFont.systemFont(ofSize: preferredDescriptor.pointSize, weight: UIFont.Weight.regular),
                                                  colour: colour,
                                                  kerning: 0)
        
        return NSAttributedString (string: string, attributes: attrs)
        
    }
    
    
    /// returns size 22 attributed String
    ///
    /// - Parameters:
    ///   - string: string
    ///   - colour: text colour
    /// - Returns: NSAttributedString
    class func doorTitle (_ string: String, colour: UIColor) -> NSAttributedString  {
        
        let preferredDescriptor = UIFont.preferredFont(forTextStyle: UIFont.TextStyle.title2)
        let attrs = createAttributeWithSystemFont(UIFont.systemFont(ofSize: preferredDescriptor.pointSize, weight: UIFont.Weight.bold),
                                                  colour: colour,
                                                  kerning: 0)
        
        return NSAttributedString (string: string, attributes: attrs)
    }
    
    /// returns size 20 attributed String
    ///
    /// - Parameters:
    ///   - string: string
    ///   - colour: text colour
    /// - Returns: NSAttributedString
    class func doorTextField (_ string: String, colour: UIColor) -> NSAttributedString  {
        
        let preferredDescriptor = UIFont.preferredFont(forTextStyle: UIFont.TextStyle.title3)
        let attrs = createAttributeWithSystemFont(UIFont.systemFont(ofSize: preferredDescriptor.pointSize, weight: UIFont.Weight.regular),
                                                  colour: colour,
                                                  kerning: 0)
        
        return NSAttributedString (string: string, attributes: attrs)
    }
    
    /// returns size 20 attributed String
    ///
    /// - Parameters:
    ///   - string: string
    ///   - colour: text colour
    /// - Returns: NSAttributedString
    class func doorTextFieldBold (_ string: String, colour: UIColor) -> NSAttributedString  {
        
        let preferredDescriptor = UIFont.preferredFont(forTextStyle: UIFont.TextStyle.title3)
        let attrs = createAttributeWithSystemFont(UIFont.systemFont(ofSize: preferredDescriptor.pointSize, weight: UIFont.Weight.bold),
                                                  colour: colour,
                                                  kerning: 0)
        
        return NSAttributedString (string: string, attributes: attrs)
    }
    
    
    /// returns size 28 attributed String
    ///
    /// - Parameters:
    ///   - string: string
    ///   - colour: text colour
    /// - Returns: NSAttributedString
    class func doorHugeTitle (_ string: String, colour: UIColor) -> NSAttributedString  {
        
        let preferredDescriptor = UIFont.preferredFont(forTextStyle: UIFont.TextStyle.title1)
        let attrs = createAttributeWithSystemFont(UIFont.systemFont(ofSize: preferredDescriptor.pointSize, weight: UIFont.Weight.bold),
                                                  colour: colour,
                                                  kerning: 0)
        
        return NSAttributedString (string: string, attributes: attrs)
    }
    

    /// - Parameters:
    ///   - string: string
    ///   - colour: text colour
    ///   - pointSize: dynamic pointsize
    /// - Returns: NSAttributedString
    class func doorGinormousTitle (_ string: String, colour: UIColor, pointSize: CGFloat) -> NSAttributedString  {
        
        let attrs = createAttributeWithSystemFont(UIFont.systemFont(ofSize: pointSize, weight: UIFont.Weight.bold),
                                                  colour: colour,
                                                  kerning: 0)
        
        return NSAttributedString (string: string, attributes: attrs)
    }
    
}


