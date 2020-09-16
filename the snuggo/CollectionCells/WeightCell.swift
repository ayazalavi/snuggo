//
//  WeightCell.swift
//  the snuggo
//
//  Created by Miranz  Technologies on 9/15/20.
//  Copyright © 2020 Ayaz Alavi. All rights reserved.
//

import Foundation
import UIKit

class WeightCell: UICollectionViewCell {
    
    var data: SeatData? {
        didSet {
            if let data = data {
                weight.text = "\(data.weight)"
            }
        }
    }
    
    var error: ErrorMessage? {
        didSet {
            if let error = error {
                label.textColor = .red
                label.text = error.longMessage.contains("too small") ? "Weight Is: LOW" : "Weight Is: HEAVY"
                weight.textColor = .red
            }
            else {
                label.textColor = UIColor(red: 70.0/255.0, green: 155.0/255.0, blue: 198.0/255.0, alpha: 1.0)
                label.text = "Weight Is: OK"
                weight.textColor = .black
            }
        }
    }
    
    lazy var backgroundImage: UIImageView = {
        let image = UIImageView(image: #imageLiteral(resourceName: "scales"))
        image.frame = CGRect(x: 0, y: self.frame.size.height/2 - 75 - 20, width: self.frame.size.width, height: 150)
        image.contentMode = .scaleAspectFit
        return image
    }()
    
    lazy var weight: UILabel = {
        let lbl = UILabel(frame: CGRect(x: (backgroundImage.frame.origin.x + backgroundImage.frame.size.width/2 ) - 15, y: (backgroundImage.frame.size.height/2 + backgroundImage.frame.origin.y) - 25, width: 50, height: 30))
        lbl.font = UIFont(name: "Hiragino Sans W3", size: 20)
        lbl.textColor = .black
        lbl.textAlignment = .center
        return lbl
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
        addSubview(weight)
    }
}
