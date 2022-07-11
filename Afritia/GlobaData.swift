//
//  GlobaData.swift
//  MVVMSwift
//
//  Created by Webkul  on 17/06/17.
//  Copyright © 2017 Webkul. All rights reserved.
//

import Foundation
import Alamofire
import UIKit

import UserNotifications

let DEFAULTS = UserDefaults.standard
typealias ServiceResponse = (NSDictionary?, NSError?) -> Void
var queue = OperationQueue()
var profileImageCache = NSCache<AnyObject, AnyObject>()
let progress = GradientCircularProgress()

public struct MyStyle : StyleProperty {
    /*** style properties **********************************************************************************/
    
    // Progress Size
    public var progressSize: CGFloat = 200
    
    // Gradient Circular
    public var arcLineWidth: CGFloat = 18.0
    public var startArcColor: UIColor = UIColor.clear
    public var endArcColor: UIColor = UIColor.orange
    
    // Base Circular
    public var baseLineWidth: CGFloat? = 19.0
    public var baseArcColor: UIColor? = UIColor.darkGray
    
    // Ratio
    public var ratioLabelFont: UIFont? = UIFont(name: "Verdana-Bold", size: 16.0)
    public var ratioLabelFontColor: UIColor? = UIColor.white
    
    // Message
    public var messageLabelFont: UIFont? = UIFont.systemFont(ofSize: 16.0)
    public var messageLabelFontColor: UIColor? = UIColor.white
    
    // Background
    public var backgroundStyle: BackgroundStyles = .dark
    
    // Dismiss
    public var dismissTimeInterval: Double? = 0.0 // 'nil' for default setting.
    
    /*** style properties **********************************************************************************/
    
    public init() {}
}

struct GlobalVariables {
    static var proceedToCheckOut:Bool = false
    static var hometableView:UITableView!
    static var ExecuteShippingAddress:Bool = false
    static var  CurrentIndex:Int = 1
    static var shippingAndBillingViewModel:BillingAndShipingViewModel!
    static var showFeature:Bool = true
    static var  selectedCategoryIds:NSMutableArray = []
    static var  selectedRelatedProductIds:NSMutableArray = []
    static var  selectedUPSellProductIds:NSMutableArray = []
    static var  selectedCrossSellProductIds:NSMutableArray = []
    
}

class GlobalData: NSObject{
    
    public var languageBundle:Bundle!
    
    class var sharedInstance:GlobalData {
        struct Singleton {
            static let instance = GlobalData()
        }
        return Singleton.instance
    }
    
    public var cartItemsCount:Int = 0
    
    func language(key:String) ->String{
        let languageCode = UserDefaults.standard
        if languageCode.object(forKey: "language") != nil {
            let language = languageCode.object(forKey: "language")
            if let path = Bundle.main.path(forResource: language as! String?, ofType: "lproj") {
                languageBundle = Bundle(path: path)
            }
            else{
                languageBundle = Bundle(path: Bundle.main.path(forResource: "en", ofType: "lproj")!)
            }
        }else {
            languageCode.set("en", forKey: "language")
            languageCode.synchronize()
            let language = languageCode.string(forKey: "language")!
            var path = Bundle.main.path(forResource: language, ofType: "lproj")!
            if path .isEmpty {
                path = Bundle.main.path(forResource: "en", ofType: "lproj")!
            }
            languageBundle = Bundle(path: path)
        }
        
        return languageBundle.localizedString(forKey: key, value: "", table: nil)
    }
    
    /*
    func getRespectiveName(statusCode:Int?) -> String{
        var message:String = ""
        if statusCode == 404{
            message = "servererror".localized
        }else if statusCode == 500{
            message = "servernotfound".localized
        }else{
            message = "somethingwentwrongpleasetryagain".localized
        }
        return message
    }
     */
    
    func getImageFromUrl(imageUrl:String,imageView:UIImageView){
        
        let urlString = imageUrl.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)
        let image  = profileImageCache.object(forKey: urlString as AnyObject)
        if image != nil{
            imageView.image = image as? UIImage
        }else{
            if  URL(string:urlString!) != nil{
                DispatchQueue.global(qos: .background).async {
                    let operation = BlockOperation(block: {
                        let url =  URL(string:urlString!)
                        let data = try? Data(contentsOf: url!)
                        if data != nil{
                            if let img = UIImage(data: data!){
                                OperationQueue.main.addOperation({
                                    imageView.image = img
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
    
    func getImageFromUrlWithActivity(imageUrl:String,imageView:UIImageView, activity:UIActivityIndicatorView){
        let urlString = imageUrl.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)
        let image  = profileImageCache.object(forKey: urlString as AnyObject)
        if image != nil{
            imageView.image = image as? UIImage
            DispatchQueue.main.async {
                activity.stopAnimating()
            }
        }
        else{
            if  URL(string:urlString!) != nil{
                DispatchQueue.global(qos: .background).async {
                    let operation = BlockOperation(block: {
                        let url =  URL(string:urlString!)
                        let data = try? Data(contentsOf: url!)
                        if data != nil{
                            if let img = UIImage(data: data!){
                                OperationQueue.main.addOperation({
                                    imageView.image = img
                                    DispatchQueue.main.async {
                                        activity.stopAnimating()
                                    }
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
    
    func remainderNotificationCall(){
        if #available(iOS 10.0, *) {
            let content = UNMutableNotificationContent()
            let requestIdentifier = "appuse" // for multiple notification
            content.badge = 1
            content.title = "pleasevisitourstore".localized
            content.subtitle =  "somenewproduct".localized
            content.body = "checkitwonce".localized
            content.categoryIdentifier = "appuse"
            content.sound = UNNotificationSound.default()
            
            // If you want to attach any image to show in local notification
            let url = Bundle.main.url(forResource: "appicon", withExtension: ".png")
            do {
                let attachment = try? UNNotificationAttachment(identifier: requestIdentifier, url: url!, options: nil)
                content.attachments = [attachment!]
            }
            
            let trigger = UNTimeIntervalNotificationTrigger.init(timeInterval:172800, repeats: false)
            
            let request = UNNotificationRequest(identifier: requestIdentifier, content: content, trigger: trigger)
            UNUserNotificationCenter.current().add(request) { (error:Error?) in
                
                if error != nil {
                    print(error?.localizedDescription)
                }
            }
        }
    }
    
    func getAppIcon() -> UIImage {
        let iconsDictionary = Bundle.main.infoDictionary?["CFBundleIcons"] as? NSDictionary
        let primaryIconsDictionary = iconsDictionary?["CFBundlePrimaryIcon"] as? NSDictionary
        let iconFiles = primaryIconsDictionary!["CFBundleIconFiles"] as! NSArray
        // First will be smallest for the device class, last will be the largest for device class
        let lastIcon = iconFiles.lastObject as! NSString
        let icon = UIImage(named: lastIcon as String)
        
        return icon!
    }
    
    /*
    func removePreviousNetworkCall(){
        print("dismisstheconnection")
        let sessionManager = Alamofire.SessionManager.default
        sessionManager.session.getTasksWithCompletionHandler { dataTasks, uploadTasks, downloadTasks in
            dataTasks.forEach { $0.cancel() }
            uploadTasks.forEach { $0.cancel() }
            downloadTasks.forEach { $0.cancel() }
        }
    }
    */
    
    func showSuccessMessageWithBack(view:UIViewController,message:String){
        let AC = UIAlertController(title: GlobalData.sharedInstance.language(key: "success"), message: message, preferredStyle: .alert)
        let okBtn = UIAlertAction(title: GlobalData.sharedInstance.language(key: "ok"), style: .default, handler: {(_ action: UIAlertAction) -> Void in
            view.navigationController?.popViewController(animated: true)
        })
        
        AC.addAction(okBtn)
        view.present(AC, animated: true, completion: {  })
    }
    
    func checkValidEmail(data:String) -> Bool{
        let emailRegex = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,4}"
        let emailTest = NSPredicate(format: "SELF MATCHES %@", emailRegex)
        return (emailTest.evaluate(with: data))
    }
    
    func showLoader(){
        progress.show(message: "Loading...", style: BlueIndicatorStyle())
    }
    
    func dismissLoader(){
        progress.dismiss()
    }
    
    enum VersionError: Error {
        case invalidResponse, invalidBundleInfo
    }
    
    func isUpdateAvailable() throws -> Bool {
        guard let info = Bundle.main.infoDictionary,
            let currentVersion = info["CFBundleShortVersionString"] as? String,
            let identifier = info["CFBundleIdentifier"] as? String,
            
            let url = URL(string: "http://itunes.apple.com/lookup?bundleId=\(identifier)") else {
                throw VersionError.invalidBundleInfo
        }
        let data = try Data(contentsOf: url)
        guard let json = try JSONSerialization.jsonObject(with: data, options: [.allowFragments]) as? [String: Any] else {
            throw VersionError.invalidResponse
        }
        if let result = (json["results"] as? [Any])?.first as? [String: Any], let version = result["version"] as? String {
            print("version in app store", version,currentVersion)
            
            return version != currentVersion
        }
        throw VersionError.invalidResponse
    }
    
    func getAppStoreVersion() throws ->String{
        guard let info = Bundle.main.infoDictionary,
            let currentVersion = info["CFBundleShortVersionString"] as? String,
            let identifier = info["CFBundleIdentifier"] as? String,
            let url = URL(string: "http://itunes.apple.com/lookup?bundleId=\(identifier)") else {
                throw VersionError.invalidBundleInfo
        }
        let data = try Data(contentsOf: url)
        guard let json = try JSONSerialization.jsonObject(with: data, options: [.allowFragments]) as? [String: Any] else {
            throw VersionError.invalidResponse
        }
        if let result = (json["results"] as? [Any])?.first as? [String: Any], let version = result["version"] as? String {
            print("version in app store", version,currentVersion,result)
            
            return version
        }
        throw VersionError.invalidResponse
    }
    
    func getAppStoreVersionMessge()throws ->String{
        guard let info = Bundle.main.infoDictionary,
            let currentVersion = info["CFBundleShortVersionString"] as? String,
            let identifier = info["CFBundleIdentifier"] as? String,
            let url = URL(string: "http://itunes.apple.com/lookup?bundleId=\(identifier)") else {
                throw VersionError.invalidBundleInfo
        }
        let data = try Data(contentsOf: url)
        guard let json = try JSONSerialization.jsonObject(with: data, options: [.allowFragments]) as? [String: Any] else {
            throw VersionError.invalidResponse
        }
        if let result = (json["results"] as? [Any])?.first as? [String: Any], let version = result["releaseNotes"] as? String {
            print("version in app store", version,currentVersion)
            
            return version
        }
        throw VersionError.invalidResponse
    }
    
    func getMimeType(type:String)-> String{
        switch type {
        case "txt":
            return "text/plain"
        case "htm":
            return "text/html"
        case "html":
            return "text/html"
        case "php":
            return "text/html"
        case "css":
            return "text/css"
        case "js":
            return "application/javascript"
        case "json":
            return "application/json"
        case "xml":
            return "application/xml"
        case "swf":
            return "application/x-shockwave-flash"
        case "flv":
            return "video/x-flv"
        case "png":
            return "image/png"
        case "jpe":
            return "image/jpeg"
        case "jpeg":
            return "image/jpeg"
        case "gif":
            return "image/gif"
        case "bmp":
            return "image/bmp"
        case "ico":
            return "image/vnd.microsoft.icon"
        case "tiff":
            return "image/tiff"
        case "tif":
            return "image/tiff"
        case "svg":
            return "image/svg+xml"
        case "svgz":
            return "image/svg+xml"
        case "zip":
            return "application/zip"
        case "rar":
            return "application/x-rar-compressed"
        case "exe":
            return "application/x-msdownload"
        case "msi":
            return "application/x-msdownload"
        case "mp3":
            return "audio/mpeg"
        case "qt":
            return "video/quicktime"
        case "mov":
            return "video/quicktime"
        case "pdf":
            return "application/pdf"
        case "psd":
            return "image/vnd.adobe.photoshop"
        case "ai":
            return "application/postscript"
        case "eps":
            return "application/postscript"
        case "ps":
            return "application/postscript"
        case "doc":
            return "application/msword"
        case "rtf":
            return "application/rtf"
        case "xls":
            return "application/vnd.ms-excel"
        case "ppt":
            return "application/vnd.ms-powerpoint"
        case "odt":
            return "application/vnd.oasis.opendocument.text"
        case "ods":
            return "application/vnd.oasis.opendocument.spreadsheet"
            
        default:
            return ""
        }
    }
    
    //catalog product page
    func priceFormatter(_ price: Double, decimalSymbol symbolDecimal: String, grouplength groupLengthValue: String, groupsymbol groupSymbol: String, pattern patternValue: String, precision precisionValue: String) -> String {
        let stringFormatPrice = String(format: "%.6f", price)
        let newString: String = stringFormatPrice.replacingOccurrences(of: ".", with: symbolDecimal)
        var formatted: String = ""
        var precesion: Int = 0
        let range: NSRange = (newString as NSString).range(of: ".")
        if range.location != NSNotFound {
            precesion = Int(precisionValue)!
            formatted = (newString as NSString).substring(with: NSRange(location: 0, length: range.location + precesion + 1))
        }
        let leftValue: Int = (formatted.characters.count) - precesion - 1
        if leftValue > Int(groupLengthValue)! {
            var reversedString = String()
            var charIndex: Int = (formatted.characters.count )
            while charIndex > 0 {
                charIndex -= 1
                let subStrRange = NSRange(location: charIndex, length: 1)
                reversedString += (formatted as NSString).substring(with:subStrRange)
            }
            //NSLog(@"  %@",reversedString)
            let range1: NSRange = (reversedString as NSString).range(of: symbolDecimal)
            var length: Int = (reversedString.characters.count )
            let groupLength: Int = Int(groupLengthValue)!
            var firstreplace: Int = groupLength + range1.location + 1
            
            let muTable: NSMutableString = NSMutableString(string: reversedString)
            while firstreplace < length {
                if firstreplace < length {
                    muTable.insert(groupSymbol, at: firstreplace)
                    firstreplace += groupLength + 1
                    length += 1
                }
            }
            var reversedString1 = String()
            var charIndex1: Int = (muTable.length)
            while charIndex1 > 0 {
                charIndex1 -= 1
                let subStrRange = NSRange(location: charIndex1, length: 1)
                reversedString1 += (muTable as NSString).substring(with: subStrRange)
            }
            let pattern: String = patternValue
            let formatter: String = pattern.replacingOccurrences(of: "s", with: "@")
            let formattedPrice = String(format: formatter, reversedString1)
            
            return formattedPrice
        }else{
            let pattern: String = patternValue
            let formatter: String = pattern.replacingOccurrences(of: "s", with: "@")
            let formattedPrice = String(format: formatter, formatted)
            //NSLog(@"result %@",formattedPrice)
            return formattedPrice
        }
    }
}

enum CatalogProductAPI : String {
    case addToCart
    case addToWishlist
    case addToCompare
    case catalogProduct
    case removeFromWishList
}
