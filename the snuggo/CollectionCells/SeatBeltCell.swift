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
            let width = backgroundImage.frame.size.width
            let height = backgroundImage.frame.size.height
            backgroundImage.frame = CGRect(x: self.frame.size.width/2.0 - width/2.0, y: self.frame.size.height/2.0 - height/2.0 - 25, width: width, height: height)
            print(backgroundImage.image?.size, backgroundImage.frame, backgroundImage.bounds, separator: " - ")
            backgroundImage.layer.sublayers?.forEach { $0.removeFromSuperlayer() }

        }
    }

    
    func addGreenDot(position: Location, size: DOT_SIZE) {
        circle(color: .green, position: position, radius: size == DOT_SIZE.SMALL ? 5 : 10 )
            //    backgroundImage.layer.addSublayer(borderCircle(color: .green, position: position, radius: size == DOT_SIZE.SMALL ? 5 : 10 ))
    }
    
    func addRedPulse(position: Location, size: DOT_SIZE) {
        circle(color: .red, position: position, radius: size == DOT_SIZE.SMALL ? 5 : 10, animate: true )
       // backgroundImage.layer.addSublayer(borderCircle(color: .red, position: position, radius: size == DOT_SIZE.SMALL ? 5 : 10 ))
    }
    
    func getLocationPosition(location: Location, radius: CGFloat) -> CGPoint {
        switch location {
            case .TOP_CENTER:
               return CGPoint(x: backgroundImage.frame.size.width/2 + 2*radius, y: 6 * radius)
            case .BOTTOM_RIGHT:
               return CGPoint(x: backgroundImage.frame.size.width/2 + 6*radius, y: backgroundImage.frame.size.height - 4*radius)
            case .BOTTOM_CENTER:
                return CGPoint(x: backgroundImage.frame.size.width/2 - radius/2, y: backgroundImage.frame.size.height - 2*radius)
            case .BOTTOM_LEFT:
                return CGPoint(x: backgroundImage.frame.size.width/2 - 6*radius, y: backgroundImage.frame.size.height - 6*radius)
        }
    }
    
    func circle(color: UIColor, position: Location, radius: CGFloat, animate: Bool = false) {
        var pulseLayers = [CAShapeLayer]()
        for i in 0...3 {
            let bezeir = UIBezierPath(arcCenter: .zero, radius: radius+(i==0 ? 0: 2), startAngle: 0, endAngle: 2 * .pi, clockwise: true)
            let pulselayer = CAShapeLayer()
            pulselayer.path = bezeir.cgPath
            pulselayer.lineWidth = i==0 ? 0 : 2.0
            pulselayer.fillColor = i==0 ? color.cgColor : UIColor.clear.cgColor
            pulselayer.strokeColor = i==0 ? UIColor.clear.cgColor: color.cgColor
            pulselayer.lineCap = .round
            pulselayer.position = getLocationPosition(location: position, radius: radius)
            backgroundImage.layer.addSublayer(pulselayer)
            if i != 0 {
                pulseLayers.append(pulselayer)
            }
        }
        if animate {
            animatePulse(pulseLayers: pulseLayers)
        }
        
    }
    
    func animatePulse(pulseLayers: [CAShapeLayer]) {
        for (index, pulseLayer) in pulseLayers.enumerated() {
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.2*Double((index+1))) {
                let scaleAnimation = CABasicAnimation(keyPath: "transform.scale")
                scaleAnimation.duration = 1.0
                scaleAnimation.fromValue = 1.0
                scaleAnimation.toValue = 2.0
                scaleAnimation.timingFunction = CAMediaTimingFunction(name: CAMediaTimingFunctionName.easeOut)
                pulseLayer.add(scaleAnimation, forKey: "scale")
                
                let opacityAnimation = CABasicAnimation(keyPath: #keyPath(CALayer.opacity))
                opacityAnimation.duration = 1.0
                opacityAnimation.fromValue = 0.9
                opacityAnimation.toValue = 0.0
                opacityAnimation.timingFunction = CAMediaTimingFunction(name: CAMediaTimingFunctionName.easeOut)
                pulseLayer.add(opacityAnimation, forKey: "opacity")
            }
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

