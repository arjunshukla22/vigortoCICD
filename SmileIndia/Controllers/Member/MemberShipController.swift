//
//  MemberShipController.swift
//  SmileIndia
//
//  Created by Na on 20/05/19.
//  Copyright © 2019 Na. All rights reserved.
//

import UIKit

class MemberShipController: BaseViewController {
    @IBOutlet weak var logoImageView: UIImageView!
    @IBOutlet weak var toLabel: UILabel!
    @IBOutlet weak var fromLabel: UILabel!
    @IBOutlet weak var subcriberIdLabel: UILabel!
    @IBOutlet weak var memberIdLabel: UILabel!
    @IBOutlet weak var cardView: UIView!
    @IBOutlet weak var memberNameLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        membership(["LoginKey": Authentication.token ?? ""])
        //cardNumberTextfield.text = "SM201900000030"
        // Do any additional setup after loading the view.
    }
    @IBAction func didTapBackButton(_ sender: Any) {
        NavigationHandler.pop()
    }
    
  
}
extension MemberShipController{
    func membership(_ query: [String: Any]){
        activityIndicator.showLoaderOnWindow()
        self.view.endEditing(true)
        WebService.membership(queryItems: query) { (result) in
            DispatchQueue.main.async {
                activityIndicator.hideLoader()
                switch result {
                case .success(let response):
                    if let card = response.object {
                        self.cardView.isHidden = false
                        self.setupUI(card)
                    } else {
                    }
                case .failure(let error):
                    self.cardView.isHidden = true
                    print(error.message)
                    self.showError(message: error.message)
                }
            }
        }
    }
    func setupUI(_ card: Card) {
        logoImageView.sd_setImage(with: card.imageURL, placeholderImage: UIImage.init(named: "welcomeLogo"))
        memberNameLabel.text = card.FullName
        memberIdLabel.text = card.MemberId
        subcriberIdLabel.text = card.SubscriberId
        fromLabel.text = card.EffectiveDate
        toLabel.text = card.EndDate
    }
}
