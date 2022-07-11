//
//  AddeditAddressModel.swift
//  Magento2MobikulNew
//
//  Created by Webkul  on 22/08/17.
//  Copyright © 2017 Webkul . All rights reserved.
//

import UIKit

class AddeditAddressModel: NSObject {
    var isMiddleNameVisible:Bool!
    var isPrefixRequired:Bool!
    var isPrefixVisible:Bool!
    var isSuffixRequired:Bool!
    var isSuffixVisible:Bool!
    var isTaxRequired:Bool!
    var isTaxVisible:Bool!
    var isPrefixHasOption:Bool!
    var isSuffixHasOption:Bool!
    var prefixValue:Array<Any>!
    var suffixValue:Array<Any>!
    var receiveMiddleName:String!
    var receivePrefixValue:String!
    var receiveSuffixValue:String!
    var receiveStreetCount:Int = 2
    var countryData:Array<Any>!
    var receiveFirstName:String!
    var receiveLastName:String!
    var receiveCompanyName:String!
    var receiveTelephoneValue:String!
    var faxValue:String!
    var receiveCity:String!
    var receivePostCode:String!
    var receiveStreetData:Array<Any>!
    var receiveIsDefaultBilling:Bool!
    var receiveIsDefaultShipping:Bool!
    var receiveCountryId:String!
    var receiveRegion:String!
    var receiveRegionId:String!
    var defaultCountry:String = ""
    var gdprEnable:Bool = false
    var gdprRequestAddressInfoBtn:Bool = false
    var tncAddressEnable:Bool = false
    var tncAddressContent: String = ""

    init(data: JSON) {
        self.isMiddleNameVisible = data["isMiddlenameVisible"].boolValue
        self.isPrefixRequired = data["isPrefixRequired"].boolValue
        self.isPrefixVisible = data["isPrefixVisible"].boolValue
        self.isSuffixRequired = data["isSuffixRequired"].boolValue
        self.isSuffixVisible = data["isSuffixVisible"].boolValue
        self.isTaxRequired = data["isTaxRequired"].boolValue
        self.isTaxVisible = data["isTaxVisible"].boolValue
        self.isPrefixHasOption = data["prefixHasOptions"].boolValue
        self.isSuffixHasOption = data["suffixHasOptions"].boolValue
        self.prefixValue = data["prefixOptions"].arrayObject
        self.suffixValue = data["suffixOptions"].arrayObject
        self.receiveMiddleName = data["addressData"]["middlename"].stringValue
        self.receivePrefixValue = data["addressData"]["prefix"].stringValue
        self.receiveSuffixValue = data["addressData"]["suffix"].stringValue
        self.receiveStreetCount = 2 //data["streetLineCount"].intValue
        self.countryData = data["countryData"].arrayObject
        self.receiveFirstName = data["addressData"]["firstname"].stringValue
        self.receiveLastName = data["addressData"]["lastname"].stringValue
        self.receiveCompanyName = data["addressData"]["company"].stringValue
        self.receiveTelephoneValue = data["addressData"]["telephone"].stringValue
        self.faxValue = data["addressData"]["fax"].stringValue
        self.receiveCity = data["addressData"]["city"].stringValue
        self.receivePostCode = data["addressData"]["postcode"].stringValue
        self.receiveStreetData = data["addressData"]["street"].arrayObject
        self.receiveIsDefaultBilling = data["addressData"]["isDefaultBilling"].boolValue
        self.receiveIsDefaultShipping = data["addressData"]["isDefaultShipping"].boolValue
        self.receiveCountryId = data["addressData"]["country_id"].stringValue
        self.receiveRegion = data["addressData"]["region"].stringValue
        self.receiveRegionId = data["addressData"]["region_id"].stringValue
        self.defaultCountry = data["defaultCountry"].stringValue
        self.gdprEnable = data["gdprEnable"].boolValue
        self.gdprRequestAddressInfoBtn = data["gdprRequestAddressInfoBtn"].boolValue
        self.tncAddressEnable = data["tncAddressEnable"].boolValue
        self.tncAddressContent = data["tncAddressContent"].stringValue
    }
}
