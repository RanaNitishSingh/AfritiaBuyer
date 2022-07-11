//
/**
Getkart
@Category Webkul
@author Webkul <support@webkul.com>
FileName: AllStoryBoard.swift
Copyright (c) 2010-2018 Webkul Software Private Limited (https://webkul.com)
@license https://store.webkul.com/license.html ASL Licence
@link https://store.webkul.com/license.html

*/


import Foundation
import UIKit

enum AppStoryboard: String {
    case Main
    case Marketplace
    case Checkout
    
    var instance: UIStoryboard {
        return UIStoryboard(name: self.rawValue, bundle: Bundle.main)
    }
    
    func initialViewController() -> UIViewController? {
        return instance.instantiateInitialViewController()
    }
    
//    func viewController<T: UIViewController>(viewControllerClass: T.Type, function: String = #function, line: Int = #line, file: String = #file) -> T {
//        let storyboardID = (viewControllerClass as UIViewController.Type).storyboardID
//
//        guard let scene = instance.instantiateViewController(withIdentifier: storyboardID) as? T else {
//            fatalError("ViewController with identifier \(storyboardID), not found in \(self.rawValue) Storyboard.\nFile : \(file) \nLine Number : \(line) \nFunction : \(function)")
//        }
//        return scene
//    }
    
    
}
