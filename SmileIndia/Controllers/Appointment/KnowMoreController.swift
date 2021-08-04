//
//  BookAppointmentController.swift
//  SmileIndia
//
//  Created by Na on 07/07/19.
//  Copyright © 2019 Na. All rights reserved.
//

import UIKit
import MarqueeLabel
import EZSwiftExtensions

import MapKit
import SDWebImage

class ReviewTVC : UITableViewCell{
    
    
    
    @IBOutlet weak var cellVw: UIView!
    // Header
    @IBOutlet weak var headerLbl: UILabel!
    @IBOutlet weak var headerRatingVw: STRatingControl!
    
    // Normal Cell

    @IBOutlet weak var titleLbl: UILabel!
    @IBOutlet weak var descLbl: UILabel!
    @IBOutlet weak var cellRatingVw: STRatingControl!
    
    @IBOutlet weak var userImageView: UIImageView?
    
}


class KnowMoreController: UIViewController {
    
    var ReviewAppointements = [ReviewDetailsModel]()
    
    var reachability : Reachability {
        let reachability = Reachability()!
        return reachability
    }
    
    @IBOutlet weak var reviewTblVw: UITableView!
    
    @IBOutlet weak var tblHeight: NSLayoutConstraint!
    
    @IBOutlet weak var newRatingLabel: UILabel!
    @IBOutlet weak var newRatingView: STRatingControl!
    
    //  @IBOutlet weak var ReviewsHeaderLabel: UILabel!
    
    // @IBOutlet weak var PatientReviewsLabel: UILabel!
    
    @IBOutlet weak var badgeImgVw: UIImageView!
    @IBOutlet weak var badgeImgHeight: NSLayoutConstraint!
    
    
    @IBOutlet weak var phoneNoLbl: UILabel!
    
   // @IBOutlet weak var phoneBtn: UIButton!
    @IBOutlet weak var nameSV: UIStackView!
    @IBOutlet weak var AboutNameLabel: UILabel!
    @IBOutlet weak var profileImageView: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var degreeLabel: UILabel!
    @IBOutlet weak var specialityLabel: UILabel!
    @IBOutlet weak var expLabel: UILabel!
    @IBOutlet weak var cityNameLabel: UILabel!
    @IBOutlet weak var tellaboutLabel: UILabel!
    @IBOutlet weak var clinicLabel: UILabel!
    @IBOutlet weak var addressLabel: UILabel!
    //  @IBOutlet weak var ratingTableView: UITableView!
    // @IBOutlet weak var ratingLabel: UILabel!
    @IBOutlet weak var ratingView: STRatingControl!
    @IBOutlet weak var getLocationBtn: UIButton!
    
    @IBOutlet weak var overallRatingView: UIView!
    
    var object: Doctor?
    
    var datasourceTable = GenericDataSource()
    var phonenum = ""
    var radioTypeBtns:[UIButton] = []
    var typeId = ""
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        func openMapForPlace() {
            if let lat = Double(object?.Address1?[0].Latitude ?? "0.0") , let lng = Double(object?.Address1?[0].Longitude ?? "0.0")
            {
                let regionDistance:CLLocationDistance = 10000
                let coordinates = CLLocationCoordinate2DMake(lat, lng)
                let regionSpan = MKCoordinateRegion(center: coordinates, latitudinalMeters: regionDistance, longitudinalMeters: regionDistance)
                let mapItem = MKMapItem(placemark: MKPlacemark(coordinate: coordinates, addressDictionary:nil))
                mapItem.openInMaps(launchOptions: [MKLaunchOptionsDirectionsModeKey : MKLaunchOptionsDirectionsModeDriving, MKLaunchOptionsMapCenterKey: NSValue(mkCoordinate: regionSpan.center),MKLaunchOptionsMapSpanKey: NSValue(mkCoordinateSpan: regionSpan.span)])
            }
        }
        ratingView.rating = 5
        nameLabel.text = object?.ProviderName ?? ""
        AboutNameLabel.text = "\(FindDoctorScreenTxt.about.localize())  \(object?.ProviderName ?? "")"
        setStatusBar(color: .themeGreen)
        hideKeyboardWhenTappedAround()
        if object?.Degree  == "Others"{
            degreeLabel.text = "\(object?.OtherDegree ?? "")"
        }else if object?.OtherDegree == nil || object?.OtherDegree == ""{
            degreeLabel.text = "\(object?.Degree ?? "")"
        }else{
            degreeLabel.text = "\(object?.Degree ?? ""), \(object?.OtherDegree ?? "")"
        }
        if object?.Practice  == "Others"{
            specialityLabel.text = "\(object?.Otherspeciality ?? "" )"
        }
        else if object?.Otherspeciality == nil || object?.Otherspeciality == ""{
            specialityLabel.text = "\(object?.Practice ?? "")"
        }
        else{
            specialityLabel.text = "\(object?.Practice ?? ""), \(object?.Otherspeciality ?? "")"
        }
        phonenum = "\(object?.CountryCode ?? "")\(object?.PhoneNo ?? "")"
        print(phonenum)
       // phoneBtn.setTitle(phonenum, for: .normal)
        phoneNoLbl.text = phonenum
//        cityNameLabel.text = object?.CityName ?? ""
        tellaboutLabel.text = object?.TellAboutYourSelf ?? ""
        profileImageView.sd_setImage(with: object?.imageURL, placeholderImage: UIImage.init(named: object?.CustomerTypeId == 1 ? "doctor-avtar" : "hospital-avtar"))
        if let address1 = object?.Address1?[0] {
            addressLabel.text = "\(address1.Address ?? ""),\(address1.ZipCode ?? "")"
        }
        if let address1 = object?.Address1?[0] {
            clinicLabel.text = address1.HospitalName ?? ""
        }
        
        if let address1 = object?.Address1?[0] {
            let rate = Int(address1.Rating ?? "0") ?? 0
            ratingView.rating = rate
            // ratingView.isHidden = !(rate > 0)
            
            newRatingLabel.text = "\(String(describing: /address1.Rating?.toDouble()))"
            newRatingView.rating = rate
            
            cityNameLabel.text = address1.Address
            
        }else{
            cityNameLabel.text = object?.CityName ?? ""
        }
        
        if (object?.Experience) != nil || object?.Experience == "" {
            expLabel.isHidden = false
            if object?.Experience == "1"{
                expLabel.text = "\(object?.Experience ?? "")  \(FindDoctorScreenTxt.yrOfExp.localize())"
            }
            else{
                expLabel.text = "\(object?.Experience ?? "")  \(FindDoctorScreenTxt.yrOfExp.localize())  "
            }
        }
        else{
            self.expLabel.isHidden = true
        }
        
        // Arjun Code // hide - show phone Number
        if  object?.Address1?[0].Paymentstatus == true && object?.Address1?[0].PlanName != EnumPlan.Silver && object?.PhoneNo != ""{
           // phoneBtn.isHidden = false

        }
        else{
           // phoneBtn.isHidden = true
            phoneNoLbl.text = ""
        }
        
        self.badgeImgVw.isHidden = true
        
        if self.object?.Address1?[0].PlanName == EnumPlan.Silver{
            badgeImgVw.isHidden = false
            self.badgeImgVw.image =  #imageLiteral(resourceName: "silver")
            badgeImgHeight.constant = 15

        }
        else if self.object?.Address1?[0].PlanName == EnumPlan.Gold {
            badgeImgVw.isHidden = false
            self.badgeImgVw.image =  #imageLiteral(resourceName: "gold")
            badgeImgHeight.constant = 15
        }
        
        else if self.object?.Address1?[0].PlanName == EnumPlan.Platinum{
            badgeImgVw.isHidden = false
            self.badgeImgVw.image =  #imageLiteral(resourceName: "platinum")
            badgeImgHeight.constant = 15
        }else {
            badgeImgVw.isHidden = true
            badgeImgHeight.constant = 0
        }
        
      
        // Tap Guesture on Call
        
        phoneNoLbl.addTapGesture { [self] (tap) in
            
            guard let number = URL(string: "tel://" + (self.phonenum)) else { return }
            UIApplication.shared.open(number, options: [:], completionHandler: nil)
            
        }
        
        self.reviewTblVw.layoutSubviews()
        self.reviewTblVw.layoutIfNeeded()
        self.reviewTblVw.reloadData()
        self.tblHeight.constant = self.reviewTblVw.contentSize.height
        self.view.layoutIfNeeded()
        
        self.tblHeight.constant = self.reviewTblVw.contentSize.height
        
        // Get Reviews
        getRatedAppointments()
    }
    override func viewWillAppear(_ animated: Bool) {
        // self.showRating()
        if #available(iOS 13.0, *) {
            overallRatingView.borderColor = .label
        } else {
            // Fallback on earlier versions
        }
    }
    
    override func traitCollectionDidChange(_ previousTraitCollection: UITraitCollection?) {
        // do whatever you want to do
        print("mode change")
        
        if #available(iOS 13.0, *) {
            overallRatingView.borderColor = .label
            self.reviewTblVw.borderColor = .label
        } else {
            // Fallback on earlier versions
        }
        
        self.view.layoutIfNeeded()
    }
    
//    @IBAction func didTapCall(_ sender: Any) {
//        guard let number = URL(string: "tel://" + (phonenum)) else { return }
//        UIApplication.shared.open(number, options: [:], completionHandler: nil)
//    }
    @IBAction func didTapLocation(_ sender: Any) {
        openMapForPlace()
        
    }
    @IBAction func didTapBackButton(_ sender: Any){
        NavigationHandler.pop()
    }
}

extension KnowMoreController {
    func openMapForPlace() {
        if let lat = Double(object?.Address1?[0].Latitude ?? "0.0") , let lng = Double(object?.Address1?[0].Longitude ?? "0.0")
        {
            let regionDistance:CLLocationDistance = 10000
            let coordinates = CLLocationCoordinate2DMake(lat, lng)
            let regionSpan = MKCoordinateRegion(center: coordinates, latitudinalMeters: regionDistance, longitudinalMeters: regionDistance)
            let mapItem = MKMapItem(placemark: MKPlacemark(coordinate: coordinates, addressDictionary:nil))
            mapItem.openInMaps(launchOptions: [MKLaunchOptionsDirectionsModeKey : MKLaunchOptionsDirectionsModeDriving, MKLaunchOptionsMapCenterKey: NSValue(mkCoordinate: regionSpan.center),MKLaunchOptionsMapSpanKey: NSValue(mkCoordinateSpan: regionSpan.span)])
        }
    }
}

extension KnowMoreController : UITableViewDelegate,UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        
        let headerCell = tableView.dequeueReusableCell(withIdentifier: "ReviewHeaderCell") as! ReviewTVC
        
        headerCell.headerLbl.text = self.ReviewAppointements.count > 0 ? FindDoctorScreenTxt.allReviews.localize() : FindDoctorScreenTxt.patientReviews.localize()
        headerCell.headerRatingVw.isHidden = self.ReviewAppointements.count > 0 ? false : true
        
        if let address1 = object?.Address1?[0] {
            let rate = Int(address1.Rating ?? "0") ?? 0
            headerCell.headerRatingVw.rating = rate
            // ratingView.isHidden = !(rate > 0)
        }
        
        return headerCell
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if  self.ReviewAppointements.count > 0{
            return self.ReviewAppointements.count
        }
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        if  self.ReviewAppointements.count > 0{
           let cell = tableView.dequeueReusableCell(withIdentifier: "ReviewCell", for: indexPath as IndexPath) as! ReviewTVC
            
            let reviewDic : ReviewDetailsModel? = self.ReviewAppointements[indexPath.row]
            cell.cellRatingVw.rating = /reviewDic?.starRating?.toInt()
//            cell.nameLbl.text = /reviewDic?.reviwerName?.trimmed().first(char: 1).uppercased()
            cell.titleLbl.text = /reviewDic?.reviwerName
            cell.descLbl.text = /reviewDic?.review
            
            let attributes: [NSAttributedString.Key: Any] = [
                .foregroundColor: UIColor.white,
                .font: UIFont.boldSystemFont(ofSize: 20)
            ]
            
            cell.userImageView?.setNameImage(string: /reviewDic?.reviwerName, color: UIColor.systemGray, circular: true,textAttributes:attributes)
            
            return cell
            
        }else{
            let cell = tableView.dequeueReusableCell(withIdentifier: "NoReviewCell", for: indexPath as IndexPath) as! ReviewTVC
            return cell
        }
        
    }
    
   
}


extension KnowMoreController {
    func getRatedAppointments()
    {
        let queryItems = ["DoctorEmail": /object?.Email,"IsPublic":true] as [String : Any]
        self.view.activityStartAnimating(activityColor: #colorLiteral(red: 0.233, green: 0.816, blue: 0.538, alpha: 1), backgroundColor: UIColor.white)
        WebService.getRatedAppointments(queryItems: queryItems) { (result) in
            DispatchQueue.main.async {
                activityIndicator.hideLoader()
                switch result {
                case .success(let response):
                    if let ratingList = response.objects {
                        
                        ez.runThisInMainThread {
                            
                            self.ReviewAppointements = ratingList
                            
                            if self.ReviewAppointements.count > 0 {
                                
                                self.reviewTblVw.layoutSubviews()
                                self.reviewTblVw.layoutIfNeeded()
                                self.reviewTblVw.reloadData()
                                self.tblHeight.constant = self.reviewTblVw.contentSize.height
                                self.view.layoutIfNeeded()
                                
                                self.tblHeight.constant = self.reviewTblVw.contentSize.height
                            }else{
                               // self.tblHeight.constant = 50
                            }
                            
                            
                            
                        }
                        
                        
                    }
                case .failure(let error):
                    print(error)
                }
                self.view.activityStopAnimating()
            }
        }
    }
}

extension String {
    subscript(i: Int) -> String {
        return String(self[index(startIndex, offsetBy: i)])
    }
}

extension String {
   func first(char:Int) -> String {
        return String(self.prefix(char))
    }

    func last(char:Int) -> String
    {
        return String(self.suffix(char))
    }

    func excludingFirst(char:Int) -> String {
        return String(self.suffix(self.count - char))
    }

    func excludingLast(char:Int) -> String
    {
         return String(self.prefix(self.count - char))
    }
 }


