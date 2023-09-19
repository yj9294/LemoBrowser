//
//  TabPage.swift
//  Lemon
//
//  Created by yangjian on 2023/9/8.
//

import UIKit
import GADUtil

class TabPage: UIViewController {
    
    @IBOutlet weak var collectionView: UICollectionView!
    
    @IBOutlet weak var adView: GADNativeView!
    var willAppear: Bool = false

    override func viewDidLoad() {
        super.viewDidLoad()
        collectionView.register(UINib(nibName: "TabCell", bundle: .main), forCellWithReuseIdentifier: "TabCell")
        collectionView.contentInset = UIEdgeInsets(top: 20, left: 12, bottom: 12, right: 12)
        adObersve()
    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        willAppear = false
        GADUtil.share.disappear(.native)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        willAppear = true
        GADUtil.share.load(.native)
    }
}

extension TabPage {
    
    func adObersve() {
        NotificationCenter.default.addObserver(forName: Notification.Name(rawValue: "homeNativeUpdate"), object: nil, queue: .main) { [weak self] noti in
            guard let self = self else {return}
            if self.willAppear {
                if GADUtil.share.tabNativeAdImpressionDate.timeIntervalSinceNow < -10 {
                    GADUtil.share.tabNativeAdImpressionDate = Date()
                    if let ad = noti.object as? NativeADModel {
                        self.adView.nativeAd = ad.nativeAd
                    }
                    return
                }
                self.adView.nativeAd = .none
                NSLog("[ad] 10s tab 原生广告刷新或数据填充间隔.")
            }
        }
    }
    
    
    @IBAction func addItem() {
        BrowserUtil.shared.add()
        dismiss(animated: true)
    }
    
    @IBAction func back() {
        dismiss(animated: true)
    }
    
    func removeItem(_ item: BrowserItem) {
        BrowserUtil.shared.removeItem(item)
        collectionView.reloadData()
    }
    
    func selectedItem(_ item: BrowserItem) {
        BrowserUtil.shared.select(item)
        dismiss(animated: true)
    }
}

extension TabPage: UICollectionViewDelegate, UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        BrowserUtil.shared.items.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "TabCell", for: indexPath)
        if let cell = cell as? TabCell {
            let item = BrowserUtil.shared.items[indexPath.row]
            cell.item = item
            cell.closeHandler = { [weak self] in
                self?.removeItem(item)
            }
        }
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let item = BrowserUtil.shared.items[indexPath.row]
        selectedItem(item)
    }
}

extension TabPage: UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        12.0
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        12.0
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let width = view.window?.bounds.width ?? 375.0
        let w = (width - 12 * 3) / 2.0 - 2
        return CGSize(width: w, height: 200 / 150 * w)
    }
}
