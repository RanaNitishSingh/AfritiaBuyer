//
//  CatalogProduct.swift
//  Magento2MobikulNew
//
//  Created by Webkul  on 10/08/17.
//  Copyright © 2017 Webkul . All rights reserved.
//

import UIKit
import CoreData
import MobileCoreServices
import Alamofire
import Kingfisher
import WebKit
import UIFloatLabelTextField
import HCSStarRatingView
import Foundation

class CatalogProduct: AfritiaBaseViewController {
    
    @IBOutlet weak var afritiaNavBarView: AFNavigationBarView!
    @IBOutlet weak var afritiaNavBarViewHeight:NSLayoutConstraint!
    
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var mainView: UIView!
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var collectionViewContainerHeightConstarints: NSLayoutConstraint!
    @IBOutlet weak var collectionViewHeightConstarints: NSLayoutConstraint!
    @IBOutlet weak var addToCartIndicator: UIActivityIndicatorView!
    @IBOutlet weak var productNameLabel: UILabel!
    @IBOutlet weak var productpriceLabel: UILabel!
    @IBOutlet weak var pageControl: UIPageControl!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    @IBOutlet weak var productRating: HCSStarRatingView!
    @IBOutlet weak var productRatingVal: UILabel!
    @IBOutlet weak var productRatingCountVal: UILabel!
    @IBOutlet weak var stockLabelValue: UILabel!
    @IBOutlet weak var writeYourReviewButton: UIButton!
    @IBOutlet weak var quantityLabel: UILabel!
    @IBOutlet weak var addToCartButton: UIButton!
    @IBOutlet weak var goToBagButton: UIButton!
    @IBOutlet weak var quantitytextField: UITextField!
    //customizable/bundle/download/group view
    @IBOutlet weak var otherView: UIView!
    @IBOutlet weak var otherViewHeightCOnstarints: NSLayoutConstraint!
    
    @IBOutlet weak var likeShareBgView: UIView!
    
    //configurableView
    @IBOutlet weak var dynamicView: UIView!
    @IBOutlet weak var dynamicViewHeightCOnstarints: NSLayoutConstraint!
    @IBOutlet weak var addToCartView: UIView!
    @IBOutlet weak var stepperButton: UIStepper!
    //@IBOutlet weak var descriptionLabel: UILabel!
    //@IBOutlet weak var descriptionImageView: UIImageView!
    //@IBOutlet weak var featureLabel: UILabel!
    //@IBOutlet weak var featureImageView: UIImageView!
    @IBOutlet weak var totalReviews: UILabel!
    //@IBOutlet weak var descriptionView: UIView!
    //@IBOutlet weak var featureView: UIView!
    @IBOutlet weak var specialPrice: UILabel!
    @IBOutlet weak var wishlistBtn: UIButton!
    @IBOutlet weak var shareBtn: UIButton!
    @IBOutlet weak var compareButton: UIButton!
    @IBOutlet weak var similarBtn: UIButton!
    //@IBOutlet weak var ratingReviewView: UIView!
    //@IBOutlet weak var ratingView: UIView!
    @IBOutlet weak var tierPrices: UILabel!
    @IBOutlet weak var descWebView : WKWebView!
    @IBOutlet weak var descTextView : UITextView!
    @IBOutlet weak var descWebViewHeightConstarints: NSLayoutConstraint!
    
    @IBOutlet weak var aditionalFeatureView : UIView!
    @IBOutlet weak var aditionalFeatureViewHeightConstarints: NSLayoutConstraint!
    @IBOutlet weak var aditionfeatureLabel: UILabel!
    @IBOutlet weak var aditionfeatureLineLabel: UILabel!
    
    @IBOutlet weak var recentView : UIView!
    @IBOutlet weak var recentProdCollectionView: UICollectionView!
    @IBOutlet weak var recentContainerViewHeightConstarints: NSLayoutConstraint!
    @IBOutlet weak var recentCollViewHeightConstarints: NSLayoutConstraint!
    @IBOutlet weak var recentProductLabel: UILabel!
    
    //recent view widget
    //var isShowRecentWidget = true
    var recentViewCellWidth:CGFloat = 0
    var recentViewCellHeight:CGFloat = 0
    var recentViewProducModel = [Productcollection]()
    
    //Market Place
    @IBOutlet weak var marketPlaceView: UIView!
    @IBOutlet weak var marketplaceHeightConstarints: NSLayoutConstraint!
    @IBOutlet weak var sellerNameButton: UIButton!
    @IBOutlet weak var ratingValue: UILabel!
    @IBOutlet weak var message: UILabel!
    @IBOutlet weak var label1: UILabel!
    @IBOutlet weak var rating1: HCSStarRatingView!
    @IBOutlet weak var label2: UILabel!
    @IBOutlet weak var rating2: HCSStarRatingView!
    @IBOutlet weak var label3: UILabel!
    @IBOutlet weak var rating3: HCSStarRatingView!
    @IBOutlet weak var contactUsButton: UIButton!
    
    @IBOutlet weak var shippinglabel: UILabel!
    @IBOutlet weak var ratingCountView: UIView! // not in use by default hidden
    
    
    var catalogProductViewModel:CatalogProductViewModel!
    var productId:String = ""
    var productName:String = ""
    var productImageUrl:String = ""
    let defaults = UserDefaults.standard
    var imageArrayUrl:Array = [String]()
    var isVideo:Array = [Bool]() //stores the value parallel to the imageArrayUrl , for video it will be true and for image false
    var configjson:JSON!
    var groupjson:JSON!
    var linkJson:JSON!
    var bundleJson:JSON!
    var customeJson:JSON!
    
    var mainContainerY :CGFloat = 0
    var bundleCount:Int = 0
    var selectedDownloadableProduct = [String:String]()
    var selectedGroupedProduct = [String:String]()
    var bundlePickerIndex :Int!
    var bundleDisplayData = [Int:NSMutableArray]()
    var bundleSelectedDataWishList = [String:String]()
    var selectedBundleProductQuantity = [String:String]()
    var bundleSelectedData = [String:AnyObject]()
    var customeCollectionDisplayData = [Int:NSMutableArray]()
    var customePickerIndex:Int!
    var selectedCustomeOption = [String:AnyObject]()
    var selectedCustomeOptionWishList = [String:String]()
    var customePickerKeyValue = [Int:NSMutableArray]()
    var timeDict = [String:String]()
    var dateTimeDict = [String:String]()
    var dateDict = [String:String]()
    var childZoomingScrollView, parentZoomingScrollView :UIScrollView!
    var imageview,imageZoom : UIImageView!
    var currentTag:NSInteger = 0
    var pager:UIPageControl!
    var addToCartFrameY:CGFloat = 0
    var customOptionFileDict = [String:Data]()
    var customOptionFileEntry = [String:Bool]()
    var MIMETYPE = [String:String]()
    var keyBoardFlag:Int = 1
    var configurableSelectedData = [String:String]()
    var configurableRelatedProducts = [Int:NSArray]()
    var configurableData = [Int:NSMutableArray]()
    var pickerIndex:Int = 0
    var defaultLaunch:Bool = true
    var goToBagFlag:Bool = false
    var headers: HTTPHeaders = [:]
    var configurableDataImages = [String:Any]()
    var configurableDataIndex : AnyObject!
    var fromVC : String = ""
    var zoomImgVC = ZoomImageViewController()
    var selectedLabelTag : Int = 0
    
    var customOptionInternalY: CGFloat = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.setUpCustomNavigationBar()
        
        otherViewHeightCOnstarints.constant = 0
        dynamicViewHeightCOnstarints.constant = 0
        //ratingReviewView.isHidden = true
        //ratingCountView.isHidden = true
        //ratingCountViewHeightCOnstarints.constant = 0
        
        self.collectionView.register(CatalogProductImage.nib, forCellWithReuseIdentifier: CatalogProductImage.identifier)
        self.collectionView.register(CatalogProductVideo.nib, forCellWithReuseIdentifier: CatalogProductVideo.identifier)
        
        self.recentProdCollectionView.register(UINib(nibName: "ProductImageCell", bundle: nil), forCellWithReuseIdentifier: "productimagecell")
        
        scrollView.delegate = self
        collectionViewContainerHeightConstarints.constant = SCREEN_HEIGHT/2 + 16
        collectionViewHeightConstarints.constant = (collectionViewContainerHeightConstarints.constant - 10)
        collectionView.reloadData()
        
        dynamicView.backgroundColor = UIColor.DarkLavendar
        //otherView.backgroundColor = UIColor.appGreen
        
        self.setUpAndDisplayRecentViewedProductWidget(isShowRecentWidget:true)

        imageArrayUrl = [productImageUrl]
        isVideo.removeAll()
        for i in 0..<imageArrayUrl.count{
            isVideo.append(false)
            print(i)
        }
        
        productNameLabel.text = productName
        productNameLabel.font = UIFont.systemFont(ofSize:16, weight:.semibold)
        
        likeShareBgView.layer.cornerRadius = 5
        
        APIServiceManager.shared.removePreviousNetworkCall()
        GlobalData.sharedInstance.dismissLoader()
        callingHttppApi(apiType: CatalogProductAPI.catalogProduct)
        
        //description and feature custom button view
       
        //localise strings
        localisePage()
        
        productRating.tintColor = UIColor.appStarColor
        specialPrice.isHidden = true
        stepperButton.tintColor = UIColor.appStarColor
        
        //ratingReviewView.layer.borderColor = UIColor.lightGray.cgColor
        //.layer.borderWidth = 1.0
        
        addToCartView.backgroundColor = UIColor.white
        addToCartButton.applyAfritiaTheme()
        goToBagButton.applyAfritiaTheme()
        
    }
    
    fileprivate func setUpCustomNavigationBar(){
        
        self.navigationController?.isNavigationBarHidden = true
        self.tabBarController!.tabBar.applyAfritiaTheme()
        
        self.changeStatusBarColor(color: UIColor.LightLavendar)
        
       // afritiaNavBarView.configureTitleView(isVisible:true, titleType:.image, title:nil, image:navIcon.appLogo)
        /*
        afritiaNavBarView.configureLeftButton1(isVisible:true, btnTitle:"Back", btnImage:UIImage(named:"nav_icon_back")) { (btnTitle) in
            AlertManager.shared.showInfoSnackBar(msg:"Navigation Back tapped Now : \(btnTitle)")
        }*/
        
        afritiaNavBarView.configureLeftButton1(isVisible:true, btnType:.image, btnTitle:nil, btnImage:navIcon.back) { (btnTitle) in
            self.navigationController?.popViewController(animated:true)
        }
        afritiaNavBarView.configureLeftButton2(isVisible:false, btnType:.none, btnTitle:nil, btnImage:nil, actionHandler:nil)
        
        afritiaNavBarView.configureRightButton1(isVisible:true, btnType:.image, btnTitle:nil, btnImage:navIcon.cart) { (btnTitle) in
            self.showMyCart()
        }
        afritiaNavBarView.configureRightButton2(isVisible:false, btnType:.none, btnTitle:nil, btnImage:nil, actionHandler:nil)

        afritiaNavBarView.configure(isVisible:true, titleText:nil, titleType:.image, barStyle:.full) { (searchBy) in
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
    
    func setUpAndDisplayRecentViewedProductWidget(isShowRecentWidget:Bool){
        
        //get all recently view product from db
        let productModel = ProductViewModel()
        let recentViewdProduct = productModel.getProductDataFromDB()
         print(recentViewdProduct)
        
        recentView.backgroundColor = UIColor.white
        recentProductLabel.isHidden = false
        recentProductLabel.applyAfritiaBorederTheme(cornerRadius:2)
        recentProductLabel.backgroundColor = UIColor.DimLavendar
        
        if recentViewdProduct.count > 0 && isShowRecentWidget == true {
            
            recentViewProducModel = recentViewdProduct
            recentProdCollectionView.isHidden = false
            recentContainerViewHeightConstarints.constant = (SCREEN_HEIGHT/3) + 40
            recentProdCollectionView.backgroundColor = UIColor.white
            
            recentCollViewHeightConstarints.constant = recentContainerViewHeightConstarints.constant-40
            recentViewCellHeight = recentCollViewHeightConstarints.constant
            recentViewCellWidth = (SCREEN_WIDTH/2) - 40
            
            let layout = UPCarouselFlowLayout()
            layout.itemSize = CGSize(width:recentViewCellWidth, height:recentViewCellHeight)
            layout.scrollDirection = .horizontal
            layout.sideItemAlpha = 1.0
            layout.sideItemScale = 1.0
            //layout.sideItemShift = 0.5
            //layout.spacingMode = UPCarouselFlowLayoutSpacingMode.overlap(visibleOffset: 30)
            layout.spacingMode = .fixed(spacing:5)
            layout.offsetMode = .leading
            
            recentProdCollectionView.collectionViewLayout = layout
            recentProdCollectionView.delegate = self
            recentProdCollectionView.dataSource = self
            recentProdCollectionView.reloadData()
            
        }
        else
        {
            recentContainerViewHeightConstarints.constant = 0
            recentProdCollectionView.isHidden = true
            recentProductLabel.isHidden = true
        }

        print(recentViewProducModel.count)
    }
    
    
    func setUpDescriptionAndFeatureCustomButton(){
        /*
        descriptionView.backgroundColor = UIColor.appSuperLightGrey
        descriptionView.setCornerRadius(radius:5)
        descriptionView.layer.borderColor = UIColor.appLightGrey.cgColor
        descriptionView.layer.borderWidth = 0.5
        descriptionLabel.textColor = UIColor.appLightGrey
        descriptionImageView.image = #imageLiteral(resourceName: "ic_arrow").flipImage()
        
        featureView.backgroundColor = UIColor.appSuperLightGrey
        featureView.setCornerRadius(radius: 5)
        featureView.layer.borderColor = UIColor.appLightGrey.cgColor
        featureView.layer.borderWidth = 0.5
        featureLabel.textColor = UIColor.appLightGrey
        featureImageView.image = #imageLiteral(resourceName: "ic_arrow").flipImage()
        
        descriptionLabel.text = "description".localized
        featureLabel.text = "feature".localized
        */
    }
    
    override func viewWillAppear(_ animated: Bool) {
        
        /*
        self.navigationController?.isNavigationBarHidden = false
        self.navigationController?.navigationBar.applyAfritiaTheme()
        self.navigationItem.title = productName
        */
        
        self.tabBarController?.tabBar.isHidden = true
        //self.navigationController?.setNavigationBarHidden(false, animated: true)
        self.navigationController?.interactivePopGestureRecognizer?.isEnabled = false
        
        if self.isMovingToParentViewController{
            print("4nd pushed")
        }else{
            print("clear all previous")
            GlobalData.sharedInstance.dismissLoader()
        }
        quantitytextField.applyAfritiaTheme()
        //quantitytextField.layer.cornerRadius = 8
        //quantitytextField.layer.borderColor = UIColor.DarkLavendar.cgColor
        //quantitytextField.layer.borderWidth = 1
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        self.tabBarController?.tabBar.isHidden = false
    }
    
    override func willMove(toParentViewController parent: UIViewController?) {
        super.willMove(toParentViewController: parent)
        APIServiceManager.shared.removePreviousNetworkCall()
        GlobalData.sharedInstance.dismissLoader()
    }
    
    //MARK:- User defined func
    func localisePage() {
        addToCartButton.setTitle(" Add To Cart".localized, for: .normal)
        goToBagButton.setTitle("buynow".localized, for: .normal)
        writeYourReviewButton.setTitle("Write a Review", for: .normal)
        quantityLabel.text = "quantity".localized
    }
    
    //for getting the JSON data in string form
    func jsonSerializationData(jsonObj : Any) -> String {
        do {
            let jsonData =  try JSONSerialization.data(withJSONObject: jsonObj, options: .prettyPrinted)
            let jsonString:String = NSString(data: jsonData, encoding: String.Encoding.utf8.rawValue)! as String
            return jsonString
        }catch {
            print(error.localizedDescription)
        }
        return ""
    }
    
    func getDataFromUrl(url: URL, completion: @escaping (_ data: Data?, _  response: URLResponse?, _ error: Error?) -> Void) {
        URLSession.shared.dataTask(with: url) {
            (data, response, error) in
            completion(data, response, error)
            }.resume()
    }
    
    
    //MARK:- Call API
    
    func callingHttppApi(apiType : CatalogProductAPI)  {
        
        self.view.isUserInteractionEnabled = false
        var requstParams = [String:Any]()
        requstParams["storeId"] = defaults.object(forKey:"storeId") as! String
        let customerId = defaults.object(forKey: "customerId")
        let quoteId = defaults.object(forKey: "quoteId")
        requstParams["productId"] = productId
        
        if customerId != nil{
            requstParams["customerToken"] = customerId
        }
        if quoteId != nil{
            requstParams["quoteId"] = quoteId
        }
        if defaults.object(forKey: "currency") != nil{
            requstParams["currency"] = defaults.object(forKey: "currency") as! String
        }
        
        switch apiType {
        
        case .addToCart :
            GlobalData.sharedInstance.showLoader()
            var params = [String: AnyObject]()
            
            if(self.configjson["configurableData"]["attributes"].count > 0){
                params["super_attribute"] = configurableSelectedData as AnyObject?
                requstParams["params"] = jsonSerializationData(jsonObj: params)
            }
            
            if(self.groupjson["groupedData"].count > 0){
                params["super_group"] = selectedGroupedProduct as AnyObject?
                requstParams["params"] = jsonSerializationData(jsonObj: params)
            }
            
            if (self.linkJson["links"]["linksPurchasedSeparately"].string == "1") {
                params["links"] = selectedDownloadableProduct as AnyObject?
                requstParams["params"] = jsonSerializationData(jsonObj: params)
            }
            
            if(self.bundleJson["bundleOptions"].count > 0){
                params["bundle_option"] = bundleSelectedData as AnyObject?
                params["bundle_option_qty"] = selectedBundleProductQuantity as AnyObject?
                requstParams["params"] = jsonSerializationData(jsonObj: params)
            }
            
            if(self.customeJson["customOptions"].count > 0){
                params["options"] = selectedCustomeOption as AnyObject
                requstParams["params"] = jsonSerializationData(jsonObj: params)
            }
            
            requstParams["qty"] = quantitytextField.text
            
            APIServiceManager.shared.callingHttpRequest(params:requstParams, apiname:AfritiaAPI.addToCart, currentView: self){success,responseObject in
                if success == 1{
                    self.view.isUserInteractionEnabled = true
                    //self.addToCartIndicator.stopAnimating()
                    let data = responseObject as! NSDictionary
                    let errorCode: Bool = data .object(forKey:"success") as! Bool
                    
                    if data.object(forKey: "quoteId") != nil{
                        let quoteId:String = String(format: "%@", data.object(forKey: "quoteId") as! CVarArg)
                        if quoteId != "0"{
                            self.defaults .set(quoteId, forKey: "quoteId")
                        }
                    }
                    
                    GlobalData.sharedInstance.dismissLoader()
                    if errorCode == true{
                        AlertManager.shared.showSuccessSnackBar(msg:data .object(forKey:"message") as! String )
                        GlobalData.sharedInstance.cartItemsCount = data.object(forKey: "cartCount") as! Int
                        //self.tabBarController!.tabBar.items?[3].badgeValue = String(data.object(forKey: "cartCount") as! Int)
                        //self.navigationItem.prompt = String(data.object(forKey: "cartCount") as! Int)+" "+GlobalData.sharedInstance.language(key: "itemsincart")
                        
                        if self.goToBagFlag == true{
                            if self.fromVC == "mycart"   {
                                self.navigationController?.popViewController(animated: true)
                            }else{
                                self.tabBarController!.selectedIndex = 3
                            }
                        }
                    }else{
                        AlertManager.shared.showErrorSnackBar(msg: data.object(forKey: "message") as! String)
                    }
                    
                    print(data)
                    
                }else if success == 2{
                    GlobalData.sharedInstance.dismissLoader()
                    self.callingHttppApi(apiType: apiType)
                }
            }
            
        case .addToCompare:
            APIServiceManager.shared.callingHttpRequest(params:requstParams, apiname:AfritiaAPI.addToCompare, currentView: self){success,responseObject in
                if success == 1{
                    if responseObject?.object(forKey: "storeId") != nil{
                        
                        let storeId:String = String(format: "%@", responseObject?.object(forKey: "storeId") as! CVarArg)
                        
                        //let storeId:String = String(format: "%@", responseObject?.object(forKey: "storeId") as! CVarArg)
                        if storeId != "0"{
                            self.defaults .set(storeId, forKey: "storeId")
                        }
                    }
                    
                    GlobalData.sharedInstance.dismissLoader()
                    self.view.isUserInteractionEnabled = true
                    let data = responseObject as! NSDictionary
                    let errorCode: Bool = data .object(forKey:"success") as! Bool
                    
                    if errorCode == true{
                        AlertManager.shared.showSuccessSnackBar(msg:data.object(forKey: "message") as! String)
                    }else{
                        AlertManager.shared.showErrorSnackBar(msg:data.object(forKey: "message") as! String)
                    }
                }else if success == 2{
                    GlobalData.sharedInstance.dismissLoader()
                    self.callingHttppApi(apiType: apiType)
                }
            }
            
        case .addToWishlist:
            //add to wish list
            if(self.groupjson["groupedData"].count > 0){
                do {
                    let jsonData =  try JSONSerialization.data(withJSONObject: selectedGroupedProduct, options: .prettyPrinted)
                    let jsonString:String = NSString(data: jsonData, encoding: String.Encoding.utf8.rawValue)! as String
                    requstParams["super_group"] = jsonString
                    
                }
                catch {
                    print(error.localizedDescription)
                }
            }
            // download data
            if (self.linkJson["links"]["linksPurchasedSeparately"].string == "1") {
                let data = NSMutableArray();
                for value in selectedDownloadableProduct{
                    if(value.value   != ""){
                        data.add(value.value)
                    }
                }
                if(data.count>0){
                    do {
                        let jsonData =  try JSONSerialization.data(withJSONObject: data, options: .prettyPrinted)
                        let jsonString:String = NSString(data: jsonData, encoding: String.Encoding.utf8.rawValue)! as String
                        requstParams["links"] = jsonString
                    }
                    catch {
                        print(error.localizedDescription)
                    }}
            }
            
            /////// custome data
            if(self.customeJson["customOptions"].count > 0){
                do {
                    let jsonData =  try JSONSerialization.data(withJSONObject: selectedCustomeOption, options: .prettyPrinted)
                    let jsonString:String = NSString(data: jsonData, encoding: String.Encoding.utf8.rawValue)! as String
                    
                    requstParams["options"] = jsonString
                }
                catch {
                    print(error.localizedDescription)
                }
                
            }
            /// bunlde option
            if(self.bundleJson["bundleOptions"].count > 0){
                do {
                    let jsonData1 =  try JSONSerialization.data(withJSONObject: bundleSelectedDataWishList, options: .prettyPrinted)
                    let jsonString1:String = NSString(data: jsonData1, encoding: String.Encoding.utf8.rawValue)! as String
                    requstParams["bundle_option"] = jsonString1
                    
                    let jsonData2 =  try JSONSerialization.data(withJSONObject: selectedBundleProductQuantity, options: .prettyPrinted)
                    let jsonString2:String = NSString(data: jsonData2, encoding: String.Encoding.utf8.rawValue)! as String
                    requstParams["bundle_option_qty"] = jsonString2
                }
                catch {
                    print(error.localizedDescription)
                }
            }
            
            requstParams["qty"] = quantitytextField.text
            GlobalData.sharedInstance.showLoader()
            APIServiceManager.shared.callingHttpRequest(params:requstParams, apiname:AfritiaAPI.addToWishlist, currentView: self){success,responseObject in
                if success == 1{
                    self.view.isUserInteractionEnabled = true
                    GlobalData.sharedInstance.dismissLoader()
                    let data = responseObject as! NSDictionary
                    let errorCode: Bool = data .object(forKey:"success") as! Bool
                    
                    if errorCode == true{
                        AlertManager.shared.showSuccessSnackBar(msg: GlobalData.sharedInstance.language(key:"movedtowishlist".localized))
                        self.catalogProductViewModel.catalogProductModel.isInWishList = true
                        self.catalogProductViewModel.catalogProductModel.wishlistItemId = String(data.object(forKey:"itemId") as! Int)
                        
                        self.wishlistBtn.setImage(#imageLiteral(resourceName: "ic_wishlist_fill"), for: .normal)
                        
                        NotificationCenter.default.post(name: NSNotification.Name(rawValue: "refreshHomeView"), object: nil, userInfo: [:])
                        self.tabBarController?.tabBar.isHidden = true
                    }else{
                        AlertManager.shared.showErrorSnackBar(msg: GlobalData.sharedInstance.language(key:"notmovedtowishlist".localized))
                    }
                    
                    print(responseObject!)
                    
                }else if success == 2{
                    GlobalData.sharedInstance.dismissLoader()
                    self.callingHttppApi(apiType: apiType)
                }
            }
            
        case .removeFromWishList:
            GlobalData.sharedInstance.showLoader()
            self.view.isUserInteractionEnabled = false
            var requstParams = [String:Any]()
            requstParams["customerToken"] = defaults.object(forKey:"customerId") as! String
            requstParams["itemId"] = self.catalogProductViewModel.catalogProductModel.wishlistItemId
            requstParams["storeId"] = defaults.object(forKey:"storeId") as! String
            
            APIServiceManager.shared.callingHttpRequest(params:requstParams, apiname:AfritiaAPI.removeFromWishList, currentView: self){success,responseObject in
                if success == 1{
                    self.view.isUserInteractionEnabled = true
                    GlobalData.sharedInstance.dismissLoader()
                    print(responseObject!)
                    self.view.isUserInteractionEnabled = true
                    
                    let data = responseObject as! NSDictionary
                    let errorCode: Bool = data .object(forKey:"success") as! Bool
                    
                    if errorCode == true{
                        AlertManager.shared.showSuccessSnackBar(msg:GlobalData.sharedInstance.language(key: "successwishlistremove"))
                        
                        self.catalogProductViewModel.catalogProductModel.isInWishList = false
                        self.catalogProductViewModel.catalogProductModel.wishlistItemId = "0"
                        
                        self.wishlistBtn.setImage(#imageLiteral(resourceName: "ic_wishlist_empty"), for: .normal)
                        
                        NotificationCenter.default.post(name: NSNotification.Name(rawValue: "refreshHomeView"), object: nil, userInfo: [:])
                        self.tabBarController?.tabBar.isHidden = true
                    }else{
                        AlertManager.shared.showErrorSnackBar(msg:GlobalData.sharedInstance.language(key: "errorwishlist"))
                    }
                }else if success == 2{
                    self.callingHttppApi(apiType: apiType)
                    GlobalData.sharedInstance.dismissLoader()
                }
            }
            
        case .catalogProduct:
            
            let width = String(format:"%f", SCREEN_WIDTH * UIScreen.main.scale)
            requstParams["width"] = width
            let apiName1 = AfritiaAPI.productPageData + "/productId=" + productId
            print(apiName1)
            APIServiceManager.shared.callingHttpRequest(params:requstParams, apiname:AfritiaAPI.productPageData, currentView: self){success,responseObject in
                if success == 1{
                    self.view.isUserInteractionEnabled = true
                    print("ppp = ",apiName1)
                    print("Catalog Product Detail \(responseObject!)")
                    
                    let data = JSON(responseObject as! NSDictionary)
                    var ProductDict = [String: Any]()
                    ProductDict["name"] = data["name"].stringValue
                    ProductDict["ProductID"] = data["id"].stringValue
                    ProductDict["image"] = data["imageGallery"].arrayValue.count>0 ? data["imageGallery"].arrayValue[0]["largeImage"].stringValue:"a.jpeg"
                    ProductDict["price"] = data["price"].stringValue
                    ProductDict["DateTime"] = String(describing: Date())
                    ProductDict["isInWishlist"] = data["isInWishlist"].stringValue
                    ProductDict["isInRange"] = data["isInRange"].stringValue
                    ProductDict["specialPrice"] = data["specialPrice"].stringValue
                    ProductDict["originalPrice"] = data["price"].stringValue
                    ProductDict["showSpecialPrice"] = data["formatedFinalPrice"].stringValue
                    ProductDict["formatedPrice"] = data["formatedPrice"].stringValue
                    
                    if let bundleOptions = data["bundleOptions"].arrayObject, bundleOptions.count > 0   {
                        ProductDict["formatedMinPrice"] = data["formatedMinPrice"].stringValue
                        ProductDict["formatedMaxPrice"] = data["formatedMaxPrice"].stringValue
                        ProductDict["isBundle"] = "1"
                    }else{
                        ProductDict["formatedMinPrice"] = "0"
                        ProductDict["formatedMaxPrice"] = "0"
                        ProductDict["isBundle"] = "0"
                    }
                    
                     ProductDict["isFreeshipping"] = data["isFreeshipping"].stringValue
                     ProductDict["shippingPrice"] = data["shippingPrice"].stringValue
                    
                    let productModel = ProductViewModel(data: JSON(ProductDict))
                    NotificationCenter.default.post(name: NSNotification.Name(rawValue: "refreshRecentView"), object: nil)
                    print(productModel.getProductDataFromDB())
                    
                    
                    self.catalogProductViewModel = CatalogProductViewModel(data:JSON(responseObject as! NSDictionary))
                    print(responseObject as! NSDictionary)
                    self.doFurtherProcessingWithResult()
                    self.addArProduct()
                }else if success == 2{
                    GlobalData.sharedInstance.dismissLoader()
                    self.callingHttppApi(apiType: apiType)
                }
            }

            print()
        }
    }
    
    func addProductToCart()    {
//
//        if defaults.object(forKey: "authKey") == nil{
//            headers = [
//                "apiKey": API_USER_NAME,
//                "apiPassword": API_KEY,
//                "authKey":""
//            ]
//        }
//        else{
//            headers = [
//                "apiKey": API_USER_NAME,
//                "apiPassword": API_KEY,
//                "authKey":defaults.object(forKey: "authKey") as! String
//            ]
//        }
//        let textValue =  self.quantitytextField.text ?? ""
//        /*
//        DispatchQueue.main.async {
//
//        }*/
//
//        GlobalData.sharedInstance.showLoader()
//        AF.upload(multipartFormData: { multipartFormData in
//            var requstParams = [String:AnyObject]()
//            requstParams["storeId"] = self.defaults.object(forKey:"storeId") as! String as AnyObject
//            let customerId = self.defaults.object(forKey: "customerId")
//            let quoteId = self.defaults.object(forKey: "quoteId")
//            requstParams["productId"] = self.productId as AnyObject
//            if customerId != nil{
//                requstParams["customerToken"] = customerId as AnyObject
//            }
//            if quoteId != nil{
//                requstParams["quoteId"] = quoteId as AnyObject
//            }
//
//            var params = [String: AnyObject]()
//
//            if(self.configjson["configurableData"]["attributes"].count > 0){
//                params["super_attribute"] = self.configurableSelectedData as AnyObject?
//                requstParams["params"] = self.jsonSerializationData(jsonObj: params) as AnyObject
//            }
//
//            if(self.groupjson["groupedData"].count > 0){
//                params["super_group"] = self.selectedGroupedProduct as AnyObject?
//                requstParams["params"] = self.jsonSerializationData(jsonObj: params) as AnyObject
//            }
//
//            if (self.linkJson["links"]["linksPurchasedSeparately"].string == "1") {
//                params["links"] = self.selectedDownloadableProduct as AnyObject?
//                requstParams["params"] = self.jsonSerializationData(jsonObj: params) as AnyObject
//            }
//
//            if(self.bundleJson["bundleOptions"].count > 0){
//                params["bundle_option"] = self.bundleSelectedData as AnyObject?
//                params["bundle_option_qty"] = self.selectedBundleProductQuantity as AnyObject?
//                requstParams["params"] = self.jsonSerializationData(jsonObj: params) as AnyObject
//            }
//
//            if(self.customeJson["customOptions"].count > 0){
//                params["options"] = self.selectedCustomeOption as AnyObject?
//                requstParams["params"] = self.jsonSerializationData(jsonObj: params) as AnyObject
//            }
//
//            requstParams["qty"] = textValue as AnyObject//self.quantitytextField.text as AnyObject
//
//            for (key, value) in requstParams {
//                if let data = value.data(using: String.Encoding.utf8.rawValue) {
//                    multipartFormData.append(data, withName: key)
//                }
//            }
//
//            for (key,value) in self.customOptionFileEntry{
//                if value == true{
//                    let type:String = self.MIMETYPE[key]!
//                    let weatherData = self.customOptionFileDict[key]
//                    let fileName = "options_"+key+"_file"
//                    multipartFormData.append(weatherData!, withName: fileName, fileName: "file."+type, mimeType: type)
//                }
//            }
//
//            print("aaa", requstParams)
//
//        },
//        to: HOST_NAME+AfritiaAPI.addToCart,method:HTTPMethod.post,
//                         headers:self.headers, encodingCompletion: { encodingResult in
//                            GlobalData.sharedInstance.dismissLoader()
//
//                            DispatchQueue.main.async {
//                                switch encodingResult {
//                                case .success(let upload, _, _):
//                                    upload
//                                        .validate()
//                                        .responseJSON { response in
//                                            switch response.result {
//                                            case .success(let value):
//                                                print("responseObject: \(value)")
//                                                let dict = JSON(value)
//
//                                                //self.view.isUserInteractionEnabled = true
//                                                //self.addToCartIndicator.stopAnimating()
//
//                                                let errorCode: Bool = dict["success"].boolValue
//
//                                                if dict["quoteId"].stringValue != ""{
//                                                    let quoteId:String = String(format: "%@", dict["quoteId"].stringValue)
//                                                    if quoteId != "0"{
//                                                        self.defaults .set(quoteId, forKey: "quoteId")
//                                                    }
//                                                }
//
//                                                if errorCode == true
//                                                {
//                                                    AlertManager.shared.showSuccessSnackBar(msg:dict["message"].stringValue)
//                                                    GlobalData.sharedInstance.cartItemsCount = Int(dict["cartCount"].stringValue)!
//                                                    //self.tabBarController!.tabBar.items?[3].badgeValue = dict["cartCount"].stringValue
//
//                                                    if self.goToBagFlag == true{
//                                                        if self.fromVC == "mycart"   {
//                                                            self.navigationController?.popViewController(animated: true)
//                                                        }else{
//                                                            self.tabBarController!.selectedIndex = 3
//                                                        }
//                                                    }
//                                                }
//                                                else{
//                                                    AlertManager.shared.showErrorSnackBar(msg:dict["message"].stringValue)
//                                                }
//
//                                            case .failure(let responseError):
//                                                AlertManager.shared.showErrorSnackBar(msg: "Not updated")
//                                                print("responseError: \(responseError)")
//                                            }
//                                    }
//                                case .failure(let encodingError):
//                                    print("encodingError: \(encodingError)")
//                                }
//                            }
//        })
    }
    
    func doFurtherProcessingWithResult(){
        
        // produuct collection image view
        imageArrayUrl = catalogProductViewModel.getBannerImageUrl
        isVideo.removeAll()
        for i in 0..<imageArrayUrl.count{
            if imageArrayUrl[i].contains("www.youtube.com") {
                isVideo.append(true)
            }else{
                isVideo.append(false)
            }
        }
        collectionView.reloadData()
        pageControl.numberOfPages = imageArrayUrl.count
        
        //wishlist icon
        if self.catalogProductViewModel.catalogProductModel.isInWishList    {
            wishlistBtn.setImage(#imageLiteral(resourceName: "ic_wishlist_fill"), for: .normal)
        }else{
            wishlistBtn.setImage(#imageLiteral(resourceName: "ic_wishlist_empty"), for: .normal)
        }
        
        //product title and price and free shiping info
        stockLabelValue.text = catalogProductViewModel.catalogProductModel.stockMessage
        stockLabelValue.font = UIFont.systemFont(ofSize:14, weight:.semibold)
        //self.mainViewHeightConstarints.constant = 650 + SCREEN_HEIGHT/2
        
        if catalogProductViewModel.catalogProductModel.isFreeshipping == "Yes"{
            self.shippinglabel.text = "freeshipping".localized
        }else{
            self.shippinglabel.text = "shippingword".localized + ": \(catalogProductViewModel.catalogProductModel.shippingPrice  ?? "0")"
        }
        productpriceLabel.text = catalogProductViewModel.catalogProductModel.formatedFinalPrice
        //tier price
        self.tierPrices.text = catalogProductViewModel.catalogProductModel.tierPrices.joined(separator: "\n")
        
        //product rating and review
        let ratingArr:JSON = JSON(catalogProductViewModel.getRatingsData)
        let ratingCount:Float = Float(catalogProductViewModel.getRatingsData.count)
        var ratingVal:Float = 0
        for i in 0..<catalogProductViewModel.getRatingsData.count {
            let dict = ratingArr[i]
            let val = dict["ratingValue"].floatValue
            ratingVal = ratingVal + val
            print("cccvv",ratingVal)
        }
        
        writeYourReviewButton.backgroundColor = UIColor.white
        writeYourReviewButton.layer.cornerRadius = 15
        writeYourReviewButton.layer.borderColor = UIColor.DarkLavendar.cgColor
        writeYourReviewButton.layer.borderWidth = 1
        
        productRating.value = CGFloat((ratingVal/ratingCount) as Float)
        productRatingVal.text = "\(catalogProductViewModel.catalogProductModel.rating!)/5"
        productRatingCountVal.text = "\(catalogProductViewModel.reviewList.count) " + "ratings".localized
        totalReviews.text = ("\(catalogProductViewModel.reviewList.count) \n" + "review".localized)
        
        //add gesture on total reviews
        let addReviewGesture = UITapGestureRecognizer(target: self, action: #selector(CatalogProduct.totalReviewsClick(_:)))
        totalReviews.addGestureRecognizer(addReviewGesture)
        
        //add gesture on ratings view
        //let addRatingsGesture = UITapGestureRecognizer(target: self, action: #selector(CatalogProduct.ratingViewClick(_:)))
        //ratingView.addGestureRecognizer(addRatingsGesture)
        
        //product detail in web view ranjit ===========================
        
        let descHtmlStr = catalogProductViewModel.catalogProductModel.descriptionData
        descTextView.isHidden = true
        /*
        descTextView.isHidden = true
        descTextView.backgroundColor = UIColor.white
        descTextView.attributedText = descHtmlStr.htmlAttributedString(size: 15, color: .Lead)
        descTextView.isScrollEnabled = false
        descTextView.isEditable = false
        descTextView.isSelectable = false
        let textHeight = AppFunction.getTextHeightWithParaSpace(text: descHtmlStr, textWidth: SCREEN_WIDTH, space: 5, fontsize: 15)
        descWebViewHeightConstarints.constant = textHeight
       */
        
        //self.descWebView.scrollView.isScrollEnabled = false
        if let desc = descHtmlStr {
            self.loadhtmlDescriptionInWebView(htmlContent: desc)
            //self.descWebView.navigationDelegate = self
            //self.descWebView.loadHTMLString(desc, baseURL: nil)
            //let textHeight = AppFunction.getTextHeightWithParaSpace(text: desc, textWidth: SCREEN_WIDTH, space: 2, fontsize: 15)
            //descWebViewHeightConstarints.constant = textHeight
        }
        
        if catalogProductViewModel.additionalFeature.count > 0 {
            aditionfeatureLabel.isHidden = false
            aditionfeatureLineLabel.isHidden = false
            //aditionfeatureLabel.applyAfritiaBorederTheme(cornerRadius:2)
            aditionfeatureLabel.backgroundColor = UIColor.white
            self.showAdditionalFeatureList()
        }else{
            aditionalFeatureViewHeightConstarints.constant = 0
            aditionfeatureLabel.isHidden = true
            aditionfeatureLineLabel.isHidden = true
        }

        /*
        if responseObject != nil {
            self.homeViewModel.getData(data: responseObject!, recentViewData : productModel.getProductDataFromDB()) {
                (data : Bool) in
                if data {
                    self.homeTableView.reloadData()
                }
            }
        }
        
        if !recentViewData.isEmpty {
            let recentViewCollectionItem = HomeViewModelRecentViewItem(categories: recentViewData)
            items.append(recentViewCollectionItem)
        }*/
        
        activityIndicator.stopAnimating()
        
        self.groupjson = catalogProductViewModel.catalogProductModel.groupedData
        self.linkJson = catalogProductViewModel.catalogProductModel.links
        self.bundleJson = catalogProductViewModel.catalogProductModel.bundleData
        self.customeJson = catalogProductViewModel.catalogProductModel.customeOptionData
        self.configjson = catalogProductViewModel.catalogProductModel.configurableData
        
        if catalogProductViewModel.catalogProductModel.typeID == "grouped"{
            self.productpriceLabel.text =  catalogProductViewModel.catalogProductModel.groupedPrice
            
        }else if catalogProductViewModel.catalogProductModel.typeID == "bundle"{
            self.productpriceLabel.text =  catalogProductViewModel.catalogProductModel.formatedMinPrice+"-"+catalogProductViewModel.catalogProductModel.formatedMaxPrice
        }else{
            if catalogProductViewModel.catalogProductModel.isInRange == true{
                
                if catalogProductViewModel.catalogProductModel.specialPrice < catalogProductViewModel.catalogProductModel.price{
                    self.productpriceLabel.text = catalogProductViewModel.catalogProductModel.formatedSpecialprice
                    let attributeString = NSMutableAttributedString(string: catalogProductViewModel.catalogProductModel.formatedPrice)
                    attributeString.addAttribute(NSAttributedStringKey.strikethroughStyle, value: 1, range: NSRange(location: 0, length: attributeString.length))
                    specialPrice.attributedText = attributeString
                    specialPrice.isHidden = false
                }
            }
        }
        self.addToCartFrameY = self.addToCartView.frame.origin.y
        
        
        
        /////////////////// Market Place ///////////////////
        
        if catalogProductViewModel.sellerInformationData.sellerID != "" &&
            catalogProductViewModel.sellerInformationData.sellerID != "0" &&
            
            catalogProductViewModel.displaySellerInfo == true  {
            
            marketPlaceView.backgroundColor = UIColor.white
            marketPlaceView.isHidden = false
            marketplaceHeightConstarints.constant = 150
            sellerNameButton.isHidden = false
            message.isHidden = false
            ratingValue.isHidden = false
            label1.isHidden = false
            label2.isHidden = false
            label3.isHidden = false
            rating1.isHidden = false
            rating2.isHidden = false
            rating3.isHidden = false
            
            contactUsButton.setTitle("contactus".localized, for: .normal)
            contactUsButton.setTitleColor(UIColor.appStarColor, for: .normal)
            sellerNameButton.setTitle(catalogProductViewModel.sellerInformationData.sellerShopTitle, for: .normal)
            sellerNameButton.setTitleColor(UIColor.appStarColor, for: .normal)
            ratingValue.text = " "+catalogProductViewModel.sellerInformationData.sellerAverageRating+"/5"+" "
            ratingValue.textColor = UIColor.PureWhite
            ratingValue.backgroundColor = UIColor.black
            
            message.text = catalogProductViewModel.sellerInformationData.sellerReviewDescription
            for i in 0..<catalogProductViewModel.sellerRatingData.count{
                if i == 0{
                    label1.text = catalogProductViewModel.sellerRatingData[i].label
                    rating1.value = CGFloat(catalogProductViewModel.sellerRatingData[i].value)
                }else if i == 1{
                    label2.text = catalogProductViewModel.sellerRatingData[i].label
                    rating2.value = CGFloat(catalogProductViewModel.sellerRatingData[i].value)
                }else if i == 2{
                    label3.text = catalogProductViewModel.sellerRatingData[i].label
                    rating3.value = CGFloat(catalogProductViewModel.sellerRatingData[i].value)
                }
            }
            
            //marketPlaceView.layer.borderWidth = 0.5
            //marketPlaceView.layer.borderColor = UIColor().HexToColor(hexString: BUTTON_COLOR).cgColor
            
        }else{
            marketplaceHeightConstarints.constant = 0
            marketPlaceView.backgroundColor = UIColor.white
            
            sellerNameButton.isHidden = true
            message.isHidden = true
            ratingValue.isHidden = true
            label1.isHidden = true
            label2.isHidden = true
            label3.isHidden = true
            rating1.isHidden = true
            rating2.isHidden = true
            rating3.isHidden = true
        }
        
        self.mainContainerY += 10
        
        setUpGroupProducts()
        
        print("asasas",self.linkJson)
        
        //setUpDownloadableProducts() ranjit remove for download product
        
        
        setUpBundleProducts()

        
        setUpCustomOptionsProducts()
        
        otherViewHeightCOnstarints.constant += self.mainContainerY
        
        //        dynamicViewHeightCOnstarints.constant = self.mainContainerY
        //        self.mainViewHeightConstarints.constant += dynamicViewHeightCOnstarints.constant
        
        if self.configjson["configurableData"]["attributes"].count > 0{
            self.createConfigurableView()
        }
    }
    
    func loadhtmlDescriptionInWebView(htmlContent:String){
        
        //guard let path = Bundle.main.path(forResource: "style", ofType: "css") else {
                   // return WKWebView()
                //}
                
        let path = Bundle.main.path(forResource: "style", ofType: "css")
        let cssString = try! String(contentsOfFile: path!).components(separatedBy: .newlines).joined()
                let source = """
                var style = document.createElement('style');
                style.innerHTML = '\(cssString)';
                document.head.appendChild(style);
                """
                
                let userScript = WKUserScript(source: source,
                                              injectionTime: .atDocumentEnd,
                                              forMainFrameOnly: true)
                
                let userContentController = WKUserContentController()
                userContentController.addUserScript(userScript)
                
                //let configuration = WKWebViewConfiguration()
                //configuration.userContentController = userContentController
                
                //let webView = WKWebView(frame: .zero ,configuration: configuration)
        descWebView.frame = .zero
        //descWebView.configuration = configuration
        descWebView.navigationDelegate = self
        descWebView.scrollView.isScrollEnabled = false
        descWebView.scrollView.bounces = false
        
        let htmlStart = "<HTML><HEAD><meta name=\"viewport\" content=\"width=device-width, initial-scale=1.0, shrink-to-fit=no\"></HEAD><BODY>"
                let htmlEnd = "</BODY></HTML>"
                let htmlString = "\(htmlStart)\(htmlContent)\(htmlEnd)"
        descWebView.loadHTMLString(htmlString, baseURL: Bundle.main.bundleURL)
    }
    
    func showAdditionalFeatureList(){
        
        self.aditionalFeatureView.backgroundColor = UIColor.white
        var viewHeight = 0
        
        let hadingSpace = 40
        let posX = 0
        var posY = 40
        let rowSpace = 1
        let colSpace = 1
        let padSpace = 10
        let lblHeight = 20
        
        let tLblWidth = Int(SCREEN_WIDTH/3) - 20
        let vLblXpos = posX + tLblWidth + colSpace + padSpace + 20
        let vLblWidth = SCREEN_WIDTH - CGFloat(vLblXpos)
        
        let totalFeatures = self.catalogProductViewModel.additionalFeature.count
        for i in 0..<totalFeatures {
            
            let titleLbl = UILabel(frame:CGRect(x:posX + padSpace, y: posY + rowSpace, width: tLblWidth, height: lblHeight))
            titleLbl.backgroundColor = UIColor.appExtraLightGray
            titleLbl.text = " " + self.catalogProductViewModel.additionalFeature[i].label
            titleLbl.textColor = UIColor.black
            titleLbl.font = UIFont.systemFont(ofSize:14, weight:.semibold)
            aditionalFeatureView.addSubview(titleLbl)
            
            let valueLbl = UILabel(frame:CGRect(x:posX + tLblWidth + colSpace + padSpace, y: posY + rowSpace, width: Int(vLblWidth), height: lblHeight))
            valueLbl.backgroundColor = UIColor.appSuperLightGrey
            valueLbl.text = " " + self.catalogProductViewModel.additionalFeature[i].value
            valueLbl.textColor = UIColor.black
            valueLbl.font = UIFont.systemFont(ofSize:14, weight:.regular)
            aditionalFeatureView.addSubview(valueLbl)
            
            posY = posY + (lblHeight + rowSpace)
            viewHeight = viewHeight + lblHeight
        }
        
        aditionalFeatureViewHeightConstarints.constant = CGFloat(hadingSpace + viewHeight + (2*totalFeatures))
    }
    
    //TODO:- createConfigurableView
    func createConfigurableView()   {
        
        var Y :CGFloat = 0
        var shiftX:CGFloat = 0
        let swatchDict = convertToDictionary(text:self.configjson["configurableData"]["swatchData"].stringValue)
        
        //views are removed because everytime new views are created
        for subViews: UIView in dynamicView.subviews {
            subViews.removeFromSuperview()
        }
        //---
        
        //save configurable images and indexes---
        if let configImgs = self.configjson["configurableData"]["images"].stringValue as? String, configImgs != "[]"  {
            configurableDataImages = self.configjson["configurableData"]["images"].stringValue.convertToDictionary()!
            configurableDataIndex = convertToArray(text: self.configjson["configurableData"]["index"].stringValue)
            }
            //----
        
        for i in 0..<self.configjson["configurableData"]["attributes"].count
        {
            let dict = self.configjson["configurableData"]["attributes"][i]
            
            if defaultLaunch == true
            {
                if dict["swatchType"].stringValue == "visual" || dict["swatchType"].stringValue == "text"
                {
                    let swatchResult = JSON(swatchDict?[dict["id"].stringValue] ?? "")
                    let configureProductsScrollView = UIScrollView(frame: CGRect(x: 5, y: Y, width: mainView.frame.size.width - 10, height: 40))
                    configureProductsScrollView.isUserInteractionEnabled = true
                    configureProductsScrollView.showsHorizontalScrollIndicator = false
                    configureProductsScrollView.tag = i
                    shiftX = 0
                    self.dynamicView.addSubview(configureProductsScrollView)
                    
                    for (subkey,subsubJson):(String,JSON) in swatchResult{
                        let optionValue = UILabel(frame: CGRect(x: shiftX, y: 5, width: 30, height: 30))
                        optionValue.font = UIFont(name: REGULARFONT, size: 14.0)
                        optionValue.layer.cornerRadius = 15
                        optionValue.layer.borderColor = UIColor.white.cgColor
                        optionValue.layer.borderWidth = 2.0
                        optionValue.clipsToBounds = true
                        configureProductsScrollView.addSubview(optionValue)
                        
                        if subsubJson["type"].intValue == 1{
                            let optionDynamicColor = UIColor().HexToColor(hexString: subsubJson["value"].stringValue)
                            optionValue.backgroundColor = optionDynamicColor //ranjit remove this comment

                        }else if subsubJson["type"].intValue == 0{
                            optionValue.text = subsubJson["value"].stringValue
                            optionValue.textAlignment = .center
                        }
                        optionValue.tag = Int(subkey)!
                        if selectedLabelTag == optionValue.tag{
                            optionValue.layer.borderColor = UIColor.black.cgColor
                            optionValue.layer.borderWidth = 2.0
                        }else{
                            optionValue.layer.borderColor = UIColor.appLightGrey.cgColor
                            optionValue.layer.borderWidth = 1.0
                        }
                        let configGesture = UITapGestureRecognizer(target: self, action: #selector(self.swatchConfigSelection))
                        configGesture.numberOfTapsRequired = 1
                        optionValue.isUserInteractionEnabled = true
                        optionValue.addGestureRecognizer(configGesture)
                        
                        shiftX += 50
                    }
                    configureProductsScrollView.contentSize = CGSize(width: shiftX, height: 30)
                    Y += 40
                }
                else
                {
                    let configSelection = self.createDynamicSelectionView(posY:Y)
                    configSelection.tag  = 7000 + i
                    configSelection.isUserInteractionEnabled = true
                    let configGesture = UITapGestureRecognizer(target: self, action: #selector(self.openConfigSelection))
                    configGesture.numberOfTapsRequired = 1
                    configSelection.addGestureRecognizer(configGesture)
                    dynamicView.addSubview(configSelection)
                    Y += 50
                }
                self.dynamicViewHeightCOnstarints.constant = Y
                
            }
            else
            {
                if dict["swatchType"].stringValue == "visual" || dict["swatchType"].stringValue == "text"{
                    
                    let swatchResult = JSON(swatchDict?[dict["id"].stringValue] ?? "")
                   
                    
                    let configureProductsScrollView = UIScrollView(frame: CGRect(x: 5, y: Y, width: SCREEN_WIDTH - 10, height: 35))
                    configureProductsScrollView.isUserInteractionEnabled = true
                    configureProductsScrollView.showsHorizontalScrollIndicator = false
                    configureProductsScrollView.tag = i
                    shiftX = 0
                    self.dynamicView.addSubview(configureProductsScrollView)
                    
                    if i == 0{
                        
                        for (subkey,subsubJson):(String,JSON) in swatchResult{
                            let optionValue = UILabel(frame: CGRect(x: shiftX, y: 0, width: 50, height: 30))
                            optionValue.font = UIFont(name: REGULARFONT, size: 15.0)
//                            optionValue.layer.borderColor = UIColor().HexToColor(hexString: LIGHTGREY).cgColor
//                            optionValue.layer.borderWidth = 1.0
                            optionValue.clipsToBounds = true
                            configureProductsScrollView.addSubview(optionValue)
                            if subsubJson["type"].intValue == 1{
                                optionValue.backgroundColor = UIColor().HexToColor(hexString: subsubJson["value"].stringValue)
                            }else if subsubJson["type"].intValue == 0{
                                optionValue.text = subsubJson["value"].stringValue
                                optionValue.textAlignment = .center
                            }
                            optionValue.tag = Int(subkey)!
                            if selectedLabelTag == optionValue.tag{
                                optionValue.layer.borderColor = UIColor.black.cgColor
                                optionValue.layer.borderWidth = 2.0
                            }else{
                                optionValue.layer.borderColor = UIColor.appLightGrey.cgColor
                                optionValue.layer.borderWidth = 1.0
                            }
                            let configGesture = UITapGestureRecognizer(target: self, action: #selector(self.swatchConfigSelection))
                            configGesture.numberOfTapsRequired = 1
                            optionValue.isUserInteractionEnabled = true
                            optionValue.addGestureRecognizer(configGesture)
                            
                            if configurableSelectedData[dict["id"].stringValue] == subkey{
                                optionValue.layer.borderColor = UIColor.red.cgColor
                            }
                            
                            shiftX += 55
                        }
                        configureProductsScrollView.contentSize = CGSize(width: shiftX, height: 30)
                    }else{
                        
                        var combinedRelatedProducts:NSArray = []
                        for tt in 0..<i{
                            combinedRelatedProducts = combinedRelatedProducts.addingObjects(from:configurableRelatedProducts[tt] as! [Any]) as NSArray
                        }
                        var checkInDict:Bool = false
                        for (subkey,subsubJson):(String,JSON) in swatchResult{
                            var flag = false
                            
                            for k in 0..<dict["options"].count{
                                if dict["options"][k]["id"].stringValue == subkey{
                                    let thisProducts = dict["options"][k]["products"].arrayObject! as NSArray
                                    let t = anyCommonElements(data1: thisProducts, data2: combinedRelatedProducts)
                                    if t == true{
                                        flag = true
                                    }
                                }
                            }
                            if flag == true{
                                let optionValue = UILabel(frame: CGRect(x: shiftX, y: 0, width: 50, height: 30))
                                optionValue.font = UIFont(name: REGULARFONT, size: 15.0)
//                                optionValue.layer.borderColor = UIColor().HexToColor(hexString: LIGHTGREY).cgColor
//                                optionValue.layer.borderWidth = 1.0
                                optionValue.clipsToBounds = true
                                configureProductsScrollView.addSubview(optionValue)
                                if subsubJson["type"].intValue == 1{
                                    optionValue.backgroundColor = UIColor().HexToColor(hexString: subsubJson["value"].stringValue)
                                }else if subsubJson["type"].intValue == 0{
                                    optionValue.text = subsubJson["value"].stringValue
                                    optionValue.textAlignment = .center
                                }
                                optionValue.tag = Int(subkey)!
                                if selectedLabelTag == optionValue.tag{
                                    optionValue.layer.borderColor = UIColor.black.cgColor
                                    optionValue.layer.borderWidth = 2.0
                                }else{
                                    optionValue.layer.borderColor = UIColor.appLightGrey.cgColor
                                    optionValue.layer.borderWidth = 1.0
                                }
                                let configGesture = UITapGestureRecognizer(target: self, action: #selector(self.swatchConfigSelection))
                                configGesture.numberOfTapsRequired = 1
                                optionValue.isUserInteractionEnabled = true
                                optionValue.addGestureRecognizer(configGesture)
                                shiftX += 55
                                
                                if configurableSelectedData[dict["id"].stringValue] == subkey{
                                    checkInDict = true
                                    optionValue.layer.borderColor = UIColor.black.cgColor
                                }
                            }
                        }
                        if checkInDict == false{
                            configurableSelectedData[dict["id"].stringValue] = "0"
                        }
                        configureProductsScrollView.contentSize = CGSize(width: shiftX, height: 30)
                    }
                    
                    Y += 40
                }
                else
                {
                    print("refresh config")
                    if i == 0
                    {
                        /*
                        let configSelection = UILabel(frame: CGRect(x: CGFloat(5), y: CGFloat(Y), width: SCREEN_WIDTH - 10, height: CGFloat(35)))
                        configSelection.textColor = UIColor().HexToColor(hexString: TEXTHEADING_COLOR)
                        configSelection.backgroundColor = UIColor.clear
                        configSelection.font = UIFont(name: REGULARFONT, size: CGFloat(16))!
                        configSelection.text = GlobalData.sharedInstance.language(key: "chooseaselection")
                        configSelection.layer.borderColor = UIColor(red:222/255.0, green:225/255.0, blue:227/255.0, alpha: 1.0).cgColor
                        configSelection.layer.borderWidth = 2.0
                         //configSelection.textAlignment = .center
                        */
                        
                        let configSelection = self.createDynamicSelectionView(posY:Y)
                        configSelection.tag  = 7000 + i
                        
                        configSelection.isUserInteractionEnabled = true
                        dynamicView.addSubview(configSelection)
                        Y += 50
                        let configGesture = UITapGestureRecognizer(target: self, action: #selector(self.openConfigSelection))
                        configGesture.numberOfTapsRequired = 1
                        configSelection.addGestureRecognizer(configGesture)
                        
                        for k in 0..<dict["options"].count{
                            if dict["options"][k]["id"].stringValue == configurableSelectedData[dict["id"].stringValue]{
                                configSelection.text = dict["options"][k]["label"].stringValue
                            }
                        }
                    }
                    else
                    {
                        var combinedRelatedProducts:NSArray = []
                        for tt in 0..<configurableRelatedProducts.count{
                            combinedRelatedProducts = combinedRelatedProducts.addingObjects(from:configurableRelatedProducts[tt] as! [Any]) as NSArray
                        }
                        
                        /*
                        let configSelection = UILabel(frame: CGRect(x: CGFloat(5), y: CGFloat(Y), width: SCREEN_WIDTH - 10, height: CGFloat(35)))
                        configSelection.textColor = UIColor().HexToColor(hexString: TEXTHEADING_COLOR)
                        configSelection.backgroundColor = UIColor.clear
                        configSelection.font = UIFont(name: REGULARFONT, size: CGFloat(16))!
                        configSelection.text = GlobalData.sharedInstance.language(key: "chooseaselection")
                        configSelection.layer.borderColor = UIColor(red:222/255.0, green:225/255.0, blue:227/255.0, alpha: 1.0).cgColor
                        configSelection.layer.borderWidth = 2.0
                        configSelection.tag  = 7000 + i
                        configSelection.textAlignment = .center
                        */
                        
                        let configSelection = self.createDynamicSelectionView(posY:Y)
                        configSelection.isUserInteractionEnabled = true
                        let configGesture = UITapGestureRecognizer(target: self, action: #selector(self.openConfigSelection))
                        configGesture.numberOfTapsRequired = 1
                        configSelection.addGestureRecognizer(configGesture)
                        dynamicView.addSubview(configSelection)
                        Y += 50
                        
                        for k in 0..<dict["options"].count{
                            if dict["options"][k]["id"].stringValue == configurableSelectedData[dict["id"].stringValue]{
                                let thisProducts = dict["options"][k]["products"].arrayObject! as NSArray
                                let t = anyCommonElements(data1: thisProducts, data2: combinedRelatedProducts)
                                if t == true{
                                    configSelection.text = dict["options"][k]["label"].stringValue
                                }else{
                                    configurableSelectedData[dict["id"].stringValue] = "0"
                                }
                                break
                            }
                        }
                    }
                }
                self.dynamicViewHeightCOnstarints.constant = Y
                //self.dynamicView.backgroundColor = UIColor.clear
            }
        }
        
        if defaultLaunch == true{
            //self.dynamicView.backgroundColor = UIColor.clear
        }
    }
    
    
    func createDynamicSelectionView(posY:CGFloat) -> UILabel {
        
        let configSelection = UILabel(frame: CGRect(x: CGFloat(10), y: CGFloat(posY), width: SCREEN_WIDTH - 30, height: CGFloat(36)))
        configSelection.textColor = UIColor.appStarColor
        configSelection.backgroundColor = UIColor.appExtraLightGray
        configSelection.font = UIFont(name: REGULARFONT, size: CGFloat(16))!
        configSelection.text = GlobalData.sharedInstance.language(key: "chooseaselection")
        configSelection.applyRoundCornerShadow(radius:5)
        configSelection.layer.borderColor = UIColor.lightGray.cgColor //UIColor(red:222/255.0, green:225/255.0, blue:227/255.0, alpha: 1.0).cgColor
        configSelection.layer.borderWidth = 1
        configSelection.textAlignment = .center
        return configSelection
    }
    
    //TODO:- AddToWishList
    func AddToWishList() {
        
        let customerId = defaults.object(forKey: "customerId")
        if(customerId == nil){
            let alertView = UIAlertController(title: "loginrequired".localized, message: "doyouwanttologin".localized, preferredStyle: .alert)
            let loginBtn = UIAlertAction(title: "loginalert".localized, style: .default, handler: {(_ action: UIAlertAction) -> Void in
                let storyboard = UIStoryboard.init(name: "Main", bundle: nil)
                let vc = storyboard.instantiateViewController(withIdentifier: "CustomerLogin") as! CustomerLogin
                self.navigationController?.pushViewController(vc, animated: true)
            })
            let cancelBtn = UIAlertAction(title: "cancel".localized, style: .destructive, handler: {(_ action: UIAlertAction) -> Void in
            })
            
            alertView.addAction(cancelBtn)
            alertView.addAction(loginBtn)
            self.present(alertView, animated: true, completion: nil)
        }else{
            
            if self.catalogProductViewModel.catalogProductModel.isInWishList {
                //remove from wish list
                callingHttppApi(apiType: CatalogProductAPI.removeFromWishList)
                
            }else{
                //add to wish list
                
                // grouped product
                selectedGroupedProduct = [String:String]()
                selectedDownloadableProduct = [String:String]()
                selectedCustomeOption = [String:AnyObject]()
                if self.groupjson["groupedData"].count > 0{
                    for i in 0..<(self.groupjson["groupedData"].count){
                        let groupedDataDict = self.groupjson["groupedData"][i]
                        let groupedUIView = otherView.viewWithTag(5000)! as UIView
                        let textField : UITextField = groupedUIView .viewWithTag(i + 1) as! UITextField
                        if(textField.text == "0" || textField.text == ""){
                            selectedGroupedProduct[groupedDataDict["id"].string!] = "0"
                        }else{
                            selectedGroupedProduct[groupedDataDict["id"].string!] = textField.text
                        }}
                }
                // download data
                if (self.linkJson["links"]["linksPurchasedSeparately"].string == "1") {
                    let downloadOptionUIView = otherView.viewWithTag(6000)!
                    for i in 0..<self.linkJson["links"]["linkData"].count {
                        let linksOption = self.linkJson["links"]["linkData"][i]
                        let switchValue:UISwitch = downloadOptionUIView.viewWithTag(i + 1)! as! UISwitch
                        if switchValue.isOn {
                            selectedDownloadableProduct[linksOption["id"].string!] = linksOption["id"].string
                        }else{
                            selectedDownloadableProduct[linksOption["id"].string!] = ""
                        }
                    }
                }
                
                // custome data
                if(self.customeJson["customOptions"].count > 0){
                    let customOptionUIView = otherView.viewWithTag(4000)!
                    for i in 0..<customeJson["customOptions"].count {
                        let customOptionDict = customeJson["customOptions"][i]
                        if  customOptionDict["is_require"].intValue == 1 {
                            if (customOptionDict["type"].string == "field") {
                                let tempField:UITextField = customOptionUIView.viewWithTag(i + 1)! as! UITextField
                                if tempField.text == "" {
                                    selectedCustomeOption[customOptionDict["option_id"].stringValue] = "" as AnyObject?
                                }
                                else {
                                    selectedCustomeOption[customOptionDict["option_id"].stringValue] = tempField.text as AnyObject?
                                }
                            }
                            if (customOptionDict["type"] == "area") {
                                let tempArea:UITextView = customOptionUIView.viewWithTag(i + 1)! as! UITextView
                                if tempArea.text == "" {
                                    selectedCustomeOption[customOptionDict["option_id"].stringValue] = "" as AnyObject?
                                }
                                else {
                                    selectedCustomeOption[customOptionDict["option_id"].stringValue] = tempArea.text as AnyObject?
                                }
                            }
                            if (customOptionDict["type"].string == "checkbox") || (customOptionDict["type"].string == "multiple") {
                                let tempSwitchArea:UIView = customOptionUIView.viewWithTag(i + 1)!
                                var isSwitchOn = 0
                                let selectedOption = NSMutableArray()
                                for (key,_):(String, JSON) in customOptionDict["optionValues"].dictionaryValue {
                                    let checkBoxTag = Int(key)
                                    let tempSwitch:UISwitch = tempSwitchArea.viewWithTag(checkBoxTag!) as! UISwitch
                                    if tempSwitch.isOn {
                                        isSwitchOn = 1
                                        selectedOption.add(key)
                                    }
                                }
                                if isSwitchOn == 0 {
                                    selectedCustomeOption[customOptionDict["option_id"].stringValue] = selectedOption
                                }
                                else {
                                    selectedCustomeOption[customOptionDict["option_id"].stringValue] = selectedOption
                                }
                            }
                        }else{
                            if (customOptionDict["type"].string == "field") {
                                let tempField:UITextField = customOptionUIView.viewWithTag(i + 1)! as! UITextField
                                selectedCustomeOption[customOptionDict["option_id"].stringValue] = tempField.text as AnyObject?
                            }
                            if (customOptionDict["type"].string == "area") {
                                let tempArea:UITextView = customOptionUIView.viewWithTag(i + 1)! as! UITextView
                                selectedCustomeOption[customOptionDict["option_id"].stringValue] = tempArea.text as AnyObject?
                            }
                            
                            if (customOptionDict["type"].string == "checkbox") || (customOptionDict["type"].string == "multiple") {
                                let tempSwitchArea:UIView = customOptionUIView.viewWithTag(i + 1)!
                                let selectedOption = NSMutableArray()
                                for (key,_):(String, JSON) in customOptionDict["optionValues"].dictionaryValue {
                                    let checkBoxTag = Int(key)
                                    let tempSwitch:UISwitch = tempSwitchArea.viewWithTag(checkBoxTag!) as! UISwitch
                                    if tempSwitch.isOn {
                                        selectedOption.add(key)
                                    }
                                }
                                selectedCustomeOption[customOptionDict["option_id"].stringValue] = selectedOption
                            }
                        }
                        if (customOptionDict["type"].string == "radio") || (customOptionDict["type"].string == "drop_down") {
                            let tempPicker:UILabel = customOptionUIView.viewWithTag(i + 1)! as! UILabel
                            
                            if(tempPicker.text != GlobalData.sharedInstance.language(key: "chooseaselection"))  {
                                selectedCustomeOption[customOptionDict["option_id"].stringValue] = selectedCustomeOptionWishList[customOptionDict["option_id"].string!] as AnyObject
                            }
                        }
                        if (customOptionDict["type"].string == "date") || (customOptionDict["type"].string == "date_time") || (customOptionDict["type"].string == "time") {
                            let tempDatePicker:UILabel = customOptionUIView.viewWithTag(i + 1)! as! UILabel
                            if (customOptionDict["type"].string == "date") {
                                if (tempDatePicker.text != GlobalData.sharedInstance.language(key: "selectdate")) {
                                    selectedCustomeOption[customOptionDict["option_id"].stringValue] =  dateDict as AnyObject?
                                }
                            }
                            if (customOptionDict["type"].string == "date_time") {
                                if (tempDatePicker.text != GlobalData.sharedInstance.language(key: "selectdateandtime")) {
                                    
                                    selectedCustomeOption[customOptionDict["option_id"].stringValue] =  dateTimeDict as AnyObject?
                                }
                            }
                            if (customOptionDict["type"].string == "time") {
                                if (tempDatePicker.text != GlobalData.sharedInstance.language(key: "selecttime")) {
                                    selectedCustomeOption[customOptionDict["option_id"].stringValue] =  timeDict as AnyObject?
                                }
                            }
                        }
                    }
                }
                //  bundle data
                
                bundleSelectedDataWishList = [String:String]()
                if(self.bundleJson["bundleOptions"].count > 0){
                    let containerView:UIView = self.otherView.viewWithTag(9000)!
                    for i in 0..<self.bundleJson["bundleOptions"].count {
                        let bundleCollection = self.bundleJson["bundleOptions"][i]
                        let textField:UITextField = containerView.viewWithTag(i + 100) as! UITextField
                        
                        if self.bundleSelectedData[bundleCollection["option_id"].string!] != ("0" as AnyObject as! _OptionalNilComparisonType){
                            bundleSelectedDataWishList[bundleCollection["option_id"].string!] = bundleSelectedData[bundleCollection["option_id"].string!]! as? String
                        }
                        if(textField.text != "0" || textField.text != ""){
                            selectedBundleProductQuantity[bundleCollection["option_id"].string!] = textField.text
                        }
                    }
                }
                
                callingHttppApi(apiType: CatalogProductAPI.addToWishlist)
            }
        }
    }
    
    
    //TODO:- Set up Group products
    func setUpGroupProducts()   {
        if(self.groupjson["groupedData"].count > 0){
            
            let groupedDataContainer = UIView(frame: CGRect(x: CGFloat(5), y: CGFloat(self.mainContainerY), width: CGFloat(self.mainView.frame.size.width - 10), height: CGFloat(100)))
            groupedDataContainer.layer.borderColor = UIColor(red:222/255.0, green:225/255.0, blue:227/255.0, alpha: 1.0).cgColor
            groupedDataContainer.tag = 5000
            groupedDataContainer.layer.borderWidth = 2.0
            self.otherView.addSubview(groupedDataContainer)
            var groupedInternalY : CGFloat = 5
            
            for i in 0..<(self.groupjson["groupedData"].count){
                let groupDataDic = self.groupjson["groupedData"][i]
                let url = NSURL(string: groupDataDic["thumbNail"].string!)! as URL
                
                let groupedImageView = UIImageView(frame: CGRect(x: 0, y: groupedInternalY, width: SCREEN_WIDTH/5, height: SCREEN_WIDTH/5))
                groupedImageView.image = UIImage(named: "ic_placeholder.png")
                groupedImageView.isUserInteractionEnabled = true
                self.getDataFromUrl(url: url) { (data, response, error)  in
                    guard let data = data, error == nil else { return }
                    DispatchQueue.main.async() { () -> Void in
                        groupedImageView.image = UIImage(data: data)
                    }
                }
                groupedDataContainer.addSubview(groupedImageView)
                
                let nameAttributes = [NSAttributedStringKey.font: UIFont(name: REGULARFONT, size: CGFloat(14))!]
                let nameStringSize = (groupDataDic["name"].string)?.size(withAttributes: nameAttributes)
                let nameStringWidth: CGFloat = nameStringSize!.width
                let name = UILabel(frame: CGRect(x: CGFloat(((SCREEN_WIDTH / 5) + 10)), y: CGFloat(groupedInternalY), width: nameStringWidth, height: CGFloat(20)))
                name.textColor =  UIColor().HexToColor(hexString: "555555")
                name.font = UIFont(name: REGULARFONT, size: CGFloat(14))!
                name.text = groupDataDic["name"].string
                groupedDataContainer.addSubview(name)
                
                if (groupDataDic["isAvailable"].int == 1) {
                    let qtyField = UITextField(frame: CGRect(x: CGFloat(((SCREEN_WIDTH / 5) + 10)), y: CGFloat(groupedInternalY + 25), width: CGFloat(50), height: CGFloat(25)))
                    qtyField.font = UIFont(name: "Trebuchet MS", size: CGFloat(20.0))!
                    qtyField.textColor = UIColor.black
                    qtyField.text = groupDataDic["defaultQty"].stringValue == "" ? "0" : groupDataDic["defaultQty"].stringValue
                    qtyField.tag = i + 1
                    qtyField.textAlignment = .center
                    qtyField.keyboardType = .phonePad
                    qtyField.borderStyle = .roundedRect
                    qtyField.tintColor = UIColor.black
                    groupedDataContainer.addSubview(qtyField)
                    let qtylblAttributes = [NSAttributedStringKey.font: UIFont(name: "Trebuchet MS", size: CGFloat(17.0))!]
                    let qtylblStringSize = "Quantity".size(withAttributes: qtylblAttributes)
                    let qtylblStringWidth: CGFloat = qtylblStringSize.width
                    let qtyLbl = UILabel(frame: CGRect(x: CGFloat(((SCREEN_WIDTH / 5) + 65)), y: CGFloat(groupedInternalY + 27), width: qtylblStringWidth, height: CGFloat(20)))
                    qtyLbl.textColor = UIColor().HexToColor(hexString: "555555")
                    qtyLbl.font = UIFont(name: REGULARFONT, size: CGFloat(15))!
                    qtyLbl.text = "QTY"
                    groupedDataContainer.addSubview(qtyLbl)
                }else{
                    let OOSAttributes = [NSAttributedStringKey.font: UIFont(name: "Trebuchet MS", size: CGFloat(17.0))!]
                    let OOSStringSize = "OUT OF STOCK".size(withAttributes: OOSAttributes)
                    let OOSStringWidth: CGFloat = OOSStringSize.width
                    let OOS = UILabel(frame: CGRect(x: CGFloat(((SCREEN_WIDTH / 5) + 10)), y: CGFloat(groupedInternalY + 27), width: OOSStringWidth, height: CGFloat(20)))
                    OOS.textColor = UIColor().HexToColor(hexString: "555555")
                    OOS.font = UIFont(name: REGULARFONT, size: CGFloat(15))!
                    OOS.text = "OUT OF STOCK"
                    groupedDataContainer.addSubview(OOS)
                }
                if (groupDataDic["isInRange"].int == 1) {
                    let regularPriceAttributes = [NSAttributedStringKey.font: UIFont(name: REGULARFONT, size: CGFloat(15))!]
                    let regularPriceStringSize = (groupDataDic["foramtedPrice"].string)?.size(withAttributes: regularPriceAttributes)
                    let regularPriceStringWidth: CGFloat = regularPriceStringSize!.width
                    let regularprice = UILabel(frame: CGRect(x: CGFloat(((SCREEN_WIDTH / 5) + 10)), y: CGFloat(groupedInternalY + 55), width: regularPriceStringWidth, height: CGFloat(20)))
                    regularprice.textColor = UIColor().HexToColor(hexString: "555555")
                    regularprice.backgroundColor = UIColor.clear
                    regularprice.font = UIFont(name: REGULARFONT, size: CGFloat(15))!
                    let attributeString = NSMutableAttributedString(string: (groupDataDic["foramtedPrice"].string)!)
                    attributeString.addAttribute(NSAttributedStringKey.strikethroughStyle, value: 2, range: NSRange(location: 0, length: attributeString.length))
                    regularprice.attributedText = attributeString
                    groupedDataContainer.addSubview(regularprice)
                    let specialPriceAttributes = [NSAttributedStringKey.font: UIFont(name: REGULARFONT, size: CGFloat(15))!]
                    let specialPriceStringSize = (groupDataDic["specialPrice"].string)?.size(withAttributes: specialPriceAttributes)
                    let specialPriceStringWidth: CGFloat = specialPriceStringSize!.width
                    let specialPrice = UILabel(frame: CGRect(x: CGFloat((regularPriceStringWidth + 5) + ((SCREEN_WIDTH / 5) + 10)), y: CGFloat(groupedInternalY + 55), width: specialPriceStringWidth, height: CGFloat(20)))
                    specialPrice.textColor = UIColor().HexToColor(hexString: "268ED7")
                    specialPrice.backgroundColor = UIColor.clear
                    specialPrice.font = UIFont(name: REGULARFONT, size: CGFloat(15))!
                    specialPrice.text = groupDataDic["specialPrice"].string
                    groupedDataContainer.addSubview(specialPrice)
                }else{
                    let priceAttributes = [NSAttributedStringKey.font: UIFont(name: REGULARFONT, size: CGFloat(15))!]
                    let priceStringSize = (groupDataDic["foramtedPrice"].string)?.size(withAttributes: priceAttributes)
                    let priceStringWidth: CGFloat = priceStringSize!.width
                    let price = UILabel(frame: CGRect(x: CGFloat(((SCREEN_WIDTH / 5) + 10)), y: CGFloat(groupedInternalY + 55), width: priceStringWidth, height: CGFloat(20)))
                    price.textColor = UIColor().HexToColor(hexString: "268ED7")
                    price.backgroundColor = UIColor.clear
                    price.font = UIFont(name: REGULARFONT, size: CGFloat(15))!
                    price.text = groupDataDic["foramtedPrice"].string
                    groupedDataContainer.addSubview(price)
                }
                if i < self.groupjson["groupedData"].count - 1 {
                    let hr1 = UIView(frame: CGRect(x: CGFloat(5), y: CGFloat(groupedInternalY), width: CGFloat(groupedDataContainer.frame.size.width - 10), height: CGFloat(1)))
                    hr1.backgroundColor = UIColor().HexToColor(hexString: "C8C4C4")
                    groupedDataContainer.addSubview(hr1)
                    groupedInternalY += 6
                }
                groupedInternalY += SCREEN_WIDTH/5 + 10
            }
            var newFrame = groupedDataContainer.frame
            newFrame.size.height = groupedInternalY
            groupedDataContainer.frame = newFrame
            self.mainContainerY += groupedInternalY + 21
        }
    }
    
    //TODO:- Set up Downloadble products
    func setUpDownloadableProducts()   {
        if(self.linkJson["links"].count > 0){
            var internalY: CGFloat = 10
            let downloadableContainer = UIView(frame: CGRect(x: CGFloat(5), y: CGFloat(self.mainContainerY), width: CGFloat(self.mainView.frame.size.width - 10), height: CGFloat(900)))
            downloadableContainer.layer.borderColor = UIColor.LightLavendar.cgColor
            downloadableContainer.tag = 6000
            downloadableContainer.layer.borderWidth = 2.0
            self.otherView.addSubview(downloadableContainer)
            
            let reqAttributes = [NSAttributedStringKey.font: UIFont(name: "Helvetica-Bold", size: CGFloat(22.0))!]
            let reqStringSize = (self.linkJson["links"]["title"].string)?.size(withAttributes: reqAttributes)
            let reqStringWidth: CGFloat = reqStringSize!.width
            let title = UILabel(frame: CGRect(x: CGFloat(5), y: CGFloat(internalY), width: reqStringWidth, height: CGFloat(22)))
            title.textColor = UIColor.black
            title.font = UIFont(name: "Helvetica-Bold", size: CGFloat(22.0))!
            title.text = self.linkJson["links"]["title"].string
            downloadableContainer.addSubview(title)
            
            if (self.linkJson["links"]["linksPurchasedSeparately"].string == "1") {
                var star: UILabel!
                let fieldX: CGFloat = reqStringWidth + 5
                star = UILabel(frame: CGRect(x: CGFloat(fieldX), y: CGFloat(internalY), width: CGFloat(10), height: CGFloat(23)))
                star.text = "*"
                star.textColor = UIColor().HexToColor(hexString: "df280a")
                downloadableContainer.addSubview(star)
                let reqAttributes = [NSAttributedStringKey.font: UIFont(name: "Trebuchet MS", size: CGFloat(17.0))!]
                let reqStringSize = "* Required Fields".size(withAttributes: reqAttributes)
                let reqStringWidth: CGFloat = reqStringSize.width
                let required = UILabel(frame: CGRect(x: CGFloat((self.mainView.frame.size.width - 20) - reqStringWidth), y: CGFloat(internalY), width: reqStringWidth, height: CGFloat(25)))
                required.textColor = UIColor().HexToColor(hexString: "df280a")
                required.font = UIFont(name: "Trebuchet MS", size: CGFloat(17.0))!
                required.text = GlobalData.sharedInstance.language(key: "requiredsfields")
                downloadableContainer.addSubview(required)
            }
            internalY += 35
            
            for i in 0..<self.linkJson["links"]["linkData"].count {
                let customOption = self.linkJson["links"]["linkData"][i]
                let linktitle = customOption["linkTitle"].string?.html2String
                var internalspaceX: CGFloat = 5
                if (self.linkJson["links"]["linksPurchasedSeparately"].string == "1") {
                    let checkBox = UISwitch(frame: CGRect(x: CGFloat(5), y: CGFloat(internalY), width: CGFloat(50), height: CGFloat(18)))
                    checkBox.isOn = false
                    checkBox.tag = i + 1
                    downloadableContainer.addSubview(checkBox)
                    internalspaceX = 60
                    internalY += 5
                    checkBox.addTarget(self, action: #selector(self.checkDownloadSwitchState), for: .valueChanged)
                }
                let reqAttributes = [NSAttributedStringKey.font: UIFont(name: "Trebuchet MS", size: CGFloat(22.0))!]
                let reqStringSize = linktitle?.size(withAttributes: reqAttributes)
                let reqStringWidth: CGFloat = reqStringSize!.width
                let required = UILabel(frame: CGRect(x: CGFloat(internalspaceX), y: CGFloat(internalY), width: reqStringWidth, height: CGFloat(22)))
                required.textColor = UIColor().HexToColor(hexString: "555555")
                required.font = UIFont(name: "Trebuchet MS", size: CGFloat(20.0))!
                required.text = linktitle
                downloadableContainer.addSubview(required)
                var pricespace: CGFloat = internalspaceX  +  reqStringWidth
                if (customOption["url"].string != nil)  {
                    let spacewidth = [NSAttributedStringKey.font: UIFont(name: "Trebuchet MS", size: CGFloat(16.0))!]
                    let reqSampleSize = (customOption["linkSampleTitle"].string)?.size(withAttributes: spacewidth)
                    let reqSampleWidth: CGFloat = reqSampleSize!.width
                    let tapGesture = UITapGestureRecognizer(target: self, action: #selector(self.linkSample))
                    tapGesture.numberOfTapsRequired = 1
                    let reqSampleleftSize = "(".size(withAttributes: spacewidth)
                    let reqSampleleftWidth: CGFloat = reqSampleleftSize.width
                    let leftbrace = UILabel(frame: CGRect(x: CGFloat(internalspaceX + reqStringWidth + 5), y: CGFloat(internalY), width: reqSampleleftWidth, height: CGFloat(20)))
                    leftbrace.text = "("
                    leftbrace.textColor = UIColor().HexToColor(hexString: "555555")
                    leftbrace.font = UIFont(name: "Trebuchet MS", size: CGFloat(16.0))!
                    downloadableContainer.addSubview(leftbrace)
                    let linkSample = UILabel(frame: CGRect(x: CGFloat(internalspaceX + reqStringWidth + 5 + reqSampleleftWidth), y: CGFloat(internalY), width: reqSampleWidth, height: CGFloat(20)))
                    linkSample.tag = i + 1
                    linkSample.text = customOption["linkSampleTitle"].string
                    linkSample.isUserInteractionEnabled = true
                    linkSample.textColor = UIColor().HexToColor(hexString: "268ED7")
                    linkSample.font = UIFont(name: "Trebuchet MS", size: CGFloat(16.0))!
                    linkSample.addGestureRecognizer(tapGesture)
                    downloadableContainer.addSubview(linkSample)
                    
                    let reqSamplerightSize = ")".size(withAttributes: spacewidth)
                    let reqSamplerightWidth: CGFloat = reqSamplerightSize.width
                    let rightbrace = UILabel(frame: CGRect(x: CGFloat(internalspaceX + reqStringWidth + reqSampleleftWidth + 5 + reqSampleWidth), y: CGFloat(internalY), width: reqSamplerightWidth, height: CGFloat(20)))
                    rightbrace.text = ")"
                    rightbrace.textColor = UIColor().HexToColor(hexString: "555555")
                    rightbrace.font = UIFont(name: "Trebuchet MS", size: CGFloat(16.0))!
                    downloadableContainer.addSubview(rightbrace)
                    pricespace += reqSampleWidth + reqSampleleftWidth + reqSamplerightWidth
                }
                if  customOption["price"].int! > 0 {
                    let reqAttributes = [NSAttributedStringKey.font: UIFont(name: "Trebuchet MS", size: CGFloat(20.0))!]
                    let reqStringSize = (customOption["formatedPrice"].string)?.size(withAttributes: reqAttributes)
                    let reqStringWidth: CGFloat = reqStringSize!.width
                    let price = UILabel(frame: CGRect(x: CGFloat(pricespace + 10), y: CGFloat(internalY), width: reqStringWidth, height: CGFloat(23)))
                    price.textColor = UIColor().HexToColor(hexString: "555555")
                    price.font = UIFont(name: "Trebuchet MS", size: CGFloat(18.0))!
                    price.text = customOption["formatedPrice"].string
                    downloadableContainer.addSubview(price)
                }
                if (self.linkJson["links"]["linksPurchasedSeparately"].string == "1") {
                    internalY += 30
                }
                else {
                    internalY += 24
                }
            }
            if self.linkJson["samples"]["linkSampleData"].count > 0 {
                internalY += 14
                for i in 0..<self.linkJson["samples"]["linkSampleData"].count {
                    let customOption = self.linkJson["samples"]["linkSampleData"][i]
                    let spacewidth = [NSAttributedStringKey.font: UIFont(name: "Trebuchet MS", size: CGFloat(16.0))!]
                    let reqSampleSize = (customOption["sampleTitle"].string)?.size(withAttributes: spacewidth)
                    let reqSampleWidth: CGFloat = reqSampleSize!.width
                    let samplelink = UILabel(frame: CGRect(x: CGFloat(5), y: CGFloat(internalY), width: reqSampleWidth, height: CGFloat(20)))
                    samplelink.text = customOption["sampleTitle"].string
                    samplelink.font = UIFont(name: "Trebuchet MS", size: CGFloat(16.0))!
                    samplelink.textColor = UIColor().HexToColor(hexString: "268ED7")
                    downloadableContainer.addSubview(samplelink)
                    internalY += 22
                }
            }
            
            var newFrame = downloadableContainer.frame
            newFrame.size.height = internalY + 10
            downloadableContainer.frame = newFrame
            self.mainContainerY += newFrame.size.height + 20
        }
    }
    
    //TODO:- Set up Bundle products
    func setUpBundleProducts()   {
        if(self.bundleJson["bundleOptions"].count > 0){
            let bundleContainer = UIView(frame: CGRect(x: CGFloat(5), y: CGFloat(self.mainContainerY), width: CGFloat(self.mainView.frame.size.width - 10), height: CGFloat(100)))
            bundleContainer.layer.borderColor = UIColor.appLightGrey.cgColor
            bundleContainer.tag = 9000
            bundleContainer.layer.borderWidth = 2.0
            self.otherView.addSubview(bundleContainer)
            var bundleInternalY:CGFloat = 5
            
            
            
            for i in 0..<self.bundleJson["bundleOptions"].count {
                let bundleCollection = self.bundleJson["bundleOptions"][i]
                
                if bundleCollection["type"] == "select" || bundleCollection["type"] == "radio" {
                    
                    
                    self.bundleCount = 0
                    for _: Any in bundleCollection["optionValues"] {
                        self.bundleCount += 1
                    }
                    
                    let titleAttributes = [NSAttributedStringKey.font: UIFont(name: REGULARFONT, size: CGFloat(14))!]
                    let titleStringSize = (bundleCollection["default_title"].string)?.size(withAttributes: titleAttributes)
                    var titleStringWidth: CGFloat = titleStringSize!.width
                    let defaulttitle = UILabel(frame: CGRect(x: CGFloat(5), y: CGFloat(bundleInternalY), width: titleStringWidth, height: CGFloat(23)))
                    defaulttitle.textColor = UIColor.textHeading
                    defaulttitle.font = UIFont(name: REGULARFONT, size: CGFloat(14))!
                    defaulttitle.text = bundleCollection["default_title"].string
                    bundleContainer.addSubview(defaulttitle)
                    
                    if (bundleCollection["required"].string == "1") && self.bundleCount == 1 {
                        titleStringWidth += 4
                        let requiredStar = UILabel(frame: CGRect(x: CGFloat(titleStringWidth), y: CGFloat(bundleInternalY), width: CGFloat(10), height: CGFloat(23)))
                        requiredStar.text = "*"
                        requiredStar.textColor = UIColor().HexToColor(hexString: "df280a")
                        bundleContainer.addSubview(requiredStar)
                        let reqAttributes = [NSAttributedStringKey.font: UIFont(name: REGULARFONT, size: CGFloat(13))!]
                        let reqStringSize = GlobalData.sharedInstance.language(key: "requiredfieldsasterik").size(withAttributes: reqAttributes)
                        let reqStringWidth: CGFloat = reqStringSize.width
                        let required = UILabel(frame: CGRect(x: CGFloat((self.mainView.frame.size.width - 20) - reqStringWidth), y: CGFloat(bundleInternalY), width: reqStringWidth, height: CGFloat(25)))
                        required.textColor = UIColor().HexToColor(hexString: "df280a")
                        required.font = UIFont(name: REGULARFONT, size: CGFloat(13))!
                        
                        
                        
                        let singleBundleDict = bundleCollection["optionValues"][0]
                        
                        let titleAttributes = [NSAttributedStringKey.font: UIFont(name: REGULARFONT, size: CGFloat(13))!]
                        let titleStringSize = (singleBundleDict["title"].stringValue).size(withAttributes: titleAttributes)
                        let titleStringWidth: CGFloat = titleStringSize.width
                        let title = UILabel(frame: CGRect(x: CGFloat(5), y: CGFloat(bundleInternalY), width: titleStringWidth, height: CGFloat(23)))
                        title.textColor = UIColor.textHeading
                        title.backgroundColor = UIColor().HexToColor(hexString: "ffffff")
                        title.font = UIFont(name: REGULARFONT, size: CGFloat(13))!
                        title.text = singleBundleDict["title"].stringValue
                        bundleInternalY += 35
                        bundleContainer.addSubview(title)
                        
                        let qtyAttributes = [NSAttributedStringKey.font: UIFont(name: REGULARFONT, size: CGFloat(13))!]
                        let qtyStringSize = (GlobalData.sharedInstance.language(key: "qty") + ":").size(withAttributes: qtyAttributes)
                        let qtyStringWidth: CGFloat = qtyStringSize.width
                        let qty = UILabel(frame: CGRect(x: CGFloat(5), y: CGFloat(bundleInternalY), width: qtyStringWidth, height: CGFloat(23)))
                        qty.textColor = UIColor.textHeading
                        qty.font = UIFont(name: REGULARFONT, size: CGFloat(13))!
                        qty.text = GlobalData.sharedInstance.language(key: "qty")
                        bundleContainer.addSubview(qty)
                        
                        let qtyField = UITextField(frame: CGRect(x: CGFloat(qtyStringWidth + 15), y: CGFloat(bundleInternalY), width: CGFloat(46), height: CGFloat(40)))
                        qtyField.font = UIFont(name: "Trebuchet MS", size: CGFloat(18.0))!
                        qtyField.textColor = UIColor.textHeading
                        qtyField.text = "1"
                        qtyField.tag = i + 100
                        qtyField.keyboardType = .phonePad
                        qtyField.textAlignment = .center
                        qtyField.borderStyle = .roundedRect
                        bundleContainer.addSubview(qtyField)
                        bundleInternalY += 50
                        
                        
                        self.bundleSelectedData[bundleCollection["option_id"].string!] = (singleBundleDict["optionValueId"].string) as AnyObject
                    }
                    else{
                        let bundleArray = NSMutableArray()
                        bundleArray.add(GlobalData.sharedInstance.language(key: "chooseaselection"))
                        
                        for k in 0..<bundleCollection["optionValues"].count{
                            bundleArray.add(bundleCollection["optionValues"][k]["title"].string ?? " ")
                        }
                        
                        print(bundleArray)
                        
                        //print("sss",bundleCollection["optionValues"].count)
                        
                        self.bundleDisplayData[10000+i] = bundleArray
                        
                        if (bundleCollection["required"].string == "1"){
                            titleStringWidth += 4
                            let requiredStar = UILabel(frame: CGRect(x: CGFloat(titleStringWidth), y: CGFloat(bundleInternalY), width: CGFloat(10), height: CGFloat(23)))
                            requiredStar.text = "*"
                            requiredStar.textColor = UIColor().HexToColor(hexString: "df280a")
                            bundleContainer.addSubview(requiredStar)
                        }
                        bundleInternalY += 25
                        let bundleSelection = UILabel(frame: CGRect(x: CGFloat(5), y: CGFloat(bundleInternalY), width: CGFloat(bundleContainer.frame.size.width-10), height: CGFloat(35)))
                        bundleSelection.textColor = UIColor.textHeading
                        bundleSelection.backgroundColor = UIColor.clear
                        bundleSelection.font = UIFont(name: BOLDFONT, size: CGFloat(15))!
                        bundleSelection.text = GlobalData.sharedInstance.language(key: "chooseaselection")
                        bundleSelection.layer.borderColor = UIColor(red:222/255.0, green:225/255.0, blue:227/255.0, alpha: 1.0).cgColor
                        bundleSelection.layer.borderWidth = 2.0
                        bundleSelection.tag  = 10000 + i
                        bundleSelection.textAlignment = .center
                        bundleContainer.addSubview(bundleSelection)
                        bundleSelection.isUserInteractionEnabled = true
                        let configGesture = UITapGestureRecognizer(target: self, action: #selector(self.openBundleSelection))
                        configGesture.numberOfTapsRequired = 1
                        bundleSelection.addGestureRecognizer(configGesture)
                        
                        bundleInternalY += 50
                        let qtyAttributes = [NSAttributedStringKey.font: UIFont(name: REGULARFONT, size: CGFloat(13))!]
                        let qtyStringSize = (GlobalData.sharedInstance.language(key: "qty") + ":").size(withAttributes: qtyAttributes)
                        let qtyStringWidth: CGFloat = qtyStringSize.width
                        let qty = UILabel(frame: CGRect(x: CGFloat(5), y: CGFloat(bundleInternalY), width: qtyStringWidth, height: CGFloat(17)))
                        qty.textColor = UIColor.textHeading
                        qty.font = UIFont(name: REGULARFONT, size: CGFloat(13))!
                        qty.text = GlobalData.sharedInstance.language(key: "qty")
                        bundleContainer.addSubview(qty)
                        let qtyField1 = UITextField(frame: CGRect(x: CGFloat(qtyStringWidth + 15), y: CGFloat(bundleInternalY ), width: CGFloat(40), height: CGFloat(40)))
                        qtyField1.font = UIFont(name: "Trebuchet MS", size: CGFloat(18.0))!
                        qtyField1.textColor = UIColor.textHeading
                        qtyField1.text = "0"
                        qtyField1.tag = 100 + i
                        qtyField1.isUserInteractionEnabled = true
                        qtyField1.keyboardType = .phonePad
                        qtyField1.textAlignment = .center
                        qtyField1.borderStyle = .roundedRect
                        bundleContainer.addSubview(qtyField1)
                        
                        self.bundleSelectedData[bundleCollection["option_id"].string!] = "0" as AnyObject
                        bundleInternalY += 50
                        
                        print(self.bundleSelectedData)
                        
                    }
                }
                else{
                    for k in 0..<bundleCollection["optionValues"].count{
                        let checkBox = UISwitch(frame: CGRect(x: CGFloat(5), y: CGFloat(bundleInternalY), width: CGFloat(50), height: CGFloat(18)))
                        checkBox.isOn = false
                        checkBox.tag = k
                        bundleContainer.addSubview(checkBox)
                        
                        let titleLabel = UILabel(frame: CGRect(x: CGFloat(60), y: CGFloat(bundleInternalY + 5), width:bundleContainer.frame.size.width - 60, height: CGFloat(17)))
                        titleLabel.textColor = UIColor.textHeading
                        titleLabel.font = UIFont(name: REGULARFONT, size: CGFloat(14))!
                        titleLabel.text = bundleCollection["optionValues"][k]["title"].stringValue
                        bundleContainer.addSubview(titleLabel)
                        
                        bundleInternalY += 50
                    }
                }
            }
            
            var newFrame1 = bundleContainer.frame
            newFrame1.size.height = bundleInternalY
            bundleContainer.frame = newFrame1
            self.mainContainerY += (bundleInternalY + 21)
        }
    }
    
    //TODO:- Set up Custom Options products
    func setUpCustomOptionsProducts()   {
        
        print(self.customeJson["customOptions"].count)
        
        if( self.customeJson["customOptions"].count > 0){
            
            let customOptionContainer = UIView(frame: CGRect(x: CGFloat(5), y: CGFloat(self.mainContainerY), width: CGFloat(self.mainView.frame.size.width - 10), height: CGFloat(700)))
            customOptionContainer.layer.borderColor = UIColor.orange.cgColor
                //UIColor(red:222/255.0, green:225/255.0, blue:227/255.0, alpha: 1.0).cgColor
            customOptionContainer.tag = 4000
            customOptionContainer.layer.borderWidth = 2.0
            self.otherView.addSubview(customOptionContainer)
            
            //var customOptionInternalY: CGFloat = 5
            customOptionInternalY = 5
            let reqAttributes = [NSAttributedStringKey.font: UIFont(name: REGULARFONT, size: CGFloat(15))!]
            let reqStringSize = GlobalData.sharedInstance.language(key: "requiredfieldsasterik").size(withAttributes: reqAttributes)
            let reqStringWidth: CGFloat = reqStringSize.width
            let required = UILabel(frame: CGRect(x: CGFloat((self.mainView.frame.size.width - 20) - reqStringWidth), y: CGFloat(customOptionInternalY), width: reqStringWidth, height: CGFloat(25)))
            required.textColor = UIColor().HexToColor(hexString: "df280a")
            required.font = UIFont(name: REGULARFONT, size: CGFloat(15))!
            required.text = GlobalData.sharedInstance.language(key: "requiredsfields")
            customOptionContainer.addSubview(required)
            customOptionInternalY += 21
            
            var requiredStar: UILabel!
            for i in 0..<self.customeJson["customOptions"].count {
                
                let customOptionDict = self.customeJson["customOptions"][i]
                let titleAttributes = [NSAttributedStringKey.font: UIFont(name: REGULARFONT, size: CGFloat(15))!]
                let titleStringSize = (customOptionDict["title"].string)?.size(withAttributes: titleAttributes)
                let titleStringWidth: CGFloat = titleStringSize!.width
                var fieldX: CGFloat = 5
                
                let titleLabel = UILabel(frame: CGRect(x: CGFloat(fieldX), y: CGFloat(customOptionInternalY), width: titleStringWidth, height: CGFloat(23)))
                titleLabel.textColor = UIColor().HexToColor(hexString: "555555")
                titleLabel.font = UIFont(name: REGULARFONT, size: CGFloat(15))!
                titleLabel.text = customOptionDict["title"].string
                customOptionContainer.addSubview(titleLabel)
                fieldX += titleStringWidth
                
                if (customOptionDict["is_require"].string == "1") {
                    fieldX += 3
                    requiredStar = UILabel(frame: CGRect(x: CGFloat(fieldX), y: CGFloat(customOptionInternalY), width: CGFloat(10), height: CGFloat(23)))
                    requiredStar.text = "*"
                    requiredStar.textColor = UIColor().HexToColor(hexString: "df280a")
                    customOptionContainer.addSubview(requiredStar)
                }
                
                if (customOptionDict["unformated_price"].int)! > 0 {
                    fieldX += 10
                    var additionalPriceString = ""
                    if (customOptionDict["price_type"] == "fixed") {
                        additionalPriceString = "+\(customOptionDict["formated_price"])"
                    }else {
                        var price: Float = self.customeJson["price"].floatValue
                        price = (price / 100) * customOptionDict["unformated_price"].floatValue
                        additionalPriceString = String(format: "+%.02f", price)
                    }
                    let priceAttributes = [NSAttributedStringKey.font: UIFont(name: REGULARFONT, size: CGFloat(15))!]
                    let priceStringSize = additionalPriceString.size(withAttributes: priceAttributes)
                    let priceStringWidth: CGFloat = priceStringSize.width
                    let price = UILabel(frame: CGRect(x: CGFloat(fieldX), y: CGFloat(customOptionInternalY), width: priceStringWidth, height: CGFloat(23)))
                    price.textColor = UIColor().HexToColor(hexString: "555555")
                    price.font = UIFont(name: REGULARFONT, size: CGFloat(15))!
                    price.text = additionalPriceString
                    customOptionContainer.addSubview(price)
                }
                
                customOptionInternalY += 25
                
                if (customOptionDict["type"].string == "field") {
                    
                    self.createDynamicTextField(customOptionDict:customOptionDict,
                                                customOptionContainer: customOptionContainer, i: i)
                    customOptionInternalY += 10
                }
                else if (customOptionDict["type"].string == "area") {
                    
                    self.createDynamicTextView(customOptionDict:customOptionDict, customOptionContainer: customOptionContainer, i: i)
                    customOptionInternalY += 10
                }
                else if (customOptionDict["type"].string == "file") {
                    
                    self.createDynamicUIbutton(customOptionDict: customOptionDict, customOptionContainer: customOptionContainer, i: i)
                    
                }
                else if (customOptionDict["type"].string == "drop_down") || (customOptionDict["type"].string == "radio") {
                    
                    self.createDynamicRadioOrDropDown(customOptionDict: customOptionDict, customOptionContainer: customOptionContainer, i: i)
                    customOptionInternalY += 50
                    
                    let  customeArray = NSMutableArray()
                    customeArray.add(GlobalData.sharedInstance.language(key: "chooseaselection"))
                    let customeKeyArray = NSMutableArray()
                    for k in 0..<customOptionDict["optionValues"].count {
                        let dict = customOptionDict["optionValues"][k]
                        
                        customeKeyArray.add(dict["option_type_id"])
                        let priceType = dict["price_type"].string
                        let value =  dict["price"].floatValue
                        let default_title = dict["default_title"].string ?? " "
                        var additionalPriceString = ""
                        if (priceType == "fixed") {
                            additionalPriceString = dict["formated_price"].stringValue
                        }else {
                            var price: Float = self.customeJson["price"].floatValue
                            price = (price / 100) *  value
                            additionalPriceString = String(format: "+%.02f", price)
                        }
                        if value > 0 {
                            customeArray.add(default_title + " " + additionalPriceString)
                        }else {
                            customeArray.add(default_title )
                        }
                    }
                    
                    self.customeCollectionDisplayData[i + 1] = customeArray
                    self.customePickerKeyValue [ i + 1] = customeKeyArray
                    
                }
                else if (customOptionDict["type"] == "checkbox") || (customOptionDict["type"] == "multiple") {
                    
                    self.createDynamicCheckBoxOrMultiSelect(customOptionDict: customOptionDict, customOptionContainer: customOptionContainer, i: i)
                    
                }
                else if (customOptionDict["type"].string == "date") || (customOptionDict["type"].string == "date_time") || (customOptionDict["type"].string == "time") {
                    let dateTimeLabel = UILabel(frame: CGRect(x: CGFloat(5), y: CGFloat(customOptionInternalY), width: CGFloat(customOptionContainer.frame.size.width - 10), height: CGFloat(36)))
                    dateTimeLabel.textColor = UIColor().HexToColor(hexString: "636363")
                    dateTimeLabel.backgroundColor = UIColor.clear
                    dateTimeLabel.font = UIFont(name: BOLDFONT, size: CGFloat(15))!
                    dateTimeLabel.tag = i + 1
                    dateTimeLabel.layer.borderColor = UIColor(red:222/255.0, green:225/255.0, blue:227/255.0, alpha: 1.0).cgColor
                    dateTimeLabel.layer.borderWidth = 2.0
                    dateTimeLabel.textAlignment = .center
                    dateTimeLabel.isUserInteractionEnabled = true
                    if (customOptionDict["type"].string == "date") {
                        dateTimeLabel.text = GlobalData.sharedInstance.language(key: "selectdate")
                    }
                    if (customOptionDict["type"].string == "date_time") {
                        dateTimeLabel.text =  GlobalData.sharedInstance.language(key: "selectdateandtime")
                    }
                    if (customOptionDict["type"].string == "time") {
                        dateTimeLabel.text = GlobalData.sharedInstance.language(key: "selecttime")
                    }
                    customOptionContainer.addSubview(dateTimeLabel)
                    let tap = UITapGestureRecognizer(target: self, action: #selector(self.showDateTimeShowOptions))
                    dateTimeLabel.addGestureRecognizer(tap)
                    customOptionInternalY += 50
                }
                
                if i < self.customeJson["customOptions"].count - 1 {
                    let hr1 = UIView(frame: CGRect(x: CGFloat(5), y: CGFloat(customOptionInternalY), width: CGFloat(customOptionContainer.frame.size.width - 10), height: CGFloat(1)))
                    hr1.backgroundColor = UIColor().HexToColor(hexString: "C8C4C4")
                    customOptionContainer.addSubview(hr1)
                    customOptionInternalY += 11
                }
            }
            var newFrame = customOptionContainer.frame
            newFrame.size.height = customOptionInternalY
            customOptionContainer.frame = newFrame
            self.mainContainerY += (customOptionInternalY + 21)
        }
    }
    
    func createDynamicTextField(customOptionDict:JSON, customOptionContainer:UIView, i:Int){
        
        let fieldField = UITextField(frame: CGRect(x: CGFloat(5), y: CGFloat(customOptionInternalY), width: CGFloat(customOptionContainer.frame.size.width - 10), height: CGFloat(35)))
        fieldField.font = UIFont(name: "Trebuchet MS", size: CGFloat(16.0))!
        fieldField.textColor = UIColor.black
        fieldField.tag = i + 1
        fieldField.layer.borderWidth = 1.0
        fieldField.layer.borderColor = UIColor(red:222/255.0, green:225/255.0, blue:227/255.0, alpha: 1.0).cgColor
        fieldField.textAlignment = .left
        fieldField.borderStyle = .roundedRect
        customOptionContainer.addSubview(fieldField)
        customOptionInternalY += 40
        if (customOptionDict["max_characters"].string) != nil {
            customOptionInternalY -= 5
            let fieldHintAttributes = [NSAttributedStringKey.font: UIFont(name: REGULARFONT, size: CGFloat(13))!]
            let fieldHintStringSize = "\(GlobalData.sharedInstance.language(key: "maximumnumberofcharacters")) \(customOptionDict["max_characters"].stringValue)".size(withAttributes: fieldHintAttributes)
            //let fieldHintStringWidth: CGFloat = fieldHintStringSize.width
            let fieldHint = UILabel(frame: CGRect(x: CGFloat(5), y: CGFloat(customOptionInternalY), width: SCREEN_WIDTH - 10, height: CGFloat(20)))
            fieldHint.textColor = UIColor().HexToColor(hexString: "555555")
            fieldHint.font = UIFont(name: REGULARFONT, size: CGFloat(13))!
            fieldHint.text = "\(GlobalData.sharedInstance.language(key: "maximumnumberofcharacters")) \(customOptionDict["max_characters"].stringValue)"
            customOptionContainer.addSubview(fieldHint)
            customOptionInternalY += 25
        }
        
    }
    
    func createDynamicTextView(customOptionDict:JSON, customOptionContainer:UIView, i:Int) {
        let textArea = UITextView(frame: CGRect(x: CGFloat(5), y: CGFloat(customOptionInternalY), width: CGFloat(customOptionContainer.frame.size.width - 10), height: CGFloat(100)))
        textArea.layer.borderWidth = 1.0
        textArea.textColor = UIColor.black
        textArea.layer.borderColor = UIColor(red:222/255.0, green:225/255.0, blue:227/255.0, alpha: 1.0).cgColor
        textArea.font = UIFont(name: "Trebuchet MS", size: CGFloat(16.0))!
        textArea.tag = i + 1
        //textArea.delegate! = self
        customOptionContainer.addSubview(textArea)
        customOptionInternalY += 105
        if customOptionDict["max_characters"].string != nil {
            customOptionInternalY -= 5
            let fieldHintAttributes = [NSAttributedStringKey.font: UIFont(name: REGULARFONT, size: CGFloat(13))!]
            let fieldHintStringSize = "\(GlobalData.sharedInstance.language(key: "maximumnumberofcharacters")) \(customOptionDict["max_characters"].stringValue)".size(withAttributes: fieldHintAttributes)
            let fieldHintStringWidth: CGFloat = fieldHintStringSize.width
            let fieldHint = UILabel(frame: CGRect(x: CGFloat(5), y: CGFloat(customOptionInternalY), width: fieldHintStringWidth, height: CGFloat(20)))
            fieldHint.textColor = UIColor().HexToColor(hexString: "555555")
            fieldHint.font = UIFont(name: REGULARFONT, size: CGFloat(13))!
            fieldHint.text = "\(GlobalData.sharedInstance.language(key: "maximumnumberofcharacters")) \(customOptionDict["max_characters"].stringValue)"
            customOptionContainer.addSubview(fieldHint)
            customOptionInternalY += 25
        }
    }
    
    func createDynamicUIbutton(customOptionDict:JSON, customOptionContainer:UIView, i:Int) {
        
        let filePickerBtn = UIButton(type: .custom)
        filePickerBtn.backgroundColor = UIColor().HexToColor(hexString: "268ED7")
        filePickerBtn.titleLabel!.font = UIFont(name: REGULARFONT, size: CGFloat(14))!
        filePickerBtn.setTitle (GlobalData.sharedInstance.language(key: "choosefile"), for: .normal)
        filePickerBtn.frame = CGRect(x: CGFloat(5), y: CGFloat(customOptionInternalY), width: CGFloat(150), height: CGFloat(35))
        customOptionContainer.addSubview(filePickerBtn)
        customOptionInternalY += 35
        filePickerBtn.tag = i
        filePickerBtn.addTarget(self, action: #selector(self.selectCustomOptionFile), for: .touchUpInside)
        customOptionFileEntry[customOptionDict["option_id"].stringValue] = false
        
        if customOptionDict["file_extension"].string != nil {
            let fileExtensionAttributes = [NSAttributedStringKey.font: UIFont(name: REGULARFONT, size: CGFloat(13))!]
            let fileExtensionStringSize = "\(GlobalData.sharedInstance.language(key: "allowedfileextensionstoupload")) \(customOptionDict["file_extension"].stringValue)".size(withAttributes: fileExtensionAttributes)
            let fileExtensionStringWidth: CGFloat = fileExtensionStringSize.width
            let fileExtension = UILabel(frame: CGRect(x: CGFloat(5), y: CGFloat(customOptionInternalY), width: fileExtensionStringWidth, height: CGFloat(17)))
            fileExtension.textColor = UIColor().HexToColor(hexString: "268ED7")
            fileExtension.font = UIFont(name: REGULARFONT, size: CGFloat(13))!
            fileExtension.text = "\(GlobalData.sharedInstance.language(key: "allowedfileextensionstoupload")) \(customOptionDict["file_extension"].stringValue)"
            customOptionContainer.addSubview(fileExtension)
            customOptionInternalY += 17
        }
        if  customOptionDict["image_size_x"].string !=  nil {
            let fileWidthAttributes = [NSAttributedStringKey.font: UIFont(name: REGULARFONT, size: CGFloat(13))!]
            let fileWidthStringSize = "\(GlobalData.sharedInstance.language(key: "maximumimagewidth")) \(customOptionDict["image_size_x"].stringValue) px.".size(withAttributes: fileWidthAttributes)
            let fileWidthStringWidth: CGFloat = fileWidthStringSize.width
            let fileWidth = UILabel(frame: CGRect(x: CGFloat(5), y: CGFloat(customOptionInternalY), width: fileWidthStringWidth, height: CGFloat(17)))
            fileWidth.textColor = UIColor().HexToColor(hexString: "555555")
            fileWidth.font = UIFont(name: REGULARFONT, size: CGFloat(13))!
            fileWidth.text = "\(GlobalData.sharedInstance.language(key: "maximumimagewidth")) \(customOptionDict["image_size_x"].stringValue) px."
            customOptionContainer.addSubview(fileWidth)
            customOptionInternalY += 17
        }
        if customOptionDict["image_size_y"].stringValue != "" {
            let fileHeightAttributes = [NSAttributedStringKey.font: UIFont(name: REGULARFONT, size: CGFloat(13))!]
            let fileHeightStringSize = "\(GlobalData.sharedInstance.language(key: "maximumimageheight")) \(customOptionDict["image_size_y"].stringValue) px.".size(withAttributes: fileHeightAttributes)
            let fileHeightStringWidth: CGFloat = fileHeightStringSize.width
            let fileHeight = UILabel(frame: CGRect(x: CGFloat(5), y: CGFloat(customOptionInternalY), width: fileHeightStringWidth, height: CGFloat(17)))
            fileHeight.textColor = UIColor().HexToColor(hexString: "555555")
            fileHeight.font = UIFont(name: REGULARFONT, size: CGFloat(13))!
            fileHeight.text = "\(GlobalData.sharedInstance.language(key: "maximumimageheight")) \(customOptionDict["image_size_y"].stringValue) px."
            customOptionContainer.addSubview(fileHeight)
            customOptionInternalY += 17
        }
    }
    
    func createDynamicRadioOrDropDown(customOptionDict:JSON, customOptionContainer:UIView, i:Int) {
        
        let customeSelection = UILabel(frame: CGRect(x: CGFloat(5), y: CGFloat(customOptionInternalY), width: CGFloat(customOptionContainer.frame.size.width-10), height: CGFloat(35)))
        customeSelection.textColor = UIColor.black
        customeSelection.backgroundColor = UIColor.clear
        customeSelection.font = UIFont(name: BOLDFONT, size: CGFloat(15))!
        customeSelection.text = GlobalData.sharedInstance.language(key: "chooseaselection")
        customeSelection.layer.borderColor = UIColor(red:222/255.0, green:225/255.0, blue:227/255.0, alpha: 1.0).cgColor
        customeSelection.layer.borderWidth = 2.0
        customeSelection.tag  =  i + 1
        customeSelection.textAlignment = .center
        customOptionContainer.addSubview(customeSelection)
        customeSelection.isUserInteractionEnabled = true
        let configGesture = UITapGestureRecognizer(target: self, action: #selector(self.openCustomeSelection))
        configGesture.numberOfTapsRequired = 1
        customeSelection.addGestureRecognizer(configGesture)
    }
    
    func createDynamicCheckBoxOrMultiSelect(customOptionDict:JSON, customOptionContainer:UIView, i:Int){
        
        var checkBoxContainerInternalY: CGFloat = 5
        let checkBoxContainer = UIView(frame: CGRect(x: CGFloat(5), y: CGFloat(customOptionInternalY), width: CGFloat(customOptionContainer.frame.size.width - 10), height: CGFloat((customOptionDict["optionValues"].count * 35) + 5)))
        checkBoxContainer.tag = i + 1 + 8000
        customOptionContainer.addSubview(checkBoxContainer)
        
        for i in 0..<(customOptionDict["optionValues"].arrayValue).count {
            let customDataDic = customOptionDict["optionValues"].arrayValue[i]
            
            let checkBox = UISwitch(frame: CGRect(x: CGFloat(5), y: CGFloat(checkBoxContainerInternalY), width: CGFloat(55), height: CGFloat(32)))
            checkBox.isOn = false
            checkBox.tag = i
            
            checkBoxContainer.addSubview(checkBox)
            //                        checkBox.addTarget(self, action: #selector(self.checkCustomeSwitchState), for: .valueChanged)
            var additionalPriceString = ""
            if (customDataDic["price_type"].stringValue == "fixed") {
                additionalPriceString += customDataDic["formated_price"].stringValue
            }else {
                var price: Float =  self.customeJson["price"].floatValue
                price = (price / 100) * customDataDic["price"].floatValue
                additionalPriceString = String(format: "+%.02f", price)
            }
            let checkboxLabel = UILabel(frame: CGRect(x: CGFloat(60), y: CGFloat(checkBoxContainerInternalY + 5), width: CGFloat(checkBoxContainer.frame.size.width - 65), height: CGFloat(25)))
            checkboxLabel.textColor =  UIColor().HexToColor(hexString: "636363")
            checkboxLabel.backgroundColor = UIColor.clear
            checkboxLabel.font = UIFont(name: REGULARFONT, size: CGFloat(15))!
            if customDataDic["price"].floatValue > 0 {
                checkboxLabel.text = customDataDic["default_title"].stringValue  + " " + additionalPriceString
            }else {
                checkboxLabel.text = customDataDic["default_title"].stringValue
            }
            checkBoxContainer.addSubview(checkboxLabel)
            checkBoxContainerInternalY += 35
        }
        
        customOptionInternalY  += checkBoxContainerInternalY + 10
    }
    
    
    //MARK:- @IBActions
    @IBAction func wishlistBtnClicked(_ sender: UIButton) {
        self.AddToWishList()
    }
    
    @IBAction func shareBtnClicked(_ sender: UIButton) {
        self.shareProduct()
    }
    
    @IBAction func compareBtnClicked(_ sender: UIButton) {
        callingHttppApi(apiType: CatalogProductAPI.addToCompare)
    }
    
    @IBAction func similarBtnClicked(_ sender: UIButton) {
        if self.catalogProductViewModel.relatedProduct.count > 0{
            let popOverVC = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "relatedproduct") as! RelatedProductController
            popOverVC.catalogProductViewModel = self.catalogProductViewModel
            popOverVC.modalPresentationStyle = .overFullScreen
            popOverVC.delegate = self
            popOverVC.modalTransitionStyle = .coverVertical
            self.present(popOverVC, animated: true, completion: nil)
        }else{
            AlertManager.shared.showInfoSnackBar(msg:"norelatedproductsavailable".localized)
        }
    }
    
    @IBAction func dismissKeyboard(_ sender: Any) {
        view.endEditing(true)
    }
    
    /* ranjit
    @IBAction func descriptionClick(_ sender: UITapGestureRecognizer) {
        let vc = self.storyboard?.instantiateViewController(withIdentifier: "ProductDescription") as! ProductDescription
        vc.descriptionData = catalogProductViewModel.catalogProductModel.descriptionData
        self.navigationController?.pushViewController(vc, animated: true)
    }*/
    
    @IBAction func totalReviewsClick(_ sender: UITapGestureRecognizer) {
        let vc = self.storyboard?.instantiateViewController(withIdentifier: "CatalogReviews") as! CatalogReviews
        vc.catalogProductViewModel = catalogProductViewModel
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    @IBAction func ratingViewClick(_ sender: UITapGestureRecognizer) {
        let vc = self.storyboard?.instantiateViewController(withIdentifier: "CatalogReviews") as! CatalogReviews
        vc.catalogProductViewModel = catalogProductViewModel
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    @IBAction func featureClick(_ sender: UITapGestureRecognizer) {
        /*
        let vc = self.storyboard?.instantiateViewController(withIdentifier: "ProductAdditionalFeature") as! ProductAdditionalFeature
        vc.catalogProductViewModel = catalogProductViewModel
        self.navigationController?.pushViewController(vc, animated: true)
        */
    }
    
    @IBAction func incrementDecrementValue(_ sender: UIStepper) {
        quantitytextField.text = String(format:"%d",Int(sender.value))
    }
    
    @objc func openZoomableImage(at Index:Int){
        //self.zoomAction(tappedIndex:Int(sender.accessibilityHint!)!)
        self.zoomAction(tappedIndex:Index)
        
        //        let homeDimSuperView = UIView(frame: CGRect(x: CGFloat(0), y: CGFloat(0), width: CGFloat(SCREEN_WIDTH), height: CGFloat(SCREEN_HEIGHT)))
        //        let homeDimView = UIView(frame: CGRect(x: CGFloat(40), y: CGFloat(80), width: CGFloat(SCREEN_WIDTH - 80), height: CGFloat(SCREEN_HEIGHT - 160)))
        //        homeDimView.backgroundColor = UIColor.white
        //        let currentWindow = UIApplication.shared.keyWindow
        //        homeDimView.tag = 888
        //        homeDimView.frame = (currentWindow?.bounds)!
        //        homeDimView.layer.cornerRadius = 30
        //        zoomImgVC = self.storyboard?.instantiateViewController(withIdentifier: "ZoomImageViewController") as! ZoomImageViewController
        //        self.addChildViewController(zoomImgVC)
        //        zoomImgVC.currentTag = Int(sender.accessibilityHint!)!
        //        zoomImgVC.imageArrayUrl = imageArrayUrl
        //        zoomImgVC.view.frame = CGRect(x: CGFloat(0), y: CGFloat(0), width: CGFloat(SCREEN_WIDTH), height: CGFloat(SCREEN_HEIGHT))
        //        homeDimView.addSubview(zoomImgVC.view)
        //        homeDimSuperView.addSubview(homeDimView)
        //        self.view.addSubview(homeDimSuperView)
    }
    
    @objc func selectCustomOptionFile(sender: UIButton!) {
        //var customOptionDict = self.customeJson["customOptions"][sender.tag]
        view.endEditing(true)
        currentTag = sender.tag
        let importMenu = UIDocumentMenuViewController(documentTypes: [String(kUTTypePNG),String(kUTTypeImage),String(kUTTypePDF),String(kUTTypeData)], in: .import)
        importMenu.delegate = self
        importMenu.view.tag = sender.tag
        importMenu.modalPresentationStyle = .popover
        importMenu.popoverPresentationController?.sourceView = self.view
        self.present(importMenu, animated: true, completion: nil)
    }
    
    @objc func swatchConfigSelection(_ recognizer: UITapGestureRecognizer) {
        
        for view in (recognizer.view?.superview?.subviews)! {
            if view is UILabel  {
                view.layer.borderColor = UIColor.appLightGrey.cgColor
            }
        }
        
        let selectedLabel:UILabel = recognizer.view as! UILabel
        selectedLabel.layer.borderWidth = 2.0
        selectedLabel.layer.borderColor = UIColor.black.cgColor
        selectedLabelTag = selectedLabel.tag
       
        
        if recognizer.view?.superview?.tag == 0{
            let attributeDict = self.configjson["configurableData"]["attributes"][0]
            configurableSelectedData[attributeDict["id"].stringValue] = String(format:"%d",(recognizer.view?.tag)!)
            for i in 0..<attributeDict["options"].count{
                if attributeDict["options"][i]["id"].stringValue == String(format:"%d",(recognizer.view?.tag)!){
                    configurableRelatedProducts[0] = attributeDict["options"][i]["products"].arrayObject! as NSArray
                    break
                }
            }
            self.defaultLaunch = false
            self.createConfigurableView()
            
        }else{
            let attributeDict = self.configjson["configurableData"]["attributes"][(recognizer.view?.superview?.tag)!]
            configurableSelectedData[attributeDict["id"].stringValue] = String(format:"%d",(recognizer.view?.tag)!)
            for i in 0..<attributeDict["options"].count{
                if attributeDict["options"][i]["id"].stringValue == String(format:"%d",(recognizer.view?.tag)!){
                    configurableRelatedProducts[(recognizer.view?.superview?.tag)!] = attributeDict["options"][i]["products"].arrayObject! as NSArray
                    break
                }
            }
        }
        
        if configurableDataImages.count > 0 {
            //change the image of configurable products
            selectedConfigurImg()
        }
    }
    
    func anyCommonElements (data1:NSArray,data2:NSArray)->Bool{
        for lhsItem in data1 {
            for rhsItem in data2 {
                if (lhsItem as! String) == (rhsItem as! String) {
                    print("equal value",lhsItem)
                    return true
                }
            }
        }
        return false
    }
    
    
    @objc func openConfigSelection(_ recognizer: UITapGestureRecognizer) {
        
        self.dynamicView.isUserInteractionEnabled = false
        let bounds = UIScreen.main.bounds
        let height = bounds.size.height
        let block = UIView(frame:CGRect(x: 0, y: height , width: SCREEN_WIDTH, height: 250))
        block.tag = 500
        block.backgroundColor = UIColor().HexToColor(hexString: "cbd0d6")
        self.view .addSubview(block)
        block.isHidden = true
        
        //////////////////////////////////////////////////////////////////////////////////////////
        
        pickerIndex = (recognizer.view?.tag)!
        
        if defaultLaunch == true || pickerIndex == 7000{
            print("if part execute")
            
            let configArray:NSMutableArray = []
            var configDummyDict = [String:AnyObject]()
            configDummyDict["label"] = "Please Select Option" as AnyObject
            configDummyDict["id"] = "0" as AnyObject
            configDummyDict["relatedproducts"] = NSArray()
            configArray.add(configDummyDict)
            let attributesvalues = self.configjson["configurableData"]["attributes"][pickerIndex - 7000]
            let attributesName = attributesvalues["options"]
            for i in 0..<attributesName.count{
                var configDummyDict = [String:AnyObject]()
                let dict = attributesName[i]
                configDummyDict["label"] = dict["label"].stringValue as AnyObject
                configDummyDict["id"] = dict["id"].stringValue as AnyObject
                configDummyDict["relatedproducts"] = dict["products"].arrayObject as AnyObject
                configArray.add(configDummyDict)
            }
            
            configurableData[pickerIndex] = configArray
            
            
        }else{
            
            print("else part execute")
            var combinedRelatedProducts:NSArray = []
            for i in 0..<pickerIndex - 7000{
                combinedRelatedProducts = combinedRelatedProducts.addingObjects(from:configurableRelatedProducts[i] as! [Any]) as NSArray
            }
            
            let attributesvalues = self.configjson["configurableData"]["attributes"][pickerIndex - 7000]
            let attributesName = attributesvalues["options"]
            let configArray:NSMutableArray = []
            var configDummyDict = [String:AnyObject]()
            configDummyDict["label"] = "Please Select Option" as AnyObject
            configDummyDict["id"] = "0" as AnyObject
            configDummyDict["relatedproducts"] = NSArray()
            configArray.add(configDummyDict)
            for i in 0..<attributesName.count{
                var configDummyDict = [String:AnyObject]()
                let dict = attributesName[i]
                if anyCommonElements(data1: dict["products"].arrayObject! as NSArray, data2: combinedRelatedProducts) == true{
                    configDummyDict["label"] = dict["label"].stringValue as AnyObject
                    configDummyDict["id"] = dict["id"].stringValue as AnyObject
                    configDummyDict["relatedproducts"] = dict["products"].arrayObject as AnyObject
                    configArray.add(configDummyDict)
                    
                    
                }
                
                
            }
            configurableData[pickerIndex] = configArray
        }
        
        
        let optionPicker = UIPickerView(frame: CGRect(x: 0, y: 50, width: SCREEN_WIDTH - 20, height: 180))
        optionPicker.tag = 7000
        optionPicker.showsSelectionIndicator = true
        optionPicker.isHidden = false
        optionPicker.delegate = self
        block.addSubview(optionPicker)
        optionPicker.showsSelectionIndicator = true
        
        let whiteBlock = UIView(frame:CGRect(x: 0, y: 0 , width: SCREEN_WIDTH, height: 50))
        whiteBlock.backgroundColor = UIColor().HexToColor(hexString: "eff0f1")
        block .addSubview(whiteBlock)
        
        var crossImage = UIImageView()
        crossImage = UIImageView(frame: CGRect(x: 10, y: 14, width: 22, height: 22))
        crossImage.image = UIImage(named: "ic_crossblack")
        whiteBlock.addSubview(crossImage)
        let crossTap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(self.crossBtn))
        whiteBlock.addGestureRecognizer(crossTap)
        
        var done = UILabel()
        done = UILabel(frame: CGRect(x: SCREEN_WIDTH - 80, y: 12, width:100, height: 25))
        done.textAlignment = .center
        done.font = UIFont(name:"Trebuchet MS", size: 16.0)
        done.text = "done".localized
        done.isUserInteractionEnabled = true
        done.textColor = UIColor.button
        whiteBlock.addSubview(done)
        
        UIView.animate(withDuration: 0.1, delay: 0.2, options: UIViewAnimationOptions.curveEaseIn, animations: {() -> Void in
            block.isHidden = false
            block.frame = CGRect(x: 0, y: height - 250 , width: SCREEN_WIDTH, height: 250)
            
        }, completion: {(_ finished: Bool) -> Void in
        })
        
        let optionTap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(self.doneBtn))
        done.addGestureRecognizer(optionTap)
    }
    
    
    @objc func crossBtn(_ recognizer: UITapGestureRecognizer) {
        let sortView = self.view.viewWithTag(500)!
        self.dynamicView.isUserInteractionEnabled = true
        sortView.removeFromSuperview()
    }
    
    @objc func doneBtn(_ recognizer: UITapGestureRecognizer) {
        //configurable products done button
        self.dynamicView.isUserInteractionEnabled = true
        let blockView:UIView = self.view.viewWithTag(500)!
        let configPicker:UIPickerView = blockView.viewWithTag(7000)! as! UIPickerView
        let row = Int(configPicker.selectedRow(inComponent: 0))
        let sortView = self.view.viewWithTag(500)!
        
        
        let configarray:NSMutableArray = configurableData[pickerIndex]! as NSMutableArray
        let labelName:UILabel = self.dynamicView.viewWithTag(pickerIndex) as! UILabel
        let attributedValue = configarray.object(at: row) as! [String:AnyObject]
        labelName.text = attributedValue["label"] as? String
        
        let attributesvalues = self.configjson["configurableData"]["attributes"][pickerIndex - 7000]
        
        if row > 0{
            let configArray:NSMutableArray = configurableData[pickerIndex]! as NSMutableArray
            let  attributedValue = configArray.object(at: row) as! [String:AnyObject]
            configurableSelectedData[attributesvalues["id"].stringValue] = attributedValue["id"] as? String
            
            configurableRelatedProducts[pickerIndex - 7000] = attributedValue["relatedproducts"] as? NSArray
            
        }else{
            configurableSelectedData[attributesvalues["id"].stringValue] = "0"
            configurableRelatedProducts[pickerIndex - 7000] = NSArray()
            
            
        }
        
        
        if pickerIndex == 7000 && row > 0{
            defaultLaunch = false
        }else if pickerIndex == 7000 && row == 0{
            defaultLaunch = true
        }
        
        
        if defaultLaunch == false{
            self.createConfigurableView()
        }
        
        
        print(configurableRelatedProducts)
        
        if configurableDataImages.count > 0 {
            //change the image of configurable products
            selectedConfigurImg()
        }
        
        self.mainView.isUserInteractionEnabled = true
        sortView.removeFromSuperview()
    }
    
    
    
    func convertToDictionary(text: String) -> [String: Any]? {
        if let data = text.data(using: .utf8) {
            do {
                return try JSONSerialization.jsonObject(with: data, options: []) as? [String: Any]
            } catch {
                print(error.localizedDescription)
            }
        }
        return nil
    }
    
    
    func convertToArray(text: String) -> AnyObject? {
        
        if let data = text.data(using: .utf8) {
            do {
                return try JSONSerialization.jsonObject(with: data, options: []) as? AnyObject
            } catch {
                print(error.localizedDescription)
            }
        }
        
        return nil
        
    }
    
    @objc func openBundleSelection(_ recognizer: UITapGestureRecognizer) {
        self.mainView.isUserInteractionEnabled = false
        let bounds = UIScreen.main.bounds
        let height = bounds.size.height
        let block = UIView(frame:CGRect(x: 0, y: height , width: SCREEN_WIDTH, height: 250))
        block.tag = 600
        block.backgroundColor = UIColor().HexToColor(hexString: "cbd0d6")
        self.view .addSubview(block)
        block.isHidden = true
        bundlePickerIndex = recognizer.view?.tag
        
        
        
        let optionPicker = UIPickerView(frame: CGRect(x: 0, y: 50, width: SCREEN_WIDTH - 20, height: 180))
        optionPicker.tag = 10000
        optionPicker.showsSelectionIndicator = true
        optionPicker.isHidden = false
        optionPicker.delegate = self
        block.addSubview(optionPicker)
        optionPicker.showsSelectionIndicator = true
        
        let whiteBlock = UIView(frame:CGRect(x: 0, y: 0 , width: SCREEN_WIDTH, height: 50))
        whiteBlock.backgroundColor = UIColor().HexToColor(hexString: "eff0f1")
        block .addSubview(whiteBlock)
        
        var crossImage = UIImageView()
        crossImage = UIImageView(frame: CGRect(x: 10, y: 14, width: 22, height: 22))
        crossImage.image = UIImage(named: "ic_crossblack")
        whiteBlock.addSubview(crossImage)
        
        let crossTap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(self.crossBundleBtn))
        whiteBlock.addGestureRecognizer(crossTap)
        
        var done = UILabel()
        done = UILabel(frame: CGRect(x: SCREEN_WIDTH - 80, y: 12, width:100, height: 25))
        done.textAlignment = .center
        done.font = UIFont(name:"Trebuchet MS", size: 16.0)
        done.text = "done".localized
        done.isUserInteractionEnabled = true
        done.textColor = UIColor().HexToColor(hexString: "#333333")
        whiteBlock.addSubview(done)
        
        UIView.animate(withDuration: 0.1, delay: 0.2, options: UIViewAnimationOptions.curveEaseIn, animations: {() -> Void in
            block.isHidden = false
            block.frame = CGRect(x: 0, y: height - 250 , width: SCREEN_WIDTH, height: 250)
            
        }, completion: {(_ finished: Bool) -> Void in
        })
        
        let optionTap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(self.doneBundleBtn))
        done.addGestureRecognizer(optionTap)
    }
    
    @objc func crossBundleBtn(_ recognizer: UITapGestureRecognizer) {
        let sortView = self.view.viewWithTag(600)!
        self.mainView.isUserInteractionEnabled = true
        sortView.removeFromSuperview()
    }
    
    @objc func doneBundleBtn(_ recognizer: UITapGestureRecognizer) {
        let blockView:UIView = self.view.viewWithTag(600)!
        let configPicker:UIPickerView = blockView.viewWithTag(10000)! as! UIPickerView
        let row = Int(configPicker.selectedRow(inComponent: 0))
        
        let Bundlearray:NSMutableArray = bundleDisplayData[bundlePickerIndex]! as NSMutableArray
        let labelName:UILabel = self.view.viewWithTag(bundlePickerIndex) as! UILabel
        labelName.text = Bundlearray.object(at: row) as? String
        
        let containerView:UIView = self.otherView.viewWithTag(9000)!
        let textField:UITextField = containerView.viewWithTag(bundlePickerIndex-10000 + 100) as! UITextField
        
        if(row > 0 ){
            textField.text = "1"
            
            let bundleCollection = self.bundleJson["bundleOptions"][bundlePickerIndex-10000]
            self.bundleSelectedData[bundleCollection["option_id"].string!] = bundleCollection["optionValues"][row-1]["optionValueId"].string as AnyObject
            
            //Type radio/select default qty
            if bundleCollection["type"].stringValue == "radio" || bundleCollection["type"].stringValue == "select" {
                let optionValues = bundleCollection["optionValues"].arrayValue
                
                for val in optionValues{
                    if (bundleCollection["optionValues"][row-1]["optionValueId"].string as AnyObject) as? String == val["optionValueId"].stringValue{
                        
                        if val["isDefault"].stringValue == "1" {
                            //default qty will be set
                            textField.text = String(val["defaultQty"].intValue)
                        }else{
                            //default qty will not be set
                            textField.text = "0"
                        }
                        
                        if val["isQtyUserDefined"].stringValue == "1" {
                            //user can edit qty
                            textField.isUserInteractionEnabled = true
                        }else{
                            //user cannot edit qty
                            textField.text = String(val["defaultQty"].intValue)
                            textField.isUserInteractionEnabled = false
                        }
                    }
                }
            }
        }
        
        if(row == 0){
            textField.text = "0"
            textField.isUserInteractionEnabled = true
            
            let bundleCollection = self.bundleJson["bundleOptions"][bundlePickerIndex-10000]
            self.bundleSelectedData[bundleCollection["option_id"].string!] = "0" as AnyObject
        }
        
        let sortView = self.view.viewWithTag(600)!
        self.mainView.isUserInteractionEnabled = true
        sortView.removeFromSuperview()
        
    }
    
    @objc func openCustomeSelection(_ recognizer: UITapGestureRecognizer) {
        self.mainView.isUserInteractionEnabled = false
        let bounds = UIScreen.main.bounds
        let height = bounds.size.height
        let block = UIView(frame:CGRect(x: 0, y: height , width: SCREEN_WIDTH, height: 250))
        block.tag = 900
        block.backgroundColor = UIColor().HexToColor(hexString: "cbd0d6")
        self.view .addSubview(block)
        block.isHidden = true
        customePickerIndex = recognizer.view?.tag
        
        
        let optionPicker = UIPickerView(frame: CGRect(x: 0, y: 50, width: SCREEN_WIDTH - 20, height: 180))
        optionPicker.tag = 11000
        optionPicker.showsSelectionIndicator = true
        optionPicker.isHidden = false
        optionPicker.delegate = self
        block.addSubview(optionPicker)
        optionPicker.showsSelectionIndicator = true
        
        let whiteBlock = UIView(frame:CGRect(x: 0, y: 0 , width: SCREEN_WIDTH, height: 50))
        whiteBlock.backgroundColor = UIColor().HexToColor(hexString: "eff0f1")
        block .addSubview(whiteBlock)
        
        var crossImage = UIImageView()
        crossImage = UIImageView(frame: CGRect(x: 10, y: 14, width: 22, height: 22))
        crossImage.image = UIImage(named: "ic_crossblack")
        whiteBlock.addSubview(crossImage)
        
        let crossTap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(self.crossCustomeBtn))
        whiteBlock.addGestureRecognizer(crossTap)
        
        var done = UILabel()
        done = UILabel(frame: CGRect(x: SCREEN_WIDTH - 80, y: 12, width:100, height: 25))
        done.textAlignment = .center
        done.font = UIFont(name:"Trebuchet MS", size: 16.0)
        done.text = "done".localized
        done.tag = (recognizer.view?.tag)!
        done.isUserInteractionEnabled = true
        done.textColor = UIColor().HexToColor(hexString: "#333333")
        whiteBlock.addSubview(done)
        
        UIView.animate(withDuration: 0.1, delay: 0.2, options: UIViewAnimationOptions.curveEaseIn, animations: {() -> Void in
            block.isHidden = false
            block.frame = CGRect(x: 0, y: height - 250 , width: SCREEN_WIDTH, height: 250)
            
        }, completion: {(_ finished: Bool) -> Void in
        })
        
        let optionTap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(self.doneCustomeBtn))
        done.addGestureRecognizer(optionTap)
        
        
    }
    
    @objc func crossCustomeBtn(_ recognizer: UITapGestureRecognizer) {
        let sortView = self.view.viewWithTag(900)!
        sortView.removeFromSuperview()
        self.mainView.isUserInteractionEnabled = true
    }
    
    @objc func doneCustomeBtn(_ recognizer: UITapGestureRecognizer) {
        let parent = otherView.viewWithTag(4000)!
        let dropTypeLabel:UILabel = parent.viewWithTag((recognizer.view?.tag)!)! as! UILabel
        
        let blockView:UIView = self.view.viewWithTag(900)!
        let configPicker:UIPickerView = blockView.viewWithTag(11000)! as! UIPickerView
        let row = Int(configPicker.selectedRow(inComponent: 0))
        let customeSelectedDataArray:NSMutableArray = customeCollectionDisplayData[(recognizer.view?.tag)!]!
        let stringValue:String = customeSelectedDataArray.object(at: row) as! String
        dropTypeLabel.text = stringValue
        
        if(row > 0){
            let customOptionDict = self.customeJson["customOptions"][((recognizer.view?.tag)! - 1)]
            let keyArray:NSMutableArray = customePickerKeyValue[(recognizer.view?.tag)!]!
            selectedCustomeOption[customOptionDict["option_id"].stringValue] = String(format:"%@",keyArray.object(at: row-1) as! CVarArg) as AnyObject?
            selectedCustomeOptionWishList[customOptionDict["option_id"].stringValue] = String(format:"%@",keyArray.object(at: row-1) as! CVarArg)
        }
        
        
        let sortView = self.view.viewWithTag(900)!
        sortView.removeFromSuperview()
        self.mainView.isUserInteractionEnabled = true
        
    }
    
    
    @objc func showDateTimeShowOptions(_ recognizer: UITapGestureRecognizer) {
        self.mainView.isUserInteractionEnabled = false
        let bounds = UIScreen.main.bounds
        let height = bounds.size.height
        let block = UIView(frame:CGRect(x: 0, y: height , width: SCREEN_WIDTH, height: 250))
        block.tag = 800
        block.backgroundColor = UIColor().HexToColor(hexString: "cbd0d6")
        self.view .addSubview(block)
        block.isHidden = true
        
        let customOptionDict = self.customeJson["customOptions"][(recognizer.view?.tag)! - 1]
        
        let datePicker = UIDatePicker(frame: CGRect(x: CGFloat(0), y: 50, width: CGFloat(SCREEN_WIDTH - 20), height: CGFloat(200)))
        datePicker.tag = 9999
        if (customOptionDict["type"].string == "date") {
            datePicker.datePickerMode = .date
        }
        if (customOptionDict["type"].string == "date_time") {
            datePicker.datePickerMode = .dateAndTime
        }
        if (customOptionDict["type"].string == "time") {
            datePicker.datePickerMode = .time
        }
        block.addSubview(datePicker)
        
        
        let whiteBlock = UIView(frame:CGRect(x: 0, y: 0 , width: SCREEN_WIDTH, height: 50))
        whiteBlock.backgroundColor = UIColor().HexToColor(hexString: "eff0f1")
        block .addSubview(whiteBlock)
        
        var crossImage = UIImageView()
        crossImage = UIImageView(frame: CGRect(x: 10, y: 14, width: 22, height: 22))
        crossImage.image = UIImage(named: "ic_crossblack")
        crossImage.tag =  (recognizer.view?.tag)!
        whiteBlock.addSubview(crossImage)
        whiteBlock.tag = (recognizer.view?.tag)!
        let crossTap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(self.crossCustomeDateBtn))
        whiteBlock.addGestureRecognizer(crossTap)
        
        var done = UILabel()
        done = UILabel(frame: CGRect(x: SCREEN_WIDTH - 80, y: 12, width:100, height: 25))
        done.textAlignment = .center
        done.font = UIFont(name:"Trebuchet MS", size: 16.0)
        done.text = "done".localized
        done.isUserInteractionEnabled = true
        done.textColor = UIColor().HexToColor(hexString: "#333333")
        done.tag = (recognizer.view?.tag)!
        whiteBlock.addSubview(done)
        
        UIView.animate(withDuration: 0.1, delay: 0.2, options: UIViewAnimationOptions.curveEaseIn, animations: {() -> Void in
            block.isHidden = false
            block.frame = CGRect(x: 0, y: height - 250 , width: SCREEN_WIDTH, height: 250)
            
        }, completion: {(_ finished: Bool) -> Void in
        })
        
        let optionTap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(self.doneCustomeDateBtn))
        done.addGestureRecognizer(optionTap)
    }
    
    
    
    @objc func crossCustomeDateBtn(_ recognizer: UITapGestureRecognizer) {
        self.tabBarController!.tabBar.isHidden = false
        let sortView = self.view.viewWithTag(800)!
        self.mainView.isUserInteractionEnabled = true
        
        let customOptionDict = self.customeJson["customOptions"][(recognizer.view?.tag)! - 1]
        let parent = otherView.viewWithTag(4000)!
        let dateTimeLabel : UILabel = parent.viewWithTag((recognizer.view?.tag)!)! as! UILabel
        if (customOptionDict["type"] == "date") {
            dateTimeLabel.text = "Select Date"
        }
        if (customOptionDict["type"] == "date_time") {
            dateTimeLabel.text = "Select Date and Time"
        }
        if (customOptionDict["type"] == "time") {
            dateTimeLabel.text = "Select Time"
        }
        sortView.removeFromSuperview()
    }
    
    
    @objc func doneCustomeDateBtn(_ recognizer: UITapGestureRecognizer) {
        let sortView = self.view.viewWithTag(800)!
        self.mainView.isUserInteractionEnabled = true
        
        let datePicker:UIDatePicker = self.view.viewWithTag(9999)! as! UIDatePicker
        let date = datePicker.date
        let components = Calendar.current.dateComponents([.day, .month, .year, .hour, .minute], from: date)
        let parent = otherView.viewWithTag(4000)!
        let dateTimeLabel:UILabel = parent.viewWithTag((recognizer.view?.tag)!)! as! UILabel
        let customOptionDict = self.customeJson["customOptions"][(recognizer.view?.tag)! - 1]
        
        if (customOptionDict["type"].string == "date") {
            let month = "\(Int(components.month!))"
            let day = "\(Int(components.day!))"
            let year = "\(Int(components.year!))"
            dateDict = [String:String]()
            dateTimeLabel.text = "\(day)| \(month) |\(year)"
            dateDict["month"] = "\(Int(components.month!))"
            dateDict["day"] = "\(Int(components.day!))"
            dateDict["year"] = "\(Int(components.year!))"
            selectedCustomeOption[customOptionDict["option_id"].stringValue] = dateDict as AnyObject?
        }
        if (customOptionDict["type"] == "date_time") {
            let month = "\(Int(components.month!))"
            let day = "\(Int(components.day!))"
            let year = "\(Int(components.year!))"
            let hour = "\(Int(components.hour!))"
            let minute = "\(Int(components.minute!))"
            dateTimeLabel.text = "\(day)|\(month)|\(year) :: \(hour):\(minute) "
            dateTimeDict = [String:String]()
            
            dateTimeDict["month"] = "\(Int(components.month!))"
            dateTimeDict["day"] = "\(Int(components.day!))"
            dateTimeDict["year"] = "\(Int(components.year!))"
            dateTimeDict["hour"] = "\(Int(components.hour!))"
            dateTimeDict["minute"] = "\(Int(components.minute!))"
            let formatter = DateFormatter()
            formatter.dateFormat = "a"
            dateTimeDict["day_part"] = formatter.string(from: date)
            selectedCustomeOption[customOptionDict["option_id"].stringValue] = dateTimeDict as AnyObject?
        }
        if (customOptionDict["type"].string == "time") {
            let hour = "\(Int(components.hour!))"
            let minute = "\(Int(components.minute!))"
            dateTimeLabel.text = " \(hour):\(minute) "
            timeDict = [String:String]()
            timeDict["hour"] = "\(Int(components.hour!))"
            timeDict["minute"] = "\(Int(components.minute!))"
            let formatter = DateFormatter()
            formatter.dateFormat = "a"
            timeDict["day_part"] = formatter.string(from: date)
            selectedCustomeOption[customOptionDict["option_id"].stringValue] = timeDict as AnyObject?
        }
        
        sortView.removeFromSuperview()
    }
    
    @objc func linkSample(_ recognizer: UITapGestureRecognizer) {
    }
    
    @objc func checkDownloadSwitchState(_ sender: Any) {}
    
    @IBAction func addToCart(_ sender: UIButton) {
        
        var isValid:Int = 1
        var errorMessage:String = GlobalData.sharedInstance.language(key:"pleaseselect")
        let multipleBundleData:NSMutableArray = []
        
        ///////////////////////////////////// downloadble Data  ////////// ////////////////////////////////////////
        
        if (self.linkJson["links"].count > 0) {
            if (self.linkJson["links"]["linksPurchasedSeparately"].string == "1") {
                var isSwitchOn = 0
                let downloadOptionUIView = otherView.viewWithTag(6000)!
                for i in 0..<self.linkJson["links"]["linkData"].count {
                    let linksOption = self.linkJson["links"]["linkData"][i]
                    let switchValue:UISwitch = downloadOptionUIView.viewWithTag(i + 1)! as! UISwitch
                    if switchValue.isOn {
                        isSwitchOn = 1
                        selectedDownloadableProduct[linksOption["id"].string!] = linksOption["id"].string
                    }
                }
                if isSwitchOn == 0 {
                    isValid = 0
                    goToBagFlag = false
                    errorMessage = "Select at Least One Option"
                    AlertManager.shared.showErrorSnackBar(msg: errorMessage)
                }
            }
        }
        
        /////////////////////////////////////////// grouped data //////////////////////////////////////////////////
        
        
        if self.groupjson["groupedData"].count > 0{
            var oneGroupdProductSelected:Int = 0
            let groupedUIView = otherView.viewWithTag(5000)! as UIView
            for i in 0..<(self.groupjson["groupedData"].count){
                let groupedDataDict = self.groupjson["groupedData"][i]
                let textField : UITextField = groupedUIView .viewWithTag(i + 1) as! UITextField
                
                if (groupedDataDict["isAvailable"].int == 1) {
                    if(textField .text == "0"  || textField.text == ""){}
                    else{
                        oneGroupdProductSelected = 1
                        selectedGroupedProduct[groupedDataDict["id"].string!] = textField.text
                    }
                }}
            if oneGroupdProductSelected == 0{
                isValid = 0
                goToBagFlag = false
                errorMessage = "Please enter quantity greater than zero to add to cart"
                AlertManager.shared.showErrorSnackBar(msg: errorMessage)
            }
        }
        
        ///////////////////////////////////// bundle Data //////////////////////////////////////////////////////////
        
        if(self.bundleJson["bundleOptions"].count > 0){
            let containerView:UIView = self.view.viewWithTag(9000)!
            for i in 0..<self.bundleJson["bundleOptions"].count {
                let bundleCollection = self.bundleJson["bundleOptions"][i]
                if bundleCollection["type"] == "select" || bundleCollection["type"] == "radio" {
                    let textField:UITextField = containerView.viewWithTag(i + 100) as! UITextField
                    
                    if self.bundleSelectedData[bundleCollection["option_id"].string!] == ("0" as AnyObject as! _OptionalNilComparisonType){
                        isValid = 0
                        var title:String =  bundleCollection["title"].string!
                        title += " is Required Field"
                        AlertManager.shared.showErrorSnackBar(msg: title)
                    }
                    if(textField.text == "0" || textField.text == ""){
                        isValid = 0
                        errorMessage = "pleasefilltheqty".localized
                        AlertManager.shared.showErrorSnackBar(msg: errorMessage)
                    }
                    if(isValid == 1){
                        selectedBundleProductQuantity[bundleCollection["option_id"].string!] = textField.text
                    }
                }else{
                    for k in 0..<bundleCollection["optionValues"].count{
                        let switchValue:UISwitch = containerView.viewWithTag(k) as! UISwitch
                        
                        if switchValue.isOn{
                            let optionValue:String = bundleCollection["optionValues"][k]["optionValueId"].stringValue
                            multipleBundleData.add(optionValue)
                        }
                    }
                    if multipleBundleData.count > 0{
                        isValid = 1
                        self.bundleSelectedData[bundleCollection["option_id"].string!] = multipleBundleData
                    }else{
                        isValid = 0
                        goToBagFlag = false
                        errorMessage = "Please Select at Least one Option"
                        AlertManager.shared.showErrorSnackBar(msg: errorMessage)
                    }
                }
            }
        }
        
        ///////////////////////////////// custom product //////////////////////////////////////////////////////////////////////////
        
        if(self.customeJson["customOptions"].count > 0){
            let customOptionUIView = otherView.viewWithTag(4000)!
            for i in 0..<customeJson["customOptions"].count {
                let customOptionDict = customeJson["customOptions"][i]
                if  customOptionDict["is_require"].intValue == 1 {
                    if (customOptionDict["type"].string == "field") {
                        let tempField:UITextField = customOptionUIView.viewWithTag(i + 1)! as! UITextField
                        if tempField.text == "" {
                            isValid = 0
                            errorMessage = "\(customOptionDict["title"].stringValue) is a required field"
                            tempField.layer.borderColor = UIColor.red.cgColor
                        }else {
                            selectedCustomeOption[customOptionDict["option_id"].stringValue] = tempField.text as AnyObject?
                        }
                    }else if (customOptionDict["type"] == "area") {
                        let tempArea:UITextView = customOptionUIView.viewWithTag(i + 1)! as! UITextView
                        if tempArea.text == "" {
                            isValid = 0
                            if (errorMessage == "") {
                                errorMessage = "\(customOptionDict["title"].stringValue) is a required field"
                            }
                            tempArea.layer.borderColor = UIColor.red.cgColor
                        }else {
                            selectedCustomeOption[customOptionDict["option_id"].stringValue] = tempArea.text as AnyObject?
                        }
                    }else if (customOptionDict["type"].string == "checkbox") || (customOptionDict["type"].string == "multiple") {
                        let tempSwitchArea:UIView = customOptionUIView.viewWithTag(i + 1 + 8000)!
                        var isSwitchOn = 0
                        let selectedOption = NSMutableArray()
                        for i in 0..<customOptionDict["optionValues"].arrayValue.count {
                            
                            let checkBoxTag = i
                            let tempSwitch:UISwitch = tempSwitchArea.viewWithTag(checkBoxTag) as! UISwitch
                            if tempSwitch.isOn {
                                isSwitchOn = 1
                                selectedOption.add(((customOptionDict["optionValues"].arrayValue)[i].dictionaryObject!["option_type_id"] as! String))
                            }
                        }
                        if isSwitchOn == 0 {
                            isValid = 0
                            if (errorMessage == "") {
                                errorMessage =  customOptionDict["title"].stringValue +  " is a required field"
                            }
                        }else {
                            selectedCustomeOption[customOptionDict["option_id"].stringValue] = selectedOption
                        }
                    }else if customOptionDict["type"].stringValue == "file" {
                        if customOptionFileEntry[customOptionDict["option_id"].stringValue] == false{
                            isValid = 0
                            errorMessage = "Please upload the"+" "+customOptionDict["title"].stringValue
                        }
                    }
                }else{
                    if (customOptionDict["type"].string == "field") {
                        let tempField:UITextField = customOptionUIView.viewWithTag(i + 1)! as! UITextField
                        selectedCustomeOption[customOptionDict["option_id"].stringValue] = tempField.text as AnyObject?
                    }
                    if (customOptionDict["type"].string == "area") {
                        let tempArea:UITextView = customOptionUIView.viewWithTag(i + 1)! as! UITextView
                        selectedCustomeOption[customOptionDict["option_id"].stringValue] = tempArea.text as AnyObject?
                    }
                    if (customOptionDict["type"].string == "checkbox") || (customOptionDict["type"].string == "multiple") {
                        let tempSwitchArea:UIView = customOptionUIView.viewWithTag(i + 1)!
                        let selectedOption = NSMutableArray()
                        for (key,_):(String, JSON) in customOptionDict["optionValues"].dictionaryValue {
                            let checkBoxTag = Int(key)
                            let tempSwitch:UISwitch = tempSwitchArea.viewWithTag(checkBoxTag!) as! UISwitch
                            if tempSwitch.isOn {
                                selectedOption.add(key)
                            }
                        }
                        selectedCustomeOption[customOptionDict["option_id"].stringValue] = selectedOption
                    }
                }
                if (customOptionDict["type"].string == "radio") || (customOptionDict["type"].string == "drop_down") {
                    let tempPicker:UILabel = customOptionUIView.viewWithTag(i + 1)! as! UILabel
                    
                    if(tempPicker.text == GlobalData.sharedInstance.language(key: "chooseaselection"))  {
                        isValid = 0
                        errorMessage = GlobalData.sharedInstance.language(key: "chooseaselection")
                    }
                }
                if (customOptionDict["type"].string == "date") || (customOptionDict["type"].string == "date_time") || (customOptionDict["type"].string == "time") {
                    let tempDatePicker:UILabel = customOptionUIView.viewWithTag(i + 1)! as! UILabel
                    if (customOptionDict["type"].string == "date") {
                        if (tempDatePicker.text == GlobalData.sharedInstance.language(key: "selectdate")) {
                            isValid = 0
                            errorMessage = GlobalData.sharedInstance.language(key: "selectdate")
                        }
                    }
                    if (customOptionDict["type"].string == "date_time") {
                        if (tempDatePicker.text == GlobalData.sharedInstance.language(key: "selectdateandtime")) {
                            isValid = 0
                            errorMessage = GlobalData.sharedInstance.language(key: "selectdateandtime")
                        }
                    }
                    if (customOptionDict["type"].string == "time") {
                        if (tempDatePicker.text == GlobalData.sharedInstance.language(key: "selecttime")) {
                            isValid = 0
                            errorMessage = GlobalData.sharedInstance.language(key: "selecttime")
                        }
                    }
                }
            }
            
            if(isValid == 0){
                goToBagFlag = false
                AlertManager.shared.showErrorSnackBar(msg: errorMessage)
            }
        }
        
        ///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
        ////////////////////////////////////////////////////////////////Configurable ////////////////////////////////////////////////////////////////////////
        
        if self.configjson["configurableData"]["attributes"].count > 0 {
            for i in 0..<self.configjson["configurableData"]["attributes"].count {
                let attributesvalues  = self.configjson["configurableData"]["attributes"][i]
                
                if configurableSelectedData.count > 0   {
                    if configurableSelectedData[attributesvalues["id"].stringValue] == "0"{
                        errorMessage = errorMessage+attributesvalues["label"].stringValue
                        isValid = 0
                        break
                    }
                }else{
                    //configurable option is not selected
                    errorMessage = "pleaseselecttheconfigurableoptions".localized
                    isValid = 0
                    break
                }
            }
            
            if isValid == 0{
                goToBagFlag = false
                AlertManager.shared.showErrorSnackBar(msg: errorMessage)
            }
        }
        
        if(isValid == 1){
            if catalogProductViewModel.catalogProductModel.isAvailable == true{
                //addToCartIndicator.startAnimating()
                self.addProductToCart()
            }else{
                AlertManager.shared.showErrorSnackBar(msg: GlobalData.sharedInstance.language(key: "outofstock"))
            }
        }
    }
    
    func shareProduct() {
        let productUrl = catalogProductViewModel.catalogProductModel.shareUrl
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
    
    @IBAction func writeYOurReviewClick(_ sender: Any) {
        let vc = self.storyboard?.instantiateViewController(withIdentifier: "AddReview") as! AddReview
        vc.productId = self.productId
        vc.productName = self.productName
        vc.ratingFormData = catalogProductViewModel.catalogProductModel.ratingFormData
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    @IBAction func goToBag(_ sender: Any) {
        goToBagFlag = true
        self.addToCart(UIButton())
    }
    
    func zoomAction(tappedIndex: Int){
        let homeDimView = UIView(frame: CGRect(x: CGFloat(0), y: CGFloat(0), width: CGFloat(SCREEN_WIDTH), height: CGFloat(SCREEN_HEIGHT)))
        homeDimView.backgroundColor = UIColor.white
        let currentWindow = UIApplication.shared.keyWindow
        homeDimView.tag = 888
        homeDimView.frame = (currentWindow?.bounds)!
        
        let button:UIButton = UIButton(frame: CGRect(x:30, y: 30, width: 30, height: 30))
        button.backgroundColor = .clear
        //button.setTitle("X", for: .normal)
        let backImage = UIImage(named: "ic_arrow")?.withHorizontallyFlippedOrientation()
        button.setImage(backImage?.withRenderingMode(.alwaysTemplate), for:.normal)
        button.addTarget(self, action:#selector(self.closeZoomTap), for: .touchUpInside)
        button.tintColor = UIColor.black
        button.setCornerRadius(radius:5)
        button.layer.borderWidth = 1
        button.layer.borderColor = UIColor.black.cgColor
        homeDimView.addSubview(button)
        
        var X:CGFloat = 0
        
        parentZoomingScrollView = UIScrollView(frame: CGRect(x: CGFloat(0), y: CGFloat(60), width: CGFloat(SCREEN_WIDTH), height: CGFloat(SCREEN_HEIGHT - 120)))
        parentZoomingScrollView.isUserInteractionEnabled = true
        parentZoomingScrollView.tag = 888888
        parentZoomingScrollView.delegate = self
        homeDimView.addSubview(parentZoomingScrollView)
        
        for i in 0..<imageArrayUrl.count {
            childZoomingScrollView = UIScrollView(frame: CGRect(x: CGFloat(X), y: CGFloat(0), width: CGFloat(SCREEN_WIDTH), height: CGFloat(SCREEN_HEIGHT - 120)))
            childZoomingScrollView.isUserInteractionEnabled = true
            childZoomingScrollView.tag = 90000 + i
            childZoomingScrollView.delegate = self
            parentZoomingScrollView.addSubview(childZoomingScrollView)
            imageZoom = UIImageView(frame: CGRect(x: CGFloat(0), y: CGFloat(0), width: CGFloat(SCREEN_WIDTH), height: CGFloat(SCREEN_HEIGHT - 120)))
            imageZoom.image = UIImage(named: "ic_placeholder.png")
            imageZoom.contentMode = .scaleAspectFit
            GlobalData.sharedInstance.getImageFromUrl(imageUrl: imageArrayUrl[i], imageView: imageZoom)
            
            imageZoom.isUserInteractionEnabled = true
            imageZoom.tag = 10
            childZoomingScrollView.addSubview(imageZoom)
            childZoomingScrollView.maximumZoomScale = 5.0
            childZoomingScrollView.clipsToBounds = true
            childZoomingScrollView.contentSize = CGSize(width: CGFloat(SCREEN_WIDTH), height: CGFloat(SCREEN_HEIGHT - 120))
            let doubleTap = UITapGestureRecognizer(target: self, action: #selector(self.handleDoubleTap))
            doubleTap.numberOfTapsRequired = 2
            imageZoom.addGestureRecognizer(doubleTap)
            X += SCREEN_WIDTH
        }
        
        parentZoomingScrollView.contentSize = CGSize(width: CGFloat(X), height: CGFloat(SCREEN_WIDTH))
        parentZoomingScrollView.isPagingEnabled = true
        let Y: CGFloat = 70 + SCREEN_HEIGHT - 120 + 5
        pager = UIPageControl(frame: CGRect(x: CGFloat(0), y: CGFloat(Y), width: CGFloat(SCREEN_WIDTH), height: CGFloat(50)))
        //SET a property of UIPageControl
        pager.backgroundColor = UIColor.clear
        pager.numberOfPages = imageArrayUrl.count
        //as we added 3 diff views
        parentZoomingScrollView.setContentOffset(CGPoint(x: Int(SCREEN_WIDTH)*tappedIndex, y: 0), animated: false)
        pager.currentPage = tappedIndex
        pager.isHighlighted = true
        pager.pageIndicatorTintColor = UIColor.black
        pager.currentPageIndicatorTintColor = UIColor.red
        homeDimView.addSubview(pager)
        currentWindow?.addSubview(homeDimView)
        
        let newPosition = SCREEN_WIDTH * CGFloat(self.pageControl.currentPage)
        let toVisible = CGRect(x: CGFloat(newPosition), y: CGFloat(70), width: CGFloat(SCREEN_WIDTH), height: CGFloat(SCREEN_HEIGHT - 120))
        self.parentZoomingScrollView.scrollRectToVisible(toVisible, animated: true)
    }
    
    func viewForZooming(in scrollView: UIScrollView) -> UIView? {
        if scrollView.viewWithTag(90000 + currentTag) as? UIScrollView != nil{
            let scroll = scrollView.viewWithTag(90000 + currentTag) as! UIScrollView
            let image = scroll.viewWithTag(10) as! UIImageView
            return image
        }else{
            return nil
        }
    }
    
    @objc func handleDoubleTap(_ gestureRecognizer: UIGestureRecognizer) {
        let scroll = parentZoomingScrollView.viewWithTag(888888) as! UIScrollView
        let childScroll = scroll.viewWithTag(90000 + currentTag) as! UIScrollView
        let newScale: CGFloat = scroll.zoomScale * 1.5
        let zoomRect = self.zoomRect(forScale: newScale, withCenter: gestureRecognizer.location(in: gestureRecognizer.view))
        childScroll.zoom(to: zoomRect, animated: true)
    }
    
    func zoomRect(forScale scale: CGFloat, withCenter center: CGPoint) -> CGRect {
        var zoomRect = CGRect(x: 0, y: 0, width: 0, height: 0)
        let scroll = parentZoomingScrollView.viewWithTag(888888) as! UIScrollView
        let childScroll = scroll.viewWithTag(90000 + currentTag) as! UIScrollView
        zoomRect.size.height = childScroll.frame.size.height / scale
        zoomRect.size.width = childScroll.frame.size.width / scale
        zoomRect.origin.x = center.x - (zoomRect.size.width / 2.0)
        zoomRect.origin.y = center.y - (zoomRect.size.height / 2.0)
        return zoomRect
    }
    
    @objc func closeZoomTap(_ gestureRecognizer: UIGestureRecognizer) {
        let currentWindow = UIApplication.shared.keyWindow!
        currentWindow.viewWithTag(888)!.removeFromSuperview()
    }
}

extension CatalogProduct : WKNavigationDelegate{
    
    func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
        
        webView.evaluateJavaScript("document.documentElement.scrollHeight", completionHandler: { (height, error) in
                    self.descWebViewHeightConstarints?.constant = height as! CGFloat
                })
        /*
        var frame = webView.frame
        frame.size.height = 1
        webView.frame = frame
        let fittingSize = webView.sizeThatFits(CGSize.init(width: 0, height: 0))
        frame.size = fittingSize
        webView.frame = frame
        
        let descHtmlStr = catalogProductViewModel.catalogProductModel.descriptionData
        if let desc = descHtmlStr {
            print(webView.frame.size.height)
            descWebViewHeightConstarints.constant = webView.frame.size.height
        }
        else{
            descWebViewHeightConstarints.constant = 0
        }*/
    }
}

//MARK:- UITextFieldDelegate
extension CatalogProduct : UITextFieldDelegate  {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool{
        view.endEditing(true)
        return true
    }
}

//MARK:- UICollectionView :-

extension CatalogProduct : UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        if collectionView.tag == 1111 {
            return CGSize(width:SCREEN_WIDTH , height:SCREEN_HEIGHT/2)
        }
        
        if collectionView.tag == 2222{
            //let cellWidth = (recentProdCollectionView.frame.size.width/2) - 40
            print(recentViewCellWidth, recentViewCellHeight)
            return CGSize(width: recentViewCellWidth , height: recentViewCellHeight)
        }
        
        return CGSize.zero
        //return CGSize(width: collectionView.frame.size.width/2 - 32 , height: collectionView.frame.size.width/2 + 70)
    }
    
}

extension CatalogProduct: UICollectionViewDataSource , UICollectionViewDelegate {
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ view: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        if view.tag == 1111 {
            return imageArrayUrl.count
        }
        return recentViewProducModel.count
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        if collectionView.tag == 1111 {
            
            let vc = self.storyboard?.instantiateViewController(withIdentifier: "ZoomImageViewController") as! ZoomImageViewController
            vc.currentTag = indexPath.row
            self.navigationController?.pushViewController(vc, animated: true)
        }
        else if collectionView.tag == 2222 {
            if recentViewProducModel.count > 0 {
                
                let vc = AppStoryboard.Main.instance.instantiateViewController(withIdentifier: "catalogproduct") as! CatalogProduct
                vc.productImageUrl = recentViewProducModel[indexPath.row].image
                vc.productName = recentViewProducModel[indexPath.row].name
                vc.productId = recentViewProducModel[indexPath.row].ProductID
                self.navigationController?.pushViewController(vc, animated: true)
            }
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        if collectionView.tag == 1111 {
            
            if isVideo[indexPath.row] {
                //contains YouTube Video URL
                let cell = collectionView.dequeueReusableCell(withReuseIdentifier: CatalogProductVideo.identifier, for: indexPath) as! CatalogProductVideo
                let youtubeURLKey = imageArrayUrl[indexPath.row].components(separatedBy: "=").last
                if youtubeURLKey != ""  {
                    cell.productVideoView.loadWithVideoId(youtubeURLKey!)
                }
                return cell
            }
            else
            {
                //contains Image URL
                let cell = collectionView.dequeueReusableCell(withReuseIdentifier: CatalogProductImage.identifier, for: indexPath) as! CatalogProductImage
                
                cell.imageView.image = UIImage(named: "ic_placeholder.png")
                //let tapGesture = UITapGestureRecognizer(target: self, action: #selector(openZoomableImage))
                //tapGesture.accessibilityHint = "\(indexPath.row)"
                //cell.imageView.addGestureRecognizer(tapGesture)
                //GlobalData.sharedInstance.getImageFromUrl(imageUrl:imageArrayUrl[indexPath.row] , imageView: cell.imageView)
                cell.imageView.getImageFromUrl(imageUrl:imageArrayUrl[indexPath.row])
                cell.imageView.clipsToBounds = true
                cell.imageView.addTapGestureRecognizer {
                    self.openZoomableImage(at:indexPath.row)
                }
                return cell
            }
            
        }
        else if collectionView.tag == 2222 {
            
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "productimagecell", for: indexPath) as! ProductImageCell
            
            cell.productImage.image = UIImage(named: "ic_placeholder.png")
            cell.layer.cornerRadius = 4
            cell.layer.borderWidth = 1
            cell.layer.borderColor = UIColor.appSuperLightGrey.cgColor
            
            if indexPath.row < recentViewProducModel.count{
                
                cell.wishListButton.isHidden = false
                cell.addToCompareButton.isHidden = false
                cell.btnQuickViewHeight.constant = 0
                cell.btnQuickView.isHidden = true
                
                GlobalData.sharedInstance.getImageFromUrl(imageUrl:recentViewProducModel[indexPath.row].image , imageView: cell.productImage)
                cell.productImage.addTapGestureRecognizer {
                    
                    if self.recentViewProducModel.count > 0 {
                        let vc = AppStoryboard.Main.instance.instantiateViewController(withIdentifier: "catalogproduct") as! CatalogProduct
                        vc.productImageUrl = self.recentViewProducModel[indexPath.row].image
                        vc.productName = self.recentViewProducModel[indexPath.row].name
                        vc.productId = self.recentViewProducModel[indexPath.row].ProductID
                        self.navigationController?.pushViewController(vc, animated: true)
                    }
                    
                }
                cell.productName.text = recentViewProducModel[indexPath.row].name
                cell.productPrice.text = recentViewProducModel[indexPath.row].price
                
                /*
                if recentViewProducModel[indexPath.row].isBundle == "1" {
                    //bundle products
                    cell.productPrice.text = recentViewProducModel[indexPath.row].formatedMinPrice + "-" + recentViewProducModel[indexPath.row].formatedMaxPrice
                }else{
                    //other products
                    cell.productPrice.text = recentViewProducModel[indexPath.row].formatedPrice
                }*/

                
                cell.wishListButton.tag = indexPath.row
                //cell.wishListButton.addTarget(self, action: #selector(addToWishList(sender:)), for: .touchUpInside)
                cell.wishListButton.isUserInteractionEnabled = true
                
                cell.addToCompareButton.tag = indexPath.row
                //cell.addToCompareButton.addTarget(self, action: #selector(addToCompare(sender:)), for: .touchUpInside)
                cell.addToCompareButton.isUserInteractionEnabled = true
                
                if Bool(recentViewProducModel[indexPath.row].isInWishlist)!{
                    cell.wishListButton.setImage(UIImage(named: "ic_wishlist_fill")!, for: .normal)

                }else{
                    cell.wishListButton.setImage(UIImage(named: "ic_wishlist_empty")!, for: .normal)
                }
                
                if recentViewProducModel[indexPath.row].typeID == "grouped"{
                    cell.productPrice.text =  recentViewProducModel[indexPath.row].groupedPrice
                }else if recentViewProducModel[indexPath.row].typeID == "bundle"{
                    cell.productPrice.text =  recentViewProducModel[indexPath.row].formatedMinPrice
                }
                else{
                    if Bool(recentViewProducModel[indexPath.row].isInRange) == true
                    {
                        if recentViewProducModel[indexPath.row].specialPrice < recentViewProducModel[indexPath.row].originalPrice{
                            cell.productPrice.text = recentViewProducModel[indexPath.row].showSpecialPrice
                            let attributeString = NSMutableAttributedString(string: (recentViewProducModel[indexPath.row].formatedPrice ))
                            attributeString.addAttribute(NSAttributedStringKey.strikethroughStyle, value: 1, range: NSRange(location: 0, length: attributeString.length))
                            cell.specialPrice.attributedText = attributeString
                            cell.specialPrice.isHidden = false
                        }
                    }else{
                        cell.specialPrice.isHidden = true
                    }
                }
                
                if recentViewProducModel[indexPath.row].isFreeshipping == "Yes"{
                    cell.lblShipping.text = "freeshipping".localized
                }else if recentViewProducModel[indexPath.row].isFreeshipping == "No"{
                    cell.lblShipping.text = "shippingword".localized + ": \(recentViewProducModel[indexPath.row].shippingPrice )"
                }
             }
            
            cell.layoutIfNeeded()
            if traitCollection.forceTouchCapability == .available {
                cell.showFeature = false
                //homeViewController.registerForPreviewing(with: homeViewController, sourceView: cell.contentView)
            }
            return cell
        }
        
        let extracell = collectionView.dequeueReusableCell(withReuseIdentifier: "ViewAllCell", for: indexPath) as! ViewAllCell
        return extracell
        
        /*
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "productimagecell", for: indexPath) as! ProductImageCell
        
        cell.layer.cornerRadius = 4
        cell.layer.borderWidth = 1
        cell.layer.borderColor = UIColor.appSuperLightGrey.cgColor
        
        cell.contentView.frame = cell.bounds
        cell.contentView.autoresizingMask = [UIViewAutoresizing.flexibleWidth, UIViewAutoresizing.flexibleHeight]
        
        if indexPath.row < recentCollectionModel.count{
            
            GlobalData.sharedInstance.getImageFromUrl(imageUrl:recentCollectionModel[indexPath.row].image , imageView: cell.productImage)
            cell.productName.text = recentCollectionModel[indexPath.row].name
            
            if recentCollectionModel[indexPath.row].isBundle == "1" {
                //bundle products
                cell.productPrice.text = recentCollectionModel[indexPath.row].formatedMinPrice + "-" + recentCollectionModel[indexPath.row].formatedMaxPrice
            }else{
                //other products
                cell.productPrice.text = recentCollectionModel[indexPath.row].formatedPrice
            }
            
            cell.wishListButton.isHidden = true
            cell.addToCompareButton.isHidden = false
            
            cell.wishListButton.tag = indexPath.row
            //cell.wishListButton.addTarget(self, action: #selector(addToWishList(sender:)), for: .touchUpInside)
            cell.wishListButton.isUserInteractionEnabled = true
            
            cell.addToCompareButton.tag = indexPath.row
            //cell.addToCompareButton.addTarget(self, action: #selector(addToCompare(sender:)), for: .touchUpInside)
            cell.addToCompareButton.isUserInteractionEnabled = true
            
            
            if Bool(recentCollectionModel[indexPath.row].isInWishlist)!{
                cell.wishListButton.setImage(UIImage(named: "ic_wishlist_fill")!, for: .normal)

            }else{
                cell.wishListButton.setImage(UIImage(named: "ic_wishlist_empty")!, for: .normal)
            }
            
            if Bool(recentCollectionModel[indexPath.row].isInRange) == true{
                if recentCollectionModel[indexPath.row].specialPrice < recentCollectionModel[indexPath.row].originalPrice{
                    cell.productPrice.text = recentCollectionModel[indexPath.row].showSpecialPrice
                    let attributeString = NSMutableAttributedString(string: (recentCollectionModel[indexPath.row].formatedPrice ))
                    attributeString.addAttribute(NSAttributedStringKey.strikethroughStyle, value: 1, range: NSRange(location: 0, length: attributeString.length))
                    cell.specialPrice.attributedText = attributeString
                    cell.specialPrice.isHidden = false
                }else{
                    cell.specialPrice.text = ""
                    cell.specialPrice.isHidden = true
                }
            }else{
                cell.specialPrice.text = ""
                cell.specialPrice.isHidden = true
            }
         }
        
        if recentCollectionModel[indexPath.row].isFreeshipping == "Yes"{
            cell.lblShipping.text = "freeshipping".localized
        }else if recentCollectionModel[indexPath.row].isFreeshipping == "No"{
            cell.lblShipping.text = "shippingword".localized + ": \(recentCollectionModel[indexPath.row].shippingPrice )"
        }else{
            cell.lblShipping.text = ""
        }
        
        cell.layoutIfNeeded()
        return cell
         */
        
    }
    
    /*
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat{
        
        if collectionView.tag == 1111 {
            return 0.0
        }
        
        return 5.0
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat   {
        if collectionView.tag == 1111 {
            return 0.0
        }
        return 5.0
    }*/
    
}

//MARK:- UIScrollView
extension CatalogProduct : UIScrollViewDelegate {
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        if scrollView.tag == 888888{
            let pageWidth: CGFloat = self.parentZoomingScrollView.frame.size.width
            let page = floor((self.parentZoomingScrollView.contentOffset.x - pageWidth / 2) / pageWidth) + 1
            self.currentTag = NSInteger(page)
            self.pager.currentPage = Int(page)
        }
    }
    
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        
        if self.collectionView.tag == 1111{
            for cell: UICollectionViewCell in self.collectionView.visibleCells {
                let indexPathValue = self.collectionView.indexPath(for: cell)!
                print(indexPathValue.row)
                self.pageControl.currentPage = Int(indexPathValue.row)
                break
            }
        }
    }
}

//MARK:- UIDocumentPicker
extension CatalogProduct : UIDocumentPickerDelegate,UIDocumentMenuDelegate {
    
    //@available(iOS 8.0, *)
    public func documentPicker(_ controller: UIDocumentPickerViewController, didPickDocumentAt url: URL) {
        
        let cico = url as URL
        print("The Url is : /(cico)", cico, currentTag)
        
        do {
            let type:String = GlobalData.sharedInstance.getMimeType(type:cico.pathExtension.lowercased())
            let weatherData = try NSData(contentsOf: cico)! as Data
            let customOptionDict = self.customeJson["customOptions"][currentTag]
            customOptionFileEntry[customOptionDict["option_id"].stringValue] = true
            customOptionFileDict[customOptionDict["option_id"].stringValue] = weatherData
            MIMETYPE[customOptionDict["option_id"].stringValue] = type
        } catch {
            print(error)
        }
    }
    
    //@available(iOS 8.0, *)
    public func documentMenu(_ documentMenu:     UIDocumentMenuViewController, didPickDocumentPicker documentPicker: UIDocumentPickerViewController) {
        documentPicker.delegate = self
        present(documentPicker, animated: true, completion: nil)
    }
}

//MARK:- UIPickerView
extension CatalogProduct : UIPickerViewDelegate, UIPickerViewDataSource   {
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        if(pickerView.tag == 10000){
            let bundleArray:NSMutableArray = bundleDisplayData[bundlePickerIndex]! as NSMutableArray
            return bundleArray.count
        }
        if(pickerView.tag == 11000){
            let bundleArray:NSMutableArray = customeCollectionDisplayData[customePickerIndex]! as NSMutableArray
            return bundleArray.count
        }
        if(pickerView.tag == 7000){
            let configArray:NSMutableArray = configurableData[pickerIndex]! as NSMutableArray
            return configArray.count
        }else{
            return 0
        }
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        if(pickerView.tag == 10000){
            let bundleArray:NSMutableArray = bundleDisplayData[bundlePickerIndex]! as NSMutableArray
            let  attributedString:String = bundleArray.object(at: row) as! String
            return attributedString
        }
        if(pickerView.tag == 11000){
            let customeArray:NSMutableArray = customeCollectionDisplayData[customePickerIndex]! as NSMutableArray
            let  attributedString:String = customeArray.object(at: row) as! String
            return attributedString
        }
        if(pickerView.tag == 7000){
            let configArray:NSMutableArray = configurableData[pickerIndex]! as NSMutableArray
            let  attributedValue = configArray.object(at: row) as! [String:AnyObject]
            return attributedValue["label"] as? String
        }else{
            return  ""
        }
    }
}

extension CatalogProduct : RelatedProductHandlerDelegate    {
    func openProduct(productId:String,productName:String,imageUrl:String) {
        let initViewController = AppStoryboard.Main.instance.instantiateViewController(withIdentifier: "catalogproduct") as! CatalogProduct
        initViewController.productId = productId
        initViewController.productName = productName
        initViewController.productImageUrl = imageUrl
        initViewController.modalTransitionStyle = .flipHorizontal
        self.navigationController?.pushViewController(initViewController, animated: true)
    }
}

//MARK:- Selected Configurable Images
extension CatalogProduct    {
    
    func selectedConfigurImg()  {
        
        var count = 0
        var tmpArr = [String]()
        
        for j in 0..<configurableDataIndex.count  {
            count = 0
            tmpArr.removeAll()
            
            let d = JSON((configurableDataIndex as! NSArray)[j])
            
            for (key,val):(String,JSON) in d   {
                
                if (JSON(configurableSelectedData)[key] != nil) , JSON(configurableSelectedData)[key].stringValue == val.stringValue , key != "product" {
                    count += 1
                    tmpArr.append(d["product"].stringValue)
                }
                print(key)
            }
            
            if count == configurableSelectedData.count  {
                break
            }
        }
        
        print("Count array key -->>>> \(tmpArr)")
        
        if tmpArr.count > 0   {
            setNewImages(productId:tmpArr[0])
        }
    }
    
    func setNewImages(productId: String) {
        
        if let imageArr = configurableDataImages[productId] as? NSArray {
            self.imageArrayUrl.removeAll()
            self.isVideo.removeAll()
            pageControl.numberOfPages = 0
            
            for i in 0..<imageArr.count {
                
                if JSON(imageArr)[i]["img"].stringValue != ""  {
                    if JSON(imageArr)[i]["isVideo"].boolValue   {
                        //conntains youtube url
                        self.imageArrayUrl.append(JSON(imageArr)[i]["videoUrl"].stringValue)
                        self.isVideo.append(true)
                    }else{
                        //conntains image url
                        self.imageArrayUrl.append(JSON(imageArr)[i]["img"].stringValue)
                        self.isVideo.append(false)
                    }
                }
            }
            
            pageControl.numberOfPages = imageArrayUrl.count
            self.collectionView.reloadData()
        }
    }
}

//MARK: - AR Products
extension CatalogProduct : tes {
    func addArProduct() {
        if let type = catalogProductViewModel.catalogProductModel.arType, catalogProductViewModel.catalogProductModel.arUrl.count > 0 {
            let btn1 = UIButton(type: .custom)
            btn1.setImage(UIImage(named: "ar-icon"), for: .normal)
            btn1.frame = CGRect(x: 0, y: 0, width: 30, height: 30)
            
            let item1 = UIBarButtonItem(customView: btn1)
            self.navigationItem.rightBarButtonItem = item1
            
            switch type {
            case .threeD:
                self.add3DButton(btn: btn1)
            case .twoD:
                self.add2DButton(btn: btn1)
            }
        }
    }
    
    func add3DButton(btn: UIButton) {
        btn.addTarget(self, action: #selector(self.bar3DButtonClicked), for: .touchUpInside)
    }
    
    func add2DButton(btn: UIButton) {
        btn.addTarget(self, action: #selector(self.bar2DButtonClicked), for: .touchUpInside)
    }
    
    @objc func bar3DButtonClicked() {
        DownloadManager.shared.id = self.productId
        DownloadManager.shared.download(string:(catalogProductViewModel.catalogProductModel.arUrl)!)
        DownloadManager.shared.delegate = self
    }
    
    @objc func bar2DButtonClicked() {
        
        if let url = URL(string:catalogProductViewModel.catalogProductModel.arUrl) {
            
            
            KingfisherManager.shared.retrieveImage(with: url, options: nil, progressBlock: nil) { result in
                    switch result {
                    case .success(let value):
                        print("Image: \(value.image). Got from: \(value.cacheType)")
                        DispatchQueue.main.async {
                            let view = UIStoryboard(name: "Product", bundle: nil).instantiateViewController(withIdentifier: "product2DViewController") as! Product2DViewController
                            view.img = value.image ?? UIImage(named: "ic_placeholder.png")
                            self.navigationController?.pushViewController(view, animated: true)
                        }
                    case .failure(let error):
                        print("Error: \(error)")
                    }
                }
//
//            KingfisherManager.shared.retrieveImage(with: url, options: nil, progressBlock: nil, completionHandler:  { image, error, cacheType, imageURL in
//
//                DispatchQueue.main.async {
//                    let view = UIStoryboard(name: "Product", bundle: nil).instantiateViewController(withIdentifier: "product2DViewController") as! Product2DViewController
//                    view.img = image ?? UIImage(named: "ic_placeholder.png")
//                    self.navigationController?.pushViewController(view, animated: true)
//                }
//
//            })
        }
    }
    
    func pass(str: String) {
        if #available(iOS 11.0, *) {
            
            let view = UIStoryboard(name: "Product", bundle: nil).instantiateViewController(withIdentifier: "productArViewController") as! ProductArViewController
            //            let view  = viewController(forStoryboardName: productStoryBoard, forViewControllerName: Controllers.productArViewController.rawValue) as! ProductArViewController
            view.str = str
            view.texture = self.catalogProductViewModel.catalogProductModel.texture
            self.navigationController?.pushViewController(view, animated: true)
        } else {
            // Fallback on earlier versions
        }
    }
}


//MARK:- MARKET PLACE
extension CatalogProduct {
    
    @IBAction func SellerNameClick(_ sender: UIButton) {
        let viewController = AppStoryboard.Main.instance.instantiateViewController(withIdentifier: "SellerDetailsViewController") as! SellerDetailsViewController
        viewController.profileUrl = catalogProductViewModel.sellerInformationData.sellerID
        self.navigationController?.pushViewController(viewController, animated: true)
    }
    
    @IBAction func contactUsClick(_ sender: UIButton) {
        let viewController:ContactUs = AppStoryboard.Marketplace.instance.instantiateViewController(withIdentifier: "ContactUs") as! ContactUs
        viewController.sellerId = catalogProductViewModel.sellerInformationData.sellerID;
        viewController.productId = productId
        self.navigationController?.pushViewController(viewController, animated: true)
    }
}

