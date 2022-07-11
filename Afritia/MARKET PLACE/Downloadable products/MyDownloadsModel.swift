//
/**
 Getkart
 @Category Webkul
 @author Webkul <support@webkul.com>
 FileName: MyDownloadsModel.swift
 Copyright (c) 2010-2018 Webkul Software Private Limited (https://webkul.com)
 @license https://store.webkul.com/license.html ASL Licence
 @link https://store.webkul.com/license.html
 
 */

import Foundation
import UIKit

struct MyDownloadsModel {
    
    var totalCount : Int = 0
    var downloadsList = [DownloadsList]()
    
    init(data: JSON) {
        totalCount = data["totalCount"].intValue
        
        if let arr = data["downloadsList"].arrayObject{
            downloadsList = arr.map({(val) -> DownloadsList in
                return DownloadsList(data: JSON(val))
            })
        }
    }
}

struct DownloadsList {
    var canReorder : Bool!
    var date : String = ""
    var hash : String = ""
    var incrementId : String = ""
    var isOrderExist : Bool!
    var message : String = ""
    var proName : String = ""
    var remainingDownloads : String = ""
    var state : String = ""
    var status : String = ""
    
    init(data: JSON) {
        canReorder = data["canReorder"].boolValue
        date = data["date"].stringValue
        hash = data["hash"].stringValue
        incrementId = data["incrementId"].stringValue
        isOrderExist = data["isOrderExist"].boolValue
        message = data["message"].stringValue
        proName = data["proName"].stringValue
        remainingDownloads = data["remainingDownloads"].stringValue
        state = data["state"].stringValue
        status = data["status"].stringValue
    }
}
