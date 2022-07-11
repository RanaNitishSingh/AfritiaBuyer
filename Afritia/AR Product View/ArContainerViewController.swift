//
//  ArContainerViewController.swift
//  Getkart
//
//  Created by bhavuk.chawla on 15/10/18.
//  Copyright © 2018 kunal. All rights reserved.
//

import UIKit

class ArContainerViewController: UIViewController {

    var delegate: close?
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    @IBAction func crossTapped(_ sender: Any) {
        delegate?.close()
    }
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
