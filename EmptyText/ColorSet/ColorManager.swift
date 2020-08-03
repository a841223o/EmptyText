//
//  ColorManager.swift
//  EmptyText
//
//  Created by DongLunYou on 2020/7/29.
//  Copyright © 2020年 Leo. All rights reserved.
//

import Foundation
import Cocoa
class ColorManager {
    static let instance = ColorManager()
    
    var backgroundColor : NSColor {
        set{
            Defaults.instance.saveBackgroundColor(color: newValue)
        }
        get{
            return Defaults.instance.getBackgroundColor()
        }
    }
    var textColor : NSColor {
        set{
            Defaults.instance.saveTextColor(color: newValue)
        }
        get{
           return Defaults.instance.getTextColor()
        }
    }
    
    private init(){
        
    }
}
