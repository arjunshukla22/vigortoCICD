//
//  SeeTimingsCell.swift
//  SmileIndia
//
//  Created by Arjun  on 27/04/20.
//  Copyright © 2020 Na. All rights reserved.
//

import UIKit

class SeeTimingsCell: UITableViewCell, ReusableCell {
    
    
    @IBOutlet weak var viewDay: UIView!
    @IBOutlet weak var dayLabel: UILabel!
    @IBOutlet weak var mrngtimingsLabel: UILabel!
    @IBOutlet weak var evngTimingsLabel: UILabel!
    

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    var object: AddressTiming? {
        didSet {
           dayLabel.text = (self.object?.DayMasters?.Name ?? "").uppercased()
            mrngtimingsLabel.text = "\(object?.MorningTimeStart?.Timing ?? "")-\(object?.MorningTimeEnd?.Timing ?? "")"
            evngTimingsLabel.text = "\(object?.EveningTimeStart?.Timing ?? "")-\(object?.EveningTimeEnd?.Timing ?? "")"
        }
    }
    var object1: Doctor? {
        didSet {
           // dayLabel.text = (self.object1?.AvailableTimeZoneMsg ?? "")
           
        }
    }
}
//self.getFormattedDateForCell(strDate: self.object?.DayMasters?.Name ?? "", currentFomat: "EEE", expectedFromat: "EEEE")
