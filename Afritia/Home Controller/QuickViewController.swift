//
//  QuickViewController.swift
//  Afritia
//
//  Created by Ranjit Mahto on 07/12/20.
//  Copyright © 2020 kunal. All rights reserved.
//

import UIKit
import SwiftMessages

struct QuickViewAction {
    static let compare = "Compare List"
    static let goToCart = "View ShoppingCart"
}

class QuickViewController: UIViewController {

    @IBOutlet weak var productImageView:UIImageView!
    @IBOutlet weak var btnAddToCompate:UIButton!
    @IBOutlet weak var btnAddToWishlist:UIButton!
    @IBOutlet weak var lblProductTitle:UILabel!
    @IBOutlet weak var lblProductDetail:UILabel!
    @IBOutlet weak var lblPrice:UILabel!
    @IBOutlet weak var lblSpecialPrice:UILabel!
    @IBOutlet weak var lblShipping:UILabel!
    @IBOutlet weak var addCartBgView:UIView!
    @IBOutlet weak var textFieldItemCount:UITextField!
    @IBOutlet weak var stepperCountItem:UIStepper!
    @IBOutlet weak var btnAddToCart:UIButton!
    
    var productInfo:Products!
    var callBackAction:((String)->())!
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        textFieldItemCount.applyAfritiaTheme()
        btnAddToCart.applyAfritiaTheme()
        
        productImageView.getImageFromUrl(imageUrl:productInfo.image)
        
        lblProductTitle.text = productInfo.name
        lblPrice.text = productInfo.price
        lblProductDetail.text = productInfo.shortDescription
        
        textFieldItemCount.text = String(format:"%d",1)
        
        if productInfo.isInWishList{
            btnAddToWishlist.setImage(UIImage(named: "ic_wishlist_fill")!, for: .normal)
        }else{
            btnAddToWishlist.setImage(UIImage(named: "ic_wishlist_empty")!, for: .normal)
        }
        
        if productInfo.typeID == "grouped"{
            lblPrice.text =  productInfo.groupedPrice
        }else if productInfo.typeID == "bundle"{
            lblPrice.text =  productInfo.formatedMinPrice
        }else{
            if productInfo.isInRange == 1{
                if productInfo.specialPrice < productInfo.originalPrice{
                    lblPrice.text = productInfo.showSpecialPrice
                    let attributeString = NSMutableAttributedString(string: ( productInfo.formatedPrice ))
                    attributeString.addAttribute(NSAttributedStringKey.strikethroughStyle, value: 1, range: NSRange(location: 0, length: attributeString.length))
                    lblSpecialPrice.attributedText = attributeString
                    lblSpecialPrice.isHidden = false;
                }
            }else{
                lblSpecialPrice.isHidden = true;
            }
        }
        
        if productInfo.isFreeShipping == "Yes"{
            lblShipping.text = "freeshipping".localized
        }else{
            lblShipping.text = "shippingword".localized + ": \(productInfo.shippingPrize ?? "0")"
        }
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */
    
    
    @IBAction func updateItemCount(_ sender:UIStepper){
        
        textFieldItemCount.text = String(format:"%d",Int(sender.value))
    }
    
    @IBAction func addToWishList(_ sender:UIButton){
        
        if UserManager.getCustomerId == ""{
            AlertManager.shared.showWarningSnackBar(msg: GlobalData.sharedInstance.language(key: "loginrequired"))
            return
        }
        
        WishListServiceHelper.getWishListGroups { (result, wishlistGroups) in
            
            WishListServiceHelper.showWishListGroupsPopUp(onVC: self, availWishList: wishlistGroups) { (selGroupId, selGroupName) in
                
                WishListServiceHelper.addProductToWishlist(groupId: selGroupId, groupName: selGroupName, productId: self.productInfo.productID) { (result, message) in
                    
                    self.dismiss(animated:true, completion:nil)
                    
                    if result {
                        AlertManager.shared.showSuccessSnackBar(msg: message)
                        
                        if self.productInfo.isInWishList == false{
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
    
    @IBAction func addToCompateList(_ sender:UIButton){
        
        GlobalData.sharedInstance.showLoader()
        
        var requstParams = [String:Any]();
        requstParams["storeId"] = UserManager.getStoreId
        requstParams["customerToken"] = UserManager.getCustomerId
        requstParams["quoteId"] = UserManager.getQuoteId
        requstParams["productId"] = self.productInfo.productID
        
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
                    AlertManager.shared.showSnackBarWithAction(onView:self, theme:.success, msg: data.object(forKey: "message") as! String, actionBtnTitle:"See List") { (btnTitle) in
                        self.callBackAction(QuickViewAction.compare)
                    }
                    //self.showSuccessMessgae(data:data.object(forKey: "message") as! String, onDoneAction: QuickViewAction.compare)
                }else{
                    AlertManager.shared.showErrorSnackBar(msg:data.object(forKey: "message") as! String)
                }
            }else if success == 2{
                GlobalData.sharedInstance.dismissLoader()
                //self.callingExtraHttpApi()
            }
        }
    }
    
    @IBAction func addToCart(_ sender:UIButton){
        
        GlobalData.sharedInstance.showLoader()
        
        var requstParams = [String:Any]();
        requstParams["storeId"] = UserManager.getStoreId
        requstParams["customerToken"] = UserManager.getCustomerId
        requstParams["quoteId"] = UserManager.getQuoteId
        requstParams["productId"] = self.productInfo.productID
        requstParams["qty"] = self.textFieldItemCount.text
        
        APIServiceManager.shared.callingHttpRequest(params:requstParams, apiname:AfritiaAPI.addToCart, currentView: self){success,responseObject in
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
                    AlertManager.shared.showSnackBarWithAction(onView:self, theme:.success, msg: data.object(forKey: "message") as! String, actionBtnTitle:"Goto Cart") { (btnTitle) in
                        self.callBackAction(QuickViewAction.goToCart)
                    }
                    /*
                    self.showSuccessMessgae(data:data.object(forKey: "message") as! String, onDoneAction:QuickViewAction.goToCart)*/
                    
                }else{
                    AlertManager.shared.showErrorSnackBar(msg:data.object(forKey: "message") as! String)
                }
            }else if success == 2{
                GlobalData.sharedInstance.dismissLoader()
                //self.callingExtraHttpApi()
            }
        }
    }
    
    
    /*
    func showSuccessMessgae(data:String, onDoneAction:String){
        
        let msgView = MessageView.viewFromNib(layout: .messageView)
        msgView.configureTheme(.success)
        msgView.button?.isHidden = false
        
        var btnTitle = ""
        if onDoneAction == QuickViewAction.compare {
            btnTitle = "See List"
        }
        else if onDoneAction == QuickViewAction.goToCart {
            btnTitle = "Goto Cart"
        }
        
        msgView.configureContent(title:"Success", body: data, iconImage: nil, iconText: "👍", buttonImage: nil, buttonTitle: btnTitle) { _ in
            SwiftMessages.hide()
            self.dismiss(animated:true, completion:{
                if onDoneAction == QuickViewAction.compare {
                    self.callBackAction(QuickViewAction.compare)
                }
                else if onDoneAction == QuickViewAction.goToCart {
                    self.callBackAction(QuickViewAction.goToCart)
                }
            })
        }
        
        var msgConfig = SwiftMessages.defaultConfig
        msgConfig.presentationContext = .window(windowLevel: UIWindowLevelStatusBar)
        msgConfig.presentationStyle = .top
        msgConfig.dimMode = .blur(style: UIBlurEffectStyle.light, alpha: 0.4, interactive: true)
        msgConfig.duration = .forever
        SwiftMessages.show(config: msgConfig, view: msgView)
    }
    */
}
