//
//  BaseViewController.swift
//  HandstandV2
//
//  Created by user on 18/12/18.
//  Copyright © 2018 Navjot Sharma. All rights reserved.
//

import UIKit

class BaseViewController: UIViewController, ErrorHandlable {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.automaticallyAdjustsScrollViewInsets = false
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    func addTitleView(_ title: String) -> UIView {
        let mainView = UIView()
        mainView.frame = CGRect.init(x: 0 , y: -5, width: 150, height: 55)
        let label = UILabel.init(frame: CGRect(x: 0, y: -5, width: 150, height: 55))
        label.text = title
        label.font = UIFont.init(style: .bold, size: .h5)
        label.textColor = .black
        label.textAlignment = .center
        mainView.addSubview(label)
        return mainView
    }
    
    func showNavigation() {
        DispatchQueue.main.async {
          self.navigationController?.setNavigationBarHidden(false, animated: false)
        }
    }
    
    func hideNavigation() {
        DispatchQueue.main.async {
          self.navigationController?.setNavigationBarHidden(true, animated: false)
        }
    }
    
    func addCustomNavigationView(_ view: UIView) {
        
        self.navigationItem.titleView = view
        self.navigationController?.navigationBar.barTintColor = UIColor.init(red: 0.9, green: 0.9, blue: 0.9, alpha: 1)
        self.navigationController?.navigationBar.isTranslucent = false
    }
    
   
    
    func blockUI(_ flag: Bool) {
        self.view.isUserInteractionEnabled = !flag
    }
    
    @IBAction func pop(_ sender: UIBarButtonItem) {
        self.navigationController?.popViewController(animated: true)
    }
}


