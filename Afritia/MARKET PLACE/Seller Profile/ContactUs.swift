//
//  ContactUs.swift
//  MobikulMp
//
//  Created by kunal prasad on 18/01/17.
//  Copyright © 2017 Webkul. All rights reserved.
//

import UIKit

class ContactUs: UIViewController {
    
    
    @IBOutlet weak var mainView: UIView!
    @IBOutlet weak var mainViewHeightConstarints: NSLayoutConstraint!
    @IBOutlet weak var nametextField: UITextField!
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var subjectTextField: UITextField!
    @IBOutlet weak var summaryData: UITextView!
    @IBOutlet weak var submitButton: UIButton!
    @IBOutlet weak var queryLbl: UILabel!
    
    var contactUsDataDictionary = [String :String]()
    let defaults = UserDefaults.standard
    var keyBoardFlag:Int = 1
    public var sellerId:String!
    public var productId:String!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        summaryData.layer.borderWidth = 1.0
        summaryData.layer.borderColor = UIColor.lightGray.cgColor
        
        self.navigationController?.isNavigationBarHidden = false
        navigationController?.navigationBar.applyAfritiaTheme()
        self.navigationItem.title = "contactus".localized
        
        nametextField.textAlignment = UITextField().isLanguageLayoutDirectionRightToLeft() ? .right : .left
        emailTextField.textAlignment = UITextField().isLanguageLayoutDirectionRightToLeft() ? .right : .left
        subjectTextField.textAlignment = UITextField().isLanguageLayoutDirectionRightToLeft() ? .right : .left
        submitButton.setTitle("submit".localized, for:.normal)
        submitButton.applyAfritiaTheme()
        nametextField.placeholder = "entername".localized
        emailTextField.placeholder = "enteremail".localized
        subjectTextField.placeholder = "subject".localized
        
        queryLbl.text = "query".localized
        
        if((defaults.object(forKey: "customerName")) != nil){
            nametextField.text = defaults.object(forKey: "customerName") as! String?
        }
        if((defaults.object(forKey: "customerEmail")) != nil){
            emailTextField.text = defaults.object(forKey: "customerEmail") as! String?
        }
        mainViewHeightConstarints.constant = 500
    }
    
    func callingHttppApi(){
        GlobalData.sharedInstance.showLoader()
        self.view.isUserInteractionEnabled = false
        var requstParams = [String:Any]()
        let storeId = defaults.object(forKey: "storeId")
        if(storeId != nil){
            requstParams["storeId"] = storeId
        }
        
        requstParams["sellerId"] = sellerId
        requstParams["query"] = contactUsDataDictionary["query"]!
        requstParams["subject"] = contactUsDataDictionary["subject"]!
        requstParams["email"] = contactUsDataDictionary["email"]!
        requstParams["name"] =  contactUsDataDictionary["name"]!
        requstParams["productId"] = productId
        
        APIServiceManager.shared.callingHttpRequest(params:requstParams, apiname:"mobikulmphttp/marketplace/ContactSeller", currentView: self){success,responseObject in
            if success == 1{
                self.view.isUserInteractionEnabled = true
                GlobalData.sharedInstance.dismissLoader()
                let dict = JSON(responseObject as! NSDictionary)
                if dict["success"].boolValue == true{
                    AlertManager.shared.showSuccessSnackBar(msg: dict["message"].stringValue)
                    self.navigationController?.popViewController(animated: true)
                }else{
                    AlertManager.shared.showErrorSnackBar(msg: dict["message"].stringValue)
                }
                
                print("dsd", responseObject)
                
            }else if success == 2{
                GlobalData.sharedInstance.dismissLoader()
                self.callingHttppApi()
            }
        }
    }
    
    @IBAction func submit(_ sender: Any) {
        contactUsDataDictionary = [String :String]()
        var  isValid:Int = 1
        var errorMessage: String = "Please Fill"
        
        if (summaryData?.text == "") {
            isValid = 0
            errorMessage = "pleaseenterquery".localized
        }
        if subjectTextField?.text == "" {
            isValid = 0
            errorMessage = "pleaseentersubject".localized
        }
        if emailTextField?.text == "" {
            isValid = 0
            errorMessage = "pleasefillemailid".localized
        }
        if !GlobalData.sharedInstance.checkValidEmail(data: emailTextField.text!){
            isValid = 0
            errorMessage = "pleasefilllvalidemail".localized
        }
        if nametextField?.text == "" {
            isValid = 0
            errorMessage = "entername".localized
        }
        
        if isValid == 1 {
            contactUsDataDictionary["name"] = nametextField?.text
            contactUsDataDictionary["email"] = emailTextField?.text
            contactUsDataDictionary["subject"] = subjectTextField?.text
            contactUsDataDictionary["query"] = summaryData?.text
            isValid = 2
        }
        
        if isValid == 0{
            AlertManager.shared.showWarningSnackBar(msg:errorMessage )
        }
        if isValid == 2 {
            self.callingHttppApi()
        }
    }
}
