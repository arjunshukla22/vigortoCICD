//
//  CommentTVC.swift
//  SmileIndia
//
//  Created by Arjun  on 29/04/21.
//  Copyright © 2021 Na. All rights reserved.
//

import Foundation
import UIKit
import EZSwiftExtensions



class commentTVC : UITableViewCell{
    
   
    
    
    @IBOutlet weak var cellVw: UIView!
    @IBOutlet weak var commentTxtLbl: UILabel!
    @IBOutlet weak var userNameLbl: UILabel!
    @IBOutlet weak var userImg: UIImageView!
    @IBOutlet weak var timeLbl: UILabel!
    @IBOutlet weak var editBtnAction: UIButton!
    @IBOutlet weak var likeBtnAction: UIButton!
    @IBOutlet weak var ReplyBtnOl: UIButton!
    @IBOutlet weak var likeCountLbl: UILabel!{
        didSet{
            likeCountLbl.text = ""
        }
    }
    
    
    // Header Cell Data
   
   // @IBOutlet weak var HeaderLikeBtnOL: UIButton!
    @IBOutlet weak var HeaderCommentBtnOL: UIButton!
    @IBOutlet weak var HeaderShareBtnOL: UIButton!
    
    @IBOutlet weak var HeaderTitleLbl: UILabel!
    @IBOutlet weak var HeaderPost: UILabel!
    
    @IBOutlet weak var editBtnWidth: NSLayoutConstraint!
    
   
    
    @IBOutlet weak var viewReplyHeight: NSLayoutConstraint!
    @IBOutlet weak var viewReplyBtnOL: UIButton!
    override func awakeFromNib() {
        super.awakeFromNib()
        selectionStyle = .none
        self.layer.cornerRadius = 5
         }
  
    
    @IBAction func fbReactionTap(_ sender: Any) {
        if !(Authentication.isUserLoggedIn ?? false) {
            AlertManager.showAlert(type: .custom("Create an account or log in to Vigorto portal to use Vigorto social connection !"), actionTitle: AlertBtnTxt.okay.localize()) {
                NavigationHandler.pushTo(.login)
            }
        }
        else{
             }
        
    }
    @IBOutlet weak var facebookReactionButton: ReactionButton! {
        didSet {
            if !(Authentication.isUserLoggedIn ?? false) {
                AlertManager.showAlert(type: .custom("Create an account or log in to Vigorto portal to use Vigorto social connection !"), actionTitle: AlertBtnTxt.okay.localize()) {
                    NavigationHandler.pushTo(.login)
                }
            }else{
            facebookReactionButton.reactionSelector = ReactionSelector()
            facebookReactionButton.config           = ReactionButtonConfig() {
                $0.iconMarging      = 4
                $0.spacing          = 4
                $0.font             = UIFont(name: "SofiaPro-semibold", size: 14)
                $0.neutralTintColor = UIColor(red: 0.1882, green: 0.1843, blue: 0.1882, alpha: 1.0)
                $0.alignment        = .center
            }
            
         
            print()
            }
            
        }
    }
    
}


class ReplyCommentTVC : UITableViewCell {
    
    @IBOutlet weak var cellVw: UIView!
    @IBOutlet weak var commentTxtLbl: UILabel!
    @IBOutlet weak var userNameLbl: UILabel!
    @IBOutlet weak var userImg: UIImageView!
    @IBOutlet weak var timeLbl: UILabel!
    @IBOutlet weak var editBtnAction: UIButton!
    @IBOutlet weak var likeBtnAction: UIButton!
    @IBOutlet weak var ReplyBtnOl: UIButton!
    @IBOutlet weak var editBtnWidth: NSLayoutConstraint!
    
   

}




