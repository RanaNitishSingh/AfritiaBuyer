//
//  ShippingAddressViewController.swift
//  Magento2V4Theme
//
//  Created by Webkul on 19/02/18.
//  Copyright © 2018 Webkul. All rights reserved.
//


@objc protocol BillingAddressPickerDelegate: class {
    func selectBillingAddress(data:Bool,addressId:String,address:String)
}

import UIKit
import CoreLocation

class ShippingAddressViewController: UIViewController,UIPickerViewDelegate,UIPickerViewDataSource,BillingAddressPickerDelegate {
    
    @IBOutlet var mainView: UIView!
    @IBOutlet weak var addressImageView: UIImageView!
    @IBOutlet weak var shipmentImageView: UIImageView!
    @IBOutlet weak var paymantImageView: UIImageView!
    @IBOutlet weak var summaryImageView: UIImageView!
    
    @IBOutlet weak var lblLineAdressRight: UILabel!
    @IBOutlet weak var lblLineShippingLeft: UILabel!
    @IBOutlet weak var lblLineShippingRight: UILabel!
    @IBOutlet weak var lblLinePaymentLeft: UILabel!
    @IBOutlet weak var lblLinePaymentRight: UILabel!
    @IBOutlet weak var lblLineSummaryLeft: UILabel!
    
    
    @IBOutlet weak var addressLabel: UILabel!
    @IBOutlet weak var shippingLabel: UILabel!
    @IBOutlet weak var paymentLabel: UILabel!
    @IBOutlet weak var summaryLabel: UILabel!
   
    @IBOutlet weak var shippingAddressLabel: UILabel!
    @IBOutlet weak var signinAddress: UILabel!
    @IBOutlet weak var changeAddressButton: UIButton!
    @IBOutlet weak var signinView: UIView!
    @IBOutlet weak var sinInViewHeight: NSLayoutConstraint!
    @IBOutlet weak var signoutView: UIView!
    @IBOutlet weak var signoutViewHeightConstarints: NSLayoutConstraint!
    @IBOutlet weak var prefixtextField: UITextField!
    @IBOutlet weak var prefixTextFieldConstaints: NSLayoutConstraint!
    @IBOutlet weak var firstNameField: UITextField!
    @IBOutlet weak var middleNameField: UITextField!
    @IBOutlet weak var middleNameHeightConstaints: NSLayoutConstraint!
    @IBOutlet weak var lastNameField: UITextField!
    @IBOutlet weak var suffixtextFiled: UITextField!
    @IBOutlet weak var suffixTextFieldHeightConstarints: NSLayoutConstraint!
    @IBOutlet weak var genderTextField: UITextField!
    @IBOutlet weak var genderFieldHeight: NSLayoutConstraint!
    @IBOutlet weak var dobtextField: UITextField!
    @IBOutlet weak var dobTextFieldheight: NSLayoutConstraint!
    @IBOutlet weak var taxVatField: UITextField!
    @IBOutlet weak var taxVatFieldheight: NSLayoutConstraint!
    @IBOutlet weak var comanyTextField: UITextField!
    @IBOutlet weak var emailtextField: UITextField!
    @IBOutlet weak var street1Address: UITextField!
    @IBOutlet weak var street2Address: UITextField!
    @IBOutlet weak var street2AddressFieldHeight: NSLayoutConstraint!
    @IBOutlet weak var street3textField: UITextField!
    @IBOutlet weak var street3textFieldheight: NSLayoutConstraint!
    @IBOutlet weak var street4textField: UITextField!
    @IBOutlet weak var street4textFieldHeight: NSLayoutConstraint!
    @IBOutlet weak var citytextField: UITextField!
    @IBOutlet weak var telephonetextField: UITextField!
    @IBOutlet weak var faxField: UITextField!
    @IBOutlet weak var countryTextField: UITextField!
    @IBOutlet weak var stateTextField: UITextField!
    //@IBOutlet weak var mainViewHeightConstarints: NSLayoutConstraint!
    @IBOutlet weak var postCodeTextField: UITextField!
    @IBOutlet weak var continueButton: UIButton!
    @IBOutlet weak var cancelButton: UIBarButtonItem!
    @IBOutlet var locationButton: UIBarButtonItem!
    @IBOutlet var activityIndicatorButton: UIBarButtonItem!
    var activityIndicator: UIActivityIndicatorView!
    
    var locationManager = CLLocationManager()
    var currentCountryRow:Int = 0
    var countryId:String = ""
    var regionId:String = ""
    var genderValueArray:NSMutableArray = []
    var streetArray:NSArray = []
    var newAddressFlag:Int = 0
    var genderValue:String = ""
    var shipmentPaymentMethodViewModel:ShipmentAndPaymentViewModel!
    var whichApiToProcess:String = ""
    var billingViewModel:BillingAndShipingViewModel!
    var billingId:String!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        addressImageView.backgroundColor = UIColor.DarkLavendar
        addressImageView.layer.cornerRadius = 4
        addressImageView.layer.masksToBounds = true
        
        shipmentImageView.layer.cornerRadius = 4
        shipmentImageView.layer.masksToBounds = true
        
        paymantImageView.layer.cornerRadius = 4
        paymantImageView.layer.masksToBounds = true
        
        summaryImageView.layer.cornerRadius = 4
        summaryImageView.layer.masksToBounds = true
        
        
        self.lblLineAdressRight.backgroundColor = UIColor.Magnesium
        self.lblLineShippingLeft.backgroundColor = UIColor.Magnesium
        self.lblLineShippingRight.backgroundColor = UIColor.Magnesium
        self.lblLinePaymentLeft.backgroundColor = UIColor.Magnesium
        self.lblLinePaymentRight.backgroundColor = UIColor.Magnesium
        self.lblLineSummaryLeft.backgroundColor = UIColor.Magnesium
        
        self.tabBarController?.tabBar.isHidden = true
        self.navigationController!.isNavigationBarHidden = false
        self.tabBarController?.navigationController?.navigationBar.isHidden = true
        
        self.title = "billingaddress".localized
        cancelButton.title = "cancel".localized
        
        whichApiToProcess = "steponetwo"
        signinView.layer.borderColor = UIColor.appLightGrey.cgColor
        signinView.layer.borderWidth = 1.0
        self.callingHttppApi()
        
        prefixtextField.isHidden = true
        prefixTextFieldConstaints.constant = 0
        suffixtextFiled.isHidden = true
        suffixTextFieldHeightConstarints.constant = 0
        middleNameField.isHidden = true
        middleNameHeightConstaints.constant = 0
        genderTextField.isHidden = true
        genderFieldHeight.constant = 0
        dobtextField.isHidden = true
        dobTextFieldheight.constant = 0
        
        street2Address.isHidden = true
        street2AddressFieldHeight.constant = 0
        street3textField.isHidden = true
        street3textFieldheight.constant = 0
        street4textField.isHidden = true
        street4textFieldHeight.constant = 0
        taxVatField.isHidden = true
        taxVatFieldheight.constant = 0

        //changeAddressButton.setTitleColor(UIColor.button, for: .normal)
        shippingAddressLabel.text = "shippingaddress".localized
        
        changeAddressButton.setTitle("changeaddress".localized, for: .normal)
        changeAddressButton.applyAfritiaTheme()
        
        continueButton.setTitle("continue".localized, for: .normal)
        continueButton.applyAfritiaTheme()
        
        if DEFAULTS.object(forKey: "isVirtual") as! String == "false"{
            shippingAddressLabel.isHidden = false
        }else{
            shippingAddressLabel.isHidden = true
        }
        
        firstNameField.placeholder = "firstname".localized + "required".localized
        middleNameField.placeholder = "middlename".localized
        telephonetextField.placeholder = "telephone".localized + "required".localized
        comanyTextField.placeholder = "company".localized
        postCodeTextField.placeholder = "postcode".localized + "required".localized
        citytextField.placeholder = "city".localized + "required".localized
        street1Address.placeholder = "street1".localized + "required".localized
        street2Address.placeholder = "street2".localized
        emailtextField.placeholder = "email".localized + "required".localized
        lastNameField.placeholder = "lastname".localized + "required".localized
        faxField.placeholder = "fax".localized
        
        prefixtextField.placeholder = "prefix".localized
        suffixtextFiled.placeholder = "suffix".localized
        genderTextField.placeholder = "gender".localized
        dobtextField.placeholder = "dob".localized
        taxVatField.placeholder = "taxvat".localized
        stateTextField.placeholder = "state".localized
        countryTextField.placeholder = "country".localized
        
        addressLabel.text = "address".localized
        shippingLabel.text = "shipping".localized
        paymentLabel.text = "payment".localized
        summaryLabel.text = "summary".localized
        mainView.isHidden = true
        
        activityIndicator = UIActivityIndicatorView.init(activityIndicatorStyle: .white)
        activityIndicator.hidesWhenStopped = true
        activityIndicatorButton.customView = activityIndicator
        
        self.checkLocaationPermissionAndGetMyAddress()
        
        /*
        locationManager = CLLocationManager()
        locationManager.requestAlwaysAuthorization()
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.delegate = self*/
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        locationButton.isHidden = false
        self.navigationController?.isNavigationBarHidden = false
        self.navigationController?.navigationBar.applyAfritiaTheme()
        self.title =  "Shipping Address"
    }
    
    @IBAction func dismissController(_ sender: UIBarButtonItem) {
        self.dismiss(animated: true)
    }
    
    //MARK: - GPS fetch location
    // ----- location GPS
    
    @IBAction func fetchGPSLocation(_ sender: UIBarButtonItem)
    {
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
        
        self.locationButton.customView = activityIndicator
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
            
            self.citytextField.text = locality
            self.street1Address.text = subLocality
            self.stateTextField.text = administrativeArea
            self.postCodeTextField.text = postalCode
            
            print("Country",country!)
            print("CoutryCode :", countryCode!)
            print("City :", locality!)
            print("Street1 :", subLocality!)
            print("State :", administrativeArea!)
            print("postalCode :", postalCode!)
            
            
            for i in 0..<self.billingViewModel.countryData.count{
                if(self.billingViewModel.countryData[i].countryId == countryCode!){
                    self.currentCountryRow = i
                    self.countryId = self.billingViewModel.countryData[i].countryId
                    self.countryTextField.text = self.billingViewModel.countryData[i].name
                    break
                }
            }
            
            activityIndicator.stopAnimating()
            self.locationButton.customView = nil
            
            
            /*
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
            }*/
        }

    }
    
    /*
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        let locationArray = locations as NSArray
        let locationObj = locationArray.lastObject as! CLLocation
        let geocoder = CLGeocoder()
        
        geocoder.reverseGeocodeLocation(locationObj, completionHandler: {(placemarks, error)->Void in
            var placemark:CLPlacemark!
            
            if error == nil && (placemarks?.count)! > 0 {
                placemark = placemarks?[0]
                let countryCode = placemark.isoCountryCode
                for i in 0..<self.billingViewModel.countryData.count{
                    if(self.billingViewModel.countryData[i].countryId == countryCode!){
                        self.currentCountryRow = i
                        self.countryId = self.billingViewModel.countryData[i].countryId
                        self.countryTextField.text = self.billingViewModel.countryData[i].name
                        break
                    }
                }
                
                
                print("CoutryCode :", countryCode!)
                print("City :", placemark.locality!)
                print("Street1 :", placemark.subLocality!)
                print("State :", placemark.administrativeArea!)
                print("postalCode :", placemark.postalCode!)
                
                self.citytextField.text = placemark.locality
                self.street1Address.text = placemark.subLocality
                self.stateTextField.text = placemark.administrativeArea
                self.postCodeTextField.text = placemark.postalCode
            }
        })
        activityIndicator.stopAnimating()
        locationManager.stopUpdatingLocation()
    }
    // ----- location GPS
 */
    
    //MARK: -
    
    func callingHttppApi()  {
        
        DispatchQueue.main.async {
            self.view.isUserInteractionEnabled = false
            GlobalData.sharedInstance.showLoader()
            var requstParams = [String:Any]()
            let customerId = DEFAULTS.object(forKey: "customerId")
            let storeId = DEFAULTS.object(forKey: "storeId")
            let quoteId = DEFAULTS.object(forKey: "quoteId")
            let currency =  DEFAULTS.object(forKey: "currency")
            if currency != nil{
                requstParams["currency"] = DEFAULTS.object(forKey: "currency") as! String
            }
            if(customerId != nil){
                requstParams["customerToken"] = customerId
                requstParams["checkoutMethod"] = "customer"
                requstParams["quoteId"] = ""
            }else{
                if(quoteId != nil ){
                    requstParams["quoteId"] = quoteId
                    requstParams["checkoutMethod"] = "guest"
                    requstParams["customerToken"] = ""
                }
            }
            
            if(self.whichApiToProcess == "steponetwo"){
                requstParams["storeId"] = storeId
                APIServiceManager.shared.callingHttpRequest(params:requstParams, apiname:AfritiaAPI.billingShippingInfo, currentView: self){success,responseObject in
                    if success == 1{
                        GlobalData.sharedInstance.dismissLoader()
                        print(responseObject as! NSDictionary)
                        if responseObject?.object(forKey: "storeId") != nil{
                            let storeId:String = String(format: "%@", responseObject!.object(forKey: "storeId") as! CVarArg)
                            if storeId != "0"{
                                DEFAULTS.set(storeId, forKey: "storeId")
                            }
                        }
                        
                        let dict =  JSON(responseObject as! NSDictionary)
                        self.view.isUserInteractionEnabled = true
                        if dict["success"].boolValue == true{
                            self.billingViewModel = BillingAndShipingViewModel(data: dict)
                            GlobalVariables.shippingAndBillingViewModel = self.billingViewModel
                            self.doFurtherData()
                        }else{
                            AlertManager.shared.showErrorSnackBar(msg: dict["message"].stringValue)
                        }
                    }else if success == 2{
                        GlobalData.sharedInstance.dismissLoader()
                        self.callingHttppApi()
                    }
                }
            }
            else{
                var BDDict = [String:AnyObject]()
                var BDNewAddrDict = [String:AnyObject]()
                var SDDict = [String:AnyObject]()
                var SDNewAddrDict = [String:AnyObject]()
                
                if(self.newAddressFlag == 0){
                    BDDict["addressId"] = self.billingId as AnyObject
                }else{
                    BDDict["addressId"] = "0" as AnyObject?
                    BDNewAddrDict["firstName"] = self.firstNameField.text as AnyObject?
                    BDNewAddrDict["lastName"] = self.lastNameField.text as AnyObject?
                    BDNewAddrDict["company"] = self.comanyTextField.text as AnyObject?
                    BDNewAddrDict["street"] = self.streetArray as AnyObject?
                    BDNewAddrDict["city"] = self.citytextField.text as AnyObject?
                    BDNewAddrDict["email"] = self.emailtextField.text as AnyObject?
                    BDNewAddrDict["postcode"] = self.postCodeTextField.text as AnyObject?
                    BDNewAddrDict["telephone"] = self.telephonetextField.text as AnyObject?
                    BDNewAddrDict["fax"] = self.faxField.text as AnyObject?
                    BDNewAddrDict["prefix"] = self.prefixtextField.text as AnyObject?
                    BDNewAddrDict["middleName"] = self.middleNameField.text as AnyObject?
                    BDNewAddrDict["suffix"] = self.suffixtextFiled.text as AnyObject?
                    BDNewAddrDict["gender"] = self.genderValue as AnyObject?
                    BDNewAddrDict["dob"] = self.dobtextField.text as AnyObject?
                    BDNewAddrDict["taxvat"] = self.taxVatField.text as AnyObject?
                    BDNewAddrDict["saveInAddressBook"] = "1" as AnyObject
                    if(self.regionId == "0"){
                        BDNewAddrDict["region_id"] = "" as AnyObject?
                        BDNewAddrDict["region"] = self.stateTextField.text as AnyObject?
                    }else{
                        BDNewAddrDict["region_id"] = self.regionId as AnyObject?
                        BDNewAddrDict["region"] = "" as AnyObject?
                    }
                    BDNewAddrDict["country_id"] = self.countryId as AnyObject?
                }
                
                if DEFAULTS.object(forKey: "isVirtual") as! String  == "false"{
                    BDDict["useForShipping"] = "1" as AnyObject?
                }else{
                    BDDict["useForShipping"] = "0" as AnyObject?
                }
                
                BDDict["newAddress"] = BDNewAddrDict as AnyObject?
                do {
                    let jsonBillingData =  try JSONSerialization.data(withJSONObject: BDDict, options: .prettyPrinted)
                    let jsonBillingString:String = NSString(data: jsonBillingData, encoding: String.Encoding.utf8.rawValue)! as String
                    requstParams["billingData"] = jsonBillingString
                }
                catch {
                    print(error.localizedDescription)
                }
                
                if(DEFAULTS.object(forKey: "isVirtual") as! String == "false"){
                    
                    if(self.newAddressFlag == 0){
                        SDDict["addressId"] = self.billingId as AnyObject
                    }else{
                        SDDict["addressId"] = "0" as AnyObject?
                        SDNewAddrDict["firstName"] = self.firstNameField.text as AnyObject?
                        SDNewAddrDict["lastName"] = self.lastNameField.text as AnyObject?
                        SDNewAddrDict["company"] = self.comanyTextField.text as AnyObject?
                        SDNewAddrDict["street"] = self.streetArray as AnyObject?
                        SDNewAddrDict["city"] = self.citytextField.text as AnyObject?
                        SDNewAddrDict["email"] = self.emailtextField.text as AnyObject?
                        SDNewAddrDict["postcode"] = self.postCodeTextField.text as AnyObject?
                        SDNewAddrDict["telephone"] = self.telephonetextField.text as AnyObject?
                        SDNewAddrDict["fax"] = self.faxField.text as AnyObject?
                        SDNewAddrDict["prefix"] = self.prefixtextField.text as AnyObject?
                        SDNewAddrDict["middleName"] = self.middleNameField.text as AnyObject?
                        SDNewAddrDict["suffix"] = self.suffixtextFiled.text as AnyObject?
                        SDNewAddrDict["gender"] = self.genderValue as AnyObject?
                        SDNewAddrDict["dob"] = self.dobtextField.text as AnyObject?
                        SDNewAddrDict["taxvat"] = self.taxVatField.text as AnyObject?
                        SDNewAddrDict["saveInAddressBook"] = "1" as AnyObject
                        if(self.regionId == "0"){
                            SDNewAddrDict["region_id"] = "" as AnyObject?
                            SDNewAddrDict["region"] = self.stateTextField.text as AnyObject?
                        }else{
                            SDNewAddrDict["region_id"] = self.regionId as AnyObject?
                            SDNewAddrDict["region"] = "" as AnyObject?
                        }
                        SDNewAddrDict["country_id"] = self.countryId as AnyObject?
                    }
                    
                    SDDict["sameAsBilling"] = "1" as AnyObject?
                    SDDict["newAddress"] = SDNewAddrDict as AnyObject?
                    do {
                        let jsonShippingData =  try JSONSerialization.data(withJSONObject: SDDict, options: .prettyPrinted)
                        let jsonShippingString:String = NSString(data: jsonShippingData, encoding: String.Encoding.utf8.rawValue)! as String
                        requstParams["shippingData"] = jsonShippingString
                    }
                    catch {
                        print(error.localizedDescription)
                    }
                }
                requstParams["storeId"] = storeId
                APIServiceManager.shared.callingHttpRequest(params:requstParams, apiname:AfritiaAPI.shippingPaymentMethodInfo, currentView: self){success,responseObject in
                    if success == 1{
                        if responseObject?.object(forKey: "storeId") != nil{
                            let storeId:String = String(format: "%@", responseObject!.object(forKey: "storeId") as! CVarArg)
                            if storeId != "0"{
                                DEFAULTS.set(storeId, forKey: "storeId")
                            }
                        }
                        
                        self.view.isUserInteractionEnabled = true
                        GlobalData.sharedInstance.dismissLoader()
                        let dict = JSON(responseObject! as! NSDictionary)
                        print("sss", dict)
                        if dict["success"].boolValue == true{
                            self.shipmentPaymentMethodViewModel = ShipmentAndPaymentViewModel(data: dict)
                            self.goToNextController()
                        }else{
                            AlertManager.shared.showErrorSnackBar(msg: dict["message"].stringValue)
                        }
                    }else if success == 2{
                        GlobalData.sharedInstance.dismissLoader()
                        self.callingHttppApi()
                    }
                }
            }
        }
    }
    
    func selectBillingAddress(data:Bool,addressId:String,address:String){
        self.billingId = addressId
        self.signinAddress.text = address
        sinInViewHeight.constant = (signinAddress.text?.height(withConstrainedWidth: SCREEN_WIDTH - 40, font: UIFont.systemFont(ofSize: 15)))! + 70
    }
    
    func  goToNextController(){
        
        if DEFAULTS.object(forKey: "isVirtual") as! String == "false"{
            GlobalVariables.CurrentIndex = 2
            self.tabBarController!.selectedIndex = 1
        }else{
            GlobalVariables.CurrentIndex = 3
            self.tabBarController!.selectedIndex = 2
        }
    }
    
    func doFurtherData()    {
        
        mainView.isHidden = false
        if self.billingViewModel.addressData.count > 0{
            self.signinAddress.text = self.billingViewModel.addressData[0].value
            self.billingId = self.billingViewModel.addressData[0].id
            sinInViewHeight.constant = (signinAddress.text?.height(withConstrainedWidth: SCREEN_WIDTH - 40, font: UIFont.systemFont(ofSize: 15)))! + 70
            signoutView.isHidden = true
            newAddressFlag = 0
            //mainViewHeightConstarints.constant = 600
        }else{
            newAddressFlag = 1
            sinInViewHeight.constant = 0
            signinView.isHidden = true
            //mainViewHeightConstarints.constant = 800
            var Y:CGFloat = 0
            
            self.countryTextField.text = self.billingViewModel.countryData[0].name
            self.currentCountryRow = 0
            self.countryId = self.billingViewModel.countryData[0].countryId
            if self.billingViewModel.countryData[0].stateData.count > 0{
                regionId = self.billingViewModel.countryData[0].stateData[0].regionId
                stateTextField.text = self.billingViewModel.countryData[0].stateData[0].name
            }else{
                self.regionId = "0"
            }
            
            if billingViewModel.billingShippingModel.isPrifixVisible == true{
                self.prefixtextField.isHidden = false
                prefixTextFieldConstaints.constant = 45
                Y += 50
            }
            if billingViewModel.billingShippingModel.isSuffixVisible == true{
                self.suffixtextFiled.isHidden = false
                suffixTextFieldHeightConstarints.constant = 45
                Y += 50
            }
            if billingViewModel.billingShippingModel.isMiddleNameVisible == true{
                self.middleNameField.isHidden = false
                middleNameHeightConstaints.constant = 45
                Y += 50
            }
            if billingViewModel.billingShippingModel.isGenderVisible == true{
                self.genderTextField.isHidden = false
                genderFieldHeight.constant = 45
                Y += 50
            }
            if billingViewModel.billingShippingModel.isDobVisible == true{
                self.dobtextField.isHidden = false
                dobTextFieldheight.constant = 45
                Y += 50
            }
            if billingViewModel.billingShippingModel.isTaxVisible == true{
                self.taxVatField.isHidden = false
                taxVatFieldheight.constant = 45
                Y += 50
            }
            if billingViewModel.billingShippingModel.streetCount == 2{
                street2Address.isHidden = false
                street2AddressFieldHeight.constant = 45
                Y += 50
            }
            if billingViewModel.billingShippingModel.streetCount == 3{
                street2Address.isHidden = false
                street2AddressFieldHeight.constant = 45
                street3textField.isHidden = false
                street3textFieldheight.constant = 45
                Y += 100
            }
            if billingViewModel.billingShippingModel.streetCount == 4{
                street2Address.isHidden = false
                street2AddressFieldHeight.constant = 45
                street3textField.isHidden = false
                street3textFieldheight.constant = 45
                street4textField.isHidden = false
                street4textFieldHeight.constant = 45
                Y += 150
                
            }
            
            //mainViewHeightConstarints.constant = 800 + Y
            
            if billingViewModel.billingShippingModel.isGenderRequired == true{
                self.genderValueArray = ["Female", "Male"]
            }else{
                self.genderValueArray = ["Female","Male"," "]
            }
            
            let customerId = DEFAULTS.object(forKey: "customerId")
            if(customerId != nil) {
                emailtextField.text = DEFAULTS.object(forKey: "customerEmail") as? String
                emailtextField.isEnabled = false
            }
            
            if self.billingViewModel.billingShippingModel.isPrefixRequired == true {
                prefixtextField.placeholder = "prefix".localized + "required".localized
            }
            
            if self.billingViewModel.billingShippingModel.isSuffixRequired == true {
                suffixtextFiled.placeholder = "suffix".localized + "required".localized
            }
            
            if self.billingViewModel.billingShippingModel.isGenderRequired == true {
                genderTextField.placeholder = "gender".localized + "required".localized
            }
            
            if self.billingViewModel.billingShippingModel.isDobRequired == true {
                dobtextField.placeholder = "dob".localized + "required".localized
            }
            
            if self.billingViewModel.billingShippingModel.isTaxRequired == true {
                taxVatField.placeholder = "taxvat".localized + "required".localized
            }
        }
    }
    
    
    @IBAction func changeAddressClick(_ sender: UIButton) {
        
        let vc = AppStoryboard.Main.instance.instantiateViewController(withIdentifier: "BillingAddressPicker") as! BillingAddressPicker
        vc.billingViewModel = GlobalVariables.shippingAndBillingViewModel
        vc.addressID = self.billingId
        vc.delegate = self
        self.navigationController?.pushViewController(vc, animated: true)
        //self.performSegue(withIdentifier: "addresspicker", sender: self)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if (segue.identifier! == "addresspicker") {
            let viewController:BillingAddressPicker = segue.destination as UIViewController as! BillingAddressPicker
            viewController.billingViewModel = GlobalVariables.shippingAndBillingViewModel
            viewController.addressID = self.billingId
            viewController.delegate = self
        }
    }
    
    @IBAction func PrefixClick(_ sender: UITextField) {
        if billingViewModel.billingShippingModel.isPrefixHasOption == true {
            let thePicker = UIPickerView()
            thePicker.tag = 3000
            prefixtextField.inputView = thePicker
            thePicker.delegate = self
        }
    }
    
    @IBAction func SuffixClick(_ sender: UITextField) {
        if billingViewModel.billingShippingModel.isSuffixHasOption == true{
            let thePicker = UIPickerView()
            thePicker.tag = 4000
            suffixtextFiled.inputView = thePicker
            thePicker.delegate = self
        }
    }
    
    @IBAction func genderClick(_ sender: UITextField) {
        let thePicker = UIPickerView()
        thePicker.tag = 5000
        genderTextField.inputView = thePicker
        thePicker.delegate = self
    }
    
    @IBAction func dobClick(_ sender: UITextField) {
        let datePickerView:UIDatePicker = UIDatePicker()
        datePickerView.datePickerMode = UIDatePickerMode.date
        dobtextField.inputView = datePickerView
        datePickerView.addTarget(self, action: #selector(ShippingAddressViewController.datePickerFromValueChanged), for: UIControlEvents.valueChanged)
    }
    
    @objc func datePickerFromValueChanged(sender:UIDatePicker) {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = self.billingViewModel.billingShippingModel.dobFormat
        dobtextField.text = dateFormatter.string(from: sender.date)
    }
    
    @IBAction func countryClick(_ sender: UITextField) {
        let thePicker = UIPickerView()
        thePicker.tag = 1000
        countryTextField.inputView = thePicker
        thePicker.delegate = self
    }
    
    @IBAction func stateClick(_ sender: UITextField) {
        if self.billingViewModel.countryData[currentCountryRow].stateData.count > 0 {
            let thePicker = UIPickerView()
            thePicker.tag = 2000
            stateTextField.inputView = thePicker
            thePicker.delegate = self
        }
    }
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        if pickerView.tag == 1000 {
            return self.billingViewModel.countryData.count
        } else if pickerView.tag == 2000 {
            return self.billingViewModel.countryData[currentCountryRow].stateData.count
        } else if pickerView.tag == 3000 {
            return self.billingViewModel.billingShippingModel.prefixOptions.count
        } else if pickerView.tag == 4000 {
            return self.billingViewModel.billingShippingModel.suffixOptions.count
        } else if pickerView.tag == 5000 {
            return genderValueArray.count
        } else {
            return 0
        }
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        if pickerView.tag == 1000 {
            return self.billingViewModel.countryData[row].name
        } else  if pickerView.tag == 2000 {
            return self.billingViewModel.countryData[currentCountryRow].stateData[row].name
        } else if pickerView.tag == 3000 {
            return self.billingViewModel.billingShippingModel.prefixOptions[row] as? String
        } else if pickerView.tag == 4000 {
            return self.billingViewModel.billingShippingModel.suffixOptions[row] as? String
        } else if pickerView.tag == 5000 {
            return genderValueArray[row] as? String
        } else {
            return ""
        }
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        if(pickerView.tag == 1000) {
            self.countryTextField.text =  self.billingViewModel.countryData[row].name
            currentCountryRow = row
            self.countryId = self.billingViewModel.countryData[row].countryId
            if self.billingViewModel.countryData[row].stateData.count > 0 {
                self.regionId = self.billingViewModel.countryData[row].stateData[0].regionId
                self.stateTextField.text = self.billingViewModel.countryData[row].stateData[0].name
            } else {
                self.stateTextField.text = ""
                self.regionId = "0"
            }
        } else if pickerView.tag == 2000 {
            self.stateTextField.text = self.billingViewModel.countryData[currentCountryRow].stateData[row].name
            self.regionId = self.billingViewModel.countryData[currentCountryRow].stateData[row].regionId
        } else if pickerView.tag == 3000 {
            self.prefixtextField.text = self.billingViewModel.billingShippingModel.prefixOptions[row] as? String
        } else if pickerView.tag == 4000 {
            self.suffixtextFiled.text = self.billingViewModel.billingShippingModel.suffixOptions[row] as? String
        } else if pickerView.tag == 5000 {
            self.genderTextField.text = genderValueArray[row] as? String
        }
    }
    
    @IBAction func continueClick(_ sender: UIButton) {
        if self.billingViewModel.addressData.count > 0 {
            whichApiToProcess = "stepthreefour"
            self.callingHttppApi()
        } else {
            var isValid:Int = 1
            var errorMessage:String = "pleasefill".localized
            
            if(firstNameField.text == "") {
                isValid = 0
                errorMessage = "pleasefillfirstname".localized
            } else if(lastNameField.text == "") {
                isValid = 0
                errorMessage = "pleasefilllastname".localized
            } else if(street1Address.text == "") {
                isValid = 0
                errorMessage = "enteraddress1".localized
            } else if(citytextField.text == "") {
                isValid = 0
                errorMessage = "entercityname".localized
            } else if(telephonetextField.text == "") {
                isValid = 0
                errorMessage = "pleasefillmobilenumber".localized
            } else if(postCodeTextField.text == "") {
                isValid = 0
                errorMessage = "pleasefillpostalcode".localized
            } else if(emailtextField.text == "") {
                isValid = 0
                errorMessage = "pleasefillemailid".localized
            } else if !GlobalData.sharedInstance.checkValidEmail(data: emailtextField.text!) {
                isValid = 0
                errorMessage = "pleasefilllvalidemail".localized
            } else if self.billingViewModel.billingShippingModel.isPrefixRequired == true{
                    if prefixtextField.text == ""{
                        isValid = 0
                        errorMessage = errorMessage+" "+"Fill prefix Value"
                    }
            }
            if self.billingViewModel.billingShippingModel.isSuffixRequired == true {
                if suffixtextFiled.text == "" {
                    isValid = 0
                    errorMessage = errorMessage+" "+"Fill Suffix Value"
                }
            }
            if self.billingViewModel.billingShippingModel.isGenderRequired == true {
                if genderTextField.text == "" {
                    isValid = 0
                    errorMessage = errorMessage+" "+"Fill Gender Value"
                }
            }
            if self.billingViewModel.billingShippingModel.isDobRequired == true {
                if dobtextField.text == "" {
                    isValid = 0
                    errorMessage = errorMessage+" "+"Fill DOB Value"
                }
            }
            if self.billingViewModel.billingShippingModel.isTaxRequired == true {
                if taxVatField.text == "" {
                    isValid = 0
                    errorMessage = errorMessage+" "+"Fill Tax Vat Value"
                }
            }
            if self.billingViewModel.countryData[currentCountryRow].stateData.count > 0 {
                if stateTextField.text == "" {
                    isValid = 0
                    errorMessage = errorMessage + " " + "fillstatename".localized
                }
            }
            
            if isValid == 0 {
                AlertManager.shared.showErrorSnackBar(msg: errorMessage)
            } else {
                if self.billingViewModel.billingShippingModel.streetCount == 1 {
                    streetArray = [street1Address.text ?? ""]
                } else if self.billingViewModel.billingShippingModel.streetCount == 2 {
                    streetArray = [street1Address.text!,street2Address.text!]
                } else if self.billingViewModel.billingShippingModel.streetCount == 3 {
                    streetArray = [street1Address.text!,street2Address.text!,street3textField.text!]
                } else if self.billingViewModel.billingShippingModel.streetCount == 4 {
                    streetArray = [street1Address.text!,street2Address.text!,street3textField.text!,street4textField.text!]
                }
                
                let data:String = genderTextField.text!
                if data == "Male" {
                    genderValue = "1"
                } else if data == "Female" {
                    genderValue = "0"
                } else {
                    genderValue = ""
                }
                
                whichApiToProcess = "stepthreefour"
                self.callingHttppApi()
            }
        }
    }
}

extension ShippingAddressViewController : CLLocationManagerDelegate {
    
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
