//
//  WishListServiceHelper.swift
//  Afritia
//
//  Created by Ranjit Mahto on 05/12/20.
//  Copyright © 2020 kunal. All rights reserved.
//

import Foundation
import EzPopup
import UIKit

typealias completionHandler = ([MyWishlistGroupModel]) -> Void
typealias completionOnAddToWishList = (Bool, String) -> Void
typealias completionOnFetchWishList = (Bool,[MyWishlistGroupModel]) -> Void
typealias completionOnSelectWishListFromPopUp = (String,String) -> Void

class WishListServiceHelper {
    
   /*
  class  func OpenPopUpViewToAddProductToWishListGroup(onVC:UIViewController,selProductId:String,completionBlock:@escaping completionOnAddToWishList){
        
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

                    var availWishList = [MyWishlistGroupModel]()
                    
                    if data.object(forKey: "multipleWishlist") != nil   {
                        if let dictData = JSON(data.object(forKey: "multipleWishlist")!).arrayObject {
                            availWishList = dictData.map({(val) -> MyWishlistGroupModel in
                                return MyWishlistGroupModel(data: JSON(val))
                            })
                        }
                    }
                    
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
                        requstParams["customerToken"] = defaults.object(forKey:"customerId") as! String
                        requstParams["productId"] = selProductId
                        
                        print("Request Params: \(requstParams)")
                        
                        APIServiceManager.shared.callingHttpRequestWithoutView(params:requstParams, apiname:AfritiaAPI.addNewWishListGroupWithProduct ){success,responseObject in
                            if success == 1{
                                print(responseObject!)
                                let apiResponse = responseObject as? NSDictionary
                                
                                GlobalData.sharedInstance.dismissLoader()
                                let respMsg = apiResponse!["message"] as! String
                                
                                completionBlock(true, respMsg)
                                
                            }else if success == 2 {
                                completionBlock(false, "success2")
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
                
                    onVC.present(popupVC, animated: true)
                    
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
    func OpenPopUpViewToAddProductToWishListGroup(onVC:UIViewController,selProductId:String,completionBlock:@escaping completionOnAddToWishList){
        
        self.getWishListGroups { (result, wishlistGroups) in
            
            self.showWishListGroupsPopUp(onVC: onVC, availWishList: wishlistGroups) { (selGroupId, selGroupName) in
                
                self.addProductToWishlist(groupId: selGroupId, groupName: selGroupName, productId: selProductId) { (result, message) in
                    completionBlock(result,message)
                    
                }
            }
        }
    }*/
    
    
   class func getWishListGroups(completionBlock:@escaping completionOnFetchWishList){
    
        GlobalData.sharedInstance.showLoader()
    
        var requstParams = [String:Any]()
        requstParams["storeId"] = DEFAULTS.object(forKey:"storeId") as! String
        requstParams["pageNumber"] =  "1"
        requstParams["customerToken"] = DEFAULTS.object(forKey:"customerId") as! String
        
        APIServiceManager.shared.callingHttpRequestWithoutView(params:requstParams, apiname:AfritiaAPI.allAvailableWishlist){success,responseObject in
            if success == 1{
                GlobalData.sharedInstance.dismissLoader()
                
                DispatchQueue.main.async {
                    
                    let data = responseObject as! NSDictionary
                    
                    var availWishList = [MyWishlistGroupModel]()
                    
                    if data.object(forKey: "multipleWishlist") != nil   {
                        if let dictData = JSON(data.object(forKey: "multipleWishlist")!).arrayObject {
                            availWishList = dictData.map({(val) -> MyWishlistGroupModel in
                                return MyWishlistGroupModel(data: JSON(val))
                            })
                        }
                    }
                    
                    if availWishList.count > 0{
                        completionBlock(true,availWishList)
                    }
                    else{
                        completionBlock(false,availWishList)
                    }
                }
            }
            else if success == 2{
                //self.getAllAvailableWishlistGroups()
                
            }
        }
    }
    
   class func showWishListGroupsPopUp(onVC:UIViewController, availWishList:[MyWishlistGroupModel],completionBlock:@escaping completionOnSelectWishListFromPopUp){
        
        let vc = AppStoryboard.Main.instance.instantiateViewController(withIdentifier: "WishListGroupPopUpVC") as! WishListGroupPopUpVC
        vc.myWishlistGroupData = availWishList
        
        vc.callBackOnSubmitClick = {(groupId, groupName) in
            print(groupId, groupName)
            completionBlock(groupId,groupName)
        }
        
        let popViewHeight = 44 + 120 + (40 * (availWishList.count+1))
        // Init popup view controller with content is your content view controller
        let popupVC = PopupViewController(contentController: vc, popupWidth:SCREEN_WIDTH-100, popupHeight: CGFloat(popViewHeight))
        popupVC.backgroundAlpha = 0.4
        popupVC.backgroundColor = .black
        popupVC.canTapOutsideToDismiss = false
        popupVC.cornerRadius = 10
        popupVC.shadowEnabled = false
    
        onVC.present(popupVC, animated: true)
    }
    
   class func addProductToWishlist(groupId:String, groupName:String, productId:String, completionBlock:@escaping completionOnAddToWishList ){
    
     GlobalData.sharedInstance.showLoader()
    
        var requstParams = [String:Any]()
        requstParams["storeId"] = UserManager.getStoreId
        requstParams["wishlist"] = groupId
        requstParams["newWishlistName"] = ""
        if groupId == "new"{
            requstParams["newWishlistName"] = groupName
        }
        requstParams["customerToken"] = DEFAULTS.object(forKey:"customerId") as! String
        requstParams["productId"] = productId
        
        print("Request Params: \(requstParams)")
        
        APIServiceManager.shared.callingHttpRequestWithoutView(params:requstParams, apiname:AfritiaAPI.addNewWishListGroupWithProduct ){success,responseObject in
            if success == 1{
                print(responseObject!)
                let apiResponse = responseObject as? NSDictionary
                GlobalData.sharedInstance.dismissLoader()
                let respMsg = apiResponse!["message"] as! String
                completionBlock(true, respMsg)
                
            }else if success == 2 {
                completionBlock(false, "success2")
                //self.callApiForMultiWishlist(apiType:MultiWishlistAPIType.addNewWishListGroup)
                //GlobalData.sharedInstance.dismissLoader()
            }
        }
    }
    
    class func moveItemFromWishList(wishListGroupInfo:MyWishlistGroupModel,selItem:WishListItem, destGroupId:String, destGroupName:String, completionBlock:@escaping completionOnAddToWishList){
        
        if destGroupName == "Main" || destGroupId == wishListGroupInfo.id {
            AlertManager.shared.showInfoSnackBar(msg:"You have already item in this group")
            return
        }
        
        GlobalData.sharedInstance.showLoader()
        
        var requstParams = [String:Any]()
        requstParams["storeId"] = UserManager.getStoreId
        requstParams["customerToken"] = UserManager.getCustomerId
        
        if destGroupName == "Main" {
            requstParams["wishlist"] = "main"
        }else{
            requstParams["wishlist"] = destGroupId
        }
        
        if wishListGroupInfo.name == "Main"{
            requstParams["itemId"] = "main" + "-" + selItem.product_id
        }else{
            requstParams["itemId"] = selItem.product_id
        }
        
        // no need source group id to send
        if destGroupId == "new"{
            requstParams["newWishlistName"] = destGroupName
        }else{
            requstParams["newWishlistName"] = ""
        }
        
        // name of group where to move / or new group name
        print("Request Params: \(requstParams)")
        
        APIServiceManager.shared.callingHttpRequestWithoutView(params:requstParams, apiname:AfritiaAPI.moveItemFromWishListGroup ){success,responseObject in
            
            GlobalData.sharedInstance.dismissLoader()
            
            if success == 1{
                print(responseObject!)
                let apiResponse = responseObject as? NSDictionary
                GlobalData.sharedInstance.dismissLoader()
                let respMsg = apiResponse!["message"] as! String
                completionBlock(true, respMsg)
                
            }else if success == 2 {
                completionBlock(false, "success2")
                //self.callApiForMultiWishlist(apiType:MultiWishlistAPIType.addNewWishListGroup)
                //GlobalData.sharedInstance.dismissLoader()
            }
            
            /*
            if success == 1{
                print(responseObject!)
                let apiResponse = responseObject as? NSDictionary
                AlertManager.shared.showSuccessSnackBar(msg:apiResponse!["message"] as! String)
                self.wishlistItems.remove(at:selItemIndexPath.row)
                self.myWishLIstTableView.reloadData()
                self.isListEdited = true
            }else if success == 2 {
                //self.callApiForMultiWishlist(apiType:MultiWishlistAPIType.addNewWishListGroup)
                //GlobalData.sharedInstance.dismissLoader()
            }*/
        }
    }
    
    class func copyItemToWishList(wishListGroupInfo:MyWishlistGroupModel, selItem:WishListItem, destGroupId:String, destGroupName:String, completionBlock:@escaping completionOnAddToWishList){
        if destGroupName == "Main" || destGroupId == wishListGroupInfo.id {
            AlertManager.shared.showInfoSnackBar(msg:"You have already item in this group")
            return
        }
        
        GlobalData.sharedInstance.showLoader()
        
        var requstParams = [String:Any]()
        requstParams["storeId"] = UserManager.getStoreId
        requstParams["customerToken"] = UserManager.getCustomerId
        
        if destGroupName == "Main" {
            requstParams["wishlist"] = "main"
        }else{
            requstParams["wishlist"] = destGroupId
        }
        
        if wishListGroupInfo.name == "Main"{
            requstParams["itemId"] = "main" + "-" + selItem.product_id
        }else{
            requstParams["itemId"] = selItem.product_id
        }
        
        // no need source group id to send
        if destGroupId == "new"{
            requstParams["newWishlistName"] = destGroupName
        }else{
            requstParams["newWishlistName"] = ""
        }
        
        // name of group where to move / or new group name
        print("Request Params: \(requstParams)")
        
        APIServiceManager.shared.callingHttpRequestWithoutView(params:requstParams, apiname:AfritiaAPI.copyItemFromWishListGroup ){success,responseObject in
            
            GlobalData.sharedInstance.dismissLoader()
            
            if success == 1{
                print(responseObject!)
                let apiResponse = responseObject as? NSDictionary
                GlobalData.sharedInstance.dismissLoader()
                let respMsg = apiResponse!["message"] as! String
                completionBlock(true, respMsg)
                
            }else if success == 2 {
                completionBlock(false, "success2")
                //self.callApiForMultiWishlist(apiType:MultiWishlistAPIType.addNewWishListGroup)
                //GlobalData.sharedInstance.dismissLoader()
            }
            
            /*
            if success == 1{
                print(responseObject!)
                let apiResponse = responseObject as? NSDictionary
                AlertManager.shared.showSuccessSnackBar(msg:apiResponse!["message"] as! String)
                self.isListEdited = true
            }else if success == 2 {
                //self.callApiForMultiWishlist(apiType:MultiWishlistAPIType.addNewWishListGroup)
                //GlobalData.sharedInstance.dismissLoader()
            }*/
        }
        
    }
    

}
