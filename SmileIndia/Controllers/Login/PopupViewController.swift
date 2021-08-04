//
//  PopupViewController.swift
//  SmileIndia
//
//  Created by Na on 19/05/19.
//  Copyright © 2019 Na. All rights reserved.
//

import UIKit

class PopupViewController: UIViewController {

    @IBOutlet weak var docSignUpBtnOL: UIButton!
    @IBOutlet weak var memberSignUpBtnOL: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        switch Authentication.appLanguage {
        case EnumAppLanguage.English:
            docSignUpBtnOL.setBackgroundImage(UIImage(named: Asset.IcDoctor_Reg_English.rawValue), for: .normal)
            memberSignUpBtnOL.setBackgroundImage(UIImage(named: Asset.IcMember_Reg_English.rawValue), for: .normal)
            break
        case EnumAppLanguage.Spanish:
            docSignUpBtnOL.setBackgroundImage(UIImage(named: Asset.IcDoctor_Reg_Spanish.rawValue), for: .normal)
            memberSignUpBtnOL.setBackgroundImage(UIImage(named: Asset.IcMember_Reg_Spanish.rawValue), for: .normal)
            break
        default:
            docSignUpBtnOL.setBackgroundImage(UIImage(named: Asset.IcDoctor_Reg_English.rawValue), for: .normal)
            memberSignUpBtnOL.setBackgroundImage(UIImage(named: Asset.IcMember_Reg_English.rawValue), for: .normal)
            break
        }
        
    }
    
    @IBAction func didTapCloseButton(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    
    
    @IBAction func didTapDoctorButton(_ sender: Any) {
        self.dismiss(animated: true, completion: {
             NavigationHandler.pushTo(.newSignUp)
        })
    }
    
    @IBAction func didTapMemberButton(_ sender: Any) {
        self.dismiss(animated: true, completion: {
            NavigationHandler.pushTo(.member)
        })
    }
}
