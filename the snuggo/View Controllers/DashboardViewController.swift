//
//  ViewController.swift
//  the snuggo
//
//  Created by Miranz  Technologies on 9/5/20.
//  Copyright © 2020 Ayaz Alavi. All rights reserved.
//

import UIKit

class DashboardViewController: UIViewController {

    @IBOutlet weak var pager: UIView!
    @IBOutlet weak var product_image: UIImageView!
    @IBOutlet weak var parent_view: UIView!
    var products: [Product]?
    var current = 0
    var animating = false
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        self.navigationController?.navigationBar.setBackgroundImage(UIImage(), for: .default)
        self.navigationController?.navigationBar.shadowImage = UIImage()
        navigationItem.rightBarButtonItem = UIBarButtonItem(customView: UIButton.customButton(image: #imageLiteral(resourceName: "addsymbol copy").withRenderingMode(.alwaysTemplate), tintColor: .white, selector: #selector(gotoCameraScreen), target: self))
        navigationItem.leftBarButtonItem = UIBarButtonItem(customView: UIButton.customButton(image: #imageLiteral(resourceName: "menuicon").withRenderingMode(.alwaysTemplate), tintColor: .white, selector: nil, target: nil))
        navigationItem.titleView = UIImageView(image: #imageLiteral(resourceName: "TheSnuggoLogowhiteSmall"))
        
        let swipeLeft = UISwipeGestureRecognizer(target: self, action: #selector(swipeProducts(_:)))
        swipeLeft.direction = .left
        let swipeRight = UISwipeGestureRecognizer(target: self, action: #selector(swipeProducts(_:)))
        swipeRight.direction = .right
        self.parent_view.addGestureRecognizer(swipeLeft)
        self.parent_view.addGestureRecognizer(swipeRight)
        
        let tapProduct = UITapGestureRecognizer(target: self, action: #selector(tapProduct(_:)))
        self.product_image.addGestureRecognizer(tapProduct)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        guard let products = Product.getAllProducts() else {
            self.parent_view.isHidden = true
            gotoCameraScreen()
            return
        }
        self.parent_view.isHidden = false
        self.products = products
        self.loadPager()
        BluetoothScanner.shared.startScanning()
    }
    
    func loadPager() {
        guard let count = self.products?.count, count > 1 else {
            self.pager.isHidden = true
            return
        }
        self.pager.isHidden = false
        let _ = self.pager.subviews.map { $0.alpha = 0.6 }
        self.pager.subviews[current % 2].alpha = 1
    }
    
    @objc func tapProduct(_ gesture: UIGestureRecognizer) {
        self.performSegue(withIdentifier: "product", sender: self)
    }
    
    @objc func gotoCameraScreen() {
        self.performSegue(withIdentifier: "camera", sender: self)
    }
    
    
    
    @objc func swipeProducts(_ gesture: UIGestureRecognizer) {
        guard let products = products, !self.animating, self.product_image != nil else { return }
        let group = DispatchGroup()
        group.notify(queue: .main) {
            self.animating = false
            //print(self.product_image.gestureRecognizers)
            //print("Animation ended")
        }
        group.enter()
        //print(self.product_image.gestureRecognizers)
        //print("Animation started")
        let frame = product_image.frame
        if let swipe = gesture as? UISwipeGestureRecognizer {
            let current_ = swipe.direction == .right ? max(current - 1, 0) : min(current + 1, products.count - 1)
            guard current != current_ && !self.animating else { return }
            current = current_
            let imageView = UIImageView(image: UIImage(named: products[current].photo))
            imageView.contentMode = self.product_image.contentMode
            self.product_image.superview?.addSubview(imageView)
            //imageView.addConstraints(self.product_image.constraints)
            imageView.frame = frame
            imageView.alpha = 0
            let margin = swipe.direction == .right ? -1*imageView.frame.size.width : imageView.frame.size.width
            imageView.frame.origin.x += margin
            self.animating = true
            UIView.animate(withDuration: 1.0, delay: 0, usingSpringWithDamping: 0.5, initialSpringVelocity: 0.2, options: .curveEaseIn, animations: {
                self.product_image.frame.origin.x -= margin
                self.product_image.alpha = 0
                imageView.frame.origin.x = frame.origin.x
                imageView.alpha = 1
                self.loadPager()
                self.product_image = nil
            }) { (_) in
                self.product_image = imageView
                let tapProduct = UITapGestureRecognizer(target: self, action: #selector(self.tapProduct(_:)))
                self.product_image.addGestureRecognizer(tapProduct)
                group.leave()
            }
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
           if segue.identifier == "product", let viewController = segue.destination as? ProductDashboard {
               viewController.product = self.products?[current]
           }
       }
    
}



