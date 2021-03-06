//
//  ViewController.swift
//  TWWebView
//
//  Created by silentcloud on 6/25/14.
//  Copyright (c) 2014 silentcloud. All rights reserved.
//

import UIKit
import WebKit

class ViewController: UIViewController,WKNavigationDelegate, WKScriptMessageHandler {
    
    var webview:WKWebView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        //user script // native call js func
        let jsScript = "alert('马上将字体变红');redFont()"
        let userScript = WKUserScript(source: jsScript, injectionTime: .AtDocumentEnd, forMainFrameOnly: true)
        
        //WKUserContentController
        let userController = WKUserContentController()
        userController.addUserScript(userScript)
        userController.addScriptMessageHandler(self, name: "callbackHandler")
        
        //WKWebViewConfiguration
        let configuration = WKWebViewConfiguration()
        configuration.preferences.javaScriptEnabled = true
        configuration.preferences.minimumFontSize = 16.0
        configuration.userContentController = userController
        
        self.webview = WKWebView(frame: self.view.bounds, configuration: configuration)
        //gesture
        self.webview.allowsBackForwardNavigationGestures = true // or false
        
        self.webview.navigationDelegate = self
        self.view.addSubview(self.webview)
        
        let path = NSBundle.mainBundle().pathForResource("wkwebview", ofType: "html")
        let url = NSURL.fileURLWithPath(path!)
        let request = NSURLRequest(URL: url!)
        self.webview.loadRequest(request)
    }
    
    func tappedButton(sender: UIButton!)
    {
        if self.webview.canGoBack
        {
            self.webview.goBack()
        }
    }
    
    func showAlert(content: String!)
    {
        var alert = UIAlertController(title: "Call Native Alert From JS", message: content, preferredStyle: UIAlertControllerStyle.Alert)
        alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.Default, handler: nil))
        self.presentViewController(alert, animated: true, completion: nil)
    }

    /*! @abstract Invoked when a script message is received from a webpage.
    @param userContentController The user content controller invoking the
    delegate method.
    @param message The script message received.
    */
    func userContentController(userContentController: WKUserContentController, didReceiveScriptMessage message: WKScriptMessage) {
        if(message.name == "callbackHandler") {
            println("JavaScript is sending a message \(message.body)")
            let msg = message.body as NSDictionary
            self.showAlert(msg["msg"] as String)
        }
    }
    
    
    //WKNavigationDelegate
    
//    //Decides whether to allow or cancel a navigation.
    func webView(webView: WKWebView!, decidePolicyForNavigationAction navigationAction: WKNavigationAction!, decisionHandler: ((WKNavigationActionPolicy) -> Void)!)
    {
        //if back，cancel load
        println(navigationAction)
        if navigationAction.navigationType.rawValue == 0 {
            decisionHandler(.Cancel)
            return;
        }
        decisionHandler(.Allow)
    }
    
    //Decides whether to allow or cancel a navigation after its response is known.
    func webView(webView: WKWebView!, decidePolicyForNavigationResponse navigationResponse: WKNavigationResponse!, decisionHandler: ((WKNavigationResponsePolicy) -> Void)!)
    {
        println(navigationResponse.response.URL)
        if navigationResponse.response.URL?.absoluteString == "http://www.baidu.com/" {
//            webView.stopLoading()
            decisionHandler(.Cancel)
        }
        decisionHandler(.Allow)
    }
    
    
    func webView(webView: WKWebView!, didFailNavigation navigation: WKNavigation!, withError error: NSError!)
    {
        if let hasError = error {
            println("webView load error!")
        }
    }

}

