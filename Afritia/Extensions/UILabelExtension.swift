//
//  UIlabelExtension.swift
//  MusicLinkUp
//
//  Created by Ranjit Mahto on 30/10/18.
//  Copyright © 2018 Karan B. All rights reserved.
//

import UIKit


@IBDesignable
class EdgeInsetLabel: UILabel {
    
    var textInsets = UIEdgeInsets.zero {
        didSet { invalidateIntrinsicContentSize() }
    }

    override func textRect(forBounds bounds: CGRect, limitedToNumberOfLines numberOfLines: Int) -> CGRect {
        let insetRect = UIEdgeInsetsInsetRect(bounds, textInsets)
        let textRect = super.textRect(forBounds: insetRect, limitedToNumberOfLines: numberOfLines)
        let invertedInsets = UIEdgeInsets(top: -textInsets.top,
                left: -textInsets.left,
                bottom: -textInsets.bottom,
                right: -textInsets.right)
        return UIEdgeInsetsInsetRect(textRect, invertedInsets)
    }

    override func drawText(in rect: CGRect) {
        super.drawText(in: UIEdgeInsetsInsetRect(rect, textInsets))
    }
}

extension EdgeInsetLabel {
    @IBInspectable
    var leftTextInset: CGFloat {
        set { textInsets.left = newValue }
        get { return textInsets.left }
    }

    @IBInspectable
    var rightTextInset: CGFloat {
        set { textInsets.right = newValue }
        get { return textInsets.right }
    }

    @IBInspectable
    var topTextInset: CGFloat {
        set { textInsets.top = newValue }
        get { return textInsets.top }
    }

    @IBInspectable
    var bottomTextInset: CGFloat {
        set { textInsets.bottom = newValue }
        get { return textInsets.bottom }
    }
}


extension UILabel{
    
//    @IBInspectable
//        var rotation: Int {
//            get {
//                return 0
//            } set {
//                let radians = CGFloat(CGFloat(Double.pi) * CGFloat(newValue) / CGFloat(180.0))
//                self.transform = CGAffineTransform(rotationAngle: radians)
//            }
//        }
//    
//    private struct AssociatedKeys {
//        static var padding = UIEdgeInsets()
//    }
//    
//    public var padding: UIEdgeInsets? {
//        get {
//            return objc_getAssociatedObject(self, &AssociatedKeys.padding) as? UIEdgeInsets
//        }
//        set {
//            if let newValue = newValue {
//                objc_setAssociatedObject(self, &AssociatedKeys.padding, newValue as UIEdgeInsets?, objc_AssociationPolicy.OBJC_ASSOCIATION_RETAIN_NONATOMIC)
//            }
//        }
//    }
//    
//    override open func draw(_ rect: CGRect) {
//        if let insets = padding {
//            self.drawText(in: UIEdgeInsetsInsetRect(rect, insets))
//        } else {
//            self.drawText(in: rect)
//        }
//    }
//
//    func setAttributedHtmlText(_ html: String) {
//        if let attributedText = html.attributedHtmlString {
//            self.attributedText = attributedText
//        }
//    }
//    
//    override open var intrinsicContentSize: CGSize {
//        guard let text = self.text else { return super.intrinsicContentSize }
//        
//        var contentSize = super.intrinsicContentSize
//        var textWidth: CGFloat = frame.size.width
//        var insetsHeight: CGFloat = 0.0
//        
//        if let insets = padding {
//            textWidth -= insets.left + insets.right
//            insetsHeight += insets.top + insets.bottom
//        }
//        
//        let newSize = text.boundingRect(with: CGSize(width: textWidth, height: CGFloat.greatestFiniteMagnitude),
//                                        options: NSStringDrawingOptions.usesLineFragmentOrigin,
//                                        attributes: [NSAttributedStringKey.font: self.font], context: nil)
//        
//        contentSize.height = ceil(newSize.size.height) + insetsHeight
//        return contentSize
//    }
//    
//    func setDefaultText(_ defaultText:String!)->Void{
//        if self.text == "" ||  self.text == " " ||  self.text == nil{
//            self.text = defaultText
//        }
//    }
//    
//    func setLabelFont(FontName:String,fontSize:CGFloat){
//        self.font = UIFont(name: FontName, size: fontSize)
//    }
//    
//    
//    func heightForView(text:String, width:CGFloat) -> CGFloat
//    {
//        self.frame = CGRect(x: 0,y: 0, width: width, height: CGFloat(MAXFLOAT))
//        self.numberOfLines = 0
//        self.lineBreakMode = NSLineBreakMode.byWordWrapping
//        self.text = text
//        
//        self.sizeToFit()
//        return self.frame.height
//    }
//    
//    func startBlink() {
//        UIView.animate(withDuration: 0.1,
//                       delay:0.0,
//                       options:[.allowUserInteraction, .curveEaseInOut, .autoreverse, .repeat],
//                       animations: { self.alpha = 0 },
//                       completion: nil)
//    }
//    
//    func stopBlink() {
//        layer.removeAllAnimations()
//        alpha = 1
//    }
    
    func applyAfritiaBorederTheme(cornerRadius:CGFloat) {
        
        self.layer.cornerRadius = cornerRadius
        self .layer.borderColor = UIColor.LightLavendar.cgColor
        self.layer.borderWidth = 1
        self.layer.masksToBounds = true
    }

}
