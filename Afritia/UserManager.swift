//
//  UserManager.swift
//  Afritia
//
//  Created by Ranjit Mahto on 30/09/20.
//  Copyright © 2020 kunal. All rights reserved.
//

import Foundation
import UIKit

class UserManager {
    
    class func saveDefaultStoreData(responseObject:AnyObject?)
    {
        
        if responseObject?.object(forKey: "storeId") != nil{
            let storeId:String = String(format: "%@", responseObject!.object(forKey: "storeId") as! CVarArg)
            if storeId != "0"{
                DEFAULTS.set(storeId, forKey: "storeId")
            }
        }
        
        if responseObject?.object(forKey: "defaultCurrency") != nil{
            if DEFAULTS.object(forKey: "currency") == nil{
                DEFAULTS.set(responseObject!.object(forKey: "defaultCurrency") as! String, forKey: "currency")
            }
        }
        
        
    }
    
    class func saveUserLoginData(responseObject:AnyObject?){
        
        let responseData = JSON(responseObject as! NSDictionary)
        if responseData["success"].boolValue == true{
            
            DEFAULTS.set(responseData["customerEmail"].stringValue, forKey: "customerEmail")
            DEFAULTS.set(responseData["customerToken"].stringValue, forKey: "customerId")
            DEFAULTS.set(responseData["customerName"].stringValue, forKey: "customerName")
            
            UserDefaults.standard.removeObject(forKey: "quoteId")
            
            if(DEFAULTS.object(forKey: "quoteId") != nil){
                DEFAULTS.set(nil, forKey: "quoteId")
                DEFAULTS.synchronize()
            }
            
            let profileImage = responseData["profileImage"].stringValue
            let bannerImage  = responseData["bannerImage"].stringValue
            
            if profileImage != ""{
                DEFAULTS.set(profileImage, forKey: "profilePicture")
            }
            if bannerImage != ""{
                DEFAULTS.set(bannerImage, forKey: "profileBanner")
            }
            
            
            if responseData["isAdmin"].intValue == 0{
                DEFAULTS.set("f", forKey: "isAdmin")
            }else{
                DEFAULTS.set("t", forKey: "isAdmin")
            }
            
            if responseData["isSeller"].intValue == 0{
                DEFAULTS.set("f", forKey: "isSeller")
            }else{
                DEFAULTS.set("t", forKey: "isSeller")
            }
            
            if responseData["isPending"].intValue == 0{
                DEFAULTS.set("f", forKey: "isPending")
                
            }else{
                DEFAULTS.set("t", forKey: "isPending")
            }
            
            DEFAULTS.synchronize()
            
        }
        
    }
        
   class var getDeviceUDID:String {
        if let uuid = UIDevice.current.identifierForVendor?.uuidString {
            return uuid
        }
        return "SIMULATE_U34XCD_D007M"
    }
    
    class var isAdmin:Bool{
        
        if DEFAULTS.object(forKey: "isAdmin") as! String == "f" {
            return false
        }
        return true
    }
    
    class var isSeller:Bool {
        if DEFAULTS.object(forKey: "isSeller") as! String == "f" {
            return false
        }
        return true
    }
    
    class var isPending:Bool {
        if DEFAULTS.object(forKey: "isPending") as! String == "f" {
            return false
        }
        return true
    }
    
    class var getWebsiteId: String {
        
        return DEFAULT_WEBSITE_ID
    }
    
    class var getStoreId: String {
        
        if DEFAULTS.object(forKey: "storeId") != nil{
            return DEFAULTS.object(forKey: "storeId") as! String
        }
        return "1"
    }
    
    class var getCurrencyType: String {
        
        if DEFAULTS.object(forKey: "currency") != nil{
            return DEFAULTS.object(forKey: "currency") as! String
        }
        return "NGN"
    }
    
    class var getCustomerId : String {
        if DEFAULTS.object(forKey:"customerId") != nil {
            return DEFAULTS.object(forKey: "customerId") as! String
        }
        return ""
    }
    
    class var getDeviceWidth : String {
        let width = String(format:"%f", SCREEN_WIDTH * UIScreen.main.scale)
        return width
    }
    
    //let quoteId = defaults.object(forKey:"quoteId");
    //let deviceToken = defaults.object(forKey:"deviceToken");
    
    class var getQuoteId:String{
        if DEFAULTS.object(forKey:"quoteId") != nil {
            return DEFAULTS.object(forKey: "quoteId") as! String
        }
        return ""
    }
    
    class var getDeviceToken:String{
        if DEFAULTS.object(forKey:"deviceToken") != nil {
            return DEFAULTS.object(forKey: "deviceToken") as! String
        }
        return ""
    }
}

