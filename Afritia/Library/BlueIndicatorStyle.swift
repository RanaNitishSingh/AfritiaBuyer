//
//  BlueIndicatorStyle.swift
//  GradientCircularProgress
//
//  Created by keygx on 2015/08/31.
//  Copyright (c) 2015年 keygx. All rights reserved.
//

import UIKit


public struct BlueIndicatorStyle: StyleProperty {
    // Progress Size
    public var progressSize: CGFloat = 44
    
    // Gradient Circular
    public var arcLineWidth: CGFloat = 6.0
    public var startArcColor: UIColor = UIColor.LightLavendar
    public var endArcColor: UIColor = UIColor.DarkLavendar
    
    // Base Circular
    public var baseLineWidth: CGFloat? = 4.0
    public var baseArcColor: UIColor? = UIColor.DarkLavendar
    
    // Ratio
    public var ratioLabelFont: UIFont? = nil
    public var ratioLabelFontColor: UIColor? = nil
    
    // Message
    public var messageLabelFont: UIFont? = nil
    public var messageLabelFontColor: UIColor? = nil
    
    // Background
    public var backgroundStyle: BackgroundStyles = .none
    
    // Dismiss
    public var dismissTimeInterval: Double? = nil // 'nil' for default setting.
    
    public init() {}
}
