//
//  DoctorCell.swift
//  SmileIndia
//
//  Created by Na on 18/02/19.
//  Copyright © 2019 Na. All rights reserved.
//


import UIKit
import MapKit
import SDWebImage
import MarqueeLabel
import EZSwiftExtensions


class HeaderSocioProfile : UITableViewCell {
    
    @IBOutlet weak var displayImageView: UIImageView!
    @IBOutlet weak var displayImgBtn: UIButton!
    @IBOutlet weak var coverImageView: UIImageView!
    @IBOutlet weak var coverImageBtn: UIButton!
    @IBOutlet weak var profileName: UILabel!
    @IBOutlet weak var friendsCollectionView: UICollectionView!
    @IBOutlet weak var viewforMyProfile: UIView!
    @IBOutlet weak var viewforOthersProfile: UIView!
    @IBOutlet weak var statusLabel: UILabel!
    @IBOutlet weak var aboutLabel: UILabel!
    @IBOutlet weak var studyLabel: UILabel!
    @IBOutlet weak var homeLabel: UILabel!
    @IBOutlet weak var locationLabel: UILabel!
    @IBOutlet weak var socioAbout: UIImageView!
    @IBOutlet weak var socioAddress: UIImageView!
    @IBOutlet weak var socioCity: UIImageView!
    
    @IBOutlet weak var sociosp: UIImageView!
    @IBOutlet weak var shareBtn: UIButton!
    
    @IBOutlet weak var addfriendBtn: UIButton!
    @IBOutlet weak var BlockBtn: UIButton!
    @IBOutlet weak var sSpecialityImgHeight: NSLayoutConstraint!
    @IBOutlet weak var sAboutImgHeight: NSLayoutConstraint!
    
    lazy var picker: CustomImagePicker = {
        let imagePicker = CustomImagePicker()
        imagePicker.handler = { [self] in
            self.coverImageView.isHidden = false
            let size = CGSize(width: 450, height: 180)
            self.coverImageView.image = $0.crop(to: size)
            let frontsize = self.coverImageView.image?.size
            print("front image size")
            
            
            
        }
        return imagePicker
    }()
    lazy var picker2: CustomImagePicker = {
        let imagePicker = CustomImagePicker()
        imagePicker.handler = { [self] in
            let size = CGSize(width: 350, height: 350)
            self.displayImageView.image = $0.crop(to: size)
            
            print("self.imageArray.count")
            
            
        }
        return imagePicker
    }()
    var socioUser: SocioData? {
        didSet{
            setView()
            
            if Authentication.customerGuid == socioUser?.ProviderId{
                viewforOthersProfile.isHidden = true
                viewforMyProfile.isHidden = false
                
            }
            else{
                viewforOthersProfile.isHidden = false
                viewforMyProfile.isHidden = true
            }
            
            
            
//            pending - 1 -  Fr Sent --- Cancel
//            Confirmed- 2 - Unfriend -- Block
//            Block - 3 - Unblock
//            Add Friend - 0 - Add friend - cancel
            
            switch socioUser?.Status {
            case EnumFriendType.NoFriend:
                addfriendBtn.setTitle(socioFndBtnTitle.AddFriend, for: .normal)
                BlockBtn.setTitle(socioFndBtnTitle.Block, for: .normal)
                break
                
            case EnumFriendType.Pending:
                
                print("Specifier ID:- \(/socioUser?.SpecifierId)")
                
                if /socioUser?.SpecifierId > 0  {
                    addfriendBtn.setTitle(socioFndBtnTitle.AcceptFriendReq, for: .normal)
                }else{
                    addfriendBtn.setTitle(socioFndBtnTitle.CancelFriendReq, for: .normal)
                }
                
                BlockBtn.setTitle(socioFndBtnTitle.Block, for: .normal)
                break
                
            case EnumFriendType.Confirmed:
                addfriendBtn.setTitle(socioFndBtnTitle.Friend, for: .normal)
                BlockBtn.setTitle(socioFndBtnTitle.Block, for: .normal)
                break
                
            case EnumFriendType.Block:
                addfriendBtn.isHidden = true
                BlockBtn.setTitle(socioFndBtnTitle.UnBlock, for: .normal)
                break
            default:
                
                break
            }
        
            friendsCollectionView.reloadData()
        }
    }
    

    @IBAction func didTapCoverImageButton(_ sender: Any) {
        picker.showOptions()
        
    }
    
    @IBAction func didTapAddFriend(_ sender: Any) {
        print("tapped")
    }
    @IBAction func didTapDisplayImageButton(_ sender: Any) {
        picker2.showOptions()
    }
    
    func setView(){
        
        coverImageView.layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner]
        profileName.text = socioUser?.ProviderName
        statusLabel.text = socioUser?.Practice
        if socioUser?.Practice ?? "" == ""{
            sociosp.isHidden = true
            
            sSpecialityImgHeight.constant = 0
        }
        else{
            sociosp.isHidden = false
            sociosp.image = #imageLiteral(resourceName: "sociodegree")
            studyLabel.isHidden = false
            sSpecialityImgHeight.constant = 20
        }
        if socioUser?.TellAboutYourSelf ?? "" == "" {
            
            socioAbout.isHidden = true
            sAboutImgHeight.constant = 0
        }
        else{
            aboutLabel.isHidden = false
            
            socioAbout.isHidden = false
            socioAbout.image = #imageLiteral(resourceName: "sociObus")
            sAboutImgHeight.constant = 20
            aboutLabel.text = socioUser?.TellAboutYourSelf ?? ""
        }
        studyLabel.text = socioUser?.Practice
        homeLabel.text = "\(socioUser?.Address1 ?? ""),\(socioUser?.Address2 ?? "")"
        locationLabel.text = "\(socioUser?.CityName ?? ""),\(socioUser?.StateName ?? "")"
        DispatchQueue.main.async {
            self.displayImageView.sd_setImage(with: self.socioUser?.imageURL, placeholderImage: UIImage.init(named: "i"))
            
            self.coverImageView.sd_setImage(with: self.socioUser?.imageURL, placeholderImage: UIImage.init(named: "i"))
            
        }
        
    }
    
}



class feedCell: UITableViewCell , ReusableCell, TagListViewDelegate{
    
    
    @IBOutlet weak var nameLabel: UILabel!
    
    @IBOutlet weak var tagListView: TagListView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var shareBtn: UIButton!
    @IBOutlet weak var borderView: UIView!
    @IBOutlet weak var dpImage: UIImageView!
    
    
    @IBOutlet weak var commentBtn: UIButton!
    @IBOutlet weak var settingsButton: UIButton!
    @IBOutlet weak var likeCountLabel: UILabel!
    @IBOutlet weak var viewMore: UIButton!
    @IBOutlet weak var likeBtn: UIButton!
    @IBOutlet weak var timeLabel: UILabel!
    @IBOutlet weak var degreeNameLabel: UILabel!
    @IBOutlet weak var postBodyLabel: UILabel!
    
    @IBOutlet weak var feedImg: UIImageView!
    
    @IBOutlet weak var commentBtnOL: UIButton!
    var youLike : Bool?
    var btnReaction: UIButton!
    var isLabelAtMaxHeight = true
    var AddLikePostModelData : AddLikePostModel?
    override func awakeFromNib() {
        super.awakeFromNib()
        selectionStyle = .none
        self.layer.cornerRadius = 5
        borderView.layer.masksToBounds = true
        borderView.layer.cornerRadius = 5
        borderView.layer.borderWidth = 2
        borderView.layer.shadowOffset = CGSize(width: -1, height: 1)
        borderView.layer.borderColor = UIColor.init(red: 240/255, green: 240/255, blue: 240/255, alpha: 1.0).cgColor
        tagListView.delegate = self
        facebookReactionButton.addLongPressGesture { (tap) in
            print("Long Press Detect")
            if !(Authentication.isUserLoggedIn ?? false) {
                AlertManager.showAlert(type: .custom("Create an account or log in to Vigorto portal to use Vigorto social connection !"), actionTitle: AlertBtnTxt.okay.localize()) {
                    NavigationHandler.pushTo(.login)
                }}else{
                    self.facebookReactionButton.presentReactionSelector()
                }}
        facebookReactionButton.addTapGesture { (tap) in
            if !(Authentication.isUserLoggedIn ?? false) {
                AlertManager.showAlert(type: .custom("Create an account or log in to Vigorto portal to use Vigorto social connection !"), actionTitle: AlertBtnTxt.okay.localize()) {
                    NavigationHandler.pushTo(.login)
                }}
            else{
                if self.facebookReactionButton.isSelected == false {
                    self.facebookReactionButton.reaction   = Reaction.facebook.like
                    self.facebookReactionButton.config     = ReactionButtonConfig() {
                        $0.iconMarging      = 4
                        $0.spacing          = 4
                        $0.font             = UIFont(name: "HelveticaNeue", size: 12)
                        $0.neutralTintColor = .systemBlue
                        $0.alignment        = .center
                    }
                    self.facebookReactionButton.isSelected = true
                }else{
                    self.facebookReactionButton.reaction   = Reaction.facebook.like
                    self.facebookReactionButton.config     = ReactionButtonConfig() {
                        $0.iconMarging      = 4
                        $0.spacing          = 4
                        $0.font             = UIFont(name: "HelveticaNeue", size: 12)
                        $0.neutralTintColor = .systemGray
                        $0.alignment        = .center
                    }
                    self.facebookReactionButton.isSelected = false
                }
                self.likeApi()
            }}}
    
    @IBOutlet weak var reactionSummary: ReactionSummary! {
        didSet {
            reactionSummary.reactions = Reaction.facebook.few
            if object?.CustomerLikeStatus == 0{
                youLike = false
            }
            else{
                youLike = true
            }
            reactionSummary.setDefaultText(withTotalNumberOfPeople: /object?.BlogLikeCount, includingYou: /youLike)
            reactionSummary.config    = ReactionSummaryConfig {
                $0.spacing      = 8
                $0.iconMarging  = 2
                $0.font         = UIFont(name: "HelveticaNeue", size: 12)
                $0.textColor    = UIColor(red: 0.47, green: 0.47, blue: 0.47, alpha: 1)
                $0.alignment    = .left
                $0.isAggregated = true
            }
        }
    }
    
    
    
    
    @IBAction func didTapViewMore(_ sender: Any) {
        
        
        if isLabelAtMaxHeight {
            viewMore.setTitle("View Less", for: .normal)
            isLabelAtMaxHeight = false
            postBodyLabel.numberOfLines = 0
            
            
        }
        else {
            viewMore.setTitle("View More", for: .normal)
            isLabelAtMaxHeight = true
            postBodyLabel.numberOfLines = 10
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
                    
                    if(Device.IS_IPHONE){
                        $0.font             = UIFont(name: "SofiaPro-semibold", size: 13)
                    }
                    else{
                        
                        $0.font             = UIFont(name: "SofiaPro-semibold", size: 16)
                    }
                    $0.neutralTintColor = UIColor(red: 0.1882, green: 0.1843, blue: 0.1882, alpha: 1.0)
                    $0.alignment        = .center
                }
                
                facebookReactionButton.reactionSelector?.feedbackDelegate = self
                print()
            }
            
        }
    }
    
    // Actions
    
    
    @IBOutlet weak var feedbackLabel: UILabel! {
        didSet {
            feedbackLabel.isHidden = true
        }
    }
    
    @IBAction func facebookButtonReactionTouchedUpAction(_ sender: AnyObject) {
        
        
        
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
    @IBAction func facebookButtonReactionToucedUpAction(_ sender: Any) {
        if facebookReactionButton.isSelected == false {
            
            facebookReactionButton.reaction   = Reaction.facebook.like
            
        }
        else{
            facebookReactionButton.isSelected = false
        }
        
    }
    
    func likeApi(){
       // print(/object?.Id)
        
        let addPostLikeParams : [String:Any] = ["CustomerId":/Authentication.customerId,
                                                "BlogId": /object?.Id,
                                                "Status":4]
        
        print(addPostLikeParams)
        WebService.AddPostLikeStatus(queryItems: addPostLikeParams) { (result) in
            DispatchQueue.main.async {
                switch result {
                case .success(let response):
                    print("liked")
                    self.AddLikePostModelData = response.object
                  //  print(response.message)
                    
                    
                case .failure(let error):
                    
                    print(error)
                    print("error")
                    AlertManager.showAlert(type: .custom(error.message))
                    
                }
            }}}
    
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    
    var object: ListPost? {
        didSet {
            // settings button
            
            if Authentication.customerId ?? "" == String(object?.CustomerId ?? 0){
                settingsButton.isHidden = false
            }else{
                settingsButton.isHidden = true
            }
            if object?.CustomerLikeStatus == 1{
                facebookReactionButton.reaction   = Reaction.facebook.like
            }
            else if object?.CustomerLikeStatus == 2{
                facebookReactionButton.reaction   = Reaction.facebook.love
            }
            else if object?.CustomerLikeStatus == 3{
                facebookReactionButton.reaction   = Reaction.facebook.care
            }
            else if object?.CustomerLikeStatus == 4{
                facebookReactionButton.reaction   = Reaction.facebook.haha
            }
            else if object?.CustomerLikeStatus == 5{
                facebookReactionButton.reaction   = Reaction.facebook.surprise
            }
            else if object?.CustomerLikeStatus == 6{
                facebookReactionButton.reaction   = Reaction.facebook.sad
            }
            else if object?.CustomerLikeStatus == 7{
                facebookReactionButton.reaction   = Reaction.facebook.wow
            }
            else if object?.CustomerLikeStatus == 8{
                facebookReactionButton.reaction   = Reaction.facebook.angry
            }
            // number of likes lable
            
            if /object?.BlogLikeCount > 0 {
                reactionSummary.isHidden = false
                //   likeCountLabel.isHidden = false
                //  reactionSummary.setDefaultText(withTotalNumberOfPeople: /object?.BlogLikeCount, includingYou: true)
                if object?.BlogLikeCount == 1 {
                    likeCountLabel.text = " 1 Like"
                }else{
                    likeCountLabel.text = "\(object?.BlogLikeCount ?? 0) \("Likes")"
                }
                
            }else{
                likeCountLabel.isHidden = true
                reactionSummary.isHidden = true
            }
            
            
            let bodytext = object?.Username
            nameLabel.text = object?.Username
            
            var liness = bodytext?.components(separatedBy: CharacterSet.newlines)
            if object?.SpecialityName == nil || object?.DegreeName == nil{
                degreeNameLabel.isHidden = true
            }else{
                degreeNameLabel.isHidden = false
                degreeNameLabel.text = "\(object?.SpecialityName ?? ""), \(object?.DegreeName ?? "")"
            }
            timeLabel.text = object?.CreatedOnUtcString
            titleLabel.text = object?.Title
            
            feedImg.sd_setImage(with: object?.profileImageURL, placeholderImage: UIImage.init(named: "doctor-avtar"))
         //   print(object?.profileImageURL)
            
            
            nameLabel.text = object?.Username ?? ""
            let list = object?.Category ?? ""
        }
    }
    
    
}

extension feedCell: ReactionFeedbackDelegate {
    func reactionFeedbackDidChanged(_ feedback: ReactionFeedback?) {
        
    }
}
extension UILabel {
    func calculateMaxLines() -> Int {
        let maxSize = CGSize(width: frame.size.width, height: CGFloat(Float.infinity))
        let charSize = font.lineHeight
        let text = (self.text ?? "") as NSString
        let textSize = text.boundingRect(with: maxSize, options: .usesLineFragmentOrigin, attributes: [NSAttributedString.Key.font: font], context: nil)
        let linesRoundedUp = Int(ceil(textSize.height/charSize))
        return linesRoundedUp
    }
}


