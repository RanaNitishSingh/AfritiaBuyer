//
//  AppConfiguration.swift
//  Magento2MobikulNew
//
//  Created by Webkul on 12/09/17.
//  Copyright © 2017 Webkul . All rights reserved.
//

import UIKit
import Alamofire


//API SERVICE URL CONFIGURATION
var DEFAULT_WEBSITE_ID = "1"
var BASE_DOMAIN = "https://afritia.com/"
//var SUB_DOMAIN = "mobileapp/"  //for afritia user application
var HOST_NAME = BASE_DOMAIN


// API USER AND PASSWORD
var API_USER_NAME  = "mobileapp"
var API_KEY = "mobileapp@123"


struct appConstant{
    
    // stripe
    static var stripePublishKeyTest = "pk_test_51H4Y2bAL9efz3I7xNyIYzjsiOejWIZYZGNRtL0SOLTlTo669l8U1SxzTlhA1TdwJeUcA5XPw7bOs6Iyx4NfiCZHa00yserZA94"
    static var stripeSecreKey = "sk_test_51H4Y2bAL9efz3I7xsGScIVM2iJ7u10lCBqB0XxYbBqsCMQ4ZJ4Cmjlxg9HLWu8Nx0vmCd7blDA5KOZ1wX03WfdKD00upIlYiiY"
    static var stripeLiveAPIKey = "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"
    
    //Google
    static let googleAPIKey = "AIzaSyCRmbu_2QkD_RGIXnxGznktGifW279jWro"
    static let googleLoginClientID = "527911399504-h1sbev12lsnrn9p0tqp68ci1cgbmsrns.apps.googleusercontent.com"
    
    //Twitter
    static let twitterConsumerKey = "K65tiAQK29wTliMrDn2Fgmm0E"
    static let twitterConsumerSecretKey = "zWiKNrlPNDVbnHgkS2BBuLCABqCfQConKKQNvB38F87k6qfaYn"
    
}



//var STRIPE_SECRET_KEY = "sk_test_51H4Y2bAL9efz3I7xsGScIVM2iJ7u10lCBqB0XxYbBqsCMQ4ZJ4Cmjlxg9HLWu8Nx0vmCd7blDA5KOZ1wX03WfdKD00upIlYiiY"

//var STRIPE_API_KEY = "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"

//Google
//var GMSERVICE_API_KEY = "AIzaSyCRmbu_2QkD_RGIXnxGznktGifW279jWro"
//var GOOGLE_LOGIN_CLIENT_ID = "527911399504-h1sbev12lsnrn9p0tqp68ci1cgbmsrns.apps.googleusercontent.com"

//Twitter
var TWITTER_CONSUMER_KEY = "K65tiAQK29wTliMrDn2Fgmm0E"
var TWITTER_CONSUMER_SECRET_KEY = "zWiKNrlPNDVbnHgkS2BBuLCABqCfQConKKQNvB38F87k6qfaYn"
