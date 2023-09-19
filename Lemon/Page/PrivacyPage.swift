//
//  PrivacyPage.swift
//  Lemon
//
//  Created by yangjian on 2023/9/11.
//

import UIKit

class PrivacyPage: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "Privacy Policy"
        navigationItem.leftBarButtonItem = UIBarButtonItem(image: UIImage(named: "back")?.withRenderingMode(.alwaysOriginal), style: .plain, target: self, action: #selector(back))
    }

    @objc func back() {
        dismiss(animated: true)
    }
}
