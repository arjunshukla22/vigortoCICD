//
//  ReplyViewController.swift
//  SmileIndia
//
//  Created by Arjun  on 07/04/20.
//  Copyright © 2020 Na. All rights reserved.
//

import UIKit

class ReplyViewController: UIViewController ,UITextViewDelegate{
    
  //  var object: Appointment?
    
    var object: ReviewDetailsModel?
    
    @IBOutlet weak var replyTextview: UITextView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        setStatusBar(color: #colorLiteral(red: 0.233, green: 0.816, blue: 0.538, alpha: 1))
        hideKeyboardWhenTappedAround()

        if let doctorReply =  object?.reply{
        replyTextview.text = doctorReply
        }
        replyTextview.delegate = self
    }
    
    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        return textView.text.count + (text.count - range.length) <= 250
    }
    
    @IBAction func didtapSubmit(_ sender: Any) {
        if replyTextview.text?.trimmingCharacters(in: .whitespacesAndNewlines) != "" {
            if let review = replyTextview.text?.trimmingCharacters(in: .whitespacesAndNewlines){
                let queryItems = ["DoctorReply": review, "ReviewId": "\(object?.id ?? 0)"] as [String : Any]
                self.view.activityStartAnimating(activityColor: .themeGreen, backgroundColor: UIColor.white)
                WebService.replyproviders(queryItems: queryItems) { (result) in
                    DispatchQueue.main.async {
                        switch result {
                        case .success(let response):
                            AlertManager.showAlert(type: .custom(response.message ?? "")) {
                                    NavigationHandler.pop()
                            }
                        case .failure(let error):
                            AlertManager.showAlert(type: .custom(error.message))
                        }
                        self.view.activityStopAnimating()
                    }
                }
            }
        } else {
            AlertManager.showAlert(type: .custom(ReplyScreenTxt.enterReply.localize()))
        }
    }
    
    @IBAction func didtapBack(_ sender: Any) {
        NavigationHandler.pop()
    }
    
}
