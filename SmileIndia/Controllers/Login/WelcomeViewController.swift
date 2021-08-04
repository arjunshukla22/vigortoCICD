//
//  WelcomeViewController.swift
//  SmileIndia
//
//  Created by Na on 10/02/19.
//  Copyright © 2019 Na. All rights reserved.
//

import UIKit
import Localize

class WelcomeViewController: UIViewController {
    
    var lat = String()
    var long = String()
    
    @IBOutlet weak var infoLabel: UILabel!
    @IBOutlet weak var loginBtnOL: UIButton!
    @IBOutlet weak var signupBtnOL: UIButton!
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //        NotificationCenter.default.addObserver(self, selector: #selector(WelcomeViewController.methodOfReceivedNotification(notification:)), name: .showBuySub, object: nil)
        setStatusBar(color: .themeGreen)
        infoLabel.text = WelcomeScreenTxt.welcomeTxt.localize()
        self.getPrivacyAccess()
        
        //        loginBtnOL.setTitle(WelcomeScreenTxt.logIn.localize(), for: .normal)
        //        signupBtnOL.setTitle(WelcomeScreenTxt.signUp.localize(), for: .normal)
        
    }
    @objc func methodOfReceivedNotification(notification: Notification) {
        
    }
    
    private func getPrivacyAccess(){
        let vStatus = AVCaptureDevice.authorizationStatus(for: .video)
        if(vStatus == AVAuthorizationStatus.notDetermined){
            AVCaptureDevice.requestAccess(for: .video, completionHandler: { (granted: Bool) in
            })
        }
        let aStatus = AVCaptureDevice.authorizationStatus(for: .audio)
        if(aStatus == AVAuthorizationStatus.notDetermined){
            AVCaptureDevice.requestAccess(for: .audio, completionHandler: { (granted: Bool) in
            })
        }
    }
    
    @IBAction func didTapLoginButton(_ sender: Any) {
        NavigationHandler.pushTo(.login)
    }
    
    @IBAction func changeLanguageAction(_ sender: Any) {
        ChangeLanguageApp()
    }
    
    @IBAction func didTapCreateButton(_ sender: Any) {
        let popOverVC = self.storyboard?.instantiateViewController(withIdentifier: "PopupViewController") as! PopupViewController
        popOverVC.modalPresentationStyle = UIModalPresentationStyle.overFullScreen
        self.present(popOverVC, animated: true)
    }
    
    @IBAction func didTapSkipStep(_ sender: Any) {
         NavigationHandler.pushTo(.homeViewController)
        
    }
    
    func ChangeLanguageApp() {
        let actionSheet = UIAlertController(
            title: nil,
            message: AlertBtnTxt.selectLanguage.localize(),
            preferredStyle: UIAlertController.Style.actionSheet
        )
        
        for language in Localize.availableLanguages {
            print(language)
            let displayName = (language == "en") ? "English" : Localize.displayNameForLanguage(language)
            let languageAction = UIAlertAction(
                title: displayName,
                style: .default,
                handler: { (_: UIAlertAction!) -> Void in
                    
                    //                    Localize.update(fileName: "lang")
                    // Set your default languaje.
                    Localize.update(defaultLanguage: language)
                    // If you want change a user language, different to default in phone use thimethod.
                    Localize.update(language: language)
                    
                    Authentication.appLanguage = language
                    // appdelegate?.UpdateAppLanguage(Lang: language)
                })
            actionSheet.addAction(languageAction)
        }
        let cancelAction = UIAlertAction(
            title: AlertBtnTxt.cancel.localize(),
            style: UIAlertAction.Style.cancel,
            handler: nil
        )
        
        actionSheet.addAction(cancelAction)
        self.present(actionSheet, animated: true, completion: nil)
    }
    
    

    
}







