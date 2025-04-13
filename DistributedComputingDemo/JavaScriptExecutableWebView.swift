//
//  WebView.swift
//  DistributedComputingDemo
//
//  Created by Brendan Chen on 2025.04.12.
//

import SwiftUI
import WebKit

struct JavaScriptExecutableWebView: UIViewRepresentable {
    let javascriptString: String
    
    func makeUIView(context: Context) -> WKWebView {
        let config = WKWebViewConfiguration()
        config.websiteDataStore = WKWebsiteDataStore.nonPersistent()
        
        let webView = WKWebView(frame: .zero, configuration: config)
        
        return webView
    }
    
    func updateUIView(_ uiView: WKWebView, context: Context) {
        let blankPage = "<!DOCTYPE html><html><body></body></html>"
        uiView.loadHTMLString(blankPage, baseURL: nil)
    }
}

