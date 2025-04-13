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
    let completionHandler: ((_ result: Any?, _ error: Any?) -> Void)?
    
    func makeUIView(context: Context) -> WKWebView {
        let config = WKWebViewConfiguration()
        config.websiteDataStore = WKWebsiteDataStore.nonPersistent()
        
        let webView = WKWebView(frame: .zero, configuration: config)
        webView.isHidden = true
        
        return webView
    }
    
    func updateUIView(_ uiView: WKWebView, context: Context) {
        let blankPage = "<!DOCTYPE html><html><body></body></html>"
        uiView.loadHTMLString(blankPage, baseURL: nil)
        
        print("Starting JavaScript evaluation:\n\(javascriptString)")
        
        uiView.evaluateJavaScript(javascriptString) { result, error in
            print("JavaScript evaluation completed")
            if let completionHandler = completionHandler {
                completionHandler(result, error)
            }
        }
    }
}

