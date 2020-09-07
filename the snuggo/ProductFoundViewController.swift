//
//  ProductFoundViewController.swift
//  the snuggo
//
//  Created by Miranz  Technologies on 9/7/20.
//  Copyright © 2020 Ayaz Alavi. All rights reserved.
//

import Foundation
import UIKit

class ProductFoundViewController: UIViewController {
 
    @IBOutlet weak var product_image: UIImageView!
    var product: Product!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        product_image.image = UIImage(named: product.photo)
    }
    
    @IBAction func toDashBoard(_ sender: Any) {
        self.navigationController?.popToRootViewController(animated: true)
    }
    
}
