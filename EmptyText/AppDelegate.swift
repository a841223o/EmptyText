//
//  AppDelegate.swift
//  EmptyText
//
//  Created by DongLunYou on 2020/4/21.
//  Copyright © 2020年 Leo. All rights reserved.
//

import Cocoa
import PopoverResize
import HotKey
@NSApplicationMain
class AppDelegate: NSObject, NSApplicationDelegate {

    let statusItem = NSStatusBar.system.statusItem(withLength: NSStatusItem.squareLength)
    var eventMonitor: EventMonitor?
    var keyEventMonitor :EventMonitor?
    var hotKey : HotKey?
    func applicationDidFinishLaunching(_ aNotification: Notification) {
        
        if let button = statusItem.button {
            button.image = NSImage(named: "statusIcon")
            button.action = #selector(toggle(_:))
        }
        HotKeyManager.instance.setupHandle()
    }
    

    func applicationWillTerminate(_ aNotification: Notification) {
        // Insert code here to tear down your application
    }

    
    @objc func toggle(_ sender : Any?){
        if let button = statusItem.button {
            PopoverManager.instance.togglePopDetch(sender: sender)
        }
    }

}

