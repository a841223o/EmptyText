//
//  ViewController.swift
//  EmptyText
//
//  Created by DongLunYou on 2020/4/21.
//  Copyright © 2020年 Leo. All rights reserved.
//

import Cocoa

class ViewController: NSViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override var representedObject: Any? {
        didSet {
        // Update the view, if already loaded.
        }
    }


}


extension ViewController {
    static  func freshController() -> ViewController{
        let storyboard = NSStoryboard.init(name: "Main", bundle: nil)
        guard let vc = storyboard.instantiateController(withIdentifier: "ViewController") as? ViewController else {
            fatalError("some wrong")
        }
        return vc
    }
}
