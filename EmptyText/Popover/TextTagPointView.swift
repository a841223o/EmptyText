//
//  TextTagPointView.swift
//  EmptyText
//
//  Created by DongLunYou on 2020/8/13.
//  Copyright © 2020年 Leo. All rights reserved.
//

import Foundation
import Cocoa

class TextTagPointView :NSView {
    var tags : [TagModel] = []
    var totalLine : Int = 20
    var lineHeight: Int = 10
    
    override init(frame frameRect: NSRect) {
        super.init(frame: frameRect)
    
        tags.append(TagModel.init(startLine: 15, endLine: 20))
        self.layer?.backgroundColor = NSColor.red.cgColor
    }
    
    required init?(coder decoder: NSCoder) {
        super.init(coder: decoder)
        //self.wantsLayer = true
        //self.layer?.backgroundColor = NSColor.red.cgColor
    }
    func drawLine(start:Int , end:Int ){
        
    }
    override func draw(_ dirtyRect: NSRect) {
        NSColor.red.set() // choose color
        let figure = NSBezierPath() // container for line(s)
        figure.move(to: NSMakePoint(0, 100)) // start point
        figure.line(to: NSMakePoint(50, 100)) // destination
        
        figure.move(to: NSMakePoint(0, 40)) // start point
        figure.line(to: NSMakePoint(20, 40))
        

        figure.lineWidth = 5  // hair line
        figure.stroke()
    }
    
    
}
