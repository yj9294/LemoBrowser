//
//  LaunchPage.swift
//  Lemon
//
//  Created by yangjian on 2023/9/7.
//

import UIKit
import GADUtil

class LaunchPage: UIViewController {
    
    @IBOutlet weak var progressConstraint: NSLayoutConstraint!
    
    var timer: Timer? = nil
    
    var duration = 12.5
    
    var progress: Double = 0.0{
        didSet {
            if progress > 1.0 {
                progress = 1.0
            }
            progressConstraint.constant = (UIScreen.main.bounds.width - 140 - 2) * progress
        }
    }
    
    deinit {
        debugPrint("\(self) deinit!!!!")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        if timer != nil {
            timer?.invalidate()
            timer = nil
        }
        timer = Timer.scheduledTimer(timeInterval: 0.01, target: self, selector: #selector(progressing), userInfo: nil, repeats: true)
        GADUtil.share.load(.interstitial)
        GADUtil.share.load(.native)
        NetworkUtil.shared.startMonitoring()
    }
    
    @objc func progressing() {
        progress += 0.01 / duration
        if progress >= 1.0 {
            timer?.invalidate()
            timer = nil
            GADUtil.share.show(.interstitial) { _ in
                NotificationCenter.default.post(name: .didEnterHome, object: nil)
            }
        }
        
        if GADUtil.share.appenterbackground == true {
            timer?.invalidate()
            timer = nil
        }
        
        if progress > 0.4, GADUtil.share.isLoaded(.interstitial) {
            duration = 0.1
        }
    }

}
