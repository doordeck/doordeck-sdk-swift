//
//  Button.swift
//  doordeck-sdk-swift
//
//  Created by Marwan on 01/04/2019.
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
