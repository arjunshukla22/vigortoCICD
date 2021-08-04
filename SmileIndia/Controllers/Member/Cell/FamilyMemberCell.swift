//
//  FamilyMemberCell.swift
//  SmileIndia
//
//  Created by Na on 20/05/19.
//  Copyright © 2019 Na. All rights reserved.
//

import UIKit

class FamilyMemberCell: UITableViewCell, ReusableCell {

    @IBOutlet weak var firstNameLabel: UILabel!
    @IBOutlet weak var dobLabel: UILabel!
    @IBOutlet weak var genderLabel: UILabel!
    @IBOutlet weak var relationLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    var object: FamilyMembers?{
        didSet{
            firstNameLabel.text = object?.FamilyMemberFirstName
            genderLabel.text = object?.Gender
            relationLabel.text = object?.FamilyMemberRelationShip
            dobLabel.text = object?.DOB
        }
    }

}
