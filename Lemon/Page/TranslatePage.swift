//
//  TranslatePage.swift
//  Lemon
//
//  Created by yangjian on 2023/9/23.
//

import UIKit
import IQKeyboardManagerSwift

class TranslatePage: UIViewController {
    
    @IBOutlet weak var textView: IQTextView!
    @IBOutlet weak var sourceButton: UIButton!
    @IBOutlet weak var targetButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.sourceButton.setTitle(ProfileUtil.share.textSourceLanguage.language, for: .normal)
        self.targetButton.setTitle(ProfileUtil.share.textTargetLanguage.language, for: .normal)
    }

}

extension TranslatePage {
    
    @IBAction func back() {
        self.dismiss(animated: true)
    }
    
    @IBAction func source(_ sender: Any) {
        self.view.endEditing(true)
        self.navigationItem.backButtonTitle = "Language"
        let vc = LanguageListPage(ProfileUtil.share.textSourceLanguage, dataSource: ProfileUtil.share.sourceDatasource)
        vc.modalPresentationStyle = .fullScreen
        present(vc, animated: true)
        vc.didSelectHandle = { language in
            ProfileUtil.share.textSourceLanguage = language
        }
    }
    
    @IBAction func target(_ sender: Any) {
        self.view.endEditing(true)
        self.navigationItem.backButtonTitle = "Language"
        let vc = LanguageListPage(ProfileUtil.share.textTargetLanguage, dataSource: ProfileUtil.share.targetDatasource)
        vc.modalPresentationStyle = .fullScreen
        present(vc, animated: true)
        vc.didSelectHandle = { language in
            ProfileUtil.share.textTargetLanguage = language
        }
    }
   
    @IBAction func exchange(_ sender: Any) {
        if ProfileUtil.share.textSourceLanguage == .Auto {
            return
        }
        let language = ProfileUtil.share.textSourceLanguage
        ProfileUtil.share.textSourceLanguage = ProfileUtil.share.textTargetLanguage
        ProfileUtil.share.textTargetLanguage = language
        self.sourceButton.setTitle(ProfileUtil.share.textSourceLanguage.language, for: .normal)
        self.targetButton.setTitle(ProfileUtil.share.textTargetLanguage.language, for: .normal)
    }
    
    @IBAction func translateActino() {
        if !NetworkUtil.shared.isConnected {
            /// 没网络
            alert("No network.")
            return
        }
        
        LoadingView.present()
        let source = ProfileUtil.share.textSourceLanguage
        let target = ProfileUtil.share.textTargetLanguage
        self.view.endEditing(true)
        TranslateUtil.shared.translate(text: textView.text, source: source, target: target) { [weak self] isSuccess, result in
            LoadingView.dismiss()
            guard let self = self else { return }
            if AppEnterbackground {
                return
            }
            if !isSuccess {
                if result == "No network." {
                    alert(result)
                    return
                }
                let vc = TranslateFailPage()
                vc.modalPresentationStyle = .fullScreen
                self.present(vc, animated: true)
                vc.confirm = {
                    self.translateActino()
                }
                return
            }
            let vc = TranslateResult(source: self.textView.text, target: result)
            vc.modalPresentationStyle = .fullScreen
            self.present(vc, animated: true)
            self.textView.text = ""
            ProfileUtil.share.translateText = ""
        }
    }
    
}
