//
//  CreditsCell.swift
//  SmileIndia
//
//  Created by Sakshi Gothi on 19/12/20.
//  Copyright © 2020 Na. All rights reserved.
//

import UIKit

class CreditsCell: UITableViewCell ,ReusableCell{

    @IBOutlet weak var reasonLabel: UILabel!
    @IBOutlet weak var amountLabel: UILabel!
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var snoLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    var object: CreditHistory? {
            didSet {
                self.reasonLabel.text = self.object?.ReasonDescription ?? ""
                self.amountLabel.text = "$ \(self.object?.Amount ?? 0)\(".0")"
                self.dateLabel.text = self.object?.Date ?? ""
                self.snoLabel.text = "\(CreditsInfoScreenTxt.SrNo.localize()) \(self.object?.SrNo ?? 0)"
            }
        }
}




