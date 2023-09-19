//
//  CleanPage.swift
//  Lemon
//
//  Created by yangjian on 2023/9/11.
//

import UIKit
import GADUtil

class CleanPage: UIViewController {

    
    @IBOutlet weak var animatView: UIImageView!
    var timer: Timer? = nil
    var progress: Double = 0.0
    var duration: Double  = 12.5


    override func viewDidLoad() {
        super.viewDidLoad()
        BrowserUtil.shared.item.webView.removeFromSuperview()
        BrowserUtil.shared.clean(from: self)
        starAnimation()
        timer = Timer.scheduledTimer(timeInterval: 0.01, target: self, selector: #selector(progressing), userInfo: nil, repeats: true)
    }

    func starAnimation() {
        UIView.animate(withDuration: 1.5, delay: 0) {
            self.animatView.transform = CGAffineTransformMakeRotation(.pi * 1)
        } completion: { ret  in
            UIView.animate(withDuration: 1.5, delay: 0) {
                self.animatView.transform = CGAffineTransformMakeRotation(0)
            } completion: { ret  in
                self.starAnimation()
            }
        }
    }
    
    func stopAnimation() {
        animatView.layer.removeAllAnimations()
    }
    
    @objc  func progressing() {
        progress += 0.01 / duration
        if progress >= 1.0 {
            timer?.invalidate()
            timer = nil
            GADUtil.share.show(.interstitial, from: self) { [weak self] _ in
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.25) {
                    self?.stopAnimation()
                    self?.dismiss(animated: true)
                }
            }
        }
        
        if GADUtil.share.appenterbackground == true {
            timer?.invalidate()
            timer = nil
        }
        
        if progress > 0.2, GADUtil.share.isLoaded(.interstitial) {
            duration = 0.1
        }
    }
}
