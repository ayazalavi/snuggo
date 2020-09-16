//
//  SeatBeltCell.swift
//  the snuggo
//
//  Created by Miranz  Technologies on 9/15/20.
//  Copyright © 2020 Ayaz Alavi. All rights reserved.
//

import Foundation
import UIKit

class SeatBeltCell: UICollectionViewCell {
    var data: Product? {
        didSet {
            guard let data = self.data else { return }
            if error == nil {
                label.textColor = UIColor(red: 70.0/255.0, green: 155.0/255.0, blue: 198.0/255.0, alpha: 1.0)
                label.text = data.title                
            }
            backgroundImage.image = UIImage(named: data.photo)
        }
    }
    var error: ErrorMessage? {
        didSet {
            if let error = self.error {
                label.textColor = .red
                label.text = error.shortMessage
            }
        }
    }
    
    lazy var backgroundImage: UIImageView = {
        let image = UIImageView()
        image.frame = CGRect(x: 0, y: self.frame.size.height/2 - 75 - 20, width: self.frame.size.width, height: 150)
        image.contentMode = .scaleAspectFit
        return image
    }()
    
    lazy var label: UILabel = {
        let lbl = UILabel(frame: CGRect(x: 0, y: backgroundImage.frame.size.height + backgroundImage.frame.origin.y, width: self.frame.size.width, height: 30))
        lbl.font = UIFont(name: "Hiragino Sans W3", size: 14)
        lbl.textAlignment = .center
        return lbl
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupViews()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setupViews() {
        addSubview(backgroundImage)
        addSubview(label)
    }
}
