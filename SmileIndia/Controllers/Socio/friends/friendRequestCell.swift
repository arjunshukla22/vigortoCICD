//
//  friendRequestCell.swift
//  SmileIndia
//
//  Created by Sakshi Gothi on 19/05/21.
//  Copyright © 2021 Na. All rights reserved.
//


import UIKit

class friendRequestCell: UITableViewCell, ReusableCell {
    
    @IBOutlet weak var profileImg: UIImageView!
    @IBOutlet weak var profileName: UILabel!
    
    
   
   
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.selectionStyle = .none
        // Initialization code
       
        }
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
  
}
