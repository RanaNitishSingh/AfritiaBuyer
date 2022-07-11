//
//  HelperClass.swift
//  Magento2MobikulNew
//
//  Created by Webkul  on 12/09/17.
//  Copyright © 2017 Webkul . All rights reserved.
//

import UIKit
import Alamofire
import Foundation

let  IS_IPAD = UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiom.pad

class HelperClass: NSObject {
    var dd:String = ""
}

let SCREEN_WIDTH = ((UIApplication.shared.statusBarOrientation == .portrait) || (UIApplication.shared.statusBarOrientation == .portraitUpsideDown) ? UIScreen.main.bounds.size.width : UIScreen.main.bounds.size.height)
let SCREEN_HEIGHT = ((UIApplication.shared.statusBarOrientation == .portrait) || (UIApplication.shared.statusBarOrientation == .portraitUpsideDown) ? UIScreen.main.bounds.size.height : UIScreen.main.bounds.size.width)


class Connectivity {
    class func isConnectedToInternet() ->Bool {
        return NetworkReachabilityManager()!.isReachable
    }
}

enum VersionError: Error {
    case invalidResponse, invalidBundleInfo
}

