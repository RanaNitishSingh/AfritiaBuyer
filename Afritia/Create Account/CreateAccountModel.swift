//
//  CreateAccountModel.swift
//  Magento2MobikulNew
//
//  Created by Webkul on 18/08/17.
//  Copyright © 2017 Webkul. All rights reserved.
//

import UIKit

class CreateAccountModel: NSObject {
    var isDobRequired:Bool!
    var isDobVisible:Bool!
    var isGenderRequired:Bool!
    var isGenderVisible:Bool!
    var isMiddleNameVisible:Bool!
    var isMobileNumberVisible:Bool!
    var isMobileNumberRequired:Bool!
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
    var howDidYouHearOptions:Array<Any>!
    var countryCodes:Array<Any>!
    var countries:Array<Any>!
    var isHowDidYouHearRequired:Bool!
    var isHowDidYouHearVisible:Bool!
    var dateFormat:String!
    var passwordLength: Int = 0
    var allowSellerRegistrationBlock: Bool = false
    
    var isEmailIdVisible:Bool!
    var isCountryVisible:Bool!
    var isPasswordVisible:Bool!
    var isTwoFactorVisible:Bool!
    
    init(data: JSON) {
        self.dateFormat = data["dateFormat"].stringValue
        self.isDobRequired = data["isDOBRequired"].boolValue
        self.isDobVisible = data["isDOBVisible"].boolValue
        self.isGenderRequired = data["isGenderRequired"].boolValue
        self.isGenderVisible = data["isGenderVisible"].boolValue
        self.isMiddleNameVisible = data["isMiddlenameVisible"].boolValue
        self.isMobileNumberRequired = data["isMobileRequired"].boolValue
        self.isMobileNumberVisible = data["isMobileVisible"].boolValue
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
        self.howDidYouHearOptions = data["HowDidYouHearOptions"].arrayObject
        self.countryCodes = data["country_code"].arrayObject
        self.countries = data["country"].arrayObject
        self.isHowDidYouHearRequired = data["isHowDidYouHearRequired"].boolValue
        self.isHowDidYouHearVisible = data["isHowDidYouHearVisible"].boolValue
        self.passwordLength = data["passwordLength"].intValue
        self.allowSellerRegistrationBlock = data["allowSellerRegistrationBlock"].boolValue
        self.isEmailIdVisible = true
        self.isCountryVisible = true
        self.isPasswordVisible = true
        self.isTwoFactorVisible = true
    }
}
