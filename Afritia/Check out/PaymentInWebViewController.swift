//
//  PayPalPaymentWebView.swift
//  Shop767
//
//  Created by webkul on 07/04/17.
//  Copyright © 2017 Webkul. All rights reserved.
//

import UIKit
import WebKit

class PaymentInWebViewController: UIViewController {
    
    @IBOutlet weak var paymentWebView: WKWebView!
    
    public var paymentURL:String = ""
    let defaults = UserDefaults.standard;
    var successMessage:String = ""
    
    //success URL containing the increement id
    var saveSuccessURL : String = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationItem.title = GlobalData.sharedInstance.language(key: "payment")
        self.tabBarController?.tabBar.isHidden = true
        self.navigationItem.setHidesBackButton(true, animated:true);
        
        //https://afritia.com/stage/mobileapp/checkout/paystackredirect/?storeId=1&customerToken=&quoteId=5681
        print("PAYMENT URL:\(paymentURL)")
        
        GlobalData.sharedInstance.showLoader()
        let request = URLRequest(url: URL(string: paymentURL)!)
        paymentWebView.load(request)
        paymentWebView.navigationDelegate = self
        
    }
    
    @IBAction func cancelPayment(_ sender: Any) {
        let AC = UIAlertController(title: GlobalData.sharedInstance.language(key: "warning") , message: GlobalData.sharedInstance.language(key: "nopayment"), preferredStyle: .alert)
        let okBtn = UIAlertAction(title: GlobalData.sharedInstance.language(key: "ok"), style: .default, handler: {(_ action: UIAlertAction) -> Void in
            //            self.state = ""
            self.dismiss(animated: true, completion: nil)
        })
        let noBtn = UIAlertAction(title: GlobalData.sharedInstance.language(key: "cancel"), style: .destructive, handler: {(_ action: UIAlertAction) -> Void in
        })
        AC.addAction(okBtn)
        AC.addAction(noBtn)
        self.parent!.present(AC, animated: true, completion: nil)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
//        GlobalData.sharedInstance.showLoader()
    }
    
    func requestForLogin(){
        
        var loginRequest = [String:String]();
        loginRequest["apiKey"] = API_USER_NAME;
       // loginRequest["apiPassword"] = API_KEY.md5;
        loginRequest["apiPassword"] = API_KEY;
        if self.defaults.object(forKey: "language") != nil{
            loginRequest["language"] = self.defaults.object(forKey: "language") as? String;
        }
        if self.defaults.object(forKey: "currency") != nil{
            loginRequest["currency"] = self.defaults.object(forKey: "currency") as? String;
        }
        if self.defaults.object(forKey: "customer_id") != nil{
            loginRequest["customer_id"] = self.defaults.object(forKey: "customer_id") as? String;
        }
        APIServiceManager.shared.callingHttpRequest(params:loginRequest, apiname:"common/apiLogin", currentView: self){val,responseObject in
            if val == 1{
                let dict = responseObject as! NSDictionary
                print("login",dict)
                
                self.defaults.set(dict.object(forKey: "wk_token") as! String, forKey: "wk_token")
                self.defaults.set(dict.object(forKey: "language") as! String, forKey: "language")
                self.defaults.set(dict.object(forKey: "currency") as! String, forKey: "currency")
                self.defaults.synchronize();
                self.callingApiOnPaymentSuccess()
            }else if val == 2{
                GlobalData.sharedInstance.dismissLoader()
                self.requestForLogin()
                
            }
        }
    }
    
    fileprivate func callingApiOnPaymentSuccess(){
        
        self.view.isUserInteractionEnabled = false
        GlobalData.sharedInstance.showLoader()
        
        let sessionId = self.defaults.object(forKey:"wk_token")
        var requstParams = [String:Any]()
        let customerId = defaults.object(forKey: "customerId")
        let quoteId = defaults.object(forKey: "quoteId")
        
        if(customerId != nil)   {
            requstParams["customerToken"] = customerId
        }
        
        if(quoteId != nil)  {
            requstParams["quoteId"] = quoteId
        }
        
        if defaults.object(forKey: "storeId") != nil{
            requstParams["storeId"] = defaults.object(forKey: "storeId") as! String
        }
        
        requstParams["token"] = sessionId
        requstParams["isPaypalPayment"] = true
        requstParams["incrementId"] = ((saveSuccessURL.components(separatedBy: "/") as NSArray)[(saveSuccessURL.components(separatedBy: "/") as NSArray).count - 2]) as? String
        
        print(requstParams)
        
        APIServiceManager.shared.callingHttpRequest(params:requstParams, apiname:AfritiaAPI.saveOrder, currentView: self){success,responseObject in
            if success == 1
            {
                GlobalData.sharedInstance.dismissLoader()
                
                if responseObject?.object(forKey: "storeId") != nil{
                    let storeId:String = String(format: "%@", responseObject!.object(forKey: "storeId") as! CVarArg)
                    if storeId != "0"{
                        self.defaults .set(storeId, forKey: "storeId")
                    }
                }
                
                //self.view.isUserInteractionEnabled = true
                
                print(responseObject! as! NSDictionary)
                
                let data = responseObject! as! NSDictionary
                let dict = JSON(data)
                if dict["success"].boolValue == true{
                    let viewController:OrderPlaced = self.storyboard?.instantiateViewController(withIdentifier: "OrderPlaced") as! OrderPlaced
                    viewController.incrementId = dict["incrementId"].stringValue
                    self.navigationController?.pushViewController(viewController, animated: true)
                }
            }
            else if success == 2
            {
                GlobalData.sharedInstance.dismissLoader()
                self.callingApiOnPaymentSuccess()
            }
        }
    }
}

extension PaymentInWebViewController : WKNavigationDelegate {
    
    func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
        GlobalData.sharedInstance.dismissLoader()
    }
    
    func webView(_ webView: WKWebView, didCommit navigation: WKNavigation!) {
        
        let requestURL = webView.url!.absoluteString
        
        print("***PAYURL", requestURL)
        
        if (requestURL.contains("checkout/success/incrementid"))
        {
            paymentWebView.stopLoading()
            saveSuccessURL = requestURL
            callingApiOnPaymentSuccess()
            
        }else{
            
        }
        
        /*
        if (requestURL.contains("checkout/cart")) || (requestURL.contains("checkout/#payment")) || (requestURL.contains("checkout/onepage/failure"))  {
            paymentWebView.stopLoading()
            self.dismiss(animated: true, completion: nil)
        }*/
    }
    
    func webView(_ webView: WKWebView, didFail navigation: WKNavigation!, withError error: Error) {
        GlobalData.sharedInstance.dismissLoader()
    }
    
}
