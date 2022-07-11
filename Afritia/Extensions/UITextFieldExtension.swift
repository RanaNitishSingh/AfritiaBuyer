//
//  UITextFieldExtension.swift
//  MusicLinkUp
//
//  Created by Ranjit Mahto on 30/10/18.
//  Copyright © 2018 Karan B. All rights reserved.
//

import UIKit

public extension UITextField{
    
    
    func bottomBorder(texField : UITextField){
        
        let topBorder = CALayer()
        topBorder.frame = CGRect(x: 0, y: 49, width: SCREEN_WIDTH, height: 1)
        topBorder.backgroundColor = UIColor.gray.cgColor
        texField.layer.addSublayer(topBorder)
        
        let bottomBorder = CALayer()
        bottomBorder.frame = CGRect(x: 0, y: texField.frame.height - 1.0, width: SCREEN_WIDTH , height: texField.frame.height - 1.0)
        bottomBorder.backgroundColor = UIColor.gray.cgColor
        texField.layer.addSublayer(bottomBorder)
    }
    
    func isLanguageLayoutDirectionRightToLeft() -> Bool {
        let languageCode = UserDefaults.standard
        if #available(iOS 9.0, *) {
            if (languageCode.string(forKey: "language") == "ar") {
                return true
            }else{
                return false
            }
        } else {
            return false;
        }
    }
    
    func setTextAlignmentByLanguage() -> NSTextAlignment
    {
        let languageCode = UserDefaults.standard
        if (languageCode.string(forKey: "language") == "ar") {
            //return true
            return .right
        }else{
            //return false
            return .left
        }
    }
    
    func setLeftPaddingPoints(_ amount:CGFloat){
        let paddingView = UIView(frame: CGRect(x: 0, y: 0, width: amount, height: self.frame.size.height))
        self.leftView = paddingView
        self.leftViewMode = .always
    }
    
    func setRightPaddingPoints(_ amount:CGFloat) {
        let paddingView = UIView(frame: CGRect(x: 0, y: 0, width: amount, height: self.frame.size.height))
        self.rightView = paddingView
        self.rightViewMode = .always
    }
    
    func setRightViewColor(color:UIColor){
        let TextFieldLeftView:UIView = UIView(frame: CGRect(x: 0, y: 0, width: 20, height: 20))
        TextFieldLeftView.backgroundColor = color
        self.rightViewMode = .always
        self.rightView = TextFieldLeftView
    }
    
    func setLeftViewColor(color:UIColor){
        let TextFieldLeftView:UIView = UIView(frame: CGRect(x: 0, y: 0, width: 20, height: 20))
        TextFieldLeftView.backgroundColor = color
        self.rightViewMode = .always
        self.rightView = TextFieldLeftView
    }
    
    func setLeftViewImage(leftImage:UIImage){
        
        let leftView:UIView = UIView(frame: CGRect(x: 15, y: 0, width: 30, height: 30))
        let TextFieldImageView:UIImageView = UIImageView(frame: CGRect(x: 5, y: 5, width: 15, height: 15))
        TextFieldImageView.image = leftImage
        //        TextFieldLeftView.backgroundColor = GlobalData.sharedInstance.hexStringToUIColor(hex: RightViewColorName)
        leftView.addSubview(TextFieldImageView)
        self.leftViewMode = .always
        self.leftView = leftView
    }
    
    func setRightViewImage(rightImage:UIImage){
        
        let rightView:UIView = UIView(frame: CGRect(x: 15, y: 0, width: 30, height: 30))
        let TextFieldImageView:UIImageView = UIImageView(frame: CGRect(x: 5, y: 5, width: 15, height: 15))
        TextFieldImageView.image = rightImage
        //        TextFieldLeftView.backgroundColor = GlobalData.sharedInstance.hexStringToUIColor(hex: RightViewColorName)
        rightView.addSubview(TextFieldImageView)
        self.rightViewMode = .always
        self.rightView = rightView
    }
    
    func isEmpty()-> Bool {
        let whitespaceSet = CharacterSet.whitespaces
        if self.text!.trimmingCharacters(in: whitespaceSet) == "" {
            return true
        }
        //self.shake()
        return false
    }
    
    func textLength() -> Int {
        return (self.text?.count)!
    }
    
    func IsTextfieldEmpty() -> Bool{
        let whitespaceSet = CharacterSet.whitespaces
        if self.text!.trimmingCharacters(in: whitespaceSet) != "" {
            return false
        }
        return true
    }
    
    func isEmail() -> Bool {
        let regex = try? NSRegularExpression(pattern: "^[A-Z0-9._%+-]+@[A-Z0-9.-]+\\.[A-Z]{2,4}$", options: .caseInsensitive)
        return regex?.firstMatch(in: self.text!, options: [], range: NSMakeRange(0, self.text!.count)) != nil
    }
    
    func shake(){
        let animation = CABasicAnimation(keyPath: "position")
        animation.duration = 0.10
        //animation.repeatCount = 1
        animation.autoreverses = true
        animation.fromValue = NSValue(cgPoint: CGPoint(x: self.center.x - 10, y: self.center.y))
        animation.toValue = NSValue(cgPoint: CGPoint(x: self.center.x + 10, y: self.center.y))
        self.layer.add(animation, forKey: "position")
    }
    
    func setBottomBorder(){
        let BottomBorder:CALayer  = CALayer()
        BottomBorder.backgroundColor = UIColor.lightGray.cgColor
        BottomBorder.frame = CGRect(x: 0, y: self.frame.size.height - 2, width: self.frame.size.width , height: 1.0)
        self.layer.addSublayer(BottomBorder)
    }
    
    func setAllBorder()
    {
        self.layer.borderWidth = 0.5
        self.layer.borderColor = UIColor.gray.cgColor
    }
    
    func setPlaceholderLeftPadding(padding:CGFloat) {
        self.leftView = UIView(frame: CGRect(x: 0.0, y: 0.0, width: padding, height: self.frame.height))
        self.leftViewMode = .always
    }
    
    func setupTransparentLayout(_ placeholder: String = "", leftViewImage: String = "") {
        
        self.font = UIFont(name: "Roboto-Regular", size: 14)
        
        self.textColor = UIColor.white
        self.attributedPlaceholder = NSAttributedString(string:placeholder, attributes:[NSAttributedStringKey.foregroundColor: UIColor.lightGray, NSAttributedStringKey.font: UIFont(name: "Roboto-Regular", size: 12)!])
        
        self.clearButtonMode = .whileEditing
        
        //        if leftViewImage != "" {
        //
        //            let leftView = UIView(frame: CGRect(x: 0, y: 0, width:40, height: 40))
        //
        //            let placeholderImage = UIImageView(image: UIImage(named: leftViewImage))
        //            placeholderImage.frame = CGRect(x: 5, y: 5, width: 30, height: 30)
        //            leftView.addSubview(placeholderImage)
        //            self.leftView = leftView
        //            self.leftViewMode = .always
        //
        //        } else {
        //
        //            let leftView = UIView(frame: CGRect(x: 0, y: 0, width: 10, height: 40))
        //            self.leftView = leftView
        //            self.leftViewMode = .always
        //        }
        
        //        let CLEAR_BUTTON_SIZE : CGFloat = 15
        //        let BUTTON_PADDING : CGFloat = 8
        //
        //        let clearView = ClearView(frame: CGRect(x: BUTTON_PADDING / 2.0, y: BUTTON_PADDING / 2.0, width: CLEAR_BUTTON_SIZE, height: CLEAR_BUTTON_SIZE))
        //        clearView.textField = self
        //
        //        self.rightViewMode = .whileEditing;
        //        self.rightView = clearView
        
        self.layer.addBorder(UIRectEdge.bottom, color: UIColor.white, thickness: 0.5)
    }
    
    func customizeView(phText:String = "", phTextColor:UIColor, phFont:UIFont, borderWidth:CGFloat, borderColor:UIColor, roundCorner:CGFloat)->Void
    {
        self.layer.cornerRadius = roundCorner
        self.layer.borderWidth = borderWidth
        self.layer.borderColor = borderColor.cgColor
        
        self.attributedPlaceholder = NSAttributedString(string:phText, attributes:[NSAttributedStringKey.foregroundColor: phTextColor, NSAttributedStringKey.font: phFont])
    }
    
    func setDefaultBottomBorder()->Void{
        
        let border = CALayer()
        
        let width = CGFloat(1)
        border.borderColor = UIColor.lightGray.cgColor
        border.frame = CGRect(x: 0, y: self.frame.size.height - width, width:  self.bounds.size.width, height: self.frame.size.height)
        
        border.borderWidth = width
        self.layer.addSublayer(border)
        self.layer.masksToBounds = true
    }
    
    func setSelectedBottomBorder()->Void{
        
        let border = CALayer()
        
        let width = CGFloat(1)
        //border.borderColor = Functions.colorForHax(APP_COLOR).CGColor
        border.frame = CGRect(x: 0, y: self.frame.size.height - width, width:  self.frame.size.width, height: self.frame.size.height)
        
        border.borderWidth = width
        self.layer.addSublayer(border)
        self.layer.masksToBounds = true
    }
    
    func setDefaultText(_ defaultText:String!)->Void{
        if self.text == "" ||  self.text == " " ||  self.text == nil{
            self.text = defaultText
        }
    }
    
    func setLeftView() -> Void {
        let view : UIView = UIView (frame: CGRect(x: 0,y: 0,width: 5,height: 5))
        self.leftViewMode = UITextFieldViewMode.always
        self.leftView = view
    }
    
    func applyAfritiaTheme(){
        
        self.backgroundColor = UIColor.white
        self.layer.borderColor = UIColor.LightLavendar.cgColor
        self.layer.borderWidth = 0.5
        self.layer.cornerRadius = 5
        self.layer.masksToBounds = true
        self.tintColor = UIColor.DarkLavendar
        
        
    }
}

