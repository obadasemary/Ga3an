//
//  WebViewController.swift
//  Ga3an
//
//  Created by Abdelrahman Mohamed on 4/25/16.
//  Copyright © 2016 Abdelrahman Mohamed. All rights reserved.
//

import UIKit

class WebViewController: UIViewController {
    
    @IBOutlet var webView: UIWebView!

    override func viewDidLoad() {
        super.viewDidLoad()
        
        if let url = NSURL(string: "https://github.com/obadasemary/Ga3an") {
            let request = NSURLRequest(URL: url)
            webView.loadRequest(request)
        }
    }
}
