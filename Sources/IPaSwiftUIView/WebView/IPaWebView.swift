//
//  IPaWebView.swift
//  IPaSwiftUIView
//
//  Created by IPa Chen on 2020/10/26.
//

import SwiftUI
import WebKit
import IPaLog
import Combine
public struct IPaWebView: UIViewRepresentable {
    public typealias UIViewType = IPaWKWebView
    
    var request:IPaURLRequest? = nil
    var isScrollEnabled:Bool = true
    @Binding var contentHeight:CGFloat
    var navigationDelegate:WKNavigationDelegate?
    var uiDelegate:WKUIDelegate?
    public init(url:URL,uiDelegate:WKUIDelegate? = nil,navigationDelegate:WKNavigationDelegate? = nil,isScrollEnabled:Bool = true,contentHeight:Binding<CGFloat>? = nil) {
        let request = IPaURLRequest.url(url)
        self.init(request, uiDelegate: uiDelegate, navigationDelegate: navigationDelegate, isScrollEnabled: isScrollEnabled, contentHeight: contentHeight)
    }
    public init(htmlContent:String,baseUrl:URL?,replacePtToPx:Bool = true,uiDelegate:WKUIDelegate? = nil,navigationDelegate:WKNavigationDelegate? = nil,isScrollEnabled:Bool = true,contentHeight:Binding<CGFloat>? = nil) {
        let request = IPaURLRequest.htmlString(htmlContent, baseUrl, replacePtToPx)
        self.init(request, uiDelegate: uiDelegate, navigationDelegate: navigationDelegate, isScrollEnabled: isScrollEnabled, contentHeight: contentHeight)
    }
    public init(request:URLRequest,uiDelegate:WKUIDelegate? = nil,navigationDelegate:WKNavigationDelegate? = nil,isScrollEnabled:Bool = true,contentHeight:Binding<CGFloat>? = nil) {
        let request = IPaURLRequest.urlRequest(request)
        self.init(request, uiDelegate: uiDelegate, navigationDelegate: navigationDelegate, isScrollEnabled: isScrollEnabled, contentHeight: contentHeight)
    }
    
    init(_ request:IPaURLRequest? = nil,uiDelegate:WKUIDelegate? = nil,navigationDelegate:WKNavigationDelegate? = nil,isScrollEnabled:Bool = true,contentHeight:Binding<CGFloat>? = nil) {
        self.request = request
        
        self._contentHeight = contentHeight ?? Binding.constant(0)
        self.isScrollEnabled = isScrollEnabled
        self.uiDelegate = uiDelegate
        self.navigationDelegate = navigationDelegate
        
        
    }
    public func makeUIView(context: Context) -> IPaWKWebView {
        
        let webView = IPaWKWebView()
        webView.isOpaque = false
        webView.backgroundColor = UIColor.clear
        webView.scrollView.backgroundColor = UIColor.clear
        context.coordinator.webView = webView
        webView.initialJSScript(context.coordinator)
        
        self.updateUIView(webView, context: context)
        
        return webView
    }
    
    
    public func updateUIView(_ uiView: IPaWKWebView, context: Context) {
        if let request = self.request {
            context.coordinator.load(request)
        }
        uiView.uiDelegate = uiDelegate
        uiView.navigationDelegate = navigationDelegate
        uiView.scrollView.isScrollEnabled = self.isScrollEnabled
        uiView.scrollView.alwaysBounceVertical = self.isScrollEnabled
        uiView.scrollView.bounces = self.isScrollEnabled
    }
    
    public func makeCoordinator() -> Coordinator {
        Coordinator($contentHeight)
    }
    public class Coordinator : NSObject,WKScriptMessageHandler {
        weak var webView:IPaWKWebView?
        var request:IPaURLRequest? = nil
        var contentHeight:Binding<CGFloat>
        init(_ contentHeight:Binding<CGFloat>) {
            self.contentHeight = contentHeight
            super.init()
        }
        func load(_ request:IPaURLRequest) {
            if request == self.request {
                return
            }
            self.request = request
            switch request {
            case .htmlString(let htmlString,let baseUrl,let replaceCSSPtToPx):
                _ = webView?.loadHTMLString(htmlString, baseURL: baseUrl, replacePtToPx: replaceCSSPtToPx)
            case .url(let url):
                let urlRequest = URLRequest(url: url)
                _ = webView?.load(urlRequest)
            case .urlRequest(let urlRequest):
                _ = webView?.load(urlRequest)
            }
        }
        
        
        public func userContentController(_ userContentController: WKUserContentController, didReceive message: WKScriptMessage) {
            switch message.name {
            case "windowLoaded":
                webView?.evaluateJavaScript("window.webkit.messageHandlers.sizeNotification.postMessage({justLoaded:true,height: document.body.scrollHeight});") { (result, error) in
                    
                }
                break
            case "sizeNotification":
                guard let responseDict = message.body as? [String:Any],
                    let height = responseDict["height"] as? CGFloat else {
                        return
                }
                
                self.contentHeight.wrappedValue = height
            default:
                break
            }
            
        }
    }
}
