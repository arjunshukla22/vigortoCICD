//
//  PendingTableCell.swift
//  SmileIndia
//
//  Created by Na on 09/07/19.
//  Copyright © 2019 Na. All rights reserved.
//

import UIKit
enum Action {
    case pending
    case confirm
    case rating
    case none
}
class PendingTableCell: UITableViewCell, ReusableCell {
    
    @IBOutlet weak var appointmentTypeLabel: UILabel!
    @IBOutlet weak var viewHeight: NSLayoutConstraint!
    
    @IBOutlet weak var emailLabel: UILabel!
    @IBOutlet weak var cmtLabel: UILabel!
    @IBOutlet weak var userLabel: UILabel!
    @IBOutlet weak var phoneButton: UIButton!
    @IBOutlet weak var reasonLabel: UILabel!
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var timeLabel: UILabel!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var ageLabel: UILabel!
    @IBOutlet weak var statusLabel: UILabel!
    @IBOutlet weak var bookingDateLabel: UILabel!
    
    
    @IBOutlet weak var confirmButton: UIButton!
    @IBOutlet weak var cancelButton: UIButton!
    @IBOutlet weak var rateButton: UIButton!
    
    @IBOutlet weak var btnRefund: UIButton!
    @IBOutlet weak var btnNotAvailable: UIButton!
    var selectedIndex = 0
    var  refundOptions: RefundOptions?
    typealias Handler = (Action)->()
    var handler: Handler?
    var index = 1
    var appid = ""
    var  prescriptionData: DrPrescription?
    var drPrescription = ""
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.selectionStyle = .none
        // Initialization code
        
        userLabel.text = Authentication.customerType == EnumUserType.Doctor ? AppointmentScreenTxt.membersName.localize() : AppointmentScreenTxt.doctorsName.localize()
        cmtLabel.isHidden = Authentication.customerType == EnumUserType.Doctor
        //   btnRefund.isHidden == true
        cancelButton.isHidden = true
        btnNotAvailable.isHidden = true
        
    }
    
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        // Configure the view for the selected state
    }
    var object: Appointment? {
        didSet {
            
            appointmentTypeLabel.text = object?.MeetType == 1 ? AppointmentScreenTxt.InPerson.localize() : AppointmentScreenTxt.eAppointement.localize()
            self.attributingWithColor(label: timeLabel, boldTxt: AppointmentScreenTxt.AppointementTime.localize(), regTxt: object?.AppointmentTime ?? "", color: .themeGreen)
            
            self.attributingWithColor(label: dateLabel, boldTxt: AppointmentScreenTxt.AppointementDate.localize(), regTxt: self.getFormattedDateForCell(strDate: object?.AppointmentDateTime?.components(separatedBy: " ").first ?? "", currentFomat: "MM/dd/yyyy", expectedFromat: "dd-MMM-yyyy"), color: .themeGreen)
            ageLabel.text = "\(object?.Age ?? 0)"
            //            if let str = object?.AppointmentDateTime{
            //                if str.components(separatedBy: " ").count > 0{
            //                    self.attributingWithColor(label: dateLabel, boldTxt: "Appointment Date :", regTxt: self.getFormattedDateForCell(strDate: object?.AppointmentDateTime?.components(separatedBy: " ").first ?? "", currentFomat: "MM/dd/yyyy", expectedFromat: "dd-MMM-yyyy"), color: .themeGreen)
            //                }
            //            }
            if Authentication.customerType == EnumUserType.Doctor{
                bookingDateLabel.isHidden = true
            }
            else{
                
                let dateStr = self.getFormattedDateForCell(strDate: object?.CreateDateForApi?.components(separatedBy: " ").first ?? "", currentFomat: "MM/dd/yyyy", expectedFromat: "dd-MMM-yyyy")
               
                self.attributingWithColor(label: bookingDateLabel, boldTxt: AppointmentScreenTxt.BookingDate.localize(), regTxt: Authentication.appLanguage == EnumAppLanguage.English ? dateStr : "\n\(dateStr)", color: .themeGreen)
            }
            //            if let str = object?.CreateDateForApi{
            //                if str.components(separatedBy: " ").count > 0{
            //                    self.attributingWithColor(label: bookingDateLabel, boldTxt: "Booking Date :", regTxt: self.getFormattedDateForCell(strDate: str.components(separatedBy: " ").first ?? "", currentFomat: "MM/dd/yyyy", expectedFromat: "dd-MMM-yyyy"), color: .themeGreen)
            //                }
            //            }
            //    self.attributingWithColor(label: bookingDateLabel, boldTxt: "Booking Date :", regTxt: self.getFormattedDateForCell(strDate: /object?.CreateDateForApi?.components(separatedBy: " ").first ?? "", currentFomat: "MM/dd/yyyy", expectedFromat: "dd-MMM-yyyy"), color: .themeGreen)
            //   ageLabel.text = "\(object?.Age ?? 0)"
            // self.bookingDateLabel.text = \(object?.CreateDateForApi?)
            nameLabel.text = Authentication.customerType == EnumUserType.Doctor ? object?.MemberName ?? "" : object?.ProviderName ?? ""
            self.attributingWithColor(label: reasonLabel, boldTxt: AppointmentScreenTxt.reason.localize(), regTxt: object?.Reason ?? "", color: .themeGreen)
            
            statusLabel.isHidden = !(index == 4)
            
            if Authentication.customerType == EnumUserType.Doctor {
                btnRefund.isHidden = true
                self.addAttributesToText(label: emailLabel, boldTxt: AppointmentScreenTxt.emailAt.localize(), regTxt: object?.MemberEmail ?? "")
            }else {
                self.addAttributesToText(label: emailLabel, boldTxt: AppointmentScreenTxt.emailAt.localize(), regTxt: object?.ProviderEmail ?? "")
                
            }
            
            if Authentication.customerType == EnumUserType.Customer {
                btnRefund.isHidden = true
                if index == 4{
                    self.attributingWithColor(label: statusLabel, boldTxt: AppointmentScreenTxt.status.localize(), regTxt: object?.AppointmentMessage ?? "", color: .themeGreen)
                    if object?.InsurancePlanId == 0{
                        btnRefund.isHidden = true
                        
                        if object?.IsRefundAllowed == true{
                            btnRefund.setTitle(AppointmentScreenTxt.refund.localize(), for: .normal)
                        }
                        else {
                            btnRefund.setTitle(AppointmentScreenTxt.refundtaken.localize(), for: .normal)
                        }
                    }
                    else{
                        btnRefund.isHidden = true} }
                else if index == 2{
                    btnRefund.isHidden = true
                    if object?.IsNotAvailable == true{
                        btnRefund.isHidden = true}
                    else{}
                }
                else{
                    
                    btnRefund.isHidden = true
                    cancelButton.isHidden = true
                    // btnNotAvailable.isHidden = true
                }
            }
            else{
                // btnNotAvailable.isHidden = true
                btnRefund.isHidden = true
                if index == 2 {
                    if object?.IsNotAvailable == true{
                        btnNotAvailable.setTitle(AppointmentScreenTxt.notAvilable.localize(), for: .normal)
                    }
                    else{
                        // btnNotAvailable.isHidden = true
                    }
                }
                if index == 4{
                    self.attributingWithColor(label: statusLabel, boldTxt: AppointmentScreenTxt.status.localize(), regTxt: object?.AppointmentMessage ?? "", color: .themeGreen)
                }
            }
            
            
            
            cmtLabel.isHidden = !(index == 3 && Authentication.customerType == EnumUserType.Customer)
            
            if   Authentication.customerType == EnumUserType.Customer && object?.Reviews != ""{
                
                let test1Attributes:[NSAttributedString.Key: Any] = [.font : UIFont.systemFont(ofSize: 15, weight: .semibold)]
                //  test1Attributes[.foregroundColor] = UIColor.red
                
                let test2Attributes:[NSAttributedString.Key: Any] = [.font : UIFont.systemFont(ofSize: 15, weight: .regular)]
                
                let test1 = NSAttributedString(string: "\(AppointmentScreenTxt.yourReview.localize())\n", attributes:test1Attributes)
                
                let test2 = NSAttributedString(string: "\(object?.Reviews ?? "")", attributes:test2Attributes)
                let text = NSMutableAttributedString()
                
                text.append(test1)
                text.append(test2)
                
                if object?.DoctorReply != nil && Authentication.customerType == EnumUserType.Customer{
                    let reply1Attributes:[NSAttributedString.Key: Any] = [.font : UIFont.systemFont(ofSize: 15, weight: .semibold)]
                    // reply1Attributes[.foregroundColor] = UIColor.red
                    
                    let reply2Attributes:[NSAttributedString.Key: Any] = [.font : UIFont.systemFont(ofSize: 15, weight: .regular)]
                    
                    let reply1 = NSAttributedString(string: "\n\(AppointmentScreenTxt.doctorReply.localize())\n", attributes:reply1Attributes)
                    let reply2 = NSAttributedString(string: object?.DoctorReply ?? "", attributes:reply2Attributes)
                    
                    text.append(reply1)
                    text.append(reply2)
                }
                
                cmtLabel.attributedText = text
                rateButton.isHidden = true
                
            }else if (index == 3 && Authentication.customerType == EnumUserType.Customer)
            {
                cmtLabel.isHidden = true
                btnRefund.isHidden = true
            }
        }
    }
    
    
    
    @IBAction func didtapManage(_ sender: Any) {
        NavigationHandler.pushTo(.appointmentDetails(self.object!))
    }
    
    
    @IBAction func didtapUploadfiles(_ sender: Any) {
        //    refundalert()
        
        
        
        
    }
    func allowedRefundOption(_ appId: Int){
        let queryItems = ["AppointmentId": appId] as [String: Any]
        
        WebService.allowedRefundOption(queryItems: queryItems) { (result) in
            DispatchQueue.main.async { [self] in
                activityIndicator.hideLoader()
                switch result {
                case .success(let response):
                    print("succ")
                    if response.status == "0"{
                        AlertManager.showAlert(type: .custom(response.message ?? ""), actionTitle: AlertBtnTxt.okay.localize()){
                            self.refundOptions = response.object
                            print(self.refundOptions)
                            
                        }
                    }
                    else{
                        self.appid = String(self.object?.Id ?? 0)
                        //refundalert()
                        NavigationHandler.pushTo(.refundtype(self.appid))
                        
                    }
                case .failure(let error):
                    print(error.message)
                    AlertManager.showAlert(type: .custom(error.message))
                //  AlertManager.showAlert(type: .custom(error.message))
                }
                
            }
        }
    }
    
    
    
    @IBAction func didtapViewfiles(_ sender: Any) {
        if Authentication.customerType == EnumUserType.Doctor{
            AlertManager.showAlert(type: .custom(AppointmentScreenTxt.patientNtAvilable.localize()), actionTitle: AlertBtnTxt.okay.localize()){
                
            }
        }
        else{
            AlertManager.showAlert(type: .custom(AppointmentScreenTxt.doctorNtAvilable.localize()), actionTitle: AlertBtnTxt.okay.localize()){
                
            }
        }
    }
    
    
    @IBAction func didTapRateThisDoctor(_ sender: Any) {
        handler?(.rating)
    }
    
    @IBAction func didTapCancelButton(_ sender: Any) {
        if index == 4 {
            AlertManager.showAlert(type: .custom(AppointmentScreenTxt.areYouSureDeleApointment.localize()), actionTitle: AlertBtnTxt.okay.localize()) {
                Authentication.customerType == EnumUserType.Doctor ? self.deleteDoctorAppointment(self.object?.Id ?? 0) : self.deleteMemberAppointment(self.object?.Id ?? 0)
            }
            
        } else {
            AlertManager.showAlert(type: .custom(AppointmentScreenTxt.areYouSureCancelApointment.localize()), actionTitle: AlertBtnTxt.okay.localize()) {
                Authentication.customerType == EnumUserType.Doctor ? self.cancelDoctorAppointment(self.object?.Id ?? 0) : self.cancelMemberAppointment(self.object?.Id ?? 0)
            }
        }
    }
    @IBAction func didTapConfirmButton(_ sender: Any) {
        if index == 1 && Authentication.customerType == EnumUserType.Doctor{
            AlertManager.showAlert(type: .custom(AppointmentScreenTxt.ConfirmApointement.localize()), actionTitle: AlertBtnTxt.okay.localize()) {
                self.managependingappointment(self.object?.Id ?? 0)
            }
        } else if index == 2 && Authentication.customerType == EnumUserType.Doctor{
            
            AlertManager.showAlert(type: .custom(AppointmentScreenTxt.areYouSureCompleteApointment.localize()), actionTitle: AlertBtnTxt.okay.localize()) {
                NavigationHandler.pushTo(.enterOtpVC(self.object!))
            }
        }
    }
    
    
    func managependingappointment(_ appId: Int)
    {
        let queryItems = ["id": appId] as [String: Any]
        activityIndicator.showLoaderOnWindow()
        WebService.managePendingDoctorAppointments(queryItems: queryItems) { (result) in
            DispatchQueue.main.async {
                activityIndicator.hideLoader()
                switch result {
                case .success(let response):
                    AlertManager.showAlert(type: .custom(AppointmentScreenTxt.movedSucessfullyConfirm.localize()))
                    self.handler?(.confirm)
                    print(response)
                case .failure(let error):
                    AlertManager.showAlert(type: .custom(error.message))
                }
                self.getTopMostViewController()?.view.activityStopAnimating()
            }
        }
    }
    
    func manageConfirmAppointment(_ appId: String)
    {
        let queryItems = ["id": appId] as [String: Any]
        activityIndicator.showLoaderOnWindow()
        WebService.manageConfirmedAppointments(queryItems: queryItems) { (result) in
            DispatchQueue.main.async {
                activityIndicator.hideLoader()
                switch result {
                case .success(let response):
                    print(response)
                    NotificationCenter.default.post(name: Notification.Name("appointment"), object: self.index)
                    AlertManager.showAlert(type: .custom(AppointmentScreenTxt.movedSucessFullyComplete.localize()))
                    
                    self.handler?(.none)
                case .failure(let error):
                    AlertManager.showAlert(type: .custom(error.message))
                }
                self.getTopMostViewController()?.view.activityStopAnimating()
                
            }
        }
    }
    
    
    
    //MARK:// otp enter popup
    func presentAlert() -> Void {
        showInputDialog(title: nil,
                        subtitle: AppointmentScreenTxt.enterOtpMember.localize(),
                        actionTitle: AppointmentScreenTxt.submitt.localize(),
                        cancelTitle: AlertBtnTxt.cancel.localize(),
                        inputPlaceholder: AppointmentScreenTxt.EnterOtp.localize(),
                        inputKeyboardType: .numberPad)
        { (input:String?) in
            print("The new meal is \(input ?? "")")
            if input!.isEmpty || input?.count != 4{
                AlertManager.showAlert(type: .custom(AppointmentScreenTxt.OTPSentMember.localize()))
            }else
            {
                AlertManager.showAlert(type: .custom(AppointmentScreenTxt.valid.localize()))
                // self.manageConfirmAppointment("\(self.object?.Id ?? 0)")
            }
        }
    }
    
    func cancelMemberAppointment(_ appId: Int){
        let queryItems = ["id": appId] as [String: Any]
        activityIndicator.showLoaderOnWindow()
        WebService.cancelMemberAppointment(queryItems: queryItems) { (result) in
            DispatchQueue.main.async {
                activityIndicator.hideLoader()
                switch result {
                case .success:
                    NotificationCenter.default.post(name: Notification.Name("appointment"), object: self.index)
                    AlertManager.showAlert(type: .custom(AppointmentScreenTxt.movedSucessFullyHistory.localize()))
                    self.handler?(.none)
                case .failure(let error):
                    AlertManager.showAlert(type: .custom(error.message))
                }
                self.getTopMostViewController()?.view.activityStopAnimating()
                
            }
        }
    }
    func cancelDoctorAppointment(_ appId: Int){
        let queryItems = ["id": appId] as [String: Any]
        activityIndicator.showLoaderOnWindow()
        WebService.canceldoctorappointment(queryItems: queryItems) { (result) in
            DispatchQueue.main.async {
                activityIndicator.hideLoader()
                switch result {
                case .success(let response):
                    print(response)
                    NotificationCenter.default.post(name: Notification.Name("appointment"), object: self.index)
                    AlertManager.showAlert(type: .custom((AppointmentScreenTxt.movedSucessFullyHistory.localize())))
                    self.handler?(.none)
                case .failure(let error):
                    AlertManager.showAlert(type: .custom(error.message))
                }
                self.getTopMostViewController()?.view.activityStopAnimating()
                
            }
        }
    }
    func deleteDoctorAppointment(_ appId: Int){
        let queryItems = ["id": appId] as [String: Any]
        activityIndicator.showLoaderOnWindow()
        WebService.deleteDoctorAppointment(queryItems: queryItems) { (result) in
            DispatchQueue.main.async {
                activityIndicator.hideLoader()
                switch result {
                case .success(let response):
                    print(response)
                    NotificationCenter.default.post(name: Notification.Name("appointment"), object: self.index)
                    AlertManager.showAlert(type: .custom(AppointmentScreenTxt.AppointementSucessfullyDelete.localize()))
                    self.handler?(.none)
                case .failure(let error):
                    AlertManager.showAlert(type: .custom(error.message))
                }
            }
        }
    }
    func deleteMemberAppointment(_ appId: Int){
        let queryItems = ["id": appId] as [String: Any]
        activityIndicator.showLoaderOnWindow()
        WebService.deleteMemberAppointment(queryItems: queryItems) { (result) in
            DispatchQueue.main.async {
                activityIndicator.hideLoader()
                switch result {
                case .success(let response):
                    print(response)
                    NotificationCenter.default.post(name: Notification.Name("appointment"), object: self.index)
                    AlertManager.showAlert(type: .custom(AppointmentScreenTxt.AppointementSucessfullyDelete.localize()))
                    
                    self.handler?(.none)
                case .failure(let error):
                    AlertManager.showAlert(type: .custom(error.message))
                }
            }
        }
    }
    
    
    
    func getDoctorPrescription() -> Void {
        activityIndicator.showLoaderOnWindow()
        let queryItems = ["AppointmentId": "\(object?.Id ?? 0)"]
        WebService.getDoctorPrescription(queryItems: queryItems) { (result) in
            DispatchQueue.main.async {
                activityIndicator.hideLoader()
                switch result {
                case .success (let response):
                    if let prescription = response.object{
                        self.prescriptionData = prescription
                        self.drPrescription = self.prescriptionData?.PrescriptionBody ?? ""
                        if self.drPrescription == ""{
                            AlertManager.showAlert(type: .custom(AppointmentScreenTxt.prescriptonNtFound.localize()))
                        }else{
                            
                            NavigationHandler.pushTo(.drPrescription(self.drPrescription,self.object!))
                            //                            let termsVc = TermsVC.init(nibName: "TermsVC", bundle: nil)
                            //                            termsVc.modalPresentationStyle = .fullScreen
                            //                            termsVc.screentitle = "Prescription By Doctor"
                            //                            termsVc.requestURLString = self.drPrescription
                            //                            self.getTopMostViewController()!.present(termsVc, animated: true, completion: nil)
                        }
                    }
                    
                case .failure(let error):
                    self.drPrescription = ""
                    AlertManager.showAlert(type: .custom(error.message))
                }
            }
        }
    }
}



