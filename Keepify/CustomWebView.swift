//
//  CustomWebView.swift
//  Keepify
//
//  Created by Nick Thompson on 6/21/18.
//  Copyright © 2018 Nick Thompson. All rights reserved.
//

import Cocoa
import WebKit

class CustomWebView: WKWebView {
    
    override var isOpaque: Bool {
        return false
    }
}
