//
//  AnimatedLauncherVC.swift
//  Afritia
//
//  Created by Ranjit Mahto on 08/12/20.
//  Copyright © 2020 kunal. All rights reserved.
//

import UIKit

class AnimatedLauncherVC: UIViewController {
    
    
    @IBOutlet weak var logoview : UIImageView!

    override func viewDidLoad() {
        super.viewDidLoad()
        self.beginAnimation()
        // Do any additional setup after loading the view.
    }
    

    func beginAnimation () {
//        //=============================================
//        // Version 1: Pulsate 3x
//        //=============================================
//        let scaleAnimation:CABasicAnimation = CABasicAnimation(keyPath: "transform.scale")
//        scaleAnimation.duration = 1.0
//        scaleAnimation.repeatCount = 3.0
//        scaleAnimation.autoreverses = true
//        scaleAnimation.fromValue = 1.0;
//        scaleAnimation.toValue = 1.2;
//        self.uiViewToPulsate.layer.addAnimation(scaleAnimation, forKey: "scale")

//        //=============================================
//        // Version 2: To Pulse Forever
//        //=============================================
//        UIView.animateWithDuration(1.0, delay:0, options: [.Repeat, .Autoreverse], animations: {
//            self.uiViewToPulsate.transform = CGAffineTransformMakeScale(1.2, 1.2)
//        }, completion: nil)
        
//        //=============================================
//        // Version 2: Pulsate 3x
//        //=============================================
        UIView.animate(withDuration: 0.75, delay:0, options: [.repeat, .autoreverse], animations: {
            //UIView.setAnimationRepeatCount(3)
            self.logoview.transform = CGAffineTransform(scaleX: 1.2, y: 1.2)
            
            }, completion: {completion in
                self.logoview.transform = CGAffineTransform(scaleX: 1, y: 1)
        })
        
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
