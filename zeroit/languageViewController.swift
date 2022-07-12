//
//  languageViewController.swift
//  Afritia
//
//  Created by ZIT-12 on 12/07/22.
//  Copyright © 2022 kunal. All rights reserved.
//

import UIKit

class languageViewController: UIViewController {  
    
    @IBOutlet weak var englishSwitchBtn: UISwitch!
    
    @IBOutlet weak var chineseSwitchBtn: UISwitch!
  
    
    @IBOutlet weak var spanishSwitchBtn: UISwitch!
    
    
    
    @IBOutlet weak var arabicSwitchBtn: UISwitch!
    var show = Bool()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        if L102Language.currentAppleLanguage() == "ar" { self.arabicSwitchBtn.isOn = false
            arabicSwitchBtn.setOn(false, animated: true)
        }else if L102Language.currentAppleLanguage() == "es" {
            self.spanishSwitchBtn.isOn = false
            spanishSwitchBtn.setOn(false, animated: true)
        }else if L102Language.currentAppleLanguage() == "en" {
            self.englishSwitchBtn.isOn = false
            englishSwitchBtn.setOn(false, animated: true)
        }else if L102Language.currentAppleLanguage() == "zh" {
            self.chineseSwitchBtn.isOn = false
            chineseSwitchBtn.setOn(false, animated: true)
        }
        
        
    }
    
    @IBAction func engSwitchAction(_ sender: UISwitch) {
        
        var transition: UIView.AnimationOptions = .transitionFlipFromLeft
        print("en")
        L102Language.setAppleLAnguageTo(lang: "en")
        transition = .transitionFlipFromRight
        UserDefaults.standard.set(false, forKey: "switch")
        UserDefaults.standard.set("en", forKey: "CurrentLanguage")
        UIView.appearance().semanticContentAttribute = .forceLeftToRight
        Bundle.setLanguage("en")
        LocalizationSystem.sharedInstance.setLanguage(languageCode: "en")
        englishSwitchBtn.isOn = true
        englishSwitchBtn.setOn(true, animated: true)
        sender.isOn = true
        let  mainStory = UIStoryboard(name: "Main", bundle: nil)
        let search = mainStory.instantiateViewController(withIdentifier: "HomeViewController") as! HomeViewController
        UIView.beginAnimations("animation", context: nil)
        UIView.setAnimationDuration(1.0)
        self.navigationController?.pushViewController(search, animated: false)
        UIView.setAnimationTransition(UIView.AnimationTransition.flipFromRight, for: self.navigationController!.view, cache: false)
        UIView.commitAnimations()         
        
    }
    
    @IBAction func chineseSwitchBtn(_ sender: UISwitch) {
        
        var transition: UIView.AnimationOptions = .transitionFlipFromLeft
        print("zh")
        L102Language.setAppleLAnguageTo(lang: "zh")
        transition = .transitionFlipFromRight
        UserDefaults.standard.set(false, forKey: "switch")
        UserDefaults.standard.set("en", forKey: "CurrentLanguage")
        UIView.appearance().semanticContentAttribute = .forceLeftToRight
        Bundle.setLanguage("en")
        LocalizationSystem.sharedInstance.setLanguage(languageCode: "en")
        chineseSwitchBtn.isOn = true
        chineseSwitchBtn.setOn(true, animated: true)
        sender.isOn = true
        let  mainStory = UIStoryboard(name: "Main", bundle: nil)
        let search = mainStory.instantiateViewController(withIdentifier: "HomeViewController") as! HomeViewController
        UIView.beginAnimations("animation", context: nil)
        UIView.setAnimationDuration(1.0)
        self.navigationController?.pushViewController(search, animated: false)
        UIView.setAnimationTransition(UIView.AnimationTransition.flipFromRight, for: self.navigationController!.view, cache: false)
        UIView.commitAnimations()
    }
    
    @IBAction func spanishSwitchBtn(_ sender: UISwitch) {
        
        var transition: UIView.AnimationOptions = .transitionFlipFromLeft
        print("es")
        L102Language.setAppleLAnguageTo(lang: "es")
        transition = .transitionFlipFromRight
        UserDefaults.standard.set(false, forKey: "switch")
        UserDefaults.standard.set("en", forKey: "CurrentLanguage")
        UIView.appearance().semanticContentAttribute = .forceLeftToRight
        Bundle.setLanguage("en")
        LocalizationSystem.sharedInstance.setLanguage(languageCode: "en")
        spanishSwitchBtn.isOn = true
        spanishSwitchBtn.setOn(true, animated: true)
        sender.isOn = true
        let  mainStory = UIStoryboard(name: "Main", bundle: nil)
        let search = mainStory.instantiateViewController(withIdentifier: "HomeViewController") as! HomeViewController
        UIView.beginAnimations("animation", context: nil)
        UIView.setAnimationDuration(1.0)
        self.navigationController?.pushViewController(search, animated: false)
        UIView.setAnimationTransition(UIView.AnimationTransition.flipFromRight, for: self.navigationController!.view, cache: false)
        UIView.commitAnimations()
        
        
    }
    
    
    @IBAction func arabicSwitchBtn(_ sender: UISwitch) {
        
        if L102Language.currentAppleLanguage() == "en" {
            L102Language.setAppleLAnguageTo(lang: "ar")
            UserDefaults.standard.set(true, forKey: "switch")
            UserDefaults.standard.set("ar", forKey: "CurrentLanguage")
            UIView.appearance().semanticContentAttribute = .forceRightToLeft
            Bundle.setLanguage("ar");
            LocalizationSystem.sharedInstance.setLanguage(languageCode: "ar")
            print("english")
            show = false
            arabicSwitchBtn.isOn = true
            arabicSwitchBtn.setOn(true, animated: true)
            sender.isOn = true
            let  mainStory = UIStoryboard(name: "Main", bundle: nil)
            let search = mainStory.instantiateViewController(withIdentifier: "HomeViewController") as! HomeViewController
            UIView.beginAnimations("animation", context: nil)
            UIView.setAnimationDuration(1.0)
            self.navigationController?.pushViewController(search, animated: false)
            UIView.setAnimationTransition(UIView.AnimationTransition.flipFromLeft, for: self.navigationController!.view, cache: false)
            UIView.commitAnimations()
        }
        
    }
    
    
    
    
    
    
}
