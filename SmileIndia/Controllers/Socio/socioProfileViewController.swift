//
//  socioProfileViewController.swift
//  SmileIndia
//
//  Created by Sakshi Gothi on 27/04/21.
//  Copyright © 2021 Na. All rights reserved.
//


import UIKit

import EZSwiftExtensions


class socioProfileViewController: UIViewController {
    
    
    var indexArr = [IndexPath]()
    
    
    @IBOutlet weak var topProfileName: UILabel!
    // @IBOutlet weak var titleLabel: UILabel!
    
    @IBOutlet weak var backBtn: UIButton!
    
    @IBOutlet weak var postTableView: UITableView!
    
    let numberOfCells : NSInteger = 12
    var sort = "true"
    
    
    var datasource =  GenericDataSource()
    let viewModel = FindDoctorViewModel()
    var appointments = [Appointment]()
    var listPost = [ListPost]()
    var page = 0
    var totalPage = Int()
    var isNewDataLoading = false
    var spId = ""
    var nameId = ""
    var plan_name = ""
    var planID = 0
    var filteredParams :[String:Any]?
    var tagArray = [String]()
    var refreshControl: UIRefreshControl!
    var states : Array<Bool>!
    var selectedData = [IndexPath]()
    var index = IndexPath()
    var addFriendData : AddFriendModel?
    var AddLikePostModelData : AddLikePostModel?
    var dpurl = ""
    var doctor: DoctorData?
    var socioUser: SocioData?
    var profileID = ""
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setStatusBar(color: .themeGreen)
        hideKeyboardWhenTappedAround()
        print("profile id ****")
        print(profileID)
        
        // let tapRecognizer2 = UITapGestureRecognizer(target: self, action: #selector(handleTap))
        // addFeedView.addGestureRecognizer(tapRecognizer2)
      //  self.getFeedList(refreshing: "0")
        refreshControl = UIRefreshControl()
        refreshControl.attributedTitle = NSAttributedString(string: "Refreshing...")
        refreshControl.addTarget(self, action: #selector(refresh), for: .valueChanged)
       
    }
    
    override func viewWillAppear(_ animated: Bool){
        super.viewWillAppear(animated)
        
        getSocioprofile()
        
        
    }
    
    func getSocioprofile(){
        // Hide loader
        self.ShowLoader()
        WebService.getSocioProfile(queryItems: ["ProviderId": profileID,"CustomerId": /Authentication.customerId, "IsFromApp" : true] ) { (result) in
            DispatchQueue.main.async {
                switch result {
                case .success(let response):
                    if let suser = response.object {
                        self.socioUser = suser
                        print("socio")
                        self.topProfileName.text = "\(self.socioUser?.ProviderName ?? "") "
                        
                        self.postTableView.reloadData()
                    } else {
                    }
                    
                    // Hide loader
                    self.HideLoader()
                case .failure(let error):
                    print(error.message)
                    
                    // Hide loader
                    self.HideLoader()
                    
                    AlertManager.showAlert(type: .custom(/error.message)){
                        self.navigationController?.popViewController(animated: true)
                    }
                    
                   
                }
                
                
            }
        }
    }
    
    
    @objc func refresh(_ sender: Any) {
//        Authentication.customerType == "Doctor" ? self.getFeedList(refreshing:"1") : self.getFeedList(refreshing:"1")
    }
    @IBAction func didTapAddFeed(_ sender: Any) {
        if !(Authentication.isUserLoggedIn ?? false) {
            AlertManager.showAlert(type: .custom("Create an account or log in to Vigorto portal to use Vigorto social connection !"), actionTitle: "Login") {
                NavigationHandler.pushTo(.login)
            }
        }
        else{
            NavigationHandler.pushTo(.createFeed)}
    }
    
    @objc func didTapAddFriend(sender:UIButton){
        // - false- send
        // - true - cancel friend
        
        ez.runThisInMainThread {
            if sender.currentTitle == socioFndBtnTitle.AddFriend{
                self.AddfriendReqApiHit(isCancelled: false)
            }else if sender.currentTitle == socioFndBtnTitle.CancelFriendReq{
                self.AddfriendReqApiHit(isCancelled: true)
            }else if sender.currentTitle == socioFndBtnTitle.AcceptFriendReq{
                self.AcceptfriendReqApiHit()
            }
        }
        
    }
    func AddfriendReqApiHit(isCancelled:Bool){
        let addFndParam : [String:Any] = ["customerId":/Authentication.customerId,"RecieverId":/socioUser?.Customerid,"Cancelled":isCancelled]
        WebService.AddFriend(queryItems: addFndParam, completion: { (result) in
            switch result {
            case .success(let response):
                
                ez.runThisInMainThread {
                    self.addFriendData = response.object
                    
                    AlertManager.showAlert(type: .custom(/response.message))
                    
                    self.getSocioprofile()
                }
                
            case .failure(let error):
                print(error.message)
                ez.runThisInMainThread {
                    AlertManager.showAlert(type: .custom(error.message))
                    self.getSocioprofile()
                }
                
            }
        })
    }
    

    func AcceptfriendReqApiHit(){
        let addFndParam : [String:Any] = ["customerId":/Authentication.customerId,"RecieverId":/socioUser?.Customerid]
        WebService.AcceptRequest(queryItems: addFndParam, completion: { (result) in
            switch result {
            case .success(let response):
                
                ez.runThisInMainThread {
                    self.addFriendData = response.object
                    
                    AlertManager.showAlert(type: .custom(/response.message))
                    self.getSocioprofile()
                }
            case .failure(let error):
                ez.runThisInMainThread {
                    self.getSocioprofile()
                    AlertManager.showAlert(type: .custom(error.message))
                }
            }
        })
    }
    
    
    
    @IBAction func didTapBackButton(_ sender: Any) {
        NavigationHandler.pop()
    }
    @IBAction func didTapFriendList(_ sender: Any) {
        NavigationHandler.pushTo(.socioFriendList)
    }
    
    @IBAction func didTapCoverImageButton(_ sender: Any) {
        // picker.showOptions()
        
    }
    
    @IBAction func didTapDisplayImageButton(_ sender: Any) {
        
    }
    
    @objc func handleTap(gestureRecognizer: UIGestureRecognizer)
    {
        if !(Authentication.isUserLoggedIn ?? false) {
            AlertManager.showAlert(type: .custom("Create an account or log in to Vigorto portal to use Vigorto social connection !"), actionTitle: AlertBtnTxt.okay.localize()) {
                NavigationHandler.pushTo(.login)
            }
        }
        else{
            NavigationHandler.pushTo(.createFeed)
        }
    }
    
}



extension socioProfileViewController {

    func getFeedList(refreshing:String){
        let queryItems = ["CustomerId": Authentication.customerId ?? "", "pageSize": "5","pageIndex":"1","dateFrom":"","dateTo":""] as [String : Any]
        //self.view.activityStartAnimating(activityColor: .themeGreen, backgroundColor: UIColor.white)
        activityIndicator.showLoaderOnWindow()
        WebService.listPost(queryItems: queryItems) { (result) in
            DispatchQueue.main.async {
                activityIndicator.hideLoader()
                switch result {
                case .success(let response):
                    print("success")
                    self.listPost = response.objects ?? []
                    // self.setUpCellfeed()
                    self.postTableView.reloadData()
                case .failure(let error):
                    print(error)
                }
                if refreshing == "0"{
                    self.view.activityStopAnimating()
                }
                if refreshing == "1" {
                    self.refreshControl.endRefreshing()
                }
            }
        }
        
    }
    
    @objc func BlogLikeButtonClicked(sender:UIButton)
    {
        print("like")
        let cellDic : ListPost = self.listPost[sender.tag]
        
        let addPostLikeParams : [String:Any] = ["CustomerId":/Authentication.customerId,
                                                "BlogId": cellDic.Id,
                                                "Status":true
        ]
        
        print(addPostLikeParams)
        WebService.AddPostLikeStatus(queryItems: addPostLikeParams) { (result) in
            DispatchQueue.main.async {
                switch result {
                case .success(let response):
                    
                    self.AddLikePostModelData = response.object
                    self.HideLoader()
                    
                case .failure(let error):
                    
                    print(error)
                    AlertManager.showAlert(type: .custom(error.message))
                    
                }
            }}}
    
    @objc func editButtonClicked(sender:UIButton)
    {
        let cellDic : ListPost = self.listPost[sender.tag]
        //Create the AlertController and add Its action like button in Actionsheet
        let actionSheetControllerIOS8: UIAlertController = UIAlertController(title: .none, message: .none, preferredStyle: .actionSheet)
        
        let EditActionButton = UIAlertAction(title: "Edit", style: .default) { _ in
            
            let vc = UIStoryboard.init(name: "Home", bundle: Bundle.main).instantiateViewController(withIdentifier: "createPostViewController") as? createPostViewController
            vc?.recBlog = cellDic
            
            self.navigationController?.pushViewController(vc!, animated: true)
        }
        actionSheetControllerIOS8.addAction(EditActionButton)
        let deleteActionButton = UIAlertAction(title: "Delete", style: .default)
        { _ in
            AlertManager.showAlert(type: .custom("Are you sure to delete this Post?"), actionTitle: "Delete") {
                //    self.blogDelete()
                self.blogDelete(delId: /cellDic.Id)
            }
        }
        actionSheetControllerIOS8.addAction(deleteActionButton)
        let CancelActionButton = UIAlertAction(title: AlertBtnTxt.cancel.localize(), style: .cancel)
        { _ in
            print("Delete")
        }
        actionSheetControllerIOS8.addAction(CancelActionButton)
        self.present(actionSheetControllerIOS8, animated: true, completion: nil)
        
        
    }
    
    func blogDelete(delId:Int){
        
        ShowLoader()
        
        let param : [String:Any] = ["PostId": delId,
                                    "CustomerId":/Authentication.customerId,
                                    
        ]
        print("param :- ",param)
        
        WebService.DeletePost(queryItems: param) { (result) in
            
            DispatchQueue.main.async {
                
                switch result {
                
                case .success(let response):
                    print(/response.message)
                    
                    self.getFeedList(refreshing: "0")
                case .failure(let _):
                    
                    print("error")
                    // AlertManager.showAlert(type: .custom(error.message))
                    self.HideLoader()
                }
                self.HideLoader()
                
            }
            
        }
        
    }
    @objc func buttonClicked(sender:UIButton)
    {
        if !(Authentication.isUserLoggedIn ?? false) {
            AlertManager.showAlert(type: .custom("Create an account or log in to Vigorto portal to use Vigorto social connection !"), actionTitle: "Login") {
                NavigationHandler.pushTo(.login)
            }
        }
        else{
            
            
            let cellDic : ListPost = self.listPost[sender.tag]
            print(cellDic)
            
            let vc = UIStoryboard.init(name: "Comment", bundle: Bundle.main).instantiateViewController(withIdentifier: "CommentPostVC") as? CommentPostVC
            vc?.recBlog = cellDic
            self.navigationController?.pushViewController(vc!, animated: true)
        }
    }
    @objc func readMore(sender:UIButton)
    {
        
        let selectedIndex = IndexPath(item: sender.tag, section: 0)
        
        if indexArr.contains(selectedIndex){
            let indexNum = self.indexArr.index(of: selectedIndex)
            self.indexArr.remove(at: /indexNum)
        }else{
            indexArr.append(selectedIndex)
        }
        
        self.postTableView.reloadRows(at: [selectedIndex], with: .none)
        
        
    }
    

}


extension socioProfileViewController : UITableViewDelegate,UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        
        let headerCell = tableView.dequeueReusableCell(withIdentifier: "HeaderSocioProfile") as! HeaderSocioProfile
        
        // work
        headerCell.socioUser = socioUser
        headerCell.displayImageView.sd_setImage(with: self.doctor?.profileImageURL, placeholderImage: UIImage.init(named: "doctor-avtar"))
        headerCell.coverImageView.sd_setImage(with: self.doctor?.profileImageURL, placeholderImage: UIImage.init(named: "doctor-avtar"))
        headerCell.profileName.text = "\(self.socioUser?.ProviderName ?? "") "
        
        headerCell.addfriendBtn.addTarget(self,action:#selector(self.didTapAddFriend),for:.touchUpInside)
        
        return headerCell.contentView
    }
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return /self.listPost.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        
        let cell = tableView.dequeueReusableCell(withIdentifier: feedCell.identifier, for: indexPath as IndexPath) as! feedCell
        
        
        cell.object = self.listPost[indexPath.row]
        
        var cellDic: ListPost = self.listPost[indexPath.row]
        var tagarraz = cellDic.CategoryArray ?? []
        if cellDic.CategoryArray == []{
            cell.tagListView.addTags([])
            cell.tagListView.isHidden = true
        }
        else{
            tagarraz.removeAll()
            cell.tagListView.isHidden = false
            cell.tagListView.removeAllTags()
            cell.tagListView.addTags(cellDic.CategoryArray ?? [])
        }
        
        //Arjun Code
        
        
        cell.postBodyLabel.text = cellDic.Body
        print(cell.postBodyLabel.calculateMaxLines())
        
        if cell.postBodyLabel.calculateMaxLines() > 10 {
            cell.postBodyLabel.numberOfLines = 10
            cell.viewMore.isHidden = false
            
            let selectedIndex = IndexPath(item: indexPath.row, section: 0)
            if self.indexArr.contains(selectedIndex){
                cell.viewMore.setTitle("viewLess", for: .normal)
                cell.postBodyLabel.numberOfLines = 0
            }
            else{
                cell.postBodyLabel.numberOfLines = 10
                cell.viewMore.setTitle("viewMore", for: .normal)
            }
        }
        else{
            cell.postBodyLabel.numberOfLines = 0
            cell.viewMore.isHidden = true
        }
        
        
        cell.commentBtnOL.tag = indexPath.row
        cell.commentBtnOL.addTarget(self,action:#selector(self.buttonClicked),for:.touchUpInside)
        cell.viewMore.tag = indexPath.row
        cell.viewMore.addTarget(self,action:#selector(self.readMore),for:.touchUpInside)
        cell.settingsButton.tag = indexPath.row
        cell.settingsButton.addTarget(self, action: #selector(self.editButtonClicked), for: .touchUpInside)
        cell.likeBtn.addTarget(self, action: #selector(self.BlogLikeButtonClicked), for: .touchUpInside)
        
        return cell
    }
    
}
