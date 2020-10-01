//
//  LabelExtension.swift
//  doordeck-sdk-swift-sample
//
//  Copyright © 2019 Doordeck. All rights reserved.
//

import UIKit

extension UILabel {
    func doordeckLabel() {
        self.backgroundColor = UIColor.doordeckSecondaryColour()
        self.layer.cornerRadius = 10.0
        self.clipsToBounds = true
    }
}
