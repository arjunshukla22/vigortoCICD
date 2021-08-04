//
//  EAppointmentCell.swift
//  SmileIndia
//
//  Created by Arjun  on 08/04/20.
//  Copyright © 2020 Na. All rights reserved.
//

import UIKit

class EAppointmentCell: UITableViewCell, ReusableCell {

    @IBOutlet weak var emailLabel: UILabel!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var usernameLabel: UILabel!
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var timeLabel: UILabel!
    @IBOutlet weak var reasonLabel: UILabel!
    @IBOutlet weak var ageLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
        titleLabel.text = Authentication.customerType == "Doctor" ? "Member's Name :" :"Doctor's Name :"
        self.selectionStyle = .none
    }
    
        var object: Appointment? {
            didSet {
            timeLabel.text = object?.AppointmentTime
            dateLabel.text = "\(self.getFormattedDateForCell(strDate: object?.AppointmentDateTime?.components(separatedBy: " ").first ?? "", currentFomat: "MM/dd/yyyy", expectedFromat: "dd-MMM-yyyy"))"
            usernameLabel.text = Authentication.customerType == "Doctor" ? object?.MemberName ?? "" : object?.ProviderName ?? ""
                
                ageLabel.text = "\(object?.Age ?? 0)"
                
                var reson1Attributes:[NSAttributedString.Key: Any] = [.font : UIFont.systemFont(ofSize: 13, weight: .semibold)]
                reson1Attributes[.foregroundColor] = #colorLiteral(red: 0.9803921569, green: 0.6392156863, blue: 0.1333333333, alpha: 1)
                let reson2Attributes:[NSAttributedString.Key: Any] = [.font : UIFont.systemFont(ofSize: 13, weight: .regular)]
                let reson = NSAttributedString(string: AppointmentScreenTxt.reason.localize(), attributes:reson1Attributes)
                let resonText = NSAttributedString(string: object?.Reason ?? "", attributes:reson2Attributes)
                let resonFinal = NSMutableAttributedString()
                resonFinal.append(reson)
                resonFinal.append(resonText)
                self.reasonLabel.attributedText = resonFinal
                
                
                if Authentication.customerType == "Doctor" {
                     let test1Attributes:[NSAttributedString.Key: Any] = [.font : UIFont.systemFont(ofSize: 13, weight: .semibold)]
                     let test2Attributes:[NSAttributedString.Key: Any] = [.font : UIFont.systemFont(ofSize: 13, weight: .regular)]
                     let test1 = NSAttributedString(string: AppointmentScreenTxt.emailAt.localize(), attributes:test1Attributes)
                     let test2 = NSAttributedString(string: object?.MemberEmail ?? "", attributes:test2Attributes)
                     let text = NSMutableAttributedString()
                     text.append(test1)
                     text.append(test2)
                     emailLabel.attributedText = text
                     
                 }else {
                     let test1Attributes:[NSAttributedString.Key: Any] = [.font : UIFont.systemFont(ofSize: 13, weight: .semibold)]
                     let test2Attributes:[NSAttributedString.Key: Any] = [.font : UIFont.systemFont(ofSize: 13, weight: .regular)]
                     let test1 = NSAttributedString(string: AppointmentScreenTxt.emailAt.localize(), attributes:test1Attributes)
                     let test2 = NSAttributedString(string: object?.ProviderEmail ?? "", attributes:test2Attributes)
                     let text = NSMutableAttributedString()
                     text.append(test1)
                     text.append(test2)
                     emailLabel.attributedText = text
                 }
            }
        }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

    @IBAction func didtapEnter(_ sender: Any) {
        NavigationHandler.pushTo(.eAppointments(object!))
    }
}
