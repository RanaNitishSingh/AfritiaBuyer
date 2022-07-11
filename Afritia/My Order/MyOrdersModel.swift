//
//  MyOrdersModel.swift
//  Magento2MobikulNew
//
//  Created by Webkul  on 22/08/17.
//  Copyright © 2017 Webkul . All rights reserved.
//

import UIKit

class MyOrdersModel: NSObject {
    
    
    var orderId:String = ""
    var id:String = ""
    var order_total:String = ""
    var order_Date:String = ""
    var ship_To:String = ""
    var status:String = ""
    var order_state:String = ""
    var canReorder:Bool!
    var orderImage:String = ""
    var itemList:NSArray!
    
    
    init(data: JSON) {
        self.orderId = data["order_id"].stringValue
        self.id = data["id"].stringValue
        self.order_total = data["order_total"].stringValue
        self.ship_To = data["ship_to"].stringValue
        self.status = data["status"].stringValue
        self.order_state = data["state"].stringValue
        self.order_Date = data["date"].stringValue
        self.canReorder = data["canReorder"].boolValue
        self.orderImage = data["image"].stringValue
        
    }

}

class TotalOrders:NSObject{
    var totalCount:Int = 0
    
    init(data: JSON) {
        totalCount = data["totalCount"].intValue
    }
}

class MyOrdersCollectionViewModel {
    
    var myOrderCollectionModel = [MyOrdersModel]()
    var totalOrders:TotalOrders!
    
    init(data:JSON) {
        for i in 0..<data["orderList"].count{
            let dict = data["orderList"][i];
            myOrderCollectionModel.append(MyOrdersModel(data: dict))
        }
        totalOrders = TotalOrders(data: data)
    }
    
    var getMyOrdersCollectionData:Array<MyOrdersModel>{
        return myOrderCollectionModel
    }
 
    var totalCount:Int{
        return totalOrders.totalCount
    }

    func setMyOrderCollectionData(data:JSON){
        for i in 0..<data["orderList"].count{
            let dict = data["orderList"][i];
            myOrderCollectionModel.append(MyOrdersModel(data: dict))
        }
    }

}


//------------------------------------------ Copy from seller app -------------------------------
// to solve the order filter class model error for SellerOrderViewModel

struct SellerProducts{
    var name:String = ""
    var productId:String = ""
    var qty:String = ""
    
    init(data:JSON) {
        self.name = data["name"].stringValue
        self.productId = data["productId"].stringValue
        self.qty = data["qty"].stringValue
     }
}

struct SellerOrderData{
    var date:String = ""
    var orderID:String = ""
    var incrementID:String = ""
    var customerName:String = ""
    var ordertotalBase:String = ""
    var ordertotalPurchase:String = ""
    var status:String = ""
    var sellerProducts = [SellerProducts]()
    
    init(data:JSON) {
        self.date = data["customerDetails"]["date"].stringValue
        self.orderID = data["orderId"].stringValue
        self.incrementID = data["incrementId"].stringValue
        self.customerName = data["customerDetails"]["name"].stringValue
        self.ordertotalBase = data["customerDetails"]["baseTotal"].stringValue
        self.ordertotalPurchase  = data["customerDetails"]["purchaseTotal"].stringValue
        self.status = data["status"].stringValue
        
        if let arrayData = data["productNames"].arrayObject{
            sellerProducts =  arrayData.map({(value) -> SellerProducts in
                return  SellerProducts(data:JSON(value))
            })
        }
    }
}

struct OrderStatus{
    var label:String = ""
    var status:String = ""
    
    init(data:JSON) {
        self.label = data["label"].stringValue
        self.status = data["status"].stringValue
    }
}

class SellerOrderViewModel{
    
    var sellerOrderData = [SellerOrderData]()
    var orderStatus = [OrderStatus]()
    var totalCount:Int = 0
    
    init(data:JSON) {
        if let arrayData = data["orderStatus"].arrayObject{
            orderStatus =  arrayData.map({(value) -> OrderStatus in
                return  OrderStatus(data:JSON(value))
            })
        }
        if let arrayData = data["orderList"].arrayObject{
            sellerOrderData =  arrayData.map({(value) -> SellerOrderData in
                return  SellerOrderData(data:JSON(value))
            })
        }
        totalCount = data["totalCount"].intValue
    }
    
    func setSellerOrderCollectionData(data:JSON){
        for i in 0..<data["orderList"].count{
            let dict = data["orderList"][i];
            sellerOrderData.append(SellerOrderData(data: dict))
        }
    }
}

