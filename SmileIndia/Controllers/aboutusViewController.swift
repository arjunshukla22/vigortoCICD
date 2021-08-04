//
//  aboutusViewController.swift
//  SmileIndia
//
//  Created by Sakshi Gothi on 11/05/21.
//  Copyright © 2021 Na. All rights reserved.
//


import UIKit

class aboutusViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        setStatusBar(color: .themeGreen)
      
    }
    

    @IBAction func didTapBack(_ sender: Any) {
        NavigationHandler.pop()
    }
    

}
