//
//  howitworksViewController.swift
//  SmileIndia
//
//  Created by Sakshi Gothi on 11/05/21.
//  Copyright © 2021 Na. All rights reserved.
//

import UIKit

class howitworksViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        setStatusBar(color: .themeGreen)
        // Do any additional setup after loading the view.
    }
    

    @IBAction func didTapBack(_ sender: Any) {
        NavigationHandler.pop()
    }
   

}
