//
//  friendsListViewController.swift
//  SmileIndia
//
//  Created by Sakshi Gothi on 12/05/21.
//  Copyright © 2021 Na. All rights reserved.
//


import UIKit

import Fabric

enum TitlesFriends: String {
    case pending = "All Friends"
    case confirm = "Recent"
    case completed = "Friend Suggestion"
    case archived = "Friend Request"
    var color: UIColor {
        switch self {
        case .pending:
            return .themeGreen
        case .confirm:
            return .themeGreen
        case .completed:
            return .themeGreen
        case .archived:
            return .themeGreen
        }
    }
    var icon: UIImage {
        switch self {
        case .pending:
            return UIImage.init(named: "pending_new") ?? UIImage()
        case .confirm:
            return UIImage.init(named: "confirm_new") ?? UIImage()
        case .completed:
            return UIImage.init(named: "completed_new") ?? UIImage()
        case .archived:
            return UIImage.init(named: "archive_new") ?? UIImage()
        }
    }
    var id: Int {
        switch self {
        case .pending:
            return 1
        case .confirm:
            return 2
        case .completed:
            return 3
        case .archived:
            return 4
        }
    }
}

class friendsListViewController: UIViewController {
    
    var navFlag = "0"
    var sort = "true"
    
    @IBOutlet weak var pageTitlelbl: UILabel!
    
    @IBOutlet weak var countLabel: UILabel!
    @IBOutlet weak var menuBtn: UIButton!
    @IBOutlet weak var backBtn: UIButton!
    let screenSize: CGRect = UIScreen.main.bounds
    @IBOutlet weak var titleCollectionView: UICollectionView!
    @IBOutlet weak var friendTableView: UITableView!
    let titles: [TitlesFriends] = [.pending, .confirm, .completed, .archived]
    var datasource = GenericCollectionDataSource()
    var datasourceTable = GenericDataSource()
    var selectedIndex = 0
    var appointments = [Appointment]()
    var frindsArr = ["Sakshi Gothi","Mr.Sheldon Cooper","shivani gothi","Madur Sachdeva","Jatin Gera","sakshi","vishal","shivani gothi","Llanfairpwllgwyngyllgogerychwyrndrobwllllantysiliogogogoch","Jatin Gera"]
    var frindsImgArr = [#imageLiteral(resourceName: "doctor_prfile"),#imageLiteral(resourceName: "dummmy"),#imageLiteral(resourceName: "doctor-avtar"),#imageLiteral(resourceName: "slider2"),#imageLiteral(resourceName: "feedimage1"),#imageLiteral(resourceName: "welcomeFrontBg"),#imageLiteral(resourceName: "dummmy"),#imageLiteral(resourceName: "doctor-avtar"),#imageLiteral(resourceName: "dummmy"),#imageLiteral(resourceName: "doctor-avtar")]
    var action : Action = .none
    var accountDetails = [AccountDetails]()
    var bankAccount = [AccountDetails]()
    var customerinfo:CustomerInfo?
    var TableID = 1
    @IBOutlet weak var sortBtn: UIButton!
    @IBOutlet weak var infoBtn: UIButton!
    
    @IBOutlet weak var defaulterLabel: UILabel!
    
    var refreshControl: UIRefreshControl!

    var isSubscribed = false

    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setStatusBar(color: .themeGreen)
        if Authentication.customerType == "Doctor" {
           // pageTitlelbl.text = "Manage Doctor Appointment"
         
        }else{
           // pageTitlelbl.text = "Appointment Status"
        }
       
        setupCollectionCell()
       
        Authentication.customerType == "Doctor" ? self.getAppointments(1, sort: sort, refreshing: "0") : self.getMemberAppointments(1, sort: self.sort, refreshing: "0")
        
        
        
            refreshControl = UIRefreshControl()
            refreshControl.attributedTitle = NSAttributedString(string: "Refreshing...")
            refreshControl.addTarget(self, action: #selector(refresh), for: .valueChanged)
            friendTableView.addSubview(refreshControl)
        
     
        setUpTableCell()
    }
    func setupUI() -> Void {
        
     
    }
    
    @objc func refresh(_ sender: Any) {
        Authentication.customerType == "Doctor" ? self.getAppointments(selectedIndex+1, sort: self.sort, refreshing: "1") : self.getMemberAppointments(selectedIndex+1, sort: self.sort, refreshing: "1")
    }
    
    override func viewWillAppear(_ animated: Bool) {
       
    }
    
    
  
    @IBAction func didTapBack(_ sender: Any) {
        NavigationHandler.pop()
    }

}
extension friendsListViewController {
    func setupCollectionCell() {
        
        
        datasource.array = titles
        datasource.identifier = TitleCollectionCell.identifier
        titleCollectionView.dataSource = datasource
        titleCollectionView.delegate = datasource
        datasource.configure = {cell, index in
            guard let titleCell = cell as? TitleCollectionCell else { return }
            titleCell.titleLabel.text = self.titles[index].rawValue
            titleCell.titleLabel.textColor = self.selectedIndex == index ? .white : .black
            titleCell.contentView.backgroundColor = self.titles[index].color.withAlphaComponent(0)
            cell.contentView.alpha = self.selectedIndex == index ? 1 : 1
            titleCell.backgroundColor = self.selectedIndex == index ? self.titles[index].color : .grayTable
            
        }
       
        datasource.sizeItem = UICollectionViewFlowLayout.automaticSize
        let filterEnum = TitlesFriends.self
       
        datasource.sizeItem = CGSize.init(width: (screenSize.width/3.5), height: 40)
        datasource.didSelect = { cell, index  in
            guard let _ = cell as? TitleCollectionCell else { return }
            self.selectedIndex = index
            self.titleCollectionView.reloadData()
            self.setUpTableCell()
            DispatchQueue.main.async {
                self.action = .none
                Authentication.customerType == "Doctor" ? self.getAppointments(index+1, sort: self.sort, refreshing: "0") : self.getMemberAppointments(index+1, sort: self.sort, refreshing: "0")
            }
        }
    }
    
    func setUpTableCell(){
        self.TableID = self.titles[selectedIndex].id
        print(self.TableID)
        datasourceTable.array = frindsArr
        if TableID == 1 || TableID == 2 {
            self.friendTableView.reloadData()
            datasourceTable.identifier = friendsCellVC.identifier
            friendTableView.dataSource = datasourceTable
            friendTableView.delegate = datasourceTable
            friendTableView.tableFooterView = UIView()
            datasourceTable.configure = {cell, index in
                guard let tableCell = cell as? friendsCellVC else { return }
                tableCell.index = self.selectedIndex+1
                tableCell.profileName.text = self.frindsArr[index]
                tableCell.profileImage.image = self.frindsImgArr[index]
                
               
            }
            datasourceTable.didSelect = { cell, index  in
                guard let _ = cell as? feedCell else { return }
               
                NavigationHandler.pushTo(.socioProfile)
                DispatchQueue.main.async {
                    
                }
            }
        }
        else if TableID == 3{
            self.friendTableView.reloadData()
            datasourceTable.identifier = FriendSugList.identifier
            friendTableView.dataSource = datasourceTable
            friendTableView.delegate = datasourceTable
            friendTableView.tableFooterView = UIView()
            datasourceTable.didSelect = { cell, index  in
                guard let _ = cell as? feedCell else { return }
               
                NavigationHandler.pushTo(.socioProfile)
                DispatchQueue.main.async {
                    
                }
            }
            datasourceTable.configure = {cell, index in
                guard let tableCell = cell as? FriendSugList else { return }
              
                tableCell.profileName.text = self.frindsArr[index]
                tableCell.profileImage.image = self.frindsImgArr[index]
               
            }
        }
        else if TableID == 4{
            self.friendTableView.reloadData()
            datasourceTable.identifier = friendRequestCell.identifier
            friendTableView.dataSource = datasourceTable
            friendTableView.delegate = datasourceTable
            friendTableView.tableFooterView = UIView()
            datasourceTable.didSelect = { cell, index  in
                guard let _ = cell as? feedCell else { return }
               
                NavigationHandler.pushTo(.socioProfile)
                DispatchQueue.main.async {
                    
                }
            }
            datasourceTable.configure = {cell, index in
                guard let tableCell = cell as? friendRequestCell else { return }
              
                tableCell.profileName.text = self.frindsArr[index]
                tableCell.profileImg.image = self.frindsImgArr[index]
               
            }
        }
        datasourceTable.didScroll = {
        }
        datasourceTable.didSelect = {cell, index in
            guard let _ = cell as? PendingTableCell else { return}
        }
       
    }
    
    func getAppointments(_ status: Int,sort:String,refreshing:String){
       
    }
    func getMemberAppointments(_ status: Int,sort:String,refreshing:String)
    {
       
    }
    
}








