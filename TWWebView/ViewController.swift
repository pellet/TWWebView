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
        self.view!.addSubview(self.webview)
        
        let url = NSURL(string: "http://ux.alipay-inc.com/ftp/h5/zhuluwkwebview.html")
        let request = NSURLRequest(URL: url)
        self.webview.loadRequest(request)
        
        let backBtn = UIButton(frame: CGRectMake(10, 450, 60, 30))
        backBtn.setTitle("Back", forState: UIControlState.Normal)
        backBtn.setTitleColor(UIColor.redColor(), forState: UIControlState.Normal)
        backBtn.addTarget(self, action: "tappedButton:", forControlEvents: UIControlEvents.TouchUpInside)
        self.view!.addSubview(backBtn)
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

     //WKScriptMessageHandler
    func userContentController(userContentController: WKUserContentController!, didReceiveScriptMessage message: WKScriptMessage!) {
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
        if navigationAction.navigationType == .BackForward {
            decisionHandler(.Cancel)
            return;
        }
        decisionHandler(.Allow)
    }
    
    //Decides whether to allow or cancel a navigation after its response is known.
    func webView(webView: WKWebView!, decidePolicyForNavigationResponse navigationResponse: WKNavigationResponse!, decisionHandler: ((WKNavigationResponsePolicy) -> Void)!)
    {
        println(navigationResponse.response.URL)
        if navigationResponse.response.URL.absoluteString == "http://www.baidu.com/" {
            webView.stopLoading()
        }
    }
    
    
    func webView(webView: WKWebView!, didFailNavigation navigation: WKNavigation!, withError error: NSError!)
    {
        if let hasError = error {
            println("webView load error!")
        }
    }

}

