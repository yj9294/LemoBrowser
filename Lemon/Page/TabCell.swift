//
//  TabCell.swift
//  Lemon
//
//  Created by yangjian on 2023/9/8.
//

import UIKit

class TabCell: UICollectionViewCell {
    
    @IBOutlet weak var closeButton: UIButton!
    @IBOutlet weak var tilte: UILabel!
    var closeHandler: (()->Void)? = nil

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    var item: BrowserItem = .navgationItem {
        didSet {
            backgroundColor = item.isSelect ? UIColor(named: "#9AFFAF") : UIColor(named: "#FFE71E")
            closeButton.isHidden = BrowserUtil.shared.items.count == 1
            tilte.text = item.webView.url?.absoluteString ?? "Navigation"
        }
    }

    @IBAction func clseAction() {
        closeHandler?()
    }
}
