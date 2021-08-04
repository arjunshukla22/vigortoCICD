//
//  AppointmentDetailsVC.swift
//  SmileIndia
//
//  Created by Arjun  on 05/08/20.
//  Copyright © 2020 Na. All rights reserved.
//

import UIKit
import MapKit
import SDWebImage


class AppointmentDetailsVC: UIViewController {
    
    
    @IBOutlet weak var aptypeLabel: UILabel!
    @IBOutlet weak var usertypeLabel: UILabel!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var timeLabel: UILabel!
    @IBOutlet weak var ageLabel: UILabel!
    @IBOutlet weak var reasonLabel: UILabel!
    @IBOutlet weak var statusLabel: UILabel!
    @IBOutlet weak var cmtLabel: UILabel!
    
    @IBOutlet weak var LblbPaymentInfo: UILabel!
    @IBOutlet weak var collectionFiles: UICollectionView!
    @IBOutlet weak var mapView: MKMapView!
    
    @IBOutlet weak var btnViewAll: UIButton!
    
    @IBOutlet weak var memberFilesLabel: UILabel!
    @IBOutlet weak var memberFilesView: UIView!
    @IBOutlet weak var btnConfirm: UIButton!
    @IBOutlet weak var btnCancel: UIButton!
    @IBOutlet weak var btnUpload: UIButton!
    @IBOutlet weak var btnReschedule: UIButton!
    
    //   @IBOutlet weak var btnPrescribe: UIButton!
    
    @IBOutlet weak var btnDelete: UIButton!
    @IBOutlet weak var btnRate: UIButton!
    
    @IBOutlet weak var btnRateVw: UIView!
    @IBOutlet weak var btnComplete: UIButton!
    
    //  @IBOutlet weak var btnViewPrescription: UIButton!
    @IBOutlet weak var btnDrnotavailable: UIButton!
    
    @IBOutlet weak var btnPatientnotavailable: UIButton!
    
    @IBOutlet weak var btnRefund: UIButton!
    @IBOutlet weak var btnRefundTaken: UIButton!
    
    @IBOutlet weak var cancelLabel: UILabel!
    
    
    @IBOutlet weak var btnMap: UIButton!
    
    
    @IBOutlet weak var apnmtTypeLabel: UILabel!
    @IBOutlet weak var relationHeadLbl: UILabel!
    @IBOutlet weak var relationLabel: UILabel!
    @IBOutlet weak var patientNameLabel: UILabel!
    
    @IBOutlet weak var phoneNumStack: UIStackView!
    @IBOutlet weak var btnPhoneNumber: UIButton!
    
   // @IBOutlet weak var btnPaymentInfo: UIButton!
    
    
    @IBOutlet weak var btnPaymentInfo: ButtonWithImage!
    
    @IBOutlet weak var bottomVwHeight: NSLayoutConstraint!
    
    @IBOutlet weak var memberfilesVwHeight: NSLayoutConstraint!
    
    var appid = ""
    var  object: Appointment?
    var drPrescriptionFiles = [DoctorPrescriptionFiles]()
    
    var memberFiles = [MemberFiles]()
    
    var selectedIndex = 0
    
    var  prescriptionData: DrPrescription?
    var drPrescription = ""
    
    var  refundOptions: RefundOptions?
    
    var prescribed = false
    var subscriptionStatus = "0"
    
    @IBOutlet weak var bottomMenuView: UIView!
    
    @IBOutlet weak var updateInsuranceBtn: UIButton!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        setStatusBar(color: .themeGreen)
        
        self.SetupUi()
        btnReschedule.isHidden = true
        //   allowedRefundOption(self.object?.Id ?? 0)
        
        btnConfirm.alignTextBelow()
        btnCancel.alignTextBelow()
        btnDelete.alignTextBelow()
        btnReschedule.alignTextBelow()
        btnUpload.alignTextBelow()
        btnRefund.alignTextBelow()
        btnComplete.alignTextBelow()
        self.phoneNumStack.isHidden = true
        
    }
    
    
    override func viewWillAppear(_ animated: Bool) {
        self.getSubscriptionStatus()
        self.getAppointmentData()
        self.getMemberFiles()
        if self.object?.Status == "2"{
            self.getDoctorPrescriptionforCheck()
        }
        
        NotificationCenter.default.addObserver(self, selector: #selector(self.insurancecardNotificationReceived(notification:)), name: Notification.Name("insurancecard"), object: nil)
        
    }
    
    @objc func insurancecardNotificationReceived(notification: Notification){
        self.getAppointmentData()
    }
    
    func getAppointmentData() -> Void {
        let queryItems = ["AppointmentID": "\(self.object?.Id ?? 0)"]
        self.view.activityStartAnimating(activityColor: .themeGreen, backgroundColor: UIColor.white)
        WebService.getAppointmentDataForIOSVideoCall(queryItems: queryItems) { (result) in
            DispatchQueue.main.async {
                switch result {
                case .success(let response):
                    self.object = response.object
                    self.SetupUi()
                case .failure(let error):
                    print(error.message)
                }
                self.view.activityStopAnimating()
            }
        }
    }
    
    func getMemberFiles() -> Void {
        let queryItems = ["Appid": "\(object?.Id ?? 0)", "MemberId":"\(object?.MemberId ?? 0)"]
        self.view.activityStartAnimating(activityColor: .themeGreen, backgroundColor: UIColor.white)
        WebService.getMemberFiles(queryItems: queryItems) { (result) in
            DispatchQueue.main.async {
                switch result {
                case .success (let response):
                    self.memberFiles =  response.objects ?? []
                    self.memberfilesVwHeight.constant = self.memberFiles.count > 0 ? 220 : 100
                    self.collectionFiles.reloadData()
                case .failure(let error):
                    self.memberFiles =  []
                    self.memberfilesVwHeight.constant = self.memberFiles.count > 0 ? 220 : 100
                    self.collectionFiles.reloadData()
                    print(error.message)
                }
                self.view.activityStopAnimating()
            }
        }
        
        
    }
    
    func SetupUi() -> Void {
        mapView.isHidden = true
        btnRefundTaken.isHidden = true
     //   self.btnPaymentInfo.isHidden = (self.object?.InsurancePlanId == 0)
        if Authentication.customerType == EnumUserType.Doctor  {
            self.updateInsuranceBtn.isHidden = true
        }
        else{
            self.updateInsuranceBtn.isHidden = (self.object?.InsurancePlanId == 0) || (self.object?.Status == "2") || (self.object?.Status == "3")  || (self.object?.Status == "4")
        }
//        if Authentication.customerType == EnumUserType.Doctor && self.object?.InsurancePlanId != 0{
//           self.btnPaymentInfo.isHidden = false
//
//
//        }
//        else{
//            self.btnPaymentInfo.isHidden = (self.object?.InsurancePlanId == 0) || (self.object?.Status == "2") || (self.object?.Status == "3")  || (self.object?.Status == "4")
//        }
        
        if Authentication.customerType == EnumUserType.Doctor {
            self.btnPaymentInfo.isHidden = self.object?.InsurancePlanId != 0 ? false : true
        }
        else if Authentication.customerType == EnumUserType.Customer{
            if self.object?.InsurancePlanId != 0 && self.object?.Status == EnumAppointmentStatus.Pending{
                self.btnPaymentInfo.isHidden = false
            }
            else{
                self.btnPaymentInfo.isHidden = true
            }
            
        }
        
        self.aptypeLabel.text = self.object?.MeetType == 1 ? AppointmentScreenTxt.InPerson.localize() : AppointmentScreenTxt.eAppointement.localize()
        self.usertypeLabel.text = Authentication.customerType == EnumUserType.Doctor ? AppointmentScreenTxt.membersName.localize():AppointmentScreenTxt.doctorsName.localize()
        self.nameLabel.text = Authentication.customerType == EnumUserType.Doctor ? self.object?.MemberName : self.object?.ProviderName
        self.dateLabel.text = "\(self.getFormattedDate(strDate: object?.AppointmentDateTime?.components(separatedBy: " ").first ?? "", currentFomat: "MM/dd/yyyy", expectedFromat: "dd-MMM-yyyy"))" + " ,( " + "\(self.object?.DoctorTimeZoneId ?? "")" + " )"
        self.timeLabel.text = self.object?.AppointmentTime
        self.ageLabel.text = "\(self.object?.Age ?? 0)"
        self.reasonLabel.text = self.object?.Reason ?? ""
        
        
        self.apnmtTypeLabel.text = object?.MeetType == 1 ? AppointmentScreenTxt.InPerson.localize() : AppointmentScreenTxt.eAppointement.localize()
        self.patientNameLabel.text = self.object?.OtherPatinetName ?? self.object?.MemberName
        self.relationLabel.text = /self.object?.OtherPatientRelation
        
        self.relationLabel.isHidden = /self.object?.OtherPatientRelation != "" ? false : true
        self.relationHeadLbl.isHidden = /self.object?.OtherPatientRelation != "" ? false : true
        
        btnConfirm.isHidden = Authentication.customerType != EnumUserType.Doctor || self.object?.Status == "3" || self.object?.Status == "4"
        btnUpload.isHidden = !(self.object?.Status == "2") || Authentication.customerType != EnumUserType.Customer
     //   memberFilesView.isHidden = !(self.object?.Status == "2") || Authentication.customerType != EnumUserType.Customer
        btnRateVw.isHidden = !(self.object?.Status == "3" && Authentication.customerType == EnumUserType.Customer)
        btnCancel.isHidden = self.object?.Status == "3" || self.object?.Status == "4"
        if Authentication.customerType == EnumUserType.Customer{
            if self.object?.Status == "4" {
                if self.object?.RefundTakenAction == 0{
                    btnRefundTaken.isHidden = true
                    if self.object?.IsRefundAllowed == true{
                        btnRefund.isHidden = false
                        if object?.IsDeleteAllowed == true{
                            btnDelete.isHidden = false}
                        else{
                            btnDelete.isHidden = true}}
                    else{
                        btnRefund.isHidden =  true
                        if object?.IsDeleteAllowed == true{
                            btnDelete.isHidden = false}
                        else{
                            btnDelete.isHidden = true
                            
                        } } }
                else{
                    btnRefundTaken.isHidden = false
                    if self.object?.IsRefundAllowed == true{
                        btnRefund.isHidden = false
                        if object?.IsDeleteAllowed == true{
                            btnDelete.isHidden = false }
                        else{
                            btnDelete.isHidden = true}}
                    else{
                        btnRefund.isHidden =  true
                        if object?.IsDeleteAllowed == true{
                            btnDelete.isHidden = false
                        }
                        else{
                            btnDelete.isHidden = true
                            bottomMenuView.isHidden = true
                        }}}}
            else{
                btnRefundTaken.isHidden = true
                btnRefund.isHidden = true
                btnDelete.isHidden = true } }
        else{
            btnRefundTaken.isHidden = true
            btnRefund.isHidden = true
            if object?.IsDeleteAllowed == true{
                if self.object?.Status == "4" {
                    btnDelete.isHidden = false
                }
                else{
                    btnDelete.isHidden = true
                    
                }
            }
            else{
                btnDelete.isHidden = true
                bottomMenuView.isHidden = true
                bottomVwHeight.constant = 0
                
            }}
        
        
        btnConfirm.isHidden = Authentication.customerType != EnumUserType.Doctor || !(self.object?.Status == "1")
        btnComplete.isHidden = Authentication.customerType != EnumUserType.Doctor || !(self.object?.Status == "2")
        if Authentication.customerType == EnumUserType.Doctor && (self.object?.IsNotAvailable == true){
            cancelLabel.isHidden = false
            btnPatientnotavailable.isHidden = false
        }
        if Authentication.customerType == EnumUserType.Doctor && (self.object?.IsNotAvailable == false){
            cancelLabel.isHidden = true
            btnPatientnotavailable.isHidden = true
        }
        if Authentication.customerType == EnumUserType.Customer && (self.object?.IsNotAvailable == true) {
            cancelLabel.isHidden = false
            btnDrnotavailable.isHidden = false
        }
        if Authentication.customerType == EnumUserType.Customer && (self.object?.IsNotAvailable == false) {
            cancelLabel.isHidden = true
            btnDrnotavailable.isHidden = true
        }
        
        bottomMenuView.isHidden = (Authentication.customerType == EnumUserType.Doctor && self.object?.Status == "3")
        bottomVwHeight.constant = (Authentication.customerType == EnumUserType.Doctor && self.object?.Status == "3") ? 0 : 80
        self.btnPhoneNumber.setTitle(self.object?.MemberPhone ?? "", for: .normal)
        
        if self.object?.Status == "1" && Authentication.customerType == EnumUserType.Doctor{
            self.phoneNumStack.isHidden = false
        }
        
        
        if self.object?.Status == "4"{
            self.addAttributesToTextForVC(label: statusLabel, boldTxt: AppointmentScreenTxt.status.localize(), regTxt: object?.AppointmentMessage ?? "", fontSize: 16, firstFontWeight: .semibold, secFontWeight: .regular)
        }
        
        self.selectedIndex = Int(self.object?.Status ?? "0")!
        
        self.setMapView()
        
        self.cmtLabel.isHidden = object?.Reviews == "" || Authentication.customerType != EnumUserType.Customer
        self.btnRateVw.isHidden = !(self.object?.Status == "3" && Authentication.customerType == EnumUserType.Customer)
        
       // print("object?.Reviews",object?.Reviews)
        
        if  Authentication.customerType == EnumUserType.Customer && object?.Reviews != ""{

      //  if object?.Reviews != nil && Authentication.customerType == EnumUserType.Customer{
            
            var test1Attributes:[NSAttributedString.Key: Any] = [.font : UIFont.systemFont(ofSize: 16, weight: .semibold)]
            test1Attributes[.foregroundColor] = #colorLiteral(red: 0, green: 0.7896722555, blue: 0.6383753419, alpha: 1)
            
            let test2Attributes:[NSAttributedString.Key: Any] = [.font : UIFont.systemFont(ofSize: 16, weight: .regular)]
            
            let test1 = NSAttributedString(string: AppointmentScreenTxt.yourReview.localize(), attributes:test1Attributes)
            
            let test2 = NSAttributedString(string: "\(/object?.Reviews)", attributes:test2Attributes)
            let text = NSMutableAttributedString()
            
            text.append(test1)
            text.append(test2)
            
            if object?.DoctorReply != nil && Authentication.customerType == EnumUserType.Customer{
                var reply1Attributes:[NSAttributedString.Key: Any] = [.font : UIFont.systemFont(ofSize: 16, weight: .semibold)]
                reply1Attributes[.foregroundColor] = #colorLiteral(red: 0, green: 0.8025439382, blue: 0.6487842202, alpha: 1)
                
                let reply2Attributes:[NSAttributedString.Key: Any] = [.font : UIFont.systemFont(ofSize: 16, weight: .regular)]
                
                let reply1 = NSAttributedString(string: "\n\(AppointmentScreenTxt.doctorReply.localize()) ", attributes:reply1Attributes)
                let reply2 = NSAttributedString(string: object?.DoctorReply ?? "", attributes:reply2Attributes)
                
                text.append(reply1)
                text.append(reply2)
            }
            self.cmtLabel.attributedText = text
            self.btnRateVw.isHidden = true
            bottomMenuView.isHidden = true
            bottomVwHeight.constant = 0
            
        }
        
    }
    
    func setMapView(){
        
        let annotation = MKPointAnnotation()
        
        if let lat = Double(self.object?.Latitude ?? "0.0") , let lng = Double(self.object?.Longitude ?? "0.0")
        {
            if lat == 0.0 && lng == 0.0 {
                self.mapView.removeAnnotations(self.mapView.annotations)
                self.mapView.annotations.forEach {
                    if !($0 is MKUserLocation) {
                        self.mapView.removeAnnotation($0)
                        btnMap.setImage(#imageLiteral(resourceName: "noroute"), for: .normal)
                        mapView.isHidden = false
                    }
                }
               
            }else{
                btnMap.setImage(nil, for: .normal)
                annotation.coordinate = CLLocationCoordinate2D(latitude: lat, longitude: lng )
                mapView.addAnnotation(annotation)
                let location: CLLocationCoordinate2D = CLLocationCoordinate2DMake(lat, lng)
                let region: MKCoordinateRegion = MKCoordinateRegion(center: location, span: MKCoordinateSpan(latitudeDelta: 0.5, longitudeDelta: 0.5))
                mapView.setRegion(region, animated: true)
                mapView.isHidden = false
            }
        }
    }
    
    func openMapForPlace() {
        if let lat = Double(self.object?.Latitude ?? "0.0") , let lng = Double(self.object?.Longitude ?? "0.0")
        {
            
            let regionDistance:CLLocationDistance = 10000
            let coordinates = CLLocationCoordinate2DMake(lat, lng)
            let regionSpan = MKCoordinateRegion(center: coordinates, latitudinalMeters: regionDistance, longitudinalMeters: regionDistance)
            let mapItem = MKMapItem(placemark: MKPlacemark(coordinate: coordinates, addressDictionary:nil))
            //            mapItem.name = "Target location"
            mapItem.openInMaps(launchOptions: [MKLaunchOptionsDirectionsModeKey : MKLaunchOptionsDirectionsModeDriving, MKLaunchOptionsMapCenterKey: NSValue(mkCoordinate: regionSpan.center),MKLaunchOptionsMapSpanKey: NSValue(mkCoordinateSpan: regionSpan.span)])
        }
    }
    func permissionDenied(text:String){
        DispatchQueue.main.async{
            var alertText = "\(AppointmentScreenTxt.permissDenied.first.localize()) \(text) \(AppointmentScreenTxt.permissDenied.sencond.localize()) \n\n1. \(AppointmentScreenTxt.permissDenied.Third.localize())\n\n2. \(AppointmentScreenTxt.permissDenied.fourth.localize())\n\n2. \(AppointmentScreenTxt.permissDenied.fifth.localize())"
            
            var alertButton = AlertBtnTxt.okay.localize()
            var goAction = UIAlertAction(title: alertButton, style: .default, handler: nil)
            
            if UIApplication.shared.canOpenURL(URL(string: UIApplication.openSettingsURLString)!){
                alertText = "\(AppointmentScreenTxt.permissDenied.first.localize()) \(text) \(AppointmentScreenTxt.permissDenied.sencond.localize()) \n\n1. \(AppointmentScreenTxt.permissDenied.Third.localize())\n\n2. \(AppointmentScreenTxt.permissDenied.fourth.localize())\n\n2. \(AppointmentScreenTxt.permissDenied.fifth.localize())"
                alertButton = AlertBtnTxt.Go.localize()
                
                goAction = UIAlertAction(title: alertButton, style: .default, handler: {(alert: UIAlertAction!) -> Void in
                    UIApplication.shared.open(URL(string: UIApplication.openSettingsURLString)!, options: [:], completionHandler: nil)
                })
            }
            
            let alert = UIAlertController(title: AppointmentScreenTxt.permissionError.localize(), message: alertText, preferredStyle: .alert)
            alert.addAction(goAction)
            self.present(alert, animated: true, completion: nil)
        }
    }
    @IBAction func didtapInfo(_ sender: Any) {
        self.permissionDenied(text: AppointmentScreenTxt.photos.localize())
    }
    
    
    @IBAction func didtapUpdateInsuranceCard(_ sender: Any) {
        let popOverVC = self.storyboard?.instantiateViewController(withIdentifier: "UpdateInsurancecardVC") as! UpdateInsurancecardVC
        popOverVC.objectApmnt = self.object
        popOverVC.modalPresentationStyle = UIModalPresentationStyle.overFullScreen
        self.present(popOverVC, animated: true)
    }
    
    @IBAction func didtapCallMember(_ sender: UIButton) {
        guard let number = URL(string: "tel://" + ("\(self.object?.MemberPhone ?? "")")) else { return }
        UIApplication.shared.open(number, options: [:], completionHandler: nil)
    }
    
    @IBAction func didtapPaymentInfo(_ sender: Any) {
        if self.object?.InsurancePlanId != 0{
           // self.presentAlertWithImageForInfo()
            let popOverVC = self.storyboard?.instantiateViewController(withIdentifier: "InsurenceCardInfoVC") as! InsurenceCardInfoVC
            popOverVC.objectApt = self.object
            popOverVC.modalPresentationStyle = UIModalPresentationStyle.overFullScreen
            popOverVC.callback = { (data) -> Void in
                print("callback")
                print(self.object?.InsuranceCardPic)
               
                NavigationHandler.pushTo(.fullImage(URL(string: "\(APIConstants.mainUrl)" + "\(self.object?.InsuranceCardPic ?? "")")!, AppointmentScreenTxt.insurencecardImage.localize()))
            }
            self.present(popOverVC, animated: true)
        }
        /*       else{
         let message = Authentication.customerType == EnumUserType.Customer ? "This Appointment is charged as per \(self.object?.ProviderName ?? "")'s Appointment fee mentioned in the profile" : "This Appointment is charged as per Appointment fee mentioned by you in your profile"
         AlertManager.showAlert(type: .custom(message))
         } */
    }
    
    @IBAction func didtapViewAll(_ sender: Any) {
        NavigationHandler.pushTo(.uploadedfiles(self.object!))
    }
    
    @IBAction func didtapBack(_ sender: Any) {
        NotificationCenter.default.post(name: Notification.Name("appointment"), object: 3)
        NavigationHandler.pop()
    }
    
    @IBAction func didtapConfirm(_ sender: Any) {
        
        if self.object?.InsurancePlanId == 0{
            if self.object?.PaymentType == 4{
                AlertManager.showAlert(type: .custom(AppointmentScreenTxt.acceptpaylaterAPT.localize()), actionTitle: AlertBtnTxt.yes.localize()) {
                    self.managependingappointment(self.object?.Id ?? 0)
                }
            }else{
                AlertManager.showAlert(type: .custom(AppointmentScreenTxt.ConfirmApointement.localize()), actionTitle: AlertBtnTxt.yes.localize()) {
                    self.managependingappointment(self.object?.Id ?? 0)
                }
            }
            
        }else{
           // self.presentAlertWithImage()
            let popOverVC = self.storyboard?.instantiateViewController(withIdentifier: "ConfirmInsurenceDocInfoVC") as! ConfirmInsurenceDocInfoVC
            popOverVC.objectApt = self.object
            popOverVC.modalPresentationStyle = UIModalPresentationStyle.overFullScreen
            popOverVC.callback = { () -> Void in
                print("callback")
                self.managependingappointment(self.object?.Id ?? 0)
            }
            self.present(popOverVC, animated: true)
        }
    }
    
    @IBAction func didtapComplete(_ sender: Any) {
        
        /*  if self.prescribed == false {
         let fulldayAlert = UIAlertController(title: "Do you want to add Prescription?", message: nil, preferredStyle: UIAlertController.Style.alert)
         
         fulldayAlert.addAction(UIAlertAction(title: "YES", style: .default, handler: { (action: UIAlertAction!) in
         NavigationHandler.pushTo(.prescribeVC(self.object!))
         }))
         
         fulldayAlert.addAction(UIAlertAction(title: "SKIP", style: .cancel, handler: { (action: UIAlertAction!) in
         AlertManager.showAlert(type: .custom("Are you sure to complete this appointment?"), actionTitle: AlertBtnTxt.okay.localize()) {
         NavigationHandler.pushTo(.enterOtpVC(self.object!))
         }
         }))
         
         present(fulldayAlert, animated: true, completion: nil)
         }else
         {*/
        
        AlertManager.showAlert(type: .custom(AppointmentScreenTxt.areYouSureCompleteApointment.localize()), actionTitle: AlertBtnTxt.okay.localize()) {
            NavigationHandler.pushTo(.enterOtpVC(self.object!))
        }
        // }
    }
    
    
    /*   @IBAction func didtapPrescribe(_ sender: Any) {
     if self.prescribed == false {
     let fulldayAlert = UIAlertController(title: "Do you want to add Prescription?", message: nil, preferredStyle: UIAlertController.Style.alert)
     
     fulldayAlert.addAction(UIAlertAction(title: AlertBtnTxt.okay.localize(), style: .default, handler: { (action: UIAlertAction!) in
     NavigationHandler.pushTo(.prescribeVC(self.object!))
     }))
     
     fulldayAlert.addAction(UIAlertAction(title: AlertBtnTxt.cancel.localize(), style: .cancel, handler: { (action: UIAlertAction!) in
     }))
     
     present(fulldayAlert, animated: true, completion: nil)
     }else{
     
     let fulldayAlert = UIAlertController(title: "Do you want to update Prescription?", message: nil, preferredStyle: UIAlertController.Style.alert)
     
     fulldayAlert.addAction(UIAlertAction(title: AlertBtnTxt.okay.localize(), style: .default, handler: { (action: UIAlertAction!) in
     NavigationHandler.pushTo(.prescribeVC(self.object!))
     }))
     
     fulldayAlert.addAction(UIAlertAction(title: AlertBtnTxt.cancel.localize(), style: .cancel, handler: { (action: UIAlertAction!) in
     }))
     
     present(fulldayAlert, animated: true, completion: nil)
     }
     //   NavigationHandler.pushTo(.prescribeVC(self.object!))
     }*/
    @IBAction func didtapCancel(_ sender: Any) {
        AlertManager.showAlert(type: .custom(AppointmentScreenTxt.areYouSureCancelApointment.localize()), actionTitle: AlertBtnTxt.okay.localize()) {
            Authentication.customerType == EnumUserType.Doctor ? self.cancelDoctorAppointment(self.object?.Id ?? 0) : self.cancelMemberAppointment(self.object?.Id ?? 0)
        }
    }
    
    @IBAction func didtapDelete(_ sender: Any) {
        AlertManager.showAlert(type: .custom(AppointmentScreenTxt.areYouSureDeleApointment.localize()), actionTitle: AlertBtnTxt.okay.localize()) {
            Authentication.customerType == EnumUserType.Doctor ? self.deleteDoctorAppointment(self.object?.Id ?? 0) : self.deleteMemberAppointment(self.object?.Id ?? 0)
        }
    }
    
    @IBAction func didtapUpload(_ sender: Any) {
        NavigationHandler.pushTo(.uploadfile(self.object!))
    }
    
    @IBAction func didtapReschedule(_ sender: Any) {
        AlertManager.showAlert(type: .custom(AppointmentScreenTxt.comingSoon.localize()))
    }
    
    @IBAction func didtapRatethis(_ sender: Any) {
        NavigationHandler.pushTo(.rating(self.object!))
    }
    
    @IBAction func didtapViewPrescription(_ sender: Any) {
        self.getDoctorPrescription()
    }
    
    @IBAction func didtapDrNotAvailable(_ sender: Any) {
        
        AlertManager.showAlert(type: .custom(AppointmentScreenTxt.areYoudoctorNtAvilable.localize()), actionTitle: AlertBtnTxt.okay.localize()) {
            self.doctorNotAvailable(self.object?.Id ?? 0)
        }
        //        if self.prescribed == false {
        //            AlertManager.showAlert(type: .custom("Are you sure doctor is not available?"), actionTitle: AlertBtnTxt.okay.localize()) {
        //                self.doctorNotAvailable(self.object?.Id ?? 0)
        //            }
        //        }else{
        //        let fulldayAlert = UIAlertController(title: "Doctor had concluded appointment by adding prescription, do you still want to mark the patient not available?", message: nil, preferredStyle: UIAlertController.Style.alert)
        //
        //        fulldayAlert.addAction(UIAlertAction(title: "YES", style: .default, handler: { (action: UIAlertAction!) in
        //            self.doctorNotAvailable(self.object?.Id ?? 0)
        //        }))
        //
        //        fulldayAlert.addAction(UIAlertAction(title: "NO", style: .cancel, handler: { (action: UIAlertAction!) in
        //          //  fulldayAlert.dismiss(animated: true, completion: nil)
        //        }))
        //
        //        present(fulldayAlert, animated: true, completion: nil)
        //        }
        
    }
    
    @IBAction func didtapPatientNotAvailable(_ sender: Any) {
        if self.prescribed == false {
            AlertManager.showAlert(type: .custom(AppointmentScreenTxt.areYoupatientNtAvilable.localize() ), actionTitle: AlertBtnTxt.okay.localize()) {
                self.patientNotAvailable(self.object?.Id ?? 0)
            }
        }else{
            let fulldayAlert = UIAlertController(title: AppointmentScreenTxt.markPatientNtavilable.localize(), message: nil, preferredStyle: UIAlertController.Style.alert)
            
            fulldayAlert.addAction(UIAlertAction(title: AlertBtnTxt.yes.localize(), style: .default, handler: { (action: UIAlertAction!) in
                self.patientNotAvailable(self.object?.Id ?? 0)
            }))
            
            fulldayAlert.addAction(UIAlertAction(title: AlertBtnTxt.No.localize(), style: .cancel, handler: { (action: UIAlertAction!) in
                //  fulldayAlert.dismiss(animated: true, completion: nil)
            }))
            
            present(fulldayAlert, animated: true, completion: nil)
        }
        
    }
    
    @IBAction func didtapRefund(_ sender: Any) {
        allowedRefundOption(self.object?.Id ?? 0)
      //  alertForCredits()
    }
    
    @IBAction func didtapMap(_ sender: Any) {
        if btnMap.hasImage(named: "noroute.jpg", for: .normal) {
            AlertManager.showAlert(type: .custom(AppointmentScreenTxt.locationNtAvilable.localize()))
        }else{
            self.openMapForPlace()
        }
    }
    func allowedRefundOption(_ appId: Int){
        let queryItems = ["AppointmentId": appId] as [String: Any]
        
        WebService.allowedRefundOption(queryItems: queryItems) { (result) in
            DispatchQueue.main.async { [self] in
                activityIndicator.hideLoader()
                switch result {
                case .success( _):
                   
                   alertForCredits()
                 
                  
                case .failure(let error):
                    print(error.message)
                    AlertManager.showAlert(type: .custom(error.message))
                //  AlertManager.showAlert(type: .custom(error.message))
                }
                
            }
        }
    }
    
    func refundalert(){
        let alert = UIAlertController(title: AppointmentScreenTxt.initiateRefund.localize(), message: AppointmentScreenTxt.selectOptionForRefund.localize(), preferredStyle: UIAlertController.Style.alert)
        
        if refundOptions?.MoneyRefund  == true{
            alert.addAction(UIAlertAction(title: AppointmentScreenTxt.refund.localize(), style: UIAlertAction.Style.default, handler: { action in
                self.initiateRefund("\(self.object?.Id ?? 0)", optionId: "1")
            }))
        }
        if refundOptions?.CreditRefund  == true{
            alert.addAction(UIAlertAction(title: AppointmentScreenTxt.vigortoCredits.localize(), style: UIAlertAction.Style.default, handler: { action in
                self.initiateRefund("\(self.object?.Id ?? 0)", optionId: "2")
            }))
        }
        alert.addAction(UIAlertAction(title: AlertBtnTxt.cancel.localize(), style: UIAlertAction.Style.destructive, handler: nil))
        
        // show the alert
        
    }
    func initiateRefund(_ appId: String ,optionId:String){
        let queryItems = ["AppointmentId": appId ,"SelectedOptionId":optionId] as [String: Any]
        //self.view.activityStartAnimating(activityColor: .themeGreen, backgroundColor: UIColor.white)
        WebService.initiateRefund(queryItems: queryItems) { (result) in
            DispatchQueue.main.async {
                switch result {
                case .success(let response):
                    NotificationCenter.default.post(name: Notification.Name("appointment"), object: self.selectedIndex)
                    AlertManager.showAlert(type: .custom(response.message ?? "")) {
                        self.viewWillAppear(true)
                    }
                case .failure(let error):
                    NotificationCenter.default.post(name: Notification.Name("appointment"), object: self.selectedIndex)
                    AlertManager.showAlert(type: .custom(error.message)) {
                        self.viewWillAppear(true)
                    }
                }
                //   self.view.activityStopAnimating()
            }
        }
    }
    
    func isCheckFreeAppointments(_ appId: Int){
        let queryItems = ["AppointmentId": appId] as [String: Any]
        self.view.activityStartAnimating(activityColor: .themeGreen, backgroundColor: UIColor.white)
        WebService.isCheckFreeAppointments(queryItems: queryItems) { (result) in
            DispatchQueue.main.async {
                activityIndicator.hideLoader()
                switch result {
                case .success(let response):
                    AlertManager.showAlert(type: .custom(response.message ?? ""), actionTitle: AlertBtnTxt.okay.localize()) {
                        if self.subscriptionStatus == "0"{
                            NavigationHandler.pushTo(.subscriptionVC)
                        }else if self.subscriptionStatus == "1"{
                            NavigationHandler.pushTo(.subscriptionPaymentVC)
                        }
                    }
                case .failure(let error):
                    if self.subscriptionStatus == "2"{
                        self.managependingappointment(self.object?.Id ?? 0)
                    }else{
                        AlertManager.showAlert(type: .custom(error.message), actionTitle: AlertBtnTxt.okay.localize()) {
                            self.managependingappointment(self.object?.Id ?? 0)
                        }
                    }
                }
                self.view.activityStopAnimating()
            }
        }
    }
    
    func getSubscriptionStatus() -> Void {
        let queryItems = ["CustomerGuid": "\(Authentication.customerGuid!)"]
        WebService.paidDoctorPlans(queryItems: queryItems) { (result) in
            DispatchQueue.main.async {
                switch result {
                case .success(let response):
                    if response.object?.SubscriptionStatus == true {
                        if response.object?.PaymentStatus == true{
                            self.subscriptionStatus = "2"
                        }else {
                            self.subscriptionStatus = "1"
                        }
                    }else{
                        self.subscriptionStatus = "0"
                    }
                case .failure:
                    self.subscriptionStatus = "0"
                }
            }
        }
    }
    
    
    func patientNotAvailable(_ appId: Int){
        let queryItems = ["AppointmentId": appId] as [String: Any]
        self.view.activityStartAnimating(activityColor: .themeGreen, backgroundColor: UIColor.white)
        WebService.patientNotAvailable(queryItems: queryItems) { (result) in
            DispatchQueue.main.async {
                switch result {
                case .success:
                    NotificationCenter.default.post(name: Notification.Name("appointment"), object: self.selectedIndex)
                    AlertManager.showAlert(type: .custom(AppointmentScreenTxt.APTCancelSucesfully.localize())) {
                        NavigationHandler.pop()
                    }
                case .failure(let error):
                    AlertManager.showAlert(type: .custom(error.message))
                }
                self.view.activityStopAnimating()
            }
        }
    }
    
    func doctorNotAvailable(_ appId: Int){
        let queryItems = ["AppointmentId": appId] as [String: Any]
        self.view.activityStartAnimating(activityColor: .themeGreen, backgroundColor: UIColor.white)
        WebService.doctorNotAvailable(queryItems: queryItems) { (result) in
            DispatchQueue.main.async {
                switch result {
                case .success:
                    NotificationCenter.default.post(name: Notification.Name("appointment"), object: self.selectedIndex)
                    AlertManager.showAlert(type: .custom(AppointmentScreenTxt.APTCancelSucesfully.localize())) {
                        NavigationHandler.pop()
                    }
                case .failure(let error):
                    AlertManager.showAlert(type: .custom(error.message))
                }
                self.view.activityStopAnimating()
            }
        }
    }
    
    func managependingappointment(_ appId: Int){
        let queryItems = ["id": appId] as [String: Any]
        self.view.activityStartAnimating(activityColor: .themeGreen, backgroundColor: UIColor.white)
        WebService.managePendingDoctorAppointments(queryItems: queryItems) { (result) in
            DispatchQueue.main.async {
                switch result {
                case .success:
                    NotificationCenter.default.post(name: Notification.Name("appointment"), object: self.selectedIndex)
                    AlertManager.showAlert(type: .custom(AppointmentScreenTxt.movedSucessfullyConfirm.localize())) {
                        NavigationHandler.pop()
                    }
                case .failure(let error):
                    AlertManager.showAlert(type: .custom(error.message))
                }
                self.view.activityStopAnimating()
            }
        }
    }
    
    func manageConfirmAppointment(_ appId: String){
        let queryItems = ["id": appId] as [String: Any]
        self.view.activityStartAnimating(activityColor: .themeGreen, backgroundColor: UIColor.white)
        WebService.manageConfirmedAppointments(queryItems: queryItems) { (result) in
            DispatchQueue.main.async {
                switch result {
                case .success:
                    NotificationCenter.default.post(name: Notification.Name("appointment"), object: self.selectedIndex)
                    AlertManager.showAlert(type: .custom(AppointmentScreenTxt.movedSucessFullyComplete.localize())) {
                        NavigationHandler.pop()
                    }
                case .failure(let error):
                    AlertManager.showAlert(type: .custom(error.message))
                }
                self.view.activityStopAnimating()
            }
        }
    }
    
    func cancelMemberAppointment(_ appId: Int){
        let queryItems = ["id": appId] as [String: Any]
        self.view.activityStartAnimating(activityColor: .themeGreen, backgroundColor: UIColor.white)
        WebService.cancelMemberAppointment(queryItems: queryItems) { (result) in
            DispatchQueue.main.async {
                switch result {
                case .success:
                    NotificationCenter.default.post(name: Notification.Name("appointment"), object: self.selectedIndex)
                    AlertManager.showAlert(type: .custom(AppointmentScreenTxt.movedSucessFullyHistory.localize())) {
                        NavigationHandler.pop()
                    }
                case .failure(let error):
                    AlertManager.showAlert(type: .custom(error.message))
                }
                self.view.activityStopAnimating()
            }
        }
    }
    func cancelDoctorAppointment(_ appId: Int){
        let queryItems = ["id": appId] as [String: Any]
        self.view.activityStartAnimating(activityColor: .themeGreen, backgroundColor: UIColor.white)
        WebService.canceldoctorappointment(queryItems: queryItems) { (result) in
            DispatchQueue.main.async {
                switch result {
                case .success:
                    NotificationCenter.default.post(name: Notification.Name("appointment"), object: self.selectedIndex)
                    AlertManager.showAlert(type: .custom(AppointmentScreenTxt.movedSucessFullyHistory.localize())) {
                        NavigationHandler.pop()
                    }
                case .failure(let error):
                    AlertManager.showAlert(type: .custom(error.message))
                }
                self.view.activityStopAnimating()
            }
        }
    }
    func deleteDoctorAppointment(_ appId: Int){
        let queryItems = ["id": appId] as [String: Any]
        self.view.activityStartAnimating(activityColor: .themeGreen, backgroundColor: UIColor.white)
        WebService.deleteDoctorAppointment(queryItems: queryItems) { (result) in
            DispatchQueue.main.async {
                switch result {
                case .success:
                    NotificationCenter.default.post(name: Notification.Name("appointment"), object: self.selectedIndex)
                    AlertManager.showAlert(type: .custom(AppointmentScreenTxt.APTSucessDelete.localize())) {
                        NavigationHandler.pop()
                    }
                case .failure(let error):
                    AlertManager.showAlert(type: .custom(error.message))
                }
                self.view.activityStopAnimating()
            }
        }
    }
    func deleteMemberAppointment(_ appId: Int){
        let queryItems = ["id": appId] as [String: Any]
        self.view.activityStartAnimating(activityColor: .themeGreen, backgroundColor: UIColor.white)
        WebService.deleteMemberAppointment(queryItems: queryItems) { (result) in
            DispatchQueue.main.async {
                switch result {
                case .success:
                    NotificationCenter.default.post(name: Notification.Name("appointment"), object: self.selectedIndex)
                    AlertManager.showAlert(type: .custom(AppointmentScreenTxt.APTSucessDelete.localize())) {
                        NavigationHandler.pop()
                    }
                case .failure(let error):
                    AlertManager.showAlert(type: .custom(error.message))
                }
                self.view.activityStopAnimating()
            }
        }
    }
    
    func getDoctorPrescription() -> Void {
        self.view.activityStartAnimating(activityColor: .themeGreen, backgroundColor: UIColor.white)
        let queryItems = ["AppointmentId": "\(object?.Id ?? 0)"]
        WebService.getDoctorPrescription(queryItems: queryItems) { (result) in
            DispatchQueue.main.async {
                switch result {
                case .success (let response):
                    if let prescription = response.object{
                        self.prescriptionData = prescription
                        self.drPrescription = self.prescriptionData?.PrescriptionBody ?? ""
                        if self.drPrescription == ""{
                            AlertManager.showAlert(type: .custom(AppointmentScreenTxt.prescriptionNotFound.localize()))
                        }else{
                            NavigationHandler.pushTo(.drPrescription(self.drPrescription,self.object!))
                        }
                    }
                case .failure(let error):
                    self.drPrescription = ""
                    AlertManager.showAlert(type: .custom("\(AppointmentScreenTxt.prescriptionNotFound.localize()) \(error.message)"))
                }
                self.view.activityStopAnimating()
            }
        }
    }
    
    func getDoctorPrescriptionforCheck() -> Void {
        let queryItems = ["AppointmentId": "\(object?.Id ?? 0)"]
        WebService.getDoctorPrescription(queryItems: queryItems) { (result) in
            DispatchQueue.main.async {
                switch result {
                case .success :
                    self.prescribed = true
                case .failure:
                    self.prescribed = false
                }
            }
        }
    }
    
}


extension AppointmentDetailsVC: UICollectionViewDataSource,UICollectionViewDelegate , UICollectionViewDelegateFlowLayout
{
    //this method is for the size of items
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let width = collectionView.frame.width/2
        let height : CGFloat = 190.0
        return CGSize(width: width-20, height: height)
    }//these methods are to configure the spacing between items
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: 0,left: 0,bottom: 0,right: 0)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 5
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 5
    }
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if  Authentication.customerType == EnumUserType.Customer && object?.Status == EnumAppointmentStatus.History || object?.Status == EnumAppointmentStatus.Completed || object?.Status == EnumAppointmentStatus.Pending {
        memberFilesLabel.isHidden = true
        memberFilesView.isHidden = true
            memberfilesVwHeight.constant = 0
        }
        if (self.memberFiles.count == 0) {
            
            if object?.Status != EnumAppointmentStatus.History || object?.Status != EnumAppointmentStatus.Completed{
                self.collectionFiles.setEmptyMessage("\(Authentication.customerType == EnumUserType.Doctor ? "\(AppointmentScreenTxt.noFilesUploadedBy.localize()) \(self.object?.MemberName ?? "")": AppointmentScreenTxt.pleaseUploadFiles.localize())")
               
            }
        btnViewAll.isHidden = true
        
          
        } else {
          
            self.collectionFiles.restore()
            btnViewAll.isHidden = false
           
        }
        return self.memberFiles.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let memberFiles = self.memberFiles[indexPath.item]
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "MemberFilesCell", for: indexPath) as! MemberFilesCell
        cell.img.sd_setImage(with: URL(string: "\(APIConstants.mainUrl)Content/PrescriptionFiles/" + "\(memberFiles.UniqueFileName ?? "")")! , placeholderImage: nil) //UIImage.init(named: "doctor-avtar")

        cell.deleteBtn.tag = indexPath.row
        cell.deleteBtn.addTarget(self, action:  #selector(deleteBtnPressed(sender:)), for: .touchUpInside)
        cell.viewfullBtn.tag = indexPath.row
        cell.viewfullBtn.addTarget(self, action:  #selector(viewfullBtnPressed(sender:)), for: .touchUpInside)
        
        cell.deleteBtn.isHidden = (Authentication.customerType == EnumUserType.Doctor)
        
        return cell
        
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
    }
    
    @objc func deleteBtnPressed(sender: UIButton) {
        AlertManager.showAlert(type: .custom(AppointmentScreenTxt.areYouSureDeleteFile.localize()), actionTitle: AlertBtnTxt.okay.localize()) {
            let memberFiles = self.memberFiles[sender.tag]
            self.deleteMemberFilebyId(fileId: memberFiles.Id ?? 0)
        }
    }
    func deleteMemberFilebyId(fileId:Int) -> Void {
        
        let queryItems = ["FileId": fileId]
        self.view.activityStartAnimating(activityColor: .themeGreen, backgroundColor: UIColor.white)
        WebService.deleteMemberFilebyId(queryItems: queryItems) { (result) in
            DispatchQueue.main.async {
                switch result {
                case .success :
                    self.getMemberFiles()
                case .failure(let error):
                    AlertManager.showAlert(on: self, type: .custom(error.message))
                }
                self.view.activityStopAnimating()
            }
        }
    }
    @objc func viewfullBtnPressed(sender: UIButton) {
        let memberFiles = self.memberFiles[sender.tag]
        print(memberFiles.Id ?? 0)
        NavigationHandler.pushTo(.fullImage(URL(string: "\(APIConstants.mainUrl)Content/PrescriptionFiles/" + "\(memberFiles.UniqueFileName ?? "")")!, AppointmentScreenTxt.memberfile.localize()))

    }
    func alertForCredits() -> Void {
        let message = AppointmentScreenTxt.selectOptionForRefund.localize()
        let showAlert = UIAlertController(title: AppointmentScreenTxt.initiateRefund.localize() , message:message, preferredStyle: .alert)
        showAlert.addAction(UIAlertAction(title: AppointmentScreenTxt.refund.localize(), style: .default, handler: { action in
            self.initiateRefund("\(self.object?.Id ?? 0)", optionId: "1")
        }))
        showAlert.addAction(UIAlertAction(title: AppointmentScreenTxt.vigortoCredits.localize(), style: .default, handler: { action in
            self.initiateRefund("\(self.object?.Id ?? 0)", optionId: "2")
        }))
        
        showAlert.addAction(UIAlertAction(title: AlertBtnTxt.cancel.localize(), style: UIAlertAction.Style.destructive, handler: nil))
        self.present(showAlert, animated: true, completion: nil)
        
    }
    
    func presentAlertWithImageForInfo() -> Void {
        //   let message = Authentication.customerType == EnumUserType.Customer ? "This Appointment is booked with  your's " + "\((self.object?.InsurancePlanName ?? "").uppercased()) insurance plan" : "This Appointment is booked with \((self.object?.MemberName ?? "").uppercased())'s " + "\((self.object?.InsurancePlanName ?? "").uppercased()) insurance plan"
        
        let message = Authentication.customerType == EnumUserType.Customer ? AppointmentScreenTxt.memberInsurence.localize() + "\((self.object?.InsurancePlanName ?? "").uppercased())" : AppointmentScreenTxt.memberInsurence.localize() + "\((self.object?.InsurancePlanName ?? "").uppercased())"
        
        
        let showAlert = UIAlertController(title: message , message: nil, preferredStyle: .alert)
        
        //ImageView
        let imageView = UIImageView(frame: CGRect(x: 15, y: 200, width: 240, height: 190))
        imageView.sd_setImage(with: URL(string: "\(APIConstants.mainUrl)" + "\(self.object?.InsuranceCardPic ?? "")")!, placeholderImage: UIImage.gif(name: "insurance_loader"))
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        imageView.layer.cornerRadius = 12

        showAlert.view.addSubview(imageView)
        
        print(showAlert.view.size)
        
        let height = NSLayoutConstraint(item: showAlert.view, attribute: .height, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1, constant: 450)
        let width = NSLayoutConstraint(item: showAlert.view, attribute: .width, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1, constant: 250)
        showAlert.view.addConstraint(height)
        showAlert.view.addConstraint(width)
        showAlert.addAction(UIAlertAction(title: AppointmentScreenTxt.dismiss.localize(), style: .destructive, handler: { action in
        }))
        showAlert.addAction(UIAlertAction(title: AppointmentScreenTxt.viewFull.localize(), style: .default, handler: { action in
            NavigationHandler.pushTo(.fullImage(URL(string: "\(APIConstants.mainUrl)" + "\(self.object?.InsuranceCardPic ?? "")")!, AppointmentScreenTxt.insurencecardImage.localize()))

        }))
        self.present(showAlert, animated: true, completion: nil)
        
    }
    
    func presentAlertWithImage() -> Void {
        
        let showAlert = UIAlertController(title: AppointmentScreenTxt.InsurencePlanName.localize() + "\(self.object?.InsurancePlanName ?? "")", message: nil, preferredStyle: .alert)
        
        //ImageView
        let imageView = UIImageView(frame: CGRect(x: 5, y: 180, width: 240, height: 190))
        print(URL(string: "\(APIConstants.mainUrl)" + "\(self.object?.InsuranceCardPic ?? "")")!)
        imageView.sd_setImage(with: URL(string: "\(APIConstants.mainUrl)" + "\(self.object?.InsuranceCardPic ?? "")")!, placeholderImage: UIImage.gif(name: "insurance_loader"))

        showAlert.view.addSubview(imageView)
        
        //Text Label
        let textLabel = UILabel()
        textLabel.frame = CGRect(x: 5, y: 365, width: 260, height: 55)
        textLabel.text  = AppointmentScreenTxt.confirmAppointementWithInsurence.localize()
        // textLabel.textColor = .themeGreen
        textLabel.numberOfLines = 0
        textLabel.lineBreakMode = .byWordWrapping
        textLabel.textAlignment = .center
        textLabel.font = .systemFont(ofSize: 16)
        showAlert.view.addSubview(textLabel)
        
        let height = NSLayoutConstraint(item: showAlert.view, attribute: .height, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1, constant: 460)
        let width = NSLayoutConstraint(item: showAlert.view, attribute: .width, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1, constant: 250)
        showAlert.view.addConstraint(height)
        showAlert.view.addConstraint(width)
        showAlert.addAction(UIAlertAction(title: AlertBtnTxt.No.localize(), style: .default, handler: { action in
            // your actions here...
        }))
        showAlert.addAction(UIAlertAction(title: AlertBtnTxt.yes.localize(), style: .default, handler: { action in
            self.managependingappointment(self.object?.Id ?? 0)
        }))
        
        self.present(showAlert, animated: true, completion: nil)
        
    }
}

