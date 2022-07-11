//
//  MyCart.swift
//  Magento2MobikulNew
//
//  Created by Webkul  on 29/08/17.
//  Copyright © 2017 Webkul . All rights reserved.
//

import UIKit

class MyCart: AfritiaBaseViewController, UITextFieldDelegate {
    
    let defaults = UserDefaults.standard
    var myCartViewModel:MyCartViewModel!
    
    var extraHeight:CGFloat = 0
    var whichApiToProcess = ""
    var itemId:String = ""
    var toUpdateItemQtys = NSMutableArray()
    var toUpdateItemId = NSMutableArray()
    var coupontextField:UITextField!
    var productName:String!
    var imageUrl:String!
    var productid:String!
    var keyBoardshownFlag:Int = 0
    var proceedToCheckout:Bool = true
    var emptyView:EmptyPlaceHolderView!
    
    @IBOutlet weak var afritiaNavBarView: AFNavigationBarView!
    @IBOutlet weak var afritiaNavBarViewHeight:NSLayoutConstraint!
    @IBOutlet weak var cartTableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.setUpCustomNavigationBar()
        
        //self.navigationController?.isNavigationBarHidden = false
        //self.navigationController?.navigationBar.applyAfritiaTheme()
        //self.navigationItem.title = GlobalData.sharedInstance.language(key: "mycart")
        
        cartTableView.separatorColor = UIColor.clear
        cartTableView.rowHeight = UITableViewAutomaticDimension
        self.cartTableView.estimatedRowHeight = 50
    }
    
    @objc func browseCategory(sender: UIButton){
        self.tabBarController!.selectedIndex = 2
    }
    
    @IBAction func dismissKeyBoard(_ sender: Any) {
        view.endEditing(true)
    }
    
    fileprivate func setUpCustomNavigationBar(){
        
        self.navigationController?.isNavigationBarHidden = true
        self.tabBarController!.tabBar.applyAfritiaTheme()
        
        self.changeStatusBarColor(color: UIColor.LightLavendar)
        
        afritiaNavBarView.configureLeftButton1(isVisible:true, btnType:.image, btnTitle:nil, btnImage:navIcon.back) { (btn) in
            self.tabBarController?.tabBar.isHidden = false
            self.navigationController?.popViewController(animated:true)
        }
        
        afritiaNavBarView.configureLeftButton2(isVisible:false, btnType:.none, btnTitle:nil, btnImage:nil, actionHandler:nil)
        
        afritiaNavBarView.configureRightButton1(isVisible:true, btnType:.image, btnTitle:nil, btnImage:navIcon.cart){(btn) in
            // do nothing
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
    
    override func viewWillAppear(_ animated: Bool) {
        
//        for view in self.view.subviews {
//            view.removeFromSuperview()
//        }
        
        whichApiToProcess = ""
        //cartTableView.isHidden = true
        //self.navigationController?.isNavigationBarHidden = false
        //self.navigationController?.interactivePopGestureRecognizer?.isEnabled = false
        //self.view.isUserInteractionEnabled = true
        //callingHttppApi()
        self.callApiToLoadCartItems()
    }
    
    func DisplayEmptyDataView(isVisible:Bool){
        
        if isVisible {
            emptyView = EmptyPlaceHolderView(frame: self.view.frame)
            emptyView.emptyImages.image = UIImage(named: "empty_cart")!
            emptyView.addressButton.setTitle(GlobalData.sharedInstance.language(key: "browsecategory"), for: .normal)
            emptyView.labelMessage.text = GlobalData.sharedInstance.language(key: "emptycartmessage")
            emptyView.callBackBtnAction = {(action) in
                self.tabBarController!.selectedIndex = 2
            }
            
            cartTableView.backgroundView = emptyView
            cartTableView.separatorStyle = .none
            
        }else{
            
            cartTableView.backgroundView = nil
            cartTableView.separatorStyle = .singleLine
        }
    }
    
    //MARK:- API Call
    
    func callApiToLoadCartItems(){
        
        GlobalData.sharedInstance.showLoader()
        
        var requstParams = [String:Any]()
        requstParams["storeId"] = UserManager.getStoreId
        
        let quoteId = UserManager.getQuoteId
        let customerId = UserManager.getCustomerId
        
        if customerId != "" {
            requstParams["customerToken"] = customerId
            requstParams["quoteId"] = "0"
        }else{
            if(quoteId != ""){
                requstParams["quoteId"] = quoteId
            }else{
                requstParams["quoteId"] = ""
            }
            requstParams["customerToken"] = ""
        }
        
        requstParams["currency"] = UserManager.getCurrencyType
        
        GlobalData.sharedInstance.showLoader()
        APIServiceManager.shared.callingHttpRequest(params:requstParams, apiname:AfritiaAPI.cartDetails, currentView: self){success,responseObject in
            GlobalData.sharedInstance.dismissLoader()
            if success == 1
            {
                if responseObject?.object(forKey: "storeId") != nil{
                    let storeId:String = String(format: "%@", responseObject!.object(forKey: "storeId") as! CVarArg)
                    if storeId != "0"{
                        self.defaults .set(storeId, forKey: "storeId")
                    }
                }
                
                print(responseObject!)
                
                self.myCartViewModel = MyCartViewModel(data: JSON(responseObject as! NSDictionary))
                
                if self.myCartViewModel.getCartItems.count > 0{
                    
                    self.DisplayEmptyDataView(isVisible:false)
                    self.cartTableView.delegate = self
                    self.cartTableView.dataSource = self
                    self.cartTableView.reloadData()
                    
                    let cartItems = String(self.myCartViewModel.getExtraCartData.cartCount)
                    if let itemsInCart = Int(cartItems){
                        GlobalData.sharedInstance.cartItemsCount = itemsInCart
                    }
                    
                    //self.tabBarController!.tabBar.items?[3].badgeValue = String(self.myCartViewModel.getExtraCartData.cartCount)
                }else{
                    self.DisplayEmptyDataView(isVisible:true)
                    self.cartTableView.reloadData()
                    GlobalData.sharedInstance.cartItemsCount = 0
                    //self.tabBarController!.tabBar.items?[3].badgeValue = nil
                }
                
                if self.myCartViewModel.getExtraCartData.isVirtual == 1{
                    self.defaults.set("true", forKey: "isVirtual")
                }else{
                    self.defaults.set("false", forKey: "isVirtual")
                }

            }else if success == 2
            {
                self.callApiToLoadCartItems()
            }
            else if success == 0
            {
                if let data = responseObject as? NSDictionary {
                    if let otherError = data.object(forKey: "otherError") as? String  , otherError == "customerNotExist"  {
                        print("customerNotExist call")
                        self.defaults.removeObject(forKey: "customerId")
                        self.callApiToLoadCartItems()
                    }
                }
            }
        }
        
    }
    
    func callingHttppApi(){
        
        var requstParams = [String:Any]()
        if self.defaults.object(forKey: "storeId") != nil{
            requstParams["storeId"] = self.defaults.object(forKey: "storeId") as! String
        }
        let quoteId = self.defaults.object(forKey:"quoteId")
        let customerId = self.defaults.object(forKey:"customerId")
        
        if customerId != nil{
            requstParams["customerToken"] = customerId
            requstParams["quoteId"] = "0"
        }else{
            if(quoteId != nil){
                requstParams["quoteId"] = quoteId
            }
        }
        
        if self.whichApiToProcess == "removeitem"{
            GlobalData.sharedInstance.showLoader()
            requstParams["itemId"] = self.itemId
            APIServiceManager.shared.callingHttpRequest(params:requstParams, apiname:AfritiaAPI.removeCartItem, currentView: self){success,responseObject in
                GlobalData.sharedInstance.dismissLoader()
                if success == 1{
                    if responseObject?.object(forKey: "storeId") != nil{
                        let storeId:String = String(format: "%@", responseObject!.object(forKey: "storeId") as! CVarArg)
                        if storeId != "0"{
                            self.defaults .set(storeId, forKey: "storeId")
                        }
                    }
                    //self.whichApiToProcess = ""
                    self.callApiToLoadCartItems()
                }else if success == 2{
                    self.callingHttppApi()
                }
            }
        }
        else if self.whichApiToProcess == "movetowishlist"{
            GlobalData.sharedInstance.showLoader()
            requstParams["itemId"] = self.itemId
            APIServiceManager.shared.callingHttpRequest(params:requstParams, apiname:AfritiaAPI.wishlistFromCart, currentView: self){success,responseObject in
                GlobalData.sharedInstance.dismissLoader()
                
                if success == 1{
                    if responseObject?.object(forKey: "storeId") != nil{
                        let storeId:String = String(format: "%@", responseObject!.object(forKey: "storeId") as! CVarArg)
                        if storeId != "0"{
                            self.defaults .set(storeId, forKey: "storeId")
                        }
                    }
                    
                    print("sssss",responseObject as! NSDictionary)
                    AlertManager.shared.showSuccessSnackBar(msg:"successmovetowishlist".localized)
                    //self.whichApiToProcess = ""
                    self.callApiToLoadCartItems()
                    
                }else if success == 2{
                    self.callingHttppApi()
                }
            }
        }
        else if self.whichApiToProcess == "emptycart"{
            GlobalData.sharedInstance.showLoader()
            APIServiceManager.shared.callingHttpRequest(params:requstParams, apiname:AfritiaAPI.emptyCart, currentView: self){success,responseObject in
                GlobalData.sharedInstance.dismissLoader()
                if success == 1{
                    if responseObject?.object(forKey: "storeId") != nil{
                        let storeId:String = String(format: "%@", responseObject!.object(forKey: "storeId") as! CVarArg)
                        if storeId != "0"{
                            self.defaults .set(storeId, forKey: "storeId")
                        }
                    }
                    
                    //self.whichApiToProcess = ""
                    self.callApiToLoadCartItems()
                }else if success == 2{
                    self.callingHttppApi()
                }
            }
        }
        else if self.whichApiToProcess == "updatecart"{
            
            GlobalData.sharedInstance.showLoader()
            
            do {
                let jsonData1 =  try JSONSerialization.data(withJSONObject: self.toUpdateItemId, options: .prettyPrinted)
                let jsonString1:String = NSString(data: jsonData1, encoding: String.Encoding.utf8.rawValue)! as String
                requstParams["itemIds"] = jsonString1
                let jsonData2 =  try JSONSerialization.data(withJSONObject: self.toUpdateItemQtys, options: .prettyPrinted)
                let jsonString2:String = NSString(data: jsonData2, encoding: String.Encoding.utf8.rawValue)! as String
                requstParams["itemQtys"] = jsonString2
            }
            catch {
                print(error.localizedDescription)
            }
            
            APIServiceManager.shared.callingHttpRequest(params:requstParams, apiname:AfritiaAPI.updateCart, currentView: self){success,responseObject in
                GlobalData.sharedInstance.dismissLoader()
                if success == 1{
                    if responseObject?.object(forKey: "storeId") != nil{
                        let storeId:String = String(format: "%@", responseObject!.object(forKey: "storeId") as! CVarArg)
                        if storeId != "0"{
                            self.defaults .set(storeId, forKey: "storeId")
                        }
                    }
                    
                    print(responseObject!)
                    let dict = responseObject as! NSDictionary
                    if dict.object(forKey: "success") as! Bool == true{
                        AlertManager.shared.showSuccessSnackBar(msg: GlobalData.sharedInstance.language(key: "cartupdated"))
                    }
                    
                    self.callApiToLoadCartItems()
                    //self.whichApiToProcess = ""
                    //self.callingHttppApi()
                }else if success == 2{
                    self.callingHttppApi()
                }
            }
        }
        else if self.whichApiToProcess == "applycouponcode"{
            GlobalData.sharedInstance.showLoader()
            requstParams["couponCode"] = self.coupontextField.text
            requstParams["removeCoupon"] = "0"
            APIServiceManager.shared.callingHttpRequest(params:requstParams, apiname:AfritiaAPI.applyCoupan, currentView: self){success,responseObject in
                GlobalData.sharedInstance.dismissLoader()
                if success == 1{
                    if responseObject?.object(forKey: "storeId") != nil{
                        let storeId:String = String(format: "%@", responseObject!.object(forKey: "storeId") as! CVarArg)
                        if storeId != "0"{
                            self.defaults .set(storeId, forKey: "storeId")
                        }
                    }
                    
                    let dict = responseObject as! NSDictionary
 
                    if dict.object(forKey: "success") as! Bool == true{
                        //self.whichApiToProcess = ""
                        self.callApiToLoadCartItems()
                    }else{
                        //self.whichApiToProcess = ""
                        AlertManager.shared.showErrorSnackBar(msg: dict.object(forKey: "message") as! String)
                    }
                }else if success == 2{
                    self.callingHttppApi()
                }
            }
        }
        else if self.whichApiToProcess == "cancelcoupon"{
            GlobalData.sharedInstance.showLoader()
            requstParams["couponCode"] = self.coupontextField.text
            requstParams["removeCoupon"] = "1"
            APIServiceManager.shared.callingHttpRequest(params:requstParams, apiname:AfritiaAPI.applyCoupan, currentView: self){success,responseObject in
                GlobalData.sharedInstance.dismissLoader()
                if success == 1{
                    if responseObject?.object(forKey: "storeId") != nil{
                        let storeId:String = String(format: "%@", responseObject!.object(forKey: "storeId") as! CVarArg)
                        if storeId != "0"{
                            self.defaults .set(storeId, forKey: "storeId")
                        }
                    }
                    
                    let dict = responseObject as! NSDictionary

                    if dict.object(forKey: "success") as! Bool == true{
                        self.callApiToLoadCartItems()
                        //self.whichApiToProcess = ""
                        //self.callingHttppApi()
                    }else{
                        //self.whichApiToProcess = ""
                        AlertManager.shared.showErrorSnackBar(msg: dict.object(forKey: "message") as! String)
                    }
                }else if success == 2{
                    self.callingHttppApi()
                }
            }
        }
        /*
        else{
            if self.defaults.object(forKey: "currency") != nil{
                requstParams["currency"] = self.defaults.object(forKey: "currency") as! String
            }
            GlobalData.sharedInstance.showLoader()
            APIServiceManager.shared.callingHttpRequest(params:requstParams, apiname:AfritiaAPI.cartDetails, currentView: self){success,responseObject in
                if success == 1{
                    if responseObject?.object(forKey: "storeId") != nil{
                        let storeId:String = String(format: "%@", responseObject!.object(forKey: "storeId") as! CVarArg)
                        if storeId != "0"{
                            self.defaults .set(storeId, forKey: "storeId")
                        }
                    }
                    
                    print(responseObject)
                    self.view.isUserInteractionEnabled = true
                    GlobalData.sharedInstance.dismissLoader()
                    self.myCartViewModel = MyCartViewModel(data: JSON(responseObject as! NSDictionary))
                    self.doFurtherProcessingWithResult()
                    
                }else if success == 2{
                    GlobalData.sharedInstance.dismissLoader()
                    self.callingHttppApi()
                }else if success == 0   {
                    if let data = responseObject as? NSDictionary   {
                        if let otherError = data.object(forKey: "otherError") as? String  , otherError == "customerNotExist"  {
                            print("customerNotExist call")
                            GlobalData.sharedInstance.dismissLoader()
                            self.defaults.removeObject(forKey: "customerId")
                            self.callingHttppApi()
                        }
                    }
                }
            }
        }
        */
    }
    
    /*
    func doFurtherProcessingWithResult(){
        
        if self.myCartViewModel.getCartItems.count > 0{
            
            self.DisplayEmptyDataView(isVisible:false)
            //self.emptyView.isHidden = true
            //self.cartTableView.isHidden = false
            
            self.cartTableView.delegate = self
            self.cartTableView.dataSource = self
            self.cartTableView.reloadData()
            self.tabBarController!.tabBar.items?[3].badgeValue = String(self.myCartViewModel.getExtraCartData.cartCount)
        }else{
            self.DisplayEmptyDataView(isVisible:true)
            self.cartTableView.reloadData()
            //self.cartTableView.isHidden = true
            //self.emptyView.isHidden = false
            self.tabBarController!.tabBar.items?[3].badgeValue = nil
        }
        
        if self.myCartViewModel.getExtraCartData.isVirtual == 1{
            self.defaults.set("true", forKey: "isVirtual")
        }else{
            self.defaults.set("false", forKey: "isVirtual")
        }

    }*/
    
    //MARK:- Alert Actions
    
    func checkOutAsGuest(alertAction: UIAlertAction!) {
        let vc = AppStoryboard.Checkout.instance.instantiateViewController(withIdentifier: "CheckoutNavController") as! UINavigationController
        vc.modalPresentationStyle = .fullScreen
        self.present(vc, animated: true, completion: nil)
        //self.performSegue(withIdentifier: "proceedtocheckout", sender: self)
    }
    
    func registerAndCheckOut(alertAction: UIAlertAction!) {
        self.performSegue(withIdentifier: "cartToCreateAccount", sender: self)
    }
    
    func existingUser(alertAction: UIAlertAction!) {
        self.performSegue(withIdentifier: "cartToCustomerLogin", sender: self)
    }
    
    func cancelDeletePlanet(alertAction: UIAlertAction!) {
        
    }
    
    //MARK:- @IBAction
    
    @objc func moveToWishList(sender: UIButton){
        
        if UserManager.getCustomerId == "" {
            AlertManager.shared.showWarningSnackBar(msg: GlobalData.sharedInstance.language(key: "loginrequired"))
            return
        }
        
        let selCartItem = myCartViewModel.getCartItems[sender.tag]
        //let json = JSON("{}")
        
        WishListServiceHelper.getWishListGroups { (result, wishlistGroups) in
            
            WishListServiceHelper.showWishListGroupsPopUp(onVC: self, availWishList: wishlistGroups) { (selGroupId, selGroupName) in
                
                WishListServiceHelper.addProductToWishlist(groupId: selGroupId, groupName: selGroupName, productId: selCartItem.id) { (result, message) in
                    
                    if result {
                        //AlertManager.shared.showSuccessSnackBar(msg: message)
                        AlertManager.shared.showSuccessSnackBar(msg:message)
                        //self.whichApiToProcess = ""
                        self.callApiToLoadCartItems()
                    }
                    else{
                        AlertManager.shared.showErrorSnackBar(msg:message)
                    }
                }
            }
        }
        
        /*
        let customerId = defaults.object(forKey: "customerId")
        
        if customerId != nil {
            itemId = myCartViewModel.getCartItems[sender.tag].id
            whichApiToProcess = "movetowishlist"
            self.proceedToCheckout = true
            callingHttppApi()
        }
        else
        {
            let AC = UIAlertController(title: "loginrequired".localized, message: "doyouwanttologin".localized, preferredStyle: .alert)
            let yesBtn = UIAlertAction(title: GlobalData.sharedInstance.language(key: "yes"), style: .default, handler: {(_ action: UIAlertAction) -> Void in
                let vc = self.storyboard?.instantiateViewController(withIdentifier: "CustomerLogin") as! CustomerLogin
                self.navigationController?.pushViewController(vc, animated: true)
            })
            let noBtn = UIAlertAction(title: GlobalData.sharedInstance.language(key: "no"), style: .default, handler: {(_ action: UIAlertAction) -> Void in
            })
            
            AC.addAction(yesBtn)
            AC.addAction(noBtn)
            self.present(AC, animated: true, completion: { })
        } */
    }
    
    @objc func removeItem(sender: UIButton){
        self.itemId = self.myCartViewModel.getCartItems[sender.tag].id
        self.whichApiToProcess = "removeitem"
        self.callingHttppApi()
    }
    
    @objc func editCartItem(sender: UIButton){
        itemId = myCartViewModel.getCartItems[sender.tag].id
    }
    
    @objc func emptyCart(sender: UIButton){
        let AC = UIAlertController(title: GlobalData.sharedInstance.language(key: "pleaseconfirm"), message: GlobalData.sharedInstance.language(key: "cartemtyinfo"), preferredStyle: .alert)
        let okBtn = UIAlertAction(title: GlobalData.sharedInstance.language(key: "remove"), style: .default, handler: {(_ action: UIAlertAction) -> Void in
            self.whichApiToProcess = "emptycart"
            self.proceedToCheckout = true
            self.callingHttppApi()
        })
        let noBtn = UIAlertAction(title:GlobalData.sharedInstance.language(key: "cancel"), style: .destructive, handler: {(_ action: UIAlertAction) -> Void in
        })
        AC.addAction(okBtn)
        AC.addAction(noBtn)
        self.parent!.present(AC, animated: true, completion: {  })
    }
    
    @objc func updateCart(sender: UIButton){
        toUpdateItemId = NSMutableArray()
        toUpdateItemQtys = NSMutableArray()
        
        for i in 0..<myCartViewModel.getCartItems.count{
            toUpdateItemId.add(myCartViewModel.getCartItems[i].id)
            toUpdateItemQtys.add(myCartViewModel.getCartItems[i].qty)
        }
        whichApiToProcess = "updatecart"
        proceedToCheckout = true
        callingHttppApi()
    }
    
    @objc func applyCouponCode(sender: UIButton){
        if coupontextField.text == ""{
            
            AlertManager.shared.showErrorSnackBar(msg: GlobalData.sharedInstance.language(key: "entercoupan"))
        }else{
            whichApiToProcess = "applycouponcode"
            proceedToCheckout = true
            callingHttppApi()
        }
    }
    
    @objc func cancelCouponCode(sender: UIButton){
        if(coupontextField.text == ""){
            let AC = UIAlertController(title: GlobalData.sharedInstance.language(key: "warning"), message: GlobalData.sharedInstance.language(key: "entercoupan"), preferredStyle: .alert)
            let okBtn = UIAlertAction(title: GlobalData.sharedInstance.language(key: "ok"), style: .destructive, handler: {(_ action: UIAlertAction) -> Void in
            })
            
            AC.addAction(okBtn)
            self.parent!.present(AC, animated: true, completion: {  })
        }else{
            whichApiToProcess = "cancelcoupon"
            proceedToCheckout = true
            callingHttppApi()
        }
    }
    
    @objc func proceedToCheckOut(sender: UIButton){
        
        //check for minimum order
        if myCartViewModel.myCartExtraData.grandUnformatedValue < myCartViewModel.myCartExtraData.minimumAmount {
            AlertManager.shared.showWarningSnackBar(msg: "minimumorderamountis".localized + " " + "\(myCartViewModel.myCartExtraData.minimumFormattedAmount!)")
        }else{
            
            if UserManager.getCustomerId != ""{
                let vc = AppStoryboard.Checkout.instance.instantiateViewController(withIdentifier: "CheckoutNavController") as! UINavigationController
                vc.modalPresentationStyle = .fullScreen
                self.present(vc, animated: true, completion: nil)
                //self.navigationController?.pushViewController(vc, animated: true)
                //self.performSegue(withIdentifier: "proceedtocheckout", sender: self)
            }
            else{
                let alert = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
                let Create = UIAlertAction(title: GlobalData.sharedInstance.language(key: "checkoutasguest"), style: .default, handler: checkOutAsGuest)
                let guest = UIAlertAction(title: GlobalData.sharedInstance.language(key: "registerandcheckout"), style: .default, handler: registerAndCheckOut)
                let Existing = UIAlertAction(title: GlobalData.sharedInstance.language(key: "checkoutasexistingcustomer"), style: .default, handler: existingUser)
                let cancel = UIAlertAction(title: GlobalData.sharedInstance.language(key: "cancel"), style: .cancel, handler: cancelDeletePlanet)
                
                if self.myCartViewModel.getExtraCartData.isVirtual == 0 && myCartViewModel.myCartExtraData.isAllowedGuestCheckout   {
                    alert.addAction(Create)
                }
                alert.addAction(guest)
                alert.addAction(Existing)
                alert.addAction(cancel)
                
                // Support display in iPad
                alert.popoverPresentationController?.sourceView = self.view
                alert.popoverPresentationController?.sourceRect = CGRect(x:self.view.bounds.size.width / 2.0, y: self.view.bounds.size.height / 2.0, width : 1.0, height : 1.0)
                self.present(alert, animated: true, completion: nil)
            }
        }
    }
    
    @objc func openProduct(_sender : UITapGestureRecognizer){
        let vc = AppStoryboard.Main.instance.instantiateViewController(withIdentifier: "catalogproduct") as! CatalogProduct
        vc.productName = myCartViewModel.getCartItems[(_sender.view?.tag)!].name
        vc.productId = myCartViewModel.getCartItems[(_sender.view?.tag)!].productId
        vc.productImageUrl = myCartViewModel.getCartItems[(_sender.view?.tag)!].imageUrl
        vc.fromVC = "mycart"
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    @objc func shareLinkTapped(_ sender:UIButton){
        var stringToShare = [String]()
        myCartViewModel.myCartModel.forEach{stringToShare.append("afritia.customers://" + $0.url)}
//        myCartViewModel.myCartModel.forEach{stringToShare += ("afritia.customers://" + $0.url + "\n")}
        let textShareVc = UIActivityViewController(activityItems: stringToShare, applicationActivities: nil);
        if(UIDevice().model.lowercased() == "ipad".lowercased()){
            textShareVc.popoverPresentationController?.sourceView = sender
        }
        textShareVc.modalPresentationStyle = .fullScreen;
        self.present(textShareVc, animated: true, completion: nil)
    }
    
    
    //MARK:- Segue
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if (segue.identifier! == "cartToCreateAccount") {
            let viewController:CreateAccount = segue.destination as UIViewController as! CreateAccount
            viewController.movetoSignal = "cart"
        }else  if (segue.identifier! == "cartToCustomerLogin") {
            let viewController:CustomerLogin = segue.destination as UIViewController as! CustomerLogin
            viewController.moveToSignal = "cart"
        }else  if (segue.identifier! == "proceedtocheckout"){
            let viewController:UINavigationController = segue.destination  as! UINavigationController
            viewController.modalPresentationStyle = .fullScreen
        }
    }
}

extension MyCart : UITableViewDelegate, UITableViewDataSource {
    
    //MARK:- UITableViewDelegate
    func numberOfSections(in tableView: UITableView) -> Int{
        
        if self.myCartViewModel.getCartItems.count > 0 {
            return 2
        }
        return 0
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int{
        if section == 0{
            return self.myCartViewModel.getCartItems.count
        }else{
            return 1
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.section == 0{
            cartTableView.register(UINib(nibName: "CartTableViewCell", bundle: nil), forCellReuseIdentifier: "cell")
            let cell:CartTableViewCell = tableView.dequeueReusableCell(withIdentifier: "cell") as! CartTableViewCell
            
            cell.productNameLabelValue.text = myCartViewModel.getCartItems[indexPath.row].name
            cell.productNameLabelValue.font = UIFont.systemFont(ofSize:15, weight:.semibold)
            cell.qtyValue.text = myCartViewModel.getCartItems[indexPath.row].qty
            cell.priceLabelValue.text = myCartViewModel.getCartItems[indexPath.row].price
            cell.subtotalLabelValue.text  = myCartViewModel.getCartItems[indexPath.row].subtotal
            GlobalData.sharedInstance.getImageFromUrl(imageUrl: myCartViewModel.getCartItems[indexPath.row].imageUrl, imageView: cell.productImageView)
            let optionArray = myCartViewModel.getCartItems[indexPath.row].options
            
            if myCartViewModel.getCartItems[indexPath.row].message.count > 0{
                let dict:JSON = myCartViewModel.getCartItems[indexPath.row].message
                if dict["type"].stringValue == "error"{
                    cell.errorMessage.isHidden = false
                    proceedToCheckout = false
                    cell.errorMessage.text = dict["text"].stringValue
                }
            }else{
                cell.errorMessage.isHidden = true
            }
            
            var optionData:String = ""
            
            for i in 0..<optionArray.count{
                let dict = optionArray[i]
                optionData = optionData+dict["label"].stringValue+": "
                var childValue:String = ""
                if dict["value"].arrayValue.count > 0 {
                    for j in 0..<dict["value"].count {
                        if j == dict["value"].count - 1 {
                            childValue = childValue+dict["value"][j].stringValue
                        } else {
                            childValue = childValue+dict["value"][j].stringValue+","
                        }
                    }
                }
                optionData = optionData+childValue+"\n"
            }
            cell.stepperButton.value = Double(myCartViewModel.getCartItems[indexPath.row].qty)!
            cell.stepperButton.tag = indexPath.row
            cell.myCartViewModel = self.myCartViewModel
            cell.optionMessage.text = optionData
            cell.moveToWishListButton.tag = indexPath.row
            cell.moveToWishListButton.addTarget(self, action: #selector(moveToWishList(sender:)), for: .touchUpInside)
            
            let tapGesture = UITapGestureRecognizer(target: self, action: #selector(openProduct))
            cell.productImageView.addGestureRecognizer(tapGesture)
            cell.productImageView.tag = indexPath.row
            cell.productImageView.isUserInteractionEnabled = true
            cell.removeButton.tag = indexPath.row
            cell.removeButton.addTarget(self, action: #selector(removeItem(sender:)), for: .touchUpInside)
            
            let customerId = defaults.object(forKey:"customerId")
            if customerId != nil{
                cell.moveToWishListButton.isHidden = false
            }else{
                cell.moveToWishListButton.isHidden = true
            }
            
            if !myCartViewModel.getCartItems[indexPath.row].isAnimate{
                cell.productImageView.transform = CGAffineTransform(scaleX: 0.5, y: 0.5)
                UIView.animate(withDuration: 0.5, animations: {() -> Void in
                    cell.productImageView.transform = CGAffineTransform(scaleX: 0.5, y: 0.5)
                }, completion: {(_ finished: Bool) -> Void in
                    UIView.animate(withDuration: 0.5, animations: {() -> Void in
                        cell.productImageView.transform = CGAffineTransform(scaleX: 1, y: 1)
                        self.myCartViewModel.getCartItems[indexPath.row].isAnimate = true
                    })
                })
            }
            
            cell.item = myCartViewModel.getCartItems[indexPath.row]
            
            cell.selectionStyle = .none
            cell.setNeedsDisplay()
            return cell
        }
        else{
            cartTableView.register(UINib(nibName: "ExtraCartTableViewCell", bundle: nil), forCellReuseIdentifier: "extracell")
            let cell:ExtraCartTableViewCell = tableView.dequeueReusableCell(withIdentifier: "extracell") as! ExtraCartTableViewCell
            cell.subTotalLabel.text = myCartViewModel.getExtraCartData.subTotalLabel
            cell.subTotalLabelValue.text = myCartViewModel.getExtraCartData.subTotalValue
            cell.taxLabel.text = myCartViewModel.getExtraCartData.taxLabel
            cell.taxLabelValue.text = myCartViewModel.getExtraCartData.taxValue
            cell.shippingHandlingLabel.text = myCartViewModel.getExtraCartData.shippingLabel
            cell.shippingHandlingLabelValue.text = myCartViewModel.getExtraCartData.shippingValue
            cell.grandTotalLabel.text = myCartViewModel.getExtraCartData.grandLabel
            cell.grandTotalLabelValue.text = myCartViewModel.getExtraCartData.grandValue
            
            
            if myCartViewModel.getExtraCartData.discountLabel != ""{
                cell.discountLabe.text = myCartViewModel.getExtraCartData.discountLabel
                cell.discountLabelValue.text = myCartViewModel.getExtraCartData.discountValue
            }else{
                cell.discountLabe.text = "Discount"
                cell.discountLabelValue.text = "0.00"
            }
            
            cell.emptyCartButton.addTarget(self, action: #selector(emptyCart(sender:)), for: .touchUpInside)
            cell.updateCartButton.addTarget(self, action: #selector(updateCart(sender:)), for: .touchUpInside)
            cell.shareCartButton.addTarget(self, action: #selector(shareLinkTapped(_:)), for: .touchUpInside)
            
            coupontextField = cell.couponCodeTextFeild
            coupontextField.placeholder = GlobalData.sharedInstance.language(key: "entercoupan")
            
            cell.couponCodeTextFeild.delegate = self
            if myCartViewModel.getExtraCartData.couponCode == ""{
                cell.cancelButton.isHidden = true
            }else{
                cell.cancelButton.isHidden = false
            }
            
            cell.proceedToCheckOutButton.addTarget(self, action: #selector(proceedToCheckOut(sender:)), for: .touchUpInside)
            cell.applyButton.addTarget(self, action: #selector(applyCouponCode(sender:)), for: .touchUpInside)
            cell.cancelButton.addTarget(self, action: #selector(cancelCouponCode(sender:)), for: .touchUpInside)
            
            if proceedToCheckout == false{
                cell.proceedToCheckOutButton.isHidden = true
            }else{
                cell.proceedToCheckOutButton.isHidden = false
            }
            
            //check for minimum order
            if self.myCartViewModel.myCartExtraData.grandUnformatedValue < self.myCartViewModel.myCartExtraData.minimumAmount {
                cell.proceedToCheckOutButton.backgroundColor = UIColor.groupTableViewBackground
                cell.proceedToCheckOutButton.setTitle("minimumorderamountis".localized + " " + "\(myCartViewModel.myCartExtraData.minimumFormattedAmount!)", for: .normal)
                cell.proceedToCheckOutButton.setTitleColor(UIColor.red, for: .normal)
            } else {
                cell.proceedToCheckOutButton.backgroundColor = UIColor.button
                cell.proceedToCheckOutButton.setTitle("checkout".localized, for: .normal)
                cell.proceedToCheckOutButton.setTitleColor(UIColor.white, for: .normal)
            }
            
            cell.selectionStyle = .none
            cell.setNeedsDisplay()
            return cell
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if indexPath.section == 0{
            return UITableViewAutomaticDimension
        }else{
            return 435
        }
    }
}
