//
//  ChatViewController.swift
//  Turnip
//
//  Created by Tyler Hoyt on 4/13/16.
//  Copyright © 2016 Turnip Apps. All rights reserved.
//

import UIKit

class ChatViewController: UIViewController {
    
    var url : String = ""

    override func viewDidLoad() {

        //Make webview
        let webView = UIWebView(frame: self.view.bounds)
        view.addSubview(webView)

        super.viewDidLoad()
        let nsURL = NSURL (string: url)
        let requestObj = NSURLRequest(URL: nsURL!);
        webView.loadRequest(requestObj)
        print(url)
        // Do any additional setup after loading the view.
    }
}
