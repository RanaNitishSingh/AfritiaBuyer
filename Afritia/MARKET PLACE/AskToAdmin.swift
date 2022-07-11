//
//  AskToAdmin.swift
//  MobikulMp
//
//  Created by kunal prasad on 28/01/17.
//  Copyright © 2017 Webkul. All rights reserved.
//

import UIKit
import UIFloatLabelTextField

class AskToAdmin: UIViewController {
    
    @IBOutlet weak var mainViewHeightConstarints: NSLayoutConstraint!
    @IBOutlet weak var subjectTextField: UIFloatLabelTextField!
    @IBOutlet weak var queryTextField: UITextView!
    @IBOutlet weak var submitButton: UIButton!
    @IBOutlet weak var queryLbl: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationController?.isNavigationBarHidden = false
        navigationController?.navigationBar.applyAfritiaTheme()
        self.navigationItem.title = "askquestiontoadmin".localized
        
        UITextField().bottomBorder(texField: subjectTextField)
        subjectTextField.textAlignment = UITextField().isLanguageLayoutDirectionRightToLeft() ? .right : .left;
        subjectTextField.placeholder = "subject".localized
        
        submitButton.setTitle("submit".localized, for: .normal)
        submitButton.backgroundColor = UIColor.button
        
        queryLbl.text = "query".localized
        
        mainViewHeightConstarints.constant = 500
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.navigationController?.isNavigationBarHidden = false
    }
    
    
    func callingHttppApi(){
        GlobalData.sharedInstance.showLoader()
        self.view.isUserInteractionEnabled = false
        var requstParams = [String:Any]();
        let storeId = DEFAULTS.object(forKey: "storeId")
        if(storeId != nil){
            requstParams["storeId"] = storeId
        }
        let customerId = DEFAULTS.object(forKey:"customerId");
        if customerId != nil{
            requstParams["customerToken"] = customerId
        }
        requstParams["query"] = queryTextField.text
        requstParams["subject"] = subjectTextField.text
        
        APIServiceManager.shared.callingHttpRequest(params:requstParams, apiname:"mobikulmphttp/marketplace/askquestiontoadmin", currentView: self){success,responseObject in
            if success == 1{
                if responseObject?.object(forKey: "storeId") != nil{
                    let storeId:String = String(format: "%@", responseObject!.object(forKey: "storeId") as! CVarArg)
                    if storeId != "0"{
                        DEFAULTS .set(storeId, forKey: "storeId")
                    }
                }
                GlobalData.sharedInstance.dismissLoader()
                self.view.isUserInteractionEnabled = true
                var dict = JSON(responseObject as! NSDictionary)
                if dict["success"].boolValue == true{
                    AlertManager.shared.showSuccessSnackBar(msg: "querysuccessfullysubmittedtoadmin".localized)
                    self.navigationController?.popViewController(animated: true)
                }else{
                    AlertManager.shared.showErrorSnackBar(msg: dict["message"].stringValue)
                }
                print("sss", responseObject!)
                
            }else if success == 2{
                GlobalData.sharedInstance.dismissLoader()
                self.callingHttppApi()
            }
        }
    }
    
    @IBAction func AskToAdminButton(_ sender: Any) {
        var  isValid:Int = 1
        var errorMessage: String = "pleasefill".localized
        if subjectTextField.text == ""{
            errorMessage = errorMessage+" "+"subject".localized
            isValid = 0
        }
        else if queryTextField.text == ""{
            errorMessage = "pleaseenterquery".localized
            isValid = 0
        }
        
        if isValid == 0{
            AlertManager.shared.showWarningSnackBar(msg: errorMessage)
            
        }
        if isValid == 1{
            self.callingHttppApi()
        }
    }
}
