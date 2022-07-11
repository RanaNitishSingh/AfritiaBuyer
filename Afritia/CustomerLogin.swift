//
//  CustomerLogin.swift
//  Magento2V4Theme
//
//  Created by Webkul on 10/02/18.
//  Copyright © 2018 Webkul. All rights reserved.
//

import UIKit
import Firebase
import GoogleSignIn
import LocalAuthentication
//import FBSDKLoginKit
import AuthenticationServices
import EzPopup
import HCSStarRatingView
//import TwitterKit

class CustomerLogin: UIViewController {
    
    //@IBOutlet weak var appName: UILabel!
    
    let defaults = UserDefaults.standard
    
    @IBOutlet weak var loginBackView: UIView!
    @IBOutlet weak var emailIdField: UITextField!
    @IBOutlet weak var passwordtextField: HideShowPasswordTextField!
    @IBOutlet weak var forgotPasswordButton: UIButton!
    @IBOutlet weak var loginButton: UIButton!
    @IBOutlet weak var signupButton: UIButton!
    
    @IBOutlet weak var btnLoginWithFacebook: UIButton!
    @IBOutlet weak var btnLoginWithTwitter: UIButton!
    @IBOutlet weak var btnLoginWithGoogle: UIButton!
    @IBOutlet weak var btnLoginWithApple: UIButton!
    
    var whichApiToProcess:String = ""
    var emailId:String = ""
    var password:String = ""
    var moveToSignal:String = ""
    var userEmail:String = ""
    var context = LAContext()
    let kMsgShowReason = "🌛 Try to dismiss this screen 🌜"
    var errorMessage:String = ""
    var NotAgainCallTouchId :Bool = false
    
    //let fbLoginButton = FBLoginButton(frame: .zero)
    //let fbLoginButton = FBLoginButton()
    
    override func viewWillAppear(_ animated: Bool) {
        self.navigationController?.isNavigationBarHidden = false
        self.title = "Login"
        self.navigationController?.navigationBar.makeBarTransparent(titleColor:UIColor.white)
        self.navigationController?.navigationBar.setAttributedTitle(color:UIColor.white)
        view.backgroundColor = UIColor.LightLavendar
        loginBackView.layer.cornerRadius = 16
        
        let leftBtnImage = UIImage(named:"nav_icon_back")
        let backButton = UIBarButtonItem(image: leftBtnImage, style: .plain, target: self, action: #selector(self.backToProfile))
        self.navigationItem.leftBarButtonItem = backButton
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //google login setup
        GIDSignIn.sharedInstance().delegate = self
      //  GIDSignIn.sharedInstance()?.presentingViewController = self
        
//        //facebbok login setup
//        fbLoginButton.center = view.center
//        //view.addSubview(loginButton)
//        fbLoginButton.delegate = self
//        fbLoginButton.permissions = ["public_profile", "email"]
//        fbLoginButton.isHidden = true
//
//        if let token = AccessToken.current, !token.isExpired {
//                // User is logged in, do work such as go to next view controller.
//        }
        
        self.tabBarController?.tabBar.isHidden = true
        
        loginButton.applyAfritiaTheme()
        loginButton.setTitle(GlobalData.sharedInstance.language(key: "login"), for: .normal)

        signupButton.isHidden = true
        
        emailIdField.setLeftPaddingPoints(10)
        emailIdField.setRightPaddingPoints(10)
        emailIdField.applyAfritiaTheme()
        emailIdField.placeholder = GlobalData.sharedInstance.language(key: "email")
        
        passwordtextField.applyAfritiaTheme()
        passwordtextField.placeholder = GlobalData.sharedInstance.language(key: "password")
        
        forgotPasswordButton.setTitleColor(UIColor.lightGray, for: .normal)
        forgotPasswordButton.setTitle(GlobalData.sharedInstance.language(key: "forgotpassword"), for: .normal)
        
        if defaults.object(forKey: "touchIdFlag") == nil{
            defaults.set("0", forKey: "touchIdFlag");
            defaults.synchronize()
        }
        
        context = LAContext()
        //appName.text = GlobalData.sharedInstance.language(key: "applicationname");
        
        btnLoginWithFacebook.applyShadowedBorder()
        btnLoginWithApple.applyShadowedBorder()
        btnLoginWithGoogle.applyShadowedBorder()
        btnLoginWithTwitter.applyShadowedBorder()
    }
    
    @objc func backToProfile(){
        self.tabBarController?.tabBar.isHidden = false
        self.navigationController?.popViewController(animated:true)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        if(self.moveToSignal != "cart"){
            if defaults.object(forKey: "touchIdFlag") as! String == "1"{
                let  AC = UIAlertController(title: GlobalData.sharedInstance.language(key: "alert"), message: GlobalData.sharedInstance.language(key: "loginbytouchid"), preferredStyle: .alert)
                let okBtn = UIAlertAction(title: GlobalData.sharedInstance.language(key: "ok"), style:.default, handler: {(_ action: UIAlertAction) -> Void in
                    self.configureTouchIdBeforeLogin()
                })
                let cancelBtn = UIAlertAction(title: GlobalData.sharedInstance.language(key: "cancel"), style:.destructive, handler: {(_ action: UIAlertAction) -> Void in
                    
                })
                AC.addAction(okBtn)
                AC.addAction(cancelBtn)
                self.parent!.present(AC, animated: true, completion: {  })
            }
        }
    }
    
    @IBAction func clickOnBack(_ sender: Any) {
        //self.navigationController?.isNavigationBarHidden = false
        self.navigationController?.popViewController(animated: true)
        self.tabBarController?.tabBar.isHidden = false
    }
    
    func callingHttppApi(){
        
        GlobalData.sharedInstance.showLoader()
        self.view.isUserInteractionEnabled = false
        var requstParams = [String:Any]()

        
        requstParams["storeId"] = UserManager.getStoreId
        requstParams["quoteId"] = UserManager.getQuoteId
        requstParams["token"] = UserManager.getDeviceToken
        
        if(whichApiToProcess == "forgotpassword")
        {
            requstParams["email"] = self.userEmail
            APIServiceManager.shared.callingHttpRequest(params:requstParams, apiname:AfritiaAPI.forgotPassword, currentView: self){success,responseObject in
                if success == 1{
                    
                    if responseObject?.object(forKey: "storeId") != nil{
                        let storeId:String = String(format: "%@", responseObject?.object(forKey: "storeId") as! CVarArg)
                        if storeId != "0"{
                            self.defaults .set(storeId, forKey: "storeId")
                        }
                    }
                    
                    GlobalData.sharedInstance.dismissLoader()
                    self.view.isUserInteractionEnabled = true
                    let dict  = JSON(responseObject as! NSDictionary)
                    print(dict)
                    if dict["success"].boolValue == true{
                        AlertManager.shared.showSuccessSnackBar(msg: dict["message"].stringValue)
                    }else{
                        AlertManager.shared.showErrorSnackBar(msg: dict["message"].stringValue)
                    }
                }else if success == 2{
                    self.callingHttppApi()
                    GlobalData.sharedInstance.dismissLoader()
                }
            }
        }
        else
        {
            requstParams["username"] = emailIdField.text
            requstParams["password"] = passwordtextField.text
            requstParams["websiteId"] = UserManager.getWebsiteId
            requstParams["width"] = UserManager.getDeviceWidth
            requstParams["device"] = UserManager.getDeviceUDID
            
            self.loginToAfritiaWith(reqParam:requstParams)
        }
    }
    
    func loginToAfritiaWith(reqParam:[String:Any]){
        
        APIServiceManager.shared.callingHttpRequest(params:reqParam, apiname:AfritiaAPI.login, currentView: self){success,responseObject in
            if success == 1{
                if responseObject?.object(forKey: "storeId") != nil{
                    let storeId:String = String(format: "%@", responseObject?.object(forKey: "storeId") as! CVarArg)
                    if storeId != "0"{
                        self.defaults .set(storeId, forKey: "storeId")
                    }
                }
                self.view.isUserInteractionEnabled = true
                self.doFurtherProcessingWithResult(data:responseObject!)
            }
            else if success == 2{
                GlobalData.sharedInstance.dismissLoader()
                self.callingHttppApi()
            }
        }
    }
    
    func doFurtherProcessingWithResult(data:AnyObject){
        GlobalData.sharedInstance.dismissLoader()
        
        let responseData = JSON(data as! NSDictionary)
        print(responseData)
        
        if responseData["success"].boolValue == true{
            
            if responseData["tfa_enable"].boolValue == true {
                self.showTwoFactorVeryFicationDialogue(resData:data)
                // show two factor popup then update dashboard
            }
            else
            {
                //update dashboard without two factor
                self.updateDashBoardView(data: data)
                
                //UserManager.saveUserLoginData(responseObject:data)
                //let cartTotalDict = JSON(data)
                //let cartCount  = cartTotalDict["cartCount"].intValue
                //if cartCount > 0 {
                //    self.tabBarController!.tabBar.items?[3].badgeValue = cartTotalDict["cartCount"].stringValue
                //}
            }
            
        }else{
            AlertManager.shared.showErrorSnackBar(msg: responseData["message"].stringValue)
        }
    }
    
    func updateDashBoardView(data:AnyObject){
        
        UserManager.saveUserLoginData(responseObject:data)
        let cartTotalDict = JSON(data)
        let cartCount  = cartTotalDict["cartCount"].intValue
        if cartCount > 0 {
            let cartItems = cartTotalDict["cartCount"].stringValue
            if let itemsInCart = Int(cartItems){
                GlobalData.sharedInstance.cartItemsCount = itemsInCart
            }
            
            //self.tabBarController!.tabBar.items?[3].badgeValue = cartTotalDict["cartCount"].stringValue
        }
        
        //ranjit-uncomment to active touch id
        //self.setUpTouchIdForLogin()
        
        //show full profile after successfull login
        self.tabBarController?.tabBar.isHidden = false
       // self.navigationController?.popViewController(animated: true)
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let viewController = storyboard.instantiateViewController(withIdentifier :"MyProfileController") as! MyProfileController
        self.navigationController?.pushViewController(viewController, animated: true)
        
    }
    
    func setUpTouchIdForLogin(){
        
        if defaults.object(forKey: "touchIdFlag") != nil && self.NotAgainCallTouchId == false{
            
            if defaults.object(forKey: "touchIdFlag") as! String == "0"{
                let  AC = UIAlertController(title: GlobalData.sharedInstance.language(key: "alert"), message: GlobalData.sharedInstance.language(key: "wouldyouliketoconnectappwithtouchid"), preferredStyle: .alert)
                let okBtn = UIAlertAction(title: GlobalData.sharedInstance.language(key: "ok"), style:.default, handler: {(_ action: UIAlertAction) -> Void in
                    self.configureTouchIdafterLogin()
                })
                let cancelBtn = UIAlertAction(title: GlobalData.sharedInstance.language(key: "cancel"), style: .destructive, handler: {(_ action: UIAlertAction) -> Void in
                    self.defaults.set("0", forKey: "touchIdFlag")
                    self.defaults.synchronize()
                    self.tabBarController?.tabBar.isHidden = false
                    self.navigationController?.popViewController(animated: true)
                })
                AC.addAction(okBtn)
                AC.addAction(cancelBtn)
                self.parent!.present(AC, animated: true, completion: {  })
                
            }else if defaults.object(forKey: "touchIdFlag") as! String == "1" {
                let  AC = UIAlertController(title: GlobalData.sharedInstance.language(key: "alert"), message: GlobalData.sharedInstance.language(key: "wouldyouliketoreset"), preferredStyle: .alert)
                let okBtn = UIAlertAction(title: GlobalData.sharedInstance.language(key: "ok"), style:.default, handler: {(_ action: UIAlertAction) -> Void in
                    self.configureTouchIdafterLogin();
                })
                let cancelBtn = UIAlertAction(title: GlobalData.sharedInstance.language(key: "cancel"), style: .destructive, handler: {(_ action: UIAlertAction) -> Void in
                    self.defaults.set("1", forKey: "touchIdFlag");
                    self.defaults.synchronize()
                    self.tabBarController?.tabBar.isHidden = false
                    self.navigationController?.popViewController(animated: true)
                })
                AC.addAction(okBtn)
                AC.addAction(cancelBtn)
                self.parent!.present(AC, animated: true, completion: {  })
            }else{
                self.tabBarController?.tabBar.isHidden = false
                self.navigationController?.popViewController(animated: true)
            }
        }else{
            self.tabBarController?.tabBar.isHidden = false
            self.navigationController?.popViewController(animated: true)
        }
    }
    
    func showTwoFactorVeryFicationDialogue(resData:AnyObject){
        
        let respDict = JSON(resData as! NSDictionary)
        
        var verificationMode = ""
        if respDict["tfa_value"].stringValue == "email"{
            verificationMode = respDict["email"].stringValue
        }else{
            verificationMode = respDict["mobile"].stringValue
        }
        
        //let userEmail = respDict["customerEmail"].stringValue
        let userToken = respDict["customerToken"].stringValue
        //let defaults = respDict["customerName"].stringValue
        
        let dynlblHeight = 50
        let heightBeforeOTP = 30 + dynlblHeight + 0 + 60
        let heightAfterOTP = 30 + dynlblHeight + 120 + 60 + 60
        //let popViewHeight = 160
        let vc = AppStoryboard.Main.instance.instantiateViewController(withIdentifier: "TFAuthPopUpViewController") as! TFAuthPopUpViewController
        vc.modeType = verificationMode
        vc.isModeSelected = false
        vc.userStoreId = "1"
        vc.userToken = userToken
        
        let popupVC = PopupViewController(contentController: vc, popupWidth:SCREEN_WIDTH-100, popupHeight: CGFloat(heightBeforeOTP))
        popupVC.backgroundAlpha = 0.4
        popupVC.backgroundColor = .black
        popupVC.canTapOutsideToDismiss = true
        popupVC.cornerRadius = 10
        popupVC.shadowEnabled = false
        self.present(popupVC, animated: true)
        
        vc.popUpCallBackOnGettingOTP = {(otpCode) in
            
            var recievedOtpCode = otpCode
            let vc = AppStoryboard.Main.instance.instantiateViewController(withIdentifier: "TFAuthPopUpViewController") as! TFAuthPopUpViewController
            vc.modeType = verificationMode
            vc.isModeSelected = true
            vc.userStoreId = "1"
            vc.userToken = userToken
            
            let popupVC = PopupViewController(contentController: vc, popupWidth:SCREEN_WIDTH-100, popupHeight: CGFloat(heightAfterOTP))
            popupVC.backgroundAlpha = 0.4
            popupVC.backgroundColor = .black
            popupVC.canTapOutsideToDismiss = true
            popupVC.cornerRadius = 10
            popupVC.shadowEnabled = false
            self.present(popupVC, animated: true)
            
            vc.popUpCallBackOnUpdateOTP = {(newOtpCode) in
                recievedOtpCode = newOtpCode
            }
            
            vc.popUpCallBackOnSubmitOTP = {(otpCode) in
                if otpCode == recievedOtpCode {
                    print("Go To DashBoard")
                    popupVC.dismiss(animated:true) {
                        self.updateDashBoardView(data:resData)
                    }
                }else{
                    AlertManager.shared.showInfoSnackBar(msg:"Please enter correct OTP")
                }
            }
        }
        
    }
    
    @IBAction func signupClick(_ sender: UIButton) {
        self.performSegue(withIdentifier: "createaccount", sender: self)
    }
    
    @IBAction func forgaotPasswordClick(_ sender: Any) {
        let AC = UIAlertController(title:GlobalData.sharedInstance.language(key:"enteremail"), message: "", preferredStyle: .alert)
        AC.addTextField { (textField) in
            textField.placeholder = GlobalData.sharedInstance.language(key:"enteremail");
        }
        let okBtn = UIAlertAction(title: GlobalData.sharedInstance.language(key:"ok"), style: .default, handler: {(_ action: UIAlertAction) -> Void in
            let textField = AC.textFields![0]
            if((textField.text?.count)! < 1){
                AlertManager.shared.showErrorSnackBar(msg:GlobalData.sharedInstance.language(key:"pleasefillemailid") )
            }else if  !GlobalData.sharedInstance.checkValidEmail(data: textField.text!){
                AlertManager.shared.showErrorSnackBar(msg:GlobalData.sharedInstance.language(key: "pleaseentervalidemail"));
            }else{
                self.userEmail = textField.text!;
                self.whichApiToProcess = "forgotpassword"
                self.callingHttppApi()
            }
        })
        let noBtn = UIAlertAction(title: GlobalData.sharedInstance.language(key:"cancel"), style:.destructive, handler: {(_ action: UIAlertAction) -> Void in
        })
        AC.addAction(okBtn)
        AC.addAction(noBtn)
        self.present(AC, animated: true, completion: {  })
    }
    
    @IBAction func LoginClick(_ sender: UIButton) {
        view.endEditing(true)
        emailId = emailIdField.text!
        password = passwordtextField.text!
        var isValid = 0
        var errorMessage = ""
        if !GlobalData.sharedInstance.checkValidEmail(data: emailId){
            isValid = 1
            errorMessage = GlobalData.sharedInstance.language(key: "please enter valid email");
        }else if password == ""{
            isValid = 1
            errorMessage = GlobalData.sharedInstance.language(key: "enter password");
        }
        if isValid == 1{
            AlertManager.shared.showErrorSnackBar(msg: errorMessage)
        }else{
            whichApiToProcess = ""
            callingHttppApi()
        }
    }
    
    //MARK:- Touch ID
    
    ///////////////////////////////////After Login we are setting//////////////////// /////////////////////////////////////////////////////////////////////////////////
    
    func configureTouchIdafterLogin(){
        
        var policy: LAPolicy?
        if #available(iOS 9.0, *) {
            // iOS 9+ users with Biometric and Passcode verification
            policy = .deviceOwnerAuthentication
        } else {
            // iOS 8+ users with Biometric and Custom (Fallback button) verification
            context.localizedFallbackTitle = ""
            policy = .deviceOwnerAuthenticationWithBiometrics
        }
        var err: NSError?
        guard context.canEvaluatePolicy(policy!, error: &err) else {
            print("sfsf")
            
            //Touch Id not set in device
            let  AC = UIAlertController(title: "Error", message: GlobalData.sharedInstance.language(key: "touchidisnotenabledinyourdevice"), preferredStyle: .alert)
            let okBtn = UIAlertAction(title: "OK", style:.default, handler: {(_ action: UIAlertAction) -> Void in
                self.goToDashBoardWithoutTouchId()
            })
            AC.addAction(okBtn)
            self.parent!.present(AC, animated: true, completion: {  })
            return
        }
        
        loginProcessAfterLogin(policy: policy!)
    }
    
    private func loginProcessAfterLogin(policy: LAPolicy) {
        // Start evaluation process with a callback that is executed when the user ends the process successfully or not
        context.evaluatePolicy(policy, localizedReason: kMsgShowReason, reply: { (success, error) in
            DispatchQueue.main.async {
                
                guard success else {
                    guard let error = error else {
                        self.showUnexpectedErrorMessageAfterLogin()
                        return
                    }
                    switch(error) {
                    case LAError.authenticationFailed:
                        self.errorMessage = GlobalData.sharedInstance.language(key: "therewasaproblemverifyingyouridentity")
                    case LAError.userCancel:
                        self.errorMessage = GlobalData.sharedInstance.language(key: "authenticationwascanceledbyuser")
                    default:
                        self.errorMessage = GlobalData.sharedInstance.language(key: "touchidmaynotbeconfigured")
                        break
                    }
                    
                    let  AC = UIAlertController(title: GlobalData.sharedInstance.language(key: "error"), message: self.errorMessage, preferredStyle: .alert)
                    let okBtn = UIAlertAction(title: GlobalData.sharedInstance.language(key: "ok"), style:.default, handler: {(_ action: UIAlertAction) -> Void in
                        self.goToDashBoardWithoutTouchId()
                    })
                    AC.addAction(okBtn)
                    self.parent!.present(AC, animated: true, completion: {  })
                    return
                }
                // Good news! Everything went fine 👏
                self.goToDashBoardWithTouchId()
            }
        })
    }
    
    func goToDashBoardWithoutTouchId(){
        defaults.set("0", forKey: "touchIdFlag");
        defaults.synchronize()
        self.tabBarController?.tabBar.isHidden = false
        self.navigationController?.popViewController(animated: true)
    }
    
    func goToDashBoardWithTouchId(){
        defaults.set("1", forKey: "touchIdFlag");
        defaults.set(emailId, forKey: "TouchEmailId")
        defaults.set(password, forKey: "TouchPasswordValue")
        defaults.synchronize()
        self.tabBarController?.tabBar.isHidden = false
        self.navigationController?.popViewController(animated: true)
    }
    
    func showUnexpectedErrorMessageAfterLogin(){
        let  AC = UIAlertController(title: GlobalData.sharedInstance.language(key: "error"), message: GlobalData.sharedInstance.language(key: "erroroccured"), preferredStyle: .alert)
        let okBtn = UIAlertAction(title: GlobalData.sharedInstance.language(key: "ok"), style:.default, handler: {(_ action: UIAlertAction) -> Void in
            self.tabBarController?.tabBar.isHidden = false
            self.navigationController?.popViewController(animated: true)
        })
        AC.addAction(okBtn)
        self.parent!.present(AC, animated: true, completion: {  })
    }
    
    /////////////////////   before Login we are setting /////////////////////////////////////////////////////////////////////////////////
    func configureTouchIdBeforeLogin(){
        var policy: LAPolicy?
        policy = .deviceOwnerAuthenticationWithBiometrics
        context.localizedFallbackTitle = ""
        
        var err: NSError?
        guard context.canEvaluatePolicy(policy!, error: &err) else {
            return
        }
        loginProcessBeforeLogin(policy: policy!)
    }
    
    private func loginProcessBeforeLogin(policy: LAPolicy) {
        // Start evaluation process with a callback that is executed when the user ends the process successfully or not
        context.evaluatePolicy(policy, localizedReason: kMsgShowReason, reply: { (success, error) in
            DispatchQueue.main.async {
                
                guard success else {
                    guard let error = error else {
                        self.showUnexpectedErrorMessageBeforeLogin()
                        return
                    }
                    switch(error) {
                    case LAError.authenticationFailed:
                        self.errorMessage = GlobalData.sharedInstance.language(key: "therewasaproblemverifyingyouridentity")
                    case LAError.userCancel:
                        self.errorMessage = GlobalData.sharedInstance.language(key: "authenticationwascanceledbyuser")
                        
                    default:
                        self.errorMessage = GlobalData.sharedInstance.language(key: "touchidmaynotbeconfigured")
                        break
                    }
                    let  AC = UIAlertController(title: GlobalData.sharedInstance.language(key: "error"), message: self.errorMessage, preferredStyle: .alert)
                    let okBtn = UIAlertAction(title: GlobalData.sharedInstance.language(key: "ok"), style:.default, handler: {(_ action: UIAlertAction) -> Void in
                        
                    })
                    AC.addAction(okBtn)
                    self.parent!.present(AC, animated: true, completion: {  })
                    return
                }
                // Good news! Everything went fine 👏
                self.callApiWithSavedCredential()
            }
        })
    }
    
    func showUnexpectedErrorMessageBeforeLogin(){
        let  AC = UIAlertController(title: GlobalData.sharedInstance.language(key: "error"), message: GlobalData.sharedInstance.language(key: "erroroccured"), preferredStyle: .alert)
        let okBtn = UIAlertAction(title: GlobalData.sharedInstance.language(key: "ok"), style:.default, handler: {(_ action: UIAlertAction) -> Void in
            
        })
        AC.addAction(okBtn)
        self.parent!.present(AC, animated: true, completion: {  })
    }
    
    func callApiWithSavedCredential(){
        emailId = defaults.object(forKey: "TouchEmailId") as! String
        password = defaults.object(forKey: "TouchPasswordValue") as! String
        emailIdField.text = defaults.object(forKey: "TouchEmailId") as? String
        passwordtextField.text = defaults.object(forKey: "TouchPasswordValue") as? String
        NotAgainCallTouchId = true
        whichApiToProcess = ""
        callingHttppApi()
    }
    
    func createUserAccountWith(fullName:String, emailId:String, profilePicUrl:String){
        
        if emailId == "" {
            AlertManager.shared.showSuccessSnackBar(msg:"Email Id not found please try to login with other account")
            return
        }

        // create account with social info
        GlobalData.sharedInstance.showLoader()
        self.view.isUserInteractionEnabled = false
        
        var requstParams = [String:Any]()
        requstParams["storeId"] = UserManager.getStoreId
        requstParams["quoteId"] = UserManager.getQuoteId
        requstParams["token"] = UserManager.getDeviceToken
        requstParams["websiteId"] = UserManager.getWebsiteId
        
        requstParams["firstName"] = fullName.splitName()[0]
        requstParams["lastName"] = fullName.splitName()[1]
        requstParams["email"] = emailId
        requstParams["password"] = AppFunction.randomPasswordGenerater(length:10)
        requstParams["prefix"] = ""
        requstParams["suffix"] = ""
        requstParams["middleName"] = ""
        requstParams["mobile"] = ""
        requstParams["dob"] = ""
        requstParams["taxvat"] = ""
        requstParams["isSocial"] = "1"
        requstParams["pictureURL"] = profilePicUrl
        requstParams["gender"] = ""
        requstParams["becomeSeller"] = "0"
        requstParams["shopUrl"] = ""
        //requstParams["storeName"] = shopNameTextField.text
        requstParams["becomeSeller"] = "1"

        //let width = String(format:"%f", SCREEN_WIDTH * UIScreen.main.scale)
        requstParams["width"] = UserManager.getDeviceWidth
        
        APIServiceManager.shared.callingHttpRequest(params:requstParams, apiname:AfritiaAPI.createAccount, currentView: self){success,responseObject in
                
                if success == 1
                {
                    print(responseObject!)
                    GlobalData.sharedInstance.dismissLoader()
                    self.view.isUserInteractionEnabled = true
                    let dict = JSON(responseObject as! NSDictionary)
                    if dict["success"].boolValue == true{
                        
                        self.defaults.set(dict["customerEmail"].stringValue, forKey: "customerEmail")
                        self.defaults.set(dict["customerToken"].stringValue, forKey: "customerId")
                        self.defaults.set(dict["customerName"].stringValue, forKey: "customerName")
                        if(self.defaults.object(forKey: "quoteId") != nil){
                            self.defaults.set(nil, forKey: "quoteId")
                            self.defaults.synchronize()
                        }
                        
                        UserDefaults.standard.removeObject(forKey: "quoteId")
                        if dict["isSeller"].intValue == 0{
                            self.defaults.set("f", forKey: "isSeller")
                        }else{
                            self.defaults.set("t", forKey: "isSeller")
                        }
                        
                        if dict["isPending"].intValue == 0{
                            self.defaults.set("f", forKey: "isPending")
                            
                        }else{
                            self.defaults.set("t", forKey: "isPending")
                        }
                        
                        if dict["isAdmin"].intValue == 0{
                            self.defaults.set("f", forKey: "isAdmin")
                        }else{
                            self.defaults.set("t", forKey: "isAdmin")
                        }
                        
                        self.defaults.synchronize()
                        AlertManager.shared.showSuccessSnackBar(msg: dict["message"].stringValue)
                        
//                        if self.movetoSignal == "cart"{
//                            self.performSegue(withIdentifier: "checkout", sender: self)
//                        }
                        
                        self.tabBarController?.tabBar.isHidden = false
                        self.navigationController?.popToRootViewController(animated:true)
                        
                    }else{
                        AlertManager.shared.showErrorSnackBar(msg: dict["message"].stringValue)
                    }
                }else if success == 2{
                    GlobalData.sharedInstance.dismissLoader()
                    self.callingHttppApi()
                }
            }
    }
    
    @IBAction func loginWithGoogle(_ sender:UIButton){
        GIDSignIn.sharedInstance().signIn()
    }
    
//    @IBAction func loginWithFacebook(_ sender:UIButton){
//        //fbLoginButton.sendActions(for: .touchUpInside)
//        //self.faceBookLoginWithManager()
//
//        let fbManager = LoginManager()
//        fbManager.logOut()
//
//        let readPermissions: [Permission] = [.publicProfile, .email]
//            let sdkPermissions = readPermissions.map({ $0.name })
//
//        fbManager.logIn(permissions: sdkPermissions, from: nil) { (result, error) in
//            if let token = result?.token {
//                // your token here
//                print("TOKEN:\(token.tokenString)")
//
//                let request = FBSDKLoginKit.GraphRequest(graphPath:"me",
//                                                         parameters:["fields":"email,name,picture.type(large)"],
//                                                         tokenString:token.tokenString,
//                                                         version:nil,
//                                                         httpMethod:.get)
//
//                request.start { (connection, result, error) in
//                   // print("RESULT:::\(result!)")
//
//                    if let userInfo = result as? NSDictionary {
//
//                        var userId = ""
//                        var userName = ""
//                        var userEmail = ""
//                        var userProfilePic = ""
//
//                        if let profilePic = ((userInfo["picture"] as? [String: Any])?["data"] as? [String: Any])?["url"] as? String {
//                            userProfilePic = profilePic
//
//                            }
//
//                        if let id = userInfo["id"] as? String {
//                            userId = id
//                        }
//
//                        if let name = userInfo["name"] as? String {
//                            userName = name
//                        }
//
//                        if let email = userInfo["email"] as? String {
//                            userEmail = email
//                        }
//
//                        print("ID:\(userId)")
//                        print("NAME:\(userName)")
//                        print("EMAIL:\(userEmail)")
//                        print("IMAGE:\(userProfilePic)")
//
//                        self.createUserAccountWith(fullName:userName, emailId:userEmail, profilePicUrl: userProfilePic)
//
//                    }else{
//                        print(error?.localizedDescription as Any)
//                    }
//                }
//            }
//            else {
//            }
//        }
//    }
    
    /*
    func faceBookLoginWithManager()
    {
        let loginManager = LoginManager()
        //let getPermission = ["email","id","first_name","last_name","name","picture.type(large)","birthday","gender","hometown"]
        loginManager.logIn(permissions: ["public_profile","email","id","name","picture.type(large)"], viewController: self, completion: { loginResult in

         switch loginResult {
            case .failed(let error):
                print("\(error)")
            case .cancelled:
                print("cancelled")
            case .success(let grantedPermissions, let declinedPermissions, let accessToken):
                print("\(grantedPermissions) \(declinedPermissions) \(accessToken.tokenString)")
                //self.getUserDataFromFacebook()
                
                
                if grantedPermissions.contains("email")
                {
                    if (AccessToken.current != nil)
                    {
                        GraphRequest(graphPath:"me", parameters:["fields":"email,name"]).start { (connection, result, error) in
                            print("EMAIL RESULT:\(result!)")
                        }
                    }
                }
            }
        })
    }
     */
    

    @IBAction func loginWithApple(_ sender:UIButton){
        
        if #available(iOS 13.0, *) {
            let appleIdProvider = ASAuthorizationAppleIDProvider()
            let request = appleIdProvider.createRequest()
            let authorizationController = ASAuthorizationController(authorizationRequests:[request])
            //authorizationController.delegate = self
            authorizationController.performRequests()
            request.requestedScopes = [.fullName, .email]
            
        } else {
            // Fallback on earlier versions
        }
    }
    
    @IBAction func loginWithTwitter(_ sender:UIButton){
        /*
        var userId = ""
        var userName = ""
        var userEmail = ""
        var userProfilePic = ""
        
        TWTRTwitter.sharedInstance().logIn(with: self) { (session, error) in
            
            if error != nil {
                print(error?.localizedDescription ?? "No Error")
            }
            else
            {
                if let userSession = session {
                    userId = userSession.userID
                    userName = userSession.userName
                    //
                    print("Id:\(userSession.userID)")
                    print("Name:\(userSession.userName)")
                    
                    //request for email
                    let client = TWTRAPIClient.withCurrentUser()
                    client.requestEmail { (email, error) in
                        
                        if error != nil{
                            print(error?.localizedDescription ?? "No Error")
                        }else{
                            
                            if let email = email {
                                userEmail = email
                                print("Email:\(userEmail)")
                                
                                client.loadUser(withID: userId) { (user, error) in
                                    
                                    if error != nil{
                                        print(error?.localizedDescription ?? "No Error")
                                    }else{
                                        
                                        if let twitUser = user {
                                            userProfilePic = twitUser.profileImageURL
                                            print("ProfilePic:\(userProfilePic)")
                                            //go for regidtration
                                            self.createUserAccountWith(fullName:userName, emailId:userEmail, profilePicUrl: userProfilePic)
                                        }
                                            
                                        }
                                    }
                                
                                }
                                
                            }
                        }
                    
                    }
                }
            
            }
        }*/
    }
    
    /*
    func getUserDataFromFacebook()
    {
        if let accessToken = AccessToken.current {
            print("User is Already Logged In:\(accessToken.tokenString)")
            
            let req = GraphRequest(graphPath: "me", parameters: ["fields":"email,id,first_name,last_name,name,picture.type(large),birthday,gender,hometown"], tokenString: accessToken.tokenString, version:nil, httpMethod: HTTPMethod(rawValue: "GET"))
            
            req.start { (connection, result, error) in
                if(error == nil) {
                     print("result \(result!)")
                    
                    /*if let fields = result as? [String:Any] {
                        let id = fields["id"] as! String
                        
                        let emailReq = GraphRequest(graphPath:id, parameters: ["fields":"email"], tokenString: accessToken.tokenString, version:nil, httpMethod: HTTPMethod(rawValue: "GET"))
                        emailReq.start { (connection, result, error) in
                            if(error == nil) {
                                 print("result \(result!)")
                            } else {
                                print("error \(error!.localizedDescription)")
                            }
                        }
                    }*/
                }
                else
                {
                    print("error \(error!.localizedDescription)")
                }
            }
            
            GraphRequest(graphPath: "me", parameters: ["fields": "first_name, last_name, picture, id, email"]).start { (connection, result, error) in
                if let err = error
                { print(err.localizedDescription); return }
                else
                {
                    if let fields = result as? [String:Any] {
                        
                        print(fields as NSDictionary)
                        
                        let id = fields["id"] as! String
                        let firstName = fields["first_name"] as! String
                        let lastName = fields["last_name"] as! String
                        let emailId = fields["email"] as! String
                        let facebookProfileString = "http://graph.facebook.com/\(id)/picture?type=large"
                        print(id, emailId, firstName, lastName, facebookProfileString)
                    }
                }
            }
        }
    }*/
    
}

extension CustomerLogin : GIDSignInDelegate {
    
    func sign(_ signIn: GIDSignIn!, didSignInFor user: GIDGoogleUser!, withError error: Error!) {
        print("Google Sing In didSignInForUser")
      if let error = error {
        print(error.localizedDescription)
        return
      }
        
        guard let authentication = user.authentication else { return }
        
        authentication.getTokensWithHandler { (authentication, error) in
            
            if let error = error {
              print("Login error: \(error.localizedDescription)")
              return
            }
            
            guard let authentication = user.authentication else { return }
            let accessToken = authentication.accessToken
            let idToken = authentication.idToken
            
            print("Access Token: \(accessToken ?? "No ACCESS TOKEN FOUND")")
            print("id Token: \(idToken ?? "NO ID TOKEN FOUND")")
            
            print("profile name : \(user.profile.name ?? "No Name found")")
            print("profile email : \(user.profile.email ?? "No Email found")")
            
            var userName = ""
            var userEmailId = ""
            var userPictureUrl = ""
            
            if let name = user.profile.name {
                userName = name
            }

            if let email = user.profile.email {
                userEmailId = email
            }
            
            if user.profile.hasImage {
                userPictureUrl = user.profile.imageURL(withDimension: 100).absoluteString
                print("profile image URL : \(userPictureUrl)")
            }else{
                print("profile image not found")
            }
            
            self.createUserAccountWith(fullName: userName, emailId: userEmailId, profilePicUrl: userPictureUrl)
            
        }
    }
    
    // Start Google OAuth2 Authentication
    func sign(_ signIn: GIDSignIn?, present viewController: UIViewController?) {
      // Showing OAuth2 authentication window
      if let aController = viewController {
        present(aController, animated: true) {() -> Void in }
      }
    }
    
    // After Google OAuth2 authentication
    func sign(_ signIn: GIDSignIn?, dismiss viewController: UIViewController?) {
      // Close OAuth2 authentication window
      dismiss(animated: true) {() -> Void in }
    }
}

//extension CustomerLogin: LoginButtonDelegate {
//    
//    func loginButton(_ loginButton: FBLoginButton, didCompleteWith result: LoginManagerLoginResult?, error: Error?) {
//        
//        if let token = result?.token?.tokenString{
//            print("AccessToken:\(token)")
//            
//            let request = FBSDKLoginKit.GraphRequest(graphPath:"me",
//                                                     parameters:["fields": "first_name, last_name, picture, id, email"],
//                                                     tokenString:token,
//                                                     version:nil,
//                                                     httpMethod:.get)
//            
//            request.start { (connection, result, error) in
//                print("\(result!)")
//            }
//        }
//    }
//    
//    func loginButtonDidLogOut(_ loginButton: FBLoginButton) {
//        print("User logged out")
//    }
//}


@available(iOS 13.0, *)
extension CustomerLogin : ASAuthorizationControllerDelegate {
    
    func authorizationController(controller: ASAuthorizationController, didCompleteWithAuthorization authorization: ASAuthorization) {
        
        guard let credential = authorization.credential as? ASAuthorizationAppleIDCredential else { return }

        /*
        var userId = ""
        var tokenId = ""
        var authPass = ""
        var userStatus = ""
        var userEmail = ""
        var userName = ""
        */
        
            let userIdentifier = credential.user
            let token = credential.identityToken
            let authCode = credential.authorizationCode
            let realUserStatus = credential.realUserStatus
            let mail = credential.email // nil
            let name = credential.fullName?.familyName // nil
        
        print(userIdentifier, token!, authCode!, realUserStatus, mail!, name!)
        
        self.createUserAccountWith(fullName:name! , emailId: mail!, profilePicUrl:"")
    }
    
    func authorizationController(controller: ASAuthorizationController, didCompleteWithError error: Error) {
        print("Error:\(error.localizedDescription)")
    }
}



