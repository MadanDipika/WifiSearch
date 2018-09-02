//
//  SearchDetailViewController.swift
//  WikiSearch
//
//  Created by Dipika Madan on 02/09/18.
//  Copyright © 2018 Dipika Madan. All rights reserved.
//

import Foundation
import WebKit

class SearchDetailViewController: UIViewController, WKUIDelegate {
    
    @IBOutlet var webViewParent: UIView!
    @IBOutlet var progressView: UIProgressView!
    
    private var webView: WKWebView! = nil
    var url: URL? = nil
    
    override func viewDidLoad() {
        super.viewDidLoad()
    
        if let url = url{
            self.addWebView()
            webView.load(URLRequest(url: url))
        }
    }
    
    private func addWebView() {
        let webConfiguration = WKWebViewConfiguration()
        webView = WKWebView(frame: self.webViewParent.bounds, configuration: webConfiguration)
        webView.uiDelegate = self
        self.webViewParent.addSubview(webView)
        
        webView.addObserver(self, forKeyPath: #keyPath(WKWebView.estimatedProgress), options: .new, context: nil)
    }
    
    override func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?) {
        if keyPath == "estimatedProgress" {
            progressView.progress = Float(webView.estimatedProgress)
        }
        progressView.isHidden = progressView.progress == 1 ? true: false
    }
}
