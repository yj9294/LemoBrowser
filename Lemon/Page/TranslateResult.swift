//
//  TranslateResult.swift
//  Lemon
//
//  Created by yangjian on 2023/9/25.
//

import UIKit

class TranslateResult: UIViewController {
    
    @IBOutlet weak var sourceLab: UILabel!
    @IBOutlet weak var targetLab: UILabel!
    @IBOutlet weak var sourceResultLab: UILabel!
    @IBOutlet weak var targetResultLab: UILabel!
    var source: String
    var target: String
    
    init(source: String, target: String) {
        self.source = source
        self.target = target
        super.init(nibName: "TranslateResult", bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        sourceLab.text = ProfileUtil.share.textSourceLanguage.language
        targetLab.text = ProfileUtil.share.textTargetLanguage.language
        sourceResultLab.text = source
        targetResultLab.text = target
    }
    
    @IBAction func back() {
        dismiss(animated: true)
    }

}
