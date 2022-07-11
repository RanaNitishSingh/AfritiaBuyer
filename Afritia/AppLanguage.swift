//
//  AppLanguage.swift
//  Getkart
//
//  Created by Ranjit Mahto on 09/10/20.
//  Copyright © 2020 kunal. All rights reserved.
//

import Foundation
import UIKit

class appLanguage {
    
    static func localize(key:String) -> String {
        
        var languageBundle:Bundle!
        
        let languageCode = UserDefaults.standard
        if languageCode.object(forKey: "language") != nil {
            let language = languageCode.object(forKey: "language")
            if let path = Bundle.main.path(forResource: language as! String?, ofType: "lproj") {
                languageBundle = Bundle(path: path)
            }
            else{
                languageBundle = Bundle(path: Bundle.main.path(forResource: "en", ofType: "lproj")!)
            }
        }else {
            languageCode.set("en", forKey: "language")
            languageCode.synchronize()
            let language = languageCode.string(forKey: "language")!
            var path = Bundle.main.path(forResource: language, ofType: "lproj")!
            if path .isEmpty {
                path = Bundle.main.path(forResource: "en", ofType: "lproj")!
            }
            languageBundle = Bundle(path: path)
        }
        
        return languageBundle.localizedString(forKey: key, value: "", table: nil)
    }
}


extension String {
    var localized: String {
        return appLanguage.localize(key: self)
    }
}


