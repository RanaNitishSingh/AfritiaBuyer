//
//  AfritiaAPI.swift
//  Afritia
//
//  Created by Ranjit Mahto on 01/10/20.
//  Copyright © 2020 kunal. All rights reserved.
//

import Foundation
import UIKit
import Alamofire

var SUB_DOMAIN_USER = "mobileapp/"  //for afritia user application
var SUB_DOMAIN_SELLER = "mobilempapp/" //for afritia seller application

struct AfritiaSellerAPI {
    
    static let dashboard = SUB_DOMAIN_SELLER + "marketplace/Dashboard"
    static let orderList = SUB_DOMAIN_SELLER + "marketplace/OrderList"
    static let createShipment = SUB_DOMAIN_SELLER + "marketplace/createShipment"
    static let sendOrdereMail = SUB_DOMAIN_SELLER + "marketplace/sendorderemail"
    static let cancelOrder = SUB_DOMAIN_SELLER + "marketplace/cancelorder"
    static let createInvoice = SUB_DOMAIN_SELLER + "marketplace/createinvoice"
    static let viewOrder = SUB_DOMAIN_SELLER + "marketplace/vieworder"
    static let createAccountForm = SUB_DOMAIN_SELLER + "marketplace/createAccountFormData"
    static let createAccount = SUB_DOMAIN_SELLER + "marketplace/createAccount"
    
    static let profileFormData = SUB_DOMAIN_SELLER + "marketplace/profileFormData"
    static let deleteSellerImage = SUB_DOMAIN_SELLER + "marketplace/deleteSellerImage"
    
    static let saveAttribute = SUB_DOMAIN_SELLER + "product/saveattribute"
    static let productDelete = SUB_DOMAIN_SELLER + "marketplace/ProductDelete"
    static let productList = SUB_DOMAIN_SELLER + "marketplace/Productlist"
    
    static let checkSku = SUB_DOMAIN_SELLER + "product/checkSku"
    static let SaveProduct = SUB_DOMAIN_SELLER + "product/SaveProduct"
    static let newProductFormdata = SUB_DOMAIN_SELLER + "product/newformdata"
    static let uploadProductImage = SUB_DOMAIN_SELLER + "product/UploadProductImage"
    
    static let transactionList = SUB_DOMAIN_SELLER + "marketplace/transactionList"
    static let pdfHeaderFormData = SUB_DOMAIN_SELLER + "marketplace/PdfHeaderFormData"
    static let savePDFHeader = SUB_DOMAIN_SELLER + "marketplace/SavePdfHeader"
    static let downloadAllInvoice = SUB_DOMAIN_SELLER + "marketplace/downloadAllInvoice"
    static let downloadAllShipping = SUB_DOMAIN_SELLER + "marketplace/downloadAllShipping"
    
    static let withdrawalRequest = SUB_DOMAIN_SELLER + "marketplace/withdrawalRequest"
    
    //Get OTP
    static let getOTPCode = SUB_DOMAIN_USER + "customer/SendOtp"
    
    static let sellerCollection = SUB_DOMAIN_SELLER + "marketplace/SellerCollection"
    
    
}

struct AfritiaAPI {
    
    //registerDevice
    static let registerDevice = SUB_DOMAIN_USER + "extra/registerDevice"
    
    //home
    static let homePageData = SUB_DOMAIN_USER + "catalog/homePageData"
    
    //compare
    static let addToCompare = SUB_DOMAIN_USER + "catalog/addtocompare"
    static let removefromCompare =  SUB_DOMAIN_USER + "catalog/removefromcompare"
    static let compareList =  SUB_DOMAIN_USER + "catalog/comparelist"
    
    //search
    static let searchSuggesion = SUB_DOMAIN_USER + "extra/searchSuggestion"
    static let searchTermList = SUB_DOMAIN_USER + "extra/searchTermList"
    
    //advanceSearch
    static let advanceSearchFormData = SUB_DOMAIN_USER + "catalog/advancedsearchformdata"
    
    //logiin
    static let forgotPassword  = SUB_DOMAIN_USER + "customer/forgotpassword"
    static let login = SUB_DOMAIN_USER + "customer/logIn"
    
    //register
    static let createAccountForm = SUB_DOMAIN_USER + "customer/createAccountFormData"
    static let createAccount = SUB_DOMAIN_USER + "customer/createAccount"
    static let accountInfoData = SUB_DOMAIN_USER + "customer/accountInfoData"
    static let saveAccountInfo =  SUB_DOMAIN_USER + "customer/saveAccountInfo"
    
    //Get OTP
    static let getOTPCode = SUB_DOMAIN_USER + "customer/SendOtp"
    
    //cms data liinks
    static let cmsData = SUB_DOMAIN_USER + "extra/cmsData"
    
    //notification
    static let notificationList = SUB_DOMAIN_USER + "extra/notificationList"
    
    static let contactUsPost = SUB_DOMAIN_USER + "contact/post"
    
    //addressbook
    static let deleteAddress =  SUB_DOMAIN_USER + "customer/deleteAddress"
    static let addressBookData = SUB_DOMAIN_USER + "customer/addressBookData"
    static let saveAddress = SUB_DOMAIN_USER + "customer/saveAddress"
    static let addressFormData = SUB_DOMAIN_USER + "customer/addressformData"
    
    //myOrder
    static let reOrder = SUB_DOMAIN_USER + "customer/reOrder"
    static let orderList = SUB_DOMAIN_USER + "customer/orderList"
    
    //order detail
    static let orderDetails = SUB_DOMAIN_USER + "customer/orderDetails"
    
    //review
    static let reviewList = SUB_DOMAIN_USER + "customer/reviewList"
    static let saveReview = SUB_DOMAIN_USER + "customer/saveReview"
    static let reviewDetails = SUB_DOMAIN_USER + "customer/reviewDetails"
    
    //wishlist
    static let addToWishlist = SUB_DOMAIN_USER + "catalog/addtoWishlist"
    static let wishListToCart = SUB_DOMAIN_USER + "customer/wishlisttoCart"
    static let updateWishList = SUB_DOMAIN_USER + "customer/updatewishList"
    static let removeFromWishList = SUB_DOMAIN_USER + "customer/removefromWishlist"
    static let wishList = SUB_DOMAIN_USER + "customer/wishList"
    
    //multiWishlist
     static let allAvailableWishlist = SUB_DOMAIN_USER + "customer/MultipleWishlist"
     static let renameWishlistGroup = SUB_DOMAIN_USER + "customer/UpdateWishlistGroup"
     static let deleteWishListGroup = SUB_DOMAIN_USER + "customer/RemoveMultipleWishlistGroup"
     static let addNewWishListGroup = SUB_DOMAIN_USER + "catalog/AddToMultipleWishlist"
     static let addNewWishListGroupWithProduct = SUB_DOMAIN_USER + "catalog/AddToMultipleWishlist"
     static let removeItemFromWishListGroup =  SUB_DOMAIN_USER + "customer/RemoveFromMultipleWishlist"
     static let copyItemFromWishListGroup = SUB_DOMAIN_USER + "customer/CopyItemFromWishlistGroup"
     static let moveItemFromWishListGroup = SUB_DOMAIN_USER + "customer/MoveItemFromWishlistGroup"
    
    
    //myKart
    static let addToCart =  SUB_DOMAIN_USER + "checkout/addtoCart"
    static let removeCartItem = SUB_DOMAIN_USER + "checkout/removecartItem"
    static let wishlistFromCart = SUB_DOMAIN_USER + "checkout/wishlistfromCart"
    static let emptyCart = SUB_DOMAIN_USER + "checkout/emptyCart"
    static let updateCart = SUB_DOMAIN_USER + "checkout/updateCart"
    static let applyCoupan = SUB_DOMAIN_USER + "checkout/applyCoupon"
    static let cartDetails = SUB_DOMAIN_USER + "checkout/cartDetails"
    
    //product detail
    static let productPageData = SUB_DOMAIN_USER + "catalog/productPageData"
    static let sellerProfile =  SUB_DOMAIN_SELLER + "marketplace/SellerProfile"
    
    //catalog
     static let newProductList = SUB_DOMAIN_USER + "catalog/newProductList"
     static let featuredProductList = SUB_DOMAIN_USER + "catalog/featuredProductList"
     static let hotDealList = SUB_DOMAIN_USER + "catalog/hotDealList"
     static let advancedSearchResult = SUB_DOMAIN_USER + "catalog/AdvancedSearchResult"
     static let searchResult = SUB_DOMAIN_USER + "catalog/searchResult"
     static let customcollection = SUB_DOMAIN_USER + "extra/customcollection"
     static let sellerCollection = SUB_DOMAIN_USER + "marketplace/SellerCollection"
     static let categoryProductList = SUB_DOMAIN_USER + "catalog/categoryProductList"
     
      //checkout
     static let billingShippingInfo =  SUB_DOMAIN_USER + "checkout/billingShippingInfo"
     static let shippingPaymentMethodInfo =  SUB_DOMAIN_USER +  "checkout/shippingPaymentMethodInfo"
     static let orderReviewInfo =  SUB_DOMAIN_USER +  "checkout/orderreviewInfo"
     static let saveOrder = SUB_DOMAIN_USER + "checkout/saveOrder"
    
    //download
    static let downloadProduct = SUB_DOMAIN_USER + "customer/downloadProduct"
    static let myDownloadsList = SUB_DOMAIN_USER + "customer/myDownloadsList"
    
    
    static var payPalPaymentUrl:String {
        
        let quoteId = UserManager.getQuoteId
        let customerId = UserManager.getCustomerId
        let storeId = UserManager.getStoreId
        var paymentUrl = ""
        
        if storeId != "" {
            if customerId != ""    {
                paymentUrl = HOST_NAME + "mobileapp/checkout/paystackredirect/?storeId=\(storeId)&customerToken=\(customerId)&quoteId=\(quoteId)"
            }
            else if quoteId != "" {
                paymentUrl = HOST_NAME + "mobileapp/checkout/PaypalRedirect/?storeId=\(storeId)&quoteId=\(quoteId))&customerToken="
            }
        }
        return paymentUrl
    }
    
    static var payStackPaymentUrl:String {
        
        let quoteId = UserManager.getQuoteId
        let customerId = UserManager.getCustomerId
        let storeId = UserManager.getStoreId
        var paymentUrl = ""
        
        if storeId != "" {
            if customerId != "" {
                paymentUrl = HOST_NAME + "mobileapp/checkout/paystackredirect/?storeId=\(storeId)&customerToken=\(customerId)&quoteId=\(quoteId)"
            }
            else if quoteId != "" {
                paymentUrl = HOST_NAME + "mobileapp/checkout/paystackredirect/?storeId=\(storeId)&quoteId=\(quoteId)&customerToken="
            }
        }
        return paymentUrl
    }
}

