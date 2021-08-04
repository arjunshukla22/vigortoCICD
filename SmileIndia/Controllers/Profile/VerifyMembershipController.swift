//
//  VerifyMembershipController.swift
//  SmileIndia
//
//  Created by Na on 15/03/19.
//  Copyright © 2019 Na. All rights reserved.
//

import UIKit

class VerifyMembershipController: BaseViewController {

    @IBOutlet weak var logoImageView: UIImageView!
    @IBOutlet weak var toLabel: UILabel!
    @IBOutlet weak var fromLabel: UILabel!
    @IBOutlet weak var subcriberIdLabel: UILabel!
    @IBOutlet weak var memberIdLabel: UILabel!
    @IBOutlet weak var cardView: UIView!
    @IBOutlet weak var cardNumberTextfield: UITextField!
    @IBOutlet weak var memberNameLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
//cardNumberTextfield.text = "SM201900000030"
        // Do any additional setup after loading the view.
    }
    @IBAction func didTapBackButton(_ sender: Any) {
        NavigationHandler.pop()
    }

    @IBAction func didTapSearch(_ sender: Any) {
        if cardNumberTextfield.text?.isEmptyString() ?? false{
            AlertManager.showAlert(type: .custom("Please enter card number."))
        } else {
        verifyMembership(["CardNo": cardNumberTextfield.text ?? "", "LoginKey": Authentication.token ?? ""])
        }
    }
    

}
extension VerifyMembershipController{
    func verifyMembership(_ query: [String: Any]){
        self.view.activityStartAnimating(activityColor: .themeGreen, backgroundColor: UIColor.white)
        self.view.endEditing(true)
        WebService.verifyMembership(queryItems: query) { (result) in
            DispatchQueue.main.async {
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
                self.view.activityStopAnimating()
            }
        }
    }
    func setupUI(_ card: Card) {
        logoImageView.sd_setImage(with: card.imageURL, placeholderImage: UIImage.init(named: "welcomeLogo"))
        memberNameLabel.text = card.MemberName
        memberIdLabel.text = card.MemberId
        subcriberIdLabel.text = card.SubscriberId
        fromLabel.text = card.EffectiveDate
        toLabel.text = card.EndDate
    }
}
