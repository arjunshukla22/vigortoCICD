//
//  CommentPostVC.swift
//  SmileIndia
//
//  Created by Arjun  on 01/04/21.
//  Copyright © 2021 Na. All rights reserved.
//

import UIKit
import ParallaxHeader
import IQKeyboardManager
import EZSwiftExtensions
import Toaster

enum ShowHideEnum {
    
    static let viewReply = "View More Reply"
    static let hideReply = "Hide Reply"
}

class CommentPostVC: UIViewController {
    
    var editcommentID = 0
    var replyCommentID = -1
    var CommentPageIndex = 0
    var recBlog : ListPost?
    var isNewDataLoading = false
    
    var idArr = [Int]()
    
    var AddLikePostModelData : AddLikePostModel?
    
    var commentDeleteModelData : CommentDeleteModel?
    
    var commentCountStr = "" {
        didSet{
            self.mainTblVw.reloadData()
        }
    }
    
    
    override var canBecomeFirstResponder: Bool {
        return true
    }
    
    var customInputView: UIView!
    var sendButton: UIButton!
    //  var addMediaButtom: UIButton!
    var textField = FlexibleTextView()
    
    @IBOutlet weak var mainTblVw: UITableView!
    @IBOutlet weak var tableViewBottomLayoutConstraint: NSLayoutConstraint!
    
    
    // header view
    
    @IBOutlet weak var HeaderVw: UIView!
    @IBOutlet weak var HeaderMoreBtnOL: UIButton!
    @IBOutlet weak var HeaderuserImg: UIImageView!
    @IBOutlet weak var HeaderuserNameLbl: UILabel!
    @IBOutlet weak var HeaderTimeNameLbl: UILabel!
    
    
    var commentArr = [CommentModel]()
    
    override var inputAccessoryView: UIView? {
        
        if customInputView == nil {
            customInputView = CustomView()
            customInputView.backgroundColor = UIColor.groupTableViewBackground
            textField.placeholderTxt = "Write a comment"
            textField.delegate = self
            textField.font = .systemFont(ofSize: 15)
            textField.layer.cornerRadius = 5
            
            customInputView.autoresizingMask = .flexibleHeight
            
            customInputView.addSubview(textField)
            
            sendButton = UIButton(type: .system)
            sendButton.isEnabled = false
            sendButton.titleLabel?.font = UIFont.systemFont(ofSize: 16)
           // sendButton.setTitle("Send", for: .normal)
            sendButton.setTitleColor(UIColor.lightGray, for: .normal)
            sendButton.contentEdgeInsets = UIEdgeInsets(top: 8, left: 8, bottom: 8, right: 8)
            sendButton.addTarget(self, action: #selector(handleSend), for: .touchUpInside)
            customInputView?.addSubview(sendButton)
            
            //                addMediaButtom = UIButton(type: .custom)
            //              //  addMediaButtom.setImage(UIImage(imageLiteralResourceName: "addImage").withRenderingMode(.alwaysTemplate), for: .normal)
            //                addMediaButtom.isEnabled = true
            //                addMediaButtom.titleLabel?.font = UIFont.systemFont(ofSize: 16)
            //              //  addMediaButtom.setTitle(AlertBtnTxt.cancel.localize(), for: .normal)
            //                addMediaButtom.contentEdgeInsets = UIEdgeInsets(top: 9, left: 0, bottom: 5, right: 0)
            //                addMediaButtom.addTarget(self, action: #selector(handleSend), for: .touchUpInside)
            //                customInputView?.addSubview(addMediaButtom)
            
            textField.translatesAutoresizingMaskIntoConstraints = false
            sendButton.translatesAutoresizingMaskIntoConstraints = false
            //    addMediaButtom.translatesAutoresizingMaskIntoConstraints = false
            sendButton.setContentHuggingPriority(UILayoutPriority(rawValue: 1000), for: NSLayoutConstraint.Axis.horizontal)
            sendButton.setContentCompressionResistancePriority(UILayoutPriority(rawValue: 1000), for: NSLayoutConstraint.Axis.horizontal)
            
            //                addMediaButtom.setContentHuggingPriority(UILayoutPriority(rawValue: 1000), for: NSLayoutConstraint.Axis.horizontal)
            //                addMediaButtom.setContentCompressionResistancePriority(UILayoutPriority(rawValue: 1000), for: NSLayoutConstraint.Axis.horizontal)
            
            textField.maxHeight = 80
            
            //                addMediaButtom.leadingAnchor.constraint(
            //                    equalTo: customInputView.leadingAnchor,
            //                    constant: 8
            //                    ).isActive = true
            //
            //                addMediaButtom.trailingAnchor.constraint(
            //                    equalTo: textField.leadingAnchor,
            //                    constant: -8
            //                    ).isActive = true
            //
            //                addMediaButtom.topAnchor.constraint(
            //                    equalTo: customInputView.topAnchor,
            //                    constant: 8
            //                    ).isActive = true
            //
            //                addMediaButtom.bottomAnchor.constraint(
            //                    equalTo: customInputView.layoutMarginsGuide.bottomAnchor,
            //                    constant: -8
            //                    ).isActive = true
            
            
            textField.leadingAnchor.constraint(
                equalTo: customInputView.leadingAnchor,
                constant: 8
            ).isActive = true
            
            textField.trailingAnchor.constraint(
                equalTo: sendButton.leadingAnchor,
                constant: 0
            ).isActive = true
            
            textField.topAnchor.constraint(
                equalTo: customInputView.topAnchor,
                constant: 8
            ).isActive = true
            
            textField.bottomAnchor.constraint(
                equalTo: customInputView.layoutMarginsGuide.bottomAnchor,
                constant: -8
            ).isActive = true
            
            sendButton.leadingAnchor.constraint(
                equalTo: textField.trailingAnchor,
                constant: 0
            ).isActive = true
            
            sendButton.trailingAnchor.constraint(
                equalTo: customInputView.trailingAnchor,
                constant: -8
            ).isActive = true
            
            sendButton.bottomAnchor.constraint(
                equalTo: customInputView.layoutMarginsGuide.bottomAnchor,
                constant: -8
            ).isActive = true
        }
        return customInputView
    }
    
    @objc func handleSend() {
      //  print("works")
        
        let CommentsTxtFld = textField.text
       // print("CommentsTxtFld",CommentsTxtFld)
        
        if CommentsTxtFld != "" {
            
            customInputView.isHidden = true
            
            sendButton.setTitle("", for: .normal)
            sendButton.isEnabled = false
            sendButton.setTitleColor(UIColor.lightGray, for: .normal)
            textField.resignFirstResponder()
            
            // Show Loader
            ShowLoader()
            
            // Call Add Post Text
            self.AddBlogPostCommentApiHit()
            
        }
        
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Comment Count
        commentCountStr = /recBlog?.BlogCommentCount?.toString
        
        HeaderuserNameLbl.text = /recBlog?.Username
        HeaderTimeNameLbl.text = /recBlog?.CreatedOnUtcString
       
        HeaderuserImg.sd_setImage(with: recBlog?.profileImageURL , completed: nil)
        
        HeaderMoreBtnOL.isHidden = /Authentication.customerId != /recBlog?.CustomerId?.toString ? true : false
        
        hideKeyboardWhenTappedAround()
        IQKeyboardManager.shared().isEnabled = false
        IQKeyboardManager.shared().shouldShowToolbarPlaceholder = false
        self.mainTblVw.keyboardDismissMode = .interactive
        
        //  self.navigationController?.navigationBar.barStyle = UIBarStyle.black
        
        navigationController?.navigationBar.barTintColor = UIColor.white
        self.navigationController?.setNavigationBarHidden(true, animated: true)
        
        textField.delegate = self
        mainTblVw.delegate = self
        
        self.GetBlogPostCommentsApiHit()
        
//        addBackButton()
        
        
        
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWasShown), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide), name: UIResponder.keyboardWillHideNotification, object: nil)
        
        
        
    }
    
    @objc func keyboardWasShown(notification: NSNotification) {
        let info = notification.userInfo!
        let keyboardFrame: CGRect = (info[UIResponder.keyboardFrameEndUserInfoKey] as! NSValue).cgRectValue
        
        UIView.animate(withDuration: 0.1, animations: { () -> Void in
            self.tableViewBottomLayoutConstraint.constant = keyboardFrame.size.height-20
            self.view.layoutIfNeeded()
        })
    }
    
    
    @objc func keyboardWillHide(sender: NSNotification) {
        // self.view.frame.origin.y = 0
        self.tableViewBottomLayoutConstraint.constant = 0
    }
    
    func addBackButton() {
        let backButton = UIButton(type: .roundedRect)
        backButton.setImage(UIImage(named:  "backblack"), for: .normal) // Image can be downloaded from here below link
        backButton.imageView?.tintColor = UIColor.black
        backButton.titleLabel?.lineBreakMode = .byTruncatingTail
        backButton.setTitle("   Comments", for: .normal)
        backButton.tintColor = UIColor.black
        //  backButton.titleLabel?.font =  UIFont(name: Fonts.NunitoSans.Bold, size: 16)
        backButton.setTitleColor(backButton.tintColor, for: .normal) // You can change the TitleColor
        backButton.addTarget(self, action: #selector(self.backAction(_:)), for: .touchUpInside)
        self.navigationController?.navigationBar.backgroundColor = UIColor.black
        self.navigationItem.leftBarButtonItem = UIBarButtonItem(customView: backButton)
        self.navigationItem.leftBarButtonItem?.tintColor = UIColor.white
    }
    
    @objc func backAction(_ sender: UIButton) {
        self.navigationController?.popViewController(animated: true)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    
        UIApplication.shared.statusBarStyle = .default
        
        
    }
    

    @IBAction func backBtnAction(_ sender: Any) {
        IQKeyboardManager.shared().isEnabled = true
        IQKeyboardManager.shared().shouldShowToolbarPlaceholder = false
        self.navigationController?.setNavigationBarHidden(true, animated: true)
        
        UIApplication.shared.statusBarStyle = .lightContent
        self.navigationController?.popViewController(animated: true)
    }
    
    
    @IBAction func MoreBtnAction(_ sender: Any) {
        print("Main MoreBtn Action")
    }

}

extension CommentPostVC : UITableViewDelegate,UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        
        let headerCell = tableView.dequeueReusableCell(withIdentifier: "HeaderComment") as! commentTVC
        
        headerCell.HeaderTitleLbl.text = /recBlog?.Title
        headerCell.HeaderPost.text = /recBlog?.Body?.htmlToString
        
        // Header Like Btn OL
      //  headerCell.HeaderLikeBtnOL.tag = section
//        headerCell.HeaderLikeBtnOL.addTarget(self,action:#selector(self.BlogLikeButtonClicked),for:.touchUpInside)
//        
        // Header Like Btn OL
        var commentStr = ""
    
        if /commentCountStr.toInt() > 0 {
            commentStr = /commentCountStr.toInt() > 1 ? "   \(/commentCountStr)  Comments" : "   \(/commentCountStr)  Comment"
            headerCell.HeaderCommentBtnOL.setTitle(commentStr, for: .normal)
        }
        
        headerCell.HeaderCommentBtnOL.tag = section
        headerCell.HeaderCommentBtnOL.addTarget(self,action:#selector(self.BlogCommentButtonClicked),for:.touchUpInside)
        
        return headerCell.contentView
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return /self.commentArr.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let commentDic : CommentModel? = self.commentArr[indexPath.row]
        
        if /commentDic?.commentID > 0 {
            // Comment Reply Cell
            let cell = tableView.dequeueReusableCell(withIdentifier: "ReplyCommentTVC", for: indexPath as IndexPath) as! ReplyCommentTVC
            
            cell.commentTxtLbl.text = /commentDic?.commentText?.htmlToString
            cell.userNameLbl.text = /commentDic?.username
            cell.timeLbl.text = /commentDic?.commentTimeAgo
            
            cell.editBtnAction.tag = indexPath.row
            cell.editBtnAction.addTarget(self,action:#selector(self.editButtonClicked),for:.touchUpInside)
//
//
//            cell.likeBtnAction.tag = indexPath.row
//            cell.likeBtnAction.addTarget(self,action:#selector(self.CommentLikeBtnClicked),for:.touchUpInside)
//
//            cell.ReplyBtnOl.tag = indexPath.row
//            cell.ReplyBtnOl.addTarget(self,action:#selector(self.ReplyBtnClicked),for:.touchUpInside)
        
            cell.editBtnAction.isHidden = /Authentication.customerId != /commentDic?.customerID?.toString ? true : false
            cell.editBtnWidth.constant = /Authentication.customerId != /commentDic?.customerID?.toString ? 0 : 27
            
            if let imgurl = URL.init(string: /commentDic?.profileImage) {
                cell.userImg.sd_setImage(with:imgurl  , completed: nil)
            }

            return cell
        }else{
            // Comment Dic
            let cell = tableView.dequeueReusableCell(withIdentifier: "commentTVC", for: indexPath as IndexPath) as! commentTVC
            
            cell.commentTxtLbl.text = /commentDic?.commentText?.htmlToString
            cell.userNameLbl.text = /commentDic?.username
            cell.timeLbl.text = /commentDic?.commentTimeAgo
            
            cell.editBtnAction.tag = indexPath.row
            cell.editBtnAction.addTarget(self,action:#selector(self.editButtonClicked),for:.touchUpInside)
            
            
            cell.likeBtnAction.tag = indexPath.row
            cell.likeBtnAction.addTarget(self,action:#selector(self.CommentLikeBtnClicked),for:.touchUpInside)
            
            
          //  cell.ReplyBtnOl.tag = indexPath.row
            cell.ReplyBtnOl.tag = /commentDic?.id
            cell.ReplyBtnOl.addTarget(self,action:#selector(self.ReplyBtnClicked),for:.touchUpInside)
        
            cell.editBtnAction.isHidden = /Authentication.customerId != /commentDic?.customerID?.toString ? true : false
            cell.editBtnWidth.constant = /Authentication.customerId != /commentDic?.customerID?.toString ? 0 : 27
            
            if let imgurl = URL.init(string: /commentDic?.profileImage) {
                cell.userImg.sd_setImage(with:imgurl  , completed: nil)
            }
            

            cell.viewReplyHeight.constant = commentDic?.commentRepliesList?.count != 0 ? 30 : 0
            
            if /commentDic?.commentRepliesList?.count > 0 {
                if idArr.contains(/commentDic?.id){
                    cell.viewReplyBtnOL.setTitle(ShowHideEnum.hideReply, for: .normal)
                }else{
                    cell.viewReplyBtnOL.setTitle(ShowHideEnum.viewReply, for: .normal)
                }
            }else{
               // cell.viewReplyBtnOL.setTitle(ShowHideEnum.hideReply, for: .normal)
            }
            
            cell.viewReplyBtnOL.tag = /commentDic?.id
            cell.viewReplyBtnOL.addTarget(self,action:#selector(self.HideShowReply),for:.touchUpInside)
            
            return cell
        }
        
    }
    
    @objc func HideShowReply(sender:UIButton){
        
        let replyModel : [CommentModel] = self.commentArr.filter({$0.id == sender.tag})
        if replyModel.count > 0 {
            let indexNo = commentArr.index(of:replyModel.first!)!
            
            if /self.commentArr[indexNo].commentRepliesList?.count > 0 {
                
                let indexPath = IndexPath(row: indexNo, section: 0)
                
                guard let cell = mainTblVw.cellForRow(at: indexPath) as? commentTVC else {
                    return
                }
                
                if sender.currentTitle == ShowHideEnum.viewReply {
                    // Add Id in ID Arr
                    idArr.append(sender.tag)
                  //  print("Add--ID Arr:- \(idArr)")
        
                    // Set Cell button title
                    cell.viewReplyBtnOL.setTitle(ShowHideEnum.hideReply, for: .normal)
                    let indexes = loadReplies(comment: self.commentArr[indexNo], replylist: (self.commentArr[indexNo].commentRepliesList?.reversed())!)
                  //  self.mainTblVw?.beginUpdates()
                    self.mainTblVw?.insertRows(at: indexes, with: .right)
                 //   self.mainTblVw?.endUpdates()
                }else{
                    // Remove Id in ID Arr
                    idArr.removeObject(sender.tag)
                   // print("Remove--ID Arr:- \(idArr)")
                    
                    // Set Cell button title
                    cell.viewReplyBtnOL.setTitle(ShowHideEnum.viewReply, for: .normal)
                    let indexes = hideReplies(comment: self.commentArr[indexNo], replylist: (self.commentArr[indexNo].commentRepliesList?.reversed())!)
                  //  self.mainTblVw?.beginUpdates()
                    self.mainTblVw?.deleteRows(at: indexes, with: .right)
                  //  self.mainTblVw?.endUpdates()
                }
                
            }else{
                print("reply Not exist")
            }
        }else{
            print("Model not exist")
            
        }
    }
    
    /** Loads the replies of the corresponding comment into the list */
    func loadReplies(comment: CommentModel,replylist:[CommentModel]) -> [IndexPath] {
        // Get index of the comment
        let index = commentArr.index(of: comment)!
        
        // Generate replies and insert
        var ips: [IndexPath] = []
        for i in 1 ... replylist.count {
            let r = replylist[i-1]
            commentArr.insert(r, at: index + i)
            ips.append(IndexPath(row: index + i, section: 0))
        }
        return ips
    }
    
    /** Deletes the replies of the corresponding comment into the list */
    func hideReplies(comment: CommentModel,replylist:[CommentModel]) -> [IndexPath] {
        
        // Get index of the comment
        let index = commentArr.index(of: comment)!
        
        // Generate replies and insert
        var ips: [IndexPath] = []
        for i in 1 ... replylist.count {
            commentArr.remove(at: index + 1)
            ips.append(IndexPath(row: index + i, section: 0))
        }
        return ips
    }
    
    
    @objc func ReplyBtnClicked(sender:UIButton){
        
//        let commentDic : CommentModel? = self.commentArr[sender.tag]
//        replyCommentID = /commentDic?.id
        
        replyCommentID = sender.tag
        textField.becomeFirstResponder()
    }
    
    @objc func editButtonClicked(sender:UIButton)
    {
        
        let commentDic : CommentModel? = self.commentArr[sender.tag]
        
        //Create the AlertController and add Its action like button in Actionsheet
        let actionSheetControllerIOS8: UIAlertController = UIAlertController(title: "", message: nil, preferredStyle: .actionSheet)
        
        let EditActionButton = UIAlertAction(title: "Edit", style: .default) { _ in
            
            self.editcommentID = /commentDic?.id
            self.textField.text = /commentDic?.commentText
            self.textField.becomeFirstResponder()
            
        }
        actionSheetControllerIOS8.addAction(EditActionButton)
        
        //        let ReplyActionButton = UIAlertAction(title: "Reply", style: .default)
        //        { _ in
        //            print("Reply")
        //        }
        //        actionSheetControllerIOS8.addAction(ReplyActionButton)
        
        let deleteActionButton = UIAlertAction(title: "Delete", style: .destructive)
        { _ in
            print("Delete")
            
            self.DeleteCommentApiHit(delId: /commentDic?.id)
        }
        actionSheetControllerIOS8.addAction(deleteActionButton)
        
        let CancelActionButton = UIAlertAction(title: AlertBtnTxt.cancel.localize(), style: .cancel)
        { _ in
            print("Cancel")
        }
      //  CancelActionButton.titleTextColor = UIColor.themeGreen
        actionSheetControllerIOS8.addAction(CancelActionButton)
        self.present(actionSheetControllerIOS8, animated: true, completion: nil)
        
    }
    
    @objc func CommentLikeBtnClicked(sender:UIButton)
    {
        let indexPath = IndexPath(row: sender.tag, section: 0)
        let cell = mainTblVw.cellForRow(at: indexPath) as! commentTVC
       
        if cell.likeBtnAction.currentTitleColor == .themeGreen {
            cell.likeBtnAction.setTitleColor(.systemGray, for: .normal)
        }else{
            cell.likeBtnAction.setTitleColor(.themeGreen, for: .normal)
        }
    }
    
    @objc func BlogLikeButtonClicked(sender:UIButton)
    {
        //AddPostLikeStatusApiHit(Status:true)
    }
    
    @objc func BlogCommentButtonClicked(sender:UIButton)
    {
        textField.becomeFirstResponder()
    }
}
extension CommentPostVC : UIScrollViewDelegate {
    func scrollViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate decelerate: Bool) {
        
        //Bottom Refresh
        
        if scrollView == mainTblVw{
            
            if ((scrollView.contentOffset.y + scrollView.frame.size.height) >= scrollView.contentSize.height)
            {
                if !isNewDataLoading{
                    
                    isNewDataLoading = true
                    CommentPageIndex = CommentPageIndex + 1
                    GetBlogPostCommentsApiHit()
                }
            }
        }
    }
}

extension CommentPostVC {
    
    // Get blogs Post Comments
    func AddPostLikeStatusApiHit(Status:Bool){
        
        let addPostLikeParams : [String:Any] = ["CustomerId":/Authentication.customerId,
                                                "BlogId":/recBlog?.Id,
                                                "Status":Status
        ]
        
       // print(addPostLikeParams)
        WebService.AddPostLikeStatus(queryItems: addPostLikeParams) { (result) in
            DispatchQueue.main.async {
                switch result {
                case .success(let response):
                    
                    
                    
                    self.AddLikePostModelData = response.object
                    self.HideLoader()
                    
                case .failure(let error):
                    
                   // print(error)
                    AlertManager.showAlert(type: .custom(error.message))
                    
                }
            }}}
    
    // Get blogs Post Comments
    func GetBlogPostCommentsApiHit(){
        
        let getBlogsParams : [String:Any] = [
            //"CustomerId":/Authentication.customerId,
                                             "blogPostId":/recBlog?.Id,
                                             "CommentPageIndex":CommentPageIndex,
                                             "pageSize":10,
                                             "IsFromApp":true,
                                             "dateFrom":"",
                                             "dateTo":"",
                                             "commentText":"",
        ]
        
        print(getBlogsParams)
        
        WebService.getBlogPostComments(queryItems: getBlogsParams) { (result) in
            
            DispatchQueue.main.async {
                
                switch result {
                
                case .success(let response):
                    
                    self.isNewDataLoading = false
                   // Remove All Subjects
                    self.idArr.removeAll()
                    
                    if self.CommentPageIndex == 0{
                        self.commentArr.removeAll()
                    }
                    
                    if /response.objects?.count > 0 {
                        self.commentArr.append(contentsOf: response.objects ?? [] )
                        self.mainTblVw.reloadData()
                        
                        print("Get blogs Api Called")
                        
                        ez.runThisAfterDelay(seconds: 2) {
                            
                            print("reply comment id :- \(self.replyCommentID)")
                            
                            let btn = UIButton()
                            btn.tag = self.replyCommentID
                            btn.setTitle(ShowHideEnum.viewReply, for: .normal)
                            self.HideShowReply(sender: btn)
                            
                            self.replyCommentID =  -1
                            
                            // Hide loader
                            self.HideLoader()
                            
                            self.customInputView.isHidden = false
                        }
                        
                    }else{
                        // self.navigationController?.popViewController(animated: true)
                        // AlertManager.showAlert(type: .custom(/response.message))
                        
                        // Hide loader
                        self.HideLoader()
                      //  self.mainTblVw.reloadData()
                        
                        self.customInputView.isHidden = false
                    }
                    
                case .failure(let error):
                    
                    print(error)
                    if self.CommentPageIndex == 0{
                        self.commentArr.removeAll()
                        self.mainTblVw.reloadData()
                    }
                // AlertManager.showAlert(type: .custom(error.message))
                    self.HideLoader()
                    
                    self.customInputView.isHidden = false
                }
            }
        }
    }
    
    func AddBlogPostCommentApiHit(){
        
        self.customInputView.isHidden = true
        
        let addBlogsParams : [String:Any] = ["LoginKey":/Authentication.token,
                                             "CommentText":/textField.text,
                                             "BlogPostId":/recBlog?.Id,
                                             "IsApp":true,
                                             "Id": editcommentID,
                                             "CommentId" : replyCommentID > 0 ? replyCommentID : 0
        ]
        print("addBlogsParams :- ",addBlogsParams)
        
        WebService.AddBlogPostComment(queryItems: addBlogsParams) { (result) in
            
            DispatchQueue.main.async {
                
                switch result {
                
                case .success(let response):
                    //  print(/response.message)
                    
                    self.commentCountStr = /response.object?.totalComment?.toString
                   // self.commentCountStr = /response.object?.totalComment?.toString
                    // Show Toast
                    Toast(text: /response.message).show()
                    
                    if self.editcommentID != 0 {
                        // Hide loader
                        self.HideLoader()
                        self.navigationController?.popViewController(animated: true)
                        //AlertManager.showAlert(type: .custom(/response.message))
                    }else{
                       // self.replyCommentID =  -1
//                        self.customInputView.isHidden = false
                        self.editcommentID = 0
                        self.CommentPageIndex = 0
                        self.textField.text = ""
                        self.textField.resignFirstResponder()
                        self.sendButton.setTitle("", for: .normal)
                        // Get Blogs Comments
                        self.GetBlogPostCommentsApiHit()
                        
                        
                    }
                    
                case .failure(let _):
                    
                    self.customInputView.isHidden = false
                    print("error")
                // AlertManager.showAlert(type: .custom(error.message))
                
                }
            }
        }
    }
    
    func DeleteCommentApiHit(delId:Int){
        
        self.customInputView.isHidden = true
        ShowLoader()
        
        let deleCommParams : [String:Any] = ["CommentId": delId,
                                             "CustomerId":/Authentication.customerId,
                                            
        ]
       // print("deleCommParams :- ",deleCommParams)
        
        WebService.DeleteComment(queryItems: deleCommParams) { (result) in
            
            DispatchQueue.main.async {
                
                switch result {
                
                case .success(let response):
                    //  print(/response.message)
                    
                    
                    Toast(text: /response.message).show()
                    AlertManager.showAlert(type: .custom(/response.message))
                    
                    self.commentCountStr = /response.object?.totalComment?.toString

                    self.CommentPageIndex = 0
                    self.commentDeleteModelData = response.object
                    
                    self.GetBlogPostCommentsApiHit()
                    
                    
                    
                case .failure(let _):
                    
                    self.customInputView.isHidden = false
                    print("error")
                // AlertManager.showAlert(type: .custom(error.message))
                    self.HideLoader()
                }
            }
        }
    }
}

extension CommentPostVC : UITextViewDelegate {
    
    func textViewDidBeginEditing(_ textView: UITextView) {
      //  print("textview start")
        
        if textView.text == "" {
            sendButton.setTitle("", for: .normal)
            sendButton.isEnabled = false
            sendButton.setTitleColor(UIColor.lightGray, for: .normal)
        }else{
            sendButton.setTitle("Send", for: .normal)
            sendButton.isEnabled = true
            sendButton.setTitleColor(UIColor.themeGreen, for: .normal)
        }
        
    }
    
//    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
//        // as @nhgrif suggested, we can skip the string manipulations if
//        // the beginning of the textView.text is not touched.
//        guard range.location == 0 else {
//            return true
//        }
//
//        let newString = (textView.text as NSString).replacingCharacters(in: range, with: text) as NSString
//        return newString.rangeOfCharacter(from: NSCharacterSet.whitespacesAndNewlines).location != 0
//    }
    
    func textViewDidChange(_ textView: UITextView) {
        
        let getCommentStr = textView.text.trimmed()
        if getCommentStr == "" {
            sendButton.setTitle("", for: .normal)
            sendButton.isEnabled = false
            sendButton.setTitleColor(UIColor.lightGray, for: .normal)
        }else{
            sendButton.setTitle("Send", for: .normal)
            sendButton.isEnabled = true
            sendButton.setTitleColor(UIColor.themeGreen, for: .normal)
        }
    }
    
    func textViewDidEndEditing(_ textView: UITextView) {
        
        //print("textview end")
    }
}

class CustomView: UIView {

    // this is needed so that the inputAccesoryView is properly sized from the auto layout constraints
    // actual value is not important

    override var intrinsicContentSize: CGSize {
        return CGSize.zero
    }
}
