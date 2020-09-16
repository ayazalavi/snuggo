//
//  CarSeatDisplay.swift
//  the snuggo
//
//  Created by Miranz  Technologies on 9/15/20.
//  Copyright © 2020 Ayaz Alavi. All rights reserved.
//

import Foundation
import UIKit

class CarSeatDisplay: UIView {
    private lazy var button: UIButton = {
        let button = UIButton(type: .custom)
        button.setTitle("-", for:.normal)
        button.setTitle("", for:.selected)
        button.setImage(UIImage(), for: .normal)
        button.setImage(#imageLiteral(resourceName: "greentick copy"), for: .selected)
        button.layer.cornerRadius = 16.5
        button.layer.borderColor = UIColor.white.cgColor
        button.layer.borderWidth = 3
        button.frame = CGRect(x: 20, y: self.frame.size.height/2 - 16.5, width: 33, height: 33)
        button.isUserInteractionEnabled = false
        //button.addTarget(self, action: #selector(buttonTapped), for: .touchUpInside)
        return button
    }()
    
    private lazy var label: UILabel = {
        let lbl = UILabel(frame: CGRect(origin: CGPoint(x: 53, y: self.frame.size.height/2 - 10.5), size: CGSize(width: 99, height: 21)))
        lbl.text = "Car Seat"
        lbl.font = UIFont(name: "Hiragino Sans W3", size: 16)
        lbl.textColor = .white
        lbl.textAlignment = .center
        //button.addTarget(self, action: #selector(buttonTapped), for: .touchUpInside)
        return lbl
    }()
       
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setupView()
    }

    private func setupView() {
        addSubview(button)
        addSubview(label)
        setCardSeat(powerDown: true, otherError: false)
    }
       
    func setCardSeat(powerDown: Bool, otherError: Bool) {
        if powerDown {
            button.isSelected = false
            button.setTitle("-", for: .normal)
            button.setTitleColor(.white, for: .normal)
        }
        else if otherError {
            button.isSelected = false
            button.setTitle("!", for: .normal)
            button.setTitleColor(.red, for: .normal)
        }
        else {
            button.isSelected = true
        }
    }
}
