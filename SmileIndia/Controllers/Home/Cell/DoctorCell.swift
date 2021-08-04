//
//  DoctorCell.swift
//  SmileIndia
//
//  Created by Na on 18/02/19.
//  Copyright © 2019 Na. All rights reserved.
//
struct Device {
    static let IS_IPAD = UIDevice.current.userInterfaceIdiom == .pad
    static let IS_IPHONE = UIDevice.current.userInterfaceIdiom == .phone
}
enum Event {
    case appointment
    case rating
    case knowmore
    
}

import UIKit
import MapKit
import SDWebImage
import MarqueeLabel
class DoctorCell: UITableViewCell , ReusableCell{
    
    
    //  @IBOutlet weak var tellaboutImage: UIImageView!
    // @IBOutlet weak var tellaboutLabel: MarqueeLabel!
    
    @IBOutlet weak var tdLabel: UILabel!
    
    @IBOutlet weak var btnMap: UIButton!
    
    @IBOutlet weak var timeLabel: UILabel!
    @IBOutlet weak var shareBtn: UIButton!
    @IBOutlet weak var bookBtn: UIButton!
    @IBOutlet weak var borderView: UIView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var specialityLabel: UILabel!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var phoneLabel: UIButton!
    @IBOutlet weak var regnoLabel: UILabel!
    @IBOutlet weak var addressLabel: MarqueeLabel!
    @IBOutlet weak var eFeeLabel: UILabel!
    @IBOutlet weak var EconsultationFeeLabel: UILabel!
    @IBOutlet weak var consultationFeeLabel: UILabel!
    @IBOutlet weak var priceLabel: UILabel!
    // @IBOutlet weak var availabilityLabel: UILabel!
    @IBOutlet weak var profileImageView: UIImageView!
    @IBOutlet weak var rating: STRatingControl!
    @IBOutlet weak var callBtn: UIButton!
    @IBOutlet weak var callImg: UIImageView!
    //   @IBOutlet weak var typeLabel: UILabel!
    @IBOutlet weak var timeSlotLabel: UILabel!
    @IBOutlet weak var timeSlotView: UIView!
    @IBOutlet weak var timeSlotViewHeight: NSLayoutConstraint!
    @IBOutlet weak var locationBtn: UIButton!
    @IBOutlet weak var ratingLabel: UILabel!
    @IBOutlet weak var mapView: MKMapView!
    typealias Handler =   ([AddressTiming])->()
    var handler : Handler?
    typealias EventHandler =   (Event, Doctor)->()
    var handlingEvent : EventHandler?
    var YearsOfExperience = ""
    var phonenum = ""
    var timezone = ""
    //  @IBOutlet weak var degreeImage: UIImageView!
    
    //  @IBOutlet weak var constraintDegreeHeight: NSLayoutConstraint!
    
    @IBOutlet weak var imgBanner: UIImageView!
    
    //    @IBOutlet weak var econsultLabel: UILabel!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        selectionStyle = .none
        self.layer.cornerRadius = 5
        borderView.layer.masksToBounds = true
        borderView.layer.cornerRadius = 5
        borderView.layer.borderWidth = 2
        borderView.layer.shadowOffset = CGSize(width: -1, height: 1)
        borderView.layer.borderColor = UIColor.init(red: 240/255, green: 240/255, blue: 240/255, alpha: 1.0).cgColor
        
        if  Authentication.customerType == EnumUserType.Doctor{
            bookBtn.isHidden = true
        }
        
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    
    var object : Doctor? {
        didSet{
            
            if object?.Experience == "1" {
                YearsOfExperience = " 1 \(FindDoctorScreenTxt.yrOfExp.localize())"
            }else{
                YearsOfExperience = "\(object?.Experience ?? "") \(FindDoctorScreenTxt.yrOfExp.localize())"
            }
            
            nameLabel.text = object?.ProviderName ?? ""
            if object?.AvailableDayMsg == ""{
                timeSlotViewHeight.constant = 0
            }
            else{
                timeSlotViewHeight.constant = 30
                timeSlotLabel.text = object?.AvailableDayMsg
            }
           
            callBtn.isHidden = false
            callImg.isHidden = false
            phonenum = "\(object?.CountryCode ?? "")\(object?.PhoneNo ?? "")"
            callBtn.setTitle(phonenum, for: .normal)
            //            if object?.Degree  == "Others"{
            //
            //              specialityLabel.text = "\(object?.Practice ?? ""),\n\(object?.CityName ?? ""),\n\(YearsOfExperience)"
            //            }else if object?.OtherDegree == nil || object?.OtherDegree == ""{
            //            specialityLabel.text = "\(object?.Practice ?? ""),\n\(object?.CityName ?? ""),\n\(YearsOfExperience)"
            //            }else
            //            {
            //   specialityLabel.text = "\(object?.Practice ?? ""),\n\(object?.CityName ?? ""),\n\(YearsOfExperience)"
            //      }
            var lblTxt = "\(/object?.Practice),\n\(/object?.Otherspeciality),\(/object?.CityName),\n\(YearsOfExperience)"
            lblTxt = lblTxt.replacingOccurrences(of: ",,", with: ",")
            
            lblTxt = lblTxt.replacingOccurrences(of: ",\n,", with: ",\n")
            specialityLabel.text =  lblTxt
            
            
            if let address1 = object?.Address1?[0] {
                addressLabel.text = /address1.Address + " ,\(/address1.ZipCode)"
                let rate = Int(address1.Rating ?? "0") ?? 0
                rating.rating = rate
                ratingLabel.isHidden = !(rate > 0)
                rating.isHidden = !(rate > 0)
                ratingLabel.text = "\(rate) \(FindDoctorScreenTxt.Rating.localize())"
                ratingLabel.font = UIFont.systemFont(ofSize: Authentication.appLanguage == EnumAppLanguage.English ? 10 : 6)
                ratingLabel.lineBreakMode = .byWordWrapping
                regnoLabel.text = address1.HospitalName ?? ""
                
            }
            
            profileImageView.sd_setImage(with: object?.imageURL, placeholderImage: UIImage.init(named: object?.CustomerTypeId == 1 ? "doctor-avtar" : "hospital-avtar"))
            // let ConsultantFee = "$200.00" = "\u{20B9}"
            
            if Int(object?.EConsultationFee ?? "0") == 0 || object?.EConsultationFee == "" {
                EconsultationFeeLabel.isHidden = true
//                eFeeLabel.isHidden = true
            }else {
                EconsultationFeeLabel.isHidden = false
//                eFeeLabel.isHidden = false
                
                let test1Attributes:[NSAttributedString.Key: Any] = [.font : UIFont.systemFont(ofSize: Authentication.appLanguage == EnumAppLanguage.English ? 10 : 10, weight: .semibold)]
                let test2Attributes:[NSAttributedString.Key: Any] = [.font : UIFont.systemFont(ofSize: Authentication.appLanguage == EnumAppLanguage.English ? 10 : 10, weight: .regular)]

                let test1 = NSAttributedString(string: FindDoctorScreenTxt.EConsultationFee.localize(), attributes:test1Attributes)
                let test2 = NSAttributedString(string: " $ \(object?.EConsultationFee ?? "0")", attributes:test2Attributes)
                let text = NSMutableAttributedString()
                
                text.append(test1)
                text.append(test2)
                
                EconsultationFeeLabel.attributedText = text
                EconsultationFeeLabel.lineBreakMode = .byWordWrapping
                
            }

            // Consultation fee
            let test1Attributes:[NSAttributedString.Key: Any] = [.font : UIFont.systemFont(ofSize: Authentication.appLanguage == EnumAppLanguage.English ? 10 : 10, weight: .semibold)]
            let test2Attributes:[NSAttributedString.Key: Any] = [.font : UIFont.systemFont(ofSize: Authentication.appLanguage == EnumAppLanguage.English ? 10 : 10, weight: .regular)]

            let test1 = NSAttributedString(string: FindDoctorScreenTxt.consultationFee.localize(), attributes:test1Attributes)
            let test2 = NSAttributedString(string: " $ \(object?.ConsultantFee ?? 0)", attributes:test2Attributes)
            let text = NSMutableAttributedString()
            
            text.append(test1)
            text.append(test2)
            
            consultationFeeLabel.attributedText = text
            consultationFeeLabel.lineBreakMode = .byWordWrapping
            
            // Member fee
            let memberAttr:[NSAttributedString.Key: Any] = [.font : UIFont.systemFont(ofSize: 10, weight: .semibold),
                                                            .foregroundColor : UIColor.themeGreen
            
            ]
            let memberAttr2:[NSAttributedString.Key: Any] = [.font : UIFont.systemFont(ofSize: 10, weight: .regular)]

            let memberTxt = NSAttributedString(string: FindDoctorScreenTxt.MemberFee.localize(), attributes:memberAttr)
            let memberTxt2 = NSAttributedString(string: " $ \(object?.DiscountOffered ?? "0")", attributes:memberAttr2)
            let membermainTxt = NSMutableAttributedString()
            
            membermainTxt.append(memberTxt)
            membermainTxt.append(memberTxt2)
            
            priceLabel.attributedText = membermainTxt
            
            
          //  priceLabel.text = FindDoctorScreenTxt.MemberFee.localize() + " $ \(object?.DiscountOffered ?? "0")"
            specialityLabel.isHidden =  object?.CustomerTypeId == 4
            //   constraintDegreeHeight.constant = object?.CustomerTypeId == 1 ? 15 : 0
            //  setMapView()
            
            if object?.TreatmentDiscount ?? "" == ""{
                if(Device.IS_IPHONE){
                    self.attributingWithColorWithFontSize(label: tdLabel, boldTxt: "", regTxt: "", color: .themeGreen, fontSize: 13)
                }else{
                    self.attributingWithColorWithFontSize(label: tdLabel, boldTxt: "", regTxt: "", color: .themeGreen, fontSize: 18)
                }
            }else{
                if(Device.IS_IPHONE){
                    self.attributingWithColorWithFontSize(label: tdLabel, boldTxt: FindDoctorScreenTxt.UinSuredtreatMentDisc.localize(), regTxt: "\(object?.TreatmentDiscount ?? "")" + "%", color: .themeGreen, fontSize: 13)
                }else{
                    self.attributingWithColorWithFontSize(label: tdLabel, boldTxt: FindDoctorScreenTxt.UinSuredtreatMentDisc.localize(), regTxt: "\(object?.TreatmentDiscount ?? "")" + "%", color: .themeGreen, fontSize: 18)
                }
            }
            //            print("Paymentstatus :- \(/object?.ProviderName)")
            //            print("Paymentstatus :- \(/object?.Address1?[0].Paymentstatus)")
            //            print("PlanName :- \(/object?.Address1?[0].PlanName)")
            //            print("PhoneNo :- \(/object?.PhoneNo)")
            //
            if  object?.Address1?[0].Paymentstatus == true && object?.Address1?[0].PlanName != EnumPlan.Silver && object?.PhoneNo != ""{
                callBtn.isHidden = false
                callImg.isHidden = false
            }
            else{
                callBtn.isHidden = true
                callImg.isHidden = true
            }
            //            if self.object?.Address1?[0].SubscriptionTypeId ?? 0 == 1 ||  self.object?.Address1?[0].SubscriptionTypeId ?? 0 == 4{
            //                imgBanner.isHidden = false
            //                self.imgBanner.image =  #imageLiteral(resourceName: "silver")
            //
            //            }else if self.object?.Address1?[0].SubscriptionTypeId ?? 0 == 2 ||  self.object?.Address1?[0].SubscriptionTypeId ?? 0 == 5 {
            //                imgBanner.isHidden = false
            //                self.imgBanner.image =  #imageLiteral(resourceName: "gold")
            //            }else if self.object?.Address1?[0].SubscriptionTypeId ?? 0 == 3 ||  self.object?.Address1?[0].SubscriptionTypeId ?? 0 == 6{
            //                imgBanner.isHidden = false
            //                self.imgBanner.image =  #imageLiteral(resourceName: "platinum")
            //            }else {
            //                imgBanner.isHidden = true
            //            }
            
            
            if self.object?.Address1?[0].PlanName == EnumPlan.Silver{
                imgBanner.isHidden = false
                self.imgBanner.image =  #imageLiteral(resourceName: "silver")
                
            }
            else if self.object?.Address1?[0].PlanName == EnumPlan.Gold {
                imgBanner.isHidden = false
                self.imgBanner.image =  #imageLiteral(resourceName: "gold")
            }
            else if self.object?.Address1?[0].PlanName == EnumPlan.Platinum{
                imgBanner.isHidden = false
                self.imgBanner.image =  #imageLiteral(resourceName: "platinum")
            }else {
                imgBanner.isHidden = true
            }
        }
    }
    
    @IBAction func didTapCall(_ sender: Any) {
        print(phonenum)
        guard let number = URL(string: "tel://" + (phonenum)) else { return }
        UIApplication.shared.open(number, options: [:], completionHandler: nil)
    }
    
    @IBAction func didTapAllTimings(_ sender: Any) {
        handlingEvent?(.knowmore, object!)
    }
    
    func setMapView(){
        let annotation = MKPointAnnotation()
        
        if let lat = Double(object?.Address1?[0].Latitude ?? "0.0") , let lng = Double(object?.Address1?[0].Longitude ?? "0.0")
        {
            if lat == 0.0 && lng == 0.0 {
                self.mapView.removeAnnotations(self.mapView.annotations)
                self.mapView.annotations.forEach {
                    if !($0 is MKUserLocation) {
                        self.mapView.removeAnnotation($0)
                    }
                }
                btnMap.setImage(#imageLiteral(resourceName: "sample_map"), for: .normal)
                
            }else
            {
                btnMap.setImage(nil, for: .normal)
                annotation.coordinate = CLLocationCoordinate2D(latitude: lat, longitude: lng )
                mapView.addAnnotation(annotation)
                let location: CLLocationCoordinate2D = CLLocationCoordinate2DMake(lat, lng)
                let region: MKCoordinateRegion = MKCoordinateRegion(center: location, span: MKCoordinateSpan(latitudeDelta: 0.5, longitudeDelta: 0.5))
                mapView.setRegion(region, animated: true)
            }
        }
    }
    @IBAction func didTapBookAppointment(_ sender: Any) {
        
        if !(Authentication.isUserLoggedIn ?? false) {
            AlertManager.showAlert(type: .custom(FindDoctorScreenTxt.loginFirst.localize())) {
                NavigationHandler.pushTo(.login)
            }
        }else
        {
            handlingEvent?(.appointment, object!)
        }
    }
    
    @IBAction func didTapRateThisPerson(_ sender: Any) {
        handlingEvent?(.rating, object!)
    }
    
    @IBAction func didTapShare(_ sender: Any) {
        
        handler?(object?.Address1Timming ?? [])
        
    }
    
    @IBAction func didTapLocation(_ sender: Any) {
        openMapForPlace()
    }
    /*  @IBAction func didTapMapView(_ sender: Any) {
     if btnMap.hasImage(named: "sample_map.png", for: .normal) {
     AlertManager.showAlert(type: .custom("Location not available!"))
     }else
     {
     openMapForPlace()
     }
     }*/
    
    func openMapForPlace() {
        if let lat = Double(object?.Address1?[0].Latitude ?? "0.0") , let lng = Double(object?.Address1?[0].Longitude ?? "0.0")
        {
            
            let regionDistance:CLLocationDistance = 10000
            let coordinates = CLLocationCoordinate2DMake(lat, lng)
            let regionSpan = MKCoordinateRegion(center: coordinates, latitudinalMeters: regionDistance, longitudinalMeters: regionDistance)
            let mapItem = MKMapItem(placemark: MKPlacemark(coordinate: coordinates, addressDictionary:nil))
            //            mapItem.name = "Target location"
            mapItem.openInMaps(launchOptions: [MKLaunchOptionsDirectionsModeKey : MKLaunchOptionsDirectionsModeDriving, MKLaunchOptionsMapCenterKey: NSValue(mkCoordinate: regionSpan.center),MKLaunchOptionsMapSpanKey: NSValue(mkCoordinateSpan: regionSpan.span)])
        }
    }
    
}




