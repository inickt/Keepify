//
//  CustomView.swift
//  Keepify
//
//  Created by Nick Thompson on 6/21/18.
//  Copyright © 2018 Nick Thompson. All rights reserved.
//

import Cocoa

class CustomView: NSView {
    
    override var mouseDownCanMoveWindow: Bool {
        return true
    }
    
    override func mouseDown(with event: NSEvent) {
        super.mouseDown(with: event)
        self.window?.performDrag(with: event)
    }
    
}
