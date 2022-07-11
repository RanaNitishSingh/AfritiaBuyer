//
//  ShippingMethodController.swift
//  Magento2V4Theme
//
//  Created by Webkul on 20/02/18.
//  Copyright © 2018 Webkul. All rights reserved.
//

import UIKit

class ShippingMethodController: UIViewController,UITableViewDelegate, UITableViewDataSource {
    
    @IBOutlet weak var addressImageView: UIImageView!
    @IBOutlet weak var addressLabel: UILabel!
    @IBOutlet weak var shipmentImageView: UIImageView!
    @IBOutlet weak var shippingLabel: UILabel!
    @IBOutlet weak var paymentImageView: UIImageView!
    @IBOutlet weak var paymentLabel: UILabel!
    @IBOutlet weak var summaryImageView: UIImageView!
    @IBOutlet weak var summaryLabel: UILabel!
    @IBOutlet weak var shippingtableView: UITableView!
    
    @IBOutlet weak var lblLineAdressRight: UILabel!
    @IBOutlet weak var lblLineShippingLeft: UILabel!
    @IBOutlet weak var lblLineShippingRight: UILabel!
    @IBOutlet weak var lblLinePaymentLeft: UILabel!
    @IBOutlet weak var lblLinePaymentRight: UILabel!
    @IBOutlet weak var lblLineSummaryLeft: UILabel!
    
    @IBOutlet weak var continueButton: UIButton!
    @IBOutlet weak var cancelButton: UIBarButtonItem!
    var shipmentPaymentMethodViewModel:ShipmentAndPaymentViewModel!
    var shippingId:String = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        addressImageView.backgroundColor = UIColor.DarkLavendar
        addressImageView.layer.cornerRadius = 4
        addressImageView.layer.masksToBounds = true
        
        shipmentImageView.backgroundColor = UIColor.DarkLavendar
        
        shipmentImageView.layer.cornerRadius = 4
        shipmentImageView.layer.masksToBounds = true
        
        paymentImageView.layer.cornerRadius = 4
        paymentImageView.layer.masksToBounds = true
        
        summaryImageView.layer.cornerRadius = 4
        summaryImageView.layer.masksToBounds = true
        
        self.lblLineAdressRight.backgroundColor = UIColor.DarkLavendar
        self.lblLineShippingLeft.backgroundColor = UIColor.DarkLavendar
        self.lblLineShippingRight.backgroundColor = UIColor.Magnesium
        self.lblLinePaymentLeft.backgroundColor = UIColor.Magnesium
        self.lblLinePaymentRight.backgroundColor = UIColor.Magnesium
        self.lblLineSummaryLeft.backgroundColor = UIColor.Magnesium
        
        //continueButton.backgroundColor = UIColor.button
        //continueButton.setTitleColor(UIColor.white, for: .normal)
        continueButton.setTitle("continue".localized, for: .normal)
        continueButton.applyAfritiaTheme()
        
        shippingtableView.register(UINib(nibName: "PaymentTableViewCell", bundle: nil), forCellReuseIdentifier: "PaymentTableViewCell")
        shippingtableView.rowHeight = UITableViewAutomaticDimension
        self.shippingtableView.estimatedRowHeight = 50
        shippingtableView.separatorColor = UIColor.clear
        
        addressLabel.text = "address".localized
        shippingLabel.text = "shipping".localized
        paymentLabel.text = "payment".localized
        summaryLabel.text = "summary".localized
        cancelButton.title = "cancel".localized
    }
    
    override func viewWillAppear(_ animated: Bool) {
        
        self.navigationController?.isNavigationBarHidden = false
        self.navigationController?.navigationBar.applyAfritiaTheme()
        self.title =  "shipping".localized
        
        let billingNavigationController = self.tabBarController?.viewControllers?[0]
        let nav = billingNavigationController as! UINavigationController
        let billingViewController = nav.viewControllers[0] as! ShippingAddressViewController
        self.shipmentPaymentMethodViewModel = billingViewController.shipmentPaymentMethodViewModel
        if GlobalVariables.CurrentIndex == 2{
            self.shippingtableView.dataSource = self
            self.shippingtableView.delegate = self
            self.shippingtableView.reloadData()
        }
    }
    
    @IBAction func cancelBarBtnClicked(_ sender: UIBarButtonItem) {
        self.dismiss(animated: true)
    }
    
    @IBAction func goToshippingAddress(_ sender: UITapGestureRecognizer) {
        self.tabBarController!.selectedIndex = 0
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return self.shipmentPaymentMethodViewModel.shipmentData.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int{
        return self.shipmentPaymentMethodViewModel.shipmentData[section].shipmentContentArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell:PaymentTableViewCell = tableView.dequeueReusableCell(withIdentifier: "PaymentTableViewCell") as! PaymentTableViewCell
        cell.methodDescription.text = self.shipmentPaymentMethodViewModel.shipmentData[indexPath.section].shipmentContentArray[indexPath.row].label+" "+self.shipmentPaymentMethodViewModel.shipmentData[indexPath.section].shipmentContentArray[indexPath.row].price
        
        if shippingId == self.shipmentPaymentMethodViewModel.shipmentData[indexPath.section].shipmentContentArray[indexPath.row].code{
            cell.roundImageView.backgroundColor = UIColor.button
        }else{
            cell.roundImageView.backgroundColor = UIColor.white
        }
        
        if self.shipmentPaymentMethodViewModel.shipmentData[indexPath.section].shipmentContentArray[indexPath.row].error != "" {
            cell.methodDescription.text = cell.methodDescription.text! + "\n" + self.shipmentPaymentMethodViewModel.shipmentData[indexPath.section].shipmentContentArray[indexPath.row].error
            cell.roundImageView.isHidden = true
        } else {
            cell.roundImageView.isHidden = false
        }
        
        cell.selectionStyle = .none
        return cell
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return self.shipmentPaymentMethodViewModel.shipmentData[section].title
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        if self.shipmentPaymentMethodViewModel.shipmentData[indexPath.section].shipmentContentArray[indexPath.row].error != "" {
            AlertManager.shared.showErrorSnackBar(msg: self.shipmentPaymentMethodViewModel.shipmentData[indexPath.section].shipmentContentArray[indexPath.row].error)
        } else {
            shippingId = self.shipmentPaymentMethodViewModel.shipmentData[indexPath.section].shipmentContentArray[indexPath.row].code
        }
        
        self.shippingtableView.reloadData()
    }
    
    @IBAction func continueClick(_ sender: Any) {
        if shippingId == ""{
            AlertManager.shared.showErrorSnackBar(msg: GlobalData.sharedInstance.language(key: "pleaseselectshippingmethod"))
        }else {
            GlobalVariables.CurrentIndex = 3
            self.tabBarController!.selectedIndex = 2
        }
    }
}
