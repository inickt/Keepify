//
//  ViewController.swift
//  Keepify
//
//  Created by Nick Thompson on 6/21/18.
//  Copyright © 2018 Nick Thompson. All rights reserved.
//

import AppKit
import WebKit

class ViewController: NSViewController {

    @IBOutlet weak var webView: CustomWebView!
    @IBOutlet weak var customView: CustomView!
    @IBOutlet weak var startTitleView: CustomView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.startTitleView.wantsLayer = true
        self.startTitleView.layer?.backgroundColor = #colorLiteral(red: 1, green: 0.7333333333, blue: 0, alpha: 1).usingColorSpace(.deviceRGB)?.cgColor
        
        self.view.window?.isMovableByWindowBackground = true

        self.webView.navigationDelegate = self
        self.webView.setValue(false, forKey: "drawsBackground")
        self.webView.load(URLRequest(url: URL(string: "https://keep.google.com/")!))
    }

    func injectCSS() {
        guard let cssURL = Bundle.main.url(forResource: "custom", withExtension: "css"),
            let css = try? String(contentsOf: cssURL) else {
                return
        }
        
        var js = "var style = document.createElement('style'); style.innerHTML = '\(css)'; document.head.appendChild(style);"
        
        js = js.replacingOccurrences(of: "\n", with: "")
        js = js.replacingOccurrences(of: "{", with: "\\{")
        js = js.replacingOccurrences(of: "}", with: "\\}")
        
        self.webView.evaluateJavaScript(js) { (_, error) in
            if let error = error {
                print(error)
            }
        }
    }
    
    override func viewDidLayout() {
        super.viewDidLayout()
        
        if let closeButton = view.window?.standardWindowButton(.closeButton) {
            let y = (64.0 / 2.0) - closeButton.bounds.height / 2.0
            closeButton.removeFromSuperview()
            closeButton.setFrameOrigin(NSPoint(x: 17, y: y))
            self.webView.addSubview(closeButton)
        }
        
        if let minButton = view.window?.standardWindowButton(.miniaturizeButton) {
            let y = (64.0 / 2.0) - minButton.bounds.height / 2.0
            minButton.removeFromSuperview()
            minButton.setFrameOrigin(NSPoint(x: 37, y: y))
            self.webView.addSubview(minButton)
        }
        
        if let zoomButton = view.window?.standardWindowButton(.zoomButton) {
            let y = (64.0 / 2.0) - zoomButton.bounds.height / 2.0
            zoomButton.removeFromSuperview()
            zoomButton.setFrameOrigin(NSPoint(x: 57, y: y))
            self.webView.addSubview(zoomButton)
        }
    }
}

extension ViewController: WKNavigationDelegate, WKUIDelegate {
    
    func webView(_ webView: WKWebView, didFail navigation: WKNavigation!, withError error: Error) {
        print(error)
        print(navigation)
    }
    
    func webView(_ webView: WKWebView, didCommit navigation: WKNavigation!) {
        guard webView.url?.host == "keep.google.com" else { return }

        self.injectCSS()
    }

    func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
        guard webView.url?.host == "keep.google.com" else { return }
        
        self.injectCSS()
    }
    
    func webView(_ webView: WKWebView, decidePolicyFor navigationAction: WKNavigationAction, decisionHandler: @escaping (WKNavigationActionPolicy) -> Void) {
        if navigationAction.navigationType == .linkActivated,
            let url = navigationAction.request.url,
            url.host != "keep.google.com",
            url.host != "accounts.google.com" {
            decisionHandler(.cancel)
            NSWorkspace.shared.open(url)
        } else {
            decisionHandler(.allow)
        }
    }
}
