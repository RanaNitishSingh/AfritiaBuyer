//
//  MyWishlistModel.swift
//  Getkart
//
//  Created by Webkul on 14/08/18.
//  Copyright © 2018 Webkul. All rights reserved.
//


import UIKit

struct MyWishlistModel  {
    
    var description: String = ""
    var id: String = ""
    var name: String = ""
    var price: String = ""
    var productId: String = ""
    var qty: Int = 0
    var rating: Double = 0.0
    var sku: String = ""
    var thumbNail: String = ""
    var typeId: String = ""
    var options : NSArray!
    var formatedMaxPrice: String = ""
    var formatedMinPrice: String = ""
    var groupedPrice: String = ""
    
    init(data: JSON) {
        description = data["description"].stringValue
        id = data["id"].stringValue
        name = data["name"].stringValue
        price = data["formatedFinalPrice"].stringValue
        productId = data["productId"].stringValue
        qty = data["qty"].intValue
        rating = data["rating"].doubleValue
        sku = data["sku"].stringValue
        thumbNail = data["thumbNail"].stringValue
        typeId = data["typeId"].stringValue
        options = data["options"].arrayObject! as NSArray
        formatedMaxPrice = data["formatedMaxPrice"].stringValue
        formatedMinPrice = data["formatedMinPrice"].stringValue
        groupedPrice = data["groupedPrice"].stringValue
    }
}

struct MyWishlistGroupModel {
    
    var id:String = ""
    var name:String = ""
    var wishListMainId:String = ""
    var wishListShareLink:String = ""
    var items = [WishListItem]()
    
    init(data: JSON) {
        
        id = data["id"].stringValue
        name = data["name"].stringValue
        wishListMainId = data["wishListMainId"].stringValue
        wishListShareLink = data["wishListShareLink"].stringValue
        
        if var arrayData = data["items"].arrayObject{
            arrayData = (data["items"].arrayObject! as NSArray) as! [Any]
            items =  arrayData.map({(value) -> WishListItem in
                return  WishListItem(data:JSON(value))
            })
        }
    }
    
}

struct WishListItem {
    var id:String = ""
    var product_id:String = ""
    var sku:String = ""
    var product_url:String = ""
    var price:String = ""
    var img_link:String = ""
    var product_name:String = ""
    var description:String = ""
    var qty:String = ""
    //var product:WishListProduct!
    
    init(data: JSON) {
        
        id = data["id"].stringValue
        product_id = data["product_id"].stringValue
        sku = data["sku"].stringValue
        product_url = data["product_url"].stringValue
        price = data["price"].stringValue
        img_link = data["img_link"].stringValue
        product_name = data["product_name"].stringValue
        description = data["description"].stringValue
        qty = data["qty"].stringValue
        //product = WishListProduct(data:data) // product
        
    }
    
    //NOTE : Remove Comment to Activate Product Json
    
}

/*  Remove this comment to Activate Product Json

struct WishListProduct {
    
    var entity_id: String = ""
    var attribute_set_id : String = ""
    var type_id : String = ""
    var sku : String = ""
    var has_options : String = ""
    var required_options : String = ""
    var created_at : String = ""
    var updated_at : String = ""
    var status : String = ""
    var visibility : String = ""
    var tax_class_id : String = ""
    var trending : String = ""
    var best_seller : String = ""
    var featured : String = ""
    var mgs_j360 : String = ""
    var is_deal : String = ""
    var is_new : String = ""
    var meta_meta_keywordword : String = ""
    var name : String = ""
    var meta_title : String = ""
    var meta_description : String = ""
    var image : String = ""
    var small_image : String = ""
    var thumbnail : String = ""
    var options_container : String = ""
    var url_url_key : String = ""
    var swatch_image : String = ""
    var gift_message_available : String = ""
    var price : String = ""
    var weight : String = ""
    var is_salable : Int = 0
    var request_path : String = ""
    
    var media_gallery : MediaGallery!
    var extension_attributes : ExtensionAttributes!
    var quantity_and_stock_status : QuantityAndStockStatus!
    
    var category_ids = [String]()
    var options = [Any]()
    
    init(data: JSON) {
        
        entity_id = data["entity_id"].stringValue
        attribute_set_id = data["attribute_set_id"].stringValue
        type_id = data["type_id"].stringValue
        sku = data["sku"].stringValue
        has_options = data["has_options"].stringValue
        required_options = data["required_options"].stringValue
        created_at = data["created_at"].stringValue
        updated_at = data["updated_at"].stringValue
        status = data["status"].stringValue
        visibility = data["visibility"].stringValue
        tax_class_id = data["tax_class_id"].stringValue
        trending = data["trending"].stringValue
        best_seller = data["best_seller"].stringValue
        featured = data["featured"].stringValue
        mgs_j360 = data["mgs_j360"].stringValue
        is_deal = data["is_deal"].stringValue
        is_new = data["is_new"].stringValue
        meta_meta_keywordword = data["meta_meta_keywordword"].stringValue
        name = data["name"].stringValue
        meta_title = data["meta_title"].stringValue
        meta_description = data["meta_description"].stringValue
        image = data["image"].stringValue
        small_image = data["small_image"].stringValue
        thumbnail = data["thumbnail"].stringValue
        options_container = data["options_container"].stringValue
        url_url_key = data["url_url_key"].stringValue
        swatch_image = data["swatch_image"].stringValue
        gift_message_available = data["gift_message_available"].stringValue
        price = data["price"].stringValue
        weight = data["weight"].stringValue
        is_salable = data["is_salable"].intValue
        request_path = data["request_path"].stringValue
        
        media_gallery =  MediaGallery(data:data)
        extension_attributes = ExtensionAttributes(data:data)
        quantity_and_stock_status = QuantityAndStockStatus(data:data)
        
        category_ids = data["category_ids"].arrayObject as! [String]
        options = data["options"].arrayObject as! [Any]
        
    }
}

struct ExtensionAttributes {
    
    init(data: JSON) {
    }
}

struct QuantityAndStockStatus {
    var is_in_stock:Bool!
    var qty:Int!
    
    init(data: JSON) {
        is_in_stock = data["is_in_stock"].boolValue
        qty = data["qty"].intValue
    }
}

struct MediaGallery {
    var images : WLImage!
    var values = [String]()
    
    init(data: JSON) {
        
        images =  WLImage(data:data)
        values = data["values"].arrayObject as! [String]
    }
    
}

struct WLImage {
    var imagesdData = [ImageInfo]()
    //"value_id": "2483",
    
    init(data: JSON) {
        
        if var arrayData = data["value_id"].arrayObject{
            arrayData = (data["value_id"].arrayObject! as NSArray) as! [Any]
            imagesdData =  arrayData.map({(value) -> ImageInfo in
                return  ImageInfo(data:JSON(value))
            })
        }
    }
}

struct ImageInfo {
    
    var value_id : String = ""
    var file : String = ""
    var media_type : String = ""
    var entity_id : String = ""
    var label : String = ""
    var position : String = ""
    var disabled : String = ""
    var label_default : String = ""
    var position_default : String = ""
    var disabled_default : String = ""
    var video_provider : String = ""
    var video_url : String = ""
    var video_title : String = ""
    var video_description : String = ""
    var video_metadata : String = ""
    var video_provider_default : String = ""
    var video_url_default : String = ""
    var video_title_default : String = ""
    var video_description_default : String = ""
    var video_metadata_default : String = ""

    init(data: JSON) {
        
        value_id = data["value_id"].stringValue
        file = data["file"].stringValue
        media_type = data["media_type"].stringValue
        entity_id = data["entity_id"].stringValue
        label = data["label"].stringValue
        position = data["position"].stringValue
        disabled = data["disabled"].stringValue
        label_default = data["label_default"].stringValue
        position_default = data["position_default"].stringValue
        disabled_default = data["disabled_default"].stringValue
        video_provider = data["video_provider"].stringValue
        video_url = data["video_url"].stringValue
        video_title = data["video_title"].stringValue
        video_description = data["video_description"].stringValue
        video_metadata = data["video_metadata"].stringValue
        video_provider_default = data["video_provider_default"].stringValue
        video_url_default = data["video_url_default"].stringValue
        video_title_default = data["video_title_default"].stringValue
        video_description_default  = data["video_description_default"].stringValue
        video_metadata_default = data["video_metadata_default"].stringValue
    }
}

*/
