//
//  UIViewExtension.swift
//  MusicLinkUp
//
//  Created by Ranjit Mahto on 30/10/18.
//  Copyright © 2018 Karan B. All rights reserved.
//

import UIKit


extension UIViewController {
    
    /**
     *  Height of status bar + navigation bar (if navigation bar exist)
     */
    var topbarHeight: CGFloat {
        return UIApplication.shared.statusBarFrame.size.height +
            (self.navigationController?.navigationBar.frame.height ?? 0.0)
    }
    
    var topHeight: CGFloat {
        if #available(iOS 13.0, *) {
            return (view.window?.windowScene?.statusBarManager?.statusBarFrame.height ?? 0.0) +
                (self.navigationController?.navigationBar.frame.height ?? 0.0)
        }
        
        return UIApplication.shared.statusBarFrame.size.height +
            (self.navigationController?.navigationBar.frame.height ?? 0.0)
    }
    
    func changeStatusBarColor(color:UIColor){
        if #available(iOS 13.0, *) {
            let statusBar = UIView(frame: UIApplication.shared.keyWindow?.windowScene?.statusBarManager?.statusBarFrame ?? CGRect.zero)
             statusBar.backgroundColor = color
             UIApplication.shared.keyWindow?.addSubview(statusBar)
        } else {
             UIApplication.shared.statusBarView?.backgroundColor = color
        }
    }
    
    func setMainTitle(_ navigationTitle:String!)->Void{
        self.navigationItem.title = navigationTitle
    }
    func setCustomeTitleView(_ navigationTitle:String!)->Void{
        
        let label = UILabel()
        label.numberOfLines = 2
        label.textAlignment = NSTextAlignment.center
        label.text = navigationTitle
        label.sizeToFit()
        label.textColor = UIColor.white
        
        self.navigationItem.titleView = label
    }
    
    func setBackButton()->Void{
        self.navigationItem.backBarButtonItem = UIBarButtonItem(title: "Back", style: .done, target: nil, action: nil)
    }
    
    func setMenuButton()->Void{
        //let menu = UIBarButtonItem(image: UIImage(named: "menu"), style: .Done, target: self.revealViewController(), action: "revealToggle:")
        //self.navigationItem.leftBarButtonItem = menu
    }
    
    func setSaveButton(_ action:Selector)->Void{
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.save, target: self, action: action)
    }
    
    func setBlurryBackground(){
        let visualEffectView = UIVisualEffectView(effect: UIBlurEffect(style: .light)) as UIVisualEffectView
        visualEffectView.frame = self.view.bounds
        visualEffectView.tag = 999
        self.view.addSubview(visualEffectView)
        visualEffectView.isHidden=true;
    }
    
    func isViewEmpty(_ isempty:Bool){
        let visualEffect:UIVisualEffectView? = view.viewWithTag(9999) as? UIVisualEffectView
        if visualEffect == nil{
            return
        }
        //UIView.transitionWithView(visualEffect!, duration: 0.5, options: UIViewAnimationOptions.TransitionCrossDissolve, animations: { () -> Void in
        visualEffect?.isHidden = isempty
        //}, completion: nil)
    }
}

/*
@IBDesignable
class DesignableView: UIView {
}

@IBDesignable
class DesignableButton: UIButton {
}

@IBDesignable
class DesignableLabel: UILabel {
}*/

extension UIView {
    
    /*
    @IBInspectable
        var cornerRadius: CGFloat {
            get {
                return layer.cornerRadius
            }
            set {
                layer.cornerRadius = newValue
            }
        }

        @IBInspectable
        var borderWidth: CGFloat {
            get {
                return layer.borderWidth
            }
            set {
                layer.borderWidth = newValue
            }
        }
        
        @IBInspectable
        var borderColor: UIColor? {
            get {
                if let color = layer.borderColor {
                    return UIColor(cgColor: color)
                }
                return nil
            }
            set {
                if let color = newValue {
                    layer.borderColor = color.cgColor
                } else {
                    layer.borderColor = nil
                }
            }
        }
        
        @IBInspectable
        var shadowRadius: CGFloat {
            get {
                return layer.shadowRadius
            }
            set {
                layer.shadowRadius = newValue
            }
        }
        
        @IBInspectable
        var shadowOpacity: Float {
            get {
                return layer.shadowOpacity
            }
            set {
                layer.shadowOpacity = newValue
            }
        }
        
        @IBInspectable
        var shadowOffset: CGSize {
            get {
                return layer.shadowOffset
            }
            set {
                layer.shadowOffset = newValue
            }
        }
        
        @IBInspectable
        var shadowColor: UIColor? {
            get {
                if let color = layer.shadowColor {
                    return UIColor(cgColor: color)
                }
                return nil
            }
            set {
                if let color = newValue {
                    layer.shadowColor = color.cgColor
                } else {
                    layer.shadowColor = nil
                }
            }
        }
 
 */

    enum ViewSide {
        case top
        case right
        case bottom
        case left
    }
    
    func createBorder(side: ViewSide, thickness: CGFloat, color: UIColor, leftOffset: CGFloat = 0, rightOffset: CGFloat = 0, topOffset: CGFloat = 0, bottomOffset: CGFloat = 0) -> CALayer {
        
        switch side {
        case .top:
            // Bottom Offset Has No Effect
            // Subtract the bottomOffset from the height and the thickness to get our final y position.
            // Add a left offset to our x to get our x position.
            // Minus our rightOffset and negate the leftOffset from the width to get our endpoint for the border.
            return _getOneSidedBorder(frame: CGRect(x: 0 + leftOffset,
                                                    y: 0 + topOffset,
                                                    width: self.frame.size.width - leftOffset - rightOffset,
                                                    height: thickness), color: color)
        case .right:
            // Left Has No Effect
            // Subtract bottomOffset from the height to get our end.
            return _getOneSidedBorder(frame: CGRect(x: self.frame.size.width - thickness - rightOffset,
                                                    y: 0 + topOffset,
                                                    width: thickness,
                                                    height: self.frame.size.height), color: color)
        case .bottom:
            // Top has No Effect
            // Subtract the bottomOffset from the height and the thickness to get our final y position.
            // Add a left offset to our x to get our x position.
            // Minus our rightOffset and negate the leftOffset from the width to get our endpoint for the border.
            return _getOneSidedBorder(frame: CGRect(x: 0 + leftOffset,
                                                    y: self.frame.size.height-thickness-bottomOffset,
                                                    width: self.frame.size.width - leftOffset - rightOffset,
                                                    height: thickness), color: color)
        case .left:
            // Right Has No Effect
            return _getOneSidedBorder(frame: CGRect(x: 0 + leftOffset,
                                                    y: 0 + topOffset,
                                                    width: thickness,
                                                    height: self.frame.size.height - topOffset - bottomOffset), color: color)
        }
    }
    
    func createViewBackedBorder(side: ViewSide, thickness: CGFloat, color: UIColor, leftOffset: CGFloat = 0, rightOffset: CGFloat = 0, topOffset: CGFloat = 0, bottomOffset: CGFloat = 0) -> UIView {
        
        switch side {
        case .top:
            let border: UIView = _getViewBackedOneSidedBorder(frame: CGRect(x: 0 + leftOffset,
                                                                            y: 0 + topOffset,
                                                                            width: self.frame.size.width - leftOffset - rightOffset,
                                                                            height: thickness), color: color)
            border.autoresizingMask = [.flexibleWidth, .flexibleBottomMargin]
            return border
            
        case .right:
            let border: UIView = _getViewBackedOneSidedBorder(frame: CGRect(x: self.frame.size.width-thickness-rightOffset,
                                                                            y: 0 + topOffset, width: thickness,
                                                                            height: self.frame.size.height - topOffset - bottomOffset), color: color)
            border.autoresizingMask = [.flexibleHeight, .flexibleLeftMargin]
            return border
            
        case .bottom:
            let border: UIView = _getViewBackedOneSidedBorder(frame: CGRect(x: 0 + leftOffset,
                                                                            y: self.frame.size.height-thickness-bottomOffset,
                                                                            width: self.frame.size.width - leftOffset - rightOffset,
                                                                            height: thickness), color: color)
            border.autoresizingMask = [.flexibleWidth, .flexibleTopMargin]
            return border
            
        case .left:
            let border: UIView = _getViewBackedOneSidedBorder(frame: CGRect(x: 0 + leftOffset,
                                                                            y: 0 + topOffset,
                                                                            width: thickness,
                                                                            height: self.frame.size.height - topOffset - bottomOffset), color: color)
            border.autoresizingMask = [.flexibleHeight, .flexibleRightMargin]
            return border
        }
    }
    
    func addBorder(side: ViewSide, thickness: CGFloat, color: UIColor, leftOffset: CGFloat = 0, rightOffset: CGFloat = 0, topOffset: CGFloat = 0, bottomOffset: CGFloat = 0) {
        
        switch side {
        case .top:
            // Add leftOffset to our X to get start X position.
            // Add topOffset to Y to get start Y position
            // Subtract left offset from width to negate shifting from leftOffset.
            // Subtract rightoffset from width to set end X and Width.
            let border: CALayer = _getOneSidedBorder(frame: CGRect(x: 0 + leftOffset,
                                                                   y: 0 + topOffset,
                                                                   width: self.frame.size.width - leftOffset - rightOffset - 40,
                                                                   height: thickness), color: color)
            self.layer.addSublayer(border)
        case .right:
            // Subtract the rightOffset from our width + thickness to get our final x position.
            // Add topOffset to our y to get our start y position.
            // Subtract topOffset from our height, so our border doesn't extend past teh view.
            // Subtract bottomOffset from the height to get our end.
            let border: CALayer = _getOneSidedBorder(frame: CGRect(x: self.frame.size.width-thickness-rightOffset,
                                                                   y: 0 + topOffset, width: thickness,
                                                                   height: self.frame.size.height - topOffset - bottomOffset), color: color)
            self.layer.addSublayer(border)
        case .bottom:
            // Subtract the bottomOffset from the height and the thickness to get our final y position.
            // Add a left offset to our x to get our x position.
            // Minus our rightOffset and negate the leftOffset from the width to get our endpoint for the border.
            let border: CALayer = _getOneSidedBorder(frame: CGRect(x: 0 + leftOffset,
                                                                   y: self.frame.size.height-thickness-bottomOffset,
                                                                   width: self.frame.size.width - leftOffset - rightOffset - 40, height: thickness), color: color)
            self.layer.addSublayer(border)
        case .left:
            let border: CALayer = _getOneSidedBorder(frame: CGRect(x: 0 + leftOffset,
                                                                   y: 0 + topOffset,
                                                                   width: thickness,
                                                                   height: self.frame.size.height - topOffset - bottomOffset), color: color)
            self.layer.addSublayer(border)
        }
    }
    
    func addViewBackedBorder(side: ViewSide, thickness: CGFloat, color: UIColor, leftOffset: CGFloat = 0, rightOffset: CGFloat = 0, topOffset: CGFloat = 0, bottomOffset: CGFloat = 0) {
        
        switch side {
        case .top:
            let border: UIView = _getViewBackedOneSidedBorder(frame: CGRect(x: 0 + leftOffset,
                                                                            y: 0 + topOffset,
                                                                            width: self.frame.size.width - leftOffset - rightOffset,
                                                                            height: thickness), color: color)
            border.autoresizingMask = [.flexibleWidth, .flexibleBottomMargin]
            self.addSubview(border)
            
        case .right:
            let border: UIView = _getViewBackedOneSidedBorder(frame: CGRect(x: self.frame.size.width-thickness-rightOffset,
                                                                            y: 0 + topOffset, width: thickness,
                                                                            height: self.frame.size.height - topOffset - bottomOffset), color: color)
            border.autoresizingMask = [.flexibleHeight, .flexibleLeftMargin]
            self.addSubview(border)
            
        case .bottom:
            let border: UIView = _getViewBackedOneSidedBorder(frame: CGRect(x: 0 + leftOffset,
                                                                            y: self.frame.size.height-thickness-bottomOffset,
                                                                            width: self.frame.size.width - leftOffset - rightOffset,
                                                                            height: thickness), color: color)
            border.autoresizingMask = [.flexibleWidth, .flexibleTopMargin]
            self.addSubview(border)
        case .left:
            let border: UIView = _getViewBackedOneSidedBorder(frame: CGRect(x: 0 + leftOffset,
                                                                            y: 0 + topOffset,
                                                                            width: thickness,
                                                                            height: self.frame.size.height - topOffset - bottomOffset), color: color)
            border.autoresizingMask = [.flexibleHeight, .flexibleRightMargin]
            self.addSubview(border)
        }
    }
    
    // Private: Our methods call these to add their borders.
    fileprivate func _getOneSidedBorder(frame: CGRect, color: UIColor) -> CALayer {
        let border:CALayer = CALayer()
        border.frame = frame
        border.backgroundColor = color.cgColor
        return border
    }
    
    fileprivate func _getViewBackedOneSidedBorder(frame: CGRect, color: UIColor) -> UIView {
        let border:UIView = UIView.init(frame: frame)
        border.backgroundColor = color
        return border
    }
    
    func applyRoundCornerShadow(radius : CGFloat)   {
        self.layer.cornerRadius = radius
        self.layer.shadowPath = UIBezierPath(roundedRect: self.bounds, cornerRadius: radius).cgPath
        self.layer.shadowOffset = CGSize(width: 0, height: 0)
        self.layer.shadowRadius = 2
        self.layer.shadowOpacity = 1
        self.backgroundColor = UIColor.white
    }
    
    func applyRoundCornerBorder(radius: CGFloat, width:CGFloat, color:UIColor)  {
        self.layer.cornerRadius = radius
        self.layer.masksToBounds = true
        self.layer.borderColor = color.cgColor
        self.layer.borderWidth = width
    }
    
    func applyGradient(colours: [UIColor]) -> Void {
        self.applyGradient(colours: colours, locations: nil)
    }
    
    func applyGradient(colours: [UIColor], locations: [NSNumber]?) -> Void {
        let gradient: CAGradientLayer = CAGradientLayer()
        gradient.frame = self.bounds
        gradient.colors = colours.map { $0.cgColor }
        gradient.locations = locations
        self.layer.addSublayer(gradient)
    }
    
    func applyGradientToTopView(colours: [UIColor], locations: [NSNumber]?) -> Void {
        let gradient: CAGradientLayer = CAGradientLayer()
        gradient.frame = self.bounds
        gradient.colors = colours.map { $0.cgColor }
        gradient.locations = locations
        self.layer.insertSublayer(gradient, at: 0)
    }
    
    func applyShadowedBorder() {
        self.layer.shadowColor = UIColor.black.withAlphaComponent(0.25).cgColor
        self.layer.shadowOpacity = 1.0
        self.layer.shadowOffset = CGSize(width: 0, height: 2.0)
        self.layer.shadowRadius = 5
        self.layer.masksToBounds = false
    }
    
    func setCornerRadius(radius: CGFloat)  {
        self.layer.cornerRadius = radius
        self.clipsToBounds = true
    }
    
    /*
     func addDashedBorder() {
     let color = UIColor.lightGray.cgColor
     
     let shapeLayer:CAShapeLayer = CAShapeLayer()
     let frameSize = self.frame.size
     let shapeRect = CGRect(x: 0, y: 0, width: frameSize.width, height: frameSize.height)
     
     shapeLayer.bounds = shapeRect
     shapeLayer.position = CGPoint(x: frameSize.width/2, y: frameSize.height/2)
     shapeLayer.fillColor = UIColor.clear.cgColor
     shapeLayer.strokeColor = color
     shapeLayer.lineWidth = 2
     shapeLayer.lineJoin = kCALineJoinRound
     shapeLayer.lineDashPattern = [6,3]
     shapeLayer.path = UIBezierPath(roundedRect: shapeRect, cornerRadius: 5).cgPath
     
     self.layer.addSublayer(shapeLayer)
     }
     
     func addBottomBorder(BorderWidth:CGFloat, BorderColor:UIColor){
     let BottomShapeLayer:CALayer = CALayer()
     
     let BorderFrameSize = self.frame.size
     print(self.frame.size.width)
     
     BottomShapeLayer.frame = CGRect(x: 0, y: BorderFrameSize.height - BorderWidth, width: BorderFrameSize.width , height: BorderWidth)
     BottomShapeLayer.backgroundColor = BorderColor.cgColor
     self.layer.addSublayer(BottomShapeLayer)
     }
     
     func addTopBorder(BorderWidth:CGFloat, BorderColor:UIColor){
     let BottomShapeLayer:CALayer = CALayer()
     let BorderFrameSize = self.frame.size
     BottomShapeLayer.frame = CGRect(x: 0, y: 0, width: BorderFrameSize.width , height: BorderWidth)
     BottomShapeLayer.backgroundColor = BorderColor.cgColor
     self.layer.addSublayer(BottomShapeLayer)
     }
     
     func addLeftBorder(BorderWidth:CGFloat, BorderColor:UIColor) {
     let border = CALayer()
     border.backgroundColor = BorderColor.cgColor
     border.frame = CGRect(x: 0, y: 0, width: BorderWidth, height: self.frame.size.height)
     self.layer.addSublayer(border)
     }
     
     func addRightBorder(BorderWidth:CGFloat, BorderColor:UIColor) {
     let border = CALayer()
     border.backgroundColor = BorderColor.cgColor
     border.frame = CGRect(x: self.frame.size.width - BorderWidth, y: 0, width: BorderWidth, height: self.frame.size.height)
     self.layer.addSublayer(border)
     }
     
     func addLeftBottomBorder(BorderWidth:CGFloat, BorderColor:CGColor){
     let LeftBottomShapeLayer:CALayer = CALayer()
     let BorderFrameSize = self.frame.size
     LeftBottomShapeLayer.frame = CGRect(x: 0, y: BorderFrameSize.height - BorderFrameSize.height/4, width: BorderWidth, height: BorderFrameSize.height/4)
     LeftBottomShapeLayer.backgroundColor = BorderColor
     self.layer.addSublayer(LeftBottomShapeLayer)
     
     }
     
     func addRightBottomBorder(BorderWidth:CGFloat, BorderColor:CGColor){
     let RightBottomShapeLayer:CALayer = CALayer()
     let BorderFrameSize = self.frame.size
     RightBottomShapeLayer.frame = CGRect(x: BorderFrameSize.width - BorderWidth, y: BorderFrameSize.height - BorderFrameSize.height/4, width: BorderWidth, height: BorderFrameSize.height/4)
     RightBottomShapeLayer.backgroundColor = BorderColor
     self.layer.addSublayer(RightBottomShapeLayer)
     } */

    func makeRoundCorners(_ corners:UIRectCorner, radius: CGFloat) {
        let path = UIBezierPath(roundedRect: self.bounds, byRoundingCorners: corners, cornerRadii: CGSize(width: radius, height: radius))
        let mask = CAShapeLayer()
        mask.path = path.cgPath
        self.layer.mask = mask
    }
    
    func addGradientWithColor(color: UIColor) {
        let gradient = CAGradientLayer()
        gradient.frame = self.bounds
        gradient.colors = [color.cgColor, UIColor.clear.cgColor ]
        
        self.layer.insertSublayer(gradient, at: 0)
    }
    
    func setAppRadius()->Void{
        self.layer.cornerRadius = 3.0
    }
    
    func isViewEmpty(_ isempty:Bool){
        let visualEffect:UIVisualEffectView? = self.viewWithTag(9999) as? UIVisualEffectView
        if visualEffect == nil{
            return
        }
        visualEffect?.isHidden = isempty
    }
    
    func setAppShadow(_ color:UIColor)
    {
        self.layer.shadowColor = color.cgColor;
        self.layer.shadowOffset = CGSize(width: 0,height: -2);
        self.layer.shadowOpacity = 0.5;
        self.layer.shadowRadius = 10.0;
        self.clipsToBounds = false
    }
    
    func setAppFullShadow(_ color:UIColor){
        
        let shadowPath = UIBezierPath(rect: self.bounds)
        self.layer.shadowColor = color.cgColor;
        self.layer.shadowOffset = CGSize(width: 0,height: 2);
        self.layer.shadowOpacity = 0.5;
        self.layer.shadowRadius = self.frame.width/2;
        self.layer.shadowPath = shadowPath.cgPath;
        self.clipsToBounds = false
    }
    
    func fadeTransition(_ duration:CFTimeInterval) {
        let animation:CATransition = CATransition()
        animation.timingFunction = CAMediaTimingFunction(name:
            kCAMediaTimingFunctionEaseInEaseOut)
        animation.type = kCATransitionFade
        animation.duration = duration
        self.layer.add(animation, forKey: kCATransitionFade)
    }
    
    func setCardView(cardColor : UIColor){
        
        self.layer.backgroundColor = cardColor.cgColor
        self.layer.cornerRadius = 5.0
        self.layer.borderColor  =  UIColor.appLightGrey.cgColor
        self.layer.borderWidth = 0.5
        self.layer.shadowOpacity = 0.5
        self.layer.shadowColor =  UIColor.darkGray.cgColor
        self.layer.shadowRadius = 1.0
        self.layer.shadowOffset = CGSize(width:0.5, height: 0.5)
        self.layer.masksToBounds = false
    }
    
    func setUpProfilePictureView(imgView:UIImageView){
        
        self.layer.cornerRadius =  self.bounds.width/2
        //self.bgViewProfileImage.clipsToBounds = true
        
        imgView.layer.cornerRadius = imgView.bounds.width/2
        imgView.clipsToBounds = true
        
        self.layer.borderWidth = 0.0
        self.layer.borderColor  = UIColor.appLightGrey.cgColor
        
        self.layer.shadowColor = UIColor.darkGray.cgColor
        self.layer.shadowOffset = CGSize(width:0, height:1)
        self.layer.shadowRadius = 1
        self.layer.shadowOpacity = 0.3
        
    }
    
    func setUpProfilePictureWithoutShadowView(imgView:UIImageView){
        
        self.layer.cornerRadius =  self.bounds.width/2
        //self.bgViewProfileImage.clipsToBounds = true
        
        imgView.layer.cornerRadius = imgView.bounds.width/2
        imgView.clipsToBounds = true
        
        self.layer.borderWidth = 0.0
        self.layer.borderColor  = UIColor.appLightGrey.cgColor
        
        self.layer.shadowColor = UIColor.darkGray.cgColor
        self.layer.shadowOffset = CGSize(width:0, height:0)
        self.layer.shadowRadius = 0
        self.layer.shadowOpacity = 0.0
    }
    
    
    // In order to create computed properties for extensions, we need a key to
        // store and access the stored property
        fileprivate struct AssociatedObjectKeys {
            static var tapGestureRecognizer = "MediaViewerAssociatedObjectKey_mediaViewer"
        }
        
        fileprivate typealias Action = (() -> Void)?
        
        // Set our computed property type to a closure
        fileprivate var tapGestureRecognizerAction: Action? {
            set {
                if let newValue = newValue {
                    // Computed properties get stored as associated objects
                    objc_setAssociatedObject(self, &AssociatedObjectKeys.tapGestureRecognizer, newValue, objc_AssociationPolicy.OBJC_ASSOCIATION_RETAIN)
                }
            }
            get {
                let tapGestureRecognizerActionInstance = objc_getAssociatedObject(self, &AssociatedObjectKeys.tapGestureRecognizer) as? Action
                return tapGestureRecognizerActionInstance
            }
        }
        
        // This is the meat of the sauce, here we create the tap gesture recognizer and
        // store the closure the user passed to us in the associated object we declared above
        func addTapGestureRecognizer(action: (() -> Void)?) {
            self.isUserInteractionEnabled = true
            self.tapGestureRecognizerAction = action
            let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(handleTapGesture))
            self.addGestureRecognizer(tapGestureRecognizer)
        }
        
        // Every time the user taps on the UIImageView, this function gets called,
        // which triggers the closure we stored
        @objc fileprivate func handleTapGesture(sender: UITapGestureRecognizer) {
            if let action = self.tapGestureRecognizerAction {
                action?()
            } else {
                print("no action")
            }
        }
    
   
    
    
    
}
