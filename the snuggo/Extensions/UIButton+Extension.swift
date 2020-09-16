//
//  UIButton+Extension.swift
//  the snuggo
//
//  Created by Miranz  Technologies on 9/15/20.
//  Copyright © 2020 Ayaz Alavi. All rights reserved.
//

import Foundation
import UIKit

extension UIButton {
    
    static func customButton (image: UIImage, tintColor: UIColor, selector: Selector?, target: Any?) -> UIButton {
        let backButton = UIButton(type: .custom)
        backButton.frame = .zero
        backButton.setImage(image, for: .normal)
        backButton.setImage(image, for: .highlighted)
        backButton.setImage(image, for: .selected)
        if let selector = selector {
            backButton.addTarget(target, action: selector, for: .touchUpInside)
        }
        backButton.imageView?.tintColor = tintColor
        return backButton
    }
}
