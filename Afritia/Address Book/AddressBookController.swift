//
//  AddressBookController.swift
//  Magento2V4Theme
//
//  Created by Webkul on 12/02/18.
//  Copyright © 2018 Webkul. All rights reserved.
//

import UIKit

class AddressBookController: AfritiaBaseViewController  {
    
    @IBOutlet weak var addnewAddressButton: UIButton!
    @IBOutlet weak var addressTableView: UITableView!
    @IBOutlet weak var afritiaNavBarView: AFNavigationBarView!
    @IBOutlet weak var afritiaNavBarViewHeight:NSLayoutConstraint!
   
    var addressBookViewModel:AddressBookViewModel!
    var addoredit:String = ""
    var addressId:String = "0"
    var whichApiDataToProcess:String = ""
    var documentPathUrl: NSURL!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        addressTableView.register(UINib(nibName: "AddressViewCell", bundle: nil), forCellReuseIdentifier: "AddressViewCell")
        addressTableView.register(UINib(nibName: "AddreessViewCell2", bundle: nil), forCellReuseIdentifier: "AddreessViewCell2")
        addressTableView.register(UINib(nibName: "AddressViewCell3", bundle: nil), forCellReuseIdentifier: "AddressViewCell3")
        addressTableView.rowHeight = UITableViewAutomaticDimension
        self.addressTableView.estimatedRowHeight = 100
        self.addressTableView.separatorColor = UIColor.clear
        
        addnewAddressButton.backgroundColor = UIColor.DimLavendar
        addnewAddressButton.setTitleColor(UIColor.DarkLavendar, for: .normal)
        addnewAddressButton.setTitle("addnewaddress".localized, for: .normal)
        addnewAddressButton.layer.borderColor = UIColor.DarkLavendar.cgColor
        addnewAddressButton.layer.borderWidth = 0.5
        addnewAddressButton.layer.cornerRadius = 15
        addnewAddressButton.layer.masksToBounds = true
    }
    
    override func viewWillAppear(_ animated: Bool) {
        //self.navigationController?.isNavigationBarHidden = false
        //self.navigationController?.navigationBar.applyAfritiaTheme()
        //self.title = "addressbook".localized
        self.setUpCustomNavigationBar()
        callingHttppApi()
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

    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(true)
        navigationItem.backBarButtonItem = UIBarButtonItem(title: " ", style: .plain, target: nil, action: nil)
    }
    
    func callingHttppApi(){
        GlobalData.sharedInstance.showLoader()
        self.view.isUserInteractionEnabled = false

        if whichApiDataToProcess == "deleteAddress"{
            var requstParams = [String:Any]()
            requstParams["customerToken"] = UserManager.getCustomerId
            requstParams["addressId"] = addressId
            
            APIServiceManager.shared.callingHttpRequest(params:requstParams, apiname:AfritiaAPI.deleteAddress, currentView: self){success,responseObject in
                if success == 1{
                    
                    let data = responseObject as! NSDictionary
                    print(data)
                    GlobalData.sharedInstance.dismissLoader()
                    let errorCode = data .object(forKey:"success") as! Bool
                    if errorCode == true{
                        self.whichApiDataToProcess = ""
                        self.callingHttppApi()
                    }else{
                        AlertManager.shared.showErrorSnackBar(msg:"somethingwentwrongpleasetryagain".localized)
                    }
                }else if success == 2{
                    GlobalData.sharedInstance.dismissLoader()
                    self.callingHttppApi()
                }
            }
        }
        else
        {
            
            var requstParams = [String:Any]()
            requstParams["storeId"] = UserManager.getStoreId
            requstParams["customerToken"] = UserManager.getCustomerId
            
            APIServiceManager.shared.callingHttpRequest(params:requstParams, apiname:AfritiaAPI.addressBookData, currentView: self){success,responseObject in
                if success == 1{
                    if responseObject?.object(forKey: "storeId") != nil{
                        let storeId:String = String(format: "%@", responseObject!.object(forKey: "storeId") as! CVarArg)
                        if storeId != "0"{
                            DEFAULTS.set(storeId, forKey: "storeId")
                        }
                    }
                    
                    GlobalData.sharedInstance.dismissLoader()
                    self.view.isUserInteractionEnabled = true
                    print(responseObject!)
                    self.addressBookViewModel = AddressBookViewModel(data: JSON(responseObject as! NSDictionary))
                    self.doFurtherProcessingWithResult()
                    
                }else if success == 2{
                    GlobalData.sharedInstance.dismissLoader()
                    self.callingHttppApi()
                }
            }
        }
    }
    
    func doFurtherProcessingWithResult(){
        addressTableView.delegate = self
        addressTableView.dataSource = self
        addressTableView.reloadData()
    }
    
    
    @IBAction func AddnewAddressClick(_ sender: UIButton) {
        
        let vc = AppStoryboard.Main.instance.instantiateViewController(withIdentifier:"AddEditAddress") as! AddEditAddress
        vc.addressEdiitByView = .addressBook
        vc.addOrEdit = "0"
        vc.addressId = ""
        self.navigationController?.pushViewController(vc, animated:true)
        //addoredit = "0"
        //self.performSegue(withIdentifier: "addeditaddress", sender: self)
    }
    
    @objc func editAddressButtonTapped(sender: UIButton){
        //addoredit = "1";
        //addressId = self.addressBookViewModel.additionalAddressCollection[sender.tag].id
        
        let vc = AppStoryboard.Main.instance.instantiateViewController(withIdentifier:"AddEditAddress") as! AddEditAddress
        vc.addressEdiitByView = .addressBook
        vc.addOrEdit = "1"
        vc.addressId = self.addressBookViewModel.additionalAddressCollection[sender.tag].id
        self.navigationController?.pushViewController(vc, animated:true)
        
        //self.performSegue(withIdentifier: "addeditaddress", sender: self)
    }
    
    @objc func editShippingAddressButtonTapped(sender: UIButton){
        var addOrEditMode = ""
        if self.addressBookViewModel.addressBookModel.shippingId == 0{
            addOrEditMode = "0"
        }else{
            addOrEditMode = "1"
        }
        
        let vc = AppStoryboard.Main.instance.instantiateViewController(withIdentifier:"AddEditAddress") as! AddEditAddress
        vc.addressEdiitByView = .addressBook
        vc.addOrEdit = addOrEditMode
        vc.addressId = self.addressBookViewModel.addressBookModel.shippingIdValue
        self.navigationController?.pushViewController(vc, animated:true)
        
        //addressId = self.addressBookViewModel.addressBookModel.shippingIdValue
        //self.performSegue(withIdentifier: "addeditaddress", sender: self)
    }
    
    @objc func editBillingAddressButtonTapped(sender: UIButton) {
        
        var addOrEditMode = ""
        if self.addressBookViewModel.addressBookModel.billingId == 0    {
            addOrEditMode = "0"
        }else{
            addOrEditMode = "1"
        }
        
        let vc = AppStoryboard.Main.instance.instantiateViewController(withIdentifier:"AddEditAddress") as! AddEditAddress
        vc.addressEdiitByView = .addressBook
        vc.addOrEdit = addOrEditMode
        vc.addressId = self.addressBookViewModel.addressBookModel.billingIdValue
        self.navigationController?.pushViewController(vc, animated:true)
        //self.performSegue(withIdentifier: "addeditaddress", sender: self)
    }
    
    @objc func deleteAddress(sender: UIButton){
        whichApiDataToProcess = "deleteAddress";
        addressId = self.addressBookViewModel.additionalAddressCollection[sender.tag].id
        
        let AC = UIAlertController(title:"warning".localized, message: "cartemtyinfo".localized, preferredStyle: .alert)
        let okBtn = UIAlertAction(title:"ok".localized, style: .default, handler: {(_ action: UIAlertAction) -> Void in
            self.callingHttppApi()
        })
        let noBtn = UIAlertAction(title:"cancel".localized, style: .destructive, handler: {(_ action: UIAlertAction) -> Void in
        })
        AC.addAction(okBtn)
        AC.addAction(noBtn)
        self.parent!.present(AC, animated: true, completion: { })
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if (segue.identifier! == "addeditaddress") {
            let viewController:AddEditAddress = segue.destination as UIViewController as! AddEditAddress
            viewController.addOrEdit = self.addoredit
            viewController.addressId = addressId
        }
    }
}

/*
//MARK:- GDPR
extension AddressBookController {
    
    @IBAction func downloadFile(_ sender: UIButton)    {
        
        if sender.superview?.tag == 0{
            addressId = self.addressBookViewModel.addressBookModel.billingIdValue
        }else if sender.superview?.tag == 1{
            addressId = self.addressBookViewModel.addressBookModel.shippingIdValue
        }else if sender.superview?.tag == 2{
            addressId = self.addressBookViewModel.additionalAddressCollection[sender.tag].id
        }
        
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
        let postString = params;
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
                                
                                if let gdprPdfVC = AppStoryboard.Marketplace.instance.instantiateViewController(withIdentifier: "ShowDownloadFile") as? ShowDownloadFile{
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
                
            } else {
                GlobalData.sharedInstance.dismissLoader()
                print("Failure: %@", error?.localizedDescription as Any)
            }
        }
        task.resume()
    }
}*/

extension AddressBookController : UITableViewDelegate, UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 3
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int{
        if section == 0 || section == 1{
            return 1
        }else{
            return self.addressBookViewModel.additionalAddressCollection.count;
        }
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        if section == 0{
            return "BillingAddress".localized
        }else if section == 1{
            return "ShippingAddress".localized
        }else{
            return self.addressBookViewModel.additionalAddressCollection.count > 0 ? "AdditionalAddress".localized : ""
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        if indexPath.section == 0   {
            let cell = tableView.dequeueReusableCell(withIdentifier: "AddressViewCell", for: indexPath) as! AddressViewCell
            cell.addressValue.text = self.addressBookViewModel.addressBookModel.billingAddress
            cell.deleteButton.isHidden = true
            cell.editButton.tag = indexPath.row
            cell.editButton.addTarget(self, action: #selector(editBillingAddressButtonTapped(sender:)), for: .touchUpInside)
            cell.downloadBtn.superview?.tag = indexPath.section
            cell.downloadBtn.tag = indexPath.row
            //cell.downloadBtn.addTarget(self, action: #selector(downloadFile(_:)), for: .touchUpInside)
            cell.item = self.addressBookViewModel
            
            cell.selectionStyle = .none
            return cell
        }else if indexPath.section == 1 {
            let cell = tableView.dequeueReusableCell(withIdentifier: "AddreessViewCell2", for: indexPath) as! AddreessViewCell2
            cell.addressValue.text = self.addressBookViewModel.addressBookModel.shippingAddress
            cell.deleteButton.isHidden = true
            cell.editButton.tag = indexPath.row
            cell.editButton.addTarget(self, action: #selector(editShippingAddressButtonTapped(sender:)), for: .touchUpInside)
            cell.downloadButton.superview?.tag = indexPath.section
            cell.downloadButton.tag = indexPath.row
            //cell.downloadButton.addTarget(self, action: #selector(downloadFile(_:)), for: .touchUpInside)
            cell.item = self.addressBookViewModel
            
            cell.selectionStyle = .none
            return cell
        }else   {
            let cell = tableView.dequeueReusableCell(withIdentifier: "AddressViewCell3", for: indexPath) as! AddressViewCell3
            cell.addressValue.text = self.addressBookViewModel.additionalAddressCollection[indexPath.row].value
            cell.editButton.tag = indexPath.row
            cell.editButton.addTarget(self, action: #selector(editAddressButtonTapped(sender:)), for: .touchUpInside)
            cell.deleteButton.isHidden = false
            cell.deleteButton.tag = indexPath.row
            cell.deleteButton.addTarget(self, action: #selector(deleteAddress(sender:)), for: .touchUpInside)
            cell.downloadButton.superview?.tag = indexPath.section
            cell.downloadButton.tag = indexPath.row
            //cell.downloadButton.addTarget(self, action: #selector(downloadFile(_:)), for: .touchUpInside)
            cell.item = self.addressBookViewModel
            
            cell.selectionStyle = .none
            return cell
        }
    }
    
    
}
