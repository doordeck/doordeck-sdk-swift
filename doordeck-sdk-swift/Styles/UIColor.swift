//
//  UIColour.swift
//  doordeck-sdk-swift
//
//  Copyright © 2019 Doordeck. All rights reserved.
//

import UIKit

extension UIColor {    
    convenience init(r: CGFloat, g: CGFloat, b: CGFloat) {
        self.init(red: r / 255.0, green: g / 255.0, blue: b / 255.0, alpha: 1)
    }
    
    /// Backgrounds colour for Light (Light Grey) and Dark (primary dark blue)
    ///
    /// - Parameters:
    ///   - Used for all backgrounds
    ///   - Dark: primary dark blue
    ///   - Light: Light Grey
    /// - Returns: UIColor
    class func doordeckPrimaryColour () ->  UIColor {
        if UserDefaults().getDarkUI() {
            return doordeckDarkPrimary()
        } else {
            return doordeckLightGrey()
        }
    }
    
    /// fields, pop up menus & inactive tabs for Light (White) and Dark (secondary dark blue)
    ///
    /// - Parameters:
    ///   - used for all form fields, pop up menus & inactive tabs
    ///   - Dark: secondary dark blue
    ///   - Light: white
    /// - Returns: UIColor
    class func doordeckSecondaryColour () ->  UIColor {
        if UserDefaults().getDarkUI() {
            return doordeckDarkSecondary()
        } else {
            return .white
        }
    }
    
    /// Light (Dark Blue) and Dark (Dark Grey)
    ///
    /// - Parameters:
    ///   - Dark: Dark Grey
    ///   - Light: dark Blue
    /// - Returns: UIColor
    class func doordeckTertiaryColour () ->  UIColor {
        if UserDefaults().getDarkUI() {
            return doordeckDarkGrey()
        } else {
            return doordeckDarkPrimary()
        }
    }
    
    /// Light (Very Dark Blue) and Dark (Light Grey)
    ///
    /// - Parameters:
    ///   - used for all form fields, pop up menus & inactive tabs
    ///   - Dark: Light Grey
    ///   - Light: Very Dark Blue
    /// - Returns: UIColor
    class func doordeckQuaternaryColour () ->  UIColor {
        if UserDefaults().getDarkUI() {
            return doordeckLightGrey()
        } else {
            return doordeckDarkSecondary()
        }
    }
    
    /// Light (Dark Turquoise) and Dark (Dark Turquoise)
    ///
    /// - Parameters:
    ///   - used for all form fields, pop up menus & inactive tabs
    ///   - Dark: Dark Turquoise
    ///   - Light: Dark Turquoise
    /// - Returns: UIColor
    class func doordeckQuinaryColour () ->  UIColor {
        return doordeckDarkTurquoise()
    }
    
    
    /// Light (Light Turquoise) and Dark (Light Turquoise)
    ///
    /// - Parameters:
    ///   - used for all form fields, pop up menus & inactive tabs
    ///   - Dark: Light Turquoise
    ///   - Light: Light Turquoise
    /// - Returns: UIColor
    class func doordeckSenaryColour () ->  UIColor {
        return doordeckLightTurquoise()
    }
    
    /// Light (White) and Dark (Secondary dark blue)
    ///
    /// - Parameters:
    ///   - used for all form fields, pop up menus & inactive tabs
    ///   - Dark: secondary dark blue
    ///   - Light: white
    /// - Returns: UIColor
    class func doordeckSeptenaryColour () ->  UIColor {
        if UserDefaults().getDarkUI() {
            return doordeckDarkSecondary()
        } else {
            return .white
        }
    }
    
    /// used for all buttons Light (Light Turquoise) and Dark (Dark Turquoise)
    ///
    /// - Parameters:
    ///   - used for all buttons
    ///   - Dark: Dark Turquoise
    ///   - Light: Light Turquoise
    /// - Returns: UIColor
    class func doordeckButtons () ->  UIColor {
        if UserDefaults().getDarkUI() {
            return doordeckDarkTurquoise()
        } else {
            return doordeckLightTurquoise()
        }
    }
    
    /// used for all button hover states Light (Dark Turquoise) and Dark (Light Turquoise)
    ///
    /// - Parameters:
    ///   - used for all button hover states
    ///   - Dark: Light Turquoise
    ///   - Light: Dark Turquoise
    /// - Returns: UIColor
    class func doordeckButtonsPress () ->  UIColor {
        if UserDefaults().getDarkUI() {
            return doordeckDarkTurquoise()
        } else {
            return doordeckLightTurquoise()
        }
    }
    
    /// used for all successful in app notifications Light (Green) and Dark (Green)
    ///
    /// - Parameters:
    ///   - used for all successful in app notifications
    ///   - Doordeck Green
    /// - Returns: UIColor
    class func doordeckSuccefullNotification () ->  UIColor {
        return doordeckGreen()
    }
    
    /// Text colour Light (black) and Dark (white)
    ///
    /// - Parameters:
    ///   - text Colour
    /// - Returns: UIColor
    class func doordeckTextColour (_ opacity: CGFloat) ->  UIColor {
        if UserDefaults().getDarkUI() {
            return doordeckWhite(opacity)
        } else {
            return doordeckBlack(opacity)
        }
    }
    
    
    /// Green Sucess Colour
    ///
    /// - Parameters:
    ///   - Doordeck Green
    /// - Returns: UIColor
    class func doordeckSuccessGreen () ->  UIColor {
        return UIColor (red: 51.0/255.0, green: 206.0/255.0, blue: 76.0/255.0, alpha: 1.0)
    }
    
    /// Red Fail Colour
    ///
    /// - Parameters:
    ///   - Doordeck Red
    /// - Returns: UIColor
    class func doordeckFailRed () ->  UIColor {
        return UIColor (red: 249.0/255.0, green: 50.0/255.0, blue: 81.0/255.0, alpha: 1.0)
    }
    
    /////////////////////////////////////////////////////////////////////
    //NewColour Pallet
    /////////////////////////////////////////////////////////////////////
    
    private class func doordeckDarkPrimary () -> UIColor {
        return UIColor (red: 0.0/255.0, green: 40.0/255.0, blue: 60.0/255.0, alpha: 1.0)
    }
    
    private class func doordeckDarkSecondary () -> UIColor {
        return UIColor (red: 4.0/255.0, green: 28.0/255.0, blue: 42.0/255.0, alpha: 1.0)
    }
    
    private class func doordeckDarkGrey () -> UIColor {
        return UIColor (red: 72.0/255.0, green: 73.0/255.0, blue: 74.0/255.0, alpha: 1.0)
    }
    
    private class func doordeckLightGrey () -> UIColor {
        return UIColor (red: 245.0/255.0, green: 245.0/255.0, blue: 245.0/255.0, alpha: 1.0)
    }
    
    private class func doordeckDarkTurquoise () -> UIColor {
        return UIColor (red: 17.0/255.0, green: 134.0/255.0, blue: 153.0/255.0, alpha: 1.0)
    }
    
    private class func doordeckLightTurquoise () -> UIColor {
        return UIColor (red: 0.0/255.0, green: 191.0/255.0, blue: 212.0/255.0, alpha: 1.0)
    }
    
    private class func doordeckRed () -> UIColor {
        return UIColor (red: 224.0/255.0, green: 79.0/255.0, blue: 72.0/255.0, alpha: 1.0)
    }
    
    private class func doordeckBlue () -> UIColor {
        return UIColor (red: 64.0/255.0, green: 108.0/255.0, blue: 232.0/255.0, alpha: 1.0)
    }
    
    private class func doordeckGreen () -> UIColor {
        return UIColor (red: 22.0/255.0, green: 180.0/255.0, blue: 74.0/255.0, alpha: 1.0)
    }
    
    private class func doordeckPink () -> UIColor {
        return UIColor (red: 218.0/255.0, green: 102.0/255.0, blue: 219.0/255.0, alpha: 1.0)
    }
    
    private class func doordeckOrange () -> UIColor {
        return UIColor (red: 239.0/255.0, green: 114.0/255.0, blue: 0.0/255.0, alpha: 1.0)
    }
    
    private class func doordeckFuschia () -> UIColor {
        return UIColor (red: 224.0/255.0, green: 72.0/255.0, blue: 137.0/255.0, alpha: 1.0)
    }
    
    private class func doordeckNavy () -> UIColor {
        return UIColor (red: 63.0/255.0, green: 63.0/255.0, blue: 172.0/255.0, alpha: 1.0)
    }
    
    private class func doordeckCharcoal () -> UIColor {
        return UIColor (red: 78.0/255.0, green: 78.0/255.0, blue: 78.0/255.0, alpha: 1.0)
    }
    
    private class func doordeckForestGreen () -> UIColor {
        return UIColor (red: 0.0/255.0, green: 147.0/255.0, blue: 114.0/255.0, alpha: 1.0)
    }
    
    private class func doordeckCopper () -> UIColor {
        return UIColor (red: 142.0/255.0, green: 102.0/255.0, blue: 67.0/255.0, alpha: 1.0)
    }
    
    private class func doordeckWhite (_ opacity: CGFloat) -> UIColor {
        return UIColor (red: 255.0/255.0, green: 255.0/255.0, blue: 255.0/255.0, alpha: opacity)
    }
    
    private class func doordeckBlack (_ opacity: CGFloat) -> UIColor {
        return UIColor (red: 0.0/255.0, green: 0.0/255.0, blue: 0.0/255.0, alpha: opacity)
    }
    
    ////////////////////////////////////////////////////////////////
    class func doorDarkBlue () -> UIColor {
        return UIColor (red: 11.0/255.0, green: 40.0/255.0, blue: 58.0/255.0, alpha: 1.0)
    }
    
    class func doorBlue () -> UIColor {
        return UIColor (red: 4.0/255.0, green: 28.0/255.0, blue: 42.0/255.0, alpha: 1.0)
    }
    
    
    class func doorLightBlue () -> UIColor {
        return UIColor (red: 69.0/255.0, green: 189.0/255.0, blue: 209.0/255.0, alpha: 1.0)
    }
    
    class func doorDarkGrey () -> UIColor {
        return UIColor (red: 43.0/255.0, green: 43.0/255.0, blue: 43.0/255.0, alpha: 1.0)
    }
    
    class func doorGrey () -> UIColor {
        return UIColor (red: 142.0/255.0, green: 142.0/255.0, blue: 147.0/255.0, alpha: 1.0)
    }
    
    class func doorLightGrey () -> UIColor {
        return UIColor (red: 231.0/255.0, green: 231.0/255.0, blue: 231.0/255.0, alpha: 1.0)
    }
    
    class func doorSoftWhite () -> UIColor {
        return UIColor (red: 250.0/255.0, green: 250.0/255.0, blue: 250.0/255.0, alpha: 1.0)
    }
    
    class func doorRed() -> UIColor {
        return UIColor (red: 255.0/255.0, green: 45.0/255.0, blue: 78.0/255.0, alpha: 1.0)
    }
    
    class func doorGreen() -> UIColor {
        return UIColor (red: 152.0/255.0, green: 251.0/255.0, blue: 152.0/255.0, alpha: 1.0)
    }
    
    class func doorOnBoardPruple() -> UIColor {
        return UIColor(red:0.419, green: 0.279, blue:0.442, alpha:1)
    }
    
    class func doorOnBoardTeil() -> UIColor {
        return UIColor(red:0.156, green: 0.403, blue:0.483, alpha:1)
    }
    
    class func doorOnBoardGreen() -> UIColor {
        return UIColor(red:0.472, green: 0.845, blue:0.773, alpha:1)
    }
    
    class func doorOnBoardOrange() -> UIColor {
        return UIColor (red: 255.0/255.0, green: 148.0/255.0, blue: 66.0/255.0, alpha: 1.0)
    }
    
    class func returnColourForIndex(index: Int) -> String {
        let colourArray = getLockColours()
        if index < colourArray.count {
            return colourArray[index]
        } else {    
            var tempIndex = index
            while tempIndex >= colourArray.count {
                tempIndex -= colourArray.count
            }
            return colourArray[tempIndex]
        }
    }
    
    class func getLockColours () -> [String] {
        return ["#57355D","#1F5468","#314772","#24BD9A","#55678C","#FF483F","#38A3E0","#FF9442","#4FB961","#C74BD1","#E85479","#6641FF"]
    }
    
    class func hexStringToUIColor (_ hex:String) -> UIColor {
        var cString:String = hex.trimmingCharacters(in: .whitespacesAndNewlines).uppercased()
        
        if (cString.hasPrefix("#")) {
            cString.remove(at: cString.startIndex)
        }
        
        if ((cString.count) != 6) {
            return UIColor.gray
        }
        
        var rgbValue:UInt32 = 0
        Scanner(string: cString).scanHexInt32(&rgbValue)
        
        return UIColor(
            red: CGFloat((rgbValue & 0xFF0000) >> 16) / 255.0,
            green: CGFloat((rgbValue & 0x00FF00) >> 8) / 255.0,
            blue: CGFloat(rgbValue & 0x0000FF) / 255.0,
            alpha: CGFloat(1.0)
        )
    }
    
    func toHexString() -> String {
        var r:CGFloat = 0
        var g:CGFloat = 0
        var b:CGFloat = 0
        var a:CGFloat = 0
        
        getRed(&r, green: &g, blue: &b, alpha: &a)
        
        let rgb:Int = (Int)(r*255)<<16 | (Int)(g*255)<<8 | (Int)(b*255)<<0
        
        return String(format:"#%06x", rgb)
    }
    
}

