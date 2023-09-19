//
//  TermsPage.swift
//  Lemon
//
//  Created by yangjian on 2023/9/11.
//

import UIKit

class TermsPage: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "Terms of Users"
        navigationItem.leftBarButtonItem = UIBarButtonItem(image: UIImage(named: "back")?.withRenderingMode(.alwaysOriginal), style: .plain, target: self, action: #selector(back))
    }

    @objc func back() {
        dismiss(animated: true)
    }

}
