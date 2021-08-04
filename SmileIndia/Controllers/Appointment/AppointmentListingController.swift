//
//  AppointmentListingController.swift
//  SmileIndia
//
//  Created by Na on 07/07/19.
//  Copyright © 2019 Na. All rights reserved.
//

import UIKit
import EZSwiftExtensions

import Fabric

enum Titles: String {
    case pending = "Pending"
    case confirm = "Confirmed"
    case completed = "Completed"
    case archived = "History"
    var color: UIColor {
        switch self {
        case .pending:
            return .sorange
        case .confirm:
            return .sgreen
        case .completed:
            return .sblue
        case .archived:
            return .sred
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
}

class AppointmentListingController: UIViewController {
    
    var navFlag = "0"
    var sort = "true"
    
    @IBOutlet weak var pageTitlelbl: UILabel!
    
    @IBOutlet weak var countLabel: UILabel!
    @IBOutlet weak var menuBtn: UIButton!
    @IBOutlet weak var backBtn: UIButton!
    let screenSize: CGRect = UIScreen.main.bounds
    @IBOutlet weak var titleCollectionView: UICollectionView!
    @IBOutlet weak var appointmentTableView: UITableView!
    let titles: [Titles] = [.pending, .confirm, .completed, .archived]
    var datasource = GenericCollectionDataSource()
    var datasourceTable = GenericDataSource()
    var selectedIndex = 0
    var appointments = [Appointment]()
    var action : Action = .none
    var accountDetails = [AccountDetails]()
    var bankAccount = [AccountDetails]()
    var customerinfo:CustomerInfo?
    
    @IBOutlet weak var sortBtn: UIButton!
    @IBOutlet weak var infoBtn: UIButton!
    
    @IBOutlet weak var defaulterLabel: UILabel!
    
    var refreshControl: UIRefreshControl!
    
    var isSubscribed = false
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setStatusBar(color: .themeGreen)
        if Authentication.customerType == EnumUserType.Doctor {
            pageTitlelbl.text = AppointmentScreenTxt.ManageDocAppointement.localize()
            isAccountDetailsAdded()
            getAccountDetails()
        }else{
            pageTitlelbl.text = AppointmentScreenTxt.AppointmentStatus.localize()
        }
        
        setupCollectionCell()
        
        
        if /appdelegate?.isComingDeeplinkApStatus == EnumAppointmentStatus.Completed {
            appdelegate?.isComingDeeplinkApStatus = ""
            self.selectedIndex = 2
            self.titleCollectionView.reloadData()
            Authentication.customerType == EnumUserType.Doctor ? self.getAppointments(3, sort: sort, refreshing: "0") : self.getMemberAppointments(3, sort: self.sort, refreshing: "0")
        }else{
            Authentication.customerType == EnumUserType.Doctor ? self.getAppointments(1, sort: sort, refreshing: "0") : self.getMemberAppointments(1, sort: self.sort, refreshing: "0")
        }
        
        
        
        menuBtn.isHidden = true
        infoBtn.isHidden = true
        
        
        refreshControl = UIRefreshControl()
        refreshControl.attributedTitle = NSAttributedString(string: AppointmentScreenTxt.refreshing.localize())
        refreshControl.addTarget(self, action: #selector(refresh), for: .valueChanged)
        appointmentTableView.addSubview(refreshControl)
        
        self.defaulterLabel.text = ""
        
    }
    
    
    /*
     func getAccountDetails() -> Void {
     let queryItems = ["CustomerId": Authentication.customerId ?? "0"]
     WebService.getAccountDetails(queryItems: queryItems) { (result) in
     DispatchQueue.main.async {
     switch result {
     case .success(let response):
     
     print("added")
     case .failure(let error):
     print(error.message)
     self.isAccountDetailsAdded()
     //  self.bankaccount()
     }
     }
     }
     }*/
    func isAccountDetailsAdded(){
        WebService.IsCheckVerificationDocumentsStatus(queryItems: ["LoginKey": Authentication.token ?? "YXNob2ttaXR0YWxAZ21haWwuY29tOjEyMzQ1Ng=="]) { (result) in
            DispatchQueue.main.async {
                switch result {
                case .success(let response):
                    // print(response.message)
                    if self.bankAccount.count > 0 {
                        if let isactive = self.bankAccount[0].Active{
                            if isactive == false{
                                self.presentAlertWithImageFordoc()
                            }
                            
                        }
                    }
                //self.presentAlertWithImageForaccount()
                case .failure(let error):
                    print(error.message)
                    if error.message == "Login Key is invalid"{
                        self.logoutUser()
                    }else{
                        self.presentAlertWithImageFordoc()
                    }
                }
                self.view.activityStopAnimating()
            }
        }
        
    }
    
    func getAccountDetails() -> Void {
        let queryItems = ["CustomerId": Authentication.customerId ?? "0"]
        self.view.activityStartAnimating(activityColor: #colorLiteral(red: 0.233, green: 0.816, blue: 0.538, alpha: 1), backgroundColor: UIColor.white)
        
        WebService.getAccountDetails(queryItems: queryItems) { (result) in
            
            DispatchQueue.main.async {
                switch result {
                case .success (let response):
                    //                        print("response.ta")
                    //                        print(response.TotalAmount)
                    
                    
                    for account in response.objects! {
                        self.accountDetails.append(account)
                    }
                    self.setupUI()
                case .failure(let error):
                    print(error)
                }
                self.view.activityStopAnimating()
            }
        }
    }
    
    
    
    func setupUI() -> Void {
        
        for account in self.accountDetails {
            if account.AccountType == AccountType.BankAccount{
                bankAccount.append(account)
            }else{
                
            }
        }
        
        if self.bankAccount.count > 0 {
            if let isactive = self.bankAccount[0].Active{
                if isactive == false{
                    presentAlertWithImageForaccount()
                }
                
            }
            if let name = self.bankAccount[0].Name{
                
            }
            if let accNo = self.bankAccount[0].MaskedAccountNumber{
                
            }
            if let caccNo = self.bankAccount[0].MaskedAccountNumber{
                
            }
            
            
            
            
            
            
        }
    }
    
    func presentAlertWithImageFordoc() -> Void {
        
        //ImageView
        let imageView = UIImageView(frame: CGRect(x: 50, y: 100, width: 150, height: 150))
        imageView.image = #imageLiteral(resourceName: "subscription_vg")
        
        
        
        let message = AppointmentScreenTxt.updateAccountDetailsreceivepayment.localize()
        let showAlert = UIAlertController(title: nil , message: message, preferredStyle: .alert)
        showAlert.view.addSubview(imageView)
        let height = NSLayoutConstraint(item: showAlert.view, attribute: .height, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1, constant: 350)
        let width = NSLayoutConstraint(item: showAlert.view, attribute: .width, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1, constant: 250)
        showAlert.view.addConstraint(height)
        showAlert.view.addConstraint(width)
        showAlert.addAction(UIAlertAction(title: AlertBtnTxt.okay.localize(), style: .default, handler: { action in
            NavigationHandler.pushTo(.verificationsDocs)
        }))
        showAlert.addAction(UIAlertAction(title: AlertBtnTxt.cancel.localize(), style: .default, handler: { action in
            NavigationHandler.pushTo(.homeViewController)
        }))
        
        self.present(showAlert, animated: true, completion: nil)
        
    }
    func presentAlertWithImageForaccount() -> Void {
        
        //ImageView
        let imageView = UIImageView(frame: CGRect(x: 50, y: 100, width: 150, height: 150))
        imageView.image = #imageLiteral(resourceName: "subscription_vg")
        
        
        
        let message = AppointmentScreenTxt.updateAccountDetailsreceivepayment.localize()
        let showAlert = UIAlertController(title: nil , message: message, preferredStyle: .alert)
        showAlert.view.addSubview(imageView)
        let height = NSLayoutConstraint(item: showAlert.view, attribute: .height, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1, constant: 350)
        let width = NSLayoutConstraint(item: showAlert.view, attribute: .width, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1, constant: 250)
        showAlert.view.addConstraint(height)
        showAlert.view.addConstraint(width)
        showAlert.addAction(UIAlertAction(title: AlertBtnTxt.okay.localize(), style: .default, handler: { action in
            NavigationHandler.pushTo(.BankAccount)
        }))
        showAlert.addAction(UIAlertAction(title: AlertBtnTxt.cancel.localize(), style: .default, handler: { action in
            NavigationHandler.pushTo(.homeViewController)
        }))
        self.present(showAlert, animated: true, completion: nil)
        
    }
    
    @objc func refresh(_ sender: Any) {
        Authentication.customerType == EnumUserType.Doctor ? self.getAppointments(selectedIndex+1, sort: self.sort, refreshing: "1") : self.getMemberAppointments(selectedIndex+1, sort: self.sort, refreshing: "1")
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.appointmentTableView.reloadData()
        if Authentication.customerType == EnumUserType.Doctor {
            self.customerInfo()
            self.paidDoctorPlans()
            isAccountDetailsAdded()
            getAccountDetails()
        }
        
    }
    
    @objc func appointmentNotificationReceived(notification: Notification){
        selectedIndex = notification.object as! Int - 1
        print("Selected index :- \(selectedIndex)")
        DispatchQueue.main.async {
            Authentication.customerType == EnumUserType.Doctor ? self.getAppointments(notification.object as! Int, sort: self.sort, refreshing: "0") : self.getMemberAppointments(notification.object as! Int, sort: self.sort, refreshing: "0")
        }
    }
    
    
    func customerInfo(){
        let queryItems = ["Email": Authentication.customerEmail ?? ""] as [String: Any]
        WebService.customerInfo(queryItems: queryItems) { (result) in
            DispatchQueue.main.async {
                switch result {
                case .success(let response):
                    self.customerinfo = response.object
                    if response.object?.IsDefaulter ?? false{
                        self.defaulterLabel.text = ProfileUpdate.Alert.defaulter.localize()
                        AlertManager.showAlert(type: .custom(ProfileUpdate.Alert.defaulter.localize()))
                    }else{
                        self.defaulterLabel.text = ""
                    }
                case .failure(let error):
                    AlertManager.showAlert(type: .custom(error.message))
                }
            }
        }
    }
    
    func paidDoctorPlans() -> Void {
        let queryItems = ["CustomerGuid": "\(Authentication.customerGuid!)"]
        WebService.paidDoctorPlans(queryItems: queryItems) { (result) in
            DispatchQueue.main.async {
                switch result {
                case .success(let response):
                    if response.object?.SubscriptionStatus == true && response.object?.PaymentStatus == true{
                        self.isSubscribed = true
                    }else{
                        NavigationHandler.pushTo(.homeViewController)
                    }
                case .failure(let error):
                    if error.message == "Login Key is invalid"{
                        self.logoutUser()
                    }else{
                        NavigationHandler.pushTo(.homeViewController)
                    }
                }
            }
        }
    }
    func logoutUser() -> Void {
        self.deleteToken()
        Authentication.clearData()
        NavigationHandler.logOut()
        self.logOutSinchUser()
    }
    func deleteToken() -> Void {
        self.view.activityStartAnimating(activityColor: .orange, backgroundColor: UIColor.white)
        WebService.deleteDeviceToken(queryItems: ["LoginKey": Authentication.token ?? "YXNob2ttaXR0YWxAZ21haWwuY29tOjEyMzQ1Ng=="]) { (result) in
            DispatchQueue.main.async {
                switch result {
                case .success(let response):
                    print(response.message ?? "")
                case .failure(let error):
                    print(error.message)
                }
                self.view.activityStopAnimating()
            }
        }
    }
    func logOutSinchUser() {
        let appDelegate = UIApplication.shared.delegate! as! AppDelegate
        if let client = appDelegate.client {
            client.stopListeningOnActiveConnection()
            client.unregisterPushNotificationDeviceToken()
            client.terminateGracefully()
        }
        appDelegate.client = nil
    }
    
    
    
    @IBAction func didtapInfo(_ sender: Any) {
        AlertManager.showAlert(type: .custom(AppointmentScreenTxt.InfoManageAppointement.localize()))
    }
    
    @IBAction func didtapSort(_ sender: Any) {
        if self.sort == "false"{
            self.sort = "true"
            Authentication.customerType == EnumUserType.Doctor ? self.getAppointments(self.selectedIndex+1, sort: self.sort, refreshing: "0") : self.getMemberAppointments(self.selectedIndex+1, sort: self.sort, refreshing: "0")
            
        }else{
            self.sort = "false"
            Authentication.customerType == EnumUserType.Doctor ? self.getAppointments(self.selectedIndex+1, sort: self.sort, refreshing: "0") : self.getMemberAppointments(self.selectedIndex+1, sort: self.sort, refreshing: "0")
            
        }
    }
    
    @IBAction func didTapProfile(_ sender: UIButton) {
        NavigationHandler.pushTo(Authentication.customerType == EnumUserType.Customer ? .memberDb : .doctorDb)
    }
    
    @IBAction func didTapBackButton(_ sender: Any){
        //        NavigationHandler.pushTo(.homeViewController)
        
        let homeVC = HomeViewController.instantiateFromAppStoryboard(.home)
        if NavigationHandler.stack.contains(homeVC){
            NavigationHandler.pop()
        }else{
            if var navstack = NavigationHandler.stack as? [UIViewController]{
                navstack.insert(homeVC, at: navstack.count-1)
                BaseNavigationController.sharedInstance.setViewControllers(navstack, animated: true)
            }
            NavigationHandler.pop()
        }
    }
    @IBAction func didTapPhone(_ sender: UIButton) {
        guard let number = URL(string: "tel://" + (sender.titleLabel?.text ?? "1")) else { return }
        UIApplication.shared.open(number, options: [:], completionHandler: nil)
    }
    
}
extension AppointmentListingController {
    func setupCollectionCell() {
        datasource.array = titles
        datasource.identifier = TitleCollectionCell.identifier
        titleCollectionView.dataSource = datasource
        titleCollectionView.delegate = datasource
        datasource.configure = {cell, index in
            guard let titleCell = cell as? TitleCollectionCell else { return }
            titleCell.titleLabel.text = self.titles[index].rawValue.localize()
            
            titleCell.contentView.backgroundColor = self.titles[index].color.withAlphaComponent(0.8)
            titleCell.borderView.backgroundColor = self.titles[index].color
            
            cell.contentView.alpha = self.selectedIndex == index ? 1 : 1
            titleCell.backgroundColor = self.selectedIndex == index ? self.titles[index].color : #colorLiteral(red: 0.921431005, green: 0.9214526415, blue: 0.9214410186, alpha: 1)
        }
        //        print("titleCollectionView width")
        //        print(self.titleCollectionView.frame.width)
        datasource.sizeItem = CGSize.init(width: (screenSize.width/4)-3, height: 50)
        datasource.didSelect = { cell, index  in
            guard let _ = cell as? TitleCollectionCell else { return }
            self.selectedIndex = index
            self.titleCollectionView.reloadData()
            DispatchQueue.main.async {
                self.action = .none
                Authentication.customerType == EnumUserType.Doctor ? self.getAppointments(index+1, sort: self.sort, refreshing: "0") : self.getMemberAppointments(index+1, sort: self.sort, refreshing: "0")
            }
        }
    }
    
    func setUpTableCell(){
        
        if appointments.count == 0 {
            self.countLabel.textColor = self.titles[selectedIndex].color
            self.countLabel.text = ""
            self.sortBtn.isHidden = true
        }else if appointments.count == 1{
            self.sortBtn.isHidden = false
            self.countLabel.textColor = self.titles[selectedIndex].color
            self.countLabel.text = titles[selectedIndex].rawValue == AppointmentScreenTxt.history ? "\(AppointmentScreenTxt.CancelAppointement.localize()) \(appointments.count)" : "\(titles[selectedIndex].rawValue.localize()) \(AppointmentScreenTxt.Appointments.localize()) \(appointments.count)"
        }else{
            self.sortBtn.isHidden = false
            self.countLabel.textColor = self.titles[selectedIndex].color
            self.countLabel.text = titles[selectedIndex].rawValue == AppointmentScreenTxt.history ? "\(AppointmentScreenTxt.CancelAppointement.localize()) \(appointments.count)" : "\(titles[selectedIndex].rawValue.localize()) \(AppointmentScreenTxt.Appointments.localize()) \(appointments.count)"
        }
        
        datasourceTable.array = appointments
        datasourceTable.identifier = PendingTableCell.identifier
        appointmentTableView.dataSource = datasourceTable
        appointmentTableView.delegate = datasourceTable
        appointmentTableView.tableFooterView = UIView()
        datasourceTable.configure = {cell, index in
            guard let pendingCell = cell as? PendingTableCell else { return }
            pendingCell.index = self.selectedIndex+1
            pendingCell.object = self.appointments[index]
            pendingCell.handler = { action in
                self.action = action
                if action == .rating {
                    NavigationHandler.pushTo(.rating(self.appointments[index]))
                }else {
                    DispatchQueue.main.async {
                        Authentication.customerType == EnumUserType.Doctor ? self.getAppointments(self.selectedIndex+1, sort: self.sort, refreshing: "0") : self.getMemberAppointments(self.selectedIndex+1, sort: self.sort, refreshing: "0")
                    }
                }
            }
            pendingCell.layoutIfNeeded()
            pendingCell.layoutSubviews()
        }
        datasourceTable.didScroll = {
        }
        datasourceTable.didSelect = {cell, index in
            guard let _ = cell as? PendingTableCell else { return}
        }
    }
    
    func getAppointments(_ status: Int,sort:String,refreshing:String){
        let queryItems = ["providerId": Authentication.customerGuid!, "status": status,"sortByOrder":sort] as [String : Any]
        if refreshing == "0"{
            self.view.activityStartAnimating(activityColor: .themeGreen, backgroundColor: UIColor.white)
        }
        WebService.manageDoctorAppointment(queryItems: queryItems) { (result) in
            DispatchQueue.main.async {
                switch result {
                case .success(let response):
                    self.appointments = response.objects ?? []
                    if self.appointments.count > 0 {
                        ez.runThisInMainThread {
                            self.setUpTableCell()
                            self.appointmentTableView.reloadData()
                        }
                    } else {
                        switch self.action {
                        case .pending:
                            self.selectedIndex = 2
                        case .confirm:
                            self.selectedIndex = 3
                        case .none:
                            break
                        case .rating:
                            break
                        }
                        
                        ez.runThisInMainThread {
                            self.setUpTableCell()
                            self.appointmentTableView.reloadData()
                        }
                    }
                case .failure(let error):
                    print(error)
                    self.appointments = []
                    self.setUpTableCell()
                    self.appointmentTableView.reloadData()
                //                    AlertManager.showAlert(type: .custom(error.message))
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
    func getMemberAppointments(_ status: Int,sort:String,refreshing:String)
    {
        let queryItems = ["memberId": Authentication.customerId!, "status": status,"sortByOrder":sort] as [String : Any]
        if refreshing == "0"{
            self.view.activityStartAnimating(activityColor: .themeGreen, backgroundColor: UIColor.white)
        }
        WebService.manageMemberAppointment(queryItems: queryItems) { (result) in
            DispatchQueue.main.async {
                switch result {
                case .success(let response):
                    
                    
                    ez.runThisInMainThread {
                        
                        self.appointments.removeAll()
                        
                        self.appointments = response.objects ?? []
                        self.setUpTableCell()
                        self.appointmentTableView.layoutIfNeeded()
                        self.appointmentTableView.reloadData()
                        self.view.layoutIfNeeded()
                    }
                    
                case .failure(let error):
                    print(error)
                    self.appointments = []
                    ez.runThisInMainThread {
                        self.setUpTableCell()
                        self.appointmentTableView.reloadData()
                    }
                // AlertManager.showAlert(type: .custom(error.message))
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
    
}








