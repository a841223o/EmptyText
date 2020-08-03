//
//  Defaults.swift
//  EmptyText
//
//  Created by DongLunYou on 2020/7/29.
//  Copyright © 2020年 Leo. All rights reserved.
//

import Foundation
import Cocoa

class Defaults {
    private let userDefaults = UserDefaults.standard
    static let instance = Defaults()
    private init(){}
    
    func saveContent(str:String){
        userDefaults.set(str, forKey: "Content")
    }
    
    func getContent()->String{
        return userDefaults.string(forKey: "Content") ?? ""
    }
    
    func saveTextColor(color:NSColor){
        let data : Data = NSKeyedArchiver.archivedData(withRootObject: color)
        userDefaults.set(data, forKey: "TextColor")
        userDefaults.synchronize()
    }
    func getTextColor()->NSColor{
        if let userSelectedColorData = userDefaults.object(forKey: "TextColor") as? NSData {
            if let userSelectedColor = NSKeyedUnarchiver.unarchiveObject(with: userSelectedColorData as Data ) as? NSColor {
                return userSelectedColor
            }
        }
        return NSColor.init(calibratedRed: 0, green: 0, blue: 0, alpha: 1)
    }
    
    func saveBackgroundColor(color:NSColor){
        let data : Data = NSKeyedArchiver.archivedData(withRootObject: color)
        userDefaults.set(data, forKey: "BackgroundColor")
        userDefaults.synchronize()
        
    }
    func getBackgroundColor()->NSColor{
        if let userSelectedColorData = userDefaults.object(forKey: "BackgroundColor") as? NSData {
            if let userSelectedColor = NSKeyedUnarchiver.unarchiveObject(with: userSelectedColorData as Data ) as? NSColor {
                return userSelectedColor
            }
        }
        return NSColor.init(calibratedRed: 1, green: 1, blue: 1, alpha: 1)
    }
    
}
