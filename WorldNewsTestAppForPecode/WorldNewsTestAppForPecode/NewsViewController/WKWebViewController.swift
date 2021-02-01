//
//  WKWebViewController.swift
//  WorldNewsTestAppForPecode
//
//  Created by Anton on 31.01.2021.
//

import UIKit
import WebKit

class WKWebViewController: UIViewController, WKNavigationDelegate {

    private var webView: WKWebView!
    var url: URL?
    
    override func loadView() {
        webView = WKWebView()
        webView.navigationDelegate = self
        view = webView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        webView.load(URLRequest(url: url!))
        webView.allowsBackForwardNavigationGestures = true
    }
}
