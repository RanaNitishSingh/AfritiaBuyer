//
//  AdvanceSearch.swift
//  Mobikul
//
//  Created by Webkul on 13/02/17.
//  Copyright © 2017 Webkul. All rights reserved.
//

import UIKit

class AdvanceSearch: AfritiaBaseViewController {
    
    @IBOutlet weak var mainView: UIView!
    @IBOutlet weak var mainViewHeightConstarints: NSLayoutConstraint!
    @IBOutlet weak var mainScrollView: UIScrollView!
    @IBOutlet weak var searchBtn: UIButton!
    @IBOutlet weak var afritiaNavBarView: AFNavigationBarView!
    @IBOutlet weak var afritiaNavBarViewHeight:NSLayoutConstraint!
    
    var mainCollection:JSON!
    var queryString: NSMutableArray = []
    var queryStringDict = [String:AnyObject]()
    var selectedDate: Date?
    var textFieldTag:Int = 0
    var datePicker:UIDatePicker!
    var dateView:UIView!
    var keyBoardFlag:Int = 1
    let globalObjectAdvanceSearch = GlobalData()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //self.navigationController?.isNavigationBarHidden = false
        //self.navigationController?.navigationBar.applyAfritiaTheme()
        //self.title = "advancesearch".localized
        
        self.setUpCustomNavigationBar()
        
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(AdvanceSearch.dismissKeyboard))
        view.addGestureRecognizer(tap)

        searchBtn.applyAfritiaTheme()
        searchBtn.setTitle("search".localized, for: .normal)
        //let searchBtnGesture = UITapGestureRecognizer(target: self, action: #selector(self.searchButtonClicked))
        //searchBtnGesture.numberOfTapsRequired = 1
        //searchBtn.addGestureRecognizer(searchBtnGesture)
        searchBtn.isHidden = true
        callingHttppApi()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        //self.navigationController!.isNavigationBarHidden = false
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(true)
        //navigationItem.backBarButtonItem = UIBarButtonItem(title: " ", style: .plain, target: nil, action: nil)
    }
    
    @objc func dismissKeyboard() {
        view.endEditing(true)
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
    
    func callingHttppApi(){
        GlobalData.sharedInstance.showLoader()
        self.view.isUserInteractionEnabled = false
        var requstParams = [String:Any]()
        if DEFAULTS.object(forKey: "storeId") != nil{
            requstParams["storeId"] = DEFAULTS.object(forKey: "storeId") as! String
        }
        APIServiceManager.shared.callingHttpRequest(params:requstParams, apiname:AfritiaAPI.advanceSearchFormData, currentView: self){success,responseObject in
            if success == 1{
                self.view.isUserInteractionEnabled = false
                GlobalData.sharedInstance.dismissLoader()
                if responseObject?.object(forKey: "storeId") != nil{
                    let storeId:String = String(format: "%@", responseObject!.object(forKey: "storeId") as! CVarArg)
                    if storeId != "0"{
                        DEFAULTS.set(storeId, forKey: "storeId")
                    }
                }
                print("sss", responseObject as Any)
                self.doFurtherProcessingWithResult(data:responseObject as! NSDictionary)
            }else if success == 2{
                GlobalData.sharedInstance.dismissLoader()
                self.callingHttppApi()
            }
        }
    }
    
    func doFurtherProcessingWithResult(data :NSDictionary){
        DispatchQueue.main.async { [self] in
            self.view.isUserInteractionEnabled = true;
            //print(data)
            self.mainCollection = JSON(data)
            var y:CGFloat = 8
            let  x:CGFloat = 8
            
            for i in 0..<self.mainCollection["fieldList"].count {
                let formFieldDict = self.mainCollection["fieldList"][i]
                
                if (formFieldDict["inputType"].stringValue == "string") || (formFieldDict["inputType"].stringValue == "number") {
                    
                    let fieldLabel = UILabel(frame: CGRect(x: CGFloat(x), y: CGFloat(y), width: CGFloat(SCREEN_WIDTH - 16), height: CGFloat(32)))
                    fieldLabel.textColor = UIColor.black
                    fieldLabel.backgroundColor = UIColor.clear
                    fieldLabel.text = formFieldDict["label"].stringValue
                    self.mainView.addSubview(fieldLabel)
                    y += 37
                    let textField = UITextField(frame: CGRect(x: CGFloat(x), y: CGFloat(y), width: CGFloat(SCREEN_WIDTH - 16), height: CGFloat(32)))
                    //                            let pleaceholderText: String = self.globalObjectAdvanceSearch.languageBundle.localizedString(forKey: "enter", value: "", table: nil) + " " + "\(formFieldDict["label"] as! String)"
                    // textField.placeholder = pleaceholderText
                    textField.tag = i
                    textField.borderStyle = .roundedRect
                    textField.tintColor = UIColor.black
                    self.mainView.addSubview(textField)
                    y += 40
                    self.queryStringDict = [String : AnyObject]()
                    self.queryStringDict["code"] = formFieldDict["attributeCode"].stringValue as AnyObject?
                    self.queryStringDict["inputType"] = formFieldDict["inputType"].stringValue as AnyObject?
                    self.queryStringDict["value"] = "" as AnyObject?
                    self.queryString.add(self.queryStringDict)
                    
                }else if (formFieldDict["inputType"].stringValue) == "price" {
                    
                    let priceLabel = UILabel(frame: CGRect(x: CGFloat(x), y: CGFloat(y), width: CGFloat(SCREEN_WIDTH - 16), height: CGFloat(32)))
                    priceLabel.textColor = UIColor.black
                    priceLabel.backgroundColor = UIColor.clear
                    priceLabel.font = UIFont(name: REGULARFONT, size: CGFloat(15))
                    priceLabel.text = formFieldDict["label"].stringValue
                    self.mainView.addSubview(priceLabel)
                    y += 37
                    let fromField = UITextField(frame: CGRect(x: CGFloat(x), y: CGFloat(y), width: CGFloat((SCREEN_WIDTH - 16) / 3), height: CGFloat(32)))
                    fromField.tag = i
                    fromField.borderStyle = .roundedRect
                    fromField.tintColor = UIColor.black
                    fromField.font = UIFont.systemFont(ofSize: CGFloat(19))
                    fromField.keyboardType = .numberPad
                    self.mainView.addSubview(fromField)
                    let hifen = UILabel(frame: CGRect(x: CGFloat(((SCREEN_WIDTH - 16) / 3) + x + 5), y: CGFloat(y), width: CGFloat(8), height: CGFloat(32)))
                    hifen.textColor = UIColor.black
                    hifen.backgroundColor = UIColor.clear
                    hifen.text = "-"
                    self.mainView.addSubview(hifen)
                    let toField = UITextField(frame: CGRect(x: CGFloat(((SCREEN_WIDTH - 16) / 3) + x + 18), y: CGFloat(y), width: CGFloat((SCREEN_WIDTH - 16) / 3), height: CGFloat(32)))
                    toField.tag = i
                    toField.borderStyle = .roundedRect
                    toField.tintColor = UIColor.black
                    toField.font = UIFont.systemFont(ofSize: CGFloat(19))
                    toField.keyboardType = .numberPad
                    self.mainView.addSubview(toField)
                    let currencyCode = UILabel(frame: CGRect(x: CGFloat(((SCREEN_WIDTH - 16) / 3) + x + 18 + ((SCREEN_WIDTH - 16) / 3)), y: CGFloat(y), width: CGFloat(50), height: CGFloat(32)))
                    currencyCode.textColor = UIColor.black
                    currencyCode.backgroundColor = UIColor.clear
                    if DEFAULTS.object(forKey: "currency") != nil{
                        currencyCode.text = DEFAULTS.object(forKey: "currency") as? String
                    }else{
                        currencyCode.text = ""
                    }
                    self.mainView.addSubview(currencyCode)
                    y += 40
                    
                    
                    self.queryStringDict = [String:AnyObject]()
                    self.queryStringDict["code"] = formFieldDict["attributeCode"].stringValue as AnyObject?
                    self.queryStringDict["inputType"] = formFieldDict["inputType"].stringValue as AnyObject?
                    
                    var priceFromToDict = [String:String]()
                    priceFromToDict["from"] = ""
                    priceFromToDict["to"] = ""
                    self.queryStringDict["value"] = priceFromToDict as AnyObject?
                    self.queryString.add(self.queryStringDict)
                    
                }else if (formFieldDict["inputType"].stringValue) == "select" {
                    
                    let selectLabel = UILabel(frame: CGRect(x: CGFloat(x), y: CGFloat(y), width: CGFloat(SCREEN_WIDTH - 16), height: CGFloat(32)))
                    selectLabel.textColor = UIColor.black
                    selectLabel.backgroundColor = UIColor.clear
                    selectLabel.font = UIFont(name: REGULARFONT, size: CGFloat(15))
                    selectLabel.text = formFieldDict["label"].stringValue
                    self.mainView.addSubview(selectLabel)
                    y += 37
                    self.queryStringDict = [String: AnyObject]()
                    self.queryStringDict["code"] = formFieldDict["attributeCode"].stringValue as AnyObject?
                    self.queryStringDict["inputType"] = formFieldDict["inputType"].stringValue as AnyObject?
                    var selectArrayDict = [String:String]()
                    let formArrayOption:NSArray = formFieldDict["options"].arrayObject! as NSArray
                    
                    
                    var internalY: CGFloat = 0
                    let swichContainer = UIView(frame: CGRect(x: CGFloat(5), y: CGFloat(y), width: CGFloat(self.mainView.frame.size.width - 10), height: CGFloat(90)))
                    swichContainer.layer.borderColor = UIColor(red:222/255.0, green:225/255.0, blue:227/255.0, alpha: 1.0).cgColor
                    swichContainer.tag = i
                    self.mainView.addSubview(swichContainer)
                    
                    
                    for j in 0..<formArrayOption.count {
                        let dict:NSDictionary = formArrayOption.object(at: j) as! NSDictionary
                        selectArrayDict[dict.object(forKey: "value") as! String] = "false"
                        let checkBox = UISwitch(frame: CGRect(x: CGFloat(x), y: CGFloat(internalY), width: CGFloat(55), height: CGFloat(32)))
                        checkBox.isOn = false
                        let thisTagString: NSString = "\(dict.object(forKey: "value") as! String).\(i)" as NSString
                        let thisTag  = (thisTagString.longLongValue)
                        checkBox.tag = Int(thisTag)
                        checkBox.addTarget(self, action: #selector(self.checkSwitchState), for: .valueChanged)
                        
                        
                        swichContainer.addSubview(checkBox)
                        let checkboxLabel = UILabel(frame: CGRect(x: CGFloat(x + 60), y: CGFloat(internalY), width: CGFloat(SCREEN_WIDTH - 121), height: CGFloat(32)))
                        checkboxLabel.textColor = UIColor.black
                        checkboxLabel.backgroundColor = UIColor.clear
                        checkboxLabel.font = UIFont(name: REGULARFONT, size: CGFloat(15))
                        checkboxLabel.text = dict["label"] as? String
                        swichContainer.addSubview(checkboxLabel)
                        internalY += 37
                    }
                    var newFrame = swichContainer.frame
                    newFrame.size.height = internalY + 10
                    swichContainer.frame = newFrame
                    
                    y += internalY
                    y += 3
                    self.queryStringDict["value"] = selectArrayDict as AnyObject?
                    self.queryString.add(self.queryStringDict)
                    
                }else if (formFieldDict["inputType"].stringValue) == "date" {
                    
                    let dateLabel = UILabel(frame: CGRect(x: CGFloat(x), y: CGFloat(y), width: CGFloat(SCREEN_WIDTH - 16), height: CGFloat(32)))
                    dateLabel.textColor = UIColor.black
                    dateLabel.backgroundColor = UIColor.clear
                    dateLabel.font = UIFont(name: REGULARFONT, size: CGFloat(15))
                    dateLabel.text = formFieldDict["label"].stringValue
                    self.mainView.addSubview(dateLabel)
                    y += 37
                    let fromField = UITextField(frame: CGRect(x: CGFloat(x), y: CGFloat(y), width: CGFloat((SCREEN_WIDTH - 16) / 3), height: CGFloat(32)))
                    fromField.tag = i
                    fromField.borderStyle = .roundedRect
                    fromField.font = UIFont.systemFont(ofSize: CGFloat(19))
                    fromField.isEnabled = false
                    self.mainView.addSubview(fromField)
                    let calenderFromButton = UIImageView(frame: CGRect(x: CGFloat(((SCREEN_WIDTH - 16) / 3) + x), y: CGFloat(y), width: CGFloat(32), height: CGFloat(32)))
                    calenderFromButton.tag = i
                    calenderFromButton.image = UIImage(named: "ic_calender.png")
                    calenderFromButton.isUserInteractionEnabled = true
                    let fromTap = UITapGestureRecognizer(target: self, action: #selector(self.dateTap))
                    fromTap.numberOfTapsRequired = 1
                    calenderFromButton.addGestureRecognizer(fromTap)
                    self.mainView.addSubview(calenderFromButton)
                    let hifen = UILabel(frame: CGRect(x: CGFloat(((SCREEN_WIDTH - 16) / 3) + x + 37), y: CGFloat(y), width: CGFloat(8), height: CGFloat(32)))
                    hifen.textColor = UIColor.black
                    hifen.backgroundColor = UIColor.clear
                    hifen.font = UIFont(name: "Trebuchet MS", size: CGFloat(21.0))
                    hifen.text = "-"
                    self.mainView.addSubview(hifen)
                    
                    let toField = UITextField(frame: CGRect(x: CGFloat(((SCREEN_WIDTH - 16) / 3) + x + 55), y: CGFloat(y), width: CGFloat((SCREEN_WIDTH - 16) / 3), height: CGFloat(32)))
                    toField.tag = i * 100000
                    toField.borderStyle = .roundedRect
                    toField.font = UIFont.systemFont(ofSize: CGFloat(19))
                    toField.tintColor = UIColor.black
                    toField.isEnabled = false
                    self.mainView.addSubview(toField)
                    let calenderToButton = UIImageView(frame: CGRect(x: CGFloat((((SCREEN_WIDTH - 16) / 3) * 2) + x + 55), y: CGFloat(y), width: CGFloat(32), height: CGFloat(32)))
                    calenderToButton.tag = i * 100000
                    calenderToButton.image = UIImage(named: "ic_calender.png")
                    calenderToButton.isUserInteractionEnabled = true
                    let toTap = UITapGestureRecognizer(target: self, action: #selector(self.dateTap))
                    toTap.numberOfTapsRequired = 1
                    calenderToButton.addGestureRecognizer(toTap)
                    self.mainView.addSubview(calenderToButton)
                    y += 40
                    self.queryStringDict = [String: AnyObject]()
                    self.queryStringDict["code"] = formFieldDict["attributeCode"].stringValue as AnyObject?;
                    self.queryStringDict["inputType"] = formFieldDict["inputType"].stringValue as AnyObject?
                    var dateFromToDict = [String:String]()
                    dateFromToDict["from"] = ""
                    dateFromToDict["to"] = ""
                    self.queryStringDict["value"] = dateFromToDict as AnyObject?
                    self.queryString.add(self.queryStringDict)
                }
            }
            
            self.mainViewHeightConstarints.constant = y + 70
            self.searchBtn.isHidden = false
        }
    }
    
    @objc func dateTap(_ recognizer: UITapGestureRecognizer) {
        //self.mainScrollView.contentSize = CGSize(width: CGFloat(self.mainScrollView.contentSize.width), height: CGFloat(0))
        textFieldTag = (recognizer.view?.tag)!
        dateView = UIView(frame: CGRect(x: CGFloat(0), y: CGFloat(0), width: CGFloat(SCREEN_WIDTH), height: CGFloat(SCREEN_HEIGHT)))
        dateView.backgroundColor = UIColor.black
        dateView.alpha = 0.7
        let detePickerContainer = UIView(frame: CGRect(x: CGFloat( 50), y: CGFloat((SCREEN_HEIGHT / 2) - (((SCREEN_WIDTH / 4) + 100) / 2)), width: CGFloat(SCREEN_WIDTH - 100), height: CGFloat((SCREEN_WIDTH / 4) + 45)))
        detePickerContainer.backgroundColor = UIColor().HexToColor(hexString: "00CBDF")
        let okButton = UIButton(type: .custom)
        okButton.addTarget(self, action: #selector(self.setDate), for: .touchUpInside)
        okButton.setTitle(globalObjectAdvanceSearch.languageBundle.localizedString(forKey: "done", value: "", table: nil), for: .normal)
        okButton.frame = CGRect(x: CGFloat(0), y: CGFloat((SCREEN_WIDTH / 4) + 5), width: CGFloat((detePickerContainer.frame.size.width / 2)), height: CGFloat(35))
        detePickerContainer.addSubview(okButton)
        let cancelButton = UIButton(type: .custom)
        cancelButton.addTarget(self, action: #selector(self.dismissPicker), for: .touchUpInside)
        cancelButton.setTitle(globalObjectAdvanceSearch.languageBundle.localizedString(forKey: "cancel", value: "", table: nil), for: .normal)
        cancelButton.frame = CGRect(x: CGFloat(detePickerContainer.frame.size.width / 2), y: CGFloat((SCREEN_WIDTH / 4) + 5), width: CGFloat((detePickerContainer.frame.size.width / 2)), height: CGFloat(35))
        detePickerContainer.addSubview(cancelButton)
        datePicker = UIDatePicker(frame: CGRect(x: CGFloat(0), y: CGFloat(0), width: CGFloat(detePickerContainer.frame.size.width), height: CGFloat(SCREEN_WIDTH / 4)))
        datePicker.datePickerMode = .date
        datePicker.layer.cornerRadius = 2
        datePicker.isHidden = false
        if selectedDate != Date() {
            //datePicker.date = selectedDate!
        }
        else {
            datePicker.date = Date()
        }
        datePicker.alpha = 2
        detePickerContainer.alpha = 1
        datePicker.backgroundColor = UIColor.white
        detePickerContainer.addSubview(datePicker)
        dateView.addSubview(detePickerContainer)
        self.mainView.addSubview(dateView)
    }
    
    @objc func setDate(_ sender: Any) {
        let df = DateFormatter()
        df.dateStyle = .medium
        let tempField: UITextField? = (self.mainView.viewWithTag(textFieldTag) as? UITextField)
        selectedDate = datePicker.date
        tempField?.text = "\(df.string(from: datePicker.date))"
        dateView.removeFromSuperview()
    }
    
    @objc func dismissPicker(_ sender: Any) {
        dateView.removeFromSuperview()
    }
    
    @IBAction func searchBtnClick(_ sender:UIButton) {
       
            var isValid:Int = 1;
            var lastTag = -1;
            
            for subview: UIView in self.mainView.subviews {
                var thisTag: Int = subview.tag
                if thisTag > 99999 {
                    thisTag = thisTag / 100000
                }
                if (subview is UITextField) {
                    let tempField: UITextField? = (subview as? UITextField)
                    if isValid == 1 {
                        if !(tempField?.text == "") {
                            isValid = 0
                        }
                    }
                    var tempDict = (queryString.object(at: thisTag) as! [String:AnyObject])
                    if (tempDict["inputType"] as! String) == "string" || (tempDict["inputType"] as! String) == "number"{
                        tempDict["value"] = tempField?.text as AnyObject?
                        queryString.replaceObject(at: thisTag, with: tempDict)
                    }
                    else if (tempDict["inputType"] as! String) == "date" || (tempDict["inputType"] as! String) == "price"{
                        var internalTempDict = tempDict["value"] as! [String:String]
                        if thisTag == lastTag {
                            internalTempDict["to"] = tempField?.text
                        }else{
                            internalTempDict["from"] = tempField?.text
                        }
                        tempDict["value"] = internalTempDict as AnyObject?;
                        queryString.replaceObject(at: thisTag, with: tempDict)
                        lastTag = thisTag
                    }
                }
                else if (subview is UIView){
                    let tempView: UIView? = (subview as? UIView)
                    let parentTag:Int = (tempView?.tag)!
                    for child:UIView in (tempView?.subviews)!{
                        if child is UISwitch{
                            let switchValue = child as! UISwitch;
                            var tempDict1 = (queryString.object(at: parentTag) as! [String:AnyObject])
                            
                            var internalTempDict1 = tempDict1["value"] as! [String:String]
                            if switchValue .isOn{
                                internalTempDict1[ String(switchValue.tag)] = "true"
                                //print("aaa" , switchValue.tag)
                            }
                            if switchValue .isOn == false{
                                internalTempDict1[String(switchValue.tag)] = "false"
                                //print("ddd" , switchValue.tag)
                            }
                            if isValid == 1{
                                if switchValue .isOn{
                                    isValid = 0
                                }
                            }
                            tempDict1["value"] = internalTempDict1 as AnyObject?
                            queryString.replaceObject(at: parentTag, with:tempDict1)
                        }
                    }
                }
            }
            
            if isValid == 1 {
                AlertManager.shared.showWarningSnackBar(msg: "Select at least one option")
                //GlobalData.sharedInstance.showWarningSnackBar(msg: "Select at least one option")
            }else {
                let vc = self.storyboard?.instantiateViewController(withIdentifier: "Productcategory") as! Productcategory
                vc.queryString = queryString
                vc.categoryType = "advancesearchterms"
                self.navigationController?.pushViewController(vc, animated: true)
            }
    }
    
    @objc func searchButtonClicked(_ recognizer: UITapGestureRecognizer) {
        
        /*
        var isValid:Int = 1;
        var lastTag = -1;
        
        for subview: UIView in self.mainView.subviews {
            var thisTag: Int = subview.tag
            if thisTag > 99999 {
                thisTag = thisTag / 100000
            }
            if (subview is UITextField) {
                let tempField: UITextField? = (subview as? UITextField)
                if isValid == 1 {
                    if !(tempField?.text == "") {
                        isValid = 0
                    }
                }
                var tempDict = (queryString.object(at: thisTag) as! [String:AnyObject])
                if (tempDict["inputType"] as! String) == "string" || (tempDict["inputType"] as! String) == "number"{
                    tempDict["value"] = tempField?.text as AnyObject?
                    queryString.replaceObject(at: thisTag, with: tempDict)
                }
                else if (tempDict["inputType"] as! String) == "date" || (tempDict["inputType"] as! String) == "price"{
                    var internalTempDict = tempDict["value"] as! [String:String]
                    if thisTag == lastTag {
                        internalTempDict["to"] = tempField?.text
                    }else{
                        internalTempDict["from"] = tempField?.text
                    }
                    tempDict["value"] = internalTempDict as AnyObject?;
                    queryString.replaceObject(at: thisTag, with: tempDict)
                    lastTag = thisTag
                }
            }
            else if (subview is UIView){
                let tempView: UIView? = (subview as? UIView)
                let parentTag:Int = (tempView?.tag)!
                for child:UIView in (tempView?.subviews)!{
                    if child is UISwitch{
                        let switchValue = child as! UISwitch;
                        var tempDict1 = (queryString.object(at: parentTag) as! [String:AnyObject])
                        
                        var internalTempDict1 = tempDict1["value"] as! [String:String]
                        if switchValue .isOn{
                            internalTempDict1[ String(switchValue.tag)] = "true"
                            //print("aaa" , switchValue.tag)
                        }
                        if switchValue .isOn == false{
                            internalTempDict1[String(switchValue.tag)] = "false"
                            //print("ddd" , switchValue.tag)
                        }
                        if isValid == 1{
                            if switchValue .isOn{
                                isValid = 0
                            }
                        }
                        tempDict1["value"] = internalTempDict1 as AnyObject?
                        queryString.replaceObject(at: parentTag, with:tempDict1)
                    }
                }
            }
        }
        
        if isValid == 1 {
            GlobalData.sharedInstance.showWarningSnackBar(msg: "Select at least one option")
        }else {
            let vc = self.storyboard?.instantiateViewController(withIdentifier: "Productcategory") as! Productcategory
            vc.queryString = queryString
            vc.categoryType = "advancesearchterms"
            self.navigationController?.pushViewController(vc, animated: true)
        }*/
    }
    
    @objc func checkSwitchState(_ sender: Any) {
//        let value = sender as! UISwitch
    }
}
