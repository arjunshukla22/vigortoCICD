//
//  FriendSugList.swift
//  SmileIndia
//
//  Created by Sakshi Gothi on 19/05/21.
//  Copyright © 2021 Na. All rights reserved.
//



import UIKit
enum Actionfrindssug {
    case pending
    case confirm
    case rating
    case none
}
class FriendSugList: UITableViewCell, ReusableCell {
    
    
    var selectedIndex = 0
    var  refundOptions: RefundOptions?
    @IBOutlet weak var profileImage: UIImageView!
    @IBOutlet weak var profileName: UILabel!
    
    
    
    typealias Handler = (Actionfrindssug)->()
    var handler: Handler?
    var index = 1
    var appid = ""
    var  prescriptionData: DrPrescription?
    var drPrescription = ""
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.selectionStyle = .none
        // Initialization code
       
        }
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
  
}
