//
//  CustomerOrderDetailsModel.swift
//  Magento2MobikulNew
//
//  Created by Kunal Parsad on 23/08/17.
//  Copyright © 2017 Kunal Parsad. All rights reserved.
//

import UIKit

class CustomerOrderDetailsModel: NSObject {
    var billingAddress:String!
    var incrementId:String!
    var itemList:Array<Any>!
    var totals:Array<Any>!
    var orderDate:String!
    var paymentMethod:String!
    var shippingAddress:String!
    var shippingMethod:String!
    var status:String!
    var hasCreditmemo : Bool = false
    var hasInvoices : Bool = false
    var hasShipments : Bool = false
    
    init(data:JSON){
        self.billingAddress = data["billingAddress"].stringValue.html2String
        self.incrementId = data["incrementId"].stringValue
        self.totals = data["orderData"]["totals"].arrayObject
        self.orderDate = data["orderDate"].stringValue
        self.paymentMethod = data["paymentMethod"].stringValue
        self.shippingAddress = data["shippingAddress"].stringValue.html2String
        self.shippingMethod = data["shippingMethod"].stringValue
        self.status = data["statusLabel"].stringValue
        
        self.hasCreditmemo = data["hasCreditmemo"].boolValue
        self.hasInvoices = data["hasInvoices"].boolValue
        self.hasShipments = data["hasShipments"].boolValue
    }
}


struct CustomerTotal{
    var label:String = ""
    var value:String = ""
    var code:String = ""
    
    init(data:JSON) {
        self.label = data["label"].stringValue
        self.value = data["formattedValue"].stringValue
        self.code = data["code"].stringValue
    }
    
}

struct CustomerItemsData{
    var productName:String!
    var SubTotal:String!
    var price:String = ""
    var qty_Canceled:String = ""
    var qty_CanceledValue:Int = 0
    var qty_Ordered:String = ""
    var qty_OrderedValue:Int = 0
    var qty_Refunded:String = ""
    var qty_RefundedValue:Int = 0
    var qty_Shipped:String = ""
    var qty_ShippedValue:Int = 0
    var options:Array<JSON>
    
    init(data:JSON) {
        self.productName = data["name"].stringValue;
        self.SubTotal = data["subTotal"].stringValue;
        self.price = data["price"].stringValue;
        self.qty_Canceled = data["qty"]["Canceled"].stringValue;
        self.qty_CanceledValue = data["qty"]["Canceled"].intValue;
        self.qty_Ordered = data["qty"]["Ordered"].stringValue;
        self.qty_OrderedValue = data["qty"]["Ordered"].intValue;
        self.qty_Refunded = data["qty"]["Refunded"].stringValue;
        self.qty_RefundedValue = data["qty"]["Refunded"].intValue;
        self.qty_Shipped = data["qty"]["Shipped"].stringValue;
        self.qty_ShippedValue = data["qty"]["Shipped"].intValue;
        self.options = data["option"].arrayValue
    }
}

class CustomerOrderDetailsViewModel{
    var customerOrderList = [CustomerItemsData]()
    var customerTotalData = [CustomerTotal]()
    var invoiceData = [InvoiceData]()
    var shipmentData = [OrderShipmentData]()
    var trackingInfoURL : String = ""
    var customerOrderDetailsModel:CustomerOrderDetailsModel!
    
    init(data:JSON) {
        if let arrayData = data["orderData"]["itemList"].arrayObject as NSArray?{
            customerOrderList =  arrayData.map({(value) -> CustomerItemsData in
                return  CustomerItemsData(data:JSON(value))
            })
        }
       
        if let arrayData1 = data["orderData"]["totals"].arrayObject as NSArray?{
            customerTotalData =  arrayData1.map({(value) -> CustomerTotal in
                return  CustomerTotal(data:JSON(value))
            })
        }
   
        
        if let arrObj = data["invoiceList"].arrayObject {
            invoiceData =  arrObj.map({(value) -> InvoiceData in
                return  InvoiceData(data:JSON(value))
            })
        }
        
        if let arrObj = data["shipmentList"].arrayObject {
            shipmentData =  arrObj.map({(value) -> OrderShipmentData in
                return  OrderShipmentData(data:JSON(value))
            })
        }
        
        trackingInfoURL = data["trackingUrlForAllShipment"].stringValue
        customerOrderDetailsModel = CustomerOrderDetailsModel(data: data)
    }
}

struct TrackingInfo {
    var carrierCode : String = ""
    var id : String = ""
    var title : String = ""
    var url : String = ""
    
    init(data: JSON) {
        carrierCode = data["carrierCode"].stringValue
        id = data["id"].stringValue
        title = data["title"].stringValue
        url = data["url"].stringValue
    }
}

struct InvoiceData {
    var incrementId: String = ""
    var totals = [Totals]()
    var items = [ItemsData]()
    
    init(data: JSON) {
        incrementId = data["incrementId"].stringValue
        
        if let arrObj = data["items"].arrayObject {
            items =  arrObj.map({(value) -> ItemsData in
                return  ItemsData(data:JSON(value))
            })
        }
        
        if let arrObj = data["totals"].arrayObject {
            totals =  arrObj.map({(value) -> Totals in
                return  Totals(data:JSON(value))
            })
        }
    }
}

struct ItemsData {
    var name: String = ""
    var sku: String = ""
    var price: String = ""
    var qty: String = ""
    var subTotal: String = ""
    var option = [ItemOptionsData]()
    
    init(data: JSON) {
        name = data["name"].stringValue
        sku = data["sku"].stringValue
        price = data["price"].stringValue
        qty = data["qty"].stringValue
        subTotal = data["subTotal"].stringValue
        
        if let arrObj = data["option"].arrayObject {
            option =  arrObj.map({(value) -> ItemOptionsData in
                return  ItemOptionsData(data:JSON(value))
            })
        }
    }
}

struct ItemOptionsData{
    var label: String = ""
    var value: String = ""
    
    init(data: JSON) {
        label = data["label"].stringValue
        value = data["value"].stringValue
    }
}

struct Totals {
    var code : String = ""
    var label : String = ""
    var value : String = ""
    var formattedValue : String = ""
    
    init(data: JSON) {
        code = data["code"].stringValue
        label = data["label"].stringValue
        value = data["value"].stringValue
        formattedValue = data["formattedValue"].stringValue
    }
}

struct OrderShipmentData {
    var incrementId: String = ""
    var items = [ItemsData]()
    var trackingInfoURL : String = ""
    var trackingInfo = [TrackingInfo]()
    
    init(data: JSON) {
        incrementId = data["incrementId"].stringValue
        
        if let arrObj = data["items"].arrayObject {
            items =  arrObj.map({(value) -> ItemsData in
                return  ItemsData(data:JSON(value))
            })
        }
        
        if let arrObj = data["trackingInfo"].arrayObject {
            trackingInfo =  arrObj.map({(value) -> TrackingInfo in
                return  TrackingInfo(data:JSON(value))
            })
        }
        
        trackingInfoURL = data["allTrackingUrl"].stringValue
    }
}
