//
//  Productcategory.swift
//  OpenCartApplication
//
//  Created by Webkul  on 30/08/17.
//  Copyright © 2017 webkul. All rights reserved.
//

import UIKit
import SwiftMessages
import EzPopup


protocol FilterItemsDelegate: class {
    func updateArray(dictArray: NSDictionary, code: String)
    func removeFromArray(postion: Int)
    func removeAllObjFromArray()
}

class Productcategory: AfritiaBaseViewController ,UIPickerViewDelegate{
    
    @IBOutlet weak var afritiaNavBarView: AFNavigationBarView!
    @IBOutlet weak var afritiaNavBarViewHeight: NSLayoutConstraint!
    
    @IBOutlet weak var sortbyLabel: UILabel!
    @IBOutlet weak var filterbyLabel: UILabel!
    @IBOutlet weak var productCollectionView: UICollectionView!
    @IBOutlet weak var ic_grid_list_imageview: UIImageView!
    @IBOutlet weak var gridListbyLabel: UILabel!
    @IBOutlet weak var sortFilterSuperView: UIView!
    @IBOutlet var bottomImage: UIImageView!
    
    public var categoryName:String = ""
    public var categoryId:String = ""
    public var categoryType:String = ""
    public var searchQuery:String = ""
    public var sellerId:String = ""
    public var queryString:NSMutableArray!
    
    fileprivate var change:Bool = true
    fileprivate var filterCodeValue:NSMutableArray = []
    fileprivate var filterIdValue:NSMutableArray = []
    fileprivate var sortDir:String = ""
    fileprivate var sortItem: String = ""
    fileprivate var productCollectionViewModel:ProductCollectionViewModel!
    //var productCollectionModel:[ProductCollectionModel]!
    fileprivate var loadPageRequestFlag: Bool = false
    fileprivate var totalCount:Int = 0
    fileprivate var indexPathValue:IndexPath!
    fileprivate var filterCodeHeader:NSMutableArray = []
    fileprivate var filterItemValue:NSMutableArray = []
    fileprivate var pageNumber:Int = 1
    fileprivate var ratingScrollView: UIScrollView!
    fileprivate var sortingDictionary:NSArray = []
    fileprivate var sortSignal:Int = 0
    fileprivate var sortDirection: NSMutableArray = []
    fileprivate var sortDataPicker: UIPickerView!
    fileprivate var productID:String!
    fileprivate var productName:String!
    fileprivate var productImageURL:String!
    fileprivate var mainCollection:JSON!
    fileprivate var productCategoryData: NSArray = []
    fileprivate var sendPopUpData:NSDictionary!
    fileprivate var currentIndex:Int = 0
    fileprivate var filteredItemArray :NSMutableArray = []
    fileprivate var reloadPageData:Bool = false
    fileprivate  var productQty:String = ""
    
    fileprivate var modelTag:Int = 0
    fileprivate var footerView:CustomFooterView?
    let footerViewReuseIdentifier = "RefreshFooterView"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.setUpCustomNavigationBar()
        
        let nib = UINib(nibName: "ProductImageCell", bundle:nil)
        self.productCollectionView.register(nib, forCellWithReuseIdentifier: "productimagecell")
        
        self.productCollectionView.register(UINib(nibName: "CustomFooterView", bundle: nil), forSupplementaryViewOfKind: UICollectionElementKindSectionFooter, withReuseIdentifier: "RefreshFooterView")
        
        let refreshControl = UIRefreshControl()
        let attributes = [NSAttributedStringKey.foregroundColor: UIColor.black]
        let attributedTitle = NSAttributedString(string: GlobalData.sharedInstance.language(key: "refreshing"), attributes: attributes)
        refreshControl.attributedTitle = attributedTitle
        refreshControl.addTarget(self, action: #selector(refresh(_:)), for: .valueChanged)
        //productCollectionView.refreshControl = refreshControl
        
        sortbyLabel.text = GlobalData.sharedInstance.language(key: "sort")
        filterbyLabel.text = GlobalData.sharedInstance.language(key: "filter")
        self.callApiForCategoryType(catType:self.categoryType)
        
        bottomImage.isUserInteractionEnabled = true
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(self.scorllUp))
        bottomImage.addGestureRecognizer(tapGesture)
        bottomImage.isHidden = true
        bottomImage.layer.cornerRadius = 20
        bottomImage.layer.borderWidth = 0.5
        bottomImage.layer.borderColor = UIColor.button.cgColor
        bottomImage.layer.masksToBounds = true
        
        gridListbyLabel.text = GlobalData.sharedInstance.language(key: "grid")
        
        sortFilterSuperView.isHidden = false
        
        //registerForPreviewing(with: self, sourceView: productCollectionView)
    }
    
    fileprivate func setUpCustomNavigationBar(){
        
        self.navigationController?.isNavigationBarHidden = true
        self.tabBarController!.tabBar.applyAfritiaTheme()
        
        self.changeStatusBarColor(color: UIColor.LightLavendar)

        afritiaNavBarView.searchbarStyle = NavBarStyle.compact
        //afritiaNavBarView.navBarHeight = self.afritiaNavBarViewHeight
        self.afritiaNavBarViewHeight.constant = NavBarHeight.compact.rawValue
        //afritiaNavBarView.configureTitleView(isVisible:true, titleType:.image, title:nil, image:navIcon.appLogo)
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
    
    override func viewWillAppear(_ animated: Bool) {
        
        self.tabBarController?.tabBar.isHidden = false
        if self.isMovingToParentViewController{
        }else{
            APIServiceManager.shared.removePreviousNetworkCall()
            GlobalData.sharedInstance.dismissLoader()
        }
    }
    
    override func willMove(toParentViewController parent: UIViewController?) {
        super.willMove(toParentViewController: parent)
        GlobalData.sharedInstance.dismissLoader()
        //self.navigationController?.isNavigationBarHidden = false
        self.tabBarController!.tabBar.isHidden = false
    }
    
    @objc func scorllUp(_sender : UITapGestureRecognizer){
        /*
        let indexPath = IndexPath(row: 0, section: 0)
        productCollectionView.scrollToItem(at: indexPath, at: .top, animated: true)
        self.navigationController?.setNavigationBarHidden(false, animated: true)
        */
    }
    
    @objc func refresh(_ refreshControl: UIRefreshControl) {
        refreshControl.endRefreshing()
    }
    
    func scrollViewWillEndDragging(_ scrollView: UIScrollView, withVelocity velocity: CGPoint, targetContentOffset: UnsafeMutablePointer<CGPoint>) {
        
        /*
        if(velocity.y>0) {
            UIView.animate(withDuration:0.3, delay: 0, options: UIViewAnimationOptions(), animations: {
                self.navigationController?.setNavigationBarHidden(false, animated: true)
            }, completion: nil)
            
        } else {
            UIView.animate(withDuration:0.3, delay: 0, options: UIViewAnimationOptions(), animations: {
                self.navigationController?.setNavigationBarHidden(true, animated: true)
            }, completion: nil)
        }*/
    }
    
    @IBAction func changeView(_ sender: UITapGestureRecognizer) {
        if change == false{
            ic_grid_list_imageview.image = UIImage(named: "ic_grid")
            change = true
            let nib = UINib(nibName: "ProductImageCell", bundle:nil)
            self.productCollectionView.register(nib, forCellWithReuseIdentifier: "productimagecell")
            productCollectionView.reloadData()
            gridListbyLabel.text = GlobalData.sharedInstance.language(key: "grid")
        }else{
            ic_grid_list_imageview.image = UIImage(named: "ic_list")
            change = false
            let nib = UINib(nibName: "ListCollectionViewCell", bundle:nil)
            self.productCollectionView.register(nib, forCellWithReuseIdentifier: "listcollectionview")
            productCollectionView.reloadData()
            gridListbyLabel.text = GlobalData.sharedInstance.language(key: "list")
        }
    }
    
    /*
    @objc func addToWishList(sender: UIButton){
        let customerId = defaults.object(forKey: "customerId")
        if customerId != nil{
            
            let wishListFlag = productCollectionViewModel.getProductCollectionData[sender.tag].isInWishlist
            
            if !wishListFlag!{
                productID = productCollectionViewModel.getProductCollectionData[sender.tag].id
                whichApiToProcess = "addtowishlist"
                sender.setImage(UIImage(named: "ic_wishlist_fill")!, for: .normal)
                modelTag = sender.tag
                
                callingExtraHttpApi()
            }else{
                productID = productCollectionViewModel.getProductCollectionData[sender.tag].wishlistItemId
                whichApiToProcess = "removewishlist"
                sender.setImage(UIImage(named: "ic_wishlist_empty")!, for: .normal)
                modelTag = sender.tag
                productCollectionViewModel.setWishListFlagToProductCategoryModel(data:false , pos: sender.tag)
                callingExtraHttpApi()
            }
        }else{
            AlertManager.shared.showWarningSnackBar(msg: GlobalData.sharedInstance.language(key: "loginrequired"))
        }
    }
    */
    
    @objc func addToWishList(sender: UIButton){
        
        modelTag = sender.tag
        let customerId = DEFAULTS.object(forKey:"customerId");
        if customerId != nil{
            let selProduct = productCollectionViewModel.getProductCollectionData[sender.tag]
            //productCollectionViewModel.getProductCollectionData[sender.tag]
            self.getAllAvailableWishlistGroups { (allWishListGroups) in
                self.openWishlistPopUp(availWishList: allWishListGroups, selProdInfo: selProduct, selWishBtn: sender)
            }
        }
        else
        {
            AlertManager.shared.showWarningSnackBar(msg: GlobalData.sharedInstance.language(key: "loginrequired"))
        }
    }
   
    func openWishlistPopUp(availWishList:[MyWishlistGroupModel], selProdInfo:ProductCollectionModel, selWishBtn:UIButton){
        let vc = AppStoryboard.Main.instance.instantiateViewController(withIdentifier: "WishListGroupPopUpVC") as! WishListGroupPopUpVC
        vc.myWishlistGroupData = availWishList
        
        vc.callBackOnSubmitClick = {(groupId, groupName) in
            print(groupId, groupName)
            
            GlobalData.sharedInstance.showLoader()
            
            var requstParams = [String:Any]()
            requstParams["storeId"] = UserManager.getStoreId
            requstParams["wishlist"] = groupId
            requstParams["newWishlistName"] = ""
            if groupId == "new"{
                requstParams["newWishlistName"] = groupName
            }
            requstParams["customerToken"] = UserManager.getCustomerId
            requstParams["productId"] = selProdInfo.id
            
            print("Request Params: \(requstParams)")
            
            APIServiceManager.shared.callingHttpRequestWithoutView(params:requstParams, apiname:AfritiaAPI.addNewWishListGroupWithProduct ){success,responseObject in
                if success == 1{
                    print(responseObject!)
                    let apiResponse = responseObject as? NSDictionary
                    
                    GlobalData.sharedInstance.dismissLoader()
                    AlertManager.shared.showSuccessSnackBar(msg:apiResponse!["message"] as! String)
                
                    if selProdInfo.isInWishlist == false{
                        self.modelTag = selWishBtn.tag
                        selWishBtn.setImage(UIImage(named: "ic_wishlist_fill")!, for: .normal)
                        self.productCollectionViewModel.setWishListFlagToProductCategoryModel(data:true , pos: selWishBtn.tag)
                    }else{
                        self.modelTag = selWishBtn.tag
                        selWishBtn.setImage(UIImage(named: "ic_wishlist_empty")!, for: .normal)
                        self.productCollectionViewModel.setWishListFlagToProductCategoryModel(data:false , pos: selWishBtn.tag)
                    }
                    
                }else if success == 2 {
                    //self.callApiForMultiWishlist(apiType:MultiWishlistAPIType.addNewWishListGroup)
                    //GlobalData.sharedInstance.dismissLoader()
                }
            }

        }
        
        let popViewHeight = 44 + 120 + (40 * (availWishList.count+1))
        // Init popup view controller with content is your content view controller
        let popupVC = PopupViewController(contentController: vc, popupWidth:SCREEN_WIDTH-100, popupHeight: CGFloat(popViewHeight))
        popupVC.backgroundAlpha = 0.4
        popupVC.backgroundColor = .black
        popupVC.canTapOutsideToDismiss = false
        popupVC.cornerRadius = 10
        popupVC.shadowEnabled = false
    
        self.present(popupVC, animated: true)
    }
    
    func getAllAvailableWishlistGroups(completionBlock:@escaping completionHandler){
        
        //self.mutliWishlistApiType = Mu
        GlobalData.sharedInstance.showLoader()
        
        var requstParams = [String:Any]()
        requstParams["storeId"] = DEFAULTS.object(forKey:"storeId") as! String
        requstParams["pageNumber"] =  "1"
        requstParams["customerToken"] = DEFAULTS.object(forKey:"customerId") as! String
        
        APIServiceManager.shared.callingHttpRequestWithoutView(params:requstParams, apiname:AfritiaAPI.allAvailableWishlist){success,responseObject in
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
    }
    
    @objc func addToCompare(sender: UIButton){
        productID = productCollectionViewModel.getProductCollectionData[sender.tag].id
        self.callExtraApiForAddToCompare()
    }
    
    @IBAction func filterBY(_ sender: UITapGestureRecognizer) {
        
        if productCollectionViewModel.layeredData.count > 0{
            let filterListVC = storyboard?.instantiateViewController(withIdentifier: "FilterListViewController") as! FilterListViewController
            filterListVC.layeredDataForFilter = productCollectionViewModel.getAllLayerData
            filterListVC.delegate = self
            filterListVC.filteredItemArray2 = filteredItemArray
            
            let appDelegate = UIApplication.shared.delegate as! AppDelegate
            appDelegate.window?.rootViewController!.present(filterListVC, animated: true, completion: nil)
        }
        else
        {
            if(filteredItemArray.count>0){
                let myVC = storyboard?.instantiateViewController(withIdentifier: "FilterListViewController") as! FilterListViewController
                myVC.layeredDataForFilter = productCollectionViewModel.layeredData as NSArray
                myVC.delegate = self
                myVC.filteredItemArray2 = filteredItemArray
                let appDelegate = UIApplication.shared.delegate as! AppDelegate
                appDelegate.window?.rootViewController!.present(myVC, animated: true, completion: nil)
            }
            else{
                AlertManager.shared.showErrorSnackBar(msg: GlobalData.sharedInstance.language(key: "nofilteroption"))
            }
        }
    }
    
    @IBAction func sortBy(_ sender: UITapGestureRecognizer) {
       
        if self.productCollectionViewModel.getSortCollectionData.count == 0{
            AlertManager.shared.showErrorSnackBar(msg:GlobalData.sharedInstance.language(key: "nosortingdata") )
        }else{
            let alert = UIAlertController(title: GlobalData.sharedInstance.language(key: "chooseyoursortselection"), message: nil, preferredStyle: .actionSheet)
            for i in 0..<self.productCollectionViewModel.getSortCollectionData.count {
                var image:UIImage!
                if (sortDirection[i] as AnyObject).isEqual("0") {
                    image = UIImage(named: "ic_up")
                    
                }else{
                    image = UIImage(named: "ic_down")
                }
                
                let str : String = productCollectionViewModel.getSortCollectionData[i].label
                let action = UIAlertAction(title: str, style: .default, handler: {(_ action: UIAlertAction) -> Void in
                    self.selectSortData(data:i)
                })
                action.setValue(image, forKey: "image")
                alert.addAction(action)
            }
            
            let cancel = UIAlertAction(title: GlobalData.sharedInstance.language(key: "cancel"), style: .cancel, handler: {(_ action: UIAlertAction) -> Void in
            })
            alert.addAction(cancel)
            
            // Support display in iPad
            alert.popoverPresentationController?.sourceView = self.view
            alert.popoverPresentationController?.sourceRect = CGRect(x:self.view.bounds.size.width / 2.0, y: self.view.bounds.size.height / 2.0, width : 1.0, height : 1.0)
            self.present(alert, animated: true, completion: nil)
        }
 
    }
    
    func selectSortType(type:String){
      
        sortDir = "1"
        sortItem = type
        pageNumber = 1
        callApiForCategoryType(catType:"")
    }
    
    func selectSortData(data:Int){
        if (sortDirection[data] as AnyObject).isEqual("0") {
            sortDirection[data] = "1"
            sortDir = "1"
        }else {
            sortDirection[data] = "0"
            sortDir = "0"
        }
        sortItem = self.productCollectionViewModel.getSortCollectionData[data].code
        pageNumber = 1
        callApiForCategoryType(catType:"")
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let currentCellCount = self.productCollectionView.numberOfItems(inSection: 0)
        for cell: UICollectionViewCell in self.productCollectionView.visibleCells {
            indexPathValue = self.productCollectionView.indexPath(for: cell)!
            if indexPathValue.row == self.productCollectionView.numberOfItems(inSection: 0) - 1 {
                if (totalCount > currentCellCount) && loadPageRequestFlag{
                    loadPageRequestFlag = false
                    pageNumber += 1
                    callApiForCategoryType(catType:self.categoryType)
                }
            }
            if cell.frame.origin.y > SCREEN_HEIGHT - 50{
                bottomImage.isHidden = false
            }else{
                bottomImage.isHidden = true
            }
        }
    }
}

extension Productcategory : FilterItemsDelegate {
    
    func updateArray(dictArray: NSDictionary, code: String){
       
        filteredItemArray.add(dictArray)
        dismiss(animated: true, completion: nil)
        filterCodeValue.add(code)
        filterIdValue.add(dictArray["id"] as! String)
        pageNumber = 1
        self.callApiForCategoryType(catType:"")
      
        /*
        
        for i in 0..<selectedFilter.count{
            
            let dictArray1 = selectedFilter[i] as! NSDictionary
            filteredItemArray.add(dictArray1)
            dismiss(animated: true, completion: nil)
            
            let code1 = selectedCode[i] as! String
            filterCodeValue.add(code1)
            filterIdValue.add(dictArray1["id"] as! String)
            pageNumber = 1
        }
        self.callingHttppApi()
        */
    }
    
    func removeFromArray(postion: Int){
        filteredItemArray.removeObject(at: postion)
        filterCodeValue.removeObject(at: postion)
        filterIdValue.removeObject(at: postion)
        dismiss(animated: true, completion: nil)
        pageNumber = 1
        self.callApiForCategoryType(catType:"")
    }
    
    func removeAllObjFromArray(){
        filteredItemArray.removeAllObjects()
        filterCodeValue.removeAllObjects()
        filterIdValue.removeAllObjects()
        
        dismiss(animated: true, completion: nil)
        pageNumber = 1
        self.callApiForCategoryType(catType:"")
    }
}

extension Productcategory : UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    //MARK:- UICollectionView
    
    func collectionView(_ view: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        //        if (productCollectionViewModel.getProductCollectionData.count > 0)   {
        //            sortFilterSuperView.isHidden = false
        //        }else{
        //            sortFilterSuperView.isHidden = true
        //        }
        
        return productCollectionViewModel.getProductCollectionData.count
    }
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        if change == true{
            
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "productimagecell", for: indexPath) as! ProductImageCell
            cell.layer.borderColor = UIColor.LightLavendar.cgColor
            cell.layer.borderWidth = 0.5
            cell.productImage.image = UIImage(named: "ic_placeholder.png")
            cell.productName.text = productCollectionViewModel.getProductCollectionData[indexPath.row].productName
            cell.productPrice.text =  productCollectionViewModel.getProductCollectionData[indexPath.row].price
            GlobalData.sharedInstance.getImageFromUrl(imageUrl:productCollectionViewModel.getProductCollectionData[indexPath.row].productImage , imageView: cell.productImage)
            cell.specialPrice.isHidden = true
            
            if productCollectionViewModel.getProductCollectionData[indexPath.row].isInWishlist == true{
                cell.wishListButton.setImage(UIImage(named: "ic_wishlist_fill")!, for: .normal)
            }else{
                cell.wishListButton.setImage(UIImage(named: "ic_wishlist_empty")!, for: .normal)
            }
            
            cell.wishListButton.tag = indexPath.row
            cell.wishListButton.addTarget(self, action: #selector(addToWishList(sender:)), for: .touchUpInside)
            cell.wishListButton.isUserInteractionEnabled = true
            
            cell.addToCompareButton.tag = indexPath.row
            cell.addToCompareButton.addTarget(self, action: #selector(addToCompare(sender:)), for: .touchUpInside)
            cell.addToCompareButton.isUserInteractionEnabled = true
            
            cell.btnQuickViewHeight.constant = 0
            cell.btnQuickView.isHidden = true
            
            if productCollectionViewModel.getProductCollectionData[indexPath.row].typeID == "grouped"{
                cell.productPrice.text =  productCollectionViewModel.getProductCollectionData[indexPath.row].groupedPrice
                
            }else if productCollectionViewModel.getProductCollectionData[indexPath.row].typeID == "bundle"{
                cell.productPrice.text =  productCollectionViewModel.getProductCollectionData[indexPath.row].formatedMinPrice+" - "+productCollectionViewModel.getProductCollectionData[indexPath.row].formatedMaxPrice
            }else{
                if productCollectionViewModel.getProductCollectionData[indexPath.row].isInRange == true{
                    if productCollectionViewModel.getProductCollectionData[indexPath.row].specialPrice < productCollectionViewModel.getProductCollectionData[indexPath.row].normalprice{
                        cell.productPrice.text = productCollectionViewModel.getProductCollectionData[indexPath.row].formatedSpecialPrice
                        let attributeString = NSMutableAttributedString(string: productCollectionViewModel.getProductCollectionData[indexPath.row].formatedPrice)
                        attributeString.addAttribute(NSAttributedStringKey.strikethroughStyle, value: 1, range: NSRange(location: 0, length: attributeString.length))
                        cell.specialPrice.attributedText = attributeString
                        cell.specialPrice.isHidden = false
                    }else{
                        cell.productPrice.text =  productCollectionViewModel.getProductCollectionData[indexPath.row].price
                        cell.specialPrice.isHidden = true
                    }
                }
            }
            
            if productCollectionViewModel.getProductCollectionData[indexPath.row].isFreeshipping == "Yes"{
                cell.lblShipping.text = "freeshipping".localized
            }else{
                cell.lblShipping.text = "shippingword".localized + ": \(productCollectionViewModel.getProductCollectionData[indexPath.row].shippingPrice ?? "0")"
            }
            
            return cell
            
        }
        else{
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "listcollectionview", for: indexPath) as! ListCollectionViewCell
            cell.layer.borderColor = UIColor.LightLavendar.cgColor
            cell.layer.borderWidth = 0.5
            cell.imageView.image = UIImage(named: "ic_placeholder.png")
            cell.name.text = productCollectionViewModel.getProductCollectionData[indexPath.row].productName
            cell.price.text =  productCollectionViewModel.getProductCollectionData[indexPath.row].price
            cell.descriptionData.text = productCollectionViewModel.getProductCollectionData[indexPath.row].descriptionData
            GlobalData.sharedInstance.getImageFromUrl(imageUrl:productCollectionViewModel.getProductCollectionData[indexPath.row].productImage , imageView: cell.imageView)
            cell.wishList_Button.tag = indexPath.row
            cell.compare_Button.tag = indexPath.row
            
            cell.specialPrice.isHidden = true
            
            if productCollectionViewModel.getProductCollectionData[indexPath.row].isInWishlist == true{
                cell.wishList_Button.setImage(UIImage(named: "ic_wishlist_fill")!, for: .normal)
            }else{
                cell.wishList_Button.setImage(UIImage(named: "ic_wishlist_empty")!, for: .normal)
            }
            
            cell.wishList_Button.tag = indexPath.row
            cell.wishList_Button.addTarget(self, action: #selector(addToWishList(sender:)), for: .touchUpInside)
            cell.wishList_Button.isUserInteractionEnabled = true
            
            cell.compare_Button.tag = indexPath.row
            cell.compare_Button.addTarget(self, action: #selector(addToCompare(sender:)), for: .touchUpInside)
            cell.compare_Button.isUserInteractionEnabled = true
            
            if productCollectionViewModel.getProductCollectionData[indexPath.row].typeID == "grouped"{
                cell.price.text =  productCollectionViewModel.getProductCollectionData[indexPath.row].groupedPrice
            }else if productCollectionViewModel.getProductCollectionData[indexPath.row].typeID == "bundle"{
                cell.price.text =  productCollectionViewModel.getProductCollectionData[indexPath.row].formatedMinPrice
            }else{
                if productCollectionViewModel.getProductCollectionData[indexPath.row].isInRange == true{
                    if productCollectionViewModel.getProductCollectionData[indexPath.row].specialPrice < productCollectionViewModel.getProductCollectionData[indexPath.row].normalprice{
                        cell.price.text = productCollectionViewModel.getProductCollectionData[indexPath.row].formatedSpecialPrice
                        let attributeString = NSMutableAttributedString(string: productCollectionViewModel.getProductCollectionData[indexPath.row].formatedPrice)
                        attributeString.addAttribute(NSAttributedStringKey.strikethroughStyle, value: 1, range: NSRange(location: 0, length: attributeString.length))
                        cell.specialPrice.attributedText = attributeString
                        cell.specialPrice.isHidden = false
                    }else{
                        cell.price.text =  productCollectionViewModel.getProductCollectionData[indexPath.row].price
                        cell.specialPrice.isHidden = true
                    }
                }
            }
            
            if productCollectionViewModel.getProductCollectionData[indexPath.row].isFreeshipping == "Yes"{
                cell.lblShipping.text = "freeshipping".localized
            }else{
                cell.lblShipping.text = "shippingword".localized + ": \(productCollectionViewModel.getProductCollectionData[indexPath.row].shippingPrice ?? "0")"
            }
            
            return cell
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
        return CGSize.zero
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForFooterInSection section: Int) -> CGSize {
        let currentCellCount = self.productCollectionView.numberOfItems(inSection: 0)
        if totalCount > currentCellCount{
            return CGSize(width: collectionView.bounds.size.width, height: 55)
        }else{
            return CGSize.zero
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        if kind == UICollectionElementKindSectionFooter {
            let aFooterView = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: footerViewReuseIdentifier, for: indexPath) as! CustomFooterView
            self.footerView = aFooterView
            self.footerView?.backgroundColor = UIColor.clear
            return aFooterView
        } else {
            let headerView = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: footerViewReuseIdentifier, for: indexPath)
            return headerView
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, willDisplaySupplementaryView view: UICollectionReusableView, forElementKind elementKind: String, at indexPath: IndexPath) {
        if elementKind == UICollectionElementKindSectionFooter {
            self.footerView?.startAnimate()
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, didEndDisplayingSupplementaryView view: UICollectionReusableView, forElementOfKind elementKind: String, at indexPath: IndexPath) {
        if elementKind == UICollectionElementKindSectionFooter {
            self.footerView?.stopAnimate()
        }
    }
    
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        sizeForItemAt indexPath: IndexPath) -> CGSize {
        if change == true{
            return CGSize(width: collectionView.frame.size.width/2, height:SCREEN_WIDTH/2.5 + 120)
        }else{
            return CGSize(width: collectionView.frame.size.width, height:SCREEN_WIDTH/3 + 50)
            
        }
    }
    
    func shouldInvalidateLayout(forBoundsChange newBounds: CGRect) -> Bool {
        return true
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let vc = AppStoryboard.Main.instance.instantiateViewController(withIdentifier: "catalogproduct") as! CatalogProduct
        vc.productName = productCollectionViewModel.getProductCollectionData[indexPath.row].productName
        vc.productId = productCollectionViewModel.getProductCollectionData[indexPath.row].id
        vc.productImageUrl = productCollectionViewModel.getProductCollectionData[indexPath.row].productImage
        self.navigationController?.pushViewController(vc, animated: true)
    }
}

extension Productcategory {
    
    
    func callApiForCategoryType(catType:String){
        
        if catType == "newproduct"{
            self.callAPIforNewProduct()
        }
        else if catType == "featureproduct"{
            self.callApiForFeatureProduct()
        }
        else if catType == "hotdeal"{
            self.callApiForHotDeal()
        }
        else if catType == "advancesearchterms" {
            self.callApiForAdvanceSearch()
        }
        else if catType == "searchquery"{
            self.callApiForSearchQuery()
        }
        else if catType == "custom"{
            self.callApiForCustom()
        }
        else if catType == "marketplace"{
            self.callApiForMarketPlace()
        }else{
            self.callApiForDefault()
        }
    }
    
    func callAPIforNewProduct(){
        
        var requstParams = [String:Any]()
        requstParams["width"] = SCREEN_WIDTH
        requstParams["pageNumber"] = "\(pageNumber)"
        requstParams["storeId"] = UserManager.getStoreId
        requstParams["quoteId"] = UserManager.getQuoteId
        requstParams["customerToken"] = UserManager.getCustomerId
        requstParams["currency"] = UserManager.getCurrencyType

        
        let sortData:NSArray = [sortItem, sortDir]
        
        let filterData : NSArray = [filterIdValue, filterCodeValue]
        do {
            let jsonSortData =  try JSONSerialization.data(withJSONObject: sortData, options: .prettyPrinted)
            let jsonSortString:String = NSString(data: jsonSortData, encoding: String.Encoding.utf8.rawValue)! as String
            requstParams["sortData"] = jsonSortString
            let jsonFilterData =  try JSONSerialization.data(withJSONObject: filterData, options: .prettyPrinted)
            let jsonFilterString:String = NSString(data: jsonFilterData, encoding: String.Encoding.utf8.rawValue)! as String
            requstParams["filterData"] = jsonFilterString
        }
        catch {
            print(error.localizedDescription)
        }
        
        if pageNumber == 1{
            GlobalData.sharedInstance.showLoader()
        }
        
        APIServiceManager.shared.callingHttpRequest(params:requstParams, apiname:AfritiaAPI.newProductList, currentView: self){success,responseObject in
            
            GlobalData.sharedInstance.dismissLoader()
            
            if success == 1{
                
                print(responseObject as! NSDictionary)
                if self.pageNumber == 1{
                    self.productCollectionViewModel = ProductCollectionViewModel(data:JSON(responseObject as! NSDictionary))
                }else{
                    self.productCollectionViewModel.setProductCollectionData(data:JSON(responseObject as! NSDictionary))
                }
                self.doFurtherProcessingWithResult()
            }else if success == 2{
                self.callAPIforNewProduct()
                
            }
        }
    }
    
    func callApiForFeatureProduct(){
        
        var requstParams = [String:Any]()
        
        requstParams["width"] = SCREEN_WIDTH
        requstParams["pageNumber"] = "\(pageNumber)"
        requstParams["storeId"] = UserManager.getStoreId
        requstParams["quoteId"] = UserManager.getQuoteId
        requstParams["customerToken"] = UserManager.getCustomerId
        requstParams["currency"] = UserManager.getCurrencyType

        let sortData:NSArray = [sortItem, sortDir]
        let filterData : NSArray = [filterIdValue, filterCodeValue]
        do {
            let jsonSortData =  try JSONSerialization.data(withJSONObject: sortData, options: .prettyPrinted)
            let jsonSortString:String = NSString(data: jsonSortData, encoding: String.Encoding.utf8.rawValue)! as String
            requstParams["sortData"] = jsonSortString
            let jsonFilterData =  try JSONSerialization.data(withJSONObject: filterData, options: .prettyPrinted)
            let jsonFilterString:String = NSString(data: jsonFilterData, encoding: String.Encoding.utf8.rawValue)! as String
            requstParams["filterData"] = jsonFilterString
        }
        catch {
            print(error.localizedDescription)
        }

        if pageNumber == 1{
            GlobalData.sharedInstance.showLoader()
        }
        
        APIServiceManager.shared.callingHttpRequest(params:requstParams, apiname:AfritiaAPI.featuredProductList, currentView: self){success,responseObject in
            GlobalData.sharedInstance.dismissLoader()
            if success == 1{
                print("More product responce \(responseObject)")
                if self.pageNumber == 1{
                    self.productCollectionViewModel = ProductCollectionViewModel(data:JSON(responseObject as! NSDictionary))
                }else{
                    self.productCollectionViewModel.setProductCollectionData(data:JSON(responseObject as! NSDictionary))
                }
                self.doFurtherProcessingWithResult()
            }else if success == 2{
                self.callApiForFeatureProduct()
                
            }
        }
    }
    
    func callApiForHotDeal(){
        
        var requstParams = [String:Any]()
        requstParams["width"] = SCREEN_WIDTH
        requstParams["pageNumber"] = "\(pageNumber)"
        requstParams["storeId"] = UserManager.getStoreId
        requstParams["quoteId"] = UserManager.getQuoteId
        requstParams["customerToken"] = UserManager.getCustomerId
        requstParams["currency"] = UserManager.getCurrencyType

        let sortData:NSArray = [sortItem, sortDir]
        let filterData : NSArray = [filterIdValue, filterCodeValue]
        do {
            let jsonSortData =  try JSONSerialization.data(withJSONObject: sortData, options: .prettyPrinted)
            let jsonSortString:String = NSString(data: jsonSortData, encoding: String.Encoding.utf8.rawValue)! as String
            requstParams["sortData"] = jsonSortString
            let jsonFilterData =  try JSONSerialization.data(withJSONObject: filterData, options: .prettyPrinted)
            let jsonFilterString:String = NSString(data: jsonFilterData, encoding: String.Encoding.utf8.rawValue)! as String
            requstParams["filterData"] = jsonFilterString
        }
        catch {
            print(error.localizedDescription)
        }
        
        if pageNumber == 1{
            GlobalData.sharedInstance.showLoader()
        }
        
        APIServiceManager.shared.callingHttpRequest(params:requstParams, apiname:AfritiaAPI.hotDealList, currentView: self){success,responseObject in
            GlobalData.sharedInstance.dismissLoader()
            
            if success == 1{
                print(responseObject!)
                if self.pageNumber == 1{
                    self.productCollectionViewModel = ProductCollectionViewModel(data:JSON(responseObject as! NSDictionary))
                }else{
                    self.productCollectionViewModel.setProductCollectionData(data:JSON(responseObject as! NSDictionary))
                }
                self.doFurtherProcessingWithResult()
            }
            else if success == 2{
                self.callApiForHotDeal()
            }
        }
    }
    
    func callApiForAdvanceSearch(){
        
        self.navigationItem.title = "advancesearchterms".localized
        
        var requstParams = [String:Any]()
        requstParams["width"] = SCREEN_WIDTH
        requstParams["pageNumber"] = "\(pageNumber)"
        requstParams["storeId"] = UserManager.getStoreId
        requstParams["quoteId"] = UserManager.getQuoteId
        requstParams["customerToken"] = UserManager.getCustomerId
        requstParams["currency"] = UserManager.getCurrencyType
        
       
        let sortData:NSArray = [sortItem, sortDir]
        let filterData : NSArray = [filterIdValue, filterCodeValue]
        do {
            let jsonSortData =  try JSONSerialization.data(withJSONObject: sortData, options: .prettyPrinted)
            let jsonSortString:String = NSString(data: jsonSortData, encoding: String.Encoding.utf8.rawValue)! as String
            requstParams["sortData"] = jsonSortString
            
            let jsonFilterData =  try JSONSerialization.data(withJSONObject: filterData, options: .prettyPrinted)
            let jsonFilterString:String = NSString(data: jsonFilterData, encoding: String.Encoding.utf8.rawValue)! as String
            requstParams["filterData"] = jsonFilterString
        }
        catch {
            print(error.localizedDescription)
        }
        
        requstParams["notificationId"] = categoryId
        
        do {
            let jsonFilterData =  try JSONSerialization.data(withJSONObject: queryString, options: .prettyPrinted)
            let jsonAdvanceString:String = NSString(data: jsonFilterData, encoding: String.Encoding.utf8.rawValue)! as String
            requstParams["queryString"] = jsonAdvanceString
        }
        catch {
            print(error.localizedDescription)
        }

        if pageNumber == 1{
            GlobalData.sharedInstance.showLoader()
        }
        
        APIServiceManager.shared.callingHttpRequest(params:requstParams, apiname:AfritiaAPI.advancedSearchResult, currentView: self){success,responseObject in
            GlobalData.sharedInstance.dismissLoader()
            
            if success == 1{
                print(responseObject!)
               
                if self.pageNumber == 1{
                    self.productCollectionViewModel = ProductCollectionViewModel(data:JSON(responseObject as! NSDictionary))
                    
                }else{
                    self.productCollectionViewModel.setProductCollectionData(data:JSON(responseObject as! NSDictionary))
                }
                self.doFurtherProcessingWithResult()
            }else if success == 2{
                
                self.callApiForAdvanceSearch()
            }
        }
    }
    
    func callApiForSearchQuery(){
        
        var requstParams = [String:Any]()
        requstParams["width"] = SCREEN_WIDTH
        requstParams["pageNumber"] = "\(pageNumber)"
        requstParams["storeId"] = UserManager.getStoreId
        requstParams["quoteId"] = UserManager.getQuoteId
        requstParams["customerToken"] = UserManager.getCustomerId
        requstParams["currency"] = UserManager.getCurrencyType
        
        
        let sortData:NSArray = [sortItem, sortDir]
        let filterData : NSArray = [filterIdValue, filterCodeValue]
        do {
            let jsonSortData =  try JSONSerialization.data(withJSONObject: sortData, options: .prettyPrinted)
            let jsonSortString:String = NSString(data: jsonSortData, encoding: String.Encoding.utf8.rawValue)! as String
            requstParams["sortData"] = jsonSortString
            let jsonFilterData =  try JSONSerialization.data(withJSONObject: filterData, options: .prettyPrinted)
            let jsonFilterString:String = NSString(data: jsonFilterData, encoding: String.Encoding.utf8.rawValue)! as String
            requstParams["filterData"] = jsonFilterString
        }
        catch {
            print(error.localizedDescription)
        }

        requstParams["searchQuery"] = searchQuery
        if pageNumber == 1{
            GlobalData.sharedInstance.showLoader()
        }
        
        APIServiceManager.shared.callingHttpRequest(params:requstParams, apiname:AfritiaAPI.searchResult, currentView: self){success,responseObject in
            GlobalData.sharedInstance.dismissLoader()
            if success == 1{
                
                print(responseObject!)
                
                if self.pageNumber == 1{
                    self.productCollectionViewModel = ProductCollectionViewModel(data:JSON(responseObject as! NSDictionary))
                }else{
                    self.productCollectionViewModel.setProductCollectionData(data:JSON(responseObject as! NSDictionary))
                }
                self.doFurtherProcessingWithResult()
            }else if success == 2{
                self.callApiForSearchQuery()
                
            }
        }
    }
    
    func callApiForCustom(){
        
        var requstParams = [String:Any]()
        requstParams["width"] = SCREEN_WIDTH
        requstParams["pageNumber"] = "\(pageNumber)"
        requstParams["storeId"] = UserManager.getStoreId
        requstParams["quoteId"] = UserManager.getQuoteId
        requstParams["customerToken"] = UserManager.getCustomerId
        requstParams["currency"] = UserManager.getCurrencyType
        
        let sortData:NSArray = [sortItem, sortDir]
        let filterData : NSArray = [filterIdValue, filterCodeValue]
        do {
            let jsonSortData =  try JSONSerialization.data(withJSONObject: sortData, options: .prettyPrinted)
            let jsonSortString:String = NSString(data: jsonSortData, encoding: String.Encoding.utf8.rawValue)! as String
            requstParams["sortData"] = jsonSortString
            
            let jsonFilterData =  try JSONSerialization.data(withJSONObject: filterData, options: .prettyPrinted)
            let jsonFilterString:String = NSString(data: jsonFilterData, encoding: String.Encoding.utf8.rawValue)! as String
            requstParams["filterData"] = jsonFilterString
        }
        catch {
            print(error.localizedDescription)
        }
        
        requstParams["notificationId"] = categoryId

        if pageNumber == 1{
            GlobalData.sharedInstance.showLoader()
        }
        APIServiceManager.shared.callingHttpRequest(params:requstParams, apiname:AfritiaAPI.customcollection, currentView: self){success,responseObject in
            GlobalData.sharedInstance.dismissLoader()
            
            if success == 1{
                print(responseObject!)

                if self.pageNumber == 1{
                    self.productCollectionViewModel = ProductCollectionViewModel(data:JSON(responseObject as! NSDictionary))
                }else{
                    self.productCollectionViewModel.setProductCollectionData(data:JSON(responseObject as! NSDictionary))
                }
                self.doFurtherProcessingWithResult()
            }else if success == 2{
                self.callApiForCustom()
            }
        }
    }
    
    func callApiForMarketPlace(){
        
        var requstParams = [String:Any]()
        requstParams["customerToken"] = UserManager.getCustomerId
        requstParams["sellerId"] = sellerId
        requstParams["width"] = SCREEN_WIDTH
        requstParams["pageNumber"] = "\(pageNumber)"
        requstParams["categoryId"] = "0"
        requstParams["storeId"] = UserManager.getStoreId
        
        let sortData:NSArray = [sortItem, sortDir]
        let filterData : NSArray = [filterIdValue, filterCodeValue]
        do {
            let jsonSortData =  try JSONSerialization.data(withJSONObject: sortData, options: .prettyPrinted)
            let jsonSortString:String = NSString(data: jsonSortData, encoding: String.Encoding.utf8.rawValue)! as String
            requstParams["sortData"] = jsonSortString
            let jsonFilterData =  try JSONSerialization.data(withJSONObject: filterData, options: .prettyPrinted)
            let jsonFilterString:String = NSString(data: jsonFilterData, encoding: String.Encoding.utf8.rawValue)! as String
            requstParams["filterData"] = jsonFilterString
        }
        catch {
            print(error.localizedDescription)
        }

        if pageNumber == 1{
            GlobalData.sharedInstance.showLoader()
        }
        
        APIServiceManager.shared.callingHttpRequest(params:requstParams, apiname:AfritiaSellerAPI.sellerCollection, currentView: self){success,responseObject in
            GlobalData.sharedInstance.dismissLoader()
            if success == 1{
                print(responseObject!)
                
                if self.pageNumber == 1{
                    self.productCollectionViewModel = ProductCollectionViewModel(data:JSON(responseObject as! NSDictionary))
                }else{
                    self.productCollectionViewModel.setProductCollectionData(data:JSON(responseObject as! NSDictionary))
                }
                self.doFurtherProcessingWithResult()
            }else if success == 2{
                
                self.callApiForMarketPlace()
            }
        }
    }
    
    func callApiForDefault(){
        
            var requstParams = [String:Any]()
            let storeId = DEFAULTS.object(forKey:"storeId")
            let quoteId = DEFAULTS.object(forKey: "quoteId")
            let customerId = DEFAULTS.object(forKey: "customerId")
            
            if storeId != nil{
                requstParams["storeId"] = storeId as! String
            }
            if(quoteId != nil){
                requstParams["quoteId"] = quoteId as! String
            }
            if(customerId != nil){
                requstParams["customerToken"] = customerId as! String
            }
            if DEFAULTS.object(forKey: "currency") != nil{
                requstParams["currency"] = DEFAULTS.object(forKey: "currency") as! String
            }
           
            
            let sortData:NSArray = [sortItem, sortDir]
            let filterData : NSArray = [filterIdValue, filterCodeValue]
            
            print("Sorting Data passed in API:  \(sortData)")
            
            
            
         do {
                let jsonSortData =  try JSONSerialization.data(withJSONObject: sortData, options: .prettyPrinted)
                let jsonSortString:String = NSString(data: jsonSortData, encoding: String.Encoding.utf8.rawValue)! as String
                requstParams["sortData"] =   jsonSortString
                
                print("Sorting Data JSON String: \(jsonSortString)")
                
                let jsonFilterData =  try JSONSerialization.data(withJSONObject: filterData, options: .prettyPrinted)
                let jsonFilterString:String = NSString(data: jsonFilterData, encoding: String.Encoding.utf8.rawValue)! as String
                requstParams["filterData"] = jsonFilterString
            }
            catch {
                print(error.localizedDescription)
            }
            requstParams["pageNumber"] = "\(pageNumber)"
            requstParams["categoryId"] = categoryId
            let width = String(format:"%f", SCREEN_WIDTH * UIScreen.main.scale)
            requstParams["width"] = width
            if pageNumber == 1{
                self.view.isUserInteractionEnabled = false
                GlobalData.sharedInstance.showLoader()
            }
            print("Params Sorted \(requstParams)")
            
            APIServiceManager.shared.callingHttpRequest(params:requstParams, apiname:AfritiaAPI.categoryProductList, currentView: self){success,responseObject in
                
                if success == 1{
                    print(responseObject!)
                    self.view.isUserInteractionEnabled = true
                    if self.pageNumber == 1{
                        self.productCollectionViewModel = ProductCollectionViewModel(data:JSON(responseObject as! NSDictionary))
                    }else{
                        self.productCollectionViewModel.setProductCollectionData(data:JSON(responseObject as! NSDictionary))
                    }
                    self.doFurtherProcessingWithResult()
                }else if success == 2{
                    GlobalData.sharedInstance.dismissLoader()
                    self.callApiForDefault()
                }
            }
    }
    
    func doFurtherProcessingWithResult()
    {
        if pageNumber == 1{
            GlobalData.sharedInstance.dismissLoader()
        }
        productCollectionView.delegate = self
        productCollectionView.dataSource = self
        productCollectionView.reloadData()
        totalCount = productCollectionViewModel.totalCount

        loadPageRequestFlag = true
        
        if totalCount == 0  {
            AlertManager.shared.showWarningSnackBar(msg: "searchproductsnotavailable".localized)
        }
        
        if self.sortSignal == 0 {
            for i in 0..<self.productCollectionViewModel.getSortCollectionData.count {
                if i == 0 {
                    self.sortDirection.add("1")
                }else {
                    self.sortDirection.add("0")
                }
            }
            self.sortSignal += 1
        }
    }
    
}


extension Productcategory {
    
    func callExtraApiForAddToCart(){
        
        GlobalData.sharedInstance.showLoader()
        
        var requstParams = [String:Any]()
        requstParams["storeId"] = UserManager.getStoreId
        requstParams["customerToken"] = UserManager.getCustomerId
        requstParams["quoteId"] = UserManager.getQuoteId
        requstParams["productId"] = productID
        requstParams["qty"] = "1"
        
        APIServiceManager.shared.callingHttpRequest(params:requstParams, apiname:AfritiaAPI.addToCart, currentView: self){success,responseObject in
            
            GlobalData.sharedInstance.dismissLoader()
            
            if success == 1{
                
                let data = responseObject as! NSDictionary
                let errorCode: Bool = data .object(forKey:"success") as! Bool
                
                if errorCode == true {
                    AlertManager.shared.showSuccessSnackBar(msg: data.object(forKey: "message") as! String)
                } else{
                    AlertManager.shared.showErrorSnackBar(msg:data.object(forKey: "message") as! String)
                }
                
            }else if success == 2{
                self.callExtraApiForAddToCart()
            }
        }
    }
    
    func callExtraApiForAddToCompare(){
        
        GlobalData.sharedInstance.showLoader()
        
        var requstParams = [String:Any]()
        requstParams["storeId"] = UserManager.getStoreId
        requstParams["customerToken"] = UserManager.getCustomerId
        requstParams["quoteId"] = UserManager.getQuoteId
        requstParams["productId"] = productID
        APIServiceManager.shared.callingHttpRequest(params:requstParams, apiname:AfritiaAPI.addToCompare, currentView: self){success,responseObject in
            GlobalData.sharedInstance.dismissLoader()
            
            if success == 1{
                if responseObject?.object(forKey: "storeId") != nil{
                    let storeId:String = String(format: "%@", responseObject!.object(forKey: "storeId") as! CVarArg)
                    if storeId != "0"{
                        DEFAULTS.set(storeId, forKey: "storeId")
                    }
                }
                
                let data = responseObject as! NSDictionary
                let errorCode: Bool = data .object(forKey:"success") as! Bool
                
                if errorCode == true{
                    AlertManager.shared.showSnackBarWithAction(onView:self, theme:.success, msg: data.object(forKey: "message") as! String, actionBtnTitle:"See List") { (btnTitle) in
                        self.performSegue(withIdentifier: "comparelist", sender: self)
                    }
                }
                else{
                    AlertManager.shared.showErrorSnackBar(msg:data.object(forKey: "message") as! String)
                }
                
            }else if success == 2{
                self.callExtraApiForAddToCompare()
            }
        }
    }
    
    func callExtraApiForAddToWishList(){
        
        GlobalData.sharedInstance.showLoader()
        var requstParams = [String:Any]()
        requstParams["storeId"] = UserManager.getStoreId
        requstParams["customerToken"] = UserManager.getCustomerId
        requstParams["quoteId"] = UserManager.getQuoteId
        requstParams["productId"] = productID
        APIServiceManager.shared.callingHttpRequest(params:requstParams, apiname:AfritiaAPI.addToWishlist, currentView: self){success,responseObject in
            if success == 1{
                GlobalData.sharedInstance.dismissLoader()
                if responseObject?.object(forKey: "storeId") != nil{
                    let storeId:String = String(format: "%@", responseObject!.object(forKey: "storeId") as! CVarArg)
                    if storeId != "0"{
                        DEFAULTS.set(storeId, forKey: "storeId")
                    }
                }
                
                let data = JSON(responseObject as! NSDictionary)
                
                if data["success"].boolValue == true{
                    AlertManager.shared.showSuccessSnackBar(msg:GlobalData.sharedInstance.language(key: "successwishlist"))
                    self.productCollectionViewModel.setWishListFlagToProductCategoryModel(data:true , pos: self.modelTag)
                    self.productCollectionViewModel.setWishListItemIdToProductCategoryModel(data:data["itemId"].stringValue , pos: self.modelTag)
                }
                else{
                    AlertManager.shared.showErrorSnackBar(msg:GlobalData.sharedInstance.language(key: "errorwishlist"))
                }
            }else if success == 2{
                self.callExtraApiForAddToWishList()
            }
        }
    }
    
    func callExtraApiForRemoveWishList(){
        
        GlobalData.sharedInstance.showLoader()
        var requstParams = [String:Any]()
        requstParams["storeId"] = UserManager.getStoreId
        requstParams["customerToken"] = UserManager.getCustomerId
        requstParams["quoteId"] = UserManager.getQuoteId
        requstParams["itemId"] = productID
        
        APIServiceManager.shared.callingHttpRequest(params:requstParams, apiname:AfritiaAPI.removeFromWishList, currentView: self){success,responseObject in
            GlobalData.sharedInstance.dismissLoader()
            if success == 1{
                
                let dict = JSON(responseObject as! NSDictionary)
                if dict["success"].boolValue == true{
                    AlertManager.shared.showSuccessSnackBar(msg: dict["message"].stringValue)
                    self.productCollectionViewModel.setWishListFlagToProductCategoryModel(data:false , pos: self.modelTag)
                }
            }else if success == 2{
                self.callExtraApiForRemoveWishList()
            }
        }
    }
}

/*
extension Productcategory : PreviewControllerDelegate {
    
    func previewingContext(_ previewingContext: UIViewControllerPreviewing, commit viewControllerToCommit: UIViewController) {
        
        let catalogProduct = AppStoryboard.Main.instance.instantiateViewController(withIdentifier: "catalogproduct") as! CatalogProduct
        catalogProduct.productName = self.productName
        catalogProduct.productImageUrl = self.productImageURL
        catalogProduct.productId = self.productID
        self.navigationController?.pushViewController(catalogProduct, animated: true)
    }
    
    func previewAddToCart(){
        self.callExtraApiForAddToCart()
    }
    
    func previewShare(){
        let productUrl = productImageURL
        let activityItems = [productUrl]
        let activityController = UIActivityViewController(activityItems: activityItems, applicationActivities: nil)
        if UI_USER_INTERFACE_IDIOM() == .phone {
            self.present(activityController, animated: true, completion: {  })
        }else {
            let popup = UIPopoverController(contentViewController: activityController)
            popup.present(from: CGRect(x: CGFloat(self.view.frame.size.width / 2), y: CGFloat(self.view.frame.size.height / 4), width: CGFloat(0), height: CGFloat(0)), in: self.view, permittedArrowDirections: .any, animated: true)
        }
    }
}

extension Productcategory : UIViewControllerPreviewingDelegate {
    
    func previewingContext(_ previewingContext: UIViewControllerPreviewing, viewControllerForLocation location: CGPoint) -> UIViewController? {
        if ((self.presentedViewController?.isKind(of: PreviewViewController.self)) != nil) {
            return nil
        }
        
        var productDescription:String = ""
        var requiredOption:Int = 0
        
        if let currentRow =  (previewingContext.sourceView as? UICollectionView)?.indexPathForItem(at: location)?.row{
            
            productDescription = productCollectionViewModel.getProductCollectionData[currentRow].descriptionData
            productImageURL = productCollectionViewModel.getProductCollectionData[currentRow].productImage
            productID = productCollectionViewModel.getProductCollectionData[currentRow].id
            self.productName = productCollectionViewModel.getProductCollectionData[currentRow].productName
            
            requiredOption = productCollectionViewModel.getProductCollectionData[currentRow].requiredOptions
        }
        
        // PEEK (shallow press): return the preview view controller here
        let storyboard = UIStoryboard.init(name: "Main", bundle: nil)
        let previewView = storyboard.instantiateViewController(withIdentifier: "PreviewView") as? PreviewViewController
        previewView?.productDescription = productDescription
        previewView?.imageUrl = productImageURL
        previewView?.delegate = self
        previewView?.requiredOptions = requiredOption
        
        return previewView
    }
    
}
*/
