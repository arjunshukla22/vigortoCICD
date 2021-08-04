//
//  PaymentVC.swift
//  SmileIndia
//
//  Created by Sakshi on 21/07/20.
//  Copyright © 2020 Na. All rights reserved.
//

import UIKit
import WebKit


class PaymentVC: UIViewController , WKUIDelegate, UIApplicationDelegate, WKNavigationDelegate {


    var webView: WKWebView!
    var requestURLString = ""
  
    @IBOutlet var btnDone: UIButton!
    @IBOutlet var wView: UIView!
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        setStatusBar(color: .themeGreen)
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
        self.openUrl()
    }
    func openUrl() {
    let url = URL (string: requestURLString)
    let request = URLRequest(url: url!)
    webView.load(request)
    }

    @IBAction func didtapDone(_ sender: Any) {
        NavigationHandler.popTo(DoctorDashBoardVC.self)
    }
    @IBAction func didtapBack(_ sender: Any) {
        NavigationHandler.popTo(DoctorDashBoardVC.self)
    }
      
    func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
    title = webView.title
        self.view.activityStopAnimating()
    }

    func PaidDoctorPlans() -> Void {
    
               let queryItems = ["CustomerGuid": "\(Authentication.customerGuid!)"]
               self.view.activityStartAnimating(activityColor: #colorLiteral(red: 0.233, green: 0.816, blue: 0.538, alpha: 1), backgroundColor: UIColor.white)
               WebService.paidDoctorPlans(queryItems: queryItems)
               { (result) in
                       DispatchQueue.main.async {
                           switch result {
                           case .success(let response):
                            print(response.message ?? "")
                           case .failure(let error):
                            print(error.message)
                           }
                           self.view.activityStopAnimating()
                       }
                    }
           }
   
}

