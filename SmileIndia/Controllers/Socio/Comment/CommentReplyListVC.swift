//
//  CommentReplyListVC.swift
//  SmileIndia
//
//  Created by Arjun  on 03/05/21.
//  Copyright © 2021 Na. All rights reserved.
//

import Foundation
import IQKeyboardManager
import EZSwiftExtensions
import Toaster

class CommentReplyListVC: UIViewController {
    
    var editcommentID = 0
    var delCommentID = 0
    var CommentPageIndex = 0
    var recCommentBlog : ListPost?
    var commentModelData : CommentModel?
    var isNewDataLoading = false
    
    var AddLikePostModelData : AddLikePostModel?
    
    var commentDeleteModelData : CommentDeleteModel?
    
    var ReplyArr = [CommentModel]()
    
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
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Comment Count
        commentCountStr = /recCommentBlog?.BlogCommentCount?.toString
        
        HeaderuserNameLbl.text = /recCommentBlog?.Username
        HeaderTimeNameLbl.text = /recCommentBlog?.CreatedOnUtcString
       
        HeaderuserImg.sd_setImage(with: recCommentBlog?.profileImageURL , completed: nil)
        
        HeaderMoreBtnOL.isHidden = /Authentication.customerId != /recCommentBlog?.CustomerId?.toString ? true : false
        
        hideKeyboardWhenTappedAround()
        IQKeyboardManager.shared().isEnabled = false
        IQKeyboardManager.shared().shouldShowToolbarPlaceholder = false
        self.mainTblVw.keyboardDismissMode = .interactive
        
        //  self.navigationController?.navigationBar.barStyle = UIBarStyle.black
        
        self.navigationController?.navigationBar.barTintColor = UIColor.white
        self.navigationController?.setNavigationBarHidden(true, animated: true)
        
        textField.delegate = self
        mainTblVw.delegate = self
        
      //  self.GetBlogPostCommentsApiHit()
        
    
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
    
    
    
    @IBAction func backBtnAction(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    
    
    @IBAction func MoreBtnAction(_ sender: Any) {
        print("Main MoreBtn Action")
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        IQKeyboardManager.shared().isEnabled = true
        IQKeyboardManager.shared().shouldShowToolbarPlaceholder = false
        self.navigationController?.setNavigationBarHidden(true, animated: true)
        
        UIApplication.shared.statusBarStyle = .lightContent
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    
        UIApplication.shared.statusBarStyle = .default
    }
    
    
    
    @objc func handleSend() {
        print("works")
        
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
           // self.AddBlogPostCommentApiHit()
        }
        
    }

}


extension CommentReplyListVC : UITableViewDelegate,UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return /self.ReplyArr.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ReplyCommentTVC", for: indexPath as IndexPath) as! ReplyCommentTVC
        
        let commentDic : CommentModel? = self.ReplyArr[indexPath.row]
        
        cell.commentTxtLbl.text = /commentDic?.commentText?.htmlToString
        cell.userNameLbl.text = /commentDic?.username
        cell.timeLbl.text = /commentDic?.commentTimeAgo
        
        cell.editBtnAction.tag = indexPath.row
        cell.editBtnAction.addTarget(self,action:#selector(self.editButtonClicked),for:.touchUpInside)
        
        cell.editBtnAction.isHidden = /Authentication.customerId != /commentDic?.customerID?.toString ? true : false
        cell.editBtnWidth.constant = /Authentication.customerId != /commentDic?.customerID?.toString ? 0 : 27
        
        if let imgurl = URL.init(string: /commentDic?.profileImage) {
            cell.userImg.sd_setImage(with:imgurl  , completed: nil)
        }
        
    
        return cell
    }
    
    
    @objc func editButtonClicked(sender:UIButton)
    {
        
        let commentDic : CommentModel? = self.ReplyArr[sender.tag]
        
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
            
           // self.DeleteCommentApiHit(delId: /commentDic?.id)
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
    
    @objc func BlogLikeButtonClicked(sender:UIButton)
    {
       // AddPostLikeStatusApiHit(Status:true)
    }
    
    @objc func BlogCommentButtonClicked(sender:UIButton)
    {
        textField.becomeFirstResponder()
    }
}
extension CommentReplyListVC : UIScrollViewDelegate {
    func scrollViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate decelerate: Bool) {
        
        //Bottom Refresh
        
        if scrollView == mainTblVw{
            
            if ((scrollView.contentOffset.y + scrollView.frame.size.height) >= scrollView.contentSize.height)
            {
                if !isNewDataLoading{
                    
                    isNewDataLoading = true
                    CommentPageIndex = CommentPageIndex + 1
                  //  GetBlogPostCommentsApiHit()
                }
            }
        }
    }
}


extension CommentReplyListVC {
    
    func AddPostCommentReplyApiHit(){
        
        let AddPostCommentReplyParams : [String:Any] = ["LoginKey":/Authentication.token,
                                             "CommentText":/textField.text,
                                             "BlogPostId":/recCommentBlog?.Id,
                                             "IsApp":true,
                                             "Id": editcommentID,
                                             "CommentId" : /commentModelData?.id
        ]
        print("AddPostCommentReplyParams :- ",AddPostCommentReplyParams)
        
        WebService.AddBlogPostComment(queryItems: AddPostCommentReplyParams) { (result) in
            
            DispatchQueue.main.async {
                
                switch result {
                
                case .success(let response):
                    //  print(/response.message)
                    
                    self.commentCountStr = /response.object?.totalComment?.toString
                    // Show Toast
                    Toast(text: /response.message).show()
                    
//                    if self.editcommentID != 0 {
//                        // Hide loader
//                        self.HideLoader()
//                        self.navigationController?.popViewController(animated: true)
//                        //AlertManager.showAlert(type: .custom(/response.message))
//                    }else{
                        
                        self.HideLoader()
                        
                        self.customInputView.isHidden = false
                        self.editcommentID = 0
                        self.CommentPageIndex = 0
                        self.textField.text = ""
                        self.textField.resignFirstResponder()
                        self.sendButton.setTitle("", for: .normal)
                        // Get Blogs Comments
                        //self.GetBlogPostCommentsApiHit()
                  //  }
                    
                case .failure(let _):
                    
                    print("error")
                // AlertManager.showAlert(type: .custom(error.message))
                
                }
            }
        }
    }
    
    func DeleteCommentApiHit(delId:Int){
        
        ShowLoader()
        
        let deleCommParams : [String:Any] = ["CommentId": delId,
                                             "CustomerId":/Authentication.customerId,
                                            
        ]
        print("deleCommParams :- ",deleCommParams)
        
        WebService.DeleteComment(queryItems: deleCommParams) { (result) in
            
            DispatchQueue.main.async {
                
                switch result {
                
                case .success(let response):
                    //  print(/response.message)
                    
                    
                    self.commentCountStr = /response.object?.totalComment?.toString

                    self.CommentPageIndex = 0
                    self.commentDeleteModelData = response.object
                    
                   // self.GetBlogPostCommentsApiHit()
                    
                case .failure(let _):
                    
                    print("error")
                // AlertManager.showAlert(type: .custom(error.message))
                    self.HideLoader()
                }
            }
        }
    }
    
}

extension CommentReplyListVC : UITextViewDelegate {
    
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

extension CommentReplyListVC {
    
    override var inputAccessoryView: UIView? {
        
        if customInputView == nil {
            customInputView = CustomView()
            customInputView.backgroundColor = UIColor.groupTableViewBackground
            textField.placeholderTxt = "Write Here Your Comment"
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
            //              //  addMediaButtom.setTitle("Cancel", for: .normal)
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
}
