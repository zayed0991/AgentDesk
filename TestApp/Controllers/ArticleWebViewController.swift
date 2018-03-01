//
//  ArticleWebViewController.swift
//  TestApp
//
//  Created by Faraz Habib on 28/02/18.
//  Copyright © 2018 Faraz Habib. All rights reserved.
//

import UIKit
import WebKit

class ArticleWebViewController: UIViewController {

    @IBOutlet weak var webkitView: WKWebView!
    @IBOutlet weak var btnClose: UIButton!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    
    var urlRequest:URLRequest!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        webkitView.navigationDelegate = self
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        webkitView.load(urlRequest)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func closeTapped(_ sender: UIButton) {
        dismiss(animated: true, completion: nil)
    }
    
}

extension ArticleWebViewController: WKNavigationDelegate {
    
    func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
        activityIndicator.stopAnimating()
    }
}


