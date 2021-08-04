//
//  RatingTableViewCell.swift
//  SmileIndia
//
//  Created by Na on 23/07/19.
//  Copyright © 2019 Na. All rights reserved.
//

import UIKit

class RatingTableViewCell: UITableViewCell, ReusableCell {

    @IBOutlet weak var deleteBtn: UIButton!
    @IBOutlet weak var editBtn: UIButton!
    @IBOutlet weak var drReviewLabel: UILabel!
    @IBOutlet weak var replyBtn: UIButton!
    
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var reviewLabel: UILabel!
    @IBOutlet weak var ratingView: STRatingControl!
    @IBOutlet weak var nameLabel: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        self.selectionStyle = .none
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        // Configure the view for the selected state
    }
    var object: ReviewDetailsModel? {
        didSet {
            nameLabel.text = object?.reviwerName
          //  dateLabel.text = "\(object?.createdOn ?? "Date missing")"
            dateLabel.isHidden = true
            reviewLabel.text = object?.review
            ratingView.rating = Int(object?.starRating ?? "0") ?? 0
            
           // replyBtn.setTitleColor(.themeGreen, for: .normal)
                
            
            if object?.reply == nil ||  object?.reply == ""
            {
                replyBtn.isHidden = false
                drReviewLabel.isHidden=true
                editBtn.isHidden = true
                deleteBtn.isHidden = true
            }else
            {
                drReviewLabel.isHidden=false
                editBtn.isHidden = false
                deleteBtn.isHidden = false
                replyBtn.isHidden = true
                
                if let doctorReply =  object?.reply{
                    var test1Attributes:[NSAttributedString.Key: Any] = [.font : UIFont.systemFont(ofSize: 13, weight: .bold)]
                    test1Attributes[.foregroundColor] = #colorLiteral(red: 0.3137254902, green: 0.7921568627, blue: 0.6274509804, alpha: 0.9)
                    let test2Attributes:[NSAttributedString.Key: Any] = [.font : UIFont.systemFont(ofSize: 13, weight: .regular)]

                    let test1 = NSAttributedString(string: "\(RateScreenTxt.yourReply.localize()) :\n", attributes:test1Attributes)
                    let test2 = NSAttributedString(string: doctorReply, attributes:test2Attributes)
                    let text = NSMutableAttributedString()

                    text.append(test1)
                    text.append(test2)
                    
                    

                   drReviewLabel.attributedText = text
                }
            }
        }
    }

    
    @IBAction func didtapReply(_ sender: UIButton) {
        NavigationHandler.pushTo(.replyVC(object!))
    }
    
    @IBAction func didtapEdit(_ sender: Any) {
        NavigationHandler.pushTo(.replyVC(object!))
    }
    
    @IBAction func didtapDelete(_ sender: Any) {
        AlertManager.showAlert(type: .custom(RateScreenTxt.wannaDeleteReply.localize()), actionTitle: AlertBtnTxt.okay.localize()) {
            self.deleteReply()
        }
        
    }
    
    
    func deleteReply() -> Void {
        let queryItems = ["DoctorReply": "", "ReviewId": "\(object?.id ?? 0)"] as [String : Any]
        activityIndicator.showLoaderOnWindow()
        WebService.replyproviders(queryItems: queryItems) { (result) in
            DispatchQueue.main.async {
                activityIndicator.hideLoader()
                switch result {
                case .success:
                    NotificationCenter.default.post(name: Notification.Name("reply"), object: nil)
                case .failure(let error):
                    AlertManager.showAlert(type: .custom(error.message))
                }
            }
        }
    }
}
