//
//  OrderPlaced.swift
//  Mobikul
//
//  Created by Webkul on 14/01/17.
//  Copyright © 2017 Webkul. All rights reserved.
//

import UIKit

class OrderPlaced: UIViewController {
    
    @IBOutlet weak var mainView: UIView!
    @IBOutlet weak var mainHeading: UILabel!
    @IBOutlet weak var thankforyourpurchase: UILabel!
    @IBOutlet weak var orderLabel: UILabel!
    @IBOutlet weak var orderContinueButton: UIButton!
    @IBOutlet weak var confirmmessageLabel: UILabel!
    
    public var incrementId:String!
    public var bottomButton :Int!
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        
        self.tabBarController?.tabBar.isHidden = true
        self.navigationItem.setHidesBackButton(true, animated:true);
        self.title = GlobalData.sharedInstance.language(key:"orderplaced")
        
        mainHeading.text = GlobalData.sharedInstance.language(key:"orderreceived")
        
        orderLabel.text = GlobalData.sharedInstance.language(key: "orderid")+incrementId
        orderLabel.textColor = UIColor.black
        orderLabel.addTapGestureRecognizer {
            self.orderDetails()
        }
        
        thankforyourpurchase.text = GlobalData.sharedInstance.language(key:"thankuforpurchase")
        confirmmessageLabel.text = GlobalData.sharedInstance.language (key:"confirmationmessage")
        
        orderContinueButton.setTitle(GlobalData.sharedInstance.language(key:"continue"), for: .normal)
        orderContinueButton.applyAfritiaTheme()
        
        /*
        let openOrderDetailsGesture = UITapGestureRecognizer(target: self, action: #selector(self.orderDetails))
        openOrderDetailsGesture.numberOfTapsRequired = 1
        orderLabel.addGestureRecognizer(openOrderDetailsGesture)
         */
        
        
        UserDefaults.standard.removeObject(forKey: "quoteId")
        UserDefaults.standard.synchronize()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(true)
        navigationItem.backBarButtonItem = UIBarButtonItem(title: " ", style: .plain, target: nil, action: nil)
    }
    
    //MARK:- Actions
    
    @IBAction func continueOrder(_ sender: Any) {
        GlobalVariables.proceedToCheckOut = true
        self.dismiss(animated: true, completion: nil)
    }
    
    //MARK:- Gestures
    
    @objc func orderDetails() {
        let vc = self.storyboard?.instantiateViewController(withIdentifier: "CustomerOrderMainViewController") as! CustomerOrderMainViewController
        vc.incrementId = incrementId
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    /*
    @objc func orderDetails(_ recognizer: UITapGestureRecognizer) {
        let vc = self.storyboard?.instantiateViewController(withIdentifier: "CustomerOrderMainViewController") as! CustomerOrderMainViewController
        vc.incrementId = incrementId
        self.navigationController?.pushViewController(vc, animated: true)
    }*/
    
    //MARK:- Segue
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if (segue.identifier! == "customerOrderDetailsSegue") {
            let viewController:CustomerOrderDetails = segue.destination as UIViewController as! CustomerOrderDetails
            viewController.incrementId = incrementId
        }
    }
}
