//
//  LoadView.swift
//  Lemon
//
//  Created by yangjian on 2023/9/23.
//

import Foundation
import UIKit

class LoadingView: UIView, NibLoadable {
    @IBOutlet weak var icon: UIImageView!
        
    override  func awakeFromNib() {
        super.awakeFromNib()
        rotate360Degree()
    }
    
    func rotate360Degree() {
        let rotationAnimation = CABasicAnimation(keyPath: "transform.rotation.z") // 让其在z轴旋转
        rotationAnimation.toValue = NSNumber(value: Double.pi * 2.0) // 旋转角度
        rotationAnimation.duration = 0.6 // 旋转周期
        rotationAnimation.isCumulative = true // 旋转累加角度
        rotationAnimation.repeatCount = Float(Int.max) // 旋转次数
        icon.layer.add(rotationAnimation, forKey: "rotationAnimation")
    }
    
    override func removeFromSuperview() {
        super.removeFromSuperview()
        stopRotate()
    }

    func stopRotate() {
        icon.layer.removeAllAnimations()
    }
}

protocol NibLoadable {
}

extension NibLoadable where Self : UIView {
    static func loadFromNib(_ nibname: String? = nil) -> Self {//Self (大写) 当前类对象
        //self(小写) 当前对象
        let loadName = nibname == nil ? "\(self)" : nibname!
        
          return Bundle.main.loadNibNamed(loadName, owner: nil, options: nil)?.first as! Self
    }
    
    static func present() {
        if let view = (UIApplication.shared.connectedScenes.first as? UIWindowScene)?.keyWindow {
            let progressView = Self.loadFromNib()
            progressView.frame = UIScreen.main.bounds
            view.addSubview(progressView)
        }
    }
    
    static func dismiss() {
        if let view = (UIApplication.shared.connectedScenes.first as? UIWindowScene)?.keyWindow {
            view.subviews.filter({
                $0.classForCoder == Self.classForCoder()
            }).first?.removeFromSuperview()
        }
    }
}

