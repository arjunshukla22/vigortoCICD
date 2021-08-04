//
//  AddNewMemberCell.swift
//  SmileIndia
//
//  Created by Na on 19/05/19.
//  Copyright © 2019 Na. All rights reserved.
//

import UIKit

class AddNewMemberCell: UITableViewCell, ReusableCell {

    @IBOutlet weak var firstNameLabel: UILabel!
     @IBOutlet weak var lastNameLabel: UILabel!
     @IBOutlet weak var dobLabel: UILabel!
     @IBOutlet weak var genderLabel: UILabel!
    @IBOutlet weak var relationLabel: UILabel!
    typealias DeletionHandler = ()->()
    var handler : DeletionHandler?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    var object: [String: Any]?{
        didSet{
            firstNameLabel.text = object?["FamilyMemberFirstName"] as? String
            lastNameLabel.text = object?["FamilyMemberLastName"] as? String
            dobLabel.text = object?["DOB"] as? String
        }
    }

    @IBAction func didTapDeleteButton(_ sender: Any) {
        handler?()
    }
}
