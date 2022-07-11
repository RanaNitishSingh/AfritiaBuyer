//
//  UIButtonExtension.swift
//  MusicLinkUp
//
//  Created by Ranjit Mahto on 30/10/18.
//  Copyright © 2018 Karan B. All rights reserved.
//

import UIKit

// Declare a global var to produce a unique address as the assoc object handle
var disabledColorHandle: UInt8 = 0
var highlightedColorHandle: UInt8 = 0
var selectedColorHandle: UInt8 = 0


typealias UIButtonTargetClosure = (UIButton) -> ()

class ClosureWrapper: NSObject {
    let closure: UIButtonTargetClosure
    init(_ closure: @escaping UIButtonTargetClosure) {
        self.closure = closure
    }
}

extension UIButton {

    private struct AssociatedKeys
    {
        static var targetClosure = "targetClosure"
    }
    
    private var targetClosure: UIButtonTargetClosure? {
        get {
            guard let closureWrapper = objc_getAssociatedObject(self, &AssociatedKeys.targetClosure) as? ClosureWrapper else { return nil }
            return closureWrapper.closure
        }
        set(newValue) {
            guard let newValue = newValue else { return }
            objc_setAssociatedObject(self, &AssociatedKeys.targetClosure, ClosureWrapper(newValue), objc_AssociationPolicy.OBJC_ASSOCIATION_RETAIN_NONATOMIC)
        }
    }
    
    func addTargetClosure(closure: @escaping UIButtonTargetClosure) {
        targetClosure = closure
        addTarget(self, action: #selector(UIButton.closureAction), for: .touchUpInside)
    }
    
    @objc func closureAction() {
        guard let targetClosure = targetClosure else { return }
        targetClosure(self)
    }
    
    // how to use
    /*
     loginButton.addTargetClosure { _ in
     
     // login logics
     
     }
     */
    
    func applyGradient(colors: [CGColor])
    {
        let gradientLayer = CAGradientLayer()
        gradientLayer.frame = self.bounds
        let startColor = UIColor().HexToColor(hexString:"FFAD33")
        let endColor =  UIColor().HexToColor(hexString:"FF9900")
        gradientLayer.colors = [startColor.cgColor, endColor.cgColor]
        layer.insertSublayer(gradientLayer, at: 0)
        layer.masksToBounds = true
    }
    
    
    func customizeWithBorderAndRoundCorner(bgColor:UIColor, borderColor:UIColor, cornerRadius:CGFloat){
        layer.backgroundColor = bgColor.cgColor
        layer.borderColor =  borderColor.cgColor
        layer.cornerRadius = cornerRadius
        layer.borderWidth = 1
    }
    
    func applyBorderWithHalfRoundCorner(){
        layer.backgroundColor = UIColor.clear.cgColor
        layer.borderColor =  UIColor.darkGray.cgColor
        layer.cornerRadius = self.frame.size.height/2
        layer.borderWidth = 1
    }
    
    func applyBorderWithHalfRoundCornerAndBgColor(bgColor:UIColor){
        layer.backgroundColor = bgColor.cgColor
        layer.borderColor =  UIColor.clear.cgColor
        layer.cornerRadius = self.frame.size.height/2
        layer.borderWidth = 0
        
        layer.shadowOpacity = 0.4
        layer.shadowColor = UIColor.darkGray.cgColor
        layer.shadowOffset = CGSize(width: 0, height:1)
    }
    
    func customizeWithShadowAndRoundCorner(bgColor:UIColor, borderColor:UIColor, cornerRadius:CGFloat){
        layer.backgroundColor = bgColor.cgColor
        layer.borderColor =  borderColor.cgColor
        layer.cornerRadius = cornerRadius
        layer.borderWidth = 2
        layer.shadowOpacity = 0.4
        layer.shadowColor = UIColor.darkGray.cgColor
        layer.shadowOffset = CGSize(width: 0, height:1)
    }
    
    func applyAfritiaTheme(){
        
        self.setBackgroundColor(UIColor.DarkLavendar, for: .normal)
        self.setBackgroundColor(UIColor.LightLavendar, for: .highlighted)
        
        self.setTitleColor(UIColor.white, for:.normal)
        self.setTitleColor(UIColor.DarkLavendar, for: .highlighted)
        
        self.layer.borderColor =  UIColor.clear.cgColor
        self.layer.cornerRadius = self.frame.size.height/2
        self.layer.borderWidth = 0
        self.clipsToBounds = true
    }
    
    func applyAfritiaBorederTheme(cornerRadius:CGFloat) {
        
        self.backgroundColor = UIColor.white
        self.layer.cornerRadius = cornerRadius
        self.layer.borderColor = UIColor.LightLavendar.cgColor
        self.layer.borderWidth = 1
    }
    
    /*
    func setCornerRadius(radius: CGFloat)  {
        self.layer.cornerRadius = radius
        self.clipsToBounds = true
    }*/
    
    
    private func image(withColor color: UIColor) -> UIImage? {
            let rect = CGRect(x: 0.0, y: 0.0, width: 1.0, height: 1.0)
            UIGraphicsBeginImageContext(rect.size)
            let context = UIGraphicsGetCurrentContext()

            context?.setFillColor(color.cgColor)
            context?.fill(rect)

            let image = UIGraphicsGetImageFromCurrentImageContext()
            UIGraphicsEndImageContext()

            return image
        }

        func setBackgroundColor(_ color: UIColor, for state: UIControlState) {
            self.setBackgroundImage(image(withColor: color), for: state)
        }
    
    
    @IBInspectable
        var disabledColor: UIColor? {
            get {
                if let color = objc_getAssociatedObject(self, &disabledColorHandle) as? UIColor {
                    return color
                }
                return nil
            }
            set {
                if let color = newValue {
                    self.setBackgroundColor(color, for: .disabled)
                    objc_setAssociatedObject(self, &disabledColorHandle, color, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
                } else {
                    self.setBackgroundImage(nil, for: .disabled)
                    objc_setAssociatedObject(self, &disabledColorHandle, nil, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
                }
            }
        }

    @IBInspectable
        var highlightedColor: UIColor? {
            get {
                if let color = objc_getAssociatedObject(self, &highlightedColorHandle) as? UIColor {
                    return color
                }
                return nil
            }
            set {
                if let color = newValue {
                    self.setBackgroundColor(color, for: .highlighted)
                    objc_setAssociatedObject(self, &highlightedColorHandle, color, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
                } else {
                    self.setBackgroundImage(nil, for: .highlighted)
                    objc_setAssociatedObject(self, &highlightedColorHandle, nil, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
                }
            }
        }
    
    @IBInspectable
        var selectedColor: UIColor? {
            get {
                if let color = objc_getAssociatedObject(self, &selectedColorHandle) as? UIColor {
                    return color
                }
                return nil
            }
            set {
                if let color = newValue {
                    self.setBackgroundColor(color, for: .selected)
                    objc_setAssociatedObject(self, &selectedColorHandle, color, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
                } else {
                    self.setBackgroundImage(nil, for: .selected)
                    objc_setAssociatedObject(self, &selectedColorHandle, nil, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
                }
            }
        }
    
    /*
     Add right arrow disclosure indicator to the button with normal and
     highlighted colors for the title text and the image
     */
    
    /*
    func disclosureButton(baseColor:UIColor, btnPos:CGFloat)
    {
        //self.setTitleColor(baseColor, for: .normal)
        //self.setTitleColor(baseColor.withAlphaComponent(0.3), for: .highlighted)
        //self.tintColor = baseColor
        
        let imgDropDown  =  AppImage.icon.dropDown?.resizeImageWith(newSize:CGSize(width:15, height: 20), isOpaque:true).tintedWithColor(color:baseColor)
        
        self.setImage(imgDropDown, for: .normal)
        
        self.sizeToFit()
        
        titleEdgeInsets = UIEdgeInsets(top: 0, left:0 , bottom: 0, right: 0)
        imageEdgeInsets = UIEdgeInsets(top: 0, left: SCREEN_WIDTH - btnPos , bottom: -2, right: 0)

//        guard let image = imgDropDown?.withRenderingMode(.alwaysTemplate) else
//        {
//            return
//        }
//        guard let imageHighlight = imgDropDown?.alpha(0.3)?.withRenderingMode(.alwaysTemplate) else
//        {
//            return
//        }
//
//        self.imageView?.contentMode = .scaleAspectFit
        
        //self.setImage(image, for: .normal)
        //self.setImage(imageHighlight, for: .highlighted)
        //self.imageEdgeInsets = UIEdgeInsetsMake(0, self.bounds.size.width-image.size.width*2, 0, 0);
        
        self.layer.cornerRadius = 4
        
        self.layer.borderWidth = 1
        self.layer.borderColor = AppColor.AppBlue.cgColor
        self.contentEdgeInsets = UIEdgeInsetsMake(10,0,10,0)
    }*/
    
}

@IBDesignable
class GradientButton: UIButton {
    let gradientLayer = CAGradientLayer()
    
    @IBInspectable
    var topGradientColor: UIColor? {
        didSet {
            setGradient(topGradientColor: topGradientColor, bottomGradientColor: bottomGradientColor)
        }
    }
    
    @IBInspectable
    var bottomGradientColor: UIColor? {
        didSet {
            setGradient(topGradientColor: topGradientColor, bottomGradientColor: bottomGradientColor)
        }
    }
    
    private func setGradient(topGradientColor: UIColor?, bottomGradientColor: UIColor?) {
        if let topGradientColor = topGradientColor, let bottomGradientColor = bottomGradientColor {
            gradientLayer.frame = bounds
            gradientLayer.colors = [topGradientColor.cgColor, bottomGradientColor.cgColor]
            gradientLayer.borderColor = layer.borderColor
            gradientLayer.borderWidth = layer.borderWidth
            gradientLayer.cornerRadius = layer.cornerRadius
            layer.insertSublayer(gradientLayer, at: 0)
        } else {
            gradientLayer.removeFromSuperlayer()
        }
    }
}
