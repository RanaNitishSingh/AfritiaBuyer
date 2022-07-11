//
//  UISearchBarExtension.swift
//  Afritia
//
//  Created by Ranjit Mahto on 09/10/20.
//  Copyright © 2020 kunal. All rights reserved.
//
import UIKit
import Foundation


extension UISearchBar {
    
    
    func applyAfritiaTheme() {
        
        self.backgroundColor = UIColor.LightLavendar
        guard let tf = self.value(forKey: "searchField") as? UITextField else { return }
        tf.textColor = UIColor.black
        tf.backgroundColor = UIColor.white
        tf.layer.borderColor = UIColor.Tin.cgColor
        tf.layer.borderWidth = 1.5
        tf.layer.cornerRadius = 5
        
        let image:UIImage = UIImage(named: "ic_camera")!
        let tintedImage = image.tintedWithColor(color: UIColor.lightGray).resizeImageWith(newSize:CGSize(width: 20, height: 20), isOpaque: true)
        self.setImage(tintedImage, for:.bookmark, state:.normal)
        self.showsBookmarkButton = true
        
        
//        let RightView:UIView = UIView(frame: CGRect(x: 0, y: 0, width: 60, height: 30))
//        RightView.backgroundColor = UIColor.DimLavendar
//        tf.rightView = RightView
//        tf.rightViewMode = .always
        
        if let glassIconView = tf.leftView as? UIImageView, let img = glassIconView.image {
            let newImg = img.blendedByColor(UIColor.DarkLavendar)
            glassIconView.image = newImg
        }
        
        
        
        /*
        let searchTextField = self.subviews[0].subviews.last as! UITextField
        searchTextField.layer.cornerRadius = 15
        searchTextField.textAlignment = NSTextAlignment.left
        let image:UIImage = UIImage(named: "search")!
        let imageView:UIImageView = UIImageView.init(image: image)
        searchTextField.leftView = nil
        searchTextField.placeholder = "Search"
        searchTextField.rightView = imageView
        searchTextField.rightViewMode = UITextFieldViewMode.always
        */
        
    }
    
    /*
    override func viewDidAppear(_ animated: Bool) {
            super.viewDidAppear(animated)

            let searchTextField:UITextField = searchBar.subviews[0].subviews.last as! UITextField
            searchTextField.layer.cornerRadius = 15
            searchTextField.textAlignment = NSTextAlignment.left
            let image:UIImage = UIImage(named: "search")!
            let imageView:UIImageView = UIImageView.init(image: image)
            searchTextField.leftView = nil
            searchTextField.placeholder = "Search"
            searchTextField.rightView = imageView
            searchTextField.rightViewMode = UITextFieldViewMode.always
        }*/
    
    func changeSearchBarColor(color: UIColor) {
        UIGraphicsBeginImageContext(self.frame.size)
        color.setFill()
        UIBezierPath(rect: self.frame).fill()
        let bgImage = UIGraphicsGetImageFromCurrentImageContext()!
        UIGraphicsEndImageContext()
        
        self.setSearchFieldBackgroundImage(bgImage, for: .normal)
    }
    
    func customizeSearchField() {
        
        self.barTintColor = UIColor.red
        
        guard let tf = self.value(forKey: "searchField") as? UITextField else { return }
        tf.textColor = UIColor.black
        tf.backgroundColor = UIColor.white
        tf.layer.borderColor = UIColor.Tin.cgColor
        tf.layer.borderWidth = 1.5
        tf.layer.cornerRadius = 5
        
    }
    
    func customizeSearchIcon(){
        
        guard let tf = self.value(forKey: "searchField") as? UITextField else { return }
        if let glassIconView = tf.leftView as? UIImageView, let img = glassIconView.image {
            let newImg = img.blendedByColor(UIColor.DarkLavendar)
            glassIconView.image = newImg
        }
    }
    
    func customizeClearButton() {
        
        guard let tf = self.value(forKey: "searchField") as? UITextField else { return }
        if let clearButton = tf.value(forKey: "clearButton") as? UIButton {
            clearButton.setImage(clearButton.imageView?.image?.withRenderingMode(.alwaysTemplate), for: .normal)
            clearButton.tintColor = UIColor.DarkLavendar
        }
    }
}
