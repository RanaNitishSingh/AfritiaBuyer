//
//  CommonAppFunction.swift
//  MusicLinkUp
//
//  Created by Ranjit Mahto on 05/04/19.
//  Copyright © 2019 Karan B. All rights reserved.
//

import Foundation
import MessageUI
import Contacts
import UIKit

class AppFunction {
    
    class func isRealDevice() -> Bool {
        #if targetEnvironment(simulator)
          return false
        #else
          return true
        #endif
    }
    
    class func getTextHeight(text:String, textWidth:CGFloat) -> CGFloat {
        
        let size = CGSize(width: textWidth, height: 1000)
        let option = NSStringDrawingOptions.usesFontLeading.union(.usesLineFragmentOrigin)
        let estimatedFrame = NSString(string: text).boundingRect(with: size, options:option, attributes:[NSAttributedStringKey.font:UIFont.systemFont(ofSize:15)], context:nil)
        return estimatedFrame.height
    }
    
   /* class func getTextHeightForShortTextParaSpace(text:String, limit:Int, textWidth:CGFloat, space:CGFloat, fontsize:CGFloat) -> CGFloat {
        
        let maxTextLenth = text.length
        //let minTextLenth = limit
        var shortText = ""
        
        if maxTextLenth > limit {
            shortText = text.substring(to:limit)!
        }else{
            shortText = text
        }
        
        let paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle.lineSpacing = space
        
        let size = CGSize(width: textWidth, height:9999)
        let option = NSStringDrawingOptions.usesFontLeading.union(.usesLineFragmentOrigin)
        let estimatedFrame = NSString(string: shortText).boundingRect(with: size, options:option, attributes:[NSAttributedStringKey.font:UIFont.systemFont(ofSize:fontsize), NSAttributedStringKey.paragraphStyle:paragraphStyle], context:nil)
        
        return estimatedFrame.height
    } */
    
   /* class func getShortTextHeightWithReadMore(text:String, limit:Int, textWidth:CGFloat, space:CGFloat, fontsize:CGFloat) -> CGFloat {
        
        let maxTextLenth = text.length
        var shortText = ""
        
        if maxTextLenth > limit {
            shortText = text.substring(to:limit)! + " " + READ_MORE
        }else{
            shortText = text
        }
        
        let paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle.lineSpacing = space
        
        let size = CGSize(width: textWidth, height:9999)
        let option = NSStringDrawingOptions.usesFontLeading.union(.usesLineFragmentOrigin)
        let estimatedFrame = NSString(string: shortText).boundingRect(with: size, options:option, attributes:[NSAttributedStringKey.font:UIFont.systemFont(ofSize:fontsize), NSAttributedStringKey.paragraphStyle:paragraphStyle], context:nil)
        
        return estimatedFrame.height
    } */
    
    class func getTextHeightWithParaSpace(text:String, textWidth:CGFloat, space:CGFloat, fontsize:CGFloat) -> CGFloat {
        
        let paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle.lineSpacing = space
        
        let size = CGSize(width: textWidth, height: 9999)
        let option = NSStringDrawingOptions.usesFontLeading.union(.usesLineFragmentOrigin)
        let estimatedFrame = NSString(string: text).boundingRect(with: size, options:option, attributes:[NSAttributedStringKey.font:UIFont.systemFont(ofSize:fontsize), NSAttributedStringKey.paragraphStyle:paragraphStyle], context:nil)
        
        return estimatedFrame.height
    }
    
    class func getNumberOfLine(text: String, labelWidth:CGFloat, space:CGFloat) -> Int {
        
        //let paragraphStyle = NSMutableParagraphStyle()
        //paragraphStyle.minimumLineHeight = labelHeight
        //paragraphStyle.maximumLineHeight = labelHeight
        //paragraphStyle.lineBreakMode = .byWordWrapping
        
        let paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle.lineBreakMode = .byWordWrapping
        paragraphStyle.lineSpacing = space
        
        let attributes: [NSAttributedStringKey : Any] = [NSAttributedString.Key(rawValue: NSAttributedStringKey.font.rawValue):UIFont.systemFont(ofSize:15), NSAttributedString.Key(rawValue: NSAttributedStringKey.paragraphStyle.rawValue):paragraphStyle]
        
        //let constrain = CGSize(labelWidth, CGFloat(Float.infinity))
        let constrain = CGSize(width: labelWidth, height: CGFloat(Float.infinity))
        
        let size = text.size(withAttributes: attributes)
        let stringWidth = size.width
        
        let numberOfLines = ceil(Double(stringWidth/constrain.width))
        
        return Int(numberOfLines)
    }
    
    class func getHeightFromImageSize(width:String,height:String,containerWidth:CGFloat) -> CGFloat{
        
        //let imageWidth:String = width
        //let imageHeight:String = imageInfo.img_height
        
        //convert str to CGfloat
        guard let floatWidth = NumberFormatter().number(from: width) else { return 0}
        guard let floatHeight = NumberFormatter().number(from: height) else { return 0}
        
        let flWidth = CGFloat(truncating: floatWidth)
        let flHeight = CGFloat(truncating: floatHeight)
        let aspectRatio = flHeight/flWidth
        
        let aspectHeight = containerWidth * aspectRatio
        print(aspectHeight)
        return aspectHeight
    }
    
    /*
    class func getImageHeight(imageInfo:ImageInfoModel, containerWidth:CGFloat) -> CGFloat{
        
        let imageWidth:String = imageInfo.img_width
        let imageHeight:String = imageInfo.img_height
        
        //convert str to CGfloat
        guard let floatWidth = NumberFormatter().number(from: imageWidth) else { return 0}
        guard let floatHeight = NumberFormatter().number(from: imageHeight) else { return 0}
        
        let flWidth = CGFloat(truncating: floatWidth)
        let flHeight = CGFloat(truncating: floatHeight)
        let aspectRatio = flHeight/flWidth
        
        let aspectHeight = containerWidth * aspectRatio
        print(aspectHeight)
        return aspectHeight
    } */
    
    class func getOnlyImageHeight(image:UIImage, containerWidth:CGFloat) -> CGFloat{
        
        let flWidth = image.size.width
        let flHeight = image.size.height
        let aspectRatio = flHeight/flWidth
        
        let aspectHeight = containerWidth * aspectRatio
        print(aspectHeight)
        return aspectHeight
    }
    
    class func getImageSizeFromUrl(url:URL) -> CGSize {
        
        var imageSize = CGSize.zero
        if let imageSource = CGImageSourceCreateWithURL(url as CFURL, nil) {
            
            if let imageProperties = CGImageSourceCopyPropertiesAtIndex(imageSource, 0, nil) as Dictionary? {
                let pixelWidth = imageProperties[kCGImagePropertyPixelWidth] as! Int
                let pixelHeight = imageProperties[kCGImagePropertyPixelHeight] as! Int
                print("the image width is: \(pixelWidth)")
                print("the image height is: \(pixelHeight)")
                
                imageSize.width = CGFloat(pixelWidth)
                imageSize.height = CGFloat(pixelHeight)
            }
        }
        return imageSize
    }
    
    /*
    class func openLinkInSafariFor(value:String, key:String) {
        
        if key == kContactDict.ProfileLink {
            if let articleLinkUrl = URL(string:value) {
                UIApplication.shared.open(articleLinkUrl, options: [:], completionHandler: nil)
            }
        }
        else if key == kContactDict.Website {
            if let articleLinkUrl = URL(string:value) {
                UIApplication.shared.open(articleLinkUrl, options: [:], completionHandler: nil)
            }
        }
        else if key == kContactDict.Twitter {
            if let articleLinkUrl = URL(string:value) {
                UIApplication.shared.open(articleLinkUrl, options: [:], completionHandler: nil)
            }
        }
    }
    */
    
    class func downloadImageToView(imageView:UIImageView, sourceUrl:URL, imgPlaceHolder:UIImage){
        
        imageView.kf.indicatorType = .activity
        imageView.kf.setImage(with: sourceUrl, placeholder: imgPlaceHolder, options: [.transition(.none), .fromMemoryCacheOrRefresh, .forceRefresh], progressBlock: { (receivedSize, totalSize)  in
            let percentage = (Float(receivedSize) / Float(totalSize)) * 100.0
            print("downloading progress: \(percentage)%")
        }) {result in
        switch result {
        case .success(let value):
            print("Image: \(value.image). Got from: \(value.cacheType)")
            imageView.image = value.image
        case .failure(let error):
            print("Error: \(error)")
        }
        }
  //          { (image, error, cacheType, imageUrl) in
//            imageView.image = image
//        }
    }
    
    class func attribTextWithImage(strText:String, font:UIFont,color:UIColor ,attachedImage:UIImage, position:String) -> NSMutableAttributedString {
        
        let textAttachment = NSTextAttachment()
        let image = attachedImage
        textAttachment.image = image
        let mid = font.descender + font.capHeight
        textAttachment.bounds = CGRect(x: 0, y: font.descender - (image.size.height) / 2 + mid + 2, width: (image.size.width), height: (image.size.height))
        //return textAttachment
        let image1String = NSAttributedString(attachment:textAttachment)
        
        let attribs = [NSAttributedStringKey.font:font, NSAttributedStringKey.foregroundColor :color]
        let myAttrString = NSMutableAttributedString(string: strText, attributes: attribs)
        let myAttrStringSpace = NSMutableAttributedString(string:" ")
        let myAttrStringWithImgPrefix = NSMutableAttributedString(string:"")
        
        if position == "POSTFIX" {
            myAttrString.append(myAttrStringSpace)
            myAttrString.append(image1String)
            return myAttrString
        }
        
        if position == "PREFIX" {
            myAttrStringWithImgPrefix.append(image1String)
            myAttrStringWithImgPrefix.append(myAttrStringSpace)
            myAttrStringWithImgPrefix.append(myAttrString)
            return myAttrStringWithImgPrefix
        }
        
        return myAttrString
        
    }
    
    /*
    class func getPassTimeFrom(date:String) -> String {
        
        var postTime = ""
        let from = date.toDate(dateFormat: "yyyy-MM-dd HH:mm:ss")
        let now = NSDate()
        let components = Set<Calendar.Component>([.second, .minute, .hour, .day, .weekOfMonth])
        let difference = NSCalendar.current.dateComponents(components, from: from, to: now as Date)
        
        if difference.second! <= 0{
            postTime = "now"
        }
        if difference.second! > 0 && difference.minute == 0{
            postTime = String(format: "%ds",difference.second!)
        }
        if difference.minute! > 0 && difference.hour == 0 {
            postTime = String(format: "%dm",difference.minute!)
        }
        if difference.hour! > 0 && difference.day == 0 {
            postTime = String(format: "%dh",difference.hour!)
        }
        if difference.day! > 0 && difference.weekOfMonth == 0 {
            postTime = String(format: "%dd",difference.day!)
        }
        if difference.weekOfMonth! > 0  {
            postTime = String(format: "%dw",difference.weekOfMonth!)
        }
        
        print(postTime)
        return postTime
    }
    */
    
    /*
    class func getCurrentDeviceType() -> String
    {
        var deviceType = ""
        
        if UIDevice().userInterfaceIdiom == .phone {
            switch UIScreen.main.nativeBounds.height {
            case 1136:
                print("iPhone 5 or 5S or 5C")
                deviceType = DecviceType.iPhone5
            case 1334:
                print("iPhone 6/6S/7/8")
                deviceType = DecviceType.iPhone678
            case 1920, 2208:
                print("iPhone 6+/6S+/7+/8+")
                deviceType = DecviceType.iPhone678Plus
            case 2436:
                print("iPhone X, Xs")
                deviceType = DecviceType.iPhoneX_Xs
            case 2688:
                print("iPhone Xs Max")
                deviceType = DecviceType.iPhoneX_Max
            case 1792:
                print("iPhone Xr")
                deviceType = DecviceType.iPhone_XR
            default:
                print("unknown")
            }
        }
        else
        {
            deviceType = DecviceType.iPad
        }
        return deviceType
    }
     */
    
    class func getsafeAreaTopHeight() -> CGFloat {
        
        var topSafeAreaHeight: CGFloat = 0
       
        if #available(iOS 11.0, *) {
            let window = UIApplication.shared.windows[0]
            let safeFrame = window.safeAreaLayoutGuide.layoutFrame
            topSafeAreaHeight = safeFrame.minY
        }else{
            
        }
        return topSafeAreaHeight
    }
    
    class func getsafeAreaBottomHeight() -> CGFloat {
        
        var bottomSafeAreaHeight: CGFloat = 0
        
        if #available(iOS 11.0, *) {
            let window = UIApplication.shared.windows[0]
            let safeFrame = window.safeAreaLayoutGuide.layoutFrame
            bottomSafeAreaHeight = window.frame.maxY - safeFrame.maxY
        }else{
            
        }
        return bottomSafeAreaHeight
    }
    
    class func randomPasswordGenerater(length: Int) -> String{
        let allowedChars = "abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789"
        let allowedCharsCount = UInt32(allowedChars.count)
        var randomString = ""

        for _ in 0 ..< length {
            let randomNum = Int(arc4random_uniform(allowedCharsCount))
            let randomIndex = allowedChars.index(allowedChars.startIndex, offsetBy: randomNum)
            let newCharacter = allowedChars[randomIndex]
            randomString += String(newCharacter)
        }
        
        return randomString
    }
    
    /*
    class func createOptionPopUp(containerVC:UIViewController) -> STPopupController {
        
//        STPopupNavigationBar.appearance().barStyle = UIBarStyle.default
//        STPopupNavigationBar.appearance().barTintColor = AppColor.AppBlue
//        STPopupNavigationBar.appearance().tintColor = UIColor.white
//        STPopupNavigationBar.appearance().titleTextAttributes = [NSAttributedStringKey.font:UIFont.boldSystemFont(ofSize:15), NSAttributedStringKey.foregroundColor:UIColor.white]
        
        let stPopUp = STPopupController(rootViewController: containerVC)
        
        stPopUp.backgroundView?.backgroundColor = UIColor.black.withAlphaComponent(0.4)
        stPopUp.navigationBarHidden = true
        stPopUp.containerView.layer.cornerRadius = 0
        stPopUp.transitionStyle = STPopupTransitionStyle.slideVertical
        stPopUp.style = STPopupStyle.bottomSheet
        
        return stPopUp
    }
    
    
    class func createPopUpWithNavigation( containerVC:UIViewController) -> STPopupController {
        
        STPopupNavigationBar.appearance().barStyle = UIBarStyle.default
        STPopupNavigationBar.appearance().barTintColor = AppColor.AppBlue
        STPopupNavigationBar.appearance().tintColor = UIColor.white
        STPopupNavigationBar.appearance().titleTextAttributes = [NSAttributedStringKey.font:UIFont.boldSystemFont(ofSize:15), NSAttributedStringKey.foregroundColor:UIColor.white]
        
        let stPopUp = STPopupController(rootViewController: containerVC)
        
        stPopUp.backgroundView?.backgroundColor = UIColor.black.withAlphaComponent(0.4)
        stPopUp.containerView.layer.cornerRadius = 0
        stPopUp.transitionStyle = STPopupTransitionStyle.slideVertical
        stPopUp.style = STPopupStyle.bottomSheet
        return stPopUp
    } */
    
    /*
    class func createNavigationTitleViewWithImage(titleImage:UIImage) -> UIView
    {
        let titleLogoImgView = UIImageView(frame:CGRect(x:0, y:0, width:130, height:40))
        titleLogoImgView.image = titleImage //UIImage(named: "afritia_logo")
        
        let navTitleView = UIView(frame: CGRect(x: 0, y: 0, width:SCREEN_WIDTH - 45, height: titleLogoImgView.frame.height))
        //navTitleView.backgroundColor = UIColor.red
        navTitleView.addSubview(titleLogoImgView)
        return navTitleView
    }*/
    
    class  func createNavigationTitleViewWithText(titleText:String, isShowLogo:Bool) -> UIView {
        
        let labelBgView = UIView(frame: CGRect(x:0, y: 0, width:SCREEN_WIDTH, height:30))
        labelBgView.backgroundColor = UIColor.clear
        let label = UILabel(frame: CGRect(x:0, y: 0, width:labelBgView.frame.width-20, height: 30))
        
        if isShowLogo {
            
            let logoImage = UIImage(named:"afritia_icon")!
            let resizedLogoImage = logoImage.resizeImageWith(newSize:CGSize(width:22, height: 22), isOpaque:true) //.tintedWithColor(color:UIColor.white)
            let font = UIFont(name: REGULARFONT, size: 22)!
            let color = UIColor.white
            
            let textAttachment = NSTextAttachment()
            //let image = attachedImage
            textAttachment.image = resizedLogoImage
            //let mid = font.descender + font.capHeight
            textAttachment.bounds = CGRect(x: 0, y:-3, width: (logoImage.size.width), height: (logoImage.size.height))
            //return textAttachment
            let image1String = NSAttributedString(attachment:textAttachment)
            
            let attribs = [NSAttributedStringKey.font:font, NSAttributedStringKey.foregroundColor :color]
            let myAttrString = NSMutableAttributedString(string: titleText, attributes: attribs)
            let myAttrStringSpace = NSMutableAttributedString(string:" ")
            let myAttrStringWithImgPrefix = NSMutableAttributedString(string:"")
            
            myAttrStringWithImgPrefix.append(image1String)
            myAttrStringWithImgPrefix.append(myAttrStringSpace)
            myAttrStringWithImgPrefix.append(myAttrString)
            
            label.attributedText = myAttrStringWithImgPrefix
            labelBgView.addSubview(label)
            
            //return myAttrStringWithImgPrefix
        }
        else {
            
            let attribs = [NSAttributedStringKey.font:UIFont(name: "OpenSans-Semibold", size: 22)!, NSAttributedStringKey.foregroundColor :UIColor.white]
            let attribTitle = NSMutableAttributedString(string:titleText, attributes: attribs)
            //Arial Rounded MT Bold
            label.attributedText = attribTitle
            labelBgView.addSubview(label)
        }
        
//        let navTitle = self.attribTextWithImage(strText:titleText, font:UIFont(name: "OpenSans-Semibold",size: 22)!, color:AppColor.White, attachedImage:logoImage, position:"PREFIX")

        return labelBgView
    }
    
    class func fetchContacts() {
        print("attempring to fetch contact...")
        
        let store = CNContactStore()
        store.requestAccess(for: .contacts) { (granted, err) in
            if let err = err {
                print ("Failed to request access", err)
                return
            }
            
            if granted {
                print("Access granted$$$$$")
                
                let keys = [CNContactGivenNameKey, CNContactFamilyNameKey, CNContactPhoneNumbersKey, CNContactEmailAddressesKey]
                let request = CNContactFetchRequest(keysToFetch: keys as [CNKeyDescriptor])
                
                do {
                    
                    try store.enumerateContacts(with: request, usingBlock: { (contact, stopPointToStopEnumerating) in
                        print(contact.givenName," ",contact.familyName)
                        print(contact.phoneNumbers.first?.value.stringValue ?? "")
                        print(contact.emailAddresses.first?.value ?? "")
                        print("-----------------------------------------")
                    })
                    
                }catch let err {
                    print("Failed to enumerate contact", err)
                }
                
            }else{
                print("Access deniedXXXXXX")
            }
        }
    }
    
    class func getConnectionPowerImage(status:String) -> UIImage {
        
        if status == "Fair" {
            return UIImage(named:"cp_fair")!
        }else if status == "Potential" {
            return UIImage(named:"cp_potential")!
        }else if status == "Good"{
            return UIImage(named:"cp_verygood")!
        }else if status == "Very Good"{
            return UIImage(named:"cp_verygood")!
        }else if status == "Exceptional"{
            return UIImage(named:"cp_verygood")!
        }
        return UIImage(named:"cp_potential")!
    }
    
    class func convertDoubleToCurrency(amount: Double) -> String{
        let numberFormatter = NumberFormatter()
        numberFormatter.numberStyle = .currency
        numberFormatter.locale = Locale.current
        return numberFormatter.string(from: NSNumber(value: amount))!
    }
    
    class func convertCurrencyToDouble(input: String) -> Double? {
        let numberFormatter = NumberFormatter()
        numberFormatter.numberStyle = .currency
        numberFormatter.locale = Locale.current
        return numberFormatter.number(from: input)?.doubleValue
    }
    
    class func applyBlurEffect(image:UIImage, blurAmount:CGFloat) -> UIImage?{
        
        guard let ciImage = CIImage(image: image) else {
            return nil
        }
        
        let blurFilter = CIFilter(name: "CIGaussianBlur")
        blurFilter?.setValue(ciImage, forKey: kCIInputImageKey)
        blurFilter?.setValue(ciImage, forKey: kCIInputRadiusKey)
        
        guard let outPutImage  = blurFilter?.outputImage else {
            return nil
        }
        
        let result = UIImage(ciImage:outPutImage)
        
        return result
    }
}
