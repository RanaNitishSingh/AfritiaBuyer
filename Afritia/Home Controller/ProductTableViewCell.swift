//
//  ProductTableViewCell.swift
//  WooCommerce
//
//  Created by Webkul  on 04/11/17.
//  Copyright © 2017 Webkul . All rights reserved.
//

import UIKit
import EzPopup

protocol productViewControllerHandlerDelegate {
    
    //func productAddToWishList(selProdInfo:Products, selWishBtn:UIButton, availWishList:[MyMultiWishlistModel])
    func productAddToCompare(productID:String)
    func productClick(name:String,image:String,id:String)
    func viewAllClick(type:String)
    func productQuickView(productInfo:Products)
}

class ProductTableViewCell: UITableViewCell {
    
    var productCollectionModel = [Products]()
    var homeViewModel : HomeViewModel!
    var titles:String = ""
    var delegate:productViewControllerHandlerDelegate!
    
    @IBOutlet weak var prodcutCollectionView: UICollectionView!
    @IBOutlet weak var productCollectionViewHeight: NSLayoutConstraint!
    @IBOutlet weak var buttonSeeAll: UIButton!
    
    @IBOutlet weak var productTypeLabel: UILabel!
    
    var showFeature:Bool!// = true
    var whichApiToProcess:String = ""
    var productID:String = ""
    var parentVC:HomeViewController!
    //private var modelTag:Int = 0
    
    var productType = ""{
        didSet {
            print(productType)
            productTypeLabel.text = "  " + self.productType
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        productTypeLabel.applyAfritiaBorederTheme(cornerRadius:5)
        buttonSeeAll.applyAfritiaBorederTheme(cornerRadius:5)

        productCollectionViewHeight.constant = 20
        prodcutCollectionView.register(UINib(nibName: "ProductImageCell", bundle: nil), forCellWithReuseIdentifier: "productimagecell")
        prodcutCollectionView.register(UINib(nibName: "ViewAllCell", bundle: nil), forCellWithReuseIdentifier: "ViewAllCell")
        
        prodcutCollectionView.delegate = self
        prodcutCollectionView.dataSource = self
        prodcutCollectionView.backgroundColor = UIColor.white
        
        prodcutCollectionView.reloadData()
        
    }
    
    override func layoutSubviews() {
        
        if traitCollection.forceTouchCapability == .available {
            parentVC.registerForPreviewing(with: parentVC, sourceView: prodcutCollectionView)
        }
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }
    
    static var nib:UINib {
        return UINib(nibName: identifier, bundle: nil)
    }
    
    static var identifier: String {
        return String(describing: self)
    }
    
    
    @IBAction func ShowAllProductClick(_ sender: UIButton){
        
        if productType == ProductType.feature {
            delegate.viewAllClick(type: "feature")
        }else if productType == ProductType.latest {
            delegate.viewAllClick(type: "new")
        }else{
            delegate.viewAllClick(type:"hotdeal")
        }
    }
    
    @objc func addToCompare(sender: UIButton){
        delegate.productAddToCompare(productID: productCollectionModel[sender.tag].productID)
    }
    
    @objc func addToWishList(sender: UIButton){
        
        //modelTag = sender.tag
        let customerId = UserManager.getCustomerId
        
        if customerId != ""{
            let selProduct = productCollectionModel[sender.tag]
            
            WishListServiceHelper.getWishListGroups { (result, wishlistGroups) in
                
                WishListServiceHelper.showWishListGroupsPopUp(onVC: self.parentVC, availWishList: wishlistGroups) { (selGroupId, selGroupName) in
                    
                    WishListServiceHelper.addProductToWishlist(groupId: selGroupId, groupName: selGroupName, productId: selProduct.productID) { (result, message) in
                        
                        if result {
                            AlertManager.shared.showSuccessSnackBar(msg: message)
                            
                            if selProduct.isInWishList == false{
                                sender.setImage(UIImage(named: "ic_wishlist_fill")!, for: .normal)
                            }else{
                                sender.setImage(UIImage(named: "ic_wishlist_empty")!, for: .normal)
                            }
                        }
                        else{
                            AlertManager.shared.showErrorSnackBar(msg:message)
                        }
                    }
                }
            }
        }
        else
        {
            AlertManager.shared.showWarningSnackBar(msg: GlobalData.sharedInstance.language(key: "loginrequired"))
        }
        
        /*
            WishListServiceHelper.OpenPopUpViewToAddProductToWishListGroup(onVC:self.parentVC, selProductId:selProduct.productID) { (result, massege) in
                
                if result {
                    AlertManager.shared.showSuccessSnackBar(msg: massege)
                    
                    if selProduct.isInWishList == false{
                        sender.setImage(UIImage(named: "ic_wishlist_fill")!, for: .normal)
                    }else{
                        sender.setImage(UIImage(named: "ic_wishlist_empty")!, for: .normal)
                    }
                }
                else{
                    AlertManager.shared.showErrorSnackBar(msg:massege)
                }
            }*/
            
            /*
            //self.getAllAvailableWishlistGroups { (allWishListGroups) in
                self.openWishlistPopUp(availWishList: allWishListGroups, selProdInfo: selProduct, selWishBtn: sender)
            }
        }*/
        
    }
    
    /*
    func openWishlistPopUp(availWishList:[MyWishlistGroupModel], selProdInfo:Products, selWishBtn:UIButton){
        
        let vc = AppStoryboard.Main.instance.instantiateViewController(withIdentifier: "WishListGroupPopUpVC") as! WishListGroupPopUpVC
        vc.myWishlistGroupData = availWishList
        
        vc.callBackOnSubmitClick = {(groupId, groupName) in
            print(groupId, groupName)
            
            GlobalData.sharedInstance.showLoader()
            
            var requstParams = [String:Any]()
            requstParams["storeId"] = defaults.object(forKey:"storeId") as! String
            requstParams["wishlist"] = groupId
            requstParams["newWishlistName"] = ""
            if groupId == "new"{
                requstParams["newWishlistName"] = groupName
            }
            requstParams["customerToken"] = defaults.object(forKey:"customerId") as! String
            requstParams["productId"] = selProdInfo.productID
            
            print("Request Params: \(requstParams)")
            
            APIServiceManager.shared.callingHttpRequestWithoutView(params:requstParams, apiname:AfritiaAPI.addNewWishListGroupWithProduct ){success,responseObject in
                if success == 1{
                    print(responseObject!)
                    let apiResponse = responseObject as? NSDictionary
                    
                    GlobalData.sharedInstance.dismissLoader()
                    AlertManager.shared.showSuccessSnackBar(msg:apiResponse!["message"] as! String)
                    
                    if selProdInfo.isInWishList == false{
                        selWishBtn.setImage(UIImage(named: "ic_wishlist_fill")!, for: .normal)
                    }else{
                        selWishBtn.setImage(UIImage(named: "ic_wishlist_empty")!, for: .normal)
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
    
        parentVC.present(popupVC, animated: true)
    }
    
    //func getAllAvailableWishlistGroups(completionBlock:@escaping completionHandler){
        
        //self.mutliWishlistApiType = Mu
        GlobalData.sharedInstance.showLoader()
        
        var requstParams = [String:Any]()
        requstParams["storeId"] = defaults.object(forKey:"storeId") as! String
        requstParams["pageNumber"] =  "1"
        requstParams["customerToken"] = defaults.object(forKey:"customerId") as! String
        
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
    */
    
    /*
    func callingExtraHttpApi(){
        homeViewController.view.isUserInteractionEnabled = false
        GlobalData.sharedInstance.showLoader()
        var requstParams = [String:Any]();
        if defaults.object(forKey: "storeId") != nil{
            requstParams["storeId"] = defaults.object(forKey: "storeId") as! String
        }
        let customerId = defaults.object(forKey:"customerId");
        if customerId != nil{
            requstParams["customerToken"] = customerId
        }
        
        if whichApiToProcess == "addtowishlist"{
            requstParams["productId"] = productID
            APIServiceManager.shared.callingHttpRequest(params:requstParams, apiname:AfritiaAPI.addToWishlist, currentView: homeViewController){success,responseObject in
                if success == 1{
                    if responseObject?.object(forKey: "storeId") != nil{
                        let storeId:String = String(format: "%@", responseObject!.object(forKey: "storeId") as! CVarArg)
                        if storeId != "0"{
                            defaults .set(storeId, forKey: "storeId")
                        }
                    }
                    
                    GlobalData.sharedInstance.dismissLoader()
                    self.homeViewController.view.isUserInteractionEnabled = true
                    let data = JSON(responseObject as! NSDictionary)
                    
                    if data["success"].boolValue == true{
                        AlertManager.shared.showSuccessSnackBar(msg:GlobalData.sharedInstance.language(key: "successwishlist"))
                        
                        self.productCollectionModel[self.modelTag].isInWishList = true;
                        self.productCollectionModel[self.modelTag].wishlistItemId = data["itemId"].stringValue;
                        
                        self.homeViewModel.changeWishlistProductFlagStatus(status:true, pIndex: self.modelTag, pType: self.productType)
                        self.homeViewModel.changeWishlistProductIdStatus(itemId: data["itemId"].stringValue, pIndex: self.modelTag, pType:self.productType)
                        
                        //self.homeViewModel.setWishListFlagToLatestProductModel(data: true, pos: self.modelTag)
                        //self.homeViewModel.setWishListItemIdToLatestProductModel(data:data["itemId"].stringValue , pos: self.modelTag)
                        
                        /*
                        if self.showFeature == true{
                            self.featuredProductCollectionModel[self.modelTag].isInWishList = true;
                            self.featuredProductCollectionModel[self.modelTag].wishlistItemId = data["itemId"].stringValue;
                            self.homeViewModel.setWishListFlagToFeaturedProductModel(data: true, pos: self.modelTag)
                            self.homeViewModel.setWishListItemIdToFeaturedProductModel(data:data["itemId"].stringValue , pos: self.modelTag)
                            
                        }else{
                            self.productCollectionModel[self.modelTag].isInWishList = true;
                            self.productCollectionModel[self.modelTag].wishlistItemId = data["itemId"].stringValue;
                            self.homeViewModel.setWishListFlagToLatestProductModel(data: true, pos: self.modelTag)
                            self.homeViewModel.setWishListItemIdToLatestProductModel(data:data["itemId"].stringValue , pos: self.modelTag)
                        }*/
                        
                        
                    }else{
                        AlertManager.shared.showErrorSnackBar(msg:GlobalData.sharedInstance.language(key: "errorwishlist"))
                    }
                }else if success == 2{
                    GlobalData.sharedInstance.dismissLoader()
                    self.callingExtraHttpApi()
                }
            }
        }
        else if whichApiToProcess == "removewishlist"{
            
            GlobalData.sharedInstance.showLoader()
            
            requstParams["itemId"] = productID
            
            APIServiceManager.shared.callingHttpRequest(params:requstParams, apiname:AfritiaAPI.removeFromWishList, currentView: homeViewController){success,responseObject in
                if success == 1{
                    GlobalData.sharedInstance.dismissLoader()
                    self.homeViewController.view.isUserInteractionEnabled = true
                    let dict = JSON(responseObject as! NSDictionary)
                    if dict["success"].boolValue == true{
                        AlertManager.shared.showSuccessSnackBar(msg: dict["message"].stringValue)
                        
                        self.productCollectionModel[self.modelTag].isInWishList = false;
                        self.homeViewModel.changeWishlistProductFlagStatus(status:false, pIndex: self.modelTag, pType: self.productType)
                        //self.homeViewModel.setWishListFlagToLatestProductModel(data: false, pos: self.modelTag)
                        
                        /*
                        if self.showFeature == true{
                            self.featuredProductCollectionModel[self.modelTag].isInWishList = false;
                            self.homeViewModel.setWishListFlagToFeaturedProductModel(data: false, pos: self.modelTag)
                        }else{
                            self.productCollectionModel[self.modelTag].isInWishList = false;
                            self.homeViewModel.setWishListFlagToLatestProductModel(data: false, pos: self.modelTag)
                        }*/
                    }
                }else if success == 2{
                    self.callingExtraHttpApi()
                    GlobalData.sharedInstance.dismissLoader()
                }
            }
        }
    }
    */
    
}

extension ProductTableViewCell: UICollectionViewDelegate, UICollectionViewDataSource , UICollectionViewDelegateFlowLayout{
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        if productCollectionModel.count > 0
        {
            collectionView.backgroundView = nil
            return 4 //productCollectionModel.count + 1
        }
        else{
            let messageLabel = UILabel(frame: CGRect(x: 0, y: 0, width: collectionView.bounds.size.width, height: collectionView.bounds.size.height))
            messageLabel.text = GlobalData.sharedInstance.language(key: "noproductsavailble")
            messageLabel.textColor = UIColor.black
            messageLabel.numberOfLines = 0;
            messageLabel.textAlignment = .center;
            messageLabel.font = UIFont(name: REGULARFONT, size: 15)
            messageLabel.sizeToFit()
            collectionView.backgroundView = messageLabel;
            self.productCollectionViewHeight.constant = 100
            return 0
            
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "productimagecell", for: indexPath) as! ProductImageCell
        let extracell = collectionView.dequeueReusableCell(withReuseIdentifier: "ViewAllCell", for: indexPath) as! ViewAllCell
        
        cell.productImage.image = UIImage(named: "ic_placeholder.png")
        cell.layer.cornerRadius = 4
        cell.layer.borderWidth = 1
        cell.layer.borderColor = UIColor.appSuperLightGrey.cgColor
        
        extracell.layer.cornerRadius = 4
        extracell.layer.borderWidth = 1
        extracell.layer.borderColor = UIColor.appSuperLightGrey.cgColor
        
        if indexPath.row < productCollectionModel.count{
            
            let productInfo = productCollectionModel[indexPath.row]
            cell.wishListButton.isHidden = false
            cell.addToCompareButton.isHidden = false
            
            //GlobalData.sharedInstance.getImageFromUrl(imageUrl:productCollectionModel[indexPath.row].image , imageView: cell.productImage)
            cell.productImage.getImageFromUrl(imageUrl: productInfo.image)
            cell.productName.text = productInfo.name
            cell.productPrice.text = productInfo.price
            
            cell.wishListButton.tag = indexPath.row
            cell.wishListButton.addTarget(self, action: #selector(addToWishList(sender:)), for: .touchUpInside)
            cell.wishListButton.isUserInteractionEnabled = true
            
            cell.addToCompareButton.tag = indexPath.row
            cell.addToCompareButton.addTarget(self, action: #selector(addToCompare(sender:)), for: .touchUpInside)
            cell.addToCompareButton.isUserInteractionEnabled = true
            
            if productInfo.isInWishList{
                cell.wishListButton.setImage(UIImage(named: "ic_wishlist_fill")!, for: .normal)
            }else{
                cell.wishListButton.setImage(UIImage(named: "ic_wishlist_empty")!, for: .normal)
            }
            
            if productInfo.typeID == "grouped"{
                cell.productPrice.text =  productInfo.groupedPrice
            }else if productInfo.typeID == "bundle"{
                cell.productPrice.text =  productInfo.formatedMinPrice
            }else{
                if productInfo.isInRange == 1{
                    if productInfo.specialPrice < productInfo.originalPrice{
                        cell.productPrice.text = productInfo.showSpecialPrice
                        let attributeString = NSMutableAttributedString(string: ( productInfo.formatedPrice ))
                        attributeString.addAttribute(NSAttributedStringKey.strikethroughStyle, value: 1, range: NSRange(location: 0, length: attributeString.length))
                        cell.specialPrice.attributedText = attributeString
                        cell.specialPrice.isHidden = false;
                    }
                }else{
                    cell.specialPrice.isHidden = true;
                }
            }
            
            if productInfo.isFreeShipping == "Yes"{
                cell.lblShipping.text = "freeshipping".localized
            }else{
                cell.lblShipping.text = "shippingword".localized + ": \(productInfo.shippingPrize ?? "0")"
            }
            
            cell.btnQuickViewHeight.constant = 30
            cell.btnQuickView.isHidden = false
            cell.btnQuickView.addTargetClosure { (btn) in
                self.delegate.productQuickView(productInfo: self.productCollectionModel[indexPath.row])
            }
            
            cell.layoutIfNeeded()
            self.productCollectionViewHeight.constant = self.prodcutCollectionView.contentSize.height
            
            if traitCollection.forceTouchCapability == .available {
                cell.showFeature = false
                parentVC.registerForPreviewing(with: parentVC, sourceView: cell.contentView)
            }
            
            return cell
        }else{
            extracell.layoutIfNeeded()
            self.productCollectionViewHeight.constant = self.prodcutCollectionView.contentSize.height
            extracell.viewAllLabel.text = GlobalData.sharedInstance.language(key: "viewmore");
            return extracell
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: collectionView.frame.size.width/2 - 16 , height: collectionView.frame.size.width/2 + 70)
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        if indexPath.row < productCollectionModel.count{
            let productInfo = productCollectionModel[indexPath.row]
            delegate.productClick(name: productInfo.name,
                                  image:productInfo.image,
                                  id: productInfo.productID)
        }else{
            
            if productType == ProductType.feature {
                delegate.viewAllClick(type: "feature")
            }else if productType == ProductType.latest {
                delegate.viewAllClick(type: "new")
            }else if productType == ProductType.hotdeal {
                delegate.viewAllClick(type: "hotdeal")
            }
        }
    }

    
}

