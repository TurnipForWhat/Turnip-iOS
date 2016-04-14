//
//  ChatViewController.swift
//  Turnip
//
//  Created by Tyler Hoyt on 4/13/16.
//  Copyright © 2016 Turnip Apps. All rights reserved.
//

import UIKit

class ChatViewController: UIViewController {
    
    @IBOutlet weak var webView: UIWebView!
    var url : String = ""

    override func viewDidLoad() {
        super.viewDidLoad()
        let nsURL = NSURL (string: url)
        let requestObj = NSURLRequest(URL: nsURL!);
        webView.loadRequest(requestObj)
        print(url)
        // Do any additional setup after loading the view.
    }
}
