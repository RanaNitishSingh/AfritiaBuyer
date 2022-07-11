//
/**
FashionHub
@Category Webkul
@author Webkul <support@webkul.com>
FileName: InvoiceViewController.swift
Copyright (c) 2010-2018 Webkul Software Private Limited (https://webkul.com)
@license https://store.webkul.com/license.html ASL Licence
@link https://store.webkul.com/license.html

*/


import UIKit

class InvoiceViewController: UIViewController {

    @IBOutlet weak var invoiceTblView: UITableView!
    var invoiceViewModel = InvoiceViewModel()
    var customerOrderDetailsModel:CustomerOrderDetailsViewModel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        invoiceTblView.register(InvoiceItemsTableViewCell.nib, forCellReuseIdentifier: InvoiceItemsTableViewCell.identifier)
        invoiceTblView.register(PricingTableViewCell.nib, forCellReuseIdentifier: PricingTableViewCell.identifier)
        
        invoiceTblView.rowHeight = UITableViewAutomaticDimension
        invoiceTblView.estimatedRowHeight = 200
        
        invoiceTblView.delegate = invoiceViewModel
        invoiceTblView.dataSource = invoiceViewModel
        invoiceViewModel.customerOrderDetailsModel = customerOrderDetailsModel
    }
    
    override func viewWillAppear(_ animated: Bool) {
        invoiceTblView.delegate = invoiceViewModel
        invoiceTblView.dataSource = invoiceViewModel
        invoiceViewModel.customerOrderDetailsModel = customerOrderDetailsModel
        self.invoiceTblView.reloadData()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}
