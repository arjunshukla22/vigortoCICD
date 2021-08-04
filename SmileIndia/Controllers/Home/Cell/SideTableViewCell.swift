//
//  SideTableViewCell.swift
//  SmileIndia
//
//  Created by Sakshi on 07/09/20.
//  Copyright © 2020 Na. All rights reserved.
//

import UIKit

class SideTableViewCell: UITableViewCell {

    @IBOutlet weak var SideBarView: UIView!
    @IBOutlet weak var sideBarImg: UIImageView!
    @IBOutlet weak var sideBarLbl: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
