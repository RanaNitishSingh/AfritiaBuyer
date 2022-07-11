//
//  ThemeManager.swift
//  Getkart
//
//  Created by Webkul on 22/06/18.
//  Copyright © 2018 Webkul. All rights reserved.
//

import Foundation
import UIKit

class ThemeManager{
    
  
    static func applyAfritiaTheme()
    {
        
        // theme navigation bar
        UINavigationBar.appearance().isOpaque = true
        UINavigationBar.appearance().isTranslucent = false
        //self.navigationController?.interactivePopGestureRecognizer?.isEnabled = false
        UINavigationBar.appearance().tintColor = UIColor.white
        UINavigationBar.appearance().barTintColor = UIColor.LightLavendar
        UINavigationBar.appearance().titleTextAttributes = [NSAttributedStringKey(rawValue: NSAttributedStringKey.foregroundColor.rawValue): UIColor.white]
        
        //var frameAndStatusBar: CGRect = UINavigationBar.appearance().bounds
        //frameAndStatusBar.size.height += 20
        // UINavigationBar.appearance().setBackgroundImage(UINavigationBar.gradient(size: frameAndStatusBar.size, colors:UIColor.appGreen), for: .default)
        
        //theme TabBar
        UITabBar.appearance().barStyle = .default
        UITabBar.appearance().tintColor = UIColor.white
        UITabBar.appearance().barTintColor = UIColor.purple
        UITabBar.appearance().unselectedItemTintColor = UIColor.LightLavendar
        
        
        //theme Switch
        UISwitch.appearance().onTintColor = UIColor.appGreen.withAlphaComponent(0.3)
        UISwitch.appearance().thumbTintColor = UIColor.appGreen
        UITabBar.appearance().tintColor = UIColor.appGreen
        
        
        //themeButton
        UIButton.appearance().backgroundColor = UIColor.DarkLavendar
        UIButton.appearance().setTitleColor(UIColor.white, for:.normal)
        UIButton.appearance().layer.borderColor =  UIColor.clear.cgColor
        UIButton.appearance().layer.cornerRadius = UIButton.appearance().frame.size.height/2
        UIButton.appearance().layer.borderWidth = 0
        
        //theme SearchBar
        UISearchBar.appearance().backgroundColor = UIColor.LightLavendar
        
        
        guard let tf = UISearchBar.appearance().value(forKey: "searchField") as? UITextField else { return }
        tf.textColor = UIColor.black
        tf.backgroundColor = UIColor.white
        tf.layer.borderColor = UIColor.Tin.cgColor
        tf.layer.borderWidth = 1.5
        tf.layer.cornerRadius = 5
        
        if let glassIconView = tf.leftView as? UIImageView, let img = glassIconView.image {
            let newImg = img.blendedByColor(UIColor.DarkLavendar)
            glassIconView.image = newImg
        }
    }
}



var SHOW_COMPARE = false


//var GRADIENTCOLOR = [UIColor().HexToColor(hexString: "05C149") , UIColor().HexToColor(hexString: "05C149")]
var STARGRADIENT = [UIColor().HexToColor(hexString: "93BC4B") , UIColor().HexToColor(hexString: "9ED836")]

//public var BOLDFONT = "PingFangSC-Semibold";
//public var REGULARFONT = "PingFangHK-Light";


public var BOLDFONT = "Cairo-Bold"
public var REGULARFONT = "Cairo-Regular"
public var ITALICFONT = "Cairo-Italic"


struct AppColor {
    
    
    
}
