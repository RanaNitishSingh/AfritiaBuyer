//
//  SellerInvoiceShippingDownloadController.swift
//  Getkart
//
//  Created by kunal on 08/03/18.
//  Copyright © 2018 kunal. All rights reserved.
//

import UIKit
import Alamofire
//import DatePickerDialog


class SellerInvoiceShippingDownloadController: UIViewController {
    
    @IBOutlet weak var fromDateTextField: UITextField!
    @IBOutlet weak var untillDateTextField: UITextField!
    @IBOutlet weak var submitButton: UIButton!
    
    var currentdownload:String = ""
    var documentPathUrl:NSURL!
    
    
    override func awakeFromNib() {
        self.title = "Help Us To Improve"
        //self.contentSizeInPop = CGSize(width:SCREEN_WIDTH-40, height: 280)
        //self.landscapeContentSizeInPopup = CGSizeMake(400, 200);
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //self.navigationItem.title = currentdownload == "invoice" ? "downloadinvoiceslip".localized : "downloadshippingslip".localized
        fromDateTextField.placeholder = "fromdate".localized
        untillDateTextField.placeholder = "todate".localized
        submitButton.setTitle("submit".localized, for: .normal)
        submitButton.applyAfritiaTheme()
        
        //fromDateTextField.inputView = UIView()
        //untillDateTextField.inputView = UIView()
        
        fromDateTextField.delegate = self
        untillDateTextField.delegate = self

    }
    
    /*
    @IBAction func fromDateClick(_ sender: UITextField) {
        //self.selectFromDate()
    }*/
    
    func selectFromDate(){
        /*
        RPicker.selectDate {(selectedDate) in
            let formatter = DateFormatter()
            formatter.dateFormat = "MM/dd/yy"
            self.fromDateTextField.text = formatter.string(from:selectedDate)
            
            }*/
    }
    
    
    func selectUntillDate(){
        
        /*
        RPicker.selectDate {(selectedDate) in
                // TODO: Your implementation for date
            let formatter = DateFormatter()
            formatter.dateFormat = "MM/dd/yy"
            self.untillDateTextField.text = formatter.string(from:selectedDate)
                //self.fromDateTextField.text = selectedDate.dateString("MMM-dd-YYYY")
            }
        */
    }
    
    
    @IBAction func resetClick(_ sender: UIBarButtonItem) {
        fromDateTextField.text = ""
        untillDateTextField.text = ""
    }
    
    @IBAction func viewFiles(_ sender: UIBarButtonItem) {
        let vc = AppStoryboard.Marketplace.instance.instantiateViewController(withIdentifier: "MyLocalFiles") as! MyLocalFiles
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    @IBAction func submitClick(_ sender: UIButton) {
        var isValid:Int = 1
        var error:String = "pleaseselect".localized + " "
        if fromDateTextField.text == "" {
            isValid = 0
            error = error + "fromdate".localized
        } else if untillDateTextField.text == "" {
            isValid = 0
            error = error + "todate".localized
        }
        
        if isValid == 0 {
            AlertManager.shared.showWarningSnackBar(msg: error)
        } else {
            download()
        }
    }
    
    func download(){
        var fileName:String = ""
        let date = Date()
        let formatter = DateFormatter()
        formatter.dateFormat = "dd.MM.yyyy"
        //let storeId = defaults.object(forKey: "storeId")
        var  url:String = ""
        if currentdownload == "invoice"{
            url = HOST_NAME+AfritiaSellerAPI.downloadAllInvoice
            fileName = "invoice"+formatter.string(from: date)+".pdf"
        }else{
            url = HOST_NAME+AfritiaSellerAPI.downloadAllShipping
            fileName = "shipping"+formatter.string(from: date)+".pdf"
        }
        
        let post = NSMutableString();
        post .appendFormat("storeId=%@&", UserManager.getStoreId as CVarArg);
        post .appendFormat("dateTo=%@&", untillDateTextField.text! as CVarArg);
        post .appendFormat("dateFrom=%@&", fromDateTextField.text! as CVarArg);
        post .appendFormat("logParams=%@", "1" as CVarArg);
        
        self.load(url: URL(string: url)!, params: post as String,name: fileName)
        GlobalData.sharedInstance.showLoader()
    }
    
    func load(url: URL, params:String, name:String){
        let sessionConfig = URLSessionConfiguration.default
        let session = URLSession(configuration: sessionConfig)
        var request = try! URLRequest(url: url, method: .post)
        let postString = params;
        request.httpBody = postString.data(using: .utf8)
        let customerId = DEFAULTS.object(forKey:"customerId") as! String;
        request.addValue(customerId, forHTTPHeaderField: "customerToken")
        
        let task = session.downloadTask(with: request) { (tempLocalUrl, response, error) in
            if let tempLocalUrl = tempLocalUrl, error == nil {
                // Success
                if let statusCode = (response as? HTTPURLResponse)?.statusCode {
                    print("Success: \(statusCode)")
                    GlobalData.sharedInstance.dismissLoader()
                }
                do{
                    let largeImageData = try Data(contentsOf: tempLocalUrl)
                    let documentsDirectoryURL = try! FileManager().url(for: .documentDirectory, in: .userDomainMask, appropriateFor: nil, create: true)
                    let fileURL = documentsDirectoryURL.appendingPathComponent(name);
                    
                    
                    if !FileManager.default.fileExists(atPath: fileURL.path) {
                        do {
                            try largeImageData.write(to: fileURL)
                            let AC = UIAlertController(title: "success".localized, message: "filesavemessage".localized, preferredStyle: .alert)
                            let okBtn = UIAlertAction(title: "ok".localized, style: .default, handler: {(_ action: UIAlertAction) -> Void in
                                self.documentPathUrl = fileURL as NSURL
                                let vc = AppStoryboard.Marketplace.instance.instantiateViewController(withIdentifier: "ShowDownloadFile") as! ShowDownloadFile
                                vc.documentUrl = self.documentPathUrl
                                self.navigationController?.pushViewController(vc, animated: true)
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
                        let AC = UIAlertController(title: "success".localized, message: "filesavemessage".localized, preferredStyle: .alert)
                        let okBtn = UIAlertAction(title: "ok".localized, style: .default, handler: {(_ action: UIAlertAction) -> Void in
                            self.documentPathUrl = fileURL as NSURL
                            let vc = AppStoryboard.Marketplace.instance.instantiateViewController(withIdentifier: "ShowDownloadFile") as! ShowDownloadFile
                            vc.documentUrl = self.documentPathUrl
                            self.navigationController?.pushViewController(vc, animated: true)
                        })
                        let noBtn = UIAlertAction(title: "cancel".localized, style: .destructive, handler: {(_ action: UIAlertAction) -> Void in
                            
                        })
                        AC.addAction(okBtn)
                        AC.addAction(noBtn)
                        self.present(AC, animated: true, completion: { })
                    }
                }catch{
                    print("error")
                }
                do {
                } catch (let writeError) {
                }
            } else {
                GlobalData.sharedInstance.dismissLoader()
                print("Failure: %@", error?.localizedDescription)
            }
        }
        task.resume()
    }
}

extension SellerInvoiceShippingDownloadController : UITextFieldDelegate {
    func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
        
        self.view.endEditing(true)
        
        if textField == self.fromDateTextField{
            self.selectFromDate()
            return false
        }
        else if textField == self.untillDateTextField{
            self.selectUntillDate()
            return false
        }
        return true
    }
}
