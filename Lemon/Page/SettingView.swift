//
//  SettingView.swift
//  Lemon
//
//  Created by yangjian on 2023/9/8.
//

import UIKit
import UniformTypeIdentifiers

let AppUrl = "https://itunes.apple.com/cn/app/id6466799578"

class SettingView: UIView {
    
    @IBOutlet weak var widthConstraint: NSLayoutConstraint!
    @IBOutlet weak var leftConstraint: NSLayoutConstraint!
    
    static func loadView() -> SettingView {
        return ((Bundle.main.loadNibNamed("SettingView", owner: self)?.first as? SettingView) ?? SettingView(coder: NSCoder()))!
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
    }
    
    
    @IBAction func newAction() {
        BrowserUtil.shared.removeWebView()
        BrowserUtil.shared.add()
        dismiss()
    }
    
    @IBAction func shareAction() {
        dismiss()
        var url = AppUrl
        if !BrowserUtil.shared.item.isNavigation {
            url = BrowserUtil.shared.item.webView.url?.absoluteString ?? AppUrl
        }
        let vc = UIActivityViewController(activityItems: [url], applicationActivities: nil)
        window?.rootViewController?.present(vc, animated: true)
    }
    
    @IBAction func copyAction() {
        if !BrowserUtil.shared.item.isNavigation {
            UIPasteboard.general.setValue(BrowserUtil.shared.item.webView.url?.absoluteString ?? "", forPasteboardType: UTType.plainText.identifier)
            window?.rootViewController?.alert("Copy successfully.")
            return
        }
        UIPasteboard.general.setValue("", forPasteboardType: UTType.plainText.identifier)
        window?.rootViewController?.alert("Copy successfully.")
        dismiss()
    }
    
    @IBAction func rateAction() {
        dismiss()
        let url = URL(string: AppUrl)
        if let url = url {
            UIApplication.shared.open(url)
        }
    }
    
    @IBAction func termsAction() {
        let vc = PrivacyPage()
        let navi = UINavigationController(rootViewController: vc)
        navi.modalPresentationStyle = .fullScreen
        window?.rootViewController?.present(navi, animated: true)
    }
    
    @IBAction func privacyAction() {
        let vc = TermsPage()
        let navi = UINavigationController(rootViewController: vc)
        navi.modalPresentationStyle = .fullScreen
        window?.rootViewController?.present(navi, animated: true)
    }
    
    @IBAction func dismiss() {
        self.removeFromSuperview()
    }
}
