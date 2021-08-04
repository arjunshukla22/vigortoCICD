//
//  AboutUsViewController.swift
//  SmileIndia
//
//  Created by Sakshi on 28/07/20.
//  Copyright © 2020 Na. All rights reserved.
//

import UIKit
import WebKit
class AboutUsViewController: UIViewController, WKUIDelegate, UIApplicationDelegate, WKNavigationDelegate {
    
    @IBOutlet var segment: UISegmentedControl!
    @IBOutlet var wView: UIView!
    var webView: WKWebView!
   
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        setStatusBar(color: #colorLiteral(red: 0.233, green: 0.816, blue: 0.538, alpha: 1))
     
          self.view.activityStartAnimating(activityColor: #colorLiteral(red: 0.233, green: 0.816, blue: 0.538, alpha: 1), backgroundColor: UIColor.white)
           
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
       let url = URL(string: "https://www.smileindia.com/terms-and-conditions.pdf")!
       webView.load(URLRequest(url: url))
       webView.allowsBackForwardNavigationGestures = true

            let titleTextAttributes = [NSAttributedString.Key.foregroundColor: UIColor.white]
            segment.setTitleTextAttributes(titleTextAttributes, for: .selected)
            
            self.segment.addTarget(self, action: #selector(segmentSelected(sender:)), for: .valueChanged)
        }
        
    func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
       
           self.view.activityStopAnimating()
       }
    
    @IBAction func didtapBack(_ sender: Any) {
        NavigationHandler.pop()
    }
    @objc func segmentSelected(sender: UISegmentedControl)
    {
        switch(sender.selectedSegmentIndex){

        case 0:
            let url = URL(string: "https://www.smileindia.com/terms-and-conditions.pdf")!
            webView.load(URLRequest(url: url))
            webView.allowsBackForwardNavigationGestures = true
        case 1:
            let url = URL(string: "https://www.smileindia.com/security-and-privacy.pdf")!
            webView.load(URLRequest(url: url))
            webView.allowsBackForwardNavigationGestures = true
        default:
            break
        }
    }
}
