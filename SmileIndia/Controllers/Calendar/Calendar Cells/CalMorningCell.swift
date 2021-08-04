//
//  CalMorningCell.swift
//  SmileIndia
//
//  Created by Arjun  on 24/04/20.
//  Copyright © 2020 Na. All rights reserved.
//

import UIKit

class CalMorningCell: UITableViewCell , ReusableCell{

    @IBOutlet weak var mcntView: UIView!
    @IBOutlet weak var mslotLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    var object: MorningTimeSlots? {
        didSet {
            mslotLabel.textColor = (object?.IsClosedDate ?? 0) == 0  ? .white :  .themeGreen
            mcntView.backgroundColor = (object?.IsClosedDate ?? 0) == 0  ?  .themeGreen : .white
            mslotLabel.text = object?.Time
        }
    }
    
    var select =  Bool() {
        didSet {
            mcntView.backgroundColor = select ? .themeGreen : .white
            mslotLabel.textColor = select ?  .white :  .themeGreen
        }
    }
}
