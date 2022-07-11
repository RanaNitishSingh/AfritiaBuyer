//
//  ProductModel.swift
//  RealmDatabase
//
//  Created by Webkul on 10/04/18.
//  Copyright © 2018 Webkul. All rights reserved.
//

import Foundation
import RealmSwift
import UIKit

class Productcollection: Object {
    
    @objc dynamic var name:String! = ""
    @objc dynamic var ProductID:String! = ""
    @objc dynamic var typeID:String! = ""
    
    @objc dynamic var image:String! = ""
    @objc dynamic var price:String! = ""
    @objc dynamic var DateTime:String! = ""
    @objc dynamic var isInWishlist:String! = ""
    @objc dynamic var isInRange:String! = ""
    
    @objc dynamic var specialPrice:String! = ""
    @objc dynamic var originalPrice:String! = ""
    @objc dynamic var showSpecialPrice:String! = ""
    @objc dynamic var formatedPrice:String! = ""
    
    @objc dynamic var groupedPrice:String! = ""
    @objc dynamic var formatedMinPrice:String! = ""
    @objc dynamic var formatedMaxPrice:String! = ""
   
    @objc dynamic var isFreeshipping:String  = ""
    @objc dynamic var shippingPrice:String  = ""
    
    @objc dynamic var isBundle:String!
    
    override static func primaryKey() -> String? {
        return "ProductID"
        
    }
    
    convenience init (value: JSON) {
        self.init()
        
        print("Product Model Json: \(value)")
        
        self.name = value["name"].stringValue
        self.ProductID = value["ProductID"].stringValue
        self.typeID = value["typeId"].stringValue
        self.image = value["image"].stringValue
        self.price = value["price"].stringValue
        self.DateTime = value["DateTime"].stringValue
        self.isInWishlist = value["isInWishlist"].stringValue
        self.isInRange = value["isInRange"].stringValue
        self.specialPrice = value["specialPrice"].stringValue
        self.originalPrice = value["originalPrice"].stringValue
        self.showSpecialPrice = value["showSpecialPrice"].stringValue
        self.formatedPrice = value["formatedPrice"].stringValue
        self.groupedPrice = value["groupedPrice"].stringValue
        self.formatedMinPrice = value["formatedMinPrice"].stringValue
        self.formatedMaxPrice = value["formatedMaxPrice"].stringValue
        
        //1: true and 0: false
        self.isBundle = value["isBundle"].stringValue
        
        self.isFreeshipping = value["isFreeshipping"].stringValue
        self.shippingPrice = value["shippingPrice"].stringValue

       
    }
}

func json(from object:Any) -> String? {
    
    guard let data = try? JSONSerialization.data(withJSONObject: object, options: []) else {
        return nil
    }
    return String(data: data, encoding: String.Encoding.utf8)
}



class ProductViewModel{
    
    init() {
    }
    
    init(data:JSON) {
        
        try? DBManager.sharedInstance.database?.write {
            if (self.getProductDataFromDB()).count >= 10 {
                DBManager.sharedInstance.database?.delete((self.getProductDataFromDB())[9])
                DBManager.sharedInstance.database?.add(Productcollection(value:data), update: .all)
                print("Deleted than Added new object")
            }else {
                DBManager.sharedInstance.database?.add(Productcollection(value:data), update: .all)
                print("Added new object")
            }
        }
    }
    
    func getProductDataFromDB() -> [Productcollection]   {
        if let results: Results<Productcollection> = DBManager.sharedInstance.database?.objects(Productcollection.self) {
            return ((Array(results)).sorted(by: { $0.DateTime.compare($1.DateTime) == .orderedDescending }))
        }
        
        return []
    }
    
    func deleteAllRecentViewProductData(){
        if let results:Results<Productcollection> =   DBManager.sharedInstance.database?.objects(Productcollection.self) {
            for obj in results{
                
                try! DBManager.sharedInstance.database?.write {
                    DBManager.sharedInstance.database?.delete(obj)
                }
            }
        }
    }
}
