////
//  FindDoctorController.swift
//  SmileIndia
//
//  Created by Na on 12/02/19.
//  Copyright © 2019 Na. All rights reserved.
//


import UIKit


class socioFeedViewController: UIViewController {
    
    
    var indexArr = [IndexPath]()
    
    
    @IBOutlet weak var userAccountImageView: UIButton!
    @IBOutlet weak var titleLabel: UILabel!
    
    @IBOutlet weak var backBtn: UIButton!
    
    @IBOutlet weak var doctorTableView: UITableView!
    
    @IBOutlet weak var addFeedView: UIView!
    
    @IBOutlet weak var shareBtn: UIButton!
    
    @IBOutlet weak var likeBtn: UIButton!
    var noResult : Bool = false {
        didSet{
            self.doctorTableView.isHidden = noResult
        }
    }
    let numberOfCells : NSInteger = 12
    var sort = "true"
    var datasource =  GenericDataSource()
    let viewModel = FindDoctorViewModel()
    var appointments = [Appointment]()
    var listPost = [ListPost]()
    var page = 1
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
    var dpurl = ""
    var doctor: DoctorData?
    var commentCountStr = ""
    var AddLikePostModelData : AddLikePostModel?
    override func viewDidLoad() {
        super.viewDidLoad()
        setStatusBar(color: .themeGreen)
        hideKeyboardWhenTappedAround()
        addFeedView.isUserInteractionEnabled = true
        let tapRecognizer = UITapGestureRecognizer(target: self, action: #selector(handleTap))
        addFeedView.addGestureRecognizer(tapRecognizer)
        
        refreshControl = UIRefreshControl()
        refreshControl.attributedTitle = NSAttributedString(string: "Refreshing...")
        refreshControl.addTarget(self, action: #selector(refresh), for: .valueChanged)
        doctorTableView.addSubview(refreshControl)
        doctorTableView.estimatedRowHeight = 44
        doctorTableView.rowHeight = UITableView.automaticDimension
        //  states = [Bool](repeating: true, count: numberOfCells)
        doctorTableView.estimatedRowHeight = 44
        doctorTableView.rowHeight = UITableView.automaticDimension
        
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        
        self.getFeedList(refreshing: "1")
        self.getprofile()
        self.userAccountImageView.sd_setImage(with: self.doctor?.profileImageURL, for: .normal, placeholderImage: UIImage.init(named: "doctor-avtar"))
    }
    
    func getprofile(){
        WebService.getDoctorProfile(queryItems: ["LoginKey": Authentication.token ?? "YXNob2ttaXR0YWxAZ21haWwuY29tOjEyMzQ1Ng=="]) { (result) in
            DispatchQueue.main.async {
                switch result {
                case .success(let response):
                    if let user = response.object {
                        self.doctor = user
                        self.dpurl = user.ProfileImage ?? ""
                       // print(self.dpurl)
                    } else {
                    }
                case .failure(let error):
                    print(error.message)
                }
            }
        }
    }
    
    @objc func refresh(_ sender: Any) {
        self.getFeedList(refreshing:"1")
        //   Authentication.customerType == "Doctor" ? self.getFeedList(refreshing:"1") : self.getFeedList(refreshing:"1")
    }
    @IBAction func didTapProfile(_ sender: Any) {
        print("tapped")
        if !(Authentication.isUserLoggedIn ?? false) {
            AlertManager.showAlert(type: .custom("Create an account or log in to Vigorto portal to use Vigorto social connection !"), actionTitle: "Login") {
                NavigationHandler.pushTo(.login)
            }
        }else{
           
               
               let vc = UIStoryboard.init(name: "socioProfile", bundle: Bundle.main).instantiateViewController(withIdentifier: "socioProfileViewController") as? socioProfileViewController
               vc?.profileID = /Authentication.customerGuid
            self.navigationController?.pushViewController(vc!, animated: true)
            
        }
        
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
    @IBAction func didTapBackButton(_ sender: Any) {
        NavigationHandler.popTo(HomeViewController.self)
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


extension socioFeedViewController {
    
    func getFeedList(refreshing:String){
        
        
        if refreshing == "1" {
            self.listPost.removeAll()
            page = 1
        }
        
        let queryItems = ["CustomerId": Authentication.customerId ?? "", "pageSize": "10","pageIndex":page,"dateFrom":"","dateTo":""] as [String : Any]
        //self.view.activityStartAnimating(activityColor: .themeGreen, backgroundColor: UIColor.white)
        activityIndicator.showLoaderOnWindow()
        WebService.listPost(queryItems: queryItems) { (result) in
            DispatchQueue.main.async {
                activityIndicator.hideLoader()
                switch result {
                case .success(let response):
                    print("success")
                    
                    
                    if /response.objects?.count > 0 {
                        self.doctorTableView.reloadData()
                        self.isNewDataLoading = false
                        self.listPost.append(contentsOf: response.objects ?? [] )
                        
                        
                    }
//                    self.listPost = response.objects ?? []
                    self.setUpCellfeed()
                    self.doctorTableView.reloadData()
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
       // print("like")
        let cellDic : ListPost = self.listPost[sender.tag]
        
        let addPostLikeParams : [String:Any] = ["CustomerId":/Authentication.customerId,
                                                "BlogId": cellDic.Id,
                                                "Status":true
        ]
        
      //  print(addPostLikeParams)
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
    
    
    // like api

    func setUpCellfeed(){
//        for account in self.listPost{
//            listPost.append(account)
//        }
        self.datasource.array = self.listPost
        self.datasource.identifier = feedCell.identifier
        
        self.doctorTableView.dataSource = self.datasource
        self.doctorTableView.delegate = self.datasource
        self.datasource.didSelect = { cell, index  in
            guard let _ = cell as? feedCell else { return }
           
            var cellDic: ListPost = self.listPost[index]
            let vc = UIStoryboard.init(name: "socioProfile", bundle: Bundle.main).instantiateViewController(withIdentifier: "socioProfileViewController") as? socioProfileViewController
            vc?.profileID = cellDic.CustomerGuid ?? ""
            self.navigationController?.pushViewController(vc!, animated: true)
            DispatchQueue.main.async {
                
            }
        }
        self.datasource.configure = {cell, index in
            if self.listPost.count == 0 {return}
            guard let feedCell = cell as? feedCell else { return }
            
            feedCell.object = self.listPost[index]
            
            var cellDic: ListPost = self.listPost[index]
            
            var tagarraz = cellDic.CategoryArray ?? []
            if cellDic.CategoryArray == []{
                feedCell.tagListView.addTags([])
                feedCell.tagListView.isHidden = true
            }
            else{
                tagarraz.removeAll()
                feedCell.tagListView.isHidden = false
                feedCell.tagListView.removeAllTags()
                feedCell.tagListView.addTags(cellDic.CategoryArray ?? [])
            }
            
            //Arjun Code
           // self.commentCountStr = /cellDic.BlogCommentCount?.toString
            var commentStr = ""
            if /cellDic.BlogCommentCount > 0 {
                commentStr = /cellDic.BlogCommentCount > 1 ? "   \(/cellDic.BlogCommentCount)  Comments" : "   \(/cellDic.BlogCommentCount)   Comment"
                feedCell.commentBtn.setTitle(commentStr, for: .normal)
                
            }else{
                feedCell.commentBtn.setTitle("   Comment", for: .normal)
            }
            
            if index == 0 {
                print("Title - \(/cellDic.Title) ,\(commentStr)")
            }
            
            feedCell.postBodyLabel.text = cellDic.Body?.htmlToString
            
            if feedCell.postBodyLabel.calculateMaxLines() > 10 {
                feedCell.postBodyLabel.numberOfLines = 10
                feedCell.viewMore.isHidden = false
                
                let selectedIndex = IndexPath(item: index, section: 0)
                if self.indexArr.contains(selectedIndex){
                    feedCell.viewMore.setTitle("View Less", for: .normal)
                    feedCell.postBodyLabel.numberOfLines = 0
                }
                else{
                    feedCell.postBodyLabel.numberOfLines = 10
                    feedCell.viewMore.setTitle("View More", for: .normal)
                }
            }
            else{
                feedCell.postBodyLabel.numberOfLines = 0
                feedCell.viewMore.isHidden = true
            }
            
            /*   if cellDic.BlogCommentCount ?? 0 == 0 {
             
             feedCell.commentBtn.setTitle("Comment", for: .normal)
             }
             else{
             feedCell.commentBtn.setTitle("\(/cellDic.BlogCommentCount) \("Comments")", for: .normal)
             }
             
             
             */
            
            
            //////////////////
            
            feedCell.commentBtnOL.tag = index
            feedCell.commentBtnOL.addTarget(self,action:#selector(self.buttonClicked),for:.touchUpInside)
            feedCell.viewMore.tag = index
            feedCell.viewMore.addTarget(self,action:#selector(self.readMore),for:.touchUpInside)
            feedCell.settingsButton.tag = index
            feedCell.settingsButton.addTarget(self, action: #selector(self.editButtonClicked), for: .touchUpInside)
            
            //  feedCell.likeBtn.addTarget(self, action: #selector(self.BlogLikeButtonClicked), for: .touchUpInside)
            
            
        }
        
        self.datasource.didScroll = {
            print("scrolling")
            if !self.isNewDataLoading{
            
                self.page = self.page+1
            
                self.isNewDataLoading = true
                self.getFeedList(refreshing: "0")
            
            }
        }
    }
    
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
                                    "CustomerId":/Authentication.customerId,]
      //  print("param :- ",param)
        
        WebService.DeletePost(queryItems: param) { (result) in
            
            DispatchQueue.main.async {
                
                switch result {
                
                case .success(let response):
                  //  print(/response.message)
                    
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
        
        self.doctorTableView.reloadRows(at: [selectedIndex], with: .none)
        
        
    }
    
    
    
}



