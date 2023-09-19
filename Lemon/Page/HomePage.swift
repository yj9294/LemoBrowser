//
//  HomePage.swift
//  Lemon
//
//  Created by yangjian on 2023/9/7.
//

import UIKit
import WebKit
import GADUtil
import AppTrackingTransparency
import IQKeyboardManagerSwift

class HomePage: UIViewController {
    
    @IBOutlet weak var tabButton: UIButton!
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var progressView: UIProgressView!
    @IBOutlet weak var searchButton: UIButton!
    @IBOutlet weak var textFiled: UITextField!
    @IBOutlet weak var contentView: UIView!
    @IBOutlet weak var backButton: UIButton!
    @IBOutlet weak var forwardButton: UIButton!
    
    @IBOutlet weak var adView: GADNativeView!
    var willAppear: Bool = false

    override func viewDidLoad() {
        super.viewDidLoad()
        collectionView.register(UINib(nibName: "HomeCell", bundle: .main), forCellWithReuseIdentifier: "HomeCell")
        ATTrackingManager.requestTrackingAuthorization { _ in
        }
        IQKeyboardManager.shared.enable = true
        adObersve()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        BrowserUtil.shared.item.webView.frame = contentView.frame
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        willAppear = true
        addObserver()
        refreshStatus()
        GADUtil.share.load(.interstitial)
        GADUtil.share.load(.native)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        willAppear = false
        GADUtil.share.disappear(.native)
    }

}

extension HomePage {
    
    @IBAction func searchAction() {
        if searchButton.isSelected {
            searchButton.isSelected = false
            progressView.isHidden = true
            BrowserUtil.shared.stopLoad()
        } else {
            progressView.isHidden = false
            search(textFiled.text ?? "")
        }
    }
    
    func search(_ text: String) {
        if text.count == 0 {
            alert("Please enter your search content.")
            return
        }
        searchButton.isSelected = true
        BrowserUtil.shared.load(text, from: self)
    }
    
    @IBAction func tabAction() {
        let vc = TabPage()
        vc.modalPresentationStyle = .fullScreen
        present(vc, animated: true)
    }
    
    @IBAction func settingAction() {
        let view = SettingView.loadView()
        view.frame = UIScreen.main.bounds
        self.view.addSubview(view)
    }
    
    @IBAction func cleanAction() {
        let view = CleanAlertView.loadView()
        view.frame = UIScreen.main.bounds
        view.confirmHandler = {
            let vc = CleanPage()
            vc.modalPresentationStyle = .fullScreen
            self.present(vc, animated: true)
        }
        self.view.addSubview(view)
    }
    
    @IBAction func goBack() {
        BrowserUtil.shared.goBack()
    }
    
    @IBAction func goForward() {
        BrowserUtil.shared.goForword()
    }
}

extension HomePage {
    
    func adObersve() {
        NotificationCenter.default.addObserver(forName: Notification.Name(rawValue: "homeNativeUpdate"), object: nil, queue: .main) { [weak self] noti in
            guard let self = self else {return}
            if self.willAppear {
                if GADUtil.share.homeNativeAdImpressionDate.timeIntervalSinceNow < -10 {
                    GADUtil.share.homeNativeAdImpressionDate = Date()
                    if let ad = noti.object as? NativeADModel {
                        self.adView.nativeAd = ad.nativeAd
                    }
                    return
                }
                self.adView.nativeAd = .none
                NSLog("[ad] 10s home 原生广告刷新或数据填充间隔.")
            }
        }
    }
    
    override func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?) {
        refreshStatus()
    }
    
    func refreshStatus() {
        progressView.progress = BrowserUtil.shared.progress()
        progressView.isHidden = !BrowserUtil.shared.isLoading()
        view.bringSubviewToFront(progressView)
        textFiled.text = BrowserUtil.shared.url()
        searchButton.isSelected = BrowserUtil.shared.isLoading()
        backButton.isEnabled = BrowserUtil.shared.canGoBack()
        forwardButton.isEnabled = BrowserUtil.shared.canGoForword()
        tabButton.setTitle("\(BrowserUtil.shared.items.count)", for: .normal)
    }
    
    func addObserver() {
        if !BrowserUtil.shared.isNavigation(), BrowserUtil.shared.url().count != 0 {
            BrowserUtil.shared.item.webView.removeFromSuperview()
            view.addSubview(BrowserUtil.shared.item.webView)
            BrowserUtil.shared.item.webView.navigationDelegate = self
            BrowserUtil.shared.item.webView.uiDelegate = self
        }
        BrowserUtil.shared.item.webView.navigationDelegate = self
        BrowserUtil.shared.item.webView.uiDelegate = self
    }
    
}

extension HomePage: UICollectionViewDelegate, UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return HomeItem.allCases.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "HomeCell", for: indexPath)
        if let cell = cell as? HomeCell {
            let item = HomeItem.allCases[indexPath.row]
            cell.icon.image = item.icon
            cell.title.text = item.title
        }
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let item = HomeItem.allCases[indexPath.row]
        textFiled.text = item.url
        search(item.url)
    }
}

extension HomePage: UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let width  = view.window?.bounds.width ?? 375.0
        let w = width / 4.0 - 4.0
        return CGSize(width: w, height: w)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 0.0
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 0.0
    }
}

extension HomePage: WKUIDelegate, WKNavigationDelegate, UITextFieldDelegate {
    /// 跳转链接前是否允许请求url
    func webView(_ webView: WKWebView, decidePolicyFor navigationAction: WKNavigationAction) async -> WKNavigationActionPolicy {
        backButton.isEnabled = webView.canGoBack
        forwardButton.isEnabled = webView.canGoForward
        return .allow
    }
    
    /// 响应后是否跳转
    func webView(_ webView: WKWebView, decidePolicyFor navigationResponse: WKNavigationResponse) async -> WKNavigationResponsePolicy {
        backButton.isEnabled = webView.canGoBack
        forwardButton.isEnabled = webView.canGoForward
        return .allow
    }
    
    func webView(_ webView: WKWebView, createWebViewWith configuration: WKWebViewConfiguration, for navigationAction: WKNavigationAction, windowFeatures: WKWindowFeatures) -> WKWebView? {
        /// 打开新的窗口
        backButton.isEnabled = webView.canGoBack
        forwardButton.isEnabled = webView.canGoForward
        webView.load(navigationAction.request)
        return nil
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        view.endEditing(true)
        return true
    }
}


enum HomeItem: String, CaseIterable {
    case facebook, google, youtube, twitter, instagram, amazon, tiktok, yahoo
    var title: String {
        self.rawValue.capitalized
    }
    var icon: UIImage {
        UIImage(named: self.rawValue) ?? UIImage()
    }
    var url: String {
        "https://www.\(self.rawValue).com"
    }
}
