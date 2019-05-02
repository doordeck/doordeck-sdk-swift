//
//  UimageViewExtension.swift
//  doordeck-sdk-swift-sample
//
//  Created by Marwan on 02/05/2019.
//  Copyright © 2019 Doordeck. All rights reserved.
//

import UIKit

extension UIImageView {
    func setImageColor(color: UIColor) {
        let templateImage = self.image?.withRenderingMode(.alwaysTemplate)
        self.image = templateImage
        self.tintColor = color
    }
}
