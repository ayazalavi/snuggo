//
//  ErrorCell.swift
//  the snuggo
//
//  Created by Miranz  Technologies on 9/15/20.
//  Copyright © 2020 Ayaz Alavi. All rights reserved.
//

import Foundation
import UIKit

class ErrorCell: UICollectionViewCell {
    var data: SeatData?
    var error: ErrorMessage?  {
        didSet {
            if let error = error {
                label.text = error.longMessage
                button.isHidden = error.shortMessage.contains("CHILD LEFT") ? true : false
                if button.isHidden {
                    label.sizeToFit()
                    label.frame.origin.y = self.frame.size.height/2 - label.frame.size.height/2
                }
            }
        }
    }
    
    lazy var errorImage: UIImageView = {
        let image = UIImageView(image: #imageLiteral(resourceName: "31-314229_transparent-internet-clipart-free-icon-exclamation-mark-hd"))
        image.frame = CGRect(x: label.frame.origin.x + label.frame.size.width - 70 , y: 30, width: 44, height: 44)
        image.contentMode = .scaleAspectFit
        return image
    }()
    
    lazy var label: UITextView = {
        let lbl = UITextView(frame: CGRect(x: self.frame.size.width/2 - 100, y: self.frame.size.height/2 - 50 - 20, width: 200, height: 100))
        lbl.isEditable = false
        lbl.backgroundColor = .clear
        lbl.textColor = .red
        lbl.font = UIFont(name: "Hiragino Sans W3", size: 12)
        lbl.textAlignment = .center
        return lbl
    }()
    
    lazy var button: LoginButton = {
        let btn = LoginButton(frame: CGRect(x: self.frame.size.width / 2 - 50, y: label.frame.size.height + label.frame.origin.y + 10, width: 100, height: 40))
        btn.titleLabel?.font = UIFont(name: "Hiragino Sans W3", size: 12)
        btn.backgroundColor = UIColor(red: 245/255.0, green: 44/255.0, blue: 65/255.0, alpha: 1.0)
        btn.setTitleColor(.white, for: .normal)
        btn.setTitleColor(.white, for: .highlighted)
        btn.setTitle("Click Here", for: .normal)
        btn.setTitle("Click Here", for: .highlighted)
        return btn
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupViews()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setupViews() {
        addSubview(label)
        addSubview(button)
        addSubview(errorImage)
    }
}
