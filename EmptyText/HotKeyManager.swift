//
//  HotKeyManager.swift
//  EmptyText
//
//  Created by DongLunYou on 2020/4/30.
//  Copyright © 2020年 Leo. All rights reserved.
//

import Foundation
import HotKey

enum HotKeyEnum {
    case increaseText
    case decreaseText
    case windowUpDown
    case windowOpenClose
    case fastCopy
    case alpha
    case undo
}

class HotKeyManager {
    static let instance = HotKeyManager()
    var hotKeys = [HotKeyEnum:HotKey]()
    private init() {
        hotKeys[.increaseText] = HotKey.init(key: .equal , modifiers: [.command])
        hotKeys[.decreaseText] = HotKey.init(key: .minus , modifiers: [.command])
        hotKeys[.windowUpDown] = HotKey.init(key: .d , modifiers: [.command])
        hotKeys[.windowOpenClose] = HotKey.init(key: .e , modifiers: [.command])
        hotKeys[.fastCopy] = HotKey.init(key: .c, modifiers: [.command , .shift])
        hotKeys[.alpha] = HotKey.init(key: .o, modifiers: [.command])
        //hotKeys[.undo] = HotKey.init(key: .z, modifiers: [.command])
    }
    func setupHandle(){
        
        for hotkey in hotKeys {
            switch hotkey.key {
            case .increaseText:
                hotkey.value.keyDownHandler  = {
                    PopoverManager.instance.popoverVC.increaseTextSize()
                }
            case .decreaseText:
                hotkey.value.keyDownHandler  = { PopoverManager.instance.popoverVC.decreaseTextSize()}
            case .windowUpDown:
                hotkey.value.keyDownHandler = {
                    PopoverManager.instance.popoverVC.windowsUpDownResize()
                }
            case .windowOpenClose:
                hotkey.value.keyDownHandler = {
                    PopoverManager.instance.togglePopDetch(sender: nil)
                }
            case .fastCopy:
                hotkey.value.keyDownHandler = {
                     PopoverManager.instance.popoverVC.textViewPasteText("")
                }
            case .alpha:
                hotkey.value.keyDownHandler = {
                    if PopoverManager.instance.popoverVC.alphaBtn.state == .on{
                        PopoverManager.instance.popoverVC.alphaBtn.state = .off
                    }else{
                        PopoverManager.instance.popoverVC.alphaBtn.state = .on
                    }
                    PopoverManager.instance.popoverVC.opacity(PopoverManager.instance.popoverVC.alphaBtn)
                }
            case .undo :
                PopoverManager.instance.popoverVC.view.window?.firstResponder?.undoManager?.undo()
            }
            
        }
    }
}
