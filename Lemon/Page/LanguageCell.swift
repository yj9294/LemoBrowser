//
//  LanguageCell.swift
//  Lemon
//
//  Created by yangjian on 2023/9/26.
//

import UIKit

class LanguageCell: UITableViewCell {
    
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var button: UIButton!

    override func awakeFromNib() {
        super.awakeFromNib()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        button.isSelected = selected
    }
    
    
    var item: Language?  {
        didSet {
            titleLabel.text = item?.language ?? "Auto Detect"
        }
    }
    
}
