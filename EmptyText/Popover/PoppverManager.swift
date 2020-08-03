//
//  PoppverManager.swift
//  EmptyText
//
//  Created by DongLunYou on 2020/4/23.
//  Copyright © 2020年 Leo. All rights reserved.
//

import Foundation
import PopoverResize

class PopoverManager {
    static let instance = PopoverManager()
    
    let  popover : PopoverResize
    var  detachedWindow : NSWindow
    var  windowController : NSWindowController?
    var  popoverVC : PopoverViewController
    
    var  windowOldSize : CGSize = CGSize.init(width: 300, height: 450)
    
    private init() {
        popover = PopoverResize.init(min: NSSize.init(width: CGFloat(100), height: CGFloat(30)), max: NSSize.init(width: CGFloat(800), height: CGFloat(0)))
        
        popoverVC = PopoverViewController.freshController()
        let styleMask = NSWindow.StyleMask.titled.rawValue + NSWindow.StyleMask.closable.rawValue + NSWindow.StyleMask.resizable.rawValue
        let  rect = NSWindow.contentRect(forFrameRect: popoverVC.view.bounds, styleMask:.init(rawValue: styleMask))
        detachedWindow = NSWindow.init(contentRect: rect, styleMask:.init(rawValue: styleMask), backing: NSWindow.BackingStoreType.buffered, defer: true)
        detachedWindow.contentViewController = popoverVC
        detachedWindow.isReleasedWhenClosed = true
        popover.setContentViewController(popoverVC)
        popover.delegate = popoverVC
        
    }
    func setWindowAlpha(opacity:CGFloat){
        guard let controller = windowController else{
            return
        }
        if opacity < 1 {
            if popoverVC.opacityIsOpen {
              controller.window?.alphaValue = opacity
            }
        }else{
            controller.window?.alphaValue = opacity
        }
        
    }
    func getWindowAlpha()->CGFloat{
        guard let controller = windowController else{
            return 0
        }
        return (controller.window?.alphaValue)!
    }
    func windowResize(size:NSSize){
        guard let controller = windowController else{
            return
        }
        var windowFrame = controller.window?.frame
        let origin = windowFrame?.origin
        let deHeight = size.height - windowFrame!.height
        windowFrame?.size = size
        windowFrame?.origin = CGPoint.init(x: origin!.x, y: origin!.y - deHeight)
        windowController?.window?.setFrame(windowFrame!, display: true)
    }
    
    func windowSizeSmall(){
        guard let controller = windowController else{
            return
        }
        self.windowOldSize = controller.window?.frame.size ?? self.windowOldSize
        windowResize(
            size: NSSize.init(
                width: windowController!.window!.frame.width ,
                height: 30))
    }
    func windowSizeBig(){
        guard let window = windowController?.window else{
            return
        }
        windowResize(
            size: NSSize.init(
                width:  window.frame.width,
                height: windowOldSize.height
            )
        )
    }
    
    func showPopDetch(sender : Any?){
        let window = popoverVC.detachableWindow(for: popover)
        window?.titlebarAppearsTransparent = true
        window?.titleVisibility = .hidden
        window?.styleMask.insert(NSWindow.StyleMask.fullSizeContentView)
        window?.backgroundColor = ColorManager.instance.backgroundColor
        windowController = NSWindowController.init(window: window)
        windowController?.showWindow(sender)
        if window != nil {
            self.detachedWindow = window!
        }
        
    }
    
    func setWindowColor(){
        detachedWindow.backgroundColor = ColorManager.instance.backgroundColor
    }
    
    func closePopDetch(sender : Any?){
        windowController?.close()
        windowController = nil
    }
    
    func togglePopDetch(sender:Any?) {
        if windowController != nil {
            closePopDetch(sender: sender)
        } else {
            showPopDetch(sender: sender)
            NSApplication.shared.activate(ignoringOtherApps: true)
        }
    }
    
    
    func togglePopover(with view: NSView) {
        if popover.isShown {
            closePopover(with: view)
        } else {
            showPopover(with: view)
        }
    }
    
    func showPopover(with view : NSView) {
        popover.show(relativeTo:view.bounds, of: view, preferredEdge: NSRectEdge.minY)
    }
    
    func closePopover(with view: NSView) {
        popover.performClose(view)
    }
    func acquirePrivileges() -> Bool {
        let trusted = kAXTrustedCheckOptionPrompt.takeUnretainedValue()
        let privOptions = [trusted: true]
        let accessEnabled = AXIsProcessTrustedWithOptions(privOptions as CFDictionary)
        if accessEnabled != true {
            let alert = NSAlert()
            alert.messageText = "Enable Maxxxro"
            alert.informativeText = "Once you have enabled Maxxxro in System Preferences, click OK."
            alert.beginSheetModal(for: PopoverManager.instance.windowController!.window!) { (response) in
                //vvdNSApp.terminate(self)
            }
        }
        return accessEnabled == true
    }
    
    func notification(info:String){

        let delayBeforeDelivering: TimeInterval = 0.3
        let delayBeforeDismissing: TimeInterval = 2
        
        let notification = NSUserNotification()
        notification.title = "EmptyText"
        notification.subtitle = "Fast Past Success"
        notification.informativeText = info
        notification.soundName = NSUserNotificationDefaultSoundName
        notification.deliveryDate = NSDate(timeIntervalSinceNow: delayBeforeDelivering) as Date
        
        let notificationcenter = NSUserNotificationCenter.default
        
        notificationcenter.scheduleNotification(notification)
        
        notificationcenter.perform("removeDeliveredNotification:",
                                   with: notification,
                                           afterDelay: (delayBeforeDelivering + delayBeforeDismissing))
    }
    
    
    
    
}
