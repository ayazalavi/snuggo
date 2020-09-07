//
//  QRScannerViewController.swift
//  QRCodeReader
//
//  Created by KM, Abhilash a on 08/03/19.
//  Copyright © 2019 KM, Abhilash. All rights reserved.
//

import UIKit
import AVFoundation

class QRScannerViewController: UIViewController {
    
    @IBOutlet weak var scannerView: QRScannerView! {
        didSet {
            scannerView.delegate = self
        }
    }
    @IBOutlet weak var scanButton: UIButton! {
        didSet {
            scanButton.setTitle("STOP", for: .normal)
        }
    }
    
    var product: Product? = nil {
        didSet {
            if product != nil {
                self.scannerView.stopScanning()
                AudioServicesPlaySystemSound(SystemSoundID(kSystemSoundID_Vibrate))
                self.performSegue(withIdentifier: "product", sender: self)
            }
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.leftBarButtonItem = UIBarButtonItem(customView: UIButton.customButton(image: #imageLiteral(resourceName: "back-arrow").withRenderingMode(.alwaysTemplate), tintColor: .white, selector: #selector(popViewController), target: self))
    }
    
 
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

        if !scannerView.isRunning {
            scannerView.startScanning()
        }
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        if !scannerView.isRunning {
            scannerView.stopScanning()
        }
    }

    @IBAction func scanButtonAction(_ sender: UIButton) {
        scannerView.isRunning ? scannerView.stopScanning() : scannerView.startScanning()
        let buttonTitle = scannerView.isRunning ? "STOP" : "SCAN"
        sender.setTitle(buttonTitle, for: .normal)
    }
    
    @objc func popViewController() {
        self.navigationController?.popViewController(animated: true)
    }
}


extension QRScannerViewController: QRScannerViewDelegate {
    func qrScanningDidStop() {
    }
    
    func qrScanningDidFail() {
    }
    
    func qrScanningSucceededWithCode(_ str: String?) {
        if let str = str, let qrCode = try? JSONDecoder().decode(QRData.self, from: Data(str.utf8)) {
            if let product = data.filter({ $0.id == qrCode.product_id }).last, !product.exists {
                self.product = product
                Product.addProduct(product: product)
            }
        }
    }
    
}


extension QRScannerViewController {
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "product", let viewController = segue.destination as? ProductFoundViewController {
            viewController.product = self.product
        }
    }
}

