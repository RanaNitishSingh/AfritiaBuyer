//
//  AccountInformation.swift
//  Magento2MobikulNew
//
//  Created by Webkul  on 21/08/17.
//  Copyright © 2017 Webkul . All rights reserved.
//

import UIKit
import UIFloatLabelTextField

class AccountInformation: AfritiaBaseViewController, UIPickerViewDelegate,UIPickerViewDataSource, UITextViewDelegate {
    let defaults = UserDefaults.standard;
    var accountInfoModel:AccountInformationModel!
    
    @IBOutlet weak var prefixTextField: UITextField!
    @IBOutlet weak var prefixtextFieldHeightConstarints: NSLayoutConstraint!
    @IBOutlet weak var afritiaNavBarView: AFNavigationBarView!
    @IBOutlet weak var afritiaNavBarViewHeight:NSLayoutConstraint!
    
    @IBOutlet weak var firstNameTextField: UITextField!
    @IBOutlet weak var middleNameTextField: UITextField!
    @IBOutlet weak var middleNameTextFieldHeightConstarints: NSLayoutConstraint!
    @IBOutlet weak var lasttNametextField: UITextField!
    @IBOutlet weak var suffixtextField: UITextField!
    @IBOutlet weak var suffixtextFieldHeightConstarints: NSLayoutConstraint!
    @IBOutlet weak var emailtextField: UITextField!
    @IBOutlet weak var mobileNumbertextFeild: UITextField!
    @IBOutlet weak var mobileNumberTextFeildheightConstarints: NSLayoutConstraint!
    @IBOutlet weak var dobTextFeild: UITextField!
    @IBOutlet weak var dobTextFeildheightConstarints: NSLayoutConstraint!
    @IBOutlet weak var taxValuetextField: UITextField!
    @IBOutlet weak var taxValueHeightConstarints: NSLayoutConstraint!
    @IBOutlet weak var genderTextFeild: UITextField!
    @IBOutlet weak var genderTextFeildHeightConstarints: NSLayoutConstraint!
    
    @IBOutlet weak var currentPasswordTextField: HideShowPasswordTextField!
    @IBOutlet weak var passwordtextFeildHeightConstarints: NSLayoutConstraint!
    
    @IBOutlet weak var confirmtextFeild: HideShowPasswordTextField!
    @IBOutlet weak var confirmtextFeildHeightConstarints: NSLayoutConstraint!
    
    @IBOutlet weak var confirmNewTextField: HideShowPasswordTextField!
    
    @IBOutlet weak var confirmNewTextFieldHeightConstarints: NSLayoutConstraint!
    
    @IBOutlet weak var saveButton: UIButton!
//    @IBOutlet weak var mainViewHeightConstarints: NSLayoutConstraint!
    
    @IBOutlet weak var changePasswordLabel: UILabel!
    
    @IBOutlet weak var mainView: UIView!
    @IBOutlet weak var changeEmailLabel: UILabel!
    
    //GDPR
    @IBOutlet weak var gdprStackView: UIStackView!
    @IBOutlet weak var gdprTxtView: UITextView!
    @IBOutlet weak var gdprDownlaodBtn : UIButton!
    @IBOutlet weak var checkBoxBtn : UIButton!
    
    var keyBoardFlag:Int = 1
    var prefixValueArray:NSArray = []
    var suffixValueArray:NSArray = []
    var genderValueArray:NSMutableArray = [];
    var changePasswordFlag:Bool = false
    var whichApiToProcess:String = ""
    var changeEmailFlag:Bool = false
    var documentPathUrl: NSURL!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //self.navigationController?.isNavigationBarHidden = false
        //self.navigationController?.navigationBar.applyAfritiaTheme()
        //self.navigationItem.title = appLanguage.localize(key: "myaccountinformation")
        
        self.setUpCustomNavigationBar()
        
        passwordtextFeildHeightConstarints.constant = 0
        confirmtextFeildHeightConstarints.constant = 0
        confirmNewTextFieldHeightConstarints.constant = 0
//        self.mainViewHeightConstarints.constant = 600;
        APIServiceManager.shared.removePreviousNetworkCall()
        GlobalData.sharedInstance.dismissLoader()
        self.callingHttppApi()
        
        prefixTextField.applyAfritiaTheme()
        prefixTextField.placeholder = appLanguage.localize(key: "prefix")
        firstNameTextField.applyAfritiaTheme()
        firstNameTextField.placeholder = appLanguage.localize(key: "firstname")
        middleNameTextField.applyAfritiaTheme()
        middleNameTextField.placeholder = appLanguage.localize(key: "middlename")
        lasttNametextField.applyAfritiaTheme()
        lasttNametextField.placeholder = appLanguage.localize(key: "lastname")
        suffixtextField.applyAfritiaTheme()
        suffixtextField.placeholder = appLanguage.localize(key: "suffix")
        emailtextField.applyAfritiaTheme()
        emailtextField.placeholder = appLanguage.localize(key: "email")
        mobileNumbertextFeild.applyAfritiaTheme()
        mobileNumbertextFeild.placeholder = appLanguage.localize(key: "mobileno")
        dobTextFeild.applyAfritiaTheme()
        dobTextFeild.placeholder = appLanguage.localize(key: "dob")
        taxValuetextField.applyAfritiaTheme()
        taxValuetextField.placeholder = appLanguage.localize(key: "taxvat")
        genderTextFeild.applyAfritiaTheme()
        genderTextFeild.placeholder = appLanguage.localize(key: "gender")
        currentPasswordTextField.applyAfritiaTheme()
        currentPasswordTextField.placeholder = appLanguage.localize(key: "currentpassword")
        confirmtextFeild.applyAfritiaTheme()
        confirmtextFeild.placeholder = "New Password"//appLanguage.localize(key: "confirmpassword")
        confirmNewTextField.applyAfritiaTheme()
        confirmNewTextField.placeholder = appLanguage.localize(key: "confirmnewpassword")
        
        
        changePasswordLabel.text = appLanguage.localize(key: "changepassword")
        changeEmailLabel.text = appLanguage.localize(key: "changeemail")
        
        let textAliginByLang = UITextField().setTextAlignmentByLanguage()
        
        prefixTextField.textAlignment = textAliginByLang
        firstNameTextField.textAlignment = textAliginByLang
        middleNameTextField.textAlignment = textAliginByLang
        lasttNametextField.textAlignment = textAliginByLang
        suffixtextField.textAlignment = textAliginByLang
        emailtextField.textAlignment = textAliginByLang
        dobTextFeild.textAlignment = textAliginByLang
        taxValuetextField.textAlignment = textAliginByLang
        currentPasswordTextField.textAlignment = textAliginByLang
        confirmtextFeild.textAlignment = textAliginByLang
        confirmNewTextField.textAlignment = textAliginByLang
        genderTextFeild.textAlignment = textAliginByLang
        mobileNumbertextFeild.textAlignment = textAliginByLang
        self.mainView.isHidden = true;
        
        
        saveButton.applyAfritiaTheme()
        saveButton.setTitle("save".localized, for: .normal)
        
        gdprDownlaodBtn.applyAfritiaTheme()
        gdprDownlaodBtn.setTitle("downloadaccountinformation".localized, for: .normal)
        
        checkBoxBtn.layer.borderColor = UIColor.black.cgColor
        checkBoxBtn.layer.borderWidth = 1.0
        checkBoxBtn.setImage(nil, for: .normal)
        
        emailtextField.isEnabled = false
    }
    
    fileprivate func setUpCustomNavigationBar(){
        
        self.navigationController?.isNavigationBarHidden = true
        self.tabBarController!.tabBar.applyAfritiaTheme()
        
        self.changeStatusBarColor(color: UIColor.LightLavendar)
    
        afritiaNavBarView.configureLeftButton1(isVisible:true, btnType:.image, btnTitle:nil, btnImage:navIcon.back) { (btnTitle) in
            self.navigationController?.popViewController(animated:true)
        }
        afritiaNavBarView.configureLeftButton2(isVisible:false, btnType:.none, btnTitle:nil, btnImage:nil, actionHandler:nil)
        
        afritiaNavBarView.configureRightButton1(isVisible:true, btnType:.image, btnTitle:nil, btnImage:navIcon.cart) { (btnTitle) in
            self.showMyCart()
        }
        afritiaNavBarView.configureRightButton2(isVisible:false, btnType:.none, btnTitle:nil, btnImage:nil, actionHandler:nil)

        afritiaNavBarView.configure(isVisible:true, titleText:nil, titleType:.image, barStyle:.compact) { (searchBy) in
            if searchBy == SearchOpenBy.bar || searchBy == SearchOpenBy.searchBtn {
                self.showSearchStoreBySearchBar()
            }else if searchBy == SearchOpenBy.camera{
                self.showSearchStoreByCamera()
            }else if searchBy == SearchOpenBy.mic{
                self.showSearchStoreByMicrophone()
            }
        } styleHandler: { (style) in
            if style == .full{
                self.afritiaNavBarViewHeight.constant = NavBarHeight.full.rawValue
            }else if style == .compact{
                self.afritiaNavBarViewHeight.constant = NavBarHeight.compact.rawValue
            }
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        //self.navigationController?.isNavigationBarHidden = false
        if self.isMovingToParentViewController{
            print("4nd pushed")
        }else{
            print("clear the previous")
            APIServiceManager.shared.removePreviousNetworkCall()
            GlobalData.sharedInstance.dismissLoader()
        }
    }
    
    @IBAction func changeEmailClick(_ sender: UISwitch) {
        if sender.isOn{
            emailtextField.isEnabled = true
            changeEmailFlag = true
            passwordtextFeildHeightConstarints.constant = 50;
        }else{
            emailtextField.isEnabled = false
            changeEmailFlag = false
            if changePasswordFlag == false{
                passwordtextFeildHeightConstarints.constant = 0;
            }
        }
    }
    
    func callingHttppApi(){
        GlobalData.sharedInstance.showLoader()
        if whichApiToProcess == "customerEditPost"{
            var requstParams = [String:Any]();
            requstParams["storeId"] = defaults.object(forKey:"storeId") as! String
            requstParams["websiteId"] = DEFAULT_WEBSITE_ID
            requstParams["customerToken"] = defaults.object(forKey: "customerId") as! String
            requstParams["firstName"] = firstNameTextField.text
            requstParams["lastName"] = lasttNametextField.text
            requstParams["email"] = emailtextField.text
            requstParams["prefix"] = prefixTextField.text
            requstParams["suffix"] = suffixtextField.text
            requstParams["middleName"] = middleNameTextField.text
            requstParams["mobile"] = mobileNumbertextFeild.text
            requstParams["dob"] = dobTextFeild.text
            requstParams["taxvat"] = taxValuetextField.text
            requstParams["currentPassword"] = currentPasswordTextField.text
            var value:String = ""
            if genderTextFeild.text == "Male"{
                value = "1"
            }else if genderTextFeild.text == "Female"{
                value = "0"
            }
            requstParams["newPassword"] = confirmNewTextField.text
            requstParams["confirmPassword"] = confirmtextFeild.text
            if changePasswordFlag == true{
                requstParams["doChangePassword"] = "1"
            }else{
                requstParams["doChangePassword"] = "0"
            }
            
            if changeEmailFlag == true{
                requstParams["doChangeEmail"] = "1"
            }else{
                requstParams["doChangeEmail"] = "0"
            }
            
            requstParams["gender"] = value
            
            APIServiceManager.shared.callingHttpRequest(params:requstParams, apiname:AfritiaAPI.saveAccountInfo, currentView: self){success,responseObject in
                if success == 1{
                    
                    GlobalData.sharedInstance.dismissLoader()
                    
                    
                    let dict = responseObject as! NSDictionary
                    
                    print(dict)
                    if dict.object(forKey: "success") as! Bool == true{
                        GlobalData.sharedInstance.showSuccessMessageWithBack(view: self,message:dict.object(forKey: "message") as! String )
                        
                        if self.changeEmailFlag == true{
                            self.defaults.set(self.emailtextField.text, forKey: "customerEmail")
                        }
                        
                        let name = self.firstNameTextField.text!+" "+self.lasttNametextField.text!
                        self.defaults.set(name, forKey: "customerName")
                        self.defaults.synchronize()
                        self.navigationController?.popViewController(animated: true)
                        
                    }else{
                        AlertManager.shared.showErrorSnackBar(msg: dict.object(forKey: "message") as! String)
                    }
                    
                }else if success == 2{
                    GlobalData.sharedInstance.dismissLoader()
                    self.callingHttppApi()
                }
            }
        }else{
            var requstParams = [String:Any]();
            requstParams["storeId"] = defaults.object(forKey:"storeId") as! String
            requstParams["websiteId"] = DEFAULT_WEBSITE_ID
            requstParams["customerToken"] = defaults.object(forKey: "customerId") as! String
            APIServiceManager.shared.callingHttpRequest(params:requstParams, apiname:AfritiaAPI.accountInfoData, currentView: self){success,responseObject in
                if success == 1{
                    
                    print((responseObject as! NSDictionary))
                    self.accountInfoModel  = AccountInformationModel(data: JSON(responseObject as! NSDictionary))
                    self.doFurtherProcessingwithResult()
                }else if success == 2{
                    GlobalData.sharedInstance.dismissLoader()
                    self.callingHttppApi()
                }
            }
        }
    }
    
    @IBAction func selectPrefix(_ sender: UIFloatLabelTextField) {
        if accountInfoModel.isPrefixHasOption == true{
            let thePicker = UIPickerView()
            thePicker.tag = 1000;
            prefixTextField.inputView = thePicker
            thePicker.delegate = self
        }
    }
    
    @IBAction func selectSuffix(_ sender: Any) {
        if accountInfoModel.isPrefixHasOption == true{
            let thePicker = UIPickerView()
            thePicker.tag = 2000;
            suffixtextField.inputView = thePicker
            thePicker.delegate = self
        }
    }
    
    @IBAction func selctDob(_ sender: Any) {
        let datePickerView:UIDatePicker = UIDatePicker()
        datePickerView.tag = 4000;
        datePickerView.datePickerMode = UIDatePickerMode.date
        dobTextFeild.inputView = datePickerView
        datePickerView.addTarget(self, action: #selector(AccountInformation.datePickerFromValueChanged), for: UIControlEvents.valueChanged)
    }
    
    @objc func datePickerFromValueChanged(sender:UIDatePicker) {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = accountInfoModel.dateFormat
        dobTextFeild.text = dateFormatter.string(from: sender.date)
    }
    
    @IBAction func selectGender(_ sender: Any) {
        let thePicker = UIPickerView()
        thePicker.tag = 3000;
        genderTextFeild.inputView = thePicker
        thePicker.delegate = self
    }
    
    @IBAction func changePasswordClick(_ sender: UISwitch) {
        if sender.isOn{
            changePasswordFlag = true;
            passwordtextFeildHeightConstarints.constant = 50;
            confirmtextFeildHeightConstarints.constant = 50
            confirmNewTextFieldHeightConstarints.constant = 50
            
        }else{
            changePasswordFlag = false;
            if changeEmailFlag == false{
                passwordtextFeildHeightConstarints.constant = 0;
            }
            confirmtextFeildHeightConstarints.constant = 0
            confirmNewTextFieldHeightConstarints.constant = 0
        }
    }
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        if(pickerView.tag == 1000){
            return self.prefixValueArray.count;
        }else if(pickerView.tag == 2000){
            return self.suffixValueArray.count;
        }else if(pickerView.tag == 3000){
            return self.genderValueArray.count;
        }else{
            return 0
        }
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        if pickerView.tag == 1000{
            return prefixValueArray.object(at: row) as? String
            
        }else if pickerView.tag == 2000{
            return suffixValueArray.object(at: row) as? String
            
        }else if pickerView.tag == 3000{
            return genderValueArray.object(at: row) as? String
            
        }else{
            return ""
        }
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int){
        if(pickerView.tag == 1000){
            prefixTextField.text = prefixValueArray.object(at: row) as? String
        }else if(pickerView.tag == 2000){
            suffixtextField.text = suffixValueArray.object(at: row) as? String
        }else if(pickerView.tag == 3000){
            genderTextFeild.text = genderValueArray.object(at: row) as? String
        }
    }
    
    @IBAction func dismissKeyBoard(_ sender: Any) {
        view.endEditing(true)
    }
    
    func doFurtherProcessingwithResult(){
        GlobalData.sharedInstance.dismissLoader()
        self.mainView.isHidden = false;
        prefixTextField.text = accountInfoModel.receivePrefixValue
        firstNameTextField.text = accountInfoModel.firstName
        middleNameTextField.text = accountInfoModel.middleName
        lasttNametextField.text = accountInfoModel.lastName
        suffixtextField.text = accountInfoModel.receiveSuffixValue
        emailtextField.text = accountInfoModel.emailId
        mobileNumbertextFeild.text = accountInfoModel.mobileNumber
        dobTextFeild.text = accountInfoModel.dobValue
        taxValuetextField.text = accountInfoModel.taxValue
        
        prefixValueArray = accountInfoModel.prefixValue! as NSArray
        suffixValueArray = accountInfoModel.suffixValue! as NSArray
        if accountInfoModel.isGenderRequired{
            self.genderValueArray = ["Female", "Male"]
        }else{
            self.genderValueArray = ["Female", "Male",""]
        }
        
        let pos:Int = accountInfoModel.genderValue ?? 0
        genderTextFeild.text = self.genderValueArray[pos] as? String ?? ""
        
        prefixtextFieldHeightConstarints.constant = 0;
        middleNameTextFieldHeightConstarints.constant = 0
        suffixtextFieldHeightConstarints.constant = 0
        mobileNumberTextFeildheightConstarints.constant = 0
        dobTextFeildheightConstarints.constant = 0
        taxValueHeightConstarints.constant = 0
        genderTextFeildHeightConstarints.constant = 0
        
        var totalHeight:CGFloat = 0
        
        if accountInfoModel.isPrefixVisible{
            totalHeight += 50
            prefixtextFieldHeightConstarints.constant = 50
        }
        if accountInfoModel.isMiddleNameVisible{
            totalHeight += 50
            middleNameTextFieldHeightConstarints.constant = 50
        }
        if accountInfoModel.isSuffixVisible{
            totalHeight += 50
            suffixtextFieldHeightConstarints.constant = 50
        }
        if accountInfoModel.isMobileNumberVisible{
            totalHeight += 50
            mobileNumberTextFeildheightConstarints.constant = 50
        }
        if accountInfoModel.isDobVisible{
            totalHeight += 50
            dobTextFeildheightConstarints.constant = 50
        }
        if accountInfoModel.isTaxVisible{
            totalHeight += 50
            taxValueHeightConstarints.constant = 50
        }
        if accountInfoModel.isGenderVisible{
            totalHeight += 50
            genderTextFeildHeightConstarints.constant = 50
        }
        
        callGDPR()
        
//        self.mainViewHeightConstarints.constant += totalHeight
    }
    
    @IBAction func SaveClick(_ sender: UIButton) {
        
        if (accountInfoModel.gdprEnable && accountInfoModel.tncAccountEnable && checkBoxBtn.isSelected) || !accountInfoModel.gdprEnable {
            //GDPR disabled, GDPR enabled and selected
            var errorMessage = "";
            var isValid:Int = 1;
            if firstNameTextField.text == ""{
                isValid = 0;
                errorMessage = appLanguage.localize(key: "pleasefillfirstname")
            }
            else if lasttNametextField.text == ""{
                isValid = 0;
                errorMessage = appLanguage.localize(key: "pleasefilllastname")
            }
            else if emailtextField.text == ""{
                isValid = 0;
                errorMessage = appLanguage.localize(key: "pleasefillemailid")
            }
            else if changePasswordFlag == true{
                if currentPasswordTextField.text == ""{
                    isValid = 0;
                    errorMessage = appLanguage.localize(key: "pleasefillcurrentpassowrd")
                }
                if confirmtextFeild.text == ""{
                    isValid = 0;
                    errorMessage =  appLanguage.localize(key: "pleasefillnewpassword")
                }
                if confirmNewTextField.text == ""{
                    isValid = 0;
                    errorMessage =  appLanguage.localize(key: "pleasefillconfirmnewpassword")
                }
                if confirmNewTextField.text != confirmtextFeild.text{
                    isValid = 0;
                    errorMessage = appLanguage.localize(key: "passwordnotmatch")
                }
            }else if changeEmailFlag == true{
                if currentPasswordTextField.text == ""{
                    isValid = 0;
                    errorMessage = appLanguage.localize(key: "pleasefillcurrentpassowrd")
                }
            }
            if accountInfoModel.isPrefixRequired{
                if prefixTextField.text == ""{
                    isValid = 0;
                    errorMessage = appLanguage.localize(key: "plesefillprefix")
                }
            }
            if accountInfoModel.isSuffixRequired{
                if suffixtextField.text == ""{
                    isValid = 0;
                    errorMessage = appLanguage.localize(key: "plesefillsuffix")
                }
            }
            if accountInfoModel.isMobileNumberRequired{
                if mobileNumbertextFeild.text == ""{
                    isValid = 0;
                    errorMessage = appLanguage.localize(key: "pleasefillmobilenumber")
                }
            }
            if accountInfoModel.isDobRequired{
                if dobTextFeild.text == ""{
                    isValid = 0;
                    errorMessage = appLanguage.localize(key: "plesefilldob")
                }
            }
            if accountInfoModel.isTaxRequired{
                if taxValuetextField.text == ""{
                    isValid = 0;
                    errorMessage = appLanguage.localize(key: "plesefilltaxvat")
                }
            }
            if accountInfoModel.isGenderRequired{
                if genderTextFeild.text == ""{
                    isValid = 0;
                    errorMessage = appLanguage.localize(key: "plesefillgender")
                }
            }
            
            if isValid == 0{
                AlertManager.shared.showErrorSnackBar(msg:errorMessage)
            }else{
                whichApiToProcess = "customerEditPost"
                self.callingHttppApi()
            }
        }else{
            AlertManager.shared.showErrorSnackBar(msg: "pleaseagreetogdprtermsandconditions".localized)
        }
        
        
    }
}

//MARK:- GDPR
extension AccountInformation    {
    func callGDPR() {
        if accountInfoModel.gdprEnable && accountInfoModel.tncAccountEnable   {
            //GDPR terms and conditions button
            let firstPart = "ihavereadandagreeto".localized
            let tnc = "termsandconditions".localized
            let secondPart = "ofthewebsite".localized
            let range = ("\(firstPart)\(tnc)\(secondPart)" as NSString).range(of: "\(firstPart)\(tnc)\(secondPart)")
            
            // You must set the formatting of the link manually
            let linkAttributes: [NSAttributedStringKey: Any] = [
                .link: NSURL(string: "")!,
                .foregroundColor: UIColor.blue
            ]
            
            let attributedString = NSMutableAttributedString(string: "\(firstPart)\(tnc)\(secondPart)")
            // Set the 'click here' substring to be the link
            attributedString.setAttributes(linkAttributes, range: NSRange(location: firstPart.count, length: tnc.count))
            //            attributedString.addAttribute(.link, value: tnc, range: NSRange(location: firstPart.count, length: tnc.count))
            attributedString.addAttribute(.foregroundColor, value: UIColor.white , range: range)
            
            gdprTxtView.attributedText = attributedString
        }else{
            gdprTxtView.isHidden = true
            checkBoxBtn.isHidden = true
        }
        
        if accountInfoModel.gdprEnable && accountInfoModel.gdprRequestInfoBtn   {
            //GDPR download button
        }else{
            gdprDownlaodBtn.isHidden = true
            checkBoxBtn.isHidden = true
        }
    }
    
    @available(iOS 10.0, *)
    func textView(_ textView: UITextView, shouldInteractWith URL: URL, in characterRange: NSRange, interaction: UITextItemInteraction) -> Bool {
        //GDPR : Terms and Conditions
        
        let vc = self.storyboard?.instantiateViewController(withIdentifier: "GDPRWebViewController") as! GDPRWebViewController
        vc.backImg = takeScreenshot()
        vc.content = accountInfoModel.tncAccountContent
        self.navigationController?.present(vc, animated: true, completion: nil)
        
        return true
    }
    
    /// Takes the screenshot of the screen and returns the corresponding image
    ///
    /// - Parameter shouldSave: Boolean flag asking if the image needs to be saved to user's photo library. Default set to 'true'
    /// - Returns: (Optional)image captured as a screenshot
    open func takeScreenshot() -> UIImage? {
        self.tabBarController?.tabBar.isHidden = true
        var screenshotImage :UIImage?
        let layer = UIApplication.shared.keyWindow!.layer
        let scale = UIScreen.main.scale
        UIGraphicsBeginImageContextWithOptions(layer.frame.size, false, scale);
        guard let context = UIGraphicsGetCurrentContext() else {return nil}
        layer.render(in:context)
        screenshotImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        self.tabBarController?.tabBar.isHidden = false
        return screenshotImage
    }
    
    /*
    @IBAction func downloadFile(_ sender: UIButton)    {
        
        var fileName: String = ""
        let date = Date()
        let formatter = DateFormatter()
        
        formatter.dateFormat = "dd.MM.yyyy_HH:mm:ss"
        let  url: String = HOST_NAME+"mobikulgdpr/pdf/getcustomerinfo"
        fileName = "gdprCustomerInfo"+formatter.string(from: date)+".pdf"
        
        let post = NSMutableString()
        if let customerId = defaults.object(forKey: "customerId") as? String{
            post .appendFormat("customerToken=%@&", customerId as CVarArg)
        }
        
        self.load(url: URL(string: url)!, params: post as String, name: fileName)
    }
    
    func load(url: URL, params: String, name: String) {
        GlobalData.sharedInstance.showLoader()
        let sessionConfig = URLSessionConfiguration.default
        let session = URLSession(configuration: sessionConfig)
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        let postString = params;
        request.httpBody = postString.data(using: .utf8)
        
        if defaults.object(forKey: "authKey") == nil{
            request.addValue("", forHTTPHeaderField: "authKey")
        }else{
            request.addValue(defaults.object(forKey: "authKey") as! String, forHTTPHeaderField: "authKey")
        }
        
        request.addValue(API_USER_NAME, forHTTPHeaderField: "apiKey")
        request.addValue(API_KEY, forHTTPHeaderField: "apiPassword")
        
        let task = session.downloadTask(with: request) { (tempLocalUrl, response, error) in
            if let tempLocalUrl = tempLocalUrl, error == nil {
                // Success
                
                guard let statusCode = (response as? HTTPURLResponse)?.statusCode, statusCode != 404 else {
                    AlertManager.shared.showErrorSnackBar(msg: "filenotfounderror404".localized)
                    GlobalData.sharedInstance.dismissLoader()
                    return
                }
                
                GlobalData.sharedInstance.dismissLoader()
                print("Success: \(statusCode)")
                
                do {
                    let largeImageData = try Data(contentsOf: tempLocalUrl)
                    let documentsDirectoryURL = try! FileManager().url(for: .documentDirectory, in: .userDomainMask, appropriateFor: nil, create: true)
                    let fileURL = documentsDirectoryURL.appendingPathComponent(name)
                    
                    if !FileManager.default.fileExists(atPath: fileURL.path) {
                        do {
                            try largeImageData.write(to: fileURL)
                            let AC = UIAlertController(title: "success".localized, message: "filesavemessage".localized, preferredStyle: .alert)
                            let okBtn = UIAlertAction(title: "ok".localized, style: .default, handler: {(_ action: UIAlertAction) -> Void in
                                self.documentPathUrl = fileURL as NSURL
                                
                                if let gdprPdfVC = AppStoryboard.Marketplace.instance.instantiateViewController(withIdentifier: "ShowDownloadFile") as? ShowDownloadFile{
                                    gdprPdfVC.documentUrl = self.documentPathUrl
                                    self.navigationController?.pushViewController(gdprPdfVC, animated: true)
                                }
                            })
                            let noBtn = UIAlertAction(title: "cancel".localized, style: .destructive, handler: {(_ action: UIAlertAction) -> Void in
                            })
                            AC.addAction(okBtn)
                            AC.addAction(noBtn)
                            self.present(AC, animated: true, completion: { })
                        } catch {
                            print(error)
                        }
                    } else {
                        print("Image Not Added")
                    }
                } catch {
                    print("error")
                }
                
            } else {
                GlobalData.sharedInstance.dismissLoader()
                print("Failure: %@", error?.localizedDescription as Any)
            }
        }
        task.resume()
    }
    */
    
    @IBAction func checkBtnClicked(_ sender: UIButton)  {
        if sender.isSelected    {
            checkBoxBtn.setImage(nil, for: .normal)
            sender.isSelected = false
        }else{
            sender.isSelected = true
        }
    }
}
