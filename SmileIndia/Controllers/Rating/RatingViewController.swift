//
//  RatingViewController.swift
//  SmileIndia
//
//  Created by Na on 19/07/19.
//  Copyright © 2019 Na. All rights reserved.
//

import UIKit
import FloatRatingView
import KMPlaceholderTextView

class RatingViewController: UIViewController {
    @IBOutlet weak var profileImageView: UIImageView!
    @IBOutlet weak var ratingView: FloatRatingView!
    @IBOutlet weak var nameLabel: UILabel!
   // @IBOutlet weak var ratinglabel: UILabel!
    @IBOutlet weak var charactersCountLabel: UILabel!
    @IBOutlet weak var reviewTextView: UITextView!{
        didSet{
            //reviewTextView.placeholder = "Give Your Feedback!"
            
            reviewTextView.text = RateScreenTxt.giveYourFeedback.localize()
          //  reviewTextView.textColor = UIColor.lightGray
            
            if #available(iOS 13.0, *) {
                reviewTextView.textColor = .label
            } else {
                // Fallback on earlier versions
                reviewTextView.textColor = .lightGray
            }
        }
    }
    
    @IBOutlet weak var navView: UIView!
    
    
    var  object: Appointment?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.

        setStatusBar(color: .themeGreen)
        hideKeyboardWhenTappedAround()


        showRating()
        ratingView.type = .wholeRatings
        ratingView.delegate = self
        
        reviewTextView.delegate = self
        
    }
    @IBAction func didTapBackButton(_ sender: Any){
        
        let apVC = AppointmentListingController.instantiateFromAppStoryboard(.appointment)
        if NavigationHandler.stack.contains(apVC){
            NavigationHandler.pop()
        }else{
            if var navstack = NavigationHandler.stack as? [UIViewController]{
                navstack.insert(apVC, at: navstack.count-1)
                BaseNavigationController.sharedInstance.setViewControllers(navstack, animated: true)
            }
            NotificationCenter.default.post(name: Notification.Name("appointment"), object: 3)
            NavigationHandler.pop()
        }
    }
    @IBAction func didTapSubmitRating(_ sender: Any) {
        if reviewTextView.text?.trimmingCharacters(in: .whitespacesAndNewlines) != "" &&  reviewTextView.text != RateScreenTxt.giveYourFeedback.localize() && ratingView.rating > 0{
            if let review = reviewTextView.text?.trimmingCharacters(in: .whitespacesAndNewlines){
                let queryItems = ["Reviews": review, "RatingScore": Int(ratingView.rating), "MemberName": Authentication.customerName ?? "", "ProviderId": /object?.ProviderId  , "CustomerID": /Authentication.customerId, "Email": /Authentication.customerEmail, "ImageName": "p", "AppointmentId": object?.Id ?? 0, "CreateDate": currentDate()] as [String : Any]
                
                print(queryItems)
                
                self.view.activityStartAnimating(activityColor: .themeGreen, backgroundColor: UIColor.white)
                WebService.rateproviders(queryItems: queryItems) { (result) in
                    DispatchQueue.main.async {
                        switch result {
                        case .success(let response):
                            AlertManager.showAlert(type: .custom(response.message ?? "")){
                                NotificationCenter.default.post(name: Notification.Name("appointment"), object: 3)
                                NavigationHandler.pop()
                            }
                        case .failure(let error):
                            AlertManager.showAlert(type: .custom(error.message)){
                                NotificationCenter.default.post(name: Notification.Name("appointment"), object: 3)
                                NavigationHandler.pop()
                            }
                        }
                        self.view.activityStopAnimating()
                    }
                }
            }
        } else {
            AlertManager.showAlert(type: .custom(RateScreenTxt.requiredField.localize()))
        }
    }
    
    
}
extension RatingViewController: FloatRatingViewDelegate {
    func floatRatingView(_ ratingView: FloatRatingView, didUpdate rating: Double) {

           // ratinglabel.text = "\(rating) Rating"

    }
    func floatRatingView(_ ratingView: FloatRatingView, isUpdating rating: Double) {
           // ratinglabel.text = "\(rating) Rating"

    }
}

extension RatingViewController{
    func showRating()
    {
        let queryItems = ["CustomerID": /object?.ProviderId] as [String : Any]
        self.view.activityStartAnimating(activityColor: .themeGreen, backgroundColor: UIColor.white)
        WebService.showrating(queryItems: queryItems) { (result) in
            DispatchQueue.main.async {
                switch result {
                case .success(let response):
                    print(response)
                    if let rating = response.object {
                        self.setView(rating)
                    }
                case .failure(let error):
                    print(error)
                }
                self.view.activityStopAnimating()
            }
        }
    }
    func setView(_ rating: Rating){
        DispatchQueue.main.async {
           // self.profileImageView.sd_setImage(with: rating.imageURL, completed: nil)
          //  self.profileImageView.sd_setImage(with: rating.imageURL, placeholderImage: UIImage.init(named: "doctor-avtar"))
           // self.nameLabel.text = rating.ProviderName
        }
        
    }
    func currentDate() -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd hh:mm:ss"
        return dateFormatter.string(from: Date())
    }
}


extension RatingViewController: UITextViewDelegate{
    
    func textViewDidBeginEditing(_ textView: UITextView) {
        if textView.text == RateScreenTxt.giveYourFeedback.localize() {
            textView.text = nil
            if #available(iOS 13.0, *) {
                textView.textColor = UIColor.label
            } else {
                // Fallback on earlier versions
                textView.textColor = UIColor.black
            }
        }
    }
    
    func textViewDidEndEditing(_ textView: UITextView) {
        if textView.text.isEmpty {
            textView.text = RateScreenTxt.giveYourFeedback.localize()
            if #available(iOS 13.0, *) {
                textView.textColor = .label
            } else {
                // Fallback on earlier versions
                textView.textColor = .lightGray
            }
        }
    }
    
    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        let newText = (textView.text as NSString).replacingCharacters(in: range, with: text)
        let numberOfChars = newText.count
       // charactersCountLabel.text = "\(140-numberOfChars)"
        return numberOfChars < 250    // 10 Limit Value
    }
}

