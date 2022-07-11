//
//  APIServiceManager.swift
//  Afritia
//
//  Created by Ranjit Mahto on 16/10/20.
//  Copyright © 2020 kunal. All rights reserved.
//

import Foundation
import Alamofire
import UIKit

class APIServiceManager: NSObject{
    
    class var shared:APIServiceManager {
        struct Singleton {
            static let instance = APIServiceManager()
        }
        return Singleton.instance
    }
    
    func callingHttpRequest(params:Dictionary<String,Any>, apiname:String,currentView:UIViewController,taskCallback: @escaping (Int,
        AnyObject?) -> Void)  {
        let defaults = UserDefaults.standard
        let urlString  = HOST_NAME + apiname
        
        print("url",urlString)
        print("params", params)
        
        var headers: HTTPHeaders = [:]
        if defaults.object(forKey: "authKey") == nil{
            headers = [
                "authKey":"",
                "X-Requested-With":"XMLHttpRequest"
            ]
        }else{
            headers = [
                "authKey":defaults.object(forKey: "authKey") as! String,
                "X-Requested-With":"XMLHttpRequest"
            ]
        }
        
        print("Header: \(headers)")
        
        AF.request(urlString,method: HTTPMethod.post,parameters:params,headers: headers).validate().responseJSON { response in
            print(response)
            switch response.result {
            case .success(let resultData):
                if JSON(resultData)["otherError"].stringValue == "customerNotExist"   {
                    taskCallback(0,resultData as AnyObject)
                }else{
                    taskCallback(1,resultData as AnyObject)
                }
                break
            case .failure(let error):
                if !Connectivity.isConnectedToInternet(){
                    GlobalData.sharedInstance.dismissLoader()
                    currentView.view.isUserInteractionEnabled = true
                    let AC = UIAlertController(title: GlobalData.sharedInstance.language(key: "warning"), message: error.localizedDescription, preferredStyle: .alert)
                    let okBtn = UIAlertAction(title: GlobalData.sharedInstance.language(key: "retry"), style: .default, handler: {(_ action: UIAlertAction) -> Void in
                        taskCallback(2, "" as AnyObject)
                    })
                    let noBtn = UIAlertAction(title: GlobalData.sharedInstance.language(key: "cancel"), style: .destructive, handler: {(_ action: UIAlertAction) -> Void in
                    })
                    AC.addAction(okBtn)
                    AC.addAction(noBtn)
                    currentView.present(AC, animated: true, completion: { })
                }else{
                    let statusCode =  response.response?.statusCode
                    let errorCode:Int = error._code
                    
                    let datastring = NSString(data: response.data!, encoding: String.Encoding.utf8.rawValue)
                    print(datastring!)
                    
                    if  statusCode == 401{
                        
                        if let tokenValue = response.response?.allHeaderFields["token"] as? String {
                            
//                            let usernamePasswordMd5:String = (API_USER_NAME+":"+API_KEY).md5
//                            let authkey =  (usernamePasswordMd5+":"+tokenValue).md5
                            let usernamePasswordMd5:String = (API_USER_NAME+":"+API_KEY)
                            let authkey =  (usernamePasswordMd5+":"+tokenValue)
                            defaults.set(authkey, forKey: "authKey")
                            defaults.synchronize()
                            taskCallback(2, "" as AnyObject)
                        }
                    }else if errorCode != -999 && errorCode != -1005{
                        GlobalData.sharedInstance.dismissLoader()
                        currentView.view.isUserInteractionEnabled = true
                        
                        var message:String = self.getRespectiveName(statusCode: 0)
                        if let statusCode =  response.response?.statusCode{
                            message = self.getRespectiveName(statusCode: statusCode)
                        }
                        
                        
                        let AC = UIAlertController(title: GlobalData.sharedInstance.language(key: "warning"), message: message, preferredStyle: .alert)
                        let okBtn = UIAlertAction(title: GlobalData.sharedInstance.language(key: "retry"), style: .default, handler: {(_ action: UIAlertAction) -> Void in
                            taskCallback(2, "" as AnyObject)
                        })
                        let noBtn = UIAlertAction(title: GlobalData.sharedInstance.language(key: "cancel"), style: .destructive, handler: {(_ action: UIAlertAction) -> Void in
                        })
                        AC.addAction(okBtn)
                        AC.addAction(noBtn)
                        
                        
                        currentView.present(AC, animated: true, completion: {  })
                    }else if errorCode == -1005{
                        GlobalData.sharedInstance.dismissLoader()
                        taskCallback(2, "" as AnyObject)
                    }
                    /////////////////////////////////////////////
                }
                break
            }
        }
    }
    
    
    func callingHttpRequestWithoutView(params:Dictionary<String,Any>, apiname:String,taskCallback: @escaping (Int,
        AnyObject?) -> Void)  {
        let defaults = UserDefaults.standard
        let urlString  = HOST_NAME + apiname
        
        print("url",urlString)
        print("params", params)
        
        var headers: HTTPHeaders = [:]
        if defaults.object(forKey: "authKey") == nil{
            headers = [
                "authKey":"",
                "X-Requested-With":"XMLHttpRequest"
            ]
        }else{
            headers = [
                "authKey":defaults.object(forKey: "authKey") as! String,
                "X-Requested-With":"XMLHttpRequest"
            ]
        }
        
        print("Header: \(headers)")
        
        AF.request(urlString,method: HTTPMethod.post,parameters:params,headers: headers).validate().responseJSON { response in
            print(response)
            switch response.result {
            case .success(let resultData):
                if JSON(resultData)["otherError"].stringValue == "customerNotExist"   {
                    taskCallback(0,resultData as AnyObject)
                }else{
                    taskCallback(1,resultData as AnyObject)
                }
                break
            case .failure(let error):
                if !Connectivity.isConnectedToInternet(){
                    GlobalData.sharedInstance.dismissLoader()
                    
                }else{
                    let statusCode =  response.response?.statusCode
                    let errorCode:Int = error._code
                    
                    let datastring = NSString(data: response.data!, encoding: String.Encoding.utf8.rawValue)
                    print(datastring!)
                    
                    if  statusCode == 401{
                        
                        if let tokenValue = response.response?.allHeaderFields["token"] as? String {
                            
//                            let usernamePasswordMd5:String = (API_USER_NAME+":"+API_KEY).md5
//                            let authkey =  (usernamePasswordMd5+":"+tokenValue).md5
                            let usernamePasswordMd5:String = (API_USER_NAME+":"+API_KEY)
                            let authkey =  (usernamePasswordMd5+":"+tokenValue)
                            defaults.set(authkey, forKey: "authKey")
                            defaults.synchronize()
                            taskCallback(2, "" as AnyObject)
                        }
                    }else if errorCode != -999 && errorCode != -1005{
                        GlobalData.sharedInstance.dismissLoader()
                        
                        var message:String = self.getRespectiveName(statusCode: 0)
                        if let statusCode =  response.response?.statusCode{
                            message = self.getRespectiveName(statusCode: statusCode)
                        }
                        
                        print("Response Message: \(message)")

                    }else if errorCode == -1005{
                        GlobalData.sharedInstance.dismissLoader()
                        taskCallback(2, "" as AnyObject)
                    }
                    /////////////////////////////////////////////
                }
                break
            }
        }
    }
    
    func getRespectiveName(statusCode:Int?) -> String{
        var message:String = ""
        if statusCode == 404{
            message = "servererror".localized
        }else if statusCode == 500{
            message = "servernotfound".localized
        }else{
            message = "somethingwentwrongpleasetryagain".localized
        }
        return message
    }
    
    func removePreviousNetworkCall(){
        print("dismisstheconnection")
        let sessionManager = Alamofire.Session.default
        sessionManager.session.getTasksWithCompletionHandler { dataTasks, uploadTasks, downloadTasks in
            dataTasks.forEach { $0.cancel() }
            uploadTasks.forEach { $0.cancel() }
            downloadTasks.forEach { $0.cancel() }
        }
    }
    
}
