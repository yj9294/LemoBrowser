//
//  BrowserUtil.swift
//  Lemon
//
//  Created by yangjian on 2023/9/8.
//

import UIKit

import Foundation
import UIKit
import WebKit

class BrowserUtil: NSObject {
    static let shared = BrowserUtil()
    var items:[BrowserItem] = [.navgationItem]
    
    var item: BrowserItem {
        items.filter {
            $0.isSelect == true
        }.first ?? .navgationItem
    }
    
    func removeItem(_ item: BrowserItem) {
        removeWebView()
        if item.isSelect {
            items = items.filter {
                $0 != item
            }
            items.first?.isSelect = true
        } else {
            items = items.filter {
                $0 != item
            }
        }
    }
    
    func clean(from vc: UIViewController) {
        items.filter {
            !$0.isNavigation && $0.isSelect
        }.compactMap {
            $0.webView
        }.forEach {
            $0.removeFromSuperview()
        }
        items = [.navgationItem]
    }
    
    func add(_ item: BrowserItem = .navgationItem) {
        removeWebView()
        items.forEach {
            $0.isSelect = false
        }
        items.insert(item, at: 0)
    }
    
    func select(_ item: BrowserItem) {
        removeWebView()
        if !items.contains(item) {
            return
        }
        items.forEach {
            $0.isSelect = false
        }
        item.isSelect = true
    }
    
    func removeWebView() {
        items.compactMap {
            $0.webView
        }.forEach {
            $0.removeFromSuperview()
        }
    }
    
    func load(_ url: String, from vc: UIViewController) {
        item.loadUrl(url, from: vc)
    }
    
    func stopLoad() {
        item.stopLoad()
    }
    
    func canGoBack() -> Bool {
        item.webView.canGoBack
    }
    
    func canGoForword() -> Bool {
        item.webView.canGoForward
    }
    
    func isLoading() -> Bool {
        item.webView.estimatedProgress > 0.0 && item.webView.estimatedProgress < 1.0
    }
    
    func url() -> String {
        item.webView.url?.absoluteString ?? ""
    }
    
    func isNavigation() -> Bool {
        item.isNavigation
    }
    
    func progress() -> Float {
        Float(item.webView.estimatedProgress)
    }
    
    func goBack() {
        BrowserUtil.shared.item.webView.goBack()
    }
    
    func goForword() {
        BrowserUtil.shared.item.webView.goForward()
    }
    
}

class BrowserItem: NSObject {
    
    init(webView: WKWebView, isSelect: Bool) {
        self.webView = webView
        self.isSelect = isSelect
    }
    var webView: WKWebView
    
    var isNavigation: Bool {
        webView.url == nil
    }
    var isSelect: Bool
    
    func loadUrl(_ url: String, from vc: UIViewController) {
        // 移出 view
        BrowserUtil.shared.items.filter({
            !$0.isNavigation
        }).compactMap({
            $0.webView
        }).forEach {
            $0.removeFromSuperview()
        }
        // 添加 view
        vc.view.addSubview(webView)
        if url.isUrl(), let Url = URL(string: url) {
            let request = URLRequest(url: Url)
            webView.load(request)
            if webView.observationInfo != nil {
                webView.removeObserver(vc, forKeyPath: #keyPath(WKWebView.estimatedProgress))
                webView.removeObserver(vc, forKeyPath: #keyPath(WKWebView.url))
            }
            webView.addObserver(vc, forKeyPath: #keyPath(WKWebView.estimatedProgress), context: nil)
            webView.addObserver(vc, forKeyPath: #keyPath(WKWebView.url), context: nil)
        } else {
            let urlString = url.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) ?? ""
            let reqString = "https://www.google.com/search?q=" + urlString
            self.loadUrl(reqString, from: vc)
        }
    }
    
    func stopLoad() {
        webView.stopLoading()
    }
    
    static var navgationItem: BrowserItem {
        let webView = WKWebView()
        webView.backgroundColor = .white
        webView.isOpaque = false
        webView.clipsToBounds = true
        return BrowserItem(webView: webView, isSelect: true)
    }
}

extension String {
    func isUrl() -> Bool {
        let url = "[a-zA-z]+://.*"
        let predicate = NSPredicate(format: "SELF MATCHES %@", url)
        return predicate.evaluate(with: self)
    }
}
