//
//  UIImageViewExtension.swift
//  MusicLinkUp
//
//  Created by Ranjit Mahto on 30/10/18.
//  Copyright © 2018 Karan B. All rights reserved.
//

import UIKit

public extension UIImageView
{
    
    func addBlackGradientLayer(frame: CGRect, colors:[UIColor]){
        let gradient = CAGradientLayer()
        gradient.frame = frame
        
        gradient.colors = colors.map{$0.cgColor}
        self.layer.addSublayer(gradient)
    }
    
    func addBlurEffect()
    {
        let blurEffect = UIBlurEffect(style: UIBlurEffectStyle.light)
        let blurEffectView = UIVisualEffectView(effect: blurEffect)
        blurEffectView.frame = self.bounds
        
        blurEffectView.autoresizingMask = [.flexibleWidth, .flexibleHeight] // for supporting device rotation
        self.addSubview(blurEffectView)
    }
    
    func applyRoundMask(){
        
//        let maskImageView = UIImageView()
//        maskImageView.image = UIImage(named:"circular_shape_mask")
//        maskImageView.frame = bounds
//        mask = maskImageView
        
        self.layer.cornerRadius =  self.bounds.width/2
        self.layer.masksToBounds = true
        self.clipsToBounds = true
        
        self.layer.borderWidth = 0.5
        self.layer.borderColor  = UIColor.appLightGrey.cgColor
        
        //self.layer.borderWidth = 1
        //self.layer.borderColor = AppColor.DarkNavBlue.cgColor
        
    }
    
    func applyRoundRectMask(){
        
        let maskImageView = UIImageView()
        maskImageView.image = UIImage(named:"round_rect_shape_mask")
        maskImageView.frame = bounds
        mask = maskImageView
        
    }
    
    func setUserNameLetter(userName:String, bgColor:UIColor, fontSize:CGFloat){
        /*
        self.setLetterImage(string: userName, color:bgColor, circular: true, textAttributes:[NSAttributedStringKey.font : UIFont.systemFont(ofSize:fontSize, weight:.light), NSAttributedStringKey.foregroundColor :UIColor.white])
        */
    }
    
    func getImageFromUrl(imageUrl:String){
        
        let urlString = imageUrl.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)
        let image  = profileImageCache.object(forKey: urlString as AnyObject)
        if image != nil{
            self.image = image as? UIImage
        }else{
            if  URL(string:urlString!) != nil{
                DispatchQueue.global(qos: .background).async {
                    let operation = BlockOperation(block: {
                        let url =  URL(string:urlString!)
                        let data = try? Data(contentsOf: url!)
                        if data != nil{
                            if let img = UIImage(data: data!){
                                OperationQueue.main.addOperation({
                                    self.image = img
                                    profileImageCache.setObject(img, forKey: imageUrl as AnyObject)
                                })
                            }
                        }
                    })
                    queue.addOperation(operation)
                }
            }
        }
    }
    
   /* func addRoundBorderWithShadow(borderWidth:CGFloat, borderColor:UIColor) {
        
        
        /*
        let layer = CALayer()
        layer.frame = self.bounds
        
        //layer.contents = self.image?.cgImage
        //layer.contentsGravity = kCAGravityCenter
        
        //layer.magnificationFilter = kCAFilterLinear
        //layer.isGeometryFlipped = false
        
        layer.backgroundColor = UIColor.clear.cgColor // UIColor(red: 11/255.0, green: 86/255.0, blue: 14/255.0, alpha: 1.0).cgColor
        layer.opacity = 1.0
        layer.isHidden = false
        layer.masksToBounds = false
        
        layer.cornerRadius = self.bounds.width/2
        layer.borderWidth = 2.0
        layer.borderColor = UIColor.white.cgColor
        
        layer.shadowOpacity = 0.75
        layer.shadowOffset = CGSize(width: 0, height: 1)
        layer.shadowRadius = 0.0
        
        //layer.shouldRasterize = true
        
        self.layer.addSublayer(layer)
        */
        
        
        /*
        let shadowLayer = CAShapeLayer()
        //var shadowLayer: CAShapeLayer!
        
        shadowLayer.path = UIBezierPath(roundedRect: bounds, cornerRadius: self.bounds.width/2).cgPath
        shadowLayer.fillColor =  UIColor.clear.cgColor
        
        shadowLayer.shadowColor = UIColor.black.cgColor
        shadowLayer.shadowPath = shadowLayer.path
        shadowLayer.shadowOffset = CGSize(width: 0.0, height: 2.0)
        shadowLayer.shadowOpacity = 0.5
        shadowLayer.shadowRadius = 5
        
        layer.insertSublayer(shadowLayer, at: 2)
        
        layer.borderColor = UIColor.white.cgColor
        layer.borderWidth = 2
         */
        
        /*
        self.layer.cornerRadius =  self.bounds.width/2
        //self.bgViewProfileImage.clipsToBounds = true
        self.layer.masksToBounds = true
        
        self.layer.borderWidth = 2.0
        self.layer.borderColor  = AppColor.ExLightGray.cgColor
        
        self.layer.shadowColor = UIColor.black.cgColor
        self.layer.shadowOffset = CGSize(width:7, height:8)
        self.layer.shadowRadius = 10
        self.layer.shadowOpacity = 1
         */
        
    }*/
}

