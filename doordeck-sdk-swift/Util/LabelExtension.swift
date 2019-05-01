//
//  LabelExtension.swift
//  doordeck-sdk-swift-sample
//
//  Created by Marwan on 03/05/2019.
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
