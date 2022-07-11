//

/*
 JaguarImport
 @Category Webkul
 @author Webkul
 Created by: Webkul on 16/07/18
 FileName: ContactUSController.swift
 Copyright (c) 2010-2018 Webkul Software Private Limited (https://webkul.com)
 @license https://store.webkul.com/license.html
 */


import UIKit
import MessageUI
import Cupcake


class ContactUSController: UIViewController {
    

    @IBOutlet weak var mainView: UIView!
    @IBOutlet weak var contactUsInfo: UILabel!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var nameField: UITextField!
    @IBOutlet weak var emailLabel: UILabel!
    @IBOutlet weak var emailField: UITextField!
    @IBOutlet weak var telephonrLabel: UILabel!
    @IBOutlet weak var telephoneField: UITextField!
    @IBOutlet weak var messageLabel: UILabel!
    @IBOutlet weak var messageField: UITextView!
    @IBOutlet weak var sendButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        nameLabel.text = "name".localized
        emailLabel.text = "email".localized
        telephonrLabel.text = "Mobile Phone Number"//"telephoneno".localized
        messageLabel.text = "message".localized
        contactUsInfo.text = "contactusinfo".localized
       
        /*
        let str = "Lorem ipsum 20 dolor sit er elit lamet, consectetaur cillium #adipisicing pecu, sed do #eiusmod tempor incididunt ut labore et 3.14 dolore magna aliqua."
        let attStr = AttStr(str).select("elit", .number, .hashTag, .range(-7, 6)).link()

        contactUsInfo.str(attStr).lineGap(10).lines().onLink({ text in
            print(text)
        })*/
        
        let contactStr = "contactusinfo".localized
        let attStr = AttStr(contactStr).font(UIFont.systemFont(ofSize:14, weight: .medium)).select("customersupport@afritia.com").link().color(UIColor.DarkLavendar)
        contactUsInfo.str(attStr).lineGap(5).lines().onLink({ text in
            print(text)
        })
        
        /*
        if defaults.object(forKey: "customerEmail") != nil  {
            emailField.text = defaults.object(forKey: "customerEmail") as? String
        }
        
        if defaults.object(forKey: "customerName") != nil  {
            nameField.text = defaults.object(forKey: "customerName") as? String
        }
       */
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        self.view.backgroundColor = UIColor.white
        self.mainView.backgroundColor = UIColor.white
        
        self.navigationController?.isNavigationBarHidden = false
        self.navigationController?.navigationBar.applyAfritiaTheme()
        self.navigationItem.title = "contactus".localized
        
        sendButton.setTitle("send".localized, for: .normal)
        sendButton.applyAfritiaTheme()
        messageField.applyRoundCornerBorder(radius: 6, width: 0.5, color: UIColor.Magnesium)
        contactUsInfo.backgroundColor = UIColor.white
    }
    
    //MARK:- API Call
    func callingHttppApi(){
        GlobalData.sharedInstance.showLoader()
        
        var requstParams = [String:Any]()
        requstParams["storeId"] = UserManager.getStoreId
        requstParams["name"] = nameField.text
        requstParams["email"] = emailField.text
        requstParams["telephone"] = telephoneField.text
        requstParams["comment"] = messageField.text
        
        APIServiceManager.shared.callingHttpRequest(params:requstParams, apiname:AfritiaAPI.contactUsPost, currentView: self){success,responseObject in
            if success == 1{
                
                GlobalData.sharedInstance.dismissLoader()
                
                let dict = responseObject as! NSDictionary
                
                print(dict)
                if dict.object(forKey: "success") as! Bool == true{
                    
                    let  AC = UIAlertController(title: GlobalData.sharedInstance.language(key: "success"), message: dict.object(forKey: "message") as? String, preferredStyle: .alert)
                    let okBtn = UIAlertAction(title: GlobalData.sharedInstance.language(key: "ok"), style:.default, handler: {(_ action: UIAlertAction) -> Void in
                        self.clearFields()
                        self.dismiss(animated: true, completion: nil)
                    })
                    
                    AC.addAction(okBtn)
                    self.present(AC, animated: true, completion: {  })
                }else{
                    AlertManager.shared.showErrorSnackBar(msg: dict.object(forKey: "message") as! String)
                }
            }else if success == 2{
                GlobalData.sharedInstance.dismissLoader()
                self.callingHttppApi()
            }
        }
    }
    func clearFields(){
        nameField.text = ""
        emailField.text = ""
        telephoneField.text = ""
        messageField.text = ""
    }
   
    @IBAction func sendClick(_ sender: UIButton) {
        var errorMessage = "pleasefill".localized + " "
        var isValid:Int = 1
        
        if nameField.text == ""{
            errorMessage += "name".localized
            isValid = 0
        }else if emailField.text == ""{
            errorMessage += "email".localized
            isValid = 0
        }else if telephoneField.text == ""{
            errorMessage += "telephoneno".localized
            isValid = 0
        }else if messageField.text == ""{
            errorMessage += "message".localized
            isValid = 0
        }
        
        if isValid == 0{
            AlertManager.shared.showWarningSnackBar(msg: errorMessage)
        }else{
            //call API
            callingHttppApi()
        }
    }
}
