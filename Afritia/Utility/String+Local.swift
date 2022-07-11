//
//  String+Local.swift
//

import Foundation
import UIKit
/*
extension String {
    
    var localized: String {
        
        var strLang : String? = UserDefaults.standard.string(forKey: "APPLICATION_LANGUAGE")
        
        if strLang == nil {
            strLang = "en"
        }
        
        let localiedBundlePath : Bundle = Bundle(url: (MAIN_BUNDLE.url(forResource: "Localizable", withExtension: "bundle"))!)!
        var path : String? = localiedBundlePath.path(forResource: strLang, ofType: "lproj")
        
        if path == nil {
            path = localiedBundlePath.path(forResource: "en", ofType: "lproj")
        }
        
        let langBundle = Bundle(path: path!)
        let str = langBundle?.localizedString(forKey: self, value: "", table: nil)
        return str!
        
    }
    
}

extension Bundle {
    
    var localizedBundle: Bundle {
        return Bundle(url: (MAIN_BUNDLE.url(forResource: "Localized", withExtension: "bundle"))!)!
    }
    
}
*/
