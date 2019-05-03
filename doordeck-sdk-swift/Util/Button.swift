//
//  Button.swift
//  doordeck-sdk-swift
//
//  Copyright © 2019 Doordeck. All rights reserved.
//

import UIKit
extension UIButton {

        fileprivate func createButton(_ titleNormal: NSAttributedString,
                                      titleHighlighted: NSAttributedString,
                                      titleDisabled: NSAttributedString,
                                      borderColour: UIColor,
                                      backgroundColour: UIColor,
                                      borderWidth: CGFloat,
                                      cornerRadious: CGFloat,
                                      gradient: CAGradientLayer? ) {
            
            self.setAttributedTitle(titleNormal, for: UIControl.State.normal)
            self.setAttributedTitle(titleHighlighted, for: UIControl.State.highlighted)
            self.setAttributedTitle(titleDisabled, for: UIControl.State.disabled)
            self.layer.cornerRadius = cornerRadious
            self.layer.borderColor = borderColour.cgColor
            self.layer.borderWidth = borderWidth
            self.backgroundColor = backgroundColour
            if (gradient != nil) {
                self.layer.addSublayer(gradient!)
            }
            self.clipsToBounds = true
        }
        
        fileprivate func CTACustom(_ titleNormal: NSAttributedString,
                                   titleHighlighted: NSAttributedString,
                                   titleDisabled: NSAttributedString,
                                   backgroundColour: UIColor,
                                   cornerRadius: CGFloat,
                                   gradient: CAGradientLayer? ) {
            
            createButton(titleNormal,
                         titleHighlighted: titleHighlighted,
                         titleDisabled: titleDisabled,
                         borderColour: UIColor.clear,
                         backgroundColour: backgroundColour,
                         borderWidth: 0.0,
                         cornerRadious: cornerRadius,
                         gradient: gradient)
            
        }
        
        func doorButton(_ title: String, textColour: UIColor = .white, backgroundColour: UIColor = .clear, cornerRadius: CGFloat = 15) {
            
            CTACustom(NSAttributedString.doorStandard(title, colour: textColour),
                      titleHighlighted: NSAttributedString.doorStandard(title, colour: textColour),
                      titleDisabled: NSAttributedString.doorStandard(title, colour: textColour),
                      backgroundColour: backgroundColour,
                      cornerRadius: cornerRadius,
                      gradient: nil)
        }
}

extension UIButton {
    
    func doordeckStandardButton(_ title: String, backgroundColour: UIColor = UIColor.doordeckButtons()) {
        CTACustom(NSAttributedString.doordeckH3Bold(title, colour: UIColor.doordeckTextColour(1)),
                  titleHighlighted: NSAttributedString.doordeckH3Bold(title, colour: UIColor.doordeckTextColour(1)),
                  titleDisabled: NSAttributedString.doordeckH3Bold(title, colour: UIColor.doordeckTextColour(1)),
                  backgroundColour: backgroundColour,
                  cornerRadius: 0,
                  gradient: nil)
    }
    
    func doordeckButtonWhiteBorder(_ title: String) {
        
        createButton(NSAttributedString.doordeckH4Bold(title, colour: .white),
                     titleHighlighted: NSAttributedString.doordeckH4Bold(title, colour: .white),
                     titleDisabled: NSAttributedString.doordeckH4Bold(title, colour: .white),
                     borderColour: .white,
                     backgroundColour: UIColor.clear,
                     borderWidth: 1.0,
                     cornerRadious: 10,
                     gradient: nil)
    }
    
}
