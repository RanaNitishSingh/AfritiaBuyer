//
//  SellerDetailsViewController.swift
//  Getkart
//
//  Created by kunal on 28/02/18.
//  Copyright © 2018 kunal. All rights reserved.
//

import UIKit

class SellerDetailsViewController : AfritiaBaseViewController {
    
    @IBOutlet weak var tableView: UITableView!
    
    @IBOutlet weak var afritiaNavBarView: AFNavigationBarView!
    @IBOutlet weak var afritiaNavBarViewHeight:NSLayoutConstraint!
    var profileUrl:String!
    var sellerProfileDetailsViewModel:SellerProfileDetailsViewModel!
    var sellerExtraData : SellerProfileExtraDetailsData!
    var message:String!
    var whichApiToProcess:String = ""
    var productId:String = ""
    var productName:String!
    var productImage:String!
    var wishListItemIndex = 0
    
    fileprivate var shopCollUrl:String = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //self.navigationController?.isNavigationBarHidden = false
        //navigationController?.navigationBar.applyAfritiaTheme()
        
        self.setUpCustomNavigationBar()
        
        self.navigationItem.title = "sellerdetails".localized
        tableView.register(UINib(nibName: "SellerProfileTopViewCell", bundle: nil), forCellReuseIdentifier: "SellerProfileTopViewCell")
        tableView.register(UINib(nibName: "SellerProductTableViewCell", bundle: nil), forCellReuseIdentifier: "SellerProductTableViewCell")
        tableView.register(UINib(nibName: "SellerRatingViewCell", bundle: nil), forCellReuseIdentifier: "SellerRatingViewCell")
        tableView.register(UINib(nibName: "SellerContactTableViewCell", bundle: nil), forCellReuseIdentifier: "SellerContactTableViewCell")
        tableView.register(UINib(nibName: "SellerReviewsCell", bundle: nil), forCellReuseIdentifier: "SellerReviewsCell")
        
        tableView.rowHeight = UITableViewAutomaticDimension
        self.tableView.estimatedRowHeight = 100
        self.tableView.separatorColor = UIColor.clear
        self.callingHttppApi()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(true)
        //navigationItem.backBarButtonItem = UIBarButtonItem(title: " ", style: .plain, target: nil, action: nil)
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
        
        var requstParams = [String:Any]();
        
        /*
        let storeId = defaults.object(forKey: "storeId")
        if(storeId != nil){
            requstParams["storeId"] = storeId
        }
        let customerId = defaults.object(forKey:"customerId");
        if customerId != nil{
            requstParams["customerToken"] = customerId
        }*/
        
        requstParams["storeId"] = UserManager.getStoreId
        requstParams["customerToken"] = UserManager.getCustomerId
    
        let width = String(format:"%f", SCREEN_WIDTH * UIScreen.main.scale)
        requstParams["width"] = width
        requstParams["sellerId"] = profileUrl
        
        APIServiceManager.shared.callingHttpRequest(params:requstParams, apiname:AfritiaAPI.sellerProfile, currentView: self){success,responseObject in
            GlobalData.sharedInstance.dismissLoader()
            if success == 1{
                if responseObject?.object(forKey: "storeId") != nil{
                    let storeId:String = String(format: "%@", responseObject!.object(forKey: "storeId") as! CVarArg)
                    if storeId != "0"{
                        DEFAULTS.set(storeId, forKey: "storeId")
                    }
                }
                print("sss", responseObject!)
                
                self.view.isUserInteractionEnabled = true
                let dict = JSON(responseObject as! NSDictionary)
                if dict["success"].boolValue == true{
                    self.sellerProfileDetailsViewModel = SellerProfileDetailsViewModel(data:dict)
                    self.sellerExtraData = self.sellerProfileDetailsViewModel.sellerProfileExtraDetailsData
                    self.tableView.delegate = self;
                    self.tableView.dataSource = self
                    self.tableView.reloadDataWithAutoSizingCellWorkAround()
                    self.shopCollUrl = dict["shopCollectionUrl"].stringValue
                }else{
                    AlertManager.shared.showErrorSnackBar(msg: dict["message"].stringValue)
                }
            }else if success == 2{
                self.callingHttppApi()
            }
        }
    }
    
    @objc func makeReview(sender: UIButton){
        if DEFAULTS.object(forKey: "customerId") != nil {
            let vc = AppStoryboard.Marketplace.instance.instantiateViewController(withIdentifier: "SellerMakeReviewController") as! SellerMakeReviewController
            vc.sellerId = self.profileUrl
            vc.shopUrl = self.sellerProfileDetailsViewModel.sellerProfileExtraDetailsData.shopUrl
            self.navigationController?.pushViewController(vc, animated: true)
        }else{
            AlertManager.shared.showWarningSnackBar(msg: "loginrequired".localized)
        }
    }
    
    @objc func viewAllProduct(sender: UIButton){
        let vc = AppStoryboard.Main.instance.instantiateViewController(withIdentifier: "Productcategory") as! Productcategory
        vc.categoryName = self.sellerProfileDetailsViewModel.sellerProfileExtraDetailsData.shopTitle
        vc.categoryType = "marketplace"
        vc.sellerId = profileUrl
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    func callingExtraHttpApi() {
        self.view.isUserInteractionEnabled = false
        GlobalData.sharedInstance.showLoader()
        var requstParams = [String:Any]();
        requstParams["storeId"] = UserManager.getStoreId
        requstParams["customerToken"] = UserManager.getCustomerId
        requstParams["quoteId"] = UserManager.getQuoteId

        
        if whichApiToProcess == "addtowishlist" {
            requstParams["productId"] = productId
            APIServiceManager.shared.callingHttpRequest(params:requstParams, apiname:AfritiaAPI.addToWishlist, currentView: self){success,responseObject in
                if success == 1{
                    if responseObject?.object(forKey: "storeId") != nil{
                        let storeId:String = String(format: "%@", responseObject!.object(forKey: "storeId") as! CVarArg)
                        if storeId != "0"{
                            DEFAULTS .set(storeId, forKey: "storeId")
                        }
                    }
                    GlobalData.sharedInstance.dismissLoader()
                    self.view.isUserInteractionEnabled = true
                    let data = responseObject as! NSDictionary
                    let errorCode: Bool = data .object(forKey:"success") as! Bool
                    
                    if errorCode == true {
                        AlertManager.shared.showSuccessSnackBar(msg: "successwishlist".localized)
                        self.sellerProfileDetailsViewModel.sellerRecentProduct[self.wishListItemIndex].isInWishlist = true
                        if let itemId = data.object(forKey:"itemId") as? Int {
                            self.sellerProfileDetailsViewModel.sellerRecentProduct[self.wishListItemIndex].wishlistItemId = String(itemId)
                        }
                    }else{
                        AlertManager.shared.showErrorSnackBar(msg: "errorwishlist".localized)
                    }
                }else if success == 2{
                    GlobalData.sharedInstance.dismissLoader()
                    self.callingExtraHttpApi()
                }
            }
        }
        else if whichApiToProcess == "removewishlist"{
            
            GlobalData.sharedInstance.showLoader()
            
            var requstParams = [String:Any]()
            requstParams["itemId"] = self.sellerProfileDetailsViewModel.sellerRecentProduct[self.wishListItemIndex].wishlistItemId
            requstParams["customerToken"] = DEFAULTS.object(forKey:"customerId") as! String
            requstParams["storeId"] = DEFAULTS.object(forKey:"storeId") as! String
            
            APIServiceManager.shared.callingHttpRequest(params:requstParams, apiname:AfritiaAPI.removeFromWishList, currentView: self){success,responseObject in
                if success == 1{
                    GlobalData.sharedInstance.dismissLoader()
                    self.view.isUserInteractionEnabled = true
                    
                    let dict = JSON(responseObject as! NSDictionary)
                    if dict["success"].boolValue == true{
                        AlertManager.shared.showSuccessSnackBar(msg: dict["message"].stringValue)
                        self.sellerProfileDetailsViewModel.sellerRecentProduct[self.wishListItemIndex].isInWishlist = false
                        self.sellerProfileDetailsViewModel.sellerRecentProduct[self.wishListItemIndex].wishlistItemId = ""
                    }else{
                        AlertManager.shared.showErrorSnackBar(msg:"errorwishlist".localized)
                    }
                }else if success == 2{
                    self.callingExtraHttpApi();
                    GlobalData.sharedInstance.dismissLoader()
                }
            }
        }
        else if whichApiToProcess == "addtocompare"{
            requstParams["productId"] = productId
            APIServiceManager.shared.callingHttpRequest(params:requstParams, apiname:AfritiaAPI.addToCompare, currentView: self){success,responseObject in
                if success == 1{
                    if responseObject?.object(forKey: "storeId") != nil{
                        let storeId:String = String(format: "%@", responseObject!.object(forKey: "storeId") as! CVarArg)
                        if storeId != "0"{
                            DEFAULTS.set(storeId, forKey: "storeId")
                        }
                    }
                    
                    GlobalData.sharedInstance.dismissLoader()
                    self.view.isUserInteractionEnabled = true
                    let data = responseObject as! NSDictionary
                    let errorCode: Bool = data .object(forKey:"success") as! Bool
                    
                    if errorCode == true{
                        AlertManager.shared.showSuccessSnackBar(msg:data.object(forKey: "message") as! String)
                    }
                    else{
                        AlertManager.shared.showErrorSnackBar(msg:data.object(forKey: "message") as! String)
                    }
                }else if success == 2{
                    GlobalData.sharedInstance.dismissLoader()
                    self.callingExtraHttpApi()
                }
            }
        }
    }
    
    //MARK:- Profile icons gestures
    
    @IBAction func openShareSheet(_ sender: UIButton) {
        let productUrl = self.shopCollUrl
        let activityItems = [productUrl]
        let activityController = UIActivityViewController(activityItems: activityItems, applicationActivities: nil)
        if UI_USER_INTERFACE_IDIOM() == .phone {
            self.present(activityController, animated: true, completion: {  })
        }
        else {
            let popup = UIPopoverController(contentViewController: activityController)
            popup.present(from: CGRect(x: CGFloat(self.view.frame.size.width / 2), y: CGFloat(self.view.frame.size.height / 4), width: CGFloat(0), height: CGFloat(0)), in: self.view, permittedArrowDirections: .any, animated: true)
        }
    }
    
    @IBAction func openFacebook(_ sender: UIButton) {
        
        let url = URL(string: "http://www.facebook.com/" + self.sellerProfileDetailsViewModel.sellerProfileExtraDetailsData.facebookId)!
        if #available(iOS 10.0, *) {
            UIApplication.shared.open(url, options: [:], completionHandler: nil)
        } else {
            UIApplication.shared.openURL(url)
        }
    }
    
    @IBAction func openTwitter(_ sender: UIButton) {
        
        let url = URL(string: "https://twitter.com/" + self.sellerProfileDetailsViewModel.sellerProfileExtraDetailsData.twitterId)!
        if #available(iOS 10.0, *) {
            UIApplication.shared.open(url, options: [:], completionHandler: nil)
        } else {
            UIApplication.shared.openURL(url)
        }
    }
    
    @IBAction func emailClick(_ sender: UIButton) {
        
        let emailId = String("")
        
        if let url = URL(string: "mailto:\(String(describing: emailId))"), UIApplication.shared.canOpenURL(url) {
            if #available(iOS 10.0, *) {
                UIApplication.shared.open(url)
            } else {
                UIApplication.shared.openURL(url)
            }
        }
    }
    
    @IBAction func callClick(_ sender: UIButton) {
        
        if let url = URL(string: "tel://\(123456)"), UIApplication.shared.canOpenURL(url) {
            if #available(iOS 10, *) {
                UIApplication.shared.open(url)
            } else {
                UIApplication.shared.openURL(url)
            }
        }
    }
}

extension SellerDetailsViewController : UITableViewDelegate, UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 5
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int{
        if section == 3{
            return self.sellerProfileDetailsViewModel.sellerFeedBackList.count
        }else{
            return 1
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.section == 0 {
            
            let cell = tableView.dequeueReusableCell(withIdentifier: "SellerProfileTopViewCell", for: indexPath) as! SellerProfileTopViewCell
            cell.bannerImage.getImageFromUrl(imageUrl:self.sellerExtraData.bannerImage)
            cell.sellerProfileImage.getImageFromUrl(imageUrl:self.sellerExtraData.profileImage)
           
            cell.sellerName.text = self.sellerExtraData.shopTitle.uppercased()
            cell.ratingValue.text = self.sellerExtraData.averageRating
            cell.location.text  = self.sellerExtraData.location
            
            /*
            cell.faceBook.addTarget(self, action: #selector(openFacebook(_:)), for: .touchUpInside)
            cell.twitter.addTarget(self, action: #selector(openTwitter(_:)), for: .touchUpInside)
            cell.call.addTarget(self, action: #selector(callClick(_:)), for: .touchUpInside)
            cell.mail.addTarget(self, action: #selector(emailClick(_:)), for: .touchUpInside)
            */
            
            cell.btnShare.addTarget(self, action: #selector(openShareSheet(_:)), for: .touchUpInside)
            cell.selectionStyle = .none
            return cell
        }
        else if indexPath.section == 1{
            
            let cell:SellerProductTableViewCell = tableView.dequeueReusableCell(withIdentifier: "SellerProductTableViewCell") as! SellerProductTableViewCell
            cell.sellerproducts = self.sellerProfileDetailsViewModel.sellerRecentProduct
            cell.delegate = self
            cell.productCollectionView.reloadData()
            cell.viewAllButton.addTarget(self, action: #selector(viewAllProduct(sender:)), for: .touchUpInside)
            cell.viewAllButton.isUserInteractionEnabled = true;
            cell.selectionStyle = .none
            return cell
        }
        else if indexPath.section == 2{
            let cell:SellerRatingViewCell = tableView.dequeueReusableCell(withIdentifier: "SellerRatingViewCell") as! SellerRatingViewCell
            
            cell.makeReviewButton.addTarget(self, action: #selector(makeReview(sender:)), for: .touchUpInside)
            cell.makeReviewButton.isUserInteractionEnabled = true;
            
            cell.avgRatingValue.text = self.sellerProfileDetailsViewModel.sellerProfileExtraDetailsData.averageRating
            cell.avgRatingLabel.text = "Average Rating"+"("+self.sellerProfileDetailsViewModel.sellerProfileExtraDetailsData.feedbackcount+")"
            cell.percentageValue.text = String (format:"%.1f",self.sellerProfileDetailsViewModel.sellerProfileExtraDetailsData.averageRatingFloatValue/5*100)+" %"+"Positive feed backs";
            
            cell.priceRating1Label.text = "5 Star"+"("+String(format:"%.0f",self.sellerProfileDetailsViewModel.sellerProfileExtraDetailsData.price5Star)+")"
            cell.priceRating2Label.text = "4 Star"+"("+String(format:"%.0f",self.sellerProfileDetailsViewModel.sellerProfileExtraDetailsData.price4Star)+")"
            cell.priceRating3Label.text = "3 Star"+"("+String(format:"%.0f",self.sellerProfileDetailsViewModel.sellerProfileExtraDetailsData.price3Star)+")"
            cell.priceRating4Label.text = "2 Star"+"("+String(format:"%.0f",self.sellerProfileDetailsViewModel.sellerProfileExtraDetailsData.price2Star)+")"
            cell.priceRating5Label.text = "1 Star"+"("+String(format:"%.0f",self.sellerProfileDetailsViewModel.sellerProfileExtraDetailsData.price1Star)+")"
            
            let totalPriceValue:Float = self.sellerProfileDetailsViewModel.sellerProfileExtraDetailsData.price5Star+self.sellerProfileDetailsViewModel.sellerProfileExtraDetailsData.price4Star+self.sellerProfileDetailsViewModel.sellerProfileExtraDetailsData.price3Star+self.sellerProfileDetailsViewModel.sellerProfileExtraDetailsData.price2Star+self.sellerProfileDetailsViewModel.sellerProfileExtraDetailsData.price1Star
            
            cell.priceRating1Value.progress = self.sellerProfileDetailsViewModel.sellerProfileExtraDetailsData.price5Star == 0.0 ? 0 : self.sellerProfileDetailsViewModel.sellerProfileExtraDetailsData.price5Star/totalPriceValue
            cell.priceRating2Value.progress = self.sellerProfileDetailsViewModel.sellerProfileExtraDetailsData.price4Star == 0.0 ? 0 : (self.sellerProfileDetailsViewModel.sellerProfileExtraDetailsData.price4Star/totalPriceValue)
            cell.priceRating3Value.progress = self.sellerProfileDetailsViewModel.sellerProfileExtraDetailsData.price3Star == 0.0 ? 0 : (self.sellerProfileDetailsViewModel.sellerProfileExtraDetailsData.price3Star/totalPriceValue)
            cell.priceRating4Value.progress = self.sellerProfileDetailsViewModel.sellerProfileExtraDetailsData.price2Star == 0.0 ? 0 : (self.sellerProfileDetailsViewModel.sellerProfileExtraDetailsData.price2Star/totalPriceValue)
            cell.priceRating5Value.progress = self.sellerProfileDetailsViewModel.sellerProfileExtraDetailsData.price1Star == 0.0 ? 0 : (self.sellerProfileDetailsViewModel.sellerProfileExtraDetailsData.price1Star/totalPriceValue)
            cell.avgPriceRatingValue.text = self.sellerProfileDetailsViewModel.sellerProfileExtraDetailsData.averagePriceRating
            cell.avgPriceRatingLabel.text = "averagepricerating".localized
            
            cell.valueRating1Label.text = "5Star".localized + "(" + String(format:"%.0f",self.sellerProfileDetailsViewModel.sellerProfileExtraDetailsData.value5Star) + ")"
            cell.valueRating2Label.text = "4Star".localized + "(" + String(format:"%.0f",self.sellerProfileDetailsViewModel.sellerProfileExtraDetailsData.value4Star) + ")"
            cell.valueRating3Label.text = "3Star".localized + "(" + String(format:"%.0f",self.sellerProfileDetailsViewModel.sellerProfileExtraDetailsData.value3Star) + ")"
            cell.valueRating4Label.text = "2Star".localized + "(" + String(format:"%.0f",self.sellerProfileDetailsViewModel.sellerProfileExtraDetailsData.value2Star) + ")"
            cell.valueRating5Label.text = "1star".localized + "(" + String(format:"%.0f",self.sellerProfileDetailsViewModel.sellerProfileExtraDetailsData.value1Star) + ")"
            
            let totalValue:Float = self.sellerProfileDetailsViewModel.sellerProfileExtraDetailsData.value5Star+self.sellerProfileDetailsViewModel.sellerProfileExtraDetailsData.value4Star+self.sellerProfileDetailsViewModel.sellerProfileExtraDetailsData.value3Star+self.sellerProfileDetailsViewModel.sellerProfileExtraDetailsData.value2Star+self.sellerProfileDetailsViewModel.sellerProfileExtraDetailsData.value1Star
            
            cell.valueRating1LabelValue.progress = self.sellerProfileDetailsViewModel.sellerProfileExtraDetailsData.value5Star == 0.0 ? 0 : self.sellerProfileDetailsViewModel.sellerProfileExtraDetailsData.value5Star/totalValue
            cell.valueRating2LabelValue.progress = self.sellerProfileDetailsViewModel.sellerProfileExtraDetailsData.value4Star == 0.0 ? 0 : (self.sellerProfileDetailsViewModel.sellerProfileExtraDetailsData.value4Star/totalValue)
            cell.valueRating3LabelValue.progress = self.sellerProfileDetailsViewModel.sellerProfileExtraDetailsData.value3Star == 0.0 ? 0 : (self.sellerProfileDetailsViewModel.sellerProfileExtraDetailsData.value3Star/totalValue)
            cell.valueRating4LabelValue.progress = self.sellerProfileDetailsViewModel.sellerProfileExtraDetailsData.value2Star == 0.0 ? 0 : (self.sellerProfileDetailsViewModel.sellerProfileExtraDetailsData.value2Star/totalValue)
            cell.valueRating5LabelValue.progress = self.sellerProfileDetailsViewModel.sellerProfileExtraDetailsData.value1Star == 0.0 ? 0 : (self.sellerProfileDetailsViewModel.sellerProfileExtraDetailsData.value1Star/totalValue)
            cell.avgValueRatingValue.text = self.sellerProfileDetailsViewModel.sellerProfileExtraDetailsData.averageValueRating
            cell.avgValueRatingLabel.text = "averagevaluerating".localized
            
            cell.qualityRating1Label.text = "5Star".localized + "(" + String(format:"%.0f", self.sellerProfileDetailsViewModel.sellerProfileExtraDetailsData.quality5Star) + ")"
            cell.qualityRating2Label.text = "4Star".localized + "(" + String(format:"%.0f", self.sellerProfileDetailsViewModel.sellerProfileExtraDetailsData.quality4Star) + ")"
            cell.qualityRating3Label.text = "3Star".localized + "(" + String(format:"%.0f", self.sellerProfileDetailsViewModel.sellerProfileExtraDetailsData.quality3Star) + ")"
            cell.qualityRating4Label.text = "2Star".localized + "(" + String(format:"%.0f", self.sellerProfileDetailsViewModel.sellerProfileExtraDetailsData.quality2Star) + ")"
            cell.qualityRating5Label.text = "1Star".localized + "(" + String(format:"%.0f", self.sellerProfileDetailsViewModel.sellerProfileExtraDetailsData.quality1Star) + ")"
            
            let totalQualityValue:Float = self.sellerProfileDetailsViewModel.sellerProfileExtraDetailsData.quality5Star+self.sellerProfileDetailsViewModel.sellerProfileExtraDetailsData.quality4Star+self.sellerProfileDetailsViewModel.sellerProfileExtraDetailsData.quality3Star+self.sellerProfileDetailsViewModel.sellerProfileExtraDetailsData.quality2Star+self.sellerProfileDetailsViewModel.sellerProfileExtraDetailsData.quality1Star
            
            
            cell.qualityRating1LabelValue.progress = self.sellerProfileDetailsViewModel.sellerProfileExtraDetailsData.quality5Star == 0.0 ? 0 : self.sellerProfileDetailsViewModel.sellerProfileExtraDetailsData.quality5Star/totalQualityValue
            cell.qualityRating2LabelValue.progress = self.sellerProfileDetailsViewModel.sellerProfileExtraDetailsData.quality4Star == 0.0 ? 0 : (self.sellerProfileDetailsViewModel.sellerProfileExtraDetailsData.quality4Star/totalQualityValue)
            cell.qualityRating3LabelValue.progress = self.sellerProfileDetailsViewModel.sellerProfileExtraDetailsData.quality3Star == 0.0 ? 0 : (self.sellerProfileDetailsViewModel.sellerProfileExtraDetailsData.quality3Star/totalQualityValue)
            cell.qualityRating4LabelValue.progress = self.sellerProfileDetailsViewModel.sellerProfileExtraDetailsData.quality2Star == 0.0 ? 0 : (self.sellerProfileDetailsViewModel.sellerProfileExtraDetailsData.quality2Star/totalQualityValue)
            cell.qualityRating5LabelValue.progress = self.sellerProfileDetailsViewModel.sellerProfileExtraDetailsData.quality1Star == 0.0 ? 0 : (self.sellerProfileDetailsViewModel.sellerProfileExtraDetailsData.quality1Star/totalQualityValue)
            cell.avgQaulityRatingValue.text = self.sellerProfileDetailsViewModel.sellerProfileExtraDetailsData.averageQualityRating
            cell.avgQualityRatingLabel.text = "averagequalityrating".localized
            
            cell.selectionStyle = .none
            return cell
            
        }
        else if indexPath.section == 3{
            let cell = tableView.dequeueReusableCell(withIdentifier: "SellerReviewsCell", for: indexPath) as! SellerReviewsCell
            
            let sellBy = "by"+" "+self.sellerProfileDetailsViewModel.sellerFeedBackList[indexPath.row].name
            let sellOn = "on"+" "+self.sellerProfileDetailsViewModel.sellerFeedBackList[indexPath.row].date
            
            cell.heading.text = sellBy+" "+sellOn
            
            //cell.heading.text = "by"+" "+self.sellerProfileDetailsViewModel.sellerFeedBackList[indexPath.row].name+"  "+"on"+" "+self.sellerProfileDetailsViewModel.sellerFeedBackList[indexPath.row].date
            cell.message.text = self.sellerProfileDetailsViewModel.sellerFeedBackList[indexPath.row].description
            cell.valueRating.text = String(format:"%d",self.sellerProfileDetailsViewModel.sellerFeedBackList[indexPath.row].valuerating)
            cell.priceRating.text = String(format:"%d",self.sellerProfileDetailsViewModel.sellerFeedBackList[indexPath.row].pricerating)
            cell.qualityRating.text = String(format:"%d",self.sellerProfileDetailsViewModel.sellerFeedBackList[indexPath.row].qualityrating)
            
            cell.selectionStyle = .none
            return cell
        }
        else{
            
            let cell = tableView.dequeueReusableCell(withIdentifier: "SellerContactTableViewCell", for: indexPath) as! SellerContactTableViewCell
            cell.delegate = self
            
            cell.selectionStyle = .none
            return cell
        }
    }
    
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if indexPath.section == 0{
            return SCREEN_WIDTH/2 - 50;
        }
        else if indexPath.section == 1{
            return UITableViewAutomaticDimension
        }
        if indexPath.section == 2{
            return 0
        }
        if indexPath.section == 3{
            return 0
        }
        else if indexPath.section == 4 {
            return 0
        }
        else{
            return UITableViewAutomaticDimension
        }
    }
    
}

extension SellerDetailsViewController : sellerProductViewControllerHandlerDelegate {
    
    func productClick(name:String,image:String,id:String){
        let vc = AppStoryboard.Main.instance.instantiateViewController(withIdentifier: "catalogproduct") as! CatalogProduct
        vc.productImageUrl = image
        vc.productName = name
        vc.productId = id
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    func addToWishList(productID:String, index: Int) {
        let customerId = DEFAULTS.object(forKey:"customerId")
        if customerId != nil {
            productId = productID
            wishListItemIndex = index
            whichApiToProcess = "addtowishlist"
            callingExtraHttpApi()
        } else {
            AlertManager.shared.showWarningSnackBar(msg:"loginrequired".localized)
        }
    }
    
    func removedFromWishList(productID:String, index: Int)  {
        let customerId = DEFAULTS.object(forKey:"customerId")
        if customerId != nil {
            self.productId = productID
            wishListItemIndex = index
            whichApiToProcess = "removewishlist"
            callingExtraHttpApi()
        } else {
            AlertManager.shared.showWarningSnackBar(msg: "loginrequired".localized)
        }
    }
    
    func addToCompare(productID:String) {
        self.productId = productID;
        whichApiToProcess = "addtocompare"
        callingExtraHttpApi()
    }
}

extension SellerDetailsViewController : SellerContactControllerHandlerDelegate {
    
    func contactViewClick(value:Int){
        if value == 1{
            message = self.sellerProfileDetailsViewModel.sellerProfileExtraDetailsData.description
            let vc = AppStoryboard.Marketplace.instance.instantiateViewController(withIdentifier: "SellerWebViewController") as! SellerWebViewController
            vc.message = self.message
            self.navigationController?.pushViewController(vc, animated: true)
        }else if value == 2{
            message = self.sellerProfileDetailsViewModel.sellerProfileExtraDetailsData.shippingPolicy
            let vc = AppStoryboard.Marketplace.instance.instantiateViewController(withIdentifier: "SellerWebViewController") as! SellerWebViewController
            vc.message = self.message
            self.navigationController?.pushViewController(vc, animated: true)
        }else if value == 4{
            message = self.sellerProfileDetailsViewModel.sellerProfileExtraDetailsData.returnPolicy
            let vc = AppStoryboard.Marketplace.instance.instantiateViewController(withIdentifier: "SellerWebViewController") as! SellerWebViewController
            vc.message = self.message
            self.navigationController?.pushViewController(vc, animated: true)
        } else if value == 3 {
            let vc = AppStoryboard.Marketplace.instance.instantiateViewController(withIdentifier: "SellerReviewsController") as! SellerReviewsController
            vc.sellerId = self.profileUrl
            self.navigationController?.pushViewController(vc, animated: true)
        } else if value == 6 {
            let vc = AppStoryboard.Marketplace.instance.instantiateViewController(withIdentifier: "ContactUs") as! ContactUs
            vc.sellerId = self.profileUrl
            vc.productId = "0"
            self.navigationController?.pushViewController(vc, animated: true)
        }else if value == 5{
            let vc = AppStoryboard.Marketplace.instance.instantiateViewController(withIdentifier: "GoogleMap") as! GoogleMap
            vc.countryName = self.sellerProfileDetailsViewModel.sellerProfileExtraDetailsData.location
            self.navigationController?.pushViewController(vc, animated: true)
        }
    }
}
