//
//  ReferralVC.swift
//  SmileIndia
//
//  Created by Arjun  on 19/03/20.
//  Copyright © 2020 Na. All rights reserved.
//

import UIKit
import Localize
import ActiveLabel

class ReferralVC: UIViewController {
    
    @IBOutlet weak var defaulterLabel: UILabel!
    
  //  @IBOutlet weak var inviteLbl: UILabel!
    
    @IBOutlet weak var inviteLbl: ActiveLabel!
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        setStatusBar(color: .themeGreen)
        self.defaulterLabel.text = ""
        
        self.inviteLbl.text = ReferralScreenTxt.Invite.localize()
        
        setFonts()

    }
    
    func  setFonts()  {
        let customType1 = ActiveType.custom(pattern: ReferralScreenTxt.referFriends.localize())
        let customType2 = ActiveType.custom(pattern: ReferralScreenTxt.referPoints.localize())
        inviteLbl.enabledTypes = [customType1, customType2]
        inviteLbl.customize { label in
//            label.configureLinkAttribute = { (type, attributes, isSelected) in
//                var atts = attributes
//                atts[NSAttributedString.Key.underlineStyle] = NSUnderlineStyle.single.rawValue
//                return atts
//            }
//            label.highlightFontName = UIFont.Style.bold.name
//            label.highlightFontSize = UIFont.Size.h6.floatValue
            label.customColor[customType1] = UIColor.themeGreen
            label.customSelectedColor[customType1] = UIColor.themeGreen
            
            label.customColor[customType2] = UIColor.themeGreen
            label.customSelectedColor[customType2] = UIColor.themeGreen
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        if Authentication.customerType == "Doctor" {
            self.customerInfo()
        }
    }
    func customerInfo(){
        let queryItems = ["Email": Authentication.customerEmail ?? ""] as [String: Any]
        WebService.customerInfo(queryItems: queryItems) { (result) in
            DispatchQueue.main.async {
                switch result {
                case .success(let response):
                    if response.object?.IsDefaulter ?? false{
                        self.defaulterLabel.text = ProfileUpdate.Alert.defaulter.localize()
                        AlertManager.showAlert(type: .custom(ProfileUpdate.Alert.defaulter.localize()))
                    }else{
                        self.defaulterLabel.text = ""
                    }
                case .failure(let error):
                    AlertManager.showAlert(type: .custom(error.message))
                }
            }
        }
    }
    @IBAction func didTapBack(_ sender: UIButton) {
        NavigationHandler.pop()
    }
    
    @IBAction func didTapRefer(_ sender: UIButton) {
        self.share(sender: self.view)
    }

    @objc func share(sender:UIView){
        
        var textToShare = "Let me recommend you this application\n\nJoin Vigorto, a healthcare portal to take care of you and your family's health and wellness and get rewarded on your first successful appointment booking. Please visit our website https://vigorto.com/ or get Android App https://play.google.com/store/apps/details?id=com.droveandpace.vigorto or  iPhone App https://apps.apple.com/in/app/vigorto/id1527224199\n\nYour referral code \(Authentication.customerId ?? "0")"
        if !(Authentication.isUserLoggedIn ?? false) {
         textToShare = "Let me recommend you this application\n\nJoin Vigorto, a healthcare portal to take care of you and your family's health and wellness and get rewarded on your first successful appointment booking. Please visit our website https://vigorto.com/ or get Android App https://play.google.com/store/apps/details?id=com.droveandpace.vigorto or  iPhone App https://apps.apple.com/in/app/vigorto/id1527224199"
        }
        if let myWebsite = URL(string: "https://apps.apple.com/in/app/vigorto/id1527224199") {//Enter link to your app here
            
            let objectsToShare = [textToShare, myWebsite] as [Any]
            
            let activityVC = UIActivityViewController(activityItems: objectsToShare, applicationActivities: nil)

            //Excluded Activities
            activityVC.excludedActivityTypes = [UIActivity.ActivityType.airDrop, UIActivity.ActivityType.addToReadingList]
            //

            activityVC.popoverPresentationController?.sourceView = sender
            self.present(activityVC, animated: true, completion: nil)
        }
            
    }
}
