//
//  TermsVC.swift
//  SmileIndia
//
//  Created by Arjun  on 28/02/20.
//  Copyright © 2020 Na. All rights reserved.
//

import UIKit
import WebKit


class TermsVC: UIViewController , WKUIDelegate, UIApplicationDelegate, WKNavigationDelegate {


    var webView: WKWebView!
    var requestURLString = ""
    var screentitle = ""
    
    
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var wView: UIView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        setStatusBar(color: #colorLiteral(red: 0.233, green: 0.816, blue: 0.538, alpha: 1))
        self.view.activityStartAnimating(activityColor: .themeGreen, backgroundColor: UIColor.white)

        titleLabel.text = screentitle

        let webConfiguration = WKWebViewConfiguration()

        let customFrame = CGRect.init(origin: CGPoint.zero, size: CGSize.init(width: 0.0, height: self.wView.frame.size.height))
        self.webView = WKWebView (frame: customFrame , configuration: webConfiguration)
        webView.translatesAutoresizingMaskIntoConstraints = false
        self.wView.addSubview(webView)
        webView.topAnchor.constraint(equalTo: wView.topAnchor).isActive = true
        webView.rightAnchor.constraint(equalTo: wView.rightAnchor).isActive = true
        webView.leftAnchor.constraint(equalTo: wView.leftAnchor).isActive = true
        webView.bottomAnchor.constraint(equalTo: wView.bottomAnchor).isActive = true
        webView.heightAnchor.constraint(equalTo: wView.heightAnchor).isActive = true

        webView.uiDelegate = self
        webView.navigationDelegate = self
        webView.scrollView.bounces = false
        
        if self.screentitle == "Prescription By Doctor" {
            webView.loadHTMLString(requestURLString, baseURL:URL (string:"\(APIConstants.mainUrl)"))

        }else{
            self.openUrl()
        }
    }
    func openUrl() {
    let url = URL (string: requestURLString)
    let request = URLRequest(url: url!)
    webView.load(request)
    }

    
    @IBAction func didtapBack(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    
    func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
    title = webView.title
    self.view.activityStopAnimating()
    }

}
