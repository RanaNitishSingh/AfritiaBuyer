//
//  UIColorExtension.swift
//  Afritia
//
//  Created by Ranjit Mahto on 09/10/20.
//  Copyright © 2020 kunal. All rights reserved.
//

import UIKit
import Foundation


extension UIColor {
    
    static let Accent = UIColor().HexToColor(hexString: "000000")
    static let button = UIColor().HexToColor(hexString: "232F3E")
    static let textHeading = UIColor().HexToColor(hexString: "232F3E")
    static let navigationTint = UIColor().HexToColor(hexString: "261f28")
    static let link = UIColor().HexToColor(hexString: "93BC4B")
    
    static let appRed = UIColor().HexToColor(hexString: "FF2600")
    static let appOrange = UIColor().HexToColor(hexString: "FF9300")
    static let appGreen = UIColor().HexToColor(hexString: "008F00")
    
    static let appExtraLightGray = UIColor().HexToColor(hexString: "ECEFF1")
    static let appLightGrey = UIColor().HexToColor(hexString: "8E8E93")
    static let appSuperLightGrey = UIColor().HexToColor(hexString: "EEEEEE")

   
    static let appStarColor = UIColor().HexToColor(hexString: "232F3E")
    static let appGradient = [Accent , Accent]
    static let appStarGradient = [link , UIColor().HexToColor(hexString: "9ED836")]
    
    static let DimLavendar = UIColor().HexToColor(hexString:"DCCFF9")
    static let DarkLavendar = UIColor().HexToColor(hexString:"7F1881")
    static let LightLavendar = UIColor().HexToColor(hexString:"CDBAF1")
    static let NavBarTintColor = UIColor().HexToColor(hexString:"CDBAF1")
    static let TabBarHighLightColor = UIColor().HexToColor(hexString:"E427E7")
    
    //monochrome
    static let PureBlack = UIColor(hexValue: 0x000000)
    static let Lead = UIColor(hexValue: 0x212121) // dark black //Lead
    static let Tungsten = UIColor(hexValue: 0x424242) //dark text //Tungsten
    static let Iron = UIColor(hexValue: 0x5E5E5E) // dark gray //Iron
    static let Steel = UIColor(hexValue: 0x797979)  // dark gray //Steel
    static let Tin = UIColor(hexValue: 0x919191) //light gray Tin
    static let Alumunium = UIColor(hexValue: 0xA9A9A9) // Mid gray //Alumunium
    static let Magnesium = UIColor(hexValue: 0xC0C0C0) // tag gray //Magnesium
    static let silver = UIColor(hexValue: 0xD6D6D6) //Line gray // silver
    static let Mercury = UIColor(hexValue: 0xEBEBEB) //extra light gray //Mercury
    static let PureWhite = UIColor(hexValue: 0xFFFFFF)
    
    
    func HexToColor(hexString: String, alpha:CGFloat? = 1.0) -> UIColor {
        // Convert hex string to an integer
        let hexint = Int(self.intFromHexString(hexStr: hexString))
        let red = CGFloat((hexint & 0xff0000) >> 16) / 255.0
        let green = CGFloat((hexint & 0xff00) >> 8) / 255.0
        let blue = CGFloat((hexint & 0xff) >> 0) / 255.0
        let alpha = alpha!
        // Create color object, specifying alpha as well
        let color = UIColor(red: red, green: green, blue: blue, alpha: alpha)
        return color
    }
    
    func intFromHexString(hexStr: String) -> UInt32 {
        var hexInt: UInt32 = 0
        // Create scanner
        let scanner: Scanner = Scanner(string: hexStr)
        // Tell scanner to skip the # character
        scanner.charactersToBeSkipped = NSCharacterSet(charactersIn: "#") as CharacterSet
        // Scan hex value
        scanner.scanHexInt32(&hexInt)
        return hexInt
    }
    
    /* HEX COLOR USE EXAMPLE
     let color1 = UIColor(red: 0xFF, green: 0xFF, blue: 0xFF)
     let color2 = UIColor(red: 100, green: 150, blue: 200)
     let color3 = UIColor(hexValue: 0xFFFFFF)
     
     // get color with alpha
     let semitransparentBlack = UIColor(hexValue: 0x000000).withAlphaComponent(0.5)
     */
    
   static func getWithHexString (hex:String) -> UIColor {
        
        var cString:String = hex.trimmingCharacters(in: .whitespacesAndNewlines).uppercased()
        
        if (cString.hasPrefix("#")) {
            cString.remove(at: cString.startIndex)
        }
        
        if ((cString.length) != 6) {
            return UIColor.gray
        }
        
        var rgbValue:UInt32 = 0
        Scanner(string: cString).scanHexInt32(&rgbValue)
        
        return UIColor(
            red: CGFloat((rgbValue & 0xFF0000) >> 16) / 255.0,
            green: CGFloat((rgbValue & 0x00FF00) >> 8) / 255.0,
            blue: CGFloat(rgbValue & 0x0000FF) / 255.0,
            alpha: CGFloat(1.0)
        )
    }
    
    convenience init(red: Int, green: Int, blue: Int) {
        assert(red >= 0 && red <= 255, "Invalid red component")
        assert(green >= 0 && green <= 255, "Invalid green component")
        assert(blue >= 0 && blue <= 255, "Invalid blue component")
        
        self.init(red: CGFloat(red) / 255.0, green: CGFloat(green) / 255.0, blue: CGFloat(blue) / 255.0, alpha: 1.0)
    }
    
    convenience init(hexValue: Int) {
        self.init(
            red: (hexValue >> 16) & 0xFF,
            green: (hexValue >> 8) & 0xFF,
            blue: hexValue & 0xFF
        )
    }
    
}
