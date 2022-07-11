//
//  CustomButton.swift
//  Scrapbook
//
//  Created by Ranjit Mahto on 04/12/17.
//  Copyright © 2017 Ranjit Mahto. All rights reserved.
//

import UIKit

@IBDesignable
class CustomButton: UIButton {

    @IBInspectable var cornerRadius : CGFloat = 0 {
        didSet {
            layer.cornerRadius = cornerRadius
        }
    }
    
    @IBInspectable var borderColor : UIColor = .black {
        didSet {
            layer.borderColor = borderColor.cgColor
        }
    }
    
    @IBInspectable var borderWidth : CGFloat = 0 {
        didSet {
            layer.borderWidth = borderWidth
        }
    }
    
    @IBInspectable var showShadow : Bool = false {
        
        didSet {
            if showShadow {
                layer.shadowColor = UIColor.darkGray.cgColor
                layer.shadowOffset = CGSize(width: 1, height: 1)
                layer.shadowRadius = 5
                layer.shadowOpacity = 0.6
            }
        }
    }
    
    @IBInspectable var applyGradient : Bool = false {
        
        didSet {
            if applyGradient {
                
                let gradientLayer = CAGradientLayer()
                gradientLayer.frame = self.bounds
                let startColor = UIColor().HexToColor(hexString:"FFAD33")
                let endColor =  UIColor().HexToColor(hexString:"FF9900")
                gradientLayer.colors = [startColor.cgColor, endColor.cgColor]
                layer.insertSublayer(gradientLayer, at: 0)
                layer.masksToBounds = true
                
               // let grdientColors = [UIColor.white.cgColor, UIColor.darkGray.cgColor]
               // self.applyGradient(colors:grdientColors)
            }
        }
    }
}

