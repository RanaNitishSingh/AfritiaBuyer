//
//  RecentViewTableViewCell.swift
//  Getkart
//
//  Created by Webkul on 15/05/18.
//  Copyright © 2018 Webkul. All rights reserved.
//

import UIKit
import EzPopup

protocol RecentProductViewControllerHandlerDelegate {
    func recentProductClick(name:String,image:String,id:String)
    //func recentAddToWishList(selProdInfo:Productcollection, selWishBtn:UIButton, availWishList:[MyMultiWishlistModel])
    func recentAddToCompare(productID:String)
    func recentViewAllClick()
    
    /*
    func productAddToWishList(selProdInfo:Products, selWishBtn:UIButton, availWishList:[MyMultiWishlistModel])
    func productAddToCompare(productID:String)
    func productClick(name:String,image:String,id:String)
    func viewAllClick(type:String)*/
}

class RecentViewTableViewCell: UITableViewCell {

    @IBOutlet weak var recentViewLabel: UILabel!
    @IBOutlet weak var recentViewCollectionView: UICollectionView!
    
    var recentCollectionModel = [Productcollection]()
    var delegate:RecentProductViewControllerHandlerDelegate!
    var homeViewModel : HomeViewModel!
    var parentVC:HomeViewController!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
        recentViewLabel.applyAfritiaBorederTheme(cornerRadius:5)
        recentViewLabel.text = "  " + "Recent Views"
        
        recentViewCollectionView.register(UINib(nibName: "ProductImageCell", bundle: nil), forCellWithReuseIdentifier: "productimagecell")
        recentViewCollectionView.register(UINib(nibName: "ViewAllCell", bundle: nil), forCellWithReuseIdentifier: "ViewAllCell")
        
        recentViewCollectionView.delegate = self
        recentViewCollectionView.dataSource = self
        recentViewCollectionView.backgroundColor = UIColor.white
        
        
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
        
    }
    
    @objc func addToCompare(sender: UIButton){
        delegate.recentAddToCompare(productID:recentCollectionModel[sender.tag].ProductID)
    }
    
    /*
    @objc func addToWishList(sender: UIButton){
        //delegate.recentAddToWishList(productID:recentCollectionModel[sender.tag].ProductID)
        
        let customerId = defaults.object(forKey:"customerId");
        if customerId != nil{
            let selProduct = recentCollectionModel[sender.tag]
            
            //HomeViewModel.getAllAvailableWishlistGroups { (allWishListGroups) in
                self.delegate.recentAddToWishList(selProdInfo: selProduct,
                                                   selWishBtn:sender,
                                                   availWishList: allWishListGroups)
            }
        }
        else
        {
            AlertManager.shared.showWarningSnackBar(msg: GlobalData.sharedInstance.language(key: "loginrequired"))
        }
    }
    */
    
    @objc func addToWishList(sender: UIButton){
        
        //modelTag = sender.tag
        let customerId = UserManager.getCustomerId
        if customerId != ""
        {
            let selRecentProduct = recentCollectionModel[sender.tag]
            //let json = JSON("{}")
            
            //Convertt one model to another
            var selProduct = Products.init(data:JSON("{}"))
            selProduct.name = selRecentProduct.name
            selProduct.price = selRecentProduct.price
            selProduct.productID = selRecentProduct.ProductID
            selProduct.showSpecialPrice = selRecentProduct.showSpecialPrice
            selProduct.image = selRecentProduct.image
            selProduct.isInRange = Int(selRecentProduct.isInRange)
            selProduct.isInWishList = Bool(selRecentProduct.isInWishlist)
            
            WishListServiceHelper.getWishListGroups { (result, wishlistGroups) in
                
                WishListServiceHelper.showWishListGroupsPopUp(onVC: self.parentVC, availWishList: wishlistGroups) { (selGroupId, selGroupName) in
                    
                    WishListServiceHelper.addProductToWishlist(groupId: selGroupId, groupName: selGroupName, productId: selProduct.productID) { (result, message) in
                        
                        if result {
                            AlertManager.shared.showSuccessSnackBar(msg: message)
                            
                            if selRecentProduct.isInWishlist == "false"{
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
            WishListServiceHelper.OpenPopUpViewToAddProductToWishListGroup(onVC:self.parentVC, selProductId: selRecentProduct.ProductID) { (result, massege) in
                
                if result {
                    AlertManager.shared.showSuccessSnackBar(msg: massege)
                    
                    if selRecentProduct.isInWishlist == "false"{
                        sender.setImage(UIImage(named: "ic_wishlist_fill")!, for: .normal)
                    }else{
                        sender.setImage(UIImage(named: "ic_wishlist_empty")!, for: .normal)
                    }
                }
                else{
                    AlertManager.shared.showErrorSnackBar(msg:massege)
                }
            }
            /*
            //self.getAllAvailableWishlistGroups { (allWishListGroups) in
                self.openWishlistPopUp(availWishList: allWishListGroups, selProdInfo: selProduct, selWishBtn: sender)
            }*/
        }*/
        
    }
    
    /*
    //func openWishlistPopUp(availWishList:[MyWishlistGroupModel], selProdInfo:Productcollection, selWishBtn:UIButton){
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
            requstParams["productId"] = selProdInfo.ProductID
            
            print("Request Params: \(requstParams)")
            
            APIServiceManager.shared.callingHttpRequestWithoutView(params:requstParams, apiname:AfritiaAPI.addNewWishListGroupWithProduct ){success,responseObject in
                if success == 1{
                    print(responseObject!)
                    let apiResponse = responseObject as? NSDictionary
                    
                    GlobalData.sharedInstance.dismissLoader()
                    AlertManager.shared.showSuccessSnackBar(msg:apiResponse!["message"] as! String)
                    
                    if selProdInfo.isInWishlist == "false"{
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
}

extension RecentViewTableViewCell: UICollectionViewDelegate, UICollectionViewDataSource , UICollectionViewDelegateFlowLayout{
    
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return recentCollectionModel.count
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
        
        if indexPath.row < recentCollectionModel.count{
            
            cell.wishListButton.isHidden = false
            cell.addToCompareButton.isHidden = false
            cell.btnQuickViewHeight.constant = 0
            cell.btnQuickView.isHidden = true
            
            GlobalData.sharedInstance.getImageFromUrl(imageUrl:recentCollectionModel[indexPath.row].image , imageView: cell.productImage)
            cell.productName.text = recentCollectionModel[indexPath.row].name
            cell.productPrice.text = recentCollectionModel[indexPath.row].price
            
            
            cell.wishListButton.tag = indexPath.row
            cell.wishListButton.addTarget(self, action: #selector(addToWishList(sender:)), for: .touchUpInside)
            cell.wishListButton.isUserInteractionEnabled = true
            
            cell.addToCompareButton.tag = indexPath.row
            cell.addToCompareButton.addTarget(self, action: #selector(addToCompare(sender:)), for: .touchUpInside)
            cell.addToCompareButton.isUserInteractionEnabled = true
            
            if Bool(recentCollectionModel[indexPath.row].isInWishlist)!{
                cell.wishListButton.setImage(UIImage(named: "ic_wishlist_fill")!, for: .normal)
            }else{
                cell.wishListButton.setImage(UIImage(named: "ic_wishlist_empty")!, for: .normal)
            }
            
            
            if recentCollectionModel[indexPath.row].typeID == "grouped"{
                cell.productPrice.text =  recentCollectionModel[indexPath.row].groupedPrice
            }else if recentCollectionModel[indexPath.row].typeID == "bundle"{
                cell.productPrice.text =  recentCollectionModel[indexPath.row].formatedMinPrice
            }
            else{
                if Bool(recentCollectionModel[indexPath.row].isInRange) == true
                {
                    if recentCollectionModel[indexPath.row].specialPrice < recentCollectionModel[indexPath.row].originalPrice{
                        cell.productPrice.text = recentCollectionModel[indexPath.row].showSpecialPrice
                        let attributeString = NSMutableAttributedString(string: (recentCollectionModel[indexPath.row].formatedPrice ))
                        attributeString.addAttribute(NSAttributedStringKey.strikethroughStyle, value: 1, range: NSRange(location: 0, length: attributeString.length))
                        cell.specialPrice.attributedText = attributeString
                        cell.specialPrice.isHidden = false
                    }
                }else{
                    cell.specialPrice.isHidden = true
                }
            }
            
            if recentCollectionModel[indexPath.row].isFreeshipping == "Yes"{
                cell.lblShipping.text = "freeshipping".localized
            }else if recentCollectionModel[indexPath.row].isFreeshipping == "No"{
                cell.lblShipping.text = "shippingword".localized + ": \(recentCollectionModel[indexPath.row].shippingPrice )"
            }
            
            cell.layoutIfNeeded()
            return cell
         }
        else
        {
            extracell.layoutIfNeeded()
            //self.productCollectionViewHeight.constant = self.prodcutCollectionView.contentSize.height
            extracell.viewAllLabel.text = GlobalData.sharedInstance.language(key: "viewmore");
            return extracell
        }
        
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: collectionView.frame.size.width/2 - 32 , height: collectionView.frame.size.width/2 + 70)
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if indexPath.row < recentCollectionModel.count{
            delegate.recentProductClick(name: recentCollectionModel[indexPath.row].name,
                                        image: recentCollectionModel[indexPath.row].image,
                                        id: recentCollectionModel[indexPath.row].ProductID)
        }else{
            //call extra cell action
        }
    }
    
}

