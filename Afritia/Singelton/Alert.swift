//
//  Alert.swift
//  ScanQuo
//
//  Created by zeroit01 on 11/04/22.
//

import Foundation
import UIKit

class afritiaSingleton : NSObject{
    
    static let sharedInstance = afritiaSingleton()
    
    let appName = "Afritia"
    let deviceType = "iOS"
    
    func showAlert(title: String, msg: String, VC: UIViewController, cancel_action: Bool)
    {
        let alert = UIAlertController.init(title: title, message: msg, preferredStyle: .alert)
        let OK_action = UIAlertAction.init(title: "OK", style: .default)
        alert.addAction(OK_action)
        if cancel_action
        {
            let Cancel_action = UIAlertAction.init(title: "Cancel", style: .default)
            alert.addAction(Cancel_action)
        }
        VC.present(alert, animated: true, completion: nil)
    }    
    
    
    
   func alertUser(strTitle: String, strMessage: String) {
        let myAlert = UIAlertController(title: strTitle, message: strMessage, preferredStyle: UIAlertController.Style.alert)
        let okAction = UIAlertAction(title: "Ok", style: UIAlertAction.Style.default, handler: nil)
        myAlert.addAction(okAction)
        UIApplication.shared.delegate?.window??.rootViewController?.present(myAlert, animated: true, completion: nil)
    }
    
    
    
}


