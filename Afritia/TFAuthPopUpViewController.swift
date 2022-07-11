//
//  TFAuthPopUpViewController.swift
//  Afritia
//
//  Created by Ranjit Mahto on 01/12/20.
//  Copyright © 2020 kunal. All rights reserved.
//

import UIKit

class TFAuthPopUpViewController: UIViewController {
    
    @IBOutlet weak var btnModeToggle:UIButton!
    @IBOutlet weak var textFiledOtpInput:UITextField!
    @IBOutlet weak var btnGetOTP:UIButton!
    @IBOutlet weak var btnGetOTPAgaiin:UIButton!
    @IBOutlet weak var lblModeType:UILabel!
    @IBOutlet weak var lblInfoForInput:UILabel!
    
    @IBOutlet weak var txtBgHeight:NSLayoutConstraint!
    @IBOutlet weak var btnGetOtpBgHeight:NSLayoutConstraint!
    @IBOutlet weak var btnGetOtpAgainBgHeight:NSLayoutConstraint!
    
    var imgRadio_ON : UIImage = UIImage(named:"radio_on")!
    var imgRadio_OFF : UIImage = UIImage(named:"radio_off")!
    var titleGetOTP = "Get OTP Code"
    var titleSubmitOTP = "Submit Code"
    
    var modeType:String!
    var isModeSelected:Bool!
    
    var userStoreId:String!
    var userToken:String!
    
    var popUpCallBackOnGettingOTP:((String)->())! //
    var popUpCallBackOnUpdateOTP:((String)->())! //
    var popUpCallBackOnSubmitOTP:((String)->())!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        btnGetOTP.applyAfritiaTheme()
        btnGetOTPAgaiin.applyAfritiaTheme()
        textFiledOtpInput.applyAfritiaTheme()
        
        self.lblModeType.text = modeType
        self.hideControllers()
        self.toggleModeSelRadioButton(isOn:isModeSelected)
        
        
        // Do any additional setup after loading the view.
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        if isModeSelected {
            self.showControllers()
            self.textFiledOtpInput.becomeFirstResponder()
        }
    }
    
    func toggleModeSelRadioButton(isOn:Bool){
        
        if isOn == true{
            btnModeToggle.setImage(imgRadio_ON, for:.normal)
            self.isModeSelected = true
        }else{
            btnModeToggle.setImage(imgRadio_OFF, for:.normal)
            self.isModeSelected = false
        }
    }
    
    @IBAction func btnEmailToggleTapped(_ sender:UIButton){
        self.toggleModeSelRadioButton(isOn:true)
    }
    
    @IBAction func btnGetOtpTapped(_ sender:UIButton){
        
        if isModeSelected == false {
            AlertManager.shared.showInfoSnackBar(msg:"Please select an option to get OTP")
            return
        }
        
        if sender.titleLabel?.text == titleGetOTP {
            self.dismiss(animated:true) {
                // call api for get otp
                self.callApiForGetOTPCode(isResend:false)
            }
            
        }
        else{
            
            if textFiledOtpInput.isEmpty() {
                AlertManager.shared.showInfoSnackBar(msg:"Please enter correct OTP")
                return
            }
            else{
                let otpCode = textFiledOtpInput.text!
                self.popUpCallBackOnSubmitOTP(otpCode)
            }
        }
    }
    
    @IBAction func btnGetOtpAgainTapped(_ sender:UIButton){
        
        print("btnGetOtpAgainTapped")
        
        var requstParams = [String:Any]()
        requstParams["storeId"] = self.userStoreId
        requstParams["customerToken"] = self.userToken
        requstParams["resend"] = "1"
        
        GlobalData.sharedInstance.showLoader()
        
        APIServiceManager.shared.callingHttpRequest(params:requstParams, apiname:AfritiaAPI.getOTPCode, currentView: self){success,responseObject in
            
            GlobalData.sharedInstance.dismissLoader()
            if success == 1{
                
                //print(responseObject!)
                /*
                 SUCCESS: {
                     message = "Please Enter the OTP sent to your registered Email address";
                     otp = 810059;
                     success = 1;
                 }
                 */
                
                //fiire after otp response
                let respDict = JSON(responseObject as! NSDictionary)
                let otpCode = respDict["otp"].stringValue
                self.popUpCallBackOnUpdateOTP(otpCode)
                
            }
            else if success == 2{
                GlobalData.sharedInstance.dismissLoader()
                self.callApiForGetOTPCode(isResend: true)
            }
        }
    }
    
    func callApiForGetOTPCode(isResend:Bool){
                
        var requstParams = [String:Any]()
        requstParams["storeId"] = self.userStoreId
        requstParams["customerToken"] = self.userToken
        requstParams["resend"] = "0"
        
        GlobalData.sharedInstance.showLoader()
        
        APIServiceManager.shared.callingHttpRequest(params:requstParams, apiname:AfritiaAPI.getOTPCode, currentView: self){success,responseObject in
            
            GlobalData.sharedInstance.dismissLoader()
            if success == 1{
                
                //print(responseObject!)
                /*
                 SUCCESS: {
                     message = "Please Enter the OTP sent to your registered Email address";
                     otp = 810059;
                     success = 1;
                 }
                 */
                
                //fiire after otp response
                let respDict = JSON(responseObject as! NSDictionary)
                let otpCode = respDict["otp"].stringValue
                
                self.popUpCallBackOnGettingOTP(otpCode)
            }
            else if success == 2{
                GlobalData.sharedInstance.dismissLoader()
                self.callApiForGetOTPCode(isResend: true)
            }
        }
        
    }
    
    func hideControllers(){
        //hide txt bg
        self.txtBgHeight.constant = 0
        self.textFiledOtpInput.isHidden = true
        self.lblInfoForInput.isHidden = true
        
        self.btnGetOtpBgHeight.constant = 60
        self.btnGetOTP.isHidden = false
    
        //hide otp get again
        self.btnGetOtpAgainBgHeight.constant = 0
        self.btnGetOTPAgaiin.isHidden = true
        
        btnGetOTP.setTitle(titleGetOTP, for:.normal)
    }
    
    func showControllers(){
        self.txtBgHeight.constant = 120
        self.textFiledOtpInput.isHidden = false
        self.lblInfoForInput.isHidden = false
        
        self.btnGetOtpBgHeight.constant = 60
        self.btnGetOTP.isHidden = false
        
        //hide otp get again
        self.btnGetOtpAgainBgHeight.constant = 60
        self.btnGetOTPAgaiin.isHidden = false
        
        btnGetOTP.setTitle(titleSubmitOTP, for:.normal)
    }
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
