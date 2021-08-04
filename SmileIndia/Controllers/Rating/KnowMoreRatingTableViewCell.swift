//
//  KnowMoreRatingTableViewCell.swift
//  SmileIndia
//
//  Created by Sakshi on 13/10/20.
//  Copyright © 2020 Na. All rights reserved.
//

import UIKit
class KnowMoreRatingTableViewCell: UITableViewCell, ReusableCell {

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
    var object: Appointment? {
        didSet {
            nameLabel.text = object?.MemberName
            dateLabel.text = "\(object?.CreatedDate ?? "Date missing")"
            reviewLabel.text = object?.Review
            ratingView.rating = Int(object?.Rating ?? "0") ?? 0
           }
    }

   
    
}

