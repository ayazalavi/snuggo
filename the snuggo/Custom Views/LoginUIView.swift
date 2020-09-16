//
//  LoginUIView.swift
//  the snuggo
//
//  Created by Miranz  Technologies on 9/5/20.
//  Copyright © 2020 Ayaz Alavi. All rights reserved.
//

import Foundation
import UIKit

class LoginUIView: UIView {
  //initWithFrame to init view from code
  override init(frame: CGRect) {
    super.init(frame: frame)
    setupView()
  }
  
  //initWithCode to init view from xib or storyboard
  required init?(coder aDecoder: NSCoder) {
    super.init(coder: aDecoder)
    setupView()
  }
  
  //common func to init our view
  private func setupView() {
    layer.shadowColor = UIColor.black.cgColor
    layer.shadowOpacity = 0.16
    layer.shadowRadius = 11
    layer.shadowOffset = CGSize(width: 0, height: 5)
  }
}

