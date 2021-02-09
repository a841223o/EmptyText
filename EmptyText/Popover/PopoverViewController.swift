//
//  PopoverViewController.swift
//  EmptyText
//
//  Created by DongLunYou on 2020/4/21.
//  Copyright © 2020年 Leo. All rights reserved.
//

import Cocoa
import PopoverResize

class PopoverViewController: NSViewController {

    @IBOutlet weak var scrollerView: NSScrollView!
    @IBOutlet var thisView: NSView!
    @IBOutlet weak var upDownButton: NSButton!
    @IBOutlet var textView: NSTextView!
    @IBOutlet weak var alphaBtn: NSButton!
    @IBOutlet weak var toolbarView: NSView!
    @IBOutlet weak var textTageView: TextTagPointView!
    
    var opacityIsOpen  = false
    var textSize = NSFont.systemFontSize
    var colorSelectWC : NSWindowController!
    var area:NSTrackingArea!

    override func viewDidLoad() {
        super.viewDidLoad()
        textView.setFont(NSFont.userFont(ofSize: textSize)!, range: textView.markedRange())
        colorSelectWC =  storyboard?.instantiateController(withIdentifier: "showColorSelect") as? NSWindowController
        textView.delegate = self
        textView.insertText(Defaults.instance.getContent())
        setTextColor(color: ColorManager.instance.textColor)
        setTextViewBackgroundColor(color: ColorManager.instance.backgroundColor)
        scrollerView.scrollerStyle = .overlay
        scrollerView.verticalScroller?.alphaValue = 0
        btnSetThemeColor()
    }
    
    @IBAction func reszie(_ sender: NSButton) {
        if sender.state == .on {
            PopoverManager.instance.windowSizeSmall()
        }else{
            PopoverManager.instance.windowSizeBig()
        }
    }
    
    @IBAction func opacity(_ sender: NSButton) {
        
        if sender.state == .on {
            opacityIsOpen = true
            sender.image = #imageLiteral(resourceName: "opacity_open")
            PopoverManager.instance.setWindowAlpha(opacity: 0.5)
        }else{
            opacityIsOpen = false
            sender.image = #imageLiteral(resourceName: "opacity_open")
            PopoverManager.instance.setWindowAlpha(opacity: 1)
        }
        
    }
    
    func btnSetThemeColor(){
        upDownButton.wantsLayer = true
    }
    
    func windowsUpDownResize(){
        if upDownButton.state == .off {
            PopoverManager.instance.windowSizeSmall()
            upDownButton.state = .on
            NSApplication.shared.activate(ignoringOtherApps: false)
        }else{
            PopoverManager.instance.windowSizeBig()
            upDownButton.state = .off
            NSApplication.shared.activate(ignoringOtherApps: true)
        }
    }
    
    func increaseTextSize(){
        textSize = textSize+5
        textView.setFont(NSFont.userFont(ofSize: textSize)!, range: NSRange.init(location: 0, length: (textView.textStorage?.length)!))
    }
    func decreaseTextSize(){
        guard textSize > 18 else{
            return
        }
        textSize = textSize-5
        textView.setFont(NSFont.userFont(ofSize: textSize)!, range: NSRange.init(location: 0, length: (textView.textStorage?.length)!))
    }
    @IBAction func textSizeIncrease(_ sender: NSButton) {
        increaseTextSize()
    }
    @IBAction func textSizeDecrease(_ sender: NSButton) {
        decreaseTextSize()
    }
    @objc func scrollViewClick(){
        PopoverManager.instance.setWindowAlpha(opacity: 1)
    }
    func clipboardContent() -> String?
    {
        return NSPasteboard.general.pasteboardItems?.first?.string(forType: .string)
    }
    func textViewPasteText(_ text : String){
        textView.selectedRange = NSMakeRange(textView.string.count, 0);
        let location = textView.string.count
        if let str = clipboardContent() {
            textView.insertText("\n\n"+str, replacementRange: NSRange.init(location: location, length: 0))
            
            let info = str.split(separator: "\n")
            if info.count > 0 {
                PopoverManager.instance.notification(info: String(info[0]))
            }else{
                PopoverManager.instance.notification(info: text)
            }
        }
        scrollerView.documentView?.scroll(NSPoint.init(x: 0, y: (scrollerView.documentView?.bounds.height)!))
        textView.selectedRange = NSMakeRange(textView.string.count, 0);
    }
    @IBAction func colorSelect(_ sender: NSButton) {
        let frame = PopoverManager.instance.detachedWindow.frame
        colorSelectWC.window?.setFrame(NSRect.init(x: frame.origin.x+frame.width, y: frame.origin.y, width: frame.width, height: frame.height), display: false)

        self.colorSelectWC.showWindow(nil)
    }
    
    func setTextViewBackgroundColor(color:NSColor){
        textView.backgroundColor = color
    }
    
    func setTextColor(color:NSColor){
        textView.textColor = color
        textView.insertionPointColor  = color
    }
    
    func setupMouseEvent(){
        if area != nil { self.view.removeTrackingArea(area) }
        
        let opt = (
            NSTrackingArea.Options.mouseEnteredAndExited.rawValue |
                NSTrackingArea.Options.mouseMoved.rawValue |
                NSTrackingArea.Options.activeAlways.rawValue
        )
        
        area = NSTrackingArea.init(rect: self.view.bounds, options: NSTrackingArea.Options(rawValue: opt), owner: self, userInfo: nil)
        self.view.addTrackingArea(area)
        self.view.window?.acceptsMouseMovedEvents = true
    }
    
    override func mouseExited(with event: NSEvent) {
        NSAnimationContext.runAnimationGroup { (context) in
            context.duration = 1
            scrollerView.verticalScroller?.animator().alphaValue = 0
            toolbarView.animator().alphaValue = 0
        }
        
    }
    
    override func mouseEntered(with event: NSEvent) {
        NSAnimationContext.runAnimationGroup { (context) in
            context.duration = 1
            scrollerView.verticalScroller?.animator().alphaValue = 0.2
            toolbarView.animator().alphaValue = 1
        }
        
    }
    override func viewDidLayout() {
        setupMouseEvent()
    }
    
}



extension PopoverViewController : NSPopoverDelegate {
    static  func freshController() -> PopoverViewController{
        let storyboard = NSStoryboard.init(name: NSStoryboard.Name("Main"), bundle: nil)
        guard let vc = storyboard.instantiateController(withIdentifier: NSStoryboard.SceneIdentifier("PopoverViewController")) as? PopoverViewController else {
            fatalError("some wrong")
        }
        return vc
    }
    func popoverShouldDetach(_ popover: NSPopover) -> Bool {
        return true
    }
    func detachableWindow(for popover: NSPopover) -> NSWindow? {
        return PopoverManager.instance.detachedWindow
    }
    
}

extension PopoverViewController : NSTextViewDelegate{
    func textDidChange(_ notification: Notification) {
        Defaults.instance.saveContent(str: textView.string)
        textView.setFont(NSFont.userFont(ofSize: textSize)!, range: NSRange.init(location: 0, length: (textView.textStorage?.length)!))
    }
    
    func textView(_ textView: NSTextView, shouldChangeTextIn affectedCharRange: NSRange, replacementString: String?) -> Bool {
        guard replacementString != nil else { return true }
        
        let newLineSet = NSCharacterSet.newlines
        if replacementString == " " {
            textView.breakUndoCoalescing()
        }
        if let newLineRange = replacementString!.rangeOfCharacter(from: newLineSet) {
           textView.breakUndoCoalescing()
        }
        
        return true
    }
    
}
