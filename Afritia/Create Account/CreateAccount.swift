//
//  CreateAccount.swift
//  Magento2MobikulNew
//
//  Created by Webkul on 18/08/17.
//  Copyright © 2017 Webkul. All rights reserved.
//

import UIKit
import DropDown

class CreateAccount: UIViewController ,UIPickerViewDelegate, UIPickerViewDataSource{
    
    let defaults = UserDefaults.standard
    var createAccountModel:CreateAccountModel!
    
   
    @IBOutlet weak var firstNametextField: UITextField!
    @IBOutlet weak var lastNametextField: UITextField!
    @IBOutlet weak var howDoYouKnowTextField: UITextField!
    @IBOutlet weak var emailTextFeild: UITextField!
    @IBOutlet weak var confirmEmailTextFeild: UITextField!
    @IBOutlet weak var countryTextField: UITextField!
    @IBOutlet weak var mobileCodeBgView: UIView!
    @IBOutlet weak var mobileCodeFlagImageView :UIImageView!
    @IBOutlet weak var lblMobileCode:UILabel!
    @IBOutlet weak var btnSelectMobileCode:UIButton!
    @IBOutlet weak var mobileNumbertextfield: UITextField!
    @IBOutlet weak var passwordtextField: HideShowPasswordTextField!
    @IBOutlet weak var confirmPasswordTextField: HideShowPasswordTextField!
    @IBOutlet weak var registerButton: UIButton!
    @IBOutlet weak var mainView: UIView!
    
    var prefixValueArray:NSArray = []
    var suffixValueArray:NSArray = []
    var howDidYouHereArray:NSArray = []
    var genderValueArray:NSMutableArray = []
    //var countryCodeArray:NSArray = []
    var countriesArray:NSArray = []
    var isSellerChoice:Bool = false
    var keyBoardFlag:Int = 1
    //var whichApitoprocess:String = ""
    var movetoSignal:String = ""
    var isCountryVisible:Bool = true
    let dropDown = DropDown()

    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        self.navigationController?.isNavigationBarHidden = false
        self.tabBarController?.tabBar.isHidden = true
        self.navigationController?.navigationBar.makeBarTransparent(titleColor:UIColor.white)
        self.navigationItem.title = GlobalData.sharedInstance.language(key: "createaccount")
        self.navigationController?.navigationBar.setAttributedTitle(color:UIColor.white)
        self.view.backgroundColor = UIColor.LightLavendar
        mainView.backgroundColor = UIColor.white
        mainView.layer.cornerRadius = 16
        
        //whichApitoprocess = ""
        self.callAPItoGetCreateAccountForm()
        
        
       // prefixTextField.applyAfritiaTheme()
        firstNametextField.applyAfritiaTheme()
        lastNametextField.applyAfritiaTheme()
       // middleNametextField.applyAfritiaTheme()
       // suffixtextfield.applyAfritiaTheme()
        howDoYouKnowTextField.applyAfritiaTheme()
        emailTextFeild.applyAfritiaTheme()
        confirmEmailTextFeild.applyAfritiaTheme()
        countryTextField.applyAfritiaTheme()
        //mobileNumbertextfield.applyAfritiaTheme()
        //mobileCountryCodetextfield.applyAfritiaTheme()
       // dateOfBirthTextfield.applyAfritiaTheme()
       // taxvalueTextField.applyAfritiaTheme()
      //  genderTextField.applyAfritiaTheme()
        passwordtextField.applyAfritiaTheme()
        confirmPasswordTextField.applyAfritiaTheme()
        //twoFactorTextField.applyAfritiaTheme()
        
        
       // prefixTextField.placeholder = appLanguage.localize(key: "prefix")
        firstNametextField.placeholder = appLanguage.localize(key: "firstname")
        lastNametextField.placeholder = appLanguage.localize(key: "lastname")
       // middleNametextField.placeholder = appLanguage.localize(key: "middlename")
      //  suffixtextfield.placeholder = appLanguage.localize(key: "suffix")
        howDoYouKnowTextField.placeholder = appLanguage.localize(key: "howtohearaboutus")
        emailTextFeild.placeholder = "Email Address"
        confirmEmailTextFeild.placeholder = "Confirm Email Address"
        countryTextField.placeholder = "Select Country"
        //mobileCountryCodetextfield.placeholder = "Code"
        mobileNumbertextfield.placeholder = appLanguage.localize(key: "mobileno")
       // dateOfBirthTextfield.placeholder = appLanguage.localize(key: "dob")
        //taxvalueTextField.placeholder = appLanguage.localize(key: "taxvat")
       // genderTextField.placeholder = appLanguage.localize(key: "gender")
        passwordtextField.placeholder = appLanguage.localize(key: "password")
        confirmPasswordTextField.placeholder = appLanguage.localize(key: "conpassword")
       // twoFactorTextField.placeholder = "Select Two factor"
        
        //set deop down imge to required text field
        let dropImage = UIImage(named:"nav_icon_down")!.tintedWithColor(color:UIColor.lightGray)
        howDoYouKnowTextField.setRightViewImage(rightImage:dropImage)
        countryTextField.setRightViewImage(rightImage:dropImage)
        //mobileCountryCodetextfield.setRightViewImage(rightImage: dropImage)
       // twoFactorTextField.setRightViewImage(rightImage:dropImage)
        
        registerButton.applyAfritiaTheme()
        registerButton.setTitle(appLanguage.localize(key: "register"), for: .normal)
        
        
        let textAlignByLang = UITextField().setTextAlignmentByLanguage()
        
        //prefixTextField.textAlignment = textAlignByLang
        firstNametextField.textAlignment = textAlignByLang
        lastNametextField.textAlignment = textAlignByLang
       // middleNametextField.textAlignment = textAlignByLang
       // suffixtextfield.textAlignment = textAlignByLang
        howDoYouKnowTextField.textAlignment = textAlignByLang
        emailTextFeild.textAlignment = textAlignByLang
        confirmEmailTextFeild.textAlignment = textAlignByLang
        //mobileCountryCodetextfield.textAlignment = textAlignByLang
        mobileNumbertextfield.textAlignment = textAlignByLang
      //  dateOfBirthTextfield.textAlignment = textAlignByLang
       // taxvalueTextField.textAlignment = textAlignByLang
      //  genderTextField.textAlignment = textAlignByLang
        passwordtextField.textAlignment = textAlignByLang
        confirmPasswordTextField.textAlignment = textAlignByLang
       // twoFactorTextField.textAlignment = textAlignByLang
        
        self.mainView.isHidden = true
        
        //shopNameTextField.placeholder = appLanguage.localize(key: "shopname")
        //shopurltextField.placeholder = appLanguage.localize(key: "shopurl")
        
       // self.marketPlaceHeight.constant = 50
        // self.shopurltextField.isHidden = true
        //self.shopNameTextField.isHidden = true
        
//        doyouwanttobecomesellerLabel.text = appLanguage.localize(key: "doyouwanttobecomeseller")
        
        //self.mobileCountryCodetextfield.delegate = self
        self.howDoYouKnowTextField.delegate = self
        self.countryTextField.delegate = self
      //  self.twoFactorTextField.delegate = self
    }

  
    
    override func viewWillAppear(_ animated: Bool) {
        
        let leftBtnImage = UIImage(named:"nav_icon_back")
        let backButton = UIBarButtonItem(image: leftBtnImage, style: .plain, target: self, action: #selector(self.backToProfile))
        self.navigationItem.leftBarButtonItem = backButton
    }
    
    @objc func backToProfile(){
        self.tabBarController?.tabBar.isHidden = false
        self.navigationController?.popViewController(animated:true)
    }
    
    func donePressed(_ sender: UIBarButtonItem) {
      //  dateOfBirthTextfield.resignFirstResponder()
       //  prefixTextField.resignFirstResponder()
       //  suffixtextfield.resignFirstResponder()
     //   genderTextField.resignFirstResponder()
        howDoYouKnowTextField.resignFirstResponder()
    }
    
//    @IBAction func becomeSellerClick(_ sender: UISwitch) {
//        if sender.isOn{
//            isSellerChoice = true
//            self.marketPlaceHeight.constant = 150
//
//            self.shopurltextField.isHidden = false
//            self.shopNameTextField.isHidden = false
//        }else{
//            isSellerChoice = false
//            self.marketPlaceHeight.constant = 50
//            self.shopurltextField.isHidden = true
//            self.shopNameTextField.isHidden = true
//        }
//    }
    
    func callAPItoGetCreateAccountForm(){
        
        GlobalData.sharedInstance.showLoader()
        var requstParams = [String:Any]()
        requstParams["storeId"] = UserManager.getStoreId //"1" //defaults.object(forKey:"storeId") as! String
        APIServiceManager.shared.callingHttpRequest(params:requstParams, apiname:AfritiaAPI.createAccountForm, currentView: self){success,responseObject in
            GlobalData.sharedInstance.dismissLoader()
            if success == 1{
                
                print(responseObject)
                self.createAccountModel = CreateAccountModel(data:JSON(responseObject as! NSDictionary))
                self.doFurtherProcessingwithResult()
                self.view.isUserInteractionEnabled = true
                
            }else if success == 2{
                self.callAPItoGetCreateAccountForm()
            }
        }
    }
    
    func callAPItoCreateAccount() {
        
        GlobalData.sharedInstance.showLoader()
        
        var requstParams = [String:Any]()
        requstParams["storeId"] = UserManager.getStoreId
        requstParams["websiteId"] = DEFAULT_WEBSITE_ID
        requstParams["quoteId"] = UserManager.getQuoteId
        requstParams["token"] = UserManager.getDeviceToken
        requstParams["firstName"] = firstNametextField.text
       // requstParams["middleName"] = middleNametextField.text
        requstParams["lastName"] = lastNametextField.text
        requstParams["email"] = emailTextFeild.text
       // requstParams["prefix"] = prefixTextField.text
       // requstParams["suffix"] = suffixtextfield.text
        requstParams["mobile"] = mobileNumbertextfield.text
        requstParams["country_code"] = lblMobileCode.text
        requstParams["country"] = countryTextField.text
        requstParams["isSocial"] = "0"
        requstParams["pictureURL"] = ""
        requstParams["password"] = passwordtextField.text
        

        requstParams["becomeSeller"] = "0"
        
      
        
      //  requstParams["tfa_option"] = twoFactorTextField.text
        
        APIServiceManager.shared.callingHttpRequest(params:requstParams, apiname:AfritiaAPI.createAccount, currentView: self){success,responseObject in
            GlobalData.sharedInstance.dismissLoader()
            if success == 1
            {
                print(responseObject!)
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
                 
                    
                    if self.movetoSignal == "cart"{
                        let vc = AppStoryboard.Checkout.instance.instantiateViewController(withIdentifier: "CheckoutNavController") as! UINavigationController
                        self.navigationController?.pushViewController(vc, animated: true)
                        //vc.modalPresentationStyle = .fullScreen
                        //self.present(vc, animated: true, completion: nil)
                        //self.performSegue(withIdentifier: "checkout", sender: self)
                    }
                    self.tabBarController?.tabBar.isHidden = false
                    self.navigationController?.popToRootViewController(animated:true)
                }else{
                    AlertManager.shared.showErrorSnackBar(msg: dict["message"].stringValue)
                    afritiaSingleton.sharedInstance.showAlert(title: afritiaSingleton.sharedInstance.appName, msg: "Please Check you email" , VC: self, cancel_action: false)                     
                   
                    DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                        let storyboard = UIStoryboard(name: "Main", bundle: nil)
                        let viewController = storyboard.instantiateViewController(withIdentifier :"CustomerLogin") as! CustomerLogin
                        self.navigationController?.pushViewController(viewController, animated: true)
                    }
                    
                }
            }else if success == 2{
                self.callAPItoCreateAccount()
            }
        }
    }
    
    @IBAction func dismissKeyboard(_ sender: Any) {
        view.endEditing(true)
    }
    
    @IBAction func selectCountryPhoneCodeClick(_ sender: Any) {
        self.showsCountryPhoneCodePicker()
    }
    
//    func showsTwoFactoConfirmTypePicker(){
//        let dropDown = DropDown()
//
//        // The view to which the drop down will appear on
//        dropDown.anchorView = twoFactorTextField // UIView or UIBarButtonItem
//        dropDown.width = SCREEN_WIDTH - 84
//
//        dropDown.dataSource = ["Email", "Mobile"]
//        dropDown.selectionAction = { (index: Int, item: String) in
//            self.twoFactorTextField.text = item
//        }
//
//        dropDown.direction = .any
//        dropDown.topOffset = CGPoint(x: 0, y:-(dropDown.anchorView?.plainView.bounds.height)!)
//        dropDown.bottomOffset = CGPoint(x: 0, y:(dropDown.anchorView?.plainView.bounds.height)!)
//        dropDown.dismissMode = .manual
//
//        dropDown.show()
//        //dropDown.hide()
//    }
    
    func showsCountryPhoneCodePicker(){         
      
        dropDown.anchorView = self.btnSelectMobileCode // UIView or UIBarButtonItem
        dropDown.width = SCREEN_WIDTH - 84
        
        var dataSource = [String]()
        var flagSource = [String]()
        var codeSource = [String]()
        
        for i in 0..<self.countriesArray.count {
            let content = self.countriesArray.object(at:i) as? NSDictionary
            
            if let code = content!["phone_code"] as? String, let flag = content!["flag"] as? String, let name = content!["label"] as? String {
                if code.count > 1 {
                    codeSource.append(code)
                    flagSource.append(flag)
                    dataSource.append(name)
                }
            }
        }
        
        //print("Code",  dataSource.count)
        //print("Flags", flagSource.count)
        
        dropDown.dataSource = dataSource
        dropDown.cellNib = UINib(nibName: "FlagViewCell", bundle: nil)
        dropDown.customCellConfiguration = { (index: Index, item: String, cell: DropDownCell) -> Void in
            guard let cell = cell as? FlagViewCell else { return }
            
            cell.flagImageView.getImageFromUrl(imageUrl: flagSource[index])
            cell.flagImageView.layer.cornerRadius = 2
            cell.flagImageView.layer.borderWidth = 1
            cell.flagImageView.layer.borderColor = UIColor.Tin.cgColor
            
            cell.lblCountryCode.text = codeSource[index] + " " + dataSource[index]
        }
        
        dropDown.selectionAction = { (index: Int, item: String) in
            print("Selected item: \(item) at index: \(index)")
            let selFlag = flagSource[index]
            let selCountryName = dataSource[index]
            let selCountryCode = codeSource[index]
            print(selCountryName, selCountryCode)
            self.mobileCodeFlagImageView.getImageFromUrl(imageUrl:selFlag)
            self.lblMobileCode.text = selCountryCode
        }
        
        dropDown.direction = .any
        dropDown.topOffset = CGPoint(x: 0, y:-(dropDown.anchorView?.plainView.bounds.height)!)
        dropDown.bottomOffset = CGPoint(x: 0, y:(dropDown.anchorView?.plainView.bounds.height)!)
        dropDown.dismissMode = .automatic
        dropDown.show()
        //dropDown.hide()
    }
    
    /*
    func showsCountryPhoneCodePicker(){
        let dropDown = DropDown()

        // The view to which the drop down will appear on
        dropDown.anchorView = btnSelectMobileCode // UIView or UIBarButtonItem
        
        var dataSource = [String]()
        for i in 0..<self.countryCodeArray.count {
            let content = self.countryCodeArray.object(at:i) as? NSDictionary
            if let title = content!["label"] as? String{
                dataSource.append(title)
            }
        }
        
        dropDown.dataSource = dataSource
        dropDown.selectionAction = { (index: Int, item: String) in
          print("Selected item: \(item) at index: \(index)")
            self.lblMobileCode.text = item
        }
        
        dropDown.direction = .any
        dropDown.topOffset = CGPoint(x: 0, y:-(dropDown.anchorView?.plainView.bounds.height)!)
        dropDown.bottomOffset = CGPoint(x: 0, y:(dropDown.anchorView?.plainView.bounds.height)!)
        dropDown.dismissMode = .manual
        
        dropDown.show()
        //dropDown.hide()
    }
    */
    
    func showHowDidYouKnowPicker() {       

        // The view to which the drop down will appear on
        dropDown.anchorView = howDoYouKnowTextField // UIView or UIBarButtonItem

        // The list of items to display. Can be changed dynamically
        //dropDown.dataSource = ["Car", "Motorcycle", "Truck"]
        
        var dataSource = [String]()
        for i in 0..<self.howDidYouHereArray.count {
            let content = self.howDidYouHereArray.object(at:i) as? NSDictionary
            if let title = content!["label"] as? String{
                dataSource.append(title)
            }
        }
        
        dropDown.dataSource = dataSource
        dropDown.selectionAction = { (index: Int, item: String) in
            let content = self.howDidYouHereArray.object(at: index) as? NSDictionary
            let title = content!["label"] as? String
            self.howDoYouKnowTextField.text = title
        }
        
        dropDown.direction = .any
        dropDown.width = howDoYouKnowTextField.frame.size.width
        
        dropDown.topOffset = CGPoint(x: 0, y:-(dropDown.anchorView?.plainView.bounds.height)!)
        dropDown.bottomOffset = CGPoint(x: 0, y:(dropDown.anchorView?.plainView.bounds.height)!)
        dropDown.dismissMode = .onTap
        
        dropDown.show()
    }
    
    func showCountryPicker() {
        
        // The view to which the drop down will appear on
        dropDown.anchorView = countryTextField // UIView or UIBarButtonItem

        var dataSource = [String]()
        for i in 0..<self.countriesArray.count {
            let content = self.countriesArray.object(at:i) as? NSDictionary
            if let title = content!["label"] as? String{
                dataSource.append(title)
            }
        }
        
        dropDown.dataSource = dataSource
        dropDown.selectionAction = { (index: Int, item: String) in
          print("Selected item: \(item) at index: \(index)")
            let content = self.countriesArray.object(at: index) as? NSDictionary
            let title = content!["label"] as? String
            self.countryTextField.text = title
        }
        
        dropDown.direction = .any
        dropDown.width = countryTextField.frame.size.width
        
        dropDown.topOffset = CGPoint(x: 0, y:-(dropDown.anchorView?.plainView.bounds.height)!)
        dropDown.bottomOffset = CGPoint(x: 0, y:(dropDown.anchorView?.plainView.bounds.height)!)
        dropDown.dismissMode = .onTap
        //let f = howDoYouKnowTextField.bounds
        //dropDown.topOffset = CGPoint(x:f.origin.x, y:-f.size.height)
        //dropDown.bottomOffset = CGPoint(x:f.origin.x, y:f.size.height)
        
        dropDown.show()
    }
    
    @IBAction func howDoYouKnowClick(_ sender: Any) {
                
        /*
        if createAccountModel.isHowDidYouHearVisible == true{
            let thePicker = UIPickerView()
            thePicker.tag = 5000
            howDoYouKnowTextField.inputView = thePicker
            thePicker.delegate = self
        }*/
    }
    
    @IBAction func prefixClick(_ sender: Any) {
        if createAccountModel.isPrefixHasOption == true{
            let thePicker = UIPickerView()
            thePicker.tag = 1000
          //  prefixTextField.inputView = thePicker
            thePicker.delegate = self
        }
    }
    
    
    @IBAction func suffixClick(_ sender: Any) {
        if createAccountModel.isPrefixHasOption == true{
            let thePicker = UIPickerView()
            thePicker.tag = 2000
         //   suffixtextfield.inputView = thePicker
            thePicker.delegate = self
        }
    }
    
    @IBAction func dateOfBirthClick(_ sender: Any) {
        let datePickerView:UIDatePicker = UIDatePicker()
        datePickerView.tag = 4000
        datePickerView.datePickerMode = UIDatePickerMode.date
      //  dateOfBirthTextfield.inputView = datePickerView
        datePickerView.addTarget(self, action: #selector(CreateAccount.datePickerFromValueChanged), for: UIControlEvents.valueChanged)
    }
    
    @IBAction func genderClick(_ sender: Any) {
        let thePicker = UIPickerView()
        thePicker.tag = 3000
      //  genderTextField.inputView = thePicker
        thePicker.delegate = self
    }
    
    @objc func datePickerFromValueChanged(sender:UIDatePicker) {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = createAccountModel.dateFormat
      //  dateOfBirthTextfield.text = dateFormatter.string(from: sender.date)
    }
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        if(pickerView.tag == 1000){
            return self.prefixValueArray.count
        }else if(pickerView.tag == 2000){
            return self.suffixValueArray.count
        }else if(pickerView.tag == 3000){
            return self.genderValueArray.count
        }/*else if(pickerView.tag == 5000){
            return self.howDidYouHereArray.count
        }*/else{
            return 0
        }
    }
    

    
    func doFurtherProcessingwithResult(){
        
        self.mainView.isHidden = false
        GlobalData.sharedInstance.dismissLoader()
        self.howDidYouHereArray = createAccountModel.howDidYouHearOptions! as NSArray
        self.countriesArray = createAccountModel.countries! as NSArray
        self.firstNametextField.isHidden = false
        self.lastNametextField.isHidden = false
      
        //Setup visibility for how did you know about TextField
        if createAccountModel.isHowDidYouHearVisible{
            self.howDoYouKnowTextField.isHidden = false
        }else{
            self.howDoYouKnowTextField.isHidden = true
        }
        
        
        if createAccountModel.isEmailIdVisible {
            self.emailTextFeild.isHidden = false
            self.confirmEmailTextFeild.isHidden = false
        }
        else{
            self.emailTextFeild.isHidden = true
            self.confirmEmailTextFeild.isHidden = true
        }
        
        if createAccountModel.isCountryVisible {
            self.countryTextField.isHidden = false
        }else{
            self.countryTextField.isHidden = true
        }
        
        if createAccountModel.isMobileNumberVisible{
            
            self.mobileCodeBgView.isHidden = false
            self.mobileCodeFlagImageView.isHidden = false
            self.btnSelectMobileCode.isHidden = false
            self.lblMobileCode.isHidden = false
            self.mobileNumbertextfield.isHidden = false
            self.mobileCodeBgView.layer.cornerRadius = 6
            self.mobileCodeBgView.layer.borderWidth = 1
            self.mobileCodeBgView.layer.borderColor = UIColor.silver.cgColor
            
        }else{
            
            self.mobileCodeBgView.isHidden = true
            self.mobileCodeFlagImageView.isHidden = true
            self.btnSelectMobileCode.isHidden = true
            self.lblMobileCode.isHidden = true
            self.mobileNumbertextfield.isHidden = true
        }

        if createAccountModel.isPasswordVisible {
            self.passwordtextField.isHidden = false
            self.confirmPasswordTextField.isHidden = false
        }
        else{
            self.passwordtextField.isHidden = true
            self.confirmPasswordTextField.isHidden = true
        }

    }
    
    @IBAction func registerClick(_ sender: Any) {
        
        var errorMessage = ""
        var isValid:Int = 1
        print("calling")
        
        if firstNametextField.text == ""{
            isValid = 0
            errorMessage = GlobalData.sharedInstance.language(key: "pleasefillfirstname")
        }else if lastNametextField.text == ""{
            isValid = 0
            errorMessage = GlobalData.sharedInstance.language(key: "pleasefilllastname")
        }else if !GlobalData.sharedInstance.checkValidEmail(data: emailTextFeild.text!){
            isValid = 0
            errorMessage = GlobalData.sharedInstance.language(key: "pleasefilllvalidemail")
        }else if passwordtextField.text == ""{
            isValid = 0
            errorMessage = GlobalData.sharedInstance.language(key: "pleasefillpassword")
        }else if confirmPasswordTextField.text == ""{
            isValid = 0
            errorMessage = GlobalData.sharedInstance.language(key: "pleasefillconfirmnewpassword")
        }

        if createAccountModel.isMobileNumberRequired{
            if mobileNumbertextfield.text == ""{
                isValid = 0
                errorMessage = GlobalData.sharedInstance.language(key: "pleasefillmobilenumber")
            }
        }

        
        if isValid == 0{
            AlertManager.shared.showErrorSnackBar(msg: errorMessage)
        }else{
            if passwordtextField.text != confirmPasswordTextField.text{
                AlertManager.shared.showErrorSnackBar(msg: GlobalData.sharedInstance.language(key: "passwordnotmatch"))
            }else if (passwordtextField.text?.count)! < createAccountModel.passwordLength {
                AlertManager.shared.showErrorSnackBar(msg: "passwordlength".localized + " " + "\(createAccountModel.passwordLength)")
            }else{
                self.callAPItoCreateAccount()
                //whichApitoprocess = "createaccount"
                //callingHttppApi()
                print("yes")
            }
        }
    }        
}

extension CreateAccount : UITextFieldDelegate {
    func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
        
        self.view.endEditing(true)
        
        if textField == self.howDoYouKnowTextField{
            self.showHowDidYouKnowPicker()
            return false
        }
        else if textField == self.countryTextField{
            self.showCountryPicker()
            return false
        }
        return true
    }
}
