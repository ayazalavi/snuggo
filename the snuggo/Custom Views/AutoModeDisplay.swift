//
//  AutoModeDisplay.swift
//  the snuggo
//
//  Created by Miranz  Technologies on 9/15/20.
//  Copyright © 2020 Ayaz Alavi. All rights reserved.
//

import Foundation
import UIKit

class AutoModeDisplay: UIView {
    private lazy var button: UIButton = {
        let button = UIButton(type: .custom)
        button.setTitle("( A )", for:.normal)
        button.titleLabel?.font = UIFont(name: "Hiragino Sans W3", size: 12)
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
        lbl.text = "Auto-mode"
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
    }
       
    func setPowerState(on: Bool) {
        if on {
           button.layer.borderColor = UIColor.green.cgColor
        }
        else {
           button.layer.borderColor = UIColor.white.cgColor
        }
    }
}
