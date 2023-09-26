//
//  ProfileManager.swift
//  Lemon
//
//  Created by yangjian on 2023/9/23.
//

import UIKit
import MLKitTranslate

class ProfileUtil: NSObject {
    static let share = ProfileUtil()
    var textSourceLanguage: Language {
        set{
            UserDefaults.standard.setObject(newValue, forKey: .textSourceKey)
        }
        get{
            UserDefaults.standard.getObject(Language.self, forKey: .textSourceKey) ?? .Auto
        }
    }
    var textTargetLanguage: Language {
        set{
            UserDefaults.standard.setObject(newValue, forKey: .textTargetKey)
        }
        get{
            UserDefaults.standard.getObject(Language.self, forKey: .textTargetKey) ?? .English
        }
    }
    
    var targetDatasource: [Language] {
        return datasource
    }
    
    var sourceDatasource: [Language] {
        return [[.Auto], datasource].flatMap({ array in
            return array
        })
    }
    
    var translateText: String {
        set {
            UserDefaults.standard.setObject(newValue, forKey: .translateText)
        }
        get {
            UserDefaults.standard.getObject(String.self, forKey: .translateText) ?? ""
        }
    }
    
    var datasource: [Language] {
        if let source = UserDefaults.standard.getObject([Language].self, forKey: .targetSource) {
            return source
        } else {
            let array: [Language] = TranslateLanguage.allLanguages().compactMap {
                let country = Locale.current.localizedString(forRegionCode: $0.rawValue) ?? ""
                let code = $0.rawValue
                let language = Locale.current.localizedString(forLanguageCode: $0.rawValue) ?? ""
                return Language(code: code, country: country, language: language)
            }.sorted { l1, l2 in
                l1.language < l2.language
            }
            UserDefaults.standard.setObject(array, forKey: .targetSource)
            return array
        }
    }
}

extension String {
    static let textSourceKey = "textSourceKey"
    static let textTargetKey = "textTargetKey"
    static let targetSource = "targetSource"
    static let translateText = "translateText"
    static let adConfig = "adConfig"
    static let adLimited = "adLimited"
}
