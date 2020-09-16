//
//  SnuggoWidget.swift
//  the snuggo
//
//  Created by Miranz  Technologies on 9/13/20.
//  Copyright © 2020 Ayaz Alavi. All rights reserved.
//

import Foundation
import UIKit

class TemperatureDisplay: UIView {
    
    private lazy var label: UILabel = {
        let lbl = UILabel(frame: CGRect(origin: .zero, size: self.frame.size))
        lbl.text = "-\u{B0}C Temperature"
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
        addSubview(label)
    }
       
    func setTemperature(temperature: Int, error: Bool) {
        if error {
            label.textColor = .red
        }
        else {
            label.textColor = .white
        }
        label.text = "\(temperature)\u{B0}C Temperature"
    }
}
