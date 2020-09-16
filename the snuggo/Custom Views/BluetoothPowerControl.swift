//
//  BluetoothPowerControl.swift
//  the snuggo
//
//  Created by Miranz  Technologies on 9/15/20.
//  Copyright © 2020 Ayaz Alavi. All rights reserved.
//

import Foundation
import UIKit

class BluetoothPowerControl: UIView {
    private lazy var button: UIButton = {
        let button = UIButton(type: .custom)
        button.setImage(#imageLiteral(resourceName: "onswitch1 copy"), for: .normal)
        button.setImage(#imageLiteral(resourceName: "offswitch1 copy"), for: .selected)
        button.frame = CGRect(x: self.frame.size.width/2 - 75, y: self.frame.size.height/2 - 37.5, width: 150, height: 75)
        button.addTarget(self, action: #selector(buttonTapped), for: .touchUpInside)
        return button
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
    }
    
    @objc func buttonTapped() {
        self.setPowerState(on: self.button.isSelected, stopScanning: true)
    }
    
    func setPowerState(on: Bool, stopScanning: Bool = false) {
        self.button.isSelected = !on
        if stopScanning {
            if on {
                BluetoothScanner.shared.startScanning()
            }
            else {
                BluetoothScanner.shared.stopScanning()
            }
        }
         
    }
}
