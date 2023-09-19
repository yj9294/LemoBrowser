//
//  UIViewExt.swift
//  Lemon
//
//  Created by yangjian on 2023/9/7.
//

import Foundation
import UIKit

struct UIViewKey {
    static let cornerRadius: String = "cornerRadius"
    static let masksToBounds: String = "masksToBounds"
    static let borderColor: String = "borderColor"
    static let borderWidth: String = "borderWidth"
}

extension UIView {
    
    @IBInspectable
    var cornerRadisu: Double {
        set {
            self.layer.cornerRadius = newValue
            self.layer.masksToBounds = true
            objc_setAssociatedObject(self, UIViewKey.cornerRadius, newValue, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
        }
        
        get {
            (objc_getAssociatedObject(self, UIViewKey.cornerRadius) as? Double) ?? 0.0
        }
    }
    
    @IBInspectable
    var borderColor: UIColor {
        set {
            self.layer.borderColor = newValue.cgColor
            objc_setAssociatedObject(self, UIViewKey.borderColor, newValue, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
        }
        
        get {
            (objc_getAssociatedObject(self, UIViewKey.borderColor) as? UIColor) ?? .clear
        }
    }
    
    @IBInspectable
    var borderWidth: Double {
        set {
            self.layer.borderWidth = newValue
            objc_setAssociatedObject(self, UIViewKey.borderWidth, newValue, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
        }
        
        get {
            (objc_getAssociatedObject(self, UIViewKey.borderWidth) as? Double) ?? 0.0
        }
    }
}


extension UIViewController {
    func alert(_ message: String) {
        let vc = UIAlertController(title: message, message: nil, preferredStyle: .alert)
        view.window?.rootViewController?.present(vc, animated: true)
        DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
            vc.dismiss(animated: true)
        }
    }
}
