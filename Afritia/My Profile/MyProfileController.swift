//
//  MyProfileController.swift
//  Magento2V4Theme
//
//  Created by kunal on 10/02/18.
//  Copyright © 2018 kunal. All rights reserved.
//

import UIKit
import Alamofire
import SwiftMessages
import CropViewController
import DropDown



protocol LanguageSelectionDelegate {
    
   
    // Comunicate delegates that a country has been selected
    //
    //   - Parameters:
    //   - settingsViewController: settingsViewController
    //   - language: selected language
    func settingsViewController(_ MyProfileController: MyProfileController, didSelectLanguage language: Language)
   
}



struct MyProfileData {
    var title:String!
    var image:UIImage!
    
    init(title:String, image:UIImage) {
        self.title = title
        self.image = image
    }
}




struct AppType {
    
    static let Instagram = "AppInstagram"
    static let Facebook = "AppFacebook"
    static let Twitter = "AppTwitter"
    static let Pinterest = "AppPinterest"
    static let LinkedIn = "AppLinked"
    static let Youtube = "Youtube"
}

struct AfritiaAppSchemeUrl {
    
    static let Instagram = "instagram://user?username=Afritia"
    static let Facebook = "fb://profile/Afritia"
    static let Twitter = "twitter://user?screen_name=Afritia"
    static let Piterest = "pinterest://user/Afritia"
    static let LinkedIn = "linkedin://profile?id=Afritia"
    static let Youtube = ""
}

struct AfritiaWebUrl {
    
    static let Instagram = URL(string:"https://www.instagram.com/afritiallc/")
    static let Facebook = URL(string:"https://www.facebook.com/Afritia-116437070117773")
    static let Twitter = URL(string:"https://twitter.com/AfritiaGlobal")
    static let LinkedIn = URL(string:"https://www.linkedin.com/company/afritia/")
    static let Pinterest = URL(string:"https://www.pinterest.com/b5a1dfb5ee12df239a48b8a2d20480/")
    static let Youtube = URL(string:"https://www.youtube.com/channel/UCVJ92xUKhAO3Q6Qsrq80XzQ")
}

class MyProfileController: UIViewController,UIImagePickerControllerDelegate,UINavigationControllerDelegate, CropViewControllerDelegate {
    
    @IBOutlet weak var myProfileTableView: UITableView!
    
    var profileHeaderView:NSMutableArray = [""]
    var singUpButtonView:NSMutableArray = [""]
    let dropDown = DropDown()
    let languages = LanguagesChange.languages
    var delegate : LanguageSelectionDelegate?
    /* // add this if client said to show it in befor login data
     MyProfileData(title: "notification".localized, image: UIImage(named: "ic_notificationprofile")!),
     MyProfileData(title: "searchterms".localized, image: UIImage(named: "ic_notificationprofile")!),
     MyProfileData(title: "advancesearchterms".localized, image: UIImage(named: "ic_notificationprofile")!),
     MyProfileData(title: "comparelist".localized, image: UIImage(named: "ic_notificationprofile")!),
     
     */
    
    //User-Customer
    var userDataBeforLogin:NSMutableArray = [
        MyProfileData(title: "Contact Us".localized, image: UIImage(named: "contact")!),
        MyProfileData(title: "Change App Language".localized, image: UIImage(named: "language")!)
    ]
    
    var userDataAfterLogin:NSMutableArray = [
        MyProfileData(title: "notification".localized, image: UIImage(named: "notification")!),
        MyProfileData(title: "Social Center", image: UIImage(named: "social_chat")!),
        MyProfileData(title: "myorder".localized, image: UIImage(named: "my-order")!),
        MyProfileData(title: "mywishlist".localized, image: UIImage(named: "mywishlist")!),
        MyProfileData(title: "myproductreviews".localized, image: UIImage(named: "product-review")!),
        MyProfileData(title: "accountinformation".localized, image: UIImage(named: "account-information")!),
        MyProfileData(title: "addressbook".localized, image: UIImage(named: "address-book")!),
        MyProfileData(title: "searchterms".localized, image: UIImage(named: "search-term")!),
        MyProfileData(title: "advancesearchterms".localized, image: UIImage(named: "advance-search")!),
        MyProfileData(title: "comparelist".localized, image: UIImage(named: "compare-product")!),
        MyProfileData(title: "Contact Us".localized, image: UIImage(named: "contact")!),
        MyProfileData(title: "Change App Language".localized, image: UIImage(named: "language")!),
        MyProfileData(title: "Download Merchant App".localized, image: UIImage(named: "app-store")!)]
    
    //Seller
    var approvedSellerDataAsAdmin:NSMutableArray = []
    
    var approvedSellerDataAsNonAdmin:NSMutableArray = []
    
    var nonApprovedSellerDataAsNonAdmin:NSMutableArray = []
    

    var logoutData:NSMutableArray = [MyProfileData(title: "logout".localized, image: UIImage(named: "logout")!)]
    
    //var cmsData:NSMutableArray = []
    var profileCMSData:NSMutableArray = []
    var profileData:NSMutableArray = []
    var showUserProfile:Bool = false
    var homeViewModel : HomeViewModel!
    var imageForCategoryMenu:String = ""
    var imageData:NSData!
    var uploadImage:String = ""
    var cmsID:String = ""
    var cmsName:String = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
//        self.navigationController?.navigationBar.applyAfritiaTheme()
//        self.title = "My Profile"
        
        myProfileTableView.register(UINib(nibName: "ProfileTableViewCell", bundle: nil), forCellReuseIdentifier: "ProfileTableViewCell")
        myProfileTableView.register(UINib(nibName: "ProfileCell", bundle: nil), forCellReuseIdentifier: "ProfileCell")
        myProfileTableView.register(UINib(nibName: "LoginButtonTableViewCell", bundle: nil), forCellReuseIdentifier: "LoginButtonTableViewCell")
        
        myProfileTableView.rowHeight = UITableViewAutomaticDimension
        self.myProfileTableView.estimatedRowHeight = 50
        self.myProfileTableView.separatorColor = UIColor.clear
        
        let paymentViewNavigationController = self.tabBarController?.viewControllers?[0]
        let nav = paymentViewNavigationController as! UINavigationController
        let paymentMethodViewController = nav.viewControllers[0] as! HomeViewController
        homeViewModel = paymentMethodViewController.homeViewModel
        
        //cmsData = []
        
        if homeViewModel.cmsData.count > 0{
            for i in 0..<homeViewModel.cmsData.count{
                let cmsTitle = homeViewModel.cmsData[i].title!
                let cmsInfo = MyProfileData(title: cmsTitle, image: getCmsDataImage(title: cmsTitle))
                profileCMSData.add(cmsInfo)
                //cmsData.add(homeViewModel.cmsData[i].title)
            }
        }
        
        NotificationCenter.default.addObserver(self, selector: #selector(self.pushNotificationforChatTap), name: NSNotification.Name(rawValue: "pushNotificationforChat"), object: nil)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        
        self.navigationController?.isNavigationBarHidden = true
        myProfileTableView.separatorStyle = .none
        
        if DEFAULTS.object(forKey: "customerId") != nil{
            showUserProfile = true
            self.setUpProfileDataByUserType()
        
        }else{
            
            showUserProfile = false
            profileData = [profileHeaderView,singUpButtonView,userDataBeforLogin,profileCMSData]
            //profileData = [profileHeaderView,afterLoginData,extraData,cmsData]
            myProfileTableView.dataSource = self
            myProfileTableView.delegate = self
            myProfileTableView.reloadData()
            self.myProfileTableView.setContentOffset(CGPoint(x: 0, y: -120), animated: true)
        }
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(true)
        navigationItem.backBarButtonItem = UIBarButtonItem(title: " ", style: .plain, target: nil, action: nil)
    }
    
    func getCmsDataImage(title:String) -> UIImage{
        
        var cmsImage:UIImage!
        if title == "About Us"{
            cmsImage = UIImage(named:"about")
        }
        else if title == "Privacy Policy"{
            cmsImage = UIImage(named:"privacy-policy")
        }
        else if title == "Refunds & Returns Policy"{
            cmsImage = UIImage(named:"returnr")
        }
        else if title == "Terms & Conditions"{
            cmsImage = UIImage(named:"terms-condition")
        }
        return cmsImage
    }
    
    func setUpProfileDataByUserType(){
        
        if showUserProfile == true {
            profileData = [profileHeaderView,userDataAfterLogin,logoutData,profileCMSData]
            
        }else{
            profileData = [profileHeaderView,userDataBeforLogin,logoutData,profileCMSData]
        }
        
        myProfileTableView.dataSource = self
        myProfileTableView.delegate = self
        myProfileTableView.reloadData()
    }
    
    /*
    func setUpProfileDataByUserType(){
        
        if showUserProfile == true {
            
            if defaults.object(forKey: "isSeller") as! String == "t" &&
                defaults.object(forKey: "isPending") as! String == "f" {
                
                if defaults.object(forKey: "isAdmin") as? String == "t" {
                    
                    profileData = [profileHeaderView,approvedSellerDataAsAdmin,logoutData]
                }
                else
                {
                    profileData = [profileHeaderView,approvedSellerDataAsNonAdmin,logoutData]
                }
            }
            else if defaults.object(forKey: "isSeller") as! String == "t" &&
                        defaults.object(forKey: "isPending") as! String == "t"{
                
                profileData = [profileHeaderView,nonApprovedSellerDataAsNonAdmin]
            }
            /*
            else if defaults.object(forKey: "isSeller") as! String == "f" &&
                        defaults.object(forKey: "isPending") as! String == "f"{
                profileData = [ "marketplace".localized, "wanttobecomeseller".localized]
            }*/
            else
            {
                profileData = [profileHeaderView,userDataAfterLogin,logoutData,profileCMSData]
            }
            
            myProfileTableView.dataSource = self
            myProfileTableView.delegate = self
            myProfileTableView.reloadData()
        }
    }
    */
    
    //MARK:- Push Notification for Chat Tap
    @objc func pushNotificationforChatTap()  {
        if DEFAULTS.object(forKey: "customerId") != nil{
            self.navigationController?.isNavigationBarHidden = true
        }else{
            self.navigationController?.isNavigationBarHidden = false
        }
        
        //open seller chat
        if DEFAULTS.object(forKey: "isAdmin") as? String == "t" {
            let vc = AppStoryboard.Marketplace.instance.instantiateViewController(withIdentifier: "ChatSellerListController") as! ChatSellerListController
            self.navigationController?.pushViewController(vc, animated: true)
        }else {
            let vc = AppStoryboard.Marketplace.instance.instantiateViewController(withIdentifier: "ChatMessaging") as! ChatMessaging
            vc.customerId = DEFAULTS.object(forKey:"customerId") as! String
            vc.token = ""
            vc.customerName = DEFAULTS.object(forKey:"customerName") as! String
            vc.apiKey = ""
            self.navigationController?.pushViewController(vc, animated: true)
        }
    }
    
    
    
    
    func  callRMALogin(){
        /*
        if defaults.object(forKey: "customerEmail") == nil{
            let view: RMALogin = try! SwiftMessages.viewFromNib()
            view.topLabe.text = GlobalData.sharedInstance.language(key: "guestlogin")
            view.loginButton.setTitle(GlobalData.sharedInstance.language(key: "login"), for: .normal)
            view.orderIDField.placeholder = GlobalData.sharedInstance.language(key: "orderid")
            view.emailIdField.placeholder = GlobalData.sharedInstance.language(key: "email")
            view.delegate = self
            view.viewcontroller = self
            view.cancelAction = { SwiftMessages.hide() }
            var config = SwiftMessages.defaultConfig
            config.presentationContext = .window(windowLevel: UIWindowLevelStatusBar)
            config.duration = .forever
            config.presentationStyle = .center
            config.dimMode = .gray(interactive: true)
            SwiftMessages.show(config: config, view: view)
        }else{
            self.performSegue(withIdentifier: "marketplacerma", sender: self)
        }*/
    }
    
    func getSuccessConfirmation(){
        self.performSegue(withIdentifier: "marketplacerma", sender: self)
    }
    
    func selectCmsData(pos:Int) {
        cmsID = homeViewModel.cmsData[pos].id
        cmsName = homeViewModel.cmsData[pos].title
        self.performSegue(withIdentifier: "cmsdata", sender: self)
    }
    
    
    @objc func uploadProfileORBannerPic() {
        let alert = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
        let uploadBanner = UIAlertAction(title: GlobalData.sharedInstance.language(key: "uploadbanner"), style: .default, handler: uploadBannerPic)
        let uploadPic = UIAlertAction(title: GlobalData.sharedInstance.language(key: "uploadpic"), style: .default, handler: uploadProfilePic)
        let cancel = UIAlertAction(title: GlobalData.sharedInstance.language(key: "cancel"), style: .cancel, handler: cancelDeletePlanet)
        alert.addAction(uploadBanner)
        alert.addAction(uploadPic)
        alert.addAction(cancel)
        alert.popoverPresentationController?.sourceView = self.view
        alert.popoverPresentationController?.sourceRect = CGRect(x:self.view.bounds.size.width / 2.0, y: self.view.bounds.size.height / 2.0, width : 1.0, height : 1.0)
        self.present(alert, animated: true, completion: nil)
    }
    
    func uploadBannerPic(alertAction: UIAlertAction!) {
        imageForCategoryMenu = "uploadBannerPic"
        let AC = UIAlertController(title: GlobalData.sharedInstance.language(key: "uploadbanner"), message: "", preferredStyle: .alert)
        let clickBtn = UIAlertAction(title: GlobalData.sharedInstance.language(key: "takepicture") , style: .default, handler: {(_ action: UIAlertAction) -> Void in
            if UIImagePickerController.isSourceTypeAvailable(UIImagePickerControllerSourceType.camera) {
                let imagePicker = UIImagePickerController()
                imagePicker.delegate = self
                imagePicker.sourceType = UIImagePickerControllerSourceType.camera
                imagePicker.allowsEditing = false
                self.present(imagePicker, animated: true, completion: nil)
            }
        })
        let cameraRollBtn = UIAlertAction(title: GlobalData.sharedInstance.language(key: "uploadfromcameraroll"), style: .default, handler: {(_ action: UIAlertAction) -> Void in
            let picker = UIImagePickerController()
            picker.delegate = self
            picker.allowsEditing = true
            picker.sourceType = .photoLibrary
            self.present(picker, animated: true, completion: {  })
        })
        let noBtn = UIAlertAction(title: GlobalData.sharedInstance.language(key: "cancel"), style: .default, handler: {(_ action: UIAlertAction) -> Void in
        })
        AC.addAction(clickBtn)
        AC.addAction(cameraRollBtn)
        AC.addAction(noBtn)
        self.parent!.present(AC, animated: true, completion: {  })
    }
    
    func uploadProfilePic(alertAction: UIAlertAction!) {
        imageForCategoryMenu = "profilePicture"
        let AC = UIAlertController(title: GlobalData.sharedInstance.language(key: "uploadpic"), message: "", preferredStyle: .alert)
        let clickBtn = UIAlertAction(title: GlobalData.sharedInstance.language(key: "takepicture"), style: .default, handler: {(_ action: UIAlertAction) -> Void in
            if UIImagePickerController.isSourceTypeAvailable(UIImagePickerControllerSourceType.camera) {
                let imagePicker = UIImagePickerController()
                imagePicker.delegate = self
                imagePicker.sourceType = UIImagePickerControllerSourceType.camera
                imagePicker.allowsEditing = false
                self.present(imagePicker, animated: true, completion: nil)
            }
        })
        let cameraRollBtn = UIAlertAction(title: GlobalData.sharedInstance.language(key: "uploadfromcameraroll"), style: .default, handler: {(_ action: UIAlertAction) -> Void in
            let picker = UIImagePickerController()
            picker.delegate = self
            picker.allowsEditing = true
            picker.sourceType = .photoLibrary
            self.present(picker, animated: true, completion: {  })
        })
        let noBtn = UIAlertAction(title: GlobalData.sharedInstance.language(key: "cancel"), style: .default, handler: {(_ action: UIAlertAction) -> Void in
        })
        AC.addAction(clickBtn)
        AC.addAction(cameraRollBtn)
        AC.addAction(noBtn)
        self.parent!.present(AC, animated: true, completion: {  })
    }
    
    func cancelDeletePlanet(alertAction: UIAlertAction!) {
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        if let image = info[UIImagePickerControllerOriginalImage] as? UIImage {
            let imageNew = image.fixOrientation()
            
            let image: UIImage = imageNew
            
            let cropViewController = CropViewController(image: image)
            cropViewController.delegate = self
            if (imageForCategoryMenu == "uploadBannerPic") {
                cropViewController.customAspectRatio = CGSize(width: SCREEN_WIDTH, height: 250)
            }else {
                cropViewController.customAspectRatio = CGSize(width: SCREEN_WIDTH, height: SCREEN_WIDTH)
            }
            
            cropViewController.aspectRatioPickerButtonHidden = true
            cropViewController.aspectRatioLockEnabled = true
            
            picker.dismiss(animated: true, completion: nil)
            self.present(cropViewController, animated: true, completion: nil)
        }
    }
    
    func cropViewController(_ cropViewController: CropViewController, didCropToImage image: UIImage, withRect cropRect: CGRect, angle: Int) {
        imageData = UIImageJPEGRepresentation(image, 0.8) as NSData?
        saveProfileData()
        cropViewController.dismiss(animated: true, completion: nil)
    }
    
    func saveProfileData() {
//        GlobalData.sharedInstance.showLoader()
//        var headers: HTTPHeaders = [:]
//        if DEFAULTS.object(forKey: "authKey") == nil{
//            headers = [
//                "apiKey": API_USER_NAME,
//                "apiPassword": API_KEY,
//                "authKey":""
//            ]
//        } else {
//            headers = [
//                "apiKey": API_USER_NAME,
//                "apiPassword": API_KEY,
//                "authKey":DEFAULTS.object(forKey: "authKey") as! String
//            ]
//        }
//        
//        var imageSendUrl:String = ""
//        if (imageForCategoryMenu == "uploadBannerPic") {
//            let url = BASE_DOMAIN + SUB_DOMAIN_USER + "index/uploadBannerPic"
//            imageSendUrl = url
//        } else {
//            let url = BASE_DOMAIN + SUB_DOMAIN_USER + "index/uploadProfilePic"
//            imageSendUrl = url
//        }
//        
//        DispatchQueue.main.async {
//            AF.upload(multipartFormData: { multipartFormData in
//                let customerId = DEFAULTS.object(forKey:"customerId")
//                var params = [String:AnyObject]()
//                
//                params["customerToken"] = customerId as AnyObject
//                if DEFAULTS.object(forKey: "form_key") != nil {
//                    params["form_key"] = DEFAULTS.object(forKey: "form_key") as! String as AnyObject
//                } else {
//                    params["form_key"] = "" as AnyObject
//                }
//                let width = String(format:"%f", SCREEN_WIDTH * UIScreen.main.scale)
//                params["width"] = width as AnyObject
//                
//                print(params)
//                for (key, value) in params {
//                    if let data = value.data(using: String.Encoding.utf8.rawValue) {
//                        multipartFormData.append(data, withName: key)
//                    }
//                }
//                
//                if self.imageData != nil {
//                    let imageData1 = self.imageData! as Data
//                    multipartFormData.append(imageData1, withName: "imageFormKey", fileName: "image.jpg", mimeType: "image/jpeg")
//                }
//            },
//                             to: imageSendUrl,method:HTTPMethod.post,
//                             headers: headers, encodingCompletion: { encodingResult in
//                                switch encodingResult {
//                                case .success(let upload, _, _):
//                                    upload
//                                        .validate()
//                                        .responseJSON { response in
//                                            switch response.result {
//                                            case .success(let value):
//                                                print("responseObject: \(value)")
//                                                var dict = JSON(value)
//                                                //                                                GlobalData.sharedInstance.showSuccessSnackBar(msg:dict["message"].stringValue )
//                                                GlobalData.sharedInstance.dismissLoader()
//                                                
//                                                if(self.imageForCategoryMenu == "uploadBannerPic") {
//                                                    let imageUrl = dict["url"].stringValue
//                                                    DEFAULTS.set(imageUrl, forKey: "profileBanner")
//                                                    self.myProfileTableView.reloadData()
//                                                } else {
//                                                    let imageUrl = dict["url"].stringValue
//                                                    DEFAULTS.set(imageUrl, forKey: "profilePicture")
//                                                    self.myProfileTableView.reloadData()
//                                                }
//                                            case .failure(let responseError):
//                                                AlertManager.shared.showErrorSnackBar(msg: "Not updated")
//                                                GlobalData.sharedInstance.dismissLoader()
//                                                print("responseError: \(responseError)")
//                                            }
//                                    }
//                                case .failure(let encodingError):
//                                    print("encodingError: \(encodingError)")
//                                }
//            })
//        }
    }
    
    func openCurrencyView() {
        let alert = UIAlertController(title: GlobalData.sharedInstance.language(key: "chooseyourcurrency"), message: nil, preferredStyle: .actionSheet)
        for i in 0..<homeViewModel.currency.count {
            var image = UIImage(named: "")
            if DEFAULTS.object(forKey: "currency") != nil {
                let currencyCode = DEFAULTS.object(forKey: "currency") as! String
                if currencyCode == homeViewModel.currency[i] as! String{
                    image = UIImage(named: "ic_check")
                } else {
                    image = UIImage(named: "")
                }
            }
            
            let str : String = homeViewModel.currency[i] as! String
            let action = UIAlertAction(title: str, style: .default, handler: {(_ action: UIAlertAction) -> Void in
                self.selectCurrencyData(pos:i)
            })
            action.setValue(image, forKey: "image")
            alert.addAction(action)
        }
        
        let cancel = UIAlertAction(title: GlobalData.sharedInstance.language(key: "cancel"), style: .cancel, handler: {(_ action: UIAlertAction) -> Void in
        })
        alert.addAction(cancel)
        
        // Support display in iPad
        alert.popoverPresentationController?.sourceView = self.view
        alert.popoverPresentationController?.sourceRect = CGRect(x:self.view.bounds.size.width / 2.0, y: self.view.bounds.size.height / 2.0, width : 1.0, height : 1.0)
        self.present(alert, animated: true, completion: nil)
    }
    
    func selectCurrencyData(pos:Int) {
        let contentForThisRow  = homeViewModel.currency[pos] as! String
        DEFAULTS.set(contentForThisRow, forKey: "currency")
        DEFAULTS.synchronize()
        
        let rootviewcontroller: UIWindow = ((UIApplication.shared.delegate?.window)!)!
        rootviewcontroller.rootViewController = self.storyboard?.instantiateViewController(withIdentifier: "rootnav")
        let mainwindow = (UIApplication.shared.delegate?.window!)!
        mainwindow.backgroundColor = UIColor(hue: 0.6477, saturation: 0.6314, brightness: 0.6077, alpha: 0.8)
        UIView.transition(with: mainwindow, duration: 0.55001, options: .transitionFlipFromLeft, animations: { () -> Void in
        }) { (finished) -> Void in
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if (segue.identifier! == "storeview") {
            let viewController:StoreViewController = segue.destination as UIViewController as! StoreViewController
            viewController.storeData = homeViewModel.storeData
        } else if (segue.identifier! == "cmsdata") {
            let viewController:CMSPageData = segue.destination as UIViewController as! CMSPageData
            viewController.cmsId = self.cmsID
            viewController.cmsName = cmsName
        }
    }
    
    func gotoRelatedProfile(screenName:String){
        
        print("Move to selected screen : "+screenName)

            if screenName.trimmed == "Notification" {
                
                let vc = AppStoryboard.Main.instance.instantiateViewController(withIdentifier: "NotificationController") as! NotificationController
                vc.viewBy = .profile
                self.navigationController?.pushViewController(vc, animated: true)
                //self.performSegue(withIdentifier: "notification", sender: self)
            }
            else if screenName.trimmed ==  "Social Center" {
                AlertManager.shared.showInfoSnackBar(msg:"Feature is remain to develop")
                /*
                let vc = AppStoryboard.Main.instance.instantiateViewController(withIdentifier: "SocialCenterViewController") as! SocialCenterViewController
                vc.viewBy = .profile
                self.navigationController?.pushViewController(vc, animated: true)
                */
                
            }
            else if screenName.trimmed ==  "My Order" {
                self.performSegue(withIdentifier: "myorder", sender: self)
            }
            else if screenName.trimmed ==  "My WishList" {
                let vc = self.storyboard?.instantiateViewController(withIdentifier: "MyWishList") as! MyWishList
                self.navigationController?.pushViewController(vc, animated: true)
            }
            else if screenName.trimmed == "My Product Reviews" {
                self.performSegue(withIdentifier: "myproductreviews", sender: self)
            }
            else if screenName.trimmed == "Account Information"{
                let vc = AppStoryboard.Main.instance.instantiateViewController(withIdentifier: "AccountInformation") as! AccountInformation
                self.navigationController?.pushViewController(vc, animated: true)
            }
            else if screenName.trimmed == "Address Book" {
                self.performSegue(withIdentifier: "addressbook", sender: self)
            }
            else if screenName.trimmed ==  "Search Terms" {
                self.performSegue(withIdentifier: "searchterms", sender: self)
            }
            else if screenName == "Advance Search Terms" {
                let vc = AppStoryboard.Main.instance.instantiateViewController(withIdentifier: "AdvanceSearch") as! AdvanceSearch
                self.navigationController?.pushViewController(vc, animated: true)
            }
            else if screenName == "Compare List" {
                self.performSegue(withIdentifier: "comparelist", sender: self)
            }
            else if screenName == "Contact Us" {
                let vc = AppStoryboard.Main.instance.instantiateViewController(withIdentifier: "ContactUSController") as! ContactUSController
                self.navigationController?.pushViewController(vc, animated: true)
            }
            else if screenName == "Download Merchant App" {
                AlertManager.shared.showInfoSnackBar(msg:"App is not available in app store. please wait...")
            }
        
        else if screenName == "Change App Language" {            
            print("Hello")
           
        }
        
    }
    
    
    
 
    
    
    
    
    
    /*
     
     if defaults.object(forKey: "isSeller") as! String == "t" && defaults.object(forKey: "isPending") as! String == "f" {
         if indexPath.row == 0 {
             let vc = AppStoryboard.Marketplace.instance.instantiateViewController(withIdentifier: "MarketPlace") as! MarketPlace
             self.navigationController?.pushViewController(vc, animated: true)
         } else if indexPath.row == 1 {
             let vc = AppStoryboard.Marketplace.instance.instantiateViewController(withIdentifier: "SellerDashBoardController") as! SellerDashBoardController
             self.navigationController?.pushViewController(vc, animated: true)
         }else if indexPath.row == 2{
             let vc = AppStoryboard.Marketplace.instance.instantiateViewController(withIdentifier: "SellerProfileController") as! SellerProfileController
             self.navigationController?.pushViewController(vc, animated: true)
         }else if indexPath.row == 3{
             let vc = AppStoryboard.Marketplace.instance.instantiateViewController(withIdentifier: "SellerOrderViewController") as! SellerOrderViewController
             self.navigationController?.pushViewController(vc, animated: true)
         }else if indexPath.row == 4{
             let vc = AppStoryboard.Marketplace.instance.instantiateViewController(withIdentifier: "MyTransactionList") as! MyTransactionList
             self.navigationController?.pushViewController(vc, animated: true)
         }else if indexPath.row == 5{
             let vc = AppStoryboard.Marketplace.instance.instantiateViewController(withIdentifier: "CreateAttributesController") as! CreateAttributesController
             self.navigationController?.pushViewController(vc, animated: true)
         }else if indexPath.row == 6{
             let vc = AppStoryboard.Marketplace.instance.instantiateViewController(withIdentifier: "MyProductListController") as! MyProductListController
             self.navigationController?.pushViewController(vc, animated: true)
         }else if indexPath.row == 7{
             let vc = AppStoryboard.Marketplace.instance.instantiateViewController(withIdentifier: "ManagePrintPDFHeader") as! ManagePrintPDFHeader
             self.navigationController?.pushViewController(vc, animated: true)
         }
         
         if defaults.object(forKey: "isAdmin") as? String == "f" {
             if indexPath.row == 8{
                 let vc = AppStoryboard.Marketplace.instance.instantiateViewController(withIdentifier: "AskToAdmin") as! AskToAdmin
                 self.navigationController?.pushViewController(vc, animated: true)
             }else if indexPath.row == 9 {
                 if defaults.object(forKey: "isAdmin") as? String == "t" {
                     let vc = AppStoryboard.Marketplace.instance.instantiateViewController(withIdentifier: "ChatSellerListController") as! ChatSellerListController
                     self.navigationController?.pushViewController(vc, animated: true)
                 }else {
                     let vc = AppStoryboard.Marketplace.instance.instantiateViewController(withIdentifier: "ChatMessaging") as! ChatMessaging
                     vc.customerId = defaults.object(forKey:"customerId") as! String
                     vc.token = ""
                     vc.customerName = defaults.object(forKey:"customerName") as! String
                     vc.apiKey = ""
                     self.navigationController?.pushViewController(vc, animated: true)
                 }
             }
         } else {
             if indexPath.row == 8 {
                 if defaults.object(forKey: "isAdmin") as? String == "t" {
                     let vc = AppStoryboard.Marketplace.instance.instantiateViewController(withIdentifier: "ChatSellerListController") as! ChatSellerListController
                     self.navigationController?.pushViewController(vc, animated: true)
                 } else {
                     let vc = AppStoryboard.Marketplace.instance.instantiateViewController(withIdentifier: "ChatMessaging") as! ChatMessaging
                     vc.customerId = defaults.object(forKey:"customerId") as! String
                     vc.token = ""
                     vc.customerName = defaults.object(forKey:"customerName") as! String
                     vc.apiKey = ""
                     self.navigationController?.pushViewController(vc, animated: true)
                 }
             }
         }
     } else if defaults.object(forKey: "isSeller") as! String == "t" && defaults.object(forKey: "isPending") as! String == "t" {
         if indexPath.row == 0 {
             let vc = AppStoryboard.Marketplace.instance.instantiateViewController(withIdentifier: "MarketPlace") as! MarketPlace
             self.navigationController?.pushViewController(vc, animated: true)
         } else if indexPath.row == 1 {
             GlobalData.sharedInstance.showWarningSnackBar(msg: "yourselleraccountisunderapprovalbytheadmin".localized)
         } else if indexPath.row == 2 {
             let vc = AppStoryboard.Marketplace.instance.instantiateViewController(withIdentifier: "AskToAdmin") as! AskToAdmin
             self.navigationController?.pushViewController(vc, animated: true)
         }
     } else if defaults.object(forKey: "isSeller") as! String == "f" && defaults.object(forKey: "isPending") as! String == "f" {
         if indexPath.row == 0 {
             let vc = AppStoryboard.Marketplace.instance.instantiateViewController(withIdentifier: "MarketPlace") as! MarketPlace
             self.navigationController?.pushViewController(vc, animated: true)
         } else if indexPath.row == 1 {
             let vc = AppStoryboard.Marketplace.instance.instantiateViewController(withIdentifier: "BecomesPartnerController") as! BecomesPartnerController
             self.navigationController?.pushViewController(vc, animated: true)
         }
     }
     
     */
    
    func openInstalledApp(appName:String) {
        
        if appName == AppType.Instagram {
            
            let isAppInstalled = UIApplication.shared.canOpenURL(NSURL(string:AfritiaAppSchemeUrl.Instagram)! as URL)
            
            if isAppInstalled == true {
                UIApplication.shared.open(URL(string:AfritiaAppSchemeUrl.Instagram)!)
            }else{
                UIApplication.shared.open(AfritiaWebUrl.Instagram!, options: [:], completionHandler: nil)
                //self.loadLinkInWebView(urlLink:FSwebUrl.Instagram, navTitle:"Instagram")
            }
        }
        
        else if appName == AppType.Facebook {
            
            let isAppInstalled = UIApplication.shared.canOpenURL(NSURL(string:AfritiaAppSchemeUrl.Facebook)! as URL)
            
            if isAppInstalled == true {
                UIApplication.shared.open(URL(string:AfritiaAppSchemeUrl.Facebook)!)
            }else{
                //self.loadLinkInWebView(urlLink:FSwebUrl.Facebook, navTitle:"Facebook")
                UIApplication.shared.open(AfritiaWebUrl.Facebook!, options: [:], completionHandler: nil)
            }
        }
        
        else if appName == AppType.Twitter {
            
            let isAppInstalled = UIApplication.shared.canOpenURL(NSURL(string:AfritiaAppSchemeUrl.Twitter)! as URL)
            
            if isAppInstalled == true {
                UIApplication.shared.open(URL(string:AfritiaAppSchemeUrl.Twitter)!)
            }else{
                UIApplication.shared.open(AfritiaWebUrl.Twitter!, options: [:], completionHandler: nil)
                //self.loadLinkInWebView(urlLink:FSwebUrl.Twitter, navTitle:"Twitter")
            }
        }
        
        else if appName == AppType.Pinterest {
            
            let isAppInstalled = UIApplication.shared.canOpenURL(NSURL(string:AfritiaAppSchemeUrl.Piterest)! as URL)
            
            if isAppInstalled == true {
                UIApplication.shared.open(URL(string:AfritiaAppSchemeUrl.Piterest)!)
            }else{
                UIApplication.shared.open(AfritiaWebUrl.Pinterest!, options: [:], completionHandler: nil)
                //self.loadLinkInWebView(urlLink:FSwebUrl.Pinterest, navTitle:"Pinterest")
            }
        }
        
        else if appName == AppType.LinkedIn {
            
            let isAppInstalled = UIApplication.shared.canOpenURL(NSURL(string:AfritiaAppSchemeUrl.LinkedIn)! as URL)
            
            if isAppInstalled == true {
                UIApplication.shared.open(URL(string:AfritiaAppSchemeUrl.LinkedIn)!)
            }else{
                UIApplication.shared.open(AfritiaWebUrl.LinkedIn!, options: [:], completionHandler: nil)
                //self.loadLinkInWebView(urlLink:FSwebUrl.LinkedIn, navTitle:"Linked In")
            }
        }
        
        else if appName == AppType.Youtube {
            
            let isAppInstalled = UIApplication.shared.canOpenURL(NSURL(string:AfritiaAppSchemeUrl.Youtube)! as URL)
            
            if isAppInstalled == true {
                UIApplication.shared.open(URL(string:AfritiaAppSchemeUrl.Youtube)!)
            }else{
                UIApplication.shared.open(AfritiaWebUrl.Youtube!, options: [:], completionHandler: nil)
                //self.loadLinkInWebView(urlLink:FSwebUrl.LinkedIn, navTitle:"Linked In")
            }
        }
    }
    
    func doLogout() {
        
        let logOutMsg = """
\(GlobalData.sharedInstance.language(key: "warninglogoutmessage"))
"""
        let AC = UIAlertController(title:GlobalData.sharedInstance.language(key: "warninglogoutmessage"), message:"", preferredStyle: .alert)
        let ok = UIAlertAction(title: GlobalData.sharedInstance.language(key: "yes"), style: .default, handler: {(_ action: UIAlertAction) -> Void in
            
            for key in UserDefaults.standard.dictionaryRepresentation().keys {
                if(key.description == "storeId"||key.description == "language"||key.description == "AppleLanguages" || key.description == "currency" || key.description == "authKey" || key.description == "TouchEmailId" || key.description == "TouchPasswordValue" || key.description == "touchIdFlag" || key.description == "deviceToken" ) {
                    continue
                } else {
                    UserDefaults.standard.removeObject(forKey: key.description)
                }
            }
            UserDefaults.standard.synchronize()
            //self.tabBarController!.tabBar.items?[3].badgeValue = nil
            GlobalData.sharedInstance.cartItemsCount = 0
            self.viewWillAppear(true)
        })
        
        let noBtn = UIAlertAction(title: GlobalData.sharedInstance.language(key: "no"), style: .destructive, handler: {(_ action: UIAlertAction) -> Void in
        })
        
        AC.addAction(ok)
        AC.addAction(noBtn)
        self.parent!.present(AC, animated: true, completion: {  })
    }
}

extension MyProfileController : UITableViewDelegate, UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return profileData.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        if showUserProfile {
            
            if section == 0 {
                return 1
            }else if section == 1 {
                return (profileData[1] as AnyObject).count
            }else if section == 2 {
                return logoutData.count
            }else if section == 3 {
                return profileCMSData.count
            }
            
        }else{
            
            if section == 0 {
                return 1
            }else if section == 1 {
                return 1 // sign in view
            }else if section == 2 {
                return (profileData[2] as AnyObject).count
            }else if section == 3 {
                return profileCMSData.count
            }
        }
        
        return 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        if indexPath.section == 0 {
            let cell:ProfileTableViewCell = tableView.dequeueReusableCell(withIdentifier: "ProfileTableViewCell") as! ProfileTableViewCell
            
            cell.profileEmail.isHidden = true
            cell.profileImage.image = UIImage(named: "afritia_spaced_logo_512")
            cell.profileBannerImage.image = UIImage(named: "ic_backgroundImage")
            
            if showUserProfile {
                
                cell.visualView.isHidden = false
                cell.editView.isHidden = false
                
                cell.editView.addTapGestureRecognizer {
                    self.uploadProfileORBannerPic()
                }
                
                if DEFAULTS.object(forKey: "customerEmail") != nil {
                    cell.profileEmail.text = DEFAULTS.object(forKey: "customerEmail") as? String
                }
                if DEFAULTS.object(forKey: "customerName") != nil {
                    cell.profileName.text = DEFAULTS.object(forKey: "customerName") as? String
                }
                
                if DEFAULTS.object(forKey: "profilePicture") != nil {
                    let imageUrl = DEFAULTS.object(forKey: "profilePicture") as? String
                    cell.profileImage.getImageFromUrl(imageUrl: imageUrl!)
                }
                if DEFAULTS.object(forKey: "profileBanner") != nil {
                    let imageUrl = DEFAULTS.object(forKey: "profileBanner") as? String
                    cell.profileBannerImage.getImageFromUrl(imageUrl: imageUrl!)
                }
                
            }else{
                
                cell.visualView.isHidden = true
                cell.editView.isHidden = true
                cell.profileBannerImage.image = nil
                cell.profileBannerImage.backgroundColor = UIColor.LightLavendar
                cell.profileImage.image = UIImage(named: "afritia_spaced_logo_512")
                cell.profileName.text = "Guest User"
                cell.profileEmail.text = "not regiistered"
                
            }
            
            cell.selectionStyle = .none
            return cell
            // profile header
        }
        else if indexPath.section == 1 {
            // signup view  or sigin data
            if showUserProfile {

                let cell:ProfileCell = tableView.dequeueReusableCell(withIdentifier: "ProfileCell") as! ProfileCell
                let sectionContents = profileData[indexPath.section] as! [MyProfileData]
                cell.profileImage.image = sectionContents[indexPath.row].image
                cell.name.text = sectionContents[indexPath.row].title
                cell.selectionStyle = .none
                return cell
            }
            else
            {
                let cell:LoginButtonTableViewCell = tableView.dequeueReusableCell(withIdentifier: "LoginButtonTableViewCell") as! LoginButtonTableViewCell
                cell.delegate = self
                cell.selectionStyle = .none
                return cell
            }
            
        }
        else if indexPath.section == 2 {
            // logout btn or logoutdata
            let cell:ProfileCell = tableView.dequeueReusableCell(withIdentifier: "ProfileCell") as! ProfileCell
            let sectionContents = profileData[indexPath.section] as! NSMutableArray
            let rowData = sectionContents[indexPath.row] as! MyProfileData
            cell.profileImage.image = rowData.image
            cell.name.text = rowData.title
            cell.selectionStyle = .none
            return cell
        }
        else if indexPath.section == 3 {
            // cms data
            let cell:ProfileCell = tableView.dequeueReusableCell(withIdentifier: "ProfileCell") as! ProfileCell
            let rowData = profileCMSData[indexPath.row] as! MyProfileData
            cell.profileImage.image = rowData.image
            cell.name.text = rowData.title
            cell.selectionStyle = .none
            return cell
        }
        
        return UITableViewCell()
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        if indexPath.section == 0 {
            // do nothing prifle header
        }
        else if indexPath.section == 1 {
            
            if showUserProfile {
                let sectionContents = profileData[indexPath.section] as! [MyProfileData]
                self.gotoRelatedProfile(screenName: sectionContents[indexPath.row].title)
            }else{
                // do nothing sign up view is visble for guest user
            }
        }
        else if indexPath.section == 2 {
            
            if showUserProfile {
                self.doLogout()
            }
            else
            {
                let sectionContents = profileData[indexPath.section] as! [MyProfileData]
                self.gotoRelatedProfile(screenName: sectionContents[indexPath.row].title)
            }
        }
        else if indexPath.section == 3{
            // do as direct cms data
            let contentForThisRow  = profileCMSData[indexPath.row] as! MyProfileData
            let cmsTitle = contentForThisRow.title
            print(cmsTitle!)
            print("view is redirected to cms screen")
            self.selectCmsData(pos: indexPath.row)
        }
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        if section == 0{
            return 0
        }else{
            return 5
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        if indexPath.section == 0 {
            return 250
        }
        else if indexPath.section == 1{
            
            if showUserProfile {
                return 50
            }else{
                return 235
            }
        }
        else if indexPath.section == 2 {
            return 50
        }
        else if indexPath.section == 3 {
            return 50
        }
        return 0
    }
}

extension MyProfileController : LoginButtonHandlerDelegate {
    
    func btnDowloadMerchantAppClick() {
        AlertManager.shared.showInfoSnackBar(msg:"App is not available in app store. please wait...")
    }
    
    
    func btnSignInClick() {
        self.performSegue(withIdentifier: "customerlogin", sender: self)
    }
    
    func btnRegisterClick() {
        let vc = AppStoryboard.Main.instance.instantiateViewController(withIdentifier: "CreateAccount") as! CreateAccount
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    func btnSocialMediaClick(appType: String) {
        self.openInstalledApp(appName:appType)
    }
    
}
