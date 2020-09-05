//
//  ViewController.swift
//  the snuggo
//
//  Created by Miranz  Technologies on 9/5/20.
//  Copyright © 2020 Ayaz Alavi. All rights reserved.
//

import UIKit

class ViewController: UIViewController, UITextViewDelegate {

    @IBOutlet weak var loginLabel: UITextView!
    @IBOutlet weak var termsLabel: UITextView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        guard let loginLabel = loginLabel else { return }
        if let attributedText = loginLabel.attributedText, let range = attributedText.string.range(of: "LOGIN") {
            let attribute_ = NSMutableAttributedString(attributedString: attributedText)
            let range = NSRange(range, in: attributedText.string)
            attribute_.addAttribute(NSAttributedString.Key.link, value: "Login", range:range)
            loginLabel.attributedText = attribute_
            loginLabel.linkTextAttributes = [NSAttributedString.Key.foregroundColor: UIColor(red: 50/255, green: 129/255, blue: 221/255, alpha: 1)];
        }
        guard let termsLabel = termsLabel else { return }
        if let attributedText = termsLabel.attributedText, let range = attributedText.string.range(of: "Terms of use"), let range2 = attributedText.string.range(of: "privacy policy") {
            let attribute_ = NSMutableAttributedString(attributedString: attributedText)
            let range = NSRange(range, in: attributedText.string)
            attribute_.addAttribute(NSAttributedString.Key.link, value: "Terms", range:range)
            let range2 = NSRange(range2, in: attributedText.string)
            attribute_.addAttribute(NSAttributedString.Key.link, value: "Privacy", range:range2)
            termsLabel.attributedText = attribute_
            termsLabel.linkTextAttributes = [NSAttributedString.Key.foregroundColor: UIColor(red: 50/255, green: 129/255, blue: 221/255, alpha: 1)];
        }
    }
    
    func textView(_ textView: UITextView, shouldInteractWith URL: URL, in characterRange: NSRange, interaction: UITextItemInteraction) -> Bool {
        switch URL.absoluteString {
            case "Login":
                self.dismiss(animated: true, completion: nil)
                if self.presentingViewController is ViewController {
                    self.presentingViewController?.dismiss(animated: true, completion: nil)                    
                }
            case "Terms":
                print("terms")
            case "Privacy":
                print("privacy")
            default:
                print(404)
        }
        return false
    }

    @IBAction func gotoLogin(_ sender: UIButton) {
        self.dismiss(animated: true, completion: nil)
        self.presentingViewController?.dismiss(animated: true, completion: nil)
    }
}

