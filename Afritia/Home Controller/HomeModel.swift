//
//  HomeModel.swift
//  OpenCartMpV3
//
//  Created by Webkul on 11/12/17.
//  Copyright © 2017 Webkul. All rights reserved.
//

import Foundation
import UIKit
import EzPopup

struct ProductType {
    static let feature = "Feature Product"
    static let latest = "New Product"
    static let hotdeal = "HotDeals"
}

struct HomeModal {
    
    var bannerCollectionModel = [BannerData]()
    var latestProductCollectionModel = [Products]()
    var featuredProductCollectionModel = [Products]()
    var hotdealProductCollectionModel = [Products]()
    var featureCategories = [FeatureCategories]()
    var languageData = [Languages]()
    var cateoryData:[String:AnyObject]!
    var categoryImage = [CategoryImage]()
    var storeData = [StoreData]()
    var currency :NSArray!
    var cmsData = [CMSdata]()
    
    var recentViewData = [Productcollection]()
    
    //GDPR
    var gdprData : GDPRData!
    
    //Big Banners
    var featuredProductsBannerUrl = String()
    var newProductsBannerUrl = String()
    var dealProductsBannerUrl = String()
    
    init?(data : JSON) {
        
        if var arrayData = data["bannerImages"].arrayObject{
            arrayData = (data["bannerImages"].arrayObject! as NSArray) as! [Any]
            bannerCollectionModel =  arrayData.map({(value) -> BannerData in
                return  BannerData(data:JSON(value))
            })
        }
        
        let arrayData2 = data["newProducts"].arrayObject! as NSArray
        latestProductCollectionModel =  arrayData2.map({(value) -> Products in
            return  Products(data:JSON(value))
        })
        
        let arrayData3 = data["featuredProducts"].arrayObject! as NSArray
        featuredProductCollectionModel =  arrayData3.map({(value) -> Products in
            return  Products(data:JSON(value))
        })
        
        let arrayData4 = data["featuredCategories"].arrayObject! as NSArray
        featureCategories =  arrayData4.map({(value) -> FeatureCategories in
            return  FeatureCategories(data:JSON(value))
        })
        
        let arrayData5 = data["hotDeals"].arrayObject! as NSArray
        hotdealProductCollectionModel =  arrayData5.map({(value) -> Products in
            return  Products(data:JSON(value))
        })
        
        let arrayData6 = data["categoryImages"].arrayObject! as NSArray
        categoryImage =  arrayData6.map({(value) -> CategoryImage in
            return  CategoryImage(data:JSON(value))
        })
        
        if var arrayData = data["storeData"].arrayObject{
            arrayData = (data["storeData"].arrayObject! as NSArray) as! [Any]
            storeData =  arrayData.map({(value) -> StoreData in
                return  StoreData(data:JSON(value))
            })
        }
        
        if data["allowedCurrencies"].arrayObject != nil{
            currency = data["allowedCurrencies"].arrayObject! as NSArray
        }
        
        if var arrayData = data["cmsData"].arrayObject{
            arrayData = (data["cmsData"].arrayObject! as NSArray) as! [Any]
            cmsData =  arrayData.map({(value) -> CMSdata in
                return  CMSdata(data:JSON(value))
            })
        }
        
        self.cateoryData = data["categories"].dictionaryObject! as [String : AnyObject]
        
        //GDPR
        self.gdprData = GDPRData(data: data)
        
        //print(data["customerBannerImage"].stringValue)
        //print(data["customerProfileImage"].stringValue)
        
        if data["customerBannerImage"].stringValue != ""{
            DEFAULTS.setValue(data["customerBannerImage"].stringValue, forKey: "profileBanner")
        }
        
        if data["customerProfileImage"].stringValue != ""{
            DEFAULTS.setValue(data["customerProfileImage"].stringValue, forKey: "profilePicture")
        }
        
        if data["customerEmail"].stringValue != ""{
            DEFAULTS.setValue(data["customerEmail"].stringValue, forKey: "customerEmail")
        }
        
        if data["customerName"].stringValue != ""{
            DEFAULTS.setValue(data["customerName"].stringValue, forKey: "customerName")
        }
        
        // Big Banner
        
        if data["featuredProductsBanner"].stringValue != ""{
            featuredProductsBannerUrl = data["featuredProductsBanner"].stringValue
        }
        
        if data["newProductsBanner"].stringValue != ""{
            newProductsBannerUrl = data["newProductsBanner"].stringValue
        }
        
        if data["dealProductsBanner"].stringValue != ""{
            dealProductsBannerUrl = data["dealProductsBanner"].stringValue
        }
        
        DEFAULTS.synchronize()
        
    }
}

struct BannerData{
    var bannerType:String!
    var imageUrl:String!
    var bannerId:String!
    var bannerName:String!
    var productId:String!
    
    init(data:JSON){
        bannerType = data["bannerType"].stringValue
        imageUrl  = data["url"].stringValue
        bannerId = data["categoryId"].stringValue
        bannerName = data["categoryName"].stringValue
        productId = data["productId"].stringValue
    }
}

struct FeatureCategories{
    var categoryID:String = ""
    var categoryName:String = ""
    var imageUrl:String = ""
    
    init(data:JSON) {
        self.categoryID = data["categoryId"].stringValue
        self.categoryName = data["categoryName"].stringValue
        self.imageUrl = data["url"].stringValue
    }
}

struct Products{
    
    var hasOption:Int!
    var name:String!
    var price:String!
    var productID:String!
    var showSpecialPrice:String!
    var image:String!
    var isInRange:Int!
    var isInWishList:Bool!
    var originalPrice:Double!
    var specialPrice:Double!
    var formatedPrice:String!
    var typeID:String!
    var groupedPrice:String!
    var formatedMinPrice:String!
    var formatedMaxPrice:String!
    var wishlistItemId:String!
    var shortDescription:String = ""
    var requiredOptions:Int = 0
    
    var isFreeShipping:String!
    var shippingPrize:String!
    
    init(data:JSON) {
       
        self.hasOption = data["hasOption"].intValue
        self.name = data["name"].stringValue
        self.price = data["formatedFinalPrice"].stringValue
        self.productID = data["entityId"].stringValue
        self.showSpecialPrice = data["formatedFinalPrice"].stringValue
        self.image = data["thumbNail"].stringValue
        self.originalPrice =  data["price"].doubleValue
        self.specialPrice = data["finalPrice"].doubleValue
        self.isInRange = data["isInRange"].intValue
        self.isInWishList = data["isInWishlist"].boolValue
        self.formatedPrice = data["formatedPrice"].stringValue
        self.typeID = data["typeId"].stringValue
        self.groupedPrice = data["groupedPrice"].stringValue
        self.formatedMaxPrice = data["formatedMaxPrice"].stringValue
        self.formatedMinPrice = data["formatedMinPrice"].stringValue
        self.wishlistItemId = data["wishlistItemId"].stringValue
        self.shortDescription = data["shortDescription"].stringValue.html2String
        self.requiredOptions = data["requiredOptions"].intValue
        
        self.isFreeShipping = data["isFreeshipping"].stringValue
        self.shippingPrize = data["shippingPrice"].stringValue
    }
}

struct StoreData{
    var id:String = ""
    var name:String = ""
    var stores = [Languages]()
    
    init(data:JSON) {
        self.id = data["id"].stringValue
        self.name = data["name"].stringValue
        
        if let arrayData = data["stores"].arrayObject{
            stores =  arrayData.map({(value) -> Languages in
                return  Languages(data:JSON(value))
            })
        }
    }
}

struct Languages {
    var code:String!
    var name:String!
    var id:String!
    
    init(data:JSON){
        self.code = data["code"].stringValue
        self.name = data["name"].stringValue
        self.id = data["id"].stringValue
    }
}

struct CategoryImage{
    var bannerImage:String = ""
    var id:String = ""
    var iconImage:String = ""
    
    init(data:JSON) {
        self.bannerImage = data["banner"].stringValue
        self.id = data["id"].stringValue
        self.iconImage = data["thumbnail"].stringValue
    }
}

struct CMSdata{
    var id:String!
    var title:String!
    
    init(data:JSON) {
        self.id = data["id"].stringValue
        self.title = data["title"].stringValue
    }
}

struct GDPRData {
    var gdprEnable : Bool = false
    var tncHomepageEnable : Bool = false
    var tncHomepageContent : String = ""
    
    init(data:JSON) {
        gdprEnable = data["gdprEnable"].boolValue
        tncHomepageEnable = data["tncHomepageEnable"].boolValue
        tncHomepageContent = data["tncHomepageContent"].stringValue
    }
}

enum HomeViewModelItemType {
    
    //case Category
    case Banner
    case FeatureCategory
    case NewProduct
    case FeatureProduct
    case FeaturedProductsBanner
    case RecentViewData
    case hotDeal
    
    case NewProductsBanner
    case DealProductsBanner
}

protocol HomeViewModelItem {
    var type: HomeViewModelItemType { get }
    var sectionTitle: String { get }
    var rowCount: Int { get }
}

class HomeViewModelBannerItem: HomeViewModelItem {
    var type: HomeViewModelItemType {
        return .Banner
    }
    
    var sectionTitle: String {
        return ""
    }
    
    var rowCount: Int {
        return bannerCollectionModel.count
    }
    
    var bannerCollectionModel = [BannerData]()
    
    init(categories: [BannerData]) {
        self.bannerCollectionModel = categories
    }
}


class HomeViewModelFeatureCategoriesItem: HomeViewModelItem {
    var type: HomeViewModelItemType {
        return .FeatureCategory
    }
    
    var sectionTitle: String {
        return ""
    }
    
    var rowCount: Int {
        return featureCategories.count
    }
    
    var featureCategories = [FeatureCategories]()
    
    init(categories: [FeatureCategories]) {
        self.featureCategories = categories
    }
}

class HomeViewModelLatestItem: HomeViewModelItem {
    var type: HomeViewModelItemType {
        return .NewProduct
    }
    
    var sectionTitle: String {
        return ""
    }
    
    var rowCount: Int {
        return latestProductCollectionModel.count
    }
    
    var latestProductCollectionModel = [Products]()
    
    init(categories: [Products]) {
        self.latestProductCollectionModel = categories
    }
    
}

class HomeViewModelFeatureItem: HomeViewModelItem {
    var type: HomeViewModelItemType {
        return .FeatureProduct
    }
    
    var sectionTitle: String {
        return ""
    }
    
    var rowCount: Int {
        return featuredProductCollectionModel.count
    }
    
    var featuredProductCollectionModel = [Products]()
    
    init(categories: [Products]) {
        self.featuredProductCollectionModel = categories
    }
}

class HomeViewModelRecentViewItem: HomeViewModelItem    {
    var type: HomeViewModelItemType {
        return .RecentViewData
    }
    
    var sectionTitle: String {
        return ""
    }
    
    var rowCount: Int {
        return recentViewProductData.count
    }
    
    var recentViewProductData = [Productcollection]()
    
    init(categories: [Productcollection]) {
        self.recentViewProductData = categories
    }
}

class HomeViewModelHotdealItem: HomeViewModelItem {
    var type: HomeViewModelItemType {
        return .hotDeal
    }
    
    var sectionTitle: String {
        return ""
    }
    
    var rowCount: Int {
        return hotDealsProduct.count
    }
    
    var hotDealsProduct = [Products]()
    
    init(categories: [Products]) {
        self.hotDealsProduct = categories
    }
}

class FeaturedProductsBannerItem: HomeViewModelItem {
    var type: HomeViewModelItemType {
        return .FeaturedProductsBanner
    }
    
    var sectionTitle: String {
        return ""
    }
    
    var rowCount: Int {
        return 1
    }
    
    var featuredProductsBannerUrl = String()
    
    init(bannerUrl:String) {
        self.featuredProductsBannerUrl = bannerUrl
    }
}

class NewProductsBannerItem: HomeViewModelItem {
    var type: HomeViewModelItemType {
        return .NewProductsBanner
    }
    
    var sectionTitle: String {
        return ""
    }
    
    var rowCount: Int {
        return 1
    }
    
    var latestProductsBannerUrl = String()
    
    init(bannerUrl:String) {
        self.latestProductsBannerUrl = bannerUrl
    }
}

class DealProductsBannerItem: HomeViewModelItem {
    var type: HomeViewModelItemType {
        return .DealProductsBanner
    }
    
    var sectionTitle: String {
        return ""
    }
    
    var rowCount: Int {
        return 1
    }
    
    var dealProductsBannerUrl = String()
    
    init(bannerUrl:String) {
        self.dealProductsBannerUrl = bannerUrl
    }
}


class HomeViewModel : NSObject {
    
    var items = [HomeViewModelItem]()
    var featuredProductsInfo = [Products]()
    var latestProductsInfo = [Products]()
    var hotdealProductsInfo = [Products]()
    var cateoryData:[String:AnyObject]!
    
    var currency :NSArray = []
    var languageData = [Languages]()
    var homeViewController:HomeViewController!
    var guestCheckOut:Bool!
    var categoryImage = [CategoryImage]()
    var storeData = [StoreData]()
    var cmsData = [CMSdata]()
    
    //GDPR
    var gdprData : GDPRData!
    
    //Big Banner
    var featuredProductsBannerUrl = String()
    var newProductsBannerUrl = String()
    var dealProductsBannerUrl = String()
    
    func getHomeData(data : AnyObject , recentViewData : [Productcollection] , completion:(_ data: Bool) -> Void) {
        
        guard let data = HomeModal(data: JSON(data as! NSDictionary)) else {
            return
        }
        
        print(data)
        
        items.removeAll()
        
        if !data.featureCategories.isEmpty {
            let featureCategoryCollectionItem = HomeViewModelFeatureCategoriesItem(categories: data.featureCategories)
            items.append(featureCategoryCollectionItem)
            
        }
        
        if !data.bannerCollectionModel.isEmpty {
            let bannerDataCollectionItem = HomeViewModelBannerItem(categories: data.bannerCollectionModel)
            items.append(bannerDataCollectionItem)
            
        }
        
        if data.featuredProductsBannerUrl != ""{
            let featuredProductsBannerItem = FeaturedProductsBannerItem(bannerUrl: data.featuredProductsBannerUrl)
            items.append(featuredProductsBannerItem)
        }
        
        if !data.featuredProductCollectionModel.isEmpty {
            let featureCollectionItem = HomeViewModelFeatureItem(categories: data.featuredProductCollectionModel)
            items.append(featureCollectionItem)
            featuredProductsInfo = data.featuredProductCollectionModel
        }
        
        if data.newProductsBannerUrl != ""{
            //self.newProductsBannerUrl = data.newProductsBannerUrl
            let newProductsBannerItem = NewProductsBannerItem(bannerUrl: data.newProductsBannerUrl)
            items.append(newProductsBannerItem)
        }
        
        if !data.latestProductCollectionModel.isEmpty {
            let latestCollectionItem = HomeViewModelLatestItem(categories: data.latestProductCollectionModel)
            items.append(latestCollectionItem)
            latestProductsInfo = data.latestProductCollectionModel
        }
        
        if data.dealProductsBannerUrl != ""{
            //self.dealProductsBannerUrl = data.dealProductsBannerUrl
            let dealProductsBannerItem = DealProductsBannerItem(bannerUrl: data.dealProductsBannerUrl)
            items.append(dealProductsBannerItem)
        }
        
        if !data.hotdealProductCollectionModel.isEmpty {
            let hotDealCollectionItem = HomeViewModelHotdealItem(categories: data.hotdealProductCollectionModel)
            items.append(hotDealCollectionItem)
            hotdealProductsInfo = data.hotdealProductCollectionModel
            
        }
        
        if data.currency != nil{
            self.currency = data.currency
        }
        
        if !data.cmsData.isEmpty{
            self.cmsData = data.cmsData
        }
        
        if data.gdprData != nil{
            self.gdprData = data.gdprData
        }
        
        
        if !recentViewData.isEmpty {
            let recentViewCollectionItem = HomeViewModelRecentViewItem(categories: recentViewData)
            items.append(recentViewCollectionItem)
        }
        
        self.categoryImage = data.categoryImage
        self.cateoryData = data.cateoryData
        self.storeData = data.storeData
        
        //self.featuredProductsBannerUrl = data.featuredProductsBannerUrl
        //self.newProductsBannerUrl = data.newProductsBannerUrl
        //self.dealProductsBannerUrl = data.dealProductsBannerUrl
        
        completion(true)
    }
    
    func changeWishlistProductFlagStatus(status:Bool, pIndex:Int, pType:String){
        
        if pType == ProductType.feature{
            featuredProductsInfo[pIndex].isInWishList = status
        }
        else if pType == ProductType.latest {
            latestProductsInfo[pIndex].isInWishList = status
        }
        else if pType == ProductType.hotdeal {
            hotdealProductsInfo[pIndex].isInWishList = status
        }
    }
    
    func changeWishlistProductIdStatus(itemId:String, pIndex:Int, pType:String){
        
        if pType == ProductType.feature{
            featuredProductsInfo[pIndex].wishlistItemId = itemId
        }
        else if pType == ProductType.latest {
            latestProductsInfo[pIndex].wishlistItemId = itemId
        }
        else if pType == ProductType.hotdeal {
            hotdealProductsInfo[pIndex].wishlistItemId = itemId
        }
    }
    
    /*
    func setWishListFlagToFeaturedProductModel(data:Bool,pos:Int){
        featuredProductsInfo[pos].isInWishList = data
    }
    
    func setWishListItemIdToFeaturedProductModel(data:String,pos:Int){
        featuredProductsInfo[pos].wishlistItemId = data
    }
    
    
    func setWishListFlagToLatestProductModel(data:Bool,pos:Int){
        latestProductsInfo[pos].isInWishList = data
    }
    
    func setWishListItemIdToLatestProductModel(data:String,pos:Int){
        latestProductsInfo[pos].wishlistItemId = data
    }*/
    
    /*
    //class func getAllAvailableWishlistGroups(completionBlock:@escaping completionHandler){
        
        //self.mutliWishlistApiType = Mu
        GlobalData.sharedInstance.showLoader()
        
        var requstParams = [String:Any]()
        requstParams["storeId"] = defaults.object(forKey:"storeId") as! String
        requstParams["pageNumber"] =  "1"
        requstParams["customerToken"] = defaults.object(forKey:"customerId") as! String
        
        APIServiceManager.shared.callingHttpRequestWithoutView(params:requstParams, apiname:AfritiaAPI.allAvailableWishlist ){success,responseObject in
            if success == 1{
                
                DispatchQueue.main.async {
                    
                    let data = responseObject as! NSDictionary
                    
                    GlobalData.sharedInstance.dismissLoader()

                    var wishlistData = [MyWishlistGroupModel]()
                    
                    if data.object(forKey: "multipleWishlist") != nil   {
                        if let dictData = JSON(data.object(forKey: "multipleWishlist")!).arrayObject {
                            wishlistData = dictData.map({(val) -> MyWishlistGroupModel in
                                return MyWishlistGroupModel(data: JSON(val))
                            })
                        }
                    }
                    completionBlock(wishlistData)
                }
            }
            else if success == 2{
                //self.getAllAvailableWishlistGroups()
                GlobalData.sharedInstance.dismissLoader()
            }
        }
    }*/
    
    /*
    func showAllAvailableWishlistPopUp(parentVC:UIViewController, wishListGroups:[MyMultiWishlistModel], selProductId:String, completion:completionOnAddToWishList){
        
        let vc = AppStoryboard.Main.instance.instantiateViewController(withIdentifier: "WishListGroupPopUpVC") as! WishListGroupPopUpVC
        vc.myMultiWishlistData = wishListGroups
        
        vc.callBackOnSubmitClick = {(groupId, groupName) in
            print(groupId, groupName)
            
            GlobalData.sharedInstance.showLoader()
            parentVC.view.isUserInteractionEnabled = false
            
            var requstParams = [String:Any]()
            requstParams["storeId"] = defaults.object(forKey:"storeId") as! String
            requstParams["wishlist"] = groupId
            requstParams["newWishlistName"] = ""
            if groupId == "new"{
                requstParams["newWishlistName"] = groupName
            }
            requstParams["customerToken"] = defaults.object(forKey:"customerId") as! String
            requstParams["productId"] = selProductId
            
            print("Request Params: \(requstParams)")
            
            APIServiceManager.shared.callingHttpRequest(params:requstParams, apiname:AfritiaAPI.addProductToMultiWishList, currentView:parentVC){success,responseObject in
                if success == 1{
                    print(responseObject!)
                    let apiResponse = responseObject as? NSDictionary
                    parentVC.view.isUserInteractionEnabled = true
                    GlobalData.sharedInstance.dismissLoader()
                    AlertManager.shared.showSuccessSnackBar(msg:apiResponse!["message"] as! String)
                    //self.callApiForMultiWishlist(apiType: MultiWishlistAPIType.getAllWishlistGroups)
                    
                    completion(true)
                    
                }else if success == 2 {
                    //self.callApiForMultiWishlist(apiType:MultiWishlistAPIType.addNewWishListGroup)
                    //GlobalData.sharedInstance.dismissLoader()
                }
            }
            
            /*
            //let wishListFlag = selProdInfo.isInWishList
            if selProdInfo.isInWishList == false{
                self.productId = selProdInfo.productID
                selWishBtn.setImage(UIImage(named: "ic_wishlist_fill")!, for: .normal)
                self.whichApiToProcess = "addtowishlist"
                //self.callingExtraHttpApi()
            }else{
                self.productId = selProdInfo.productID
                selWishBtn.setImage(UIImage(named: "ic_wishlist_empty")!, for: .normal)
                self.whichApiToProcess = "removewishlist"
                //self.callingExtraHttpApi()
            }*/
        }
        
        let popViewHeight = 44 + 120 + (40 * (wishListGroups.count+1))
        // Init popup view controller with content is your content view controller
        let popupVC = PopupViewController(contentController: vc, popupWidth:SCREEN_WIDTH-100, popupHeight: CGFloat(popViewHeight))
        popupVC.backgroundAlpha = 0.4
        popupVC.backgroundColor = .black
        popupVC.canTapOutsideToDismiss = false
        popupVC.cornerRadius = 10
        popupVC.shadowEnabled = false
    
        parentVC.present(popupVC, animated: true)
        
    }
    */
}

extension HomeViewModel : UITableViewDelegate , UITableViewDataSource {
    public func numberOfSections(in tableView: UITableView) -> Int{
        
        if items.count > 0 {
           print("Total HomeView ModelItem \(items.count)")
        }
        return items.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int{
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let item = items[indexPath.section]
        
        switch item.type {
        case .Banner:
            let cell:BannerTableViewCell = tableView.dequeueReusableCell(withIdentifier: BannerTableViewCell.identifier) as! BannerTableViewCell
            cell.delegate = homeViewController
            cell.bannerCollectionModel = ((item as? HomeViewModelBannerItem)?.bannerCollectionModel)!
            cell.selectionStyle = .none
            return cell
            
        case .FeatureCategory:
            let cell:TopCategoryTableViewCell = tableView.dequeueReusableCell(withIdentifier: TopCategoryTableViewCell.identifier) as! TopCategoryTableViewCell
            cell.featureCategoryCollectionModel = ((item as? HomeViewModelFeatureCategoriesItem)?.featureCategories)!
            cell.categoryCollectionView.reloadData()
            cell.delegate = homeViewController
            cell.selectionStyle = .none
            return cell
            
        case .FeaturedProductsBanner:
            
            let cell:BigBannerTableViewCell = tableView.dequeueReusableCell(withIdentifier: BigBannerTableViewCell.identifier) as! BigBannerTableViewCell
            cell.bannerType = "featurebanner"
            cell.delegate = homeViewController
            //cell.bannerCollectionModel = ((item as? HomeViewModelBannerItem)?.bannerCollectionModel)!
            
            let featuredBannerUrl = ((item as? FeaturedProductsBannerItem)?.featuredProductsBannerUrl)!
            cell.bannerImageView.getImageFromUrl(imageUrl: featuredBannerUrl)
            cell.selectionStyle = .none
            return cell
            
        case .FeatureProduct:
            let cell:ProductTableViewCell = tableView.dequeueReusableCell(withIdentifier: ProductTableViewCell.identifier) as! ProductTableViewCell
            //cell.showFeature = true
            cell.productType = ProductType.feature
            cell.prodcutCollectionView.reloadData()
            cell.prodcutCollectionView.tag = indexPath.section
            //cell.productCollectionModel = ((item as? HomeViewModelLatestItem)?.latestProductCollectionModel)!
            cell.productCollectionModel =  featuredProductsInfo //((item as? HomeViewModelFeatureItem)?.featuredProductCollectionModel)!
            cell.delegate = homeViewController
            //cell.featuredProductCollectionModel = featuredProductCollectionModel
            cell.parentVC = homeViewController
            cell.homeViewModel = homeViewController.homeViewModel
            
            cell.selectionStyle = .none
            return cell
            //return UITableViewCell()
            
        case .NewProductsBanner:
            
            let cell:BigBannerTableViewCell = tableView.dequeueReusableCell(withIdentifier: BigBannerTableViewCell.identifier) as! BigBannerTableViewCell
            cell.bannerType = "newbanner"
            cell.delegate = homeViewController
            let newProductBannerUrl = ((item as? NewProductsBannerItem)?.latestProductsBannerUrl)!
            cell.bannerImageView.getImageFromUrl(imageUrl: newProductBannerUrl)
            cell.selectionStyle = .none
            return cell
            
        case .NewProduct:
            let cell:ProductTableViewCell = tableView.dequeueReusableCell(withIdentifier: ProductTableViewCell.identifier) as! ProductTableViewCell
            //cell.showFeature = false
            cell.productType = ProductType.latest //"NEW PRODUCT"
            cell.prodcutCollectionView.reloadData()
            cell.prodcutCollectionView.tag = indexPath.section
            //cell.productCollectionModel = ((item as? HomeViewModelLatestItem)?.latestProductCollectionModel)!
            cell.productCollectionModel = latestProductsInfo // ((item as? HomeViewModelLatestItem)?.latestProductCollectionModel)!
            cell.delegate = homeViewController
            //cell.featuredProductCollectionModel = featuredProductCollectionModel
            cell.parentVC = homeViewController
            cell.homeViewModel = homeViewController.homeViewModel
            
            cell.selectionStyle = .none
            return cell
          
        case .DealProductsBanner:
            let cell:BigBannerTableViewCell = tableView.dequeueReusableCell(withIdentifier: BigBannerTableViewCell.identifier) as! BigBannerTableViewCell
            cell.bannerType = "hotdealbanner"
            cell.delegate = homeViewController
            let dealBannerUrl = ((item as? DealProductsBannerItem)?.dealProductsBannerUrl)!
            cell.bannerImageView.getImageFromUrl(imageUrl: dealBannerUrl)
            cell.selectionStyle = .none
            return cell
            
        case .hotDeal:
            
            let cell:ProductTableViewCell = tableView.dequeueReusableCell(withIdentifier: ProductTableViewCell.identifier) as! ProductTableViewCell
            //cell.showFeature = false
            cell.productType = ProductType.hotdeal //"NEW PRODUCT"
            cell.prodcutCollectionView.reloadData()
            cell.prodcutCollectionView.tag = indexPath.section
            //cell.productCollectionModel = ((item as? HomeViewModelLatestItem)?.latestProductCollectionModel)!
            cell.productCollectionModel = hotdealProductsInfo //((item as? HomeViewModelHotdealItem)?.hotDealsProduct)!
            cell.delegate = homeViewController
            //cell.featuredProductCollectionModel = featuredProductCollectionModel
            cell.parentVC = homeViewController
            cell.homeViewModel = homeViewController.homeViewModel
            cell.selectionStyle = .none
            return cell
            
            /*
            let cell:HotdealsTableViewCell = tableView.dequeueReusableCell(withIdentifier: HotdealsTableViewCell.identifier) as! HotdealsTableViewCell
            cell.hotdealCollectionModel = ((item as? HomeViewModelHotdealItem)?.hotDealsProduct)!
            cell.hotdelalCollectionView.reloadData()
            cell.delegate = homeViewController
            cell.selectionStyle = .none
            return cell
            */
            
        case .RecentViewData:
            let cell:RecentViewTableViewCell = tableView.dequeueReusableCell(withIdentifier: RecentViewTableViewCell.identifier) as! RecentViewTableViewCell
            cell.recentCollectionModel = ((item as? HomeViewModelRecentViewItem)?.recentViewProductData)!
            cell.recentViewCollectionView.reloadData()
            cell.delegate = homeViewController
            cell.parentVC = homeViewController
            cell.selectionStyle = .none
            return cell
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        let item = items[indexPath.section]
        switch item.type {
        case .Banner:
            return SCREEN_WIDTH / 2
            
        case .FeatureCategory:
            return 130
            
        case .FeaturedProductsBanner:
            return SCREEN_WIDTH - 100
            
        case .FeatureProduct:
            return UITableViewAutomaticDimension
            
        case .NewProductsBanner:
            return SCREEN_WIDTH - 100
            
        case .NewProduct:
            return UITableViewAutomaticDimension
          
        case .DealProductsBanner:
            return SCREEN_WIDTH - 100
            
        case .hotDeal:
            return UITableViewAutomaticDimension
            //return SCREEN_WIDTH / 2 + 140
            
        case .RecentViewData:
            return SCREEN_WIDTH / 2 + 140
        }
    }
}
