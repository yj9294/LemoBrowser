//
//  TranslateFailPage.swift
//  Lemon
//
//  Created by yangjian on 2023/9/26.
//

import UIKit

class TranslateFailPage: UIViewController {
    
    var confirm: (()->Void)? = nil

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    @IBAction func back() {
        dismiss(animated: true)
    }
    
    @IBAction func translate() {
        dismiss(animated: true)
        confirm?()
    }
}
