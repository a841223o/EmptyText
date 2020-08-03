//
//  ColorSetViewController.swift
//  EmptyText
//
//  Created by DongLunYou on 2020/7/29.
//  Copyright © 2020年 Leo. All rights reserved.
//

import Cocoa

class ColorSetViewController: NSViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
    }
    @IBAction func colorChange(_ sender: NSColorWell) {
        ColorManager.instance.textColor = sender.color
        PopoverManager.instance.popoverVC.setTextColor(color: sender.color)
    }
    @IBAction func backgroundColorChange(_ sender: NSColorWell) {
        ColorManager.instance.backgroundColor = sender.color
        PopoverManager.instance.popoverVC.setTextViewBackgroundColor(color: sender.color)
        PopoverManager.instance.setWindowColor()
    }
    
    @IBAction func closeApp(_ sender: NSButton) {
        NSApplication.shared.terminate(self)
    }
}
