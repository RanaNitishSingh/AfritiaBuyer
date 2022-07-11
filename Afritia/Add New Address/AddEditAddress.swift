//
//  AddEditAddress.swift
//  DummySwift
//
//  Created by Webkul on 05/12/16.
//  Copyright © 2016 Webkul. All rights reserved.
//

@objc protocol NewAddressAddHandlerDelegate: class {
    func newAddAddreressSuccess(data:Bool)
}

enum AddEditAddressBy:String{
    case addressBook
    case billingAddress
}

import UIKit
import CoreLocation
import UIFloatLabelTextField

class AddEditAddress: AfritiaBaseViewController,UIPickerViewDelegate,UITextFieldDelegate,UIPickerViewDataSource{
    
    @IBOutlet weak var mainView: UIView!
    @IBOutlet weak var stateFieldHeightConstarints: NSLayoutConstraint!
    @IBOutlet weak var statePicker: UIPickerView!
    @IBOutlet weak var stateField: UITextField!
    @IBOutlet weak var countryPicker: UIPickerView!
    @IBOutlet weak var firstNameTextField: UITextField!
    @IBOutlet weak var lastNameTextField: UITextField!
    @IBOutlet weak var companyNameTextField: UITextField!
    @IBOutlet weak var mobileNumberTextField: UITextField!
    @IBOutlet weak var faxNumberTextField: UITextField!
    @IBOutlet weak var cityNameTextField: UITextField!
    @IBOutlet weak var stateNameTextField: UITextField!
    @IBOutlet weak var postalCodeTextField: UITextField!
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var defaultBillingAddressSwitch: UISwitch!
    @IBOutlet weak var defaultShippingAddressSwitch: UISwitch!
    @IBOutlet weak var useasmydefaultbillingaddressLabel: UILabel!
    @IBOutlet weak var useasmydefaultshippingaddressLabel: UILabel!
    @IBOutlet weak var saveAddressButton: UIButton!
    @IBOutlet weak var prefixTextField: UITextField!
    @IBOutlet weak var prefixTextFieldHeightConstarints: NSLayoutConstraint!
    
    @IBOutlet weak var middleNameTextField: UITextField!
    @IBOutlet weak var middleNameTextFieldHeight: NSLayoutConstraint!
    @IBOutlet weak var suffixTextField: UITextField!
    @IBOutlet weak var suffixtextFieldHeightConstarints: NSLayoutConstraint!
    
    @IBOutlet weak var streetAddress1TextField: UITextField!
    @IBOutlet weak var streetAddress2TextField: UITextField!
    @IBOutlet weak var streetAddress3TextField: UITextField!
    @IBOutlet weak var streetAddress4TextField: UITextField!
    
    @IBOutlet weak var streetAddress1TextFeildHeight: NSLayoutConstraint!
    @IBOutlet weak var streetAddress2TextFeildHeight: NSLayoutConstraint!
    @IBOutlet weak var streetAddress3TextFieldHeight: NSLayoutConstraint!
    @IBOutlet weak var streetAddress4TextFieldHeight: NSLayoutConstraint!
    
    @IBOutlet weak var afritiaNavBarView: AFNavigationBarView!
    @IBOutlet weak var afritiaNavBarViewHeight:NSLayoutConstraint!
    
    
    @IBOutlet weak var stateLebel: UILabel!
    @IBOutlet weak var countryLbl: UILabel!
    
    @IBOutlet weak var gdprTxtView: UITextView!
    @IBOutlet weak var gdprDownlaodBtn : UIButton!
    @IBOutlet weak var checkBoxBtn : UIButton!
    
    var addressEdiitByView:AddEditAddressBy!
    
    var addOrEdit:String = ""
    var addressId:String = ""
    
    var whichApiDataToProcess:String!
    
    var countryPickerData:NSArray = []
    var statePickerData:NSArray = []
    var countryIndex:Int = 0
    var regionId:String = ""
    
    var countryValue:String!
    var firstNameValue, lastNameValue, companyValue, telephoneValue, faxValue, street1Value, street2Value, street3Value, street4Value, cityValue, regionValue, zipValue, default_shipping, default_billing :String!
    
    var delegate:NewAddressAddHandlerDelegate!
    
    var expandHeight:CGFloat = 0
    //var locationManager:CLLocationManager!
    var addEditAddressModel:AddeditAddressModel!
    var prefixValueArray:NSArray = []
    var suffixValueArray:NSArray = []
    var streetArray:NSArray = []
    var streetCount:Int = 1
    var currentClass:String = ""
    
    var keyBoardFlag:Int = 1
    let defaults = UserDefaults.standard
    
    @IBOutlet var locationButton: UIBarButtonItem!
    @IBOutlet var activityIndicatorButton: UIBarButtonItem!
    var activityIndicator: UIActivityIndicatorView!
    var documentPathUrl: NSURL!
    
    let locationManager = CLLocationManager()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if addressEdiitByView == AddEditAddressBy.addressBook {
            self.navigationController?.navigationBar.isHidden = true
            self.afritiaNavBarView.isHidden = false
            afritiaNavBarViewHeight.constant = 94
            self.setUpCustomNavigationBar()
        }else{
            self.navigationController?.navigationBar.isHidden = false
            afritiaNavBarViewHeight.constant = 0
            self.afritiaNavBarView.isHidden = true
        }
        
        if addOrEdit == "0"{
            self.navigationItem.title = "addnewaddress".localized
            gdprTxtView.isHidden = true
            gdprDownlaodBtn.isHidden = true
            checkBoxBtn.isHidden = true
        }else{
            self.navigationItem.title = appLanguage.localize(key: "edituseraddress")
            gdprTxtView.isHidden = false
            gdprDownlaodBtn.isHidden = false
            checkBoxBtn.isHidden = false
        }
        
        mobileNumberTextField.delegate = self
        
        //        mainViewHeightConstraints.constant = 1200
        stateFieldHeightConstarints.constant = 50
        statePicker.isHidden = true
        statePicker.tag = 2000
        countryPicker.tag = 1000
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(AddEditAddress.dismissKeyboard))
        view.addGestureRecognizer(tap)
        
        /*
        UITextField().bottomBorder(texField: firstNameTextField)
        UITextField().bottomBorder(texField: lastNameTextField)
        UITextField().bottomBorder(texField: companyNameTextField)
        UITextField().bottomBorder(texField: mobileNumberTextField)
        UITextField().bottomBorder(texField: faxNumberTextField)
        UITextField().bottomBorder(texField: streetAddress1TextField)
        UITextField().bottomBorder(texField: streetAddress2TextField)
        UITextField().bottomBorder(texField: cityNameTextField)
        UITextField().bottomBorder(texField: stateNameTextField)
        UITextField().bottomBorder(texField: prefixTextField)
        UITextField().bottomBorder(texField: middleNameTextField)
        UITextField().bottomBorder(texField: suffixTextField)
        UITextField().bottomBorder(texField: streetAddress3TextField)
        UITextField().bottomBorder(texField: streetAddress4TextField)
        */
        
        default_shipping = "0"
        default_billing = "0"
        
        let textAlignByLang = UITextField().setTextAlignmentByLanguage()
        
        firstNameTextField.textAlignment = textAlignByLang
        lastNameTextField.textAlignment = textAlignByLang
        companyNameTextField.textAlignment = textAlignByLang
        mobileNumberTextField.textAlignment = textAlignByLang
        faxNumberTextField.textAlignment = textAlignByLang
        streetAddress1TextField.textAlignment = textAlignByLang
        streetAddress2TextField.textAlignment = textAlignByLang
        cityNameTextField.textAlignment = textAlignByLang
        stateNameTextField.textAlignment = textAlignByLang
        postalCodeTextField.textAlignment = textAlignByLang
        prefixTextField.textAlignment = textAlignByLang
        middleNameTextField.textAlignment = textAlignByLang
        suffixTextField.textAlignment = textAlignByLang
        streetAddress3TextField.textAlignment = textAlignByLang
        streetAddress4TextField.textAlignment = textAlignByLang
        
        
        firstNameTextField.applyAfritiaTheme()
        lastNameTextField.applyAfritiaTheme()
        companyNameTextField.applyAfritiaTheme()
        mobileNumberTextField.applyAfritiaTheme()
        faxNumberTextField.applyAfritiaTheme()
        streetAddress1TextField.applyAfritiaTheme()
        streetAddress2TextField.applyAfritiaTheme()
        cityNameTextField.applyAfritiaTheme()
        stateNameTextField.applyAfritiaTheme()
        postalCodeTextField.applyAfritiaTheme()
        prefixTextField.applyAfritiaTheme()
        middleNameTextField.applyAfritiaTheme()
        suffixTextField.applyAfritiaTheme()
        streetAddress3TextField.applyAfritiaTheme()
        streetAddress4TextField.applyAfritiaTheme()
        
        
        firstNameTextField.placeholder =  appLanguage.localize(key: "firstname")+" "+appLanguage.localize(key: "required")
        middleNameTextField.placeholder = appLanguage.localize(key: "middlename")
        lastNameTextField.placeholder = appLanguage.localize(key:"lastname")+" "+appLanguage.localize(key: "required")
        companyNameTextField.placeholder = appLanguage.localize(key:"company")
        mobileNumberTextField.placeholder = appLanguage.localize(key:"phoneno")+" "+appLanguage.localize(key: "required")
        faxNumberTextField.placeholder = appLanguage.localize(key:"fax")
        streetAddress1TextField.placeholder = appLanguage.localize(key:"street1")+" "+appLanguage.localize(key: "required")
        streetAddress2TextField.placeholder = appLanguage.localize(key:"street2")
        streetAddress3TextField.placeholder = appLanguage.localize(key:"street3")
        streetAddress4TextField.placeholder = appLanguage.localize(key:"street4")
        cityNameTextField.placeholder = appLanguage.localize(key:"city")+" "+appLanguage.localize(key: "required")
        stateNameTextField.placeholder = appLanguage.localize(key:"state")
        postalCodeTextField.placeholder = appLanguage.localize(key:"zip")+" "+appLanguage.localize(key: "required")
        
        mobileNumberTextField.keyboardType = .numberPad
        faxNumberTextField.keyboardType = .numberPad
        
        saveAddressButton.applyAfritiaTheme()
        saveAddressButton.setTitle(appLanguage.localize(key:"save"), for: .normal)
        //saveAddressButton.backgroundColor = UIColor.button
        //saveAddressButton.setTitleColor(UIColor.white, for: .normal)
        
        //GDPR
        gdprDownlaodBtn.setTitle("downloadaddressinfo".localized, for: .normal)
        gdprDownlaodBtn.backgroundColor = UIColor.button
        gdprDownlaodBtn.setTitleColor(UIColor.white, for: .normal)
        
        checkBoxBtn.layer.borderColor = UIColor.black.cgColor
        checkBoxBtn.layer.borderWidth = 1.0
        checkBoxBtn.setImage(nil, for: .normal)
        
        useasmydefaultbillingaddressLabel.text = appLanguage.localize(key:"useasmydefaultbillingaddress")
        useasmydefaultshippingaddressLabel.text = appLanguage.localize(key:"useasmydefaultshippingaddress")
        stateLebel.text = appLanguage.localize(key:"state")
        countryLbl.text = "country".localized
        
        self.scrollView.isHidden = true
        whichApiDataToProcess = "formData"
        
        callingHttppApi()
        
        activityIndicator = UIActivityIndicatorView.init(activityIndicatorStyle: .white)
        activityIndicator.hidesWhenStopped = true
        activityIndicatorButton.customView = activityIndicator
        activityIndicator.tintColor = UIColor.DarkLavendar

        self.checkLocaationPermissionAndGetMyAddress()
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
        locationButton.isHidden = false
        super.viewWillAppear(animated)
        //self.navigationController?.isNavigationBarHidden = false
    }
    
    @IBAction func addNewAddressClick(_ sender: UIBarButtonItem) {
        
        self.checkLocaationPermissionAndGetMyAddress()
    }
    
    
    func checkLocaationPermissionAndGetMyAddress(){
        
        var flag = 1
        if CLLocationManager.locationServicesEnabled() {
            switch CLLocationManager.authorizationStatus() {
            case .notDetermined:
                flag = 0
            case .restricted:
                flag = 0
            case .denied:
                flag = 0
            case .authorizedAlways:
                flag = 1
            case .authorizedWhenInUse:
                flag = 1
            }
        }
        else
        {
            AlertManager.shared.showInfoSnackBar(msg:"Location services are not enabled")
    
        }
        
        if flag == 1
        {
            self.findMyLocation()
        }
        else
        {
            self.showLocationPermissionAlert()
        }
    }
    
    func showLocationPermissionAlert(){
        
            let AC = UIAlertController(title: appLanguage.localize(key: "warning"), message: "locationpermission".localized, preferredStyle: .alert)
            let actionBtnOK = UIAlertAction(title: appLanguage.localize(key: "open"), style: .default, handler: {(_ action: UIAlertAction) -> Void in
                guard let settingsUrl = URL(string: UIApplicationOpenSettingsURLString) else {
                    return
                }
                
                if UIApplication.shared.canOpenURL(settingsUrl) {
                    UIApplication.shared.open(settingsUrl, completionHandler: { (success) in
                        // Checking for setting is opened or not
                        print("Setting is opened: \(success)")
                    })
                }
            })
            let actionBtnCancel = UIAlertAction(title: appLanguage.localize(key: "cancel"), style: .destructive, handler: {(_ action: UIAlertAction) -> Void in
            })
            AC.addAction(actionBtnOK)
            AC.addAction(actionBtnCancel)
            self.present(AC, animated: true, completion: { })

    }
    
    func findMyLocation()
    {
        locationButton.customView = activityIndicator
        activityIndicator.startAnimating()
        
        locationManager.delegate = self
        //locationManager.desiredAccuracy = kCLLocationAccuracyNearestTenMeters
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.requestAlwaysAuthorization()
        //locationManager.requestWhenInUseAuthorization()
        locationManager.startUpdatingLocation()
    }
    
    func displayLocationInfo(_ placemark: CLPlacemark?) {
        
        if let containsPlacemark = placemark {
            //stop updating location to save battery life
            locationManager.stopUpdatingLocation()
            let locality = (containsPlacemark.locality != nil) ? containsPlacemark.locality : ""
            let subLocality = (containsPlacemark.subLocality != nil) ? containsPlacemark.subLocality : ""
            let postalCode = (containsPlacemark.postalCode != nil) ? containsPlacemark.postalCode : ""
            let administrativeArea = (containsPlacemark.administrativeArea != nil) ? containsPlacemark.administrativeArea : ""
            let country = (containsPlacemark.country != nil) ? containsPlacemark.country : ""
            let countryCode = (containsPlacemark.isoCountryCode != nil) ? containsPlacemark.isoCountryCode : ""
            
            self.cityNameTextField.text = locality
            self.streetAddress1TextField.text = subLocality
            self.stateField.text = administrativeArea
            self.postalCodeTextField.text = postalCode
            
            print("Country",country!)
            print("CoutryCode :", countryCode!)
            print("City :", locality!)
            print("Street1 :", subLocality!)
            print("State :", administrativeArea!)
            print("postalCode :", postalCode!)

            for i in 0..<self.countryPickerData.count{
                let countryDict:NSDictionary = self.countryPickerData .object(at: i) as! NSDictionary
                let  countryID:String = countryDict.object(forKey: "country_id") as! String
                if(countryID == countryCode!){
                    self.countryIndex = i
                    self.countryValue = countryID
                    self.countryPicker.selectRow(i, inComponent: 0, animated: false)
                    self.pickerView(self.countryPicker, didSelectRow: i, inComponent: 0)
                    break
                }
            }
            
            activityIndicator.stopAnimating()
            locationButton.customView = nil
        }

    }
    
    func callingHttppApi(){
        GlobalData.sharedInstance.showLoader()
        if whichApiDataToProcess == "saveformdata"{
            var requstParams = [String:Any]()
            requstParams["storeId"] = defaults.object(forKey:"storeId") as! String
            requstParams["customerToken"] = defaults.object(forKey:"customerId") as! String
            var addressDataDictionary = [String: AnyObject]()
            addressDataDictionary["firstname"] = firstNameValue as AnyObject?
            addressDataDictionary["lastname"] = lastNameValue as AnyObject?
            addressDataDictionary["company"] = companyValue as AnyObject?
            addressDataDictionary["telephone"] = telephoneValue as AnyObject?
            addressDataDictionary["fax"] = faxValue as AnyObject?
            addressDataDictionary["city"] = cityValue as AnyObject?
            addressDataDictionary["postcode"] = zipValue as AnyObject?
            addressDataDictionary["country_id"] = countryValue as AnyObject?
            if((regionValue == "") == false){
                addressDataDictionary["region"] = regionValue as AnyObject?
            }
            if(regionId != "0"){
                addressDataDictionary["region_id"] = regionId as AnyObject?
            }
            addressDataDictionary["street"] = streetArray as AnyObject?
            addressDataDictionary["default_billing"] = default_billing as AnyObject?
            addressDataDictionary["default_shipping"] = default_shipping as AnyObject?
            addressDataDictionary["prefix"] = prefixTextField.text as AnyObject?
            addressDataDictionary["suffix"] = suffixTextField.text as AnyObject?
            addressDataDictionary["middleName"] = middleNameTextField.text as AnyObject?
            if(addOrEdit == "1"){
                requstParams["addressId"] = addressId
            }else{
                requstParams["addressId"] = "0"
            }
            
            do {
                let jsonAddressData =  try JSONSerialization.data(withJSONObject: addressDataDictionary, options: .prettyPrinted)
                let jsonaddressString:String = NSString(data: jsonAddressData, encoding: String.Encoding.utf8.rawValue)! as String
                requstParams["addressData"] = jsonaddressString
            }
            catch {
                print(error.localizedDescription)
            }
            APIServiceManager.shared.callingHttpRequest(params:requstParams, apiname:AfritiaAPI.saveAddress, currentView: self){success,responseObject in
                if success == 1{
                    
                    let dict = responseObject as! NSDictionary
                    GlobalData.sharedInstance.dismissLoader()
                    if dict.object(forKey: "success") as! Bool == true{
                        let AC = UIAlertController(title: appLanguage.localize(key: "success"), message: dict.object(forKey: "message") as? String, preferredStyle: .alert)
                        let okBtn = UIAlertAction(title: appLanguage.localize(key: "ok"), style: .default, handler: {(_ action: UIAlertAction) -> Void in
                            self.navigationController?.popViewController(animated: true)
                            if self.currentClass == "shipping"{
                                self.delegate.newAddAddreressSuccess(data: true)
                            }
                        })
                        
                        AC.addAction(okBtn)
                        self.present(AC, animated: true, completion: {  })
                        
                        
                    }else{
                        AlertManager.shared.showErrorSnackBar(msg: dict.object(forKey: "message") as! String)
                    }
                    print(responseObject as! NSDictionary)
                }else if success == 2{
                    GlobalData.sharedInstance.dismissLoader()
                    self.callingHttppApi()
                }
            }
        }else{
            var requstParams = [String:Any]()
            requstParams["storeId"] = defaults.object(forKey:"storeId") as! String
            requstParams["customerToken"] = defaults.object(forKey:"customerId") as! String
            if addOrEdit == "1"{
                requstParams["addressId"] = addressId
            }
            APIServiceManager.shared.callingHttpRequest(params:requstParams, apiname:AfritiaAPI.addressFormData, currentView: self){success,responseObject in
                if success == 1{
                    
                    self.addEditAddressModel = AddeditAddressModel(data:JSON(responseObject as! NSDictionary))
                    print(responseObject as! NSDictionary)
                    self.doFurtherProcessingWithResult()
                }else if success == 2{
                    GlobalData.sharedInstance.dismissLoader()
                    self.callingHttppApi()
                }
            }
        }
    }
    
    @IBAction func prefixTextFieldClicked(_ sender: UIFloatLabelTextField) {
        if addEditAddressModel.isPrefixHasOption{
            let thePicker = UIPickerView()
            thePicker.tag = 3
            prefixTextField.inputView = thePicker
            thePicker.delegate = self
        }
    }
    
    @IBAction func SuffixTextFieldClick(_ sender: UIFloatLabelTextField) {
        if addEditAddressModel.isSuffixHasOption{
            let thePicker = UIPickerView()
            thePicker.tag = 4
            suffixTextField.inputView = thePicker
            thePicker.delegate = self
        }
    }
    
    @objc func dismissKeyboard() {
        view.endEditing(true)
    }
    
    func doFurtherProcessingWithResult(){
        DispatchQueue.main.async {
            GlobalData.sharedInstance.dismissLoader()
            self.view.isUserInteractionEnabled = true
            if(self.whichApiDataToProcess == "formData"){
                self.countryPickerData = self.addEditAddressModel.countryData! as NSArray
                self.countryPicker.delegate = self
                self.prefixTextFieldHeightConstarints.constant = 0
                self.middleNameTextFieldHeight.constant = 0
                self.suffixtextFieldHeightConstarints.constant = 0
                
                self.streetAddress1TextFeildHeight.constant = 0
                self.streetAddress2TextFeildHeight.constant = 0
                self.streetAddress3TextFieldHeight.constant = 0
                self.streetAddress4TextFieldHeight.constant = 0
                
                self.prefixTextField.isHidden = true
                self.middleNameTextField.isHidden = true
                self.suffixTextField.isHidden = true
                
                self.streetAddress1TextField.isHidden = true
                self.streetAddress2TextField.isHidden = true
                self.streetAddress3TextField.isHidden = true
                self.streetAddress4TextField.isHidden = true
                
                self.prefixValueArray = self.addEditAddressModel.prefixValue! as NSArray
                self.suffixValueArray = self.addEditAddressModel.suffixValue! as NSArray
                if self.addEditAddressModel.isPrefixVisible{
                    self.prefixTextField.isHidden = false
                    self.expandHeight += 50
                    self.prefixTextFieldHeightConstarints.constant = 50
                }
                
                if self.addEditAddressModel.isMiddleNameVisible{
                    self.middleNameTextField.isHidden = false
                    self.expandHeight += 50
                    self.middleNameTextFieldHeight.constant = 50
                }
                
                if self.addEditAddressModel.isSuffixVisible{
                    self.suffixTextField.isHidden = false
                    self.expandHeight += 50
                    self.suffixtextFieldHeightConstarints.constant = 50
                }
                
                self.streetCount = self.addEditAddressModel.receiveStreetCount
                
                if self.streetCount == 1{
                    self.streetAddress1TextField.isHidden = false
                    self.streetAddress1TextFeildHeight.constant = 50
                    self.expandHeight += 50
                }
                
                if self.streetCount == 2{
                    self.streetAddress1TextField.isHidden = false
                    self.streetAddress1TextFeildHeight.constant = 50
                    self.streetAddress2TextField.isHidden = false
                    self.streetAddress2TextFeildHeight.constant = 50
                    self.expandHeight += 100
                }
                
                if self.streetCount == 3{
                    
                    self.streetAddress1TextField.isHidden = false
                    self.streetAddress1TextFeildHeight.constant = 50
                    self.streetAddress2TextField.isHidden = false
                    self.streetAddress2TextFeildHeight.constant = 50
                    self.streetAddress3TextField.isHidden = false
                    self.streetAddress3TextFieldHeight.constant = 50
                    self.expandHeight += 150
                   
                }
                
                if self.streetCount == 4{
                    self.streetAddress1TextField.isHidden = false
                    self.streetAddress1TextFeildHeight.constant = 50
                    self.streetAddress2TextField.isHidden = false
                    self.streetAddress2TextFeildHeight.constant = 50
                    self.streetAddress3TextField.isHidden = false
                    self.streetAddress3TextFieldHeight.constant = 50
                    self.streetAddress4TextField.isHidden = false
                    self.streetAddress4TextFieldHeight.constant = 50
                    self.expandHeight += 200
                    
                }
                
                if(self.addOrEdit == "1"){
                    self.firstNameTextField.text = self.addEditAddressModel.receiveFirstName
                    self.lastNameTextField.text = self.addEditAddressModel.receiveLastName
                    self.companyNameTextField.text = self.addEditAddressModel.receiveCompanyName
                    self.mobileNumberTextField.text = self.addEditAddressModel.receiveTelephoneValue
                    self.faxNumberTextField.text = self.addEditAddressModel.faxValue
                    self.cityNameTextField.text = self.addEditAddressModel.receiveCity
                    self.postalCodeTextField.text = self.addEditAddressModel.receivePostCode
                    self.prefixTextField.text = self.addEditAddressModel.receivePrefixValue
                    self.middleNameTextField.text = self.addEditAddressModel.receiveMiddleName
                    self.suffixTextField.text = self.addEditAddressModel.receiveSuffixValue
                    
                    let streetArray : NSArray = self.addEditAddressModel.receiveStreetData! as NSArray
                    self.streetAddress1TextField.text = streetArray.object(at: 0) as? String
                    if(streetArray.count>1){
                        self.streetAddress2TextField.text = streetArray.object(at: 1) as? String
                    }
                    if self.addEditAddressModel.receiveIsDefaultBilling == true{
                        self.default_billing = "1"
                        self.defaultBillingAddressSwitch.setOn(true, animated: false)
                    }
                    if self.addEditAddressModel.receiveIsDefaultShipping == true{
                        self.defaultShippingAddressSwitch.setOn(true, animated: false)
                    }
                    
                    for i in 0..<self.countryPickerData.count{
                        let countryDict:NSDictionary = self.countryPickerData .object(at: i) as! NSDictionary
                        let  countryID:String = countryDict.object(forKey: "country_id") as! String
                        
                        if countryID == self.addEditAddressModel.receiveCountryId{
                            self.countryIndex = i
                            self.countryValue = countryID
                            self.countryPicker.selectRow(i, inComponent: 0, animated: false)
                            self.pickerView(self.countryPicker, didSelectRow: i, inComponent: 0)
                            break
                        }
                    }
                    var flag:Int = 0
                    for i in 0..<self.countryPickerData.count{
                        let countryDict:NSDictionary = self.countryPickerData .object(at: i) as! NSDictionary
                        let  countryID:String = countryDict.object(forKey: "country_id") as! String
                        if countryID == self.addEditAddressModel.receiveCountryId{
                            if(countryDict.object(forKey: "states") != nil){
                                let stateArray:NSArray = countryDict.object(forKey: "states") as! NSArray
                                for j in 0..<stateArray.count{
                                    let stateDict:NSDictionary = stateArray .object(at: j) as! NSDictionary
                                    let  stateId:String = stateDict.object(forKey: "region_id") as! String
                                    if(stateId == self.addEditAddressModel.receiveRegionId){
                                        flag = 1
                                        break
                                    }}
                            }else{
                                self.stateNameTextField.text = self.addEditAddressModel.receiveRegion
                            }
                        }
                    }
                    if(flag == 0){
                        self.stateNameTextField.text = self.addEditAddressModel.receiveRegion
                    }
                }else{
                    if self.countryPickerData.count > 0{
                        self.countryIndex = 0
                        
                        for i in 0..<self.countryPickerData.count{
                            let countryDict:NSDictionary = self.countryPickerData .object(at: i) as! NSDictionary
                            let  countryID:String = countryDict.object(forKey: "country_id") as! String
                            
                            if self.addEditAddressModel.defaultCountry == countryID{
                                self.countryPicker.selectRow(i, inComponent: 0, animated: false)
                                self.pickerView(self.countryPicker, didSelectRow: i, inComponent: 0)
                            }
                        }
                    }
                }
                
                //GDPR
                self.callGDPR()
            }
            self.scrollView.isHidden = false
        }
    }
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        if(pickerView.tag == 1000){
            return self.countryPickerData.count
        }else if pickerView.tag == 2000{
            return self.statePickerData.count
        }else if pickerView.tag == 3{
            return self.prefixValueArray.count
        }else if pickerView.tag == 4{
            return self.suffixValueArray.count
        }else{
            return 0
        }
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        if(pickerView.tag == 1000){
            let countryDict:NSDictionary = countryPickerData .object(at: row) as! NSDictionary
            let  attributedString:String = countryDict.object(forKey: "name") as! String
            return attributedString
        }else if pickerView.tag == 2000{
            let stateDict:NSDictionary = statePickerData .object(at: row) as! NSDictionary
            let  attributedString:String = stateDict.object(forKey: "name") as! String
            return attributedString
        }else if pickerView.tag == 3{
            return prefixValueArray.object(at: row) as? String
        }else if pickerView.tag == 4{
            return suffixValueArray.object(at: row) as? String
        }else{
            return ""
        }
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int){
        if(pickerView.tag == 1000){
            countryIndex = row
            let countryDict:NSDictionary = countryPickerData .object(at: countryIndex) as! NSDictionary
            if((countryDict.object(forKey: "states")) != nil){
                statePickerData = []
                statePickerData = countryDict.object(forKey: "states") as! NSArray
                if statePickerData.count > 0{
                    let stateDict: NSDictionary = statePickerData.object(at: 0) as! NSDictionary
                    regionId = stateDict.object(forKey: "region_id") as! String
                }
                statePicker.delegate = self
                stateField.isHidden = true
                stateFieldHeightConstarints.constant = 100
                statePicker.isHidden = false
            }else{
                regionId = "0"
                statePicker.isHidden = true
                stateFieldHeightConstarints.constant = 50
                stateField.isHidden = false
            }
            countryValue = (countryDict.object(forKey: "country_id") as! String)
        }
        if(pickerView.tag == 2000){
            let countryDict:NSDictionary = countryPickerData .object(at: countryIndex) as! NSDictionary
            let stateArray:NSArray = countryDict.object(forKey: "states") as! NSArray
            let stateDict: NSDictionary = stateArray.object(at: row) as! NSDictionary
            regionId = stateDict.object(forKey: "region_id") as! String
        }
        
        if pickerView.tag == 3{
            prefixTextField.text = prefixValueArray.object(at: row) as? String
        }
        if pickerView.tag == 4{
            suffixTextField.text = suffixValueArray.object(at: row) as? String
        }
    }
    
    @IBAction func defaultBillingAddressswitch(_ sender: UISwitch) {
        let mySwitch = (sender )
        if mySwitch.isOn {
            default_billing = "1"
        }else{
            
            default_billing = "0"
        }
    }
    
    @IBAction func defaultShippingAddressswitch(_ sender: UISwitch) {
        let mySwitch = (sender )
        if mySwitch.isOn {
            default_shipping = "1"
        }else{
            default_shipping = "0"
        }
    }
    
    @IBAction func saveAddress(_ sender: Any) {
        
        if (addEditAddressModel.gdprEnable && addEditAddressModel.tncAddressEnable && checkBoxBtn.isSelected) || (!addEditAddressModel.gdprEnable) || addOrEdit == "0" {
            //enter if adding new add, GDPR disabled, GDPR enabled and selected
            
            firstNameValue = firstNameTextField.text
            lastNameValue = lastNameTextField.text
            companyValue = companyNameTextField.text
            telephoneValue = mobileNumberTextField.text
            faxValue = faxNumberTextField.text
            street1Value = streetAddress1TextField.text
            street2Value = streetAddress2TextField.text
            street3Value = streetAddress3TextField.text
            street4Value = streetAddress4TextField.text
            cityValue = cityNameTextField.text
            
            if(regionId == "0"){
                regionValue = stateNameTextField.text
            }else{
                regionValue = ""
            }
            zipValue = postalCodeTextField.text
            let countryDict:NSDictionary = countryPickerData .object(at: countryIndex) as! NSDictionary
            countryValue = (countryDict.object(forKey: "country_id") as! String)
            
            
            var errorMessage = ""
            var isValid:Int = 0
            
            if firstNameValue == ""{
                errorMessage = appLanguage.localize(key: "pleasefillfirstname")
                isValid = 1
            }else if lastNameValue == ""{
                errorMessage = appLanguage.localize(key: "pleasefilllastname")
                isValid = 1
            }else if telephoneValue == ""{
                errorMessage = appLanguage.localize(key: "pleasefillmobilenumber")
                isValid = 1
            }else if street1Value == ""{
                errorMessage = appLanguage.localize(key: "pleasefillstreetname")
                isValid = 1
            }else if cityValue == ""{
                errorMessage = appLanguage.localize(key: "entercityname")
                isValid = 1
            }else if zipValue == ""{
                errorMessage = appLanguage.localize(key: "pleasefillzipcode")
                isValid = 1
            }else if((countryDict.object(forKey: "states")) != nil){
                if(regionId  == "0" ){
                    errorMessage = appLanguage.localize(key: "pleasefillregionname")
                    isValid = 1
                }
            }
            
            if addEditAddressModel.isPrefixRequired{
                if prefixTextField.text == ""{
                    isValid = 0
                    errorMessage =  appLanguage.localize(key: "plesefillprefix")
                }
            }
            
            if addEditAddressModel.isSuffixRequired{
                if suffixTextField.text == ""{
                    isValid = 0
                    errorMessage =  appLanguage.localize(key: "plesefillsuffix")
                }
            }
            
            if(isValid == 1){
                AlertManager.shared.showErrorSnackBar(msg: errorMessage)
            }else{
                if self.streetCount == 1{
                    streetArray = [street1Value]
                }
                if self.streetCount == 2{
                    streetArray = [street1Value, street2Value]
                }
                
                if self.streetCount == 3{
                    streetArray = [street1Value, street2Value, street3Value]
                }
                if self.streetCount == 4{
                    streetArray = [street1Value, street2Value, street3Value, street4Value]
                }
                whichApiDataToProcess = "saveformdata"
                callingHttppApi()
            }
        }else{
            AlertManager.shared.showErrorSnackBar(msg: "pleaseagreetogdprtermsandconditions".localized)
        }
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool{
        
        if textField == mobileNumberTextField {
            let ACCEPTABLE_CHARACTERS = "0123456789+"
            
            let cs = NSCharacterSet(charactersIn: ACCEPTABLE_CHARACTERS).inverted
            let filtered = string.components(separatedBy: cs).joined(separator: "")
            
            return (string == filtered)
        }
        
        return true
    }
}

//MARK:- GDPR
extension AddEditAddress : UITextViewDelegate {
    func callGDPR() {
        if addEditAddressModel.gdprEnable && addEditAddressModel.tncAddressEnable {
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
            attributedString.addAttribute(.foregroundColor, value: UIColor.black , range: range)
            
            gdprTxtView.attributedText = attributedString
        } else {
            gdprTxtView.isHidden = true
            checkBoxBtn.isHidden = true
        }
        
        if addEditAddressModel.gdprEnable && addEditAddressModel.gdprRequestAddressInfoBtn {
            //GDPR download button
        } else {
            gdprDownlaodBtn.isHidden = true
            checkBoxBtn.isHidden = true
        }
    }
    
    @available(iOS 10.0, *)
    func textView(_ textView: UITextView, shouldInteractWith URL: URL, in characterRange: NSRange, interaction: UITextItemInteraction) -> Bool {
        //GDPR : Terms and Conditions
        
        let vc = self.storyboard?.instantiateViewController(withIdentifier: "GDPRWebViewController") as! GDPRWebViewController
        vc.backImg = takeScreenshot()
        vc.content = addEditAddressModel.tncAddressContent
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
        UIGraphicsBeginImageContextWithOptions(layer.frame.size, false, scale)
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
        let  url: String = HOST_NAME+"mobikulgdpr/pdf/getaddressinfo"
        fileName = "gdprAddressInfo"+formatter.string(from: date)+".pdf"
        
        let post = NSMutableString()
        post .appendFormat("addressId=%@&", addressId as CVarArg)
        if let customerId = defaults.object(forKey: "customerId") as? String{
            post .appendFormat("customerToken=%@&", customerId as CVarArg)
        }
        if let storeId = defaults.object(forKey: "storeId") as? String  {
            post .appendFormat("storeId=%@&", storeId as CVarArg)
        }
        
        self.load(url: URL(string: url)!, params: post as String, name: fileName)
    }
    
    func load(url: URL, params: String, name: String) {
        GlobalData.sharedInstance.showLoader()
        let sessionConfig = URLSessionConfiguration.default
        let session = URLSession(configuration: sessionConfig)
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        let postString = params
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
                                
                                if let gdprPdfVC = self.storyboard?.instantiateViewController(withIdentifier: "ShowDownloadFile") as? ShowDownloadFile{
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
//                do {
//                } catch (let writeError) {
//                }
            } else {
                GlobalData.sharedInstance.dismissLoader()
                print("Failure: %@", error?.localizedDescription as Any)
            }
        }
        task.resume()
    }
    */
    
    @IBAction func checkBtnClicked(_ sender: UIButton) {
        if sender.isSelected {
            checkBoxBtn.setImage(nil, for: .normal)
            sender.isSelected = false
        } else {
            sender.isSelected = true
        }
    }
}


extension AddEditAddress : CLLocationManagerDelegate {
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
            CLGeocoder().reverseGeocodeLocation(manager.location!, completionHandler: {(placemarks, error)->Void in
                
                if (error != nil) {
                    print("Reverse geocoder failed with error" + (error?.localizedDescription)!)
                    return
                }
                
                if (placemarks?.count)! > 0 {
                    let pm = placemarks?[0]
                    self.displayLocationInfo(pm)
                } else {
                    print("Problem with the data received from geocoder")
                }
            })
        }
        
        func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
              print("Error while updating location ==> " + error.localizedDescription)
        }

}
