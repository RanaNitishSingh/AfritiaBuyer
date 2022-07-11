//
//  AppExtensions.swift
//  MusicLinkUp
//
//  Created by Karan B on 26/06/18.
//  Copyright © 2018 Karan B. All rights reserved.
//

import Foundation
import UIKit



extension Double {
    
    var dispatchTime: DispatchTime {
        get {
            return DispatchTime.now() + Double(Int64(self * Double(NSEC_PER_SEC))) / Double(NSEC_PER_SEC)
        }
    }
    
}

extension Float{
    
    func getTwoDecimal() -> String{
        return String(format: "%.2f",self)
    }
    
    func getTwoDecimalWithCurrency() -> String{
        return String(format: "$ %.2f",self)
    }
}




extension CALayer {
    
    func addBorder(_ edge: UIRectEdge, color: UIColor, thickness: CGFloat) {
        let border = CALayer()
        switch edge {
        case UIRectEdge.top:
            border.frame = CGRect(x: 0, y: 0, width: self.frame.height, height: thickness)
            break
        case UIRectEdge.bottom:
            border.frame = CGRect(x: 0, y: self.frame.height - thickness, width: UIScreen.main.bounds.width, height: thickness)
            break
        case UIRectEdge.left:
            border.frame = CGRect(x: 0, y: 0, width: thickness, height: self.frame.height)
            break
        case UIRectEdge.right:
            border.frame = CGRect(x: self.frame.width - thickness, y: 0, width: thickness, height: self.frame.height)
            break
        default:
            break
        }
        border.backgroundColor = color.cgColor
        
        self.addSublayer(border)
    }
    
    
    func addBorderWithShadow(imageView:UIImageView) {
        
        if let myimage = imageView.image {
            self.contents = myimage.cgImage
            
            self.contentsGravity = kCAGravityCenter
            
            self.magnificationFilter = kCAFilterLinear
            self.isGeometryFlipped = false
            
            self.backgroundColor = UIColor(red: 11/255.0, green: 86/255.0, blue: 14/255.0, alpha: 1.0).cgColor
            self.opacity = 1.0
            self.isHidden = false
            self.masksToBounds = false
            
            self.cornerRadius = 100.0
            self.borderWidth = 12.0
            self.borderColor = UIColor.white.cgColor
            
            self.shadowOpacity = 0.75
            self.shadowOffset = CGSize(width: 0, height: 3)
            self.shadowRadius = 3.0
            
            imageView.layer.addSublayer(self)
        }

    }
}




extension CAGradientLayer {
    
    convenience init(frame: CGRect, colors: [UIColor]) {
        self.init()
        self.frame = frame
        self.colors = []
        for color in colors {
            self.colors?.append(color.cgColor)
        }
        startPoint = CGPoint(x: 0, y: 0)
        endPoint = CGPoint(x: 1, y: 0)
    }
    
    func creatGradientImage() -> UIImage? {
        
        var image: UIImage? = nil
        UIGraphicsBeginImageContext(bounds.size)
        if let context = UIGraphicsGetCurrentContext() {
            render(in: context)
            image = UIGraphicsGetImageFromCurrentImageContext()
        }
        UIGraphicsEndImageContext()
        return image
    }
}


extension Date {
    
    var timeTicks: UInt64 {
        return UInt64((self.timeIntervalSince1970 + 62_135_596_800) * 10_000_000)
    }
}


extension UIPageViewController {
    var isPagingEnabled: Bool {
        get {
            var isEnabled: Bool = true
            for view in view.subviews {
                if let subView = view as? UIScrollView {
                    isEnabled = subView.isScrollEnabled
                }
            }
            return isEnabled
        }
        set {
            for view in view.subviews {
                if let subView = view as? UIScrollView {
                    subView.isScrollEnabled = newValue
                }
            }
        }
    }
}

