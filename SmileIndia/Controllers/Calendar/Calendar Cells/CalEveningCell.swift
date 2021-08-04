//
//  CalEveningCell.swift
//  SmileIndia
//
//  Created by Arjun  on 24/04/20.
//  Copyright © 2020 Na. All rights reserved.
//

import UIKit

class CalEveningCell: UITableViewCell , ReusableCell{
    
    
    @IBOutlet weak var ecntView: UIView!
    @IBOutlet weak var eslotLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    var object: EveningTimeSlots? {
        didSet {
            eslotLabel.textColor = (object?.IsClosedDate ?? 0) == 0  ?  .white :  .themeGreen
            ecntView.backgroundColor = (object?.IsClosedDate ?? 0) == 0  ?  .themeGreen : .white

            eslotLabel.text = object?.Time
        }
    }
    
    var select =  Bool() {
        didSet {
            ecntView.backgroundColor = select ? .themeGreen : .white
            eslotLabel.textColor = select ?  .white :  .themeGreen
        }
    }

}
