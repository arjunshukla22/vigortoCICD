//
//  RewardsViewController.swift
//  SmileIndia
//
//  Created by Arjun  on 12/10/20.
//  Copyright © 2020 Na. All rights reserved.
//

import UIKit

class RewardsViewController: BaseViewController {

    @IBOutlet weak var rpLabel: UILabel!
    
    var rewards: Rewards?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        setStatusBar(color: .themeGreen)
        self.getRewards()
    }
    
    func getRewards(){
     self.view.activityStartAnimating(activityColor: .themeGreen, backgroundColor: UIColor.white)
        WebService.getrewardsData(queryItems: ["LoginKey": Authentication.token ?? "YXNob2ttaXR0YWxAZ21haWwuY29tOjEyMzQ1Ng=="]) { (result) in
            DispatchQueue.main.async {
                switch result {
                case .success(let response):
                    if let user = response.object {
                        self.rewards = user
                       self.setUI()
                    }
                case .failure(let error):
                    self.showError(message: error.message)
                }
             self.view.activityStopAnimating()
            }
        }
    }
    
    func setUI() {
        self.rpLabel.text = "\(rewards?.Earnedpoints ?? 0)"
    }
    
    @IBAction func didtapBack(_ sender: Any) {
        NavigationHandler.pop()
    }
    
}
