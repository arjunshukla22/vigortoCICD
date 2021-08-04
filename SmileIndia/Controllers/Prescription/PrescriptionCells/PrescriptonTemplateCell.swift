//
//  PrescriptonTemplateCell.swift
//  SmileIndia
//
//  Created by Arjun  on 13/05/20.
//  Copyright © 2020 Na. All rights reserved.
//

import UIKit

class PrescriptonTemplateCell: UITableViewCell ,ReusableCell{

    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var descLabel: UILabel!
    
    @IBOutlet weak var deleteBtn: UIButton!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    var object: PrescriptionTemplates? {
        didSet {
            self.titleLabel.text = object?.Title
           // self.descLabel.text = object?.Body
           // self.descLabel.text = object?.Body?.replacingOccurrences(of: "<p>", with: "").replacingOccurrences(of: "</p>", with: "")
            self.descLabel.text = object?.Body?.htmlToString
        }
    }
    @IBAction func didtapEdit(_ sender: Any) {
        AlertManager.showAlert(type: .custom("Are you sure to edit this template?"), actionTitle: AlertBtnTxt.okay.localize()) {
            NavigationHandler.pushTo(.addPscrpn(self.object!))
        }
    }
    
}
