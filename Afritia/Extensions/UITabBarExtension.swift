//
//  UITabBarExtension.swift
//  Afritia
//
//  Created by Ranjit Mahto on 09/10/20.
//  Copyright © 2020 kunal. All rights reserved.
//

import Foundation
import UIKit

extension UITabBar {
    
    func applyAfritiaTheme() {
        
        self.tintColor = UIColor.white
        self.barTintColor = UIColor.DarkLavendar
        self.unselectedItemTintColor = UIColor.LightLavendar
        
        self.items?[0].title = nil
        self.items?[1].title = nil
        self.items?[2].title = nil
        self.items?[3].title = nil
        self.items?[4].title = nil
        
        if #available(iOS 13.0, *) {
            let appearance = UITabBarAppearance()
            appearance.configureWithOpaqueBackground()
            appearance.backgroundColor = UIColor.DarkLavendar
            
            let itemAppearance = UITabBarItemAppearance()
            itemAppearance.selected.iconColor = .white
            itemAppearance.normal.iconColor = .LightLavendar
            
            appearance.stackedLayoutAppearance = itemAppearance
            appearance.inlineLayoutAppearance = itemAppearance
            
            self.standardAppearance = appearance;
//            tabBar.unselectedItemTintColor = .LightLavendar
            if #available(iOS 15.0, *) {
                self.scrollEdgeAppearance = self.standardAppearance
            } else {
                // Fallback on earlier versions
            }
        }
//        guard let tabBarItem = tabBar.tabBarItem else { return }
//
//        tabBarItem.badgeValue = "123"
//        tabBarItem.badgeColor = UIColor.blue
    
    //guard let tabBar = self.tabBarController?.tabBar else { return }
        
    }
    
}
