//
//  RatingListViewController.swift
//  SmileIndia
//
//  Created by Na on 21/07/19.
//  Copyright © 2019 Na. All rights reserved.
//

import UIKit
import MarqueeLabel

class RatingListViewController: UIViewController {
    @IBOutlet weak var profileImageView: UIImageView!
    @IBOutlet weak var ratingView: STRatingControl!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var ratinglabel: UILabel!
    @IBOutlet weak var ratingTableView: UITableView!
    @IBOutlet weak var degreeLabel: MarqueeLabel!
    @IBOutlet weak var phoneLabel: UILabel!
    @IBOutlet weak var votesLabel: UILabel!
    @IBOutlet weak var tellAboutLabel: UILabel!
    @IBOutlet weak var defaulterLabel: UILabel!
    
    @IBOutlet weak var ratelbl: UILabel!
    

    var datasourceTable = GenericDataSource()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        setStatusBar(color: .themeGreen)
        self.defaulterLabel.text = ""

    }
    
    override func viewWillAppear(_ animated: Bool) {
        showRating()
        NotificationCenter.default.addObserver(self, selector: #selector(self.replyNotificationReceived(notification:)), name: Notification.Name("reply"), object: nil)
        if Authentication.customerType == EnumUserType.Doctor {
            self.customerInfo()
        }
    }
    func customerInfo(){
        let queryItems = ["Email": Authentication.customerEmail ?? ""] as [String: Any]
        WebService.customerInfo(queryItems: queryItems) { (result) in
            DispatchQueue.main.async {
                switch result {
                case .success(let response):
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
   @objc func replyNotificationReceived(notification: Notification){
        showRating()
    }
    
    @IBAction func didTapBackButton(_ sender: Any){
        NavigationHandler.pop()
    }
   
}
extension RatingListViewController {
    func showRating()
    {
        let queryItems = ["CustomerID": Authentication.customerGuid!] as [String : Any]
        self.view.activityStartAnimating(activityColor: #colorLiteral(red: 0.233, green: 0.816, blue: 0.538, alpha: 1), backgroundColor: UIColor.white)
        WebService.showrating(queryItems: queryItems) { (result) in
            DispatchQueue.main.async {
                switch result {
                case .success(let response):
                    print(response)
                    if let rating = response.object {
                    self.setView(rating)
                        
                        self.getRatedAppointments()
                        
//                        if rating.TotalVotes ??  0 > 0 {
//                           self.getRatedAppointments()
//                        }else{
//                            self.setUpTableCell([])
//                            self.ratingTableView.reloadData()
//                        }
                    }
//                    self.appointments = response.objects ?? []
                case .failure(let error):
                    print(error)
                }
                self.view.activityStopAnimating()
            }
        }
    }
    func getRatedAppointments()
    {
       // let queryItems = ["Providerid": Authentication.customerGuid!] as [String : Any]
        let queryItems = ["DoctorEmail": /Authentication.customerEmail] as [String : Any]
        self.view.activityStartAnimating(activityColor: #colorLiteral(red: 0.233, green: 0.816, blue: 0.538, alpha: 1), backgroundColor: UIColor.white)
        WebService.getRatedAppointments(queryItems: queryItems) { (result) in
            DispatchQueue.main.async {
                activityIndicator.hideLoader()
                switch result {
                case .success(let response):
                    if let ratingList = response.objects {
                        DispatchQueue.main.async {
                            self.setUpTableCell(ratingList)
                            self.ratingTableView.reloadData()
                        }
                    }
                case .failure(let error):
                    print(error)
                    self.setUpTableCell([])
                    self.ratingTableView.reloadData()
                }
                self.view.activityStopAnimating()
            }
        }
    }
    
    func setView(_ rating: Rating){
        DispatchQueue.main.async {
            
            self.profileImageView.sd_setImage(with: rating.imageURL, placeholderImage: UIImage.init(named: "doctor-avtar"))
            
            self.nameLabel.text = rating.ProviderName
            self.ratingView.rating = Int(rating.AvarageRating ?? "0") ?? 0
            
            self.ratelbl.text  = "\(/rating.AvarageRating?.toDouble()) \(RatingListScreenTxt.rating.localize())"
            
            var degree = /rating.Degree
            
            if rating.OtherDegree != "" {
                degree = degree + ",\(/rating.OtherDegree)"
            }
            
            self.degreeLabel.text = degree
           // self.phoneLabel.text = rating.PhoneNo
            
            if /rating.TotalVotes > 0 {
                self.votesLabel.text = "\(RatingListScreenTxt.votes.localize()) : \(rating.TotalVotes ?? 0)"
            }else{
                self.votesLabel.text = ""
            }
            
           
           // self.votesLabel.text = ""
            self.tellAboutLabel.text = rating.TellAboutYourSelf ?? ""
            
            self.attributingWithColorForVC(label: self.phoneLabel, boldTxt: RatingListScreenTxt.RegNo.localize(), regTxt: "\(rating.RegistrationNo ?? "")", color: .themeGreen, fontSize: 11, firstFontWeight: .bold, secFontWeight: .semibold)
            
           // self.phoneLabel.text = ""
            
//           self.ratinglabel.text = "\(rating.AvarageRating ?? "0") Rating"
//           if self.ratinglabel.text == "0 Rating"{
//            self.ratinglabel.text = ""
//          }
        }
        
    }
    
    func setUpTableCell(_ appointments: [ReviewDetailsModel]){
        self.ratinglabel.text = appointments.count > 0 ? "\(appointments.count) \(RatingListScreenTxt.reviews.localize())" : ""
        self.ratinglabel.textColor = .themeGreen
        datasourceTable.array = appointments
        datasourceTable.identifier = RatingTableViewCell.identifier
        ratingTableView.dataSource = datasourceTable
        ratingTableView.delegate = datasourceTable
        ratingTableView.tableFooterView = UIView()
        datasourceTable.configure = {cell, index in
            guard let ratingCell = cell as? RatingTableViewCell else { return }
            ratingCell.object = appointments[index]
            ratingCell.layoutSubviews()
            ratingCell.layoutIfNeeded()
        }
//        datasourceTable.didScroll = {
//        }
        datasourceTable.didSelect = {cell, index in
          //  guard let _ = cell as? PendingTableCell else { return}
        }
    }
}
