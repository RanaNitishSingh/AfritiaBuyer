//
//  BecomesPartnerController.swift
//  Magento1MarketPlaceNew
//
//  Created by Webkul on 13/07/17.
//  Copyright © 2017 Webkul. All rights reserved.
//

import UIKit

import UIFloatLabelTextField

class BecomesPartnerController: UIViewController {
    
    @IBOutlet weak var shopUrlTextField: UIFloatLabelTextField!
    @IBOutlet weak var shopNameTextField: UIFloatLabelTextField!
    @IBOutlet weak var refisterButton: UIButton!
    var storeUrl:String = ""
    var storeName:String = ""
    let globalObjectPrtner = GlobalData()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationController?.isNavigationBarHidden = false
        
        navigationController?.navigationBar.applyAfritiaTheme()
        self.navigationItem.title = "becomepartner".localized //GlobalData.sharedInstance.language(key: "becomepartner")
        UITextField().bottomBorder(texField: shopUrlTextField)
        UITextField().bottomBorder(texField: shopNameTextField)
        shopUrlTextField.textAlignment = UITextField().isLanguageLayoutDirectionRightToLeft() ? .right : .left
        shopNameTextField.textAlignment = UITextField().isLanguageLayoutDirectionRightToLeft() ? .right : .left
        shopUrlTextField.placeholder = GlobalData.sharedInstance.language(key: "shopurl")
        shopNameTextField.placeholder = GlobalData.sharedInstance.language(key:"shopname")
        refisterButton.setTitle(GlobalData.sharedInstance.language(key:"register"), for: .normal)
        refisterButton.backgroundColor = UIColor.button
    }
    
    func dismissKeyboard() {
        view.endEditing(true)
    }
    
    @IBAction func register(_ sender: Any) {
        var isValid:Int = 0
        var errorMessage:String = ""
        if shopUrlTextField.text == ""{
            isValid = 1
            errorMessage = GlobalData.sharedInstance.language(key:"fillshopurl")
        }else if shopNameTextField.text == ""{
            isValid = 1
            errorMessage = GlobalData.sharedInstance.language(key:"fillshopname")
        }
        if isValid == 0{
            callingHttppApi()
        }else{
            AlertManager.shared.showWarningSnackBar(msg: errorMessage)
        }
    }
    
    func callingHttppApi(){
        GlobalData.sharedInstance.showLoader()
        self.view.isUserInteractionEnabled = false
        var requstParams = [String:Any]()
        let storeId = DEFAULTS.object(forKey: "storeId")
        if(storeId != nil){
            requstParams["storeId"] = storeId
        }
        let customerId = DEFAULTS.object(forKey:"customerId")
        if customerId != nil{
            requstParams["customerToken"] = customerId
        }
        requstParams["shopUrl"] = shopUrlTextField.text
        
        APIServiceManager.shared.callingHttpRequest(params:requstParams, apiname:"mobikulmphttp/marketplace/becomeseller", currentView: self){success,responseObject in
            if success == 1{
                if responseObject?.object(forKey: "storeId") != nil{
                    let storeId:String = String(format: "%@", responseObject!.object(forKey: "storeId") as! CVarArg)
                    if storeId != "0"{
                        DEFAULTS.set(storeId, forKey: "storeId")
                    }
                }
                GlobalData.sharedInstance.dismissLoader()
                self.view.isUserInteractionEnabled = true
                let dict = JSON(responseObject as! NSDictionary)
                if dict["success"].boolValue == true{
                    AlertManager.shared.showSuccessSnackBar(msg: "sellerrequesthasbeensubmittedsuccessfully".localized)
                    if dict["isPending"].intValue == 0{
                        DEFAULTS.set("f", forKey: "isPending")
                        DEFAULTS.set("t", forKey: "isSeller")
                    }else{
                        DEFAULTS.set("t", forKey: "isPending")
                        DEFAULTS.set("t", forKey: "isSeller")
                    }
                    DEFAULTS.synchronize()
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
}
