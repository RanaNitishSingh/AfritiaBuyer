//
//  ComapreListModel.swift
//  Magento2MobikulNew
//
//  Created by Webkul  on 25/08/17.
//  Copyright © 2017 Webkul . All rights reserved.
//

import UIKit

class ComapreListModel: NSObject {
    var productName:String!
    var price:String!
    var imageUrl:String!
    var specialPrice:String!
    var rating:CGFloat!
    var productId:String!
    var hasOption:Int = 0
    var isInWishlist:Bool!
    var wishlistItemId:String!
    var typeId:String!
    
    init(data:JSON){
        self.productName = data["name"].stringValue
        self.price = data["formatedFinalPrice"].stringValue
        self.specialPrice = data["specialPrice"].stringValue
        self.rating = CGFloat(data["rating"].floatValue)
        self.imageUrl = data["thumbNail"].stringValue
        self.productId = data["entityId"].stringValue
        self.hasOption = data["hasOptions"].intValue
        self.isInWishlist = data["isInWishlist"].boolValue
        self.wishlistItemId = data["wishlistItemId"].stringValue
        self.typeId = data["typeId"].stringValue
     }
}

class AttributesName:NSObject{
    var attributesName:String!
    init(data:JSON){
        self.attributesName = data["attributeName"].stringValue
    }

}



class AttributesValue: NSObject {
    var attributesValueArray:Array<Any>!
    
    init(data:JSON){
        self.attributesValueArray = data["value"].arrayObject

    }

    
}


class CompareListViewModel:NSObject{
    var productListModel = [ComapreListModel]()
    var attributesName = [AttributesName]()
    var attributesValue = [AttributesValue]()
    
    
    init(data:JSON) {
        let arrayData = data["productList"].arrayObject! as NSArray
        productListModel =  arrayData.map({(value) -> ComapreListModel in
            return  ComapreListModel(data:JSON(value))
        })
    
        let arrayData2 = data["attributeValueList"].arrayObject! as NSArray
        attributesName =  arrayData2.map({(value) -> AttributesName in
            return  AttributesName(data:JSON(value))
        })
        
        let arrayData3 = data["attributeValueList"].arrayObject! as NSArray
        attributesValue =  arrayData3.map({(value) -> AttributesValue in
            return  AttributesValue(data:JSON(value))
        })
        
    }
    
    var getProductList:Array<ComapreListModel>{
        return productListModel
    }
    
    var getAttributsName:Array<AttributesName>{
        return attributesName
    }
    
    var getAttributesValue:Array<AttributesValue>{
        return attributesValue
    }
    
}




