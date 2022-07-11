//
//  Utility.swift
//

import Foundation
import UIKit

//import MMDrawerController

class Utility: NSObject {
    
    class func log<T>(argument: T, file: String = #file, line: Int = #line, function: String = #function) {
        
        //        guard _isDebugAssertConfiguration() else {
        //            return
        //        }
        
        #if DEBUG
            let fileName = NSURL(fileURLWithPath: file, isDirectory: false).deletingPathExtension?.lastPathComponent ?? "Unknown"
            
            print("\(fileName) || Line #\(line) || \(function):: \(argument)")
        #endif
        
    }
    
    class func createDropDownBtn() -> UIButton {
        let btn: UIButton = UIButton(type: UIButtonType.custom) as UIButton
        btn.frame = CGRect(x:0, y: 0, width:30 , height:42)
        btn.backgroundColor = UIColor.clear
        btn.setImage(UIImage(named:"dropdown"), for:.normal)
        return btn
    }
    
    /*
     
     //        print("https://github.com/Reza-Rg/Base64-Swift-Extension/blob/master/Base64.swift".base64Encoded ?? "Not Found")
     print(AppConstant.ServerURL.live)
     print(AppConstant.FontSize.regular)
     //        print(AppConfiguration.API_URL().live)
     //        print(AppConfiguration.API_URL().development)
     //        print(UIFont.familyNames) //family name listing.
     
     
     */
    
    fileprivate func readPropertyList() -> [String: Any] {
        var propertyListForamt =  PropertyListSerialization.PropertyListFormat.xml //Format of the Property List.
        var plistData: [String: Any] = [String: Any]() //Our data
        let plistPath: String? = Bundle.main.path(forResource: "AppConfig", ofType: "plist")! //the path of the data
        let plistXML = FileManager.default.contents(atPath: plistPath!)!
        do {//convert the data to a dictionary and handle errors.
            plistData = try PropertyListSerialization.propertyList(from: plistXML, options: .mutableContainersAndLeaves, format: &propertyListForamt) as! [String: Any]
        } catch {
            print("Error reading plist: \(error), format: \(propertyListForamt)")
        }
        
        return plistData
    }
    
    
    
    /// This method will used to add Parallax effect to the view based on device rotation.
    ///
    /// - Parameter view: Object of a view on which you want to add Parallax effect
    class func addParallaxTo(view: UIView) {
        
        let amount = 12
        
        let horizontal = UIInterpolatingMotionEffect(keyPath: "center.x", type: .tiltAlongHorizontalAxis)
        horizontal.minimumRelativeValue = amount
        horizontal.maximumRelativeValue = -amount
        
        let vertical = UIInterpolatingMotionEffect(keyPath: "center.y", type: .tiltAlongVerticalAxis)
        vertical.minimumRelativeValue = amount
        vertical.maximumRelativeValue = -amount
        
        let group = UIMotionEffectGroup()
        group.motionEffects = [horizontal, vertical]
        view.addMotionEffect(group)
        
    }
    
    
    /// This method will count charactors for TextView
    ///
    /// - Parameters:
    ///   - textView: Object of UITextView
    ///   - string: replacement String
    /// - Returns: Returns a Number of characters count
    class func getCharactersCount(textView: UITextView, string: String) -> Int {
        
        var textFieldCharactersCount = 0
        
        if let textFieldText = textView.text {
            
            textFieldCharactersCount = textFieldText.characters.count + string.characters.count
            
            if string.isEmpty {
                textFieldCharactersCount = textFieldCharactersCount - 1
            }
        }
        
        return textFieldCharactersCount
    }
    
    
    /// This method will open a link in a Safari Browser
    ///
    /// - Parameter strURL: String of URL which you wanted to open in Safari
    class func openLinkInSafari(_ strURL: String) -> Void {
        let url: URL = URL(string: strURL)!
        UIApplication.shared.open(url, options: [:], completionHandler: nil)
    }
    
    
    /// This method will used to show native share dialoge for sharing a Link
    ///
    /// - Parameters:
    ///   - controller: Object of controller from which you want to display Share dialoge
    ///   - strLink: String of Link which you want to share
    class func showShareDialogeForLink(_ controller: UIViewController, stringLink strLink: String) -> Void {
        
//        print("Share Link : \(strLink)")
        let myWebsite = URL(string: strLink)!
        let shareItems: Array = [myWebsite]
        
        let activityViewController = UIActivityViewController(activityItems: shareItems, applicationActivities: nil)
        
        // exclude some activity types from the list (optional)
        activityViewController.excludedActivityTypes = [.print, .addToReadingList, .postToVimeo, .airDrop, .openInIBooks, .assignToContact, .saveToCameraRoll]
        
        // present the view controller
        controller.present(activityViewController, animated: true, completion: nil)
        
        
    }
    
    
    
    
    /// This method will create an Attributed HTML String which will be used to display inside a label or textView as a Attributed String
    ///
    /// - Parameter string: HTML String
    /// - Returns: NSAttributedString of a HTML
    class func createAttributeHTMLString(_ string: String) -> NSAttributedString? {
        do {
            let data = string.data(using: String.Encoding.utf8, allowLossyConversion: true)
            if let d = data {
                let str = try NSAttributedString(data: data!, options: [NSAttributedString.DocumentReadingOptionKey.documentType:  NSAttributedString.DocumentType.html], documentAttributes: nil)
                return str
            }
        } catch {
        }
        return nil
    }
    
    
    /// This method will set side Drawer controller for Home screen
//    class func setSideDrawer() {
//
//        let aObjCenter : NavigationController = kStoryboard.home.instantiateViewController(withIdentifier: "HomeNavigationController") as! NavigationController
//        let aObjLeft : UINavigationController = kStoryboard.home.instantiateViewController(withIdentifier: "SideNavigationControl") as! UINavigationController
//
//        let mmDrawer: MMDrawerController = MMDrawerController(center: aObjCenter, leftDrawerViewController: aObjLeft, rightDrawerViewController:nil)
//        mmDrawer.openDrawerGestureModeMask = .panningNavigationBar
//        mmDrawer.closeDrawerGestureModeMask = .all
//        mmDrawer.centerHiddenInteractionMode = .none
//        mmDrawer.setMaximumLeftDrawerWidth(min(512, (ScreenSize.SCREEN_WIDTH - 60)), animated: true, completion: nil)
//        mmDrawer.showsShadow = true
//        mmDrawer.shadowOffset = CGSize(width: -2, height: 0)
//        mmDrawer.shadowOpacity = 0.5
//        mmDrawer.shadowRadius = 6.0
//        mmDrawer.shadowColor = UIColor.graySubTitle
//        mmDrawer.shouldStretchDrawer = false
//        mmDrawer.restorationIdentifier = "MMDrawer"
//        mmDrawer.setDrawerVisualStateBlock(MMDrawerVisualState.parallaxVisualStateBlock(withParallaxFactor: 5.0))
//
//        APP_DELEGATE.mmDrawer = mmDrawer
//
//    }
    
    
    /// This function will return a Object of Center Navigation Controller which is set for Side menu
    ///
    /// - Returns: Object of Navigation Controller
//    class func getCenterNavigationController() -> UINavigationController {
//        let aNavController: NavigationController = APP_DELEGATE.mmDrawer?.centerViewController! as! NavigationController
//        return aNavController
//    }
//    
//    
//    /// This function will return a Object of Home View Controller
//    ///
//    /// - Returns: Object of Home View Controller
//    class func getHomeVC() -> HomeVC {
//        let aNavController: NavigationController = APP_DELEGATE.mmDrawer?.centerViewController! as! NavigationController
//        let aObjVC: HomeVC = aNavController.viewControllers.first as! HomeVC
//        return aObjVC
//    }
//    
//    
//    /// This function will return a Object of Side Menu Controller
//    ///
//    /// - Returns: Object of Side Menu Controller
//    class func getSideVC() -> SideVC {
//        let aNavController: UINavigationController = APP_DELEGATE.mmDrawer?.leftDrawerViewController! as! UINavigationController
//        let aObjVC: SideVC = aNavController.viewControllers.first as! SideVC
//        return aObjVC
//    }
//    
    
    /// This method will use to convert Rating received from the server to use in the application converted into 5. We'll be receiving rating in form of 100 and this method will convert that rating out of 5.
    ///
    /// - Parameter string: String rating received from the server
    /// - Returns: String Rating converted in ratio of 5
    class func getRating(_ string: String) -> String {
        let aRatingValue = (Double(string)! * 5) / 100
        let aFloatingPoint = 10.0
        let aCalculatedRating = Double(round(aFloatingPoint * aRatingValue) / aFloatingPoint)
        let strRating = String(format: "%.1f", aCalculatedRating)
        return strRating
    }
    
    
    /// This method will convert a pass Date into a specifed formatted String date
    ///
    /// - Parameters:
    ///   - date: Object of Date
    ///   - dateFormat: Format in which you want to display date
    /// - Returns: Formatted String of Date
    class func getStringFromDate(_ date : Date , dateFormat : String) -> String {
        
        let dateFormatter  = DateFormatter()
        dateFormatter.dateFormat = dateFormat
        dateFormatter.timeZone = TimeZone(identifier: "UTC")
        dateFormatter.locale = Locale(identifier: "en_US_POSIX") as Locale!
        return dateFormatter.string(from: date)
    }
    
    
    /// This method will convert a String into a Date
    ///
    /// - Parameters:
    ///   - date: String Format of Date
    ///   - dateFormat: Format of String Date
    /// - Returns: Object of Date
    class func getDateFromString(_ date : String , dateFormat : String) -> Date {
        
        let dateFormatter  = DateFormatter()
        dateFormatter.dateFormat = dateFormat
        dateFormatter.timeZone = TimeZone(identifier: "UTC")
        dateFormatter.locale = Locale(identifier: "en_US_POSIX") as Locale!
        return (dateFormatter.date(from: date)! as NSDate) as Date
    }
    
    /// This method will return a Color which will be used to display as a Background color for given rating
    ///
    /// - Parameter rating: Value of Rating
    /// - Returns: Color which will be used to set in background for rating
    class func getColorForBasedOnRating(rating: Double) -> UIColor {
        if rating == 0.0 {
            return UIColor.gray
        } else if rating >= 0.1 && rating <= 2.9 {
            return UIColor.red
        } else if rating >= 3.0 && rating <= 3.9 {
            return UIColor.orange
        } else {
            return UIColor.green
        }
    }
}

