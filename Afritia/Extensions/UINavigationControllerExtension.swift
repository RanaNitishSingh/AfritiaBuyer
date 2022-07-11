//
//  UINavigationControllerExtension.swift
//  MusicLinkUp
//
//  Created by Ranjit Mahto on 30/10/18.
//  Copyright © 2018 Karan B. All rights reserved.
//

import UIKit
import Foundation


extension UINavigationController {
    
    func  customizedWith(barColor:UIColor, tintColor:UIColor, titleColor:UIColor){
        
        self.navigationItem.hidesBackButton = true
        self.navigationController?.navigationBar.isOpaque = true
        self.navigationController?.navigationBar.isTranslucent = false
        self.navigationController?.interactivePopGestureRecognizer?.isEnabled = false
        self.navigationController?.navigationBar.tintColor = tintColor
        self.navigationController?.navigationBar.barTintColor = barColor
        
        self.navigationController?.navigationBar.titleTextAttributes = [NSAttributedStringKey(rawValue: NSAttributedStringKey.foregroundColor.rawValue): UIColor.white]
    }
    
    func setPlainBackGround(){
        self.navigationBar.shadowImage = UIImage()
        self.navigationBar.setBackgroundImage(UIImage(), for: UIBarPosition.any,barMetrics: UIBarMetrics.default)
    }
    
}

extension UINavigationBar {
    
    
    open override func sizeThatFits(_ size: CGSize) -> CGSize {
            return CGSize(width: UIScreen.main.bounds.width, height: 51)
        }
    
    func setGradientGroupBackground(colors: [UIColor])
    {
        var updatedFrame = bounds
        updatedFrame.size.height += 20
        let gradientLayer = CAGradientLayer(frame: updatedFrame, colors: colors)
        
        setBackgroundImage(gradientLayer.creatGradientImage(), for: UIBarMetrics.default)
    }
    
    func setGradientNormalBackground()
    {
        if let image = UIImage(named: "Navigation_Bar")
        {
            let backgroundImage = image.resizableImage(withCapInsets: UIEdgeInsets.zero, resizingMode: .stretch)
            UINavigationBar.appearance().setBackgroundImage(backgroundImage, for: .default)
            UINavigationBar.appearance().shadowImage = UIImage()
        }
        //self.shadowImage = UIImage()
        //self.setBackgroundImage(UIImage(), for: UIBarPosition.any,barMetrics: UIBarMetrics.default)
    }
    
    /// Applies a background gradient with the given colors
    func applyNavigationGradient( colors : [UIColor]) {
        var frameAndStatusBar: CGRect = self.bounds
        frameAndStatusBar.size.height += 20 // add 20 to account for the status bar
        
        setBackgroundImage(UINavigationBar.gradient(size: frameAndStatusBar.size, colors: colors), for: .default)
    }
    
    /// Creates a gradient image with the given settings
    static func gradient(size : CGSize, colors : [UIColor]) -> UIImage?
    {
        // Turn the colors into CGColors
        let cgcolors = colors.map { $0.cgColor }
        
        // Begin the graphics context
        UIGraphicsBeginImageContextWithOptions(size, true, 0.0)
        
        // If no context was retrieved, then it failed
        guard let context = UIGraphicsGetCurrentContext() else { return nil }
        
        // From now on, the context gets ended if any return happens
        defer { UIGraphicsEndImageContext() }
        
        // Create the Coregraphics gradient
        var locations : [CGFloat] = [0.0, 1.0]
        guard let gradient = CGGradient(colorsSpace: CGColorSpaceCreateDeviceRGB(), colors: cgcolors as NSArray as CFArray, locations: &locations) else { return nil }
        
        // Draw the gradient
        context.drawLinearGradient(gradient, start: CGPoint(x: 0.0, y: 0.0), end: CGPoint(x: size.width, y: 0.0), options: [])
        
        // Generate the image (the defer takes care of closing the context)
        return UIGraphicsGetImageFromCurrentImageContext()
    }
    
    
    
    
    func applyAfritiaTheme(){
        
        self.isOpaque = true
        self.isTranslucent = false
        self.tintColor = UIColor.white
        self.barTintColor = UIColor.LightLavendar
        self.titleTextAttributes = [NSAttributedStringKey(rawValue: NSAttributedStringKey.foregroundColor.rawValue): UIColor.blue]
        
        
    }
    
    func setAttributedTitle(color:UIColor){
        
        self.titleTextAttributes = [NSAttributedStringKey(rawValue: NSAttributedStringKey.foregroundColor.rawValue): color]
    }
    
    func makeBarTransparent(titleColor:UIColor){
        
        self.setBackgroundImage(UIImage(), for: UIBarMetrics.default)
        self.shadowImage = UIImage()
        self.isTranslucent = true
        self.barTintColor = UIColor.clear
        self.tintColor = titleColor
        self.barStyle = .default
        
    }
    
    func removeHairLine(){
        self.shadowImage = UIImage()
    }
}

extension UINavigationItem {
    
    func setImageTitleView(titleImage:UIImage){
        let titleLogoImgView = UIImageView(frame:CGRect(x:0, y:0, width:130, height:40))
        titleLogoImgView.image = titleImage //UIImage(named: "afritia_logo")
        
        let navTitleView = UIView(frame: CGRect(x: 0, y: 0, width:SCREEN_WIDTH - 45, height: titleLogoImgView.frame.height))
        //navTitleView.backgroundColor = UIColor.red
        navTitleView.addSubview(titleLogoImgView)
        self.titleView = navTitleView
    }
    
    func setImageTitleView(){
        let titleLogoImgView = UIImageView(frame:CGRect(x:0, y:0, width:130, height:40))
        titleLogoImgView.image = UIImage(named: "afritia_logo")!
        
        let navTitleView = UIView(frame: CGRect(x: 0, y: 0, width:SCREEN_WIDTH - 45, height: titleLogoImgView.frame.height))
        //navTitleView.backgroundColor = UIColor.red
        navTitleView.addSubview(titleLogoImgView)
        self.titleView = navTitleView
    }
    
}

extension UIBarButtonItem {
    
    var isHidden: Bool {
        get {
            return tintColor == UIColor.clear
        }
        set(hide) {
            if hide {
                isEnabled = false
                tintColor = UIColor.clear
            } else {
                isEnabled = true
                tintColor = nil // This sets the tinColor back to the default. If you have a custom color, use that instead
            }
        }
    }
    
    var isHideBackBtnTitle : Bool {
        
        //navigationItem.backBarButtonItem = UIBarButtonItem(title: " ", style: .plain, target: nil, action: nil)
        
        get {
            return self.title == ""
        }
        set(hide) {
            if hide {
                isEnabled = false
                self.title = ""
            }else{
                isEnabled = true
                self.title = nil
            }
        }
        
    }
}

