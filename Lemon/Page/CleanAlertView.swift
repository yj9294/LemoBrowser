//
//  CleanAlertView.swift
//  Lemon
//
//  Created by yangjian on 2023/9/11.
//

import UIKit

class CleanAlertView: UIView {
    
    var confirmHandler: (()->Void)? = nil
    
    
    static func loadView() -> CleanAlertView {
        return ((Bundle.main.loadNibNamed("CleanAlertView", owner: self)?.first as? CleanAlertView) ?? CleanAlertView(coder: NSCoder()))!
    }
    
    @IBAction func dismiss() {
        self.removeFromSuperview()
    }
    
    @IBAction func confirmAction() {
        dismiss()
        confirmHandler?()
    }
}
