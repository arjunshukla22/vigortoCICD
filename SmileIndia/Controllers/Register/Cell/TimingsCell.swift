//
//  TimingsCell.swift
//  SmileIndia
//
//  Created by Na on 17/02/19.
//  Copyright © 2019 Na. All rights reserved.
//

import UIKit

class TimingsCell: UITableViewCell , ReusableCell{

    @IBOutlet weak var tickImageView: UIImageView!
    @IBOutlet weak var dayLabel: UILabel!
    @IBOutlet weak var startTimeTextfield: CustomTextfield!
    @IBOutlet weak var endTimeTextfield: CustomTextfield!
    var isMorning = true
    override func awakeFromNib() {
        super.awakeFromNib()
        selectionStyle = .none
        // Initialization code
        
        
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        // Configure the view for the selected state
    }

    var object: BusinessHour?{
        didSet{
            startTimeTextfield.array = isMorning ? object?.MorningStart ?? [] : object?.EveningStart ?? []
            endTimeTextfield.array = isMorning ? object?.MorningEnd ?? [] : object?.EveningEnd ?? []
        }
    }
}
