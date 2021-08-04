//
//  BookAppointmentController.swift
//  SmileIndia
//
//  Created by Na on 07/07/19.
//  Copyright © 2019 Na. All rights reserved.
//

import UIKit
import MarqueeLabel
import Razorpay


class BookAppointmentController: UIViewController {
    
    var reachability : Reachability {
        let reachability = Reachability()!
        return reachability
    }
    
    @IBOutlet weak var tdcpLabel: UILabel!
    
    @IBOutlet weak var btnVideocall: UIButton!
    @IBOutlet weak var btnPhysical: UIButton!
    
    @IBOutlet weak var profileImageView: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var degreeLabel: MarqueeLabel!
    @IBOutlet weak var specialityLabel: MarqueeLabel!
    @IBOutlet weak var dayCollectionCell: UICollectionView!
    @IBOutlet weak var timeCollectionCell: UICollectionView!
    
    @IBOutlet weak var previousAppointmentTextfield: UITextField!
    @IBOutlet weak var reasonTextfield: UITextField!
    
    @IBOutlet weak var expImage: UIImageView!
    @IBOutlet weak var expLabel: UILabel!
    
    @IBOutlet weak var tellaboutLabel: UILabel!
    @IBOutlet weak var clinicLabel: UILabel!
    @IBOutlet weak var addressLabel: UILabel!
    
    @IBOutlet weak var ageTextfield: UITextField!
    
    
    @IBOutlet weak var tellaboutImage: UIImageView!
    
    
    @IBOutlet weak var relationStck: UIStackView!
    @IBOutlet weak var nameStck: UIStackView!
    
    @IBOutlet weak var relationTF: UITextField!
    @IBOutlet weak var nameTF: UITextField!
    
    @IBOutlet weak var btnMySelf: UIButton!
    @IBOutlet weak var btnOthers: UIButton!
    
    @IBOutlet weak var ratingLabel: UILabel!
    @IBOutlet weak var ratingView: STRatingControl!
    
    @IBOutlet weak var btnDeleteCard: UIButton!
    
    var doctor: Doctor?
    let viewModel = AppointmentViewModel()
    var datasource = GenericCollectionDataSource()
    var datasource1 = GenericCollectionDataSource()
    var selectedDayIndex = 0
    var selectedTimeIndex = 0
    var selectedDate: String?
    var selectedTime: String?
    
    var selectedDateTime: String?
    
    
    @IBOutlet weak var insuranceView: UIView!
    @IBOutlet weak var insuranceBtn: UIButton!
    @IBOutlet weak var btnUploadCard: UIButton!
    @IBOutlet weak var clearInsuranceButton: UIButton!
    
    
    @IBOutlet weak var patientNameLbl: UILabel!
    @IBOutlet weak var ReasonForAPTLbl: UILabel!
    @IBOutlet weak var AgePatientLbl: UILabel!
    @IBOutlet weak var relationPatientLbl: UILabel!
    
    var appointmentData: AppointmentIdAndAge?
    
    var appointmentCheckOut: AppointmentCheckOut?
    
    var firstDate = ""
    
    var radioTypeBtns:[UIButton] = []
    var typeId = ""
    
    var apnmntfee = "0"
    var ConsultationAmount = "0"
    var TaxAmount = "0"
    var apntType = ""
    
    var radioBookingFor:[UIButton] = []
    var bookingForId = "1"
    
    var relationArray = ["Relation With Patient","Brother","Daughter","Father","Mother","Other","Sister","Son"]
    
    let pvStart = UIPickerView()
    var selectedStart = 0
    var responseMsg = ""
    
    var img = UIImage()
    
    var insuranceListforSearch = [InsuranceList]()
    var insurancePlanID = 0
    var planName = ""
    var checkPlan = false
    var checkCardImage = false
    var checkPlanAcceptance = false
    
    lazy var picker: CustomImagePicker = {
        let imagePicker = CustomImagePicker()
        imagePicker.handler = {
            self.img = $0
            self.uploadInsuranceCard()
        }
        return imagePicker
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setStatusBar(color: .themeGreen)
        hideKeyboardWhenTappedAround()
        
        self.view.activityStartAnimating(activityColor: .themeGreen, backgroundColor: UIColor.white)
        
        getAge()
        typeId = "1"
        nameLabel.text = doctor?.ProviderName ?? ""
        if doctor?.Otherspeciality == nil{
            var lblTxt = "\(/doctor?.Practice)"
            degreeLabel.text =  lblTxt
        }
        else{
            var lblTxt = "\(/doctor?.Practice),\n\(/doctor?.Otherspeciality)"
            //  lblTxt = lblTxt.replacingOccurrences(of: ",\n,", with: ",\n")
            degreeLabel.text =  lblTxt
        }
        
        
        if doctor?.TreatmentDiscount ?? "" == ""{
            if(Device.IS_IPHONE){
                self.attributingWithColorWithFontSizeForVC(label: tdcpLabel, boldTxt: "", regTxt: "", color: .themeGreen, fontSize: 13)
            }else{
                self.attributingWithColorWithFontSizeForVC(label: tdcpLabel, boldTxt: "", regTxt: "", color: .themeGreen, fontSize: 20)
            }
        }else{
            if(Device.IS_IPHONE){
                if #available(iOS 13.0, *) {
                    self.attributingWithColorWithFontSizeForVC(label: tdcpLabel, boldTxt: BookAppointmentScreenTxt.UninsuredTreatMentDiscount.localize(), regTxt: "\(doctor?.TreatmentDiscount ?? "")" + "%", color: .label, fontSize: 13)
                } else {
                    self.attributingWithColorWithFontSizeForVC(label: tdcpLabel, boldTxt: BookAppointmentScreenTxt.UninsuredTreatMentDiscount.localize(), regTxt: "\(doctor?.TreatmentDiscount ?? "")" + "%", color: .black, fontSize: 13)
                }
            }else{
                if #available(iOS 13.0, *) {
                    self.attributingWithColorWithFontSizeForVC(label: tdcpLabel, boldTxt: BookAppointmentScreenTxt.UninsuredTreatMentDiscount.localize(), regTxt: "\(doctor?.TreatmentDiscount ?? "")" + "%", color: .label, fontSize: 20)
                } else {
                    self.attributingWithColorWithFontSizeForVC(label: tdcpLabel, boldTxt: BookAppointmentScreenTxt.UninsuredTreatMentDiscount.localize(), regTxt: "\(doctor?.TreatmentDiscount ?? "")" + "%", color: .black, fontSize: 20)
                }
            }
        }
        
        /* if doctor?.Practice  == "Others"{
         specialityLabel.text = "\(doctor?.Otherspeciality ?? "" ), \(doctor?.CityName ?? "")"
         }else doctor?.Otherspeciality == nil || doctor?.Otherspeciality == ""{
         specialityLabel.text = "\(doctor?.Practice ?? ""), \(doctor?.CityName ?? "")"
         }
         else{
         specialityLabel.text = "\(doctor?.Practice ?? ""), \(doctor?.Otherspeciality ?? ""), \(object?.CityName ?? "")"
         }*/
        
        //  tellaboutLabel.text = doctor?.TellAboutYourSelf ?? ""
        //  tellaboutImage.isHidden = (doctor?.TellAboutYourSelf == nil || doctor?.TellAboutYourSelf == "")
        
        profileImageView.sd_setImage(with: doctor?.imageURL, placeholderImage: UIImage.init(named: doctor?.CustomerTypeId == 1 ? "doctor-avtar" : "hospital-avtar"))
        if let address1 = doctor?.Address1?[0] {
            //  addressLabel.text = "\(address1.Address ?? ""),\(address1.ZipCode ?? "")"
            self.addAttributesToTextForVC(label: addressLabel, boldTxt: BookAppointmentScreenTxt.permanentAddress.localize(), regTxt: "\(address1.Address ?? ""),\(address1.ZipCode ?? "")",fontSize:12,firstFontWeight:.bold,secFontWeight:.regular)
            
        }
        if let address1 = doctor?.Address1?[0] {
            self.addAttributesToTextForVC(label: clinicLabel, boldTxt: BookAppointmentScreenTxt.ClinicPracticeName.localize(), regTxt: address1.HospitalName ?? "",fontSize:12,firstFontWeight:.bold,secFontWeight:.regular)
            
        }
        
        if let address1 = doctor?.Address1?[0] {
            let rate = Int(address1.Rating ?? "0") ?? 0
            ratingView.rating = rate
            ratingLabel.isHidden = !(rate > 0)
            ratingView.isHidden = !(rate > 0)
            ratingLabel.text = "\(rate) Rating"
        }
        
        if (doctor?.Experience) != nil || doctor?.Experience == "" {
            expLabel.isHidden = false
            expImage.isHidden = false
            
            self.addAttributesToTextForVC(label: self.expLabel, boldTxt: BookAppointmentScreenTxt.experience.localize(), regTxt: (doctor?.Experience ?? "") + " Years",fontSize:12,firstFontWeight:.bold,secFontWeight:.regular)
        }else{
            self.expLabel.isHidden = true
            self.expImage.isHidden = true
        }
        
        viewModel.getDays() {
            self.setupCell(self.viewModel.days)
            self.firstDate = self.viewModel.days[0]
        }
        DispatchQueue.main.asyncAfter(deadline: .now()+3.0) {
            let queryItems = ["ProviderId": self.doctor?.ProviderID ?? "", "SelectedDate": self.firstDate, "currenttime": self.currentTime(),"PatientId":Authentication.customerId ?? ""]
            //  let queryItems = ["ProviderId": self.doctor?.ProviderID ?? "", "SelectedDate": self.firstDate, "PatientId":Authentication.customerId ?? ""]
            
            //   let queryItems = self.selectedDate == self.currentDate() ? ["ProviderId": self.doctor?.ProviderID ?? "", "SelectedDate": self.currentDate(), "currenttime": self.currentTime(),"PatientId":Authentication.customerId ?? ""] : ["ProviderId": self.doctor?.ProviderID ?? "", "SelectedDate": self.currentDate(),"PatientId":Authentication.customerId ?? ""]
            
            self.viewModel.getTime(queryItems, completion: {
                self.setupTimeCell(self.viewModel.time)
                self.view.activityStopAnimating()
            })
        }
        
        radioTypeBtns.append(btnPhysical)
        radioTypeBtns.append(btnVideocall)
        
        radioBookingFor.append(btnMySelf)
        radioBookingFor.append(btnOthers)
        self.nameStck.isHidden = true
        self.relationStck.isHidden = true
        
        //        relationTF.text = relationArray[selectedStart]
        //        self.createPicker()
        //        self.dismissPickerView()
        
        if planName != ""{
            self.isCheckDoctorAcceptedInsurance(insurancePlanId: self.insurancePlanID)
            self.insuranceBtn.setTitle(planName, for: .normal)
            self.clearInsuranceButton.setImage(UIImage(named: "cancel.png"), for: .normal)
        }
        self.btnDeleteCard.isHidden = true
    }
    func createPicker() -> Void {
        pvStart.delegate = self
        relationTF.rightViewMode = UITextField.ViewMode.always
        relationTF.rightView = UIImageView(image: UIImage(named: "dropdown"))
        relationTF.inputView = pvStart
    }
    func dismissPickerView() {
        let toolBar = UIToolbar()
        toolBar.sizeToFit()
        
        let button = UIBarButtonItem(title: AlertBtnTxt.done.localize(), style: .done, target: self, action: #selector(self.action))
        button.tintColor = .lightGray
        toolBar.setItems([button], animated: true)
        toolBar.isUserInteractionEnabled = true
        relationTF.inputAccessoryView = toolBar
    }
    
    @objc func action() {
        if relationTF.isEditing == true {
            relationTF.text = relationArray[selectedStart]
        }
        view.endEditing(true)
    }
    override func viewWillAppear(_ animated: Bool) {
        // self.selectedTime = nil
        setUpLbl()
    }
    
    func setUpLbl() {
        
        // Atrribute
        let attributes = [[NSAttributedString.Key.foregroundColor:UIColor.red]]
        
        // patientNameLbl
        patientNameLbl.attributedText = HeadingLblTxt.BookAppointment.patientName.localize().highlightWordsIn(highlightedWords: "*", attributes: attributes)
        
        // ReasonForAPTLbl
        ReasonForAPTLbl.attributedText = HeadingLblTxt.BookAppointment.reasonForApt.localize().highlightWordsIn(highlightedWords: "*", attributes: attributes)
        
        //AgePatientLbl
        AgePatientLbl.attributedText = HeadingLblTxt.BookAppointment.ageofpatient.localize().highlightWordsIn(highlightedWords: "*", attributes: attributes)
        
        // relationPatientLbl
        relationPatientLbl.attributedText = HeadingLblTxt.BookAppointment.relationOfpatient.localize().highlightWordsIn(highlightedWords: "*", attributes: attributes)
        
    }
    
    @IBAction func didTapBackButton(_ sender: Any){
        NavigationHandler.pop()
    }
    
    @IBAction func didTapType(_ sender: UIButton) {
        for rButton in radioTypeBtns {
            rButton.setImage(UIImage(named: "radio-unselected.png"), for: .normal)
        }
        if sender.titleLabel?.text == BookAppointmentScreenTxt.InPerson.localize()
        {
            
            typeId = "1"
            sender.setImage(UIImage(named: "vigorto-radio.png"), for: .normal)
        }else{
            if Int(doctor?.EConsultationFee ?? "0") == 0 || doctor?.EConsultationFee == "" {
                AlertManager.showAlert(type: .custom(BookAppointmentScreenTxt.drNtAvilableVideoCall.localize()))
                
            }else {
                
                sender.setImage(UIImage(named: "vigorto-radio.png"), for: .normal)
                typeId = "2"
                
            }
            
        }
    }
    
    
    @IBAction func didtapBookingFor(_ sender: UIButton) {
        
        for rButton in radioBookingFor {
            rButton.setImage(UIImage(named: "radio-unselected.png"), for: .normal)
        }
        if sender.titleLabel?.text == BookAppointmentScreenTxt.mySelf.localize(){
            self.ageTextfield.text = "\(appointmentData?.Age ?? 0)"
            bookingForId = "1"
            sender.setImage(UIImage(named: "vigorto-radio.png"), for: .normal)
            self.nameStck.isHidden = true
            self.relationStck.isHidden = true
        }else{
            self.ageTextfield.text = ""
            sender.setImage(UIImage(named: "vigorto-radio.png"), for: .normal)
            bookingForId = "2"
            self.nameStck.isHidden = false
            self.relationStck.isHidden = false
        }
    }
    
    @IBAction func didtapChooseInsurances(_ sender: Any) {
        self.presentInsuranceSreen()
    }
    func presentInsuranceSreen(){
        let showItemStoryboard = UIStoryboard(name: "insurance", bundle: nil)
        let showItemNavController = showItemStoryboard.instantiateViewController(withIdentifier: "InsuranceSearchVC") as! InsuranceSearchVC
        showItemNavController.insuranceList = self.insuranceListforSearch
        showItemNavController.delegate = self
        present(showItemNavController, animated: true, completion: nil)
    }
    
    @IBAction func didtapClearInsurance(_ sender: Any) {
        
        if clearInsuranceButton.hasImage(named: "dropdown.png", for: .normal) {
            self.presentInsuranceSreen()
        }else{
            self.checkPlanAcceptance = true
            self.insuranceView.borderColor = .themeGreen
            clearInsuranceButton.setImage(UIImage(named: "dropdown.png"), for: .normal)
            self.insurancePlanID = 0
            self.insuranceBtn.setTitle(BookAppointmentScreenTxt.insurenceCarrierPlan.localize(), for: .normal)
        }
    }
    
    @IBAction func didtapUploadCard(_ sender: Any) {
        picker.showOptions()
        
        /*   if self.checkPlanAcceptance == true{
         picker.showOptions()
         }else{
         AlertManager.showAlert(type: .custom("\(self.doctor?.ProviderName ?? "") is out-of-network for the insurance you selected : \((self.insuranceBtn.titleLabel?.text ?? "").uppercased()) .\n Please change the plan and try again"))
         } */
    }
    
    @IBAction func didtapDeleteCard(_ sender: Any) {
        self.btnDeleteCard.isHidden = true
        self.btnUploadCard.setTitle(BookAppointmentScreenTxt.uploadInsurecardimage.localize(), for: .normal)
    }
    
    
    @IBAction func didTapBookAppointment(_ sender: Any) {
        if isValid(){
            
            let weekDay = /getDayOfWeek(DateStr: /selectedDate)?.uppercased()
            
            if  weekDay == EnumWeekend.Friday || weekDay == EnumWeekend.Saturday || weekDay == EnumWeekend.Sunday{
               // print("Date Exist in Weekend")
                
               
                //Create the AlertController and add Its action like button in Actionsheet
                let alert = UIAlertController(title: "", message: BookAppointmentScreenTxt.weekandAptntConfirmed.localize(), preferredStyle: UIAlertController.Style.alert)
                
                let EditActionButton = UIAlertAction(title: AlertBtnTxt.cancel.localize(), style: .default) { _ in
                }
                EditActionButton.titleTextColor = UIColor.themeGreen
                alert.addAction(EditActionButton)
                
               
                let ContinueActionButton = UIAlertAction(title: AlertBtnTxt.Continue.localize(), style: .default)
                { _ in
                    self.CallBookAppointement()
                }
                ContinueActionButton.titleTextColor = UIColor.themeGreen
                alert.addAction(ContinueActionButton)
                
                self.present(alert, animated: true, completion: nil)
                
            }else{
                CallBookAppointement()
            }
            
        }
        else
        {
            CallBookAppointement()
        }
    }
    
    
    
    func CallBookAppointement()  {
        if self.insurancePlanID == 0 && btnUploadCard.titleLabel?.text == BookAppointmentScreenTxt.uploadInsurecardimage.localize(){
            self.bookAppointment(insurancePlanId: 0, insurancePlanName: "", appInsuraceCardId: "")
        }else{
            self.checkPlan = !(insurancePlanID == 0)
            self.checkCardImage = !(btnUploadCard.titleLabel?.text == BookAppointmentScreenTxt.uploadInsurecardimage.localize())
            
            /*   if self.checkCardImage == false{
             AlertManager.showAlert(type: .custom("Please select an Insurance card if you want to book an appointment with insurance!"))
             }else if self.checkPlan == false  {
             AlertManager.showAlert(type: .custom("Please select an Insurance plan if you want to book an appointment with insurance!"))
             }else if self.checkPlan == false  || self.checkCardImage == false{
             AlertManager.showAlert(type: .custom("Please select an Insurance plan And Insurance card if you want to book an appointment with insurance!"))
             } */
            if self.checkPlan == true  && self.checkCardImage == true{
                if self.checkPlanAcceptance == true{
                    self.bookAppointment(insurancePlanId: self.insurancePlanID, insurancePlanName: self.insuranceBtn.titleLabel?.text ?? "", appInsuraceCardId: self.btnUploadCard.titleLabel?.text ?? "")
                }else{
                    AlertManager.showAlert(type: .custom("\(self.doctor?.ProviderName ?? "") \(BookAppointmentScreenTxt.outofNwInsurenceSelected.localize()) \((self.insuranceBtn.titleLabel?.text ?? "").uppercased()) .\n \(BookAppointmentScreenTxt.changeTryPlan.localize())"))
                }
            }else{
                AlertManager.showAlert(type: .custom(BookAppointmentScreenTxt.selectInsurencePlancardifWant.localize()))
            }
        }
    }
    
    func bookAppointment(insurancePlanId:Int , insurancePlanName:String ,appInsuraceCardId:String) -> Void {
        
        if let reason = reasonTextfield.text?.trimmingCharacters(in: .whitespacesAndNewlines){
            
            let queryItems = ["Appointmentday": selectedDate!, "Appointmenttime": selectedTime!, "Reason": reason,"Age": self.ageTextfield.text!, "Providerid": doctor?.ProviderID! ?? "", "MemberId": Authentication.customerId!, "MemeberEmail": Authentication.customerEmail!,"MeetType" : typeId,"AppointmentFor":bookingForId,"OtherPatientRelation":relationTF.text!,"OtherPatinetName":self.nameTF.text! ,"InsurancePlanId":insurancePlanId , "InsurancePlanName" :insurancePlanName , "AppInsuraceCardId": appInsuraceCardId] as [String : Any]
            
            self.view.activityStartAnimating(activityColor: .themeGreen, backgroundColor: UIColor.white)
            WebService.bookAppointment(queryItems: queryItems) { (result) in
                DispatchQueue.main.async {
                    switch result {
                    case .success(let response):
                        self.apntType = self.typeId
                        self.appointmentCheckOut = response.object
                        self.apnmntfee = (self.doctor?.DiscountOffered ?? "0")
                        self.responseMsg = response.message!
                        self.checkaddress()
                    case .failure(let error):
                        AlertManager.showAlert(type: .custom(error.message))
                    }
                    self.view.activityStopAnimating()
                }
            }
        }
    }
    
    func isCheckDoctorAcceptedInsurance(insurancePlanId:Int){
        let queryItems = ["ProviderGuId":doctor?.ProviderID ?? "" ,"InsurancePlanId":insurancePlanId] as [String : Any]
        WebService.isCheckDoctorAcceptedInsurance(queryItems: queryItems) { (result) in
            DispatchQueue.main.async {
                activityIndicator.hideLoader()
                switch result {
                case .success:
                    self.checkPlanAcceptance = true
                    self.insuranceView.borderColor = .themeGreen
                case .failure:
                    self.checkPlanAcceptance = false
                    self.insuranceView.borderColor = .red
                    AlertManager.showAlert(type: .custom("\(self.doctor?.ProviderName ?? "") \(BookAppointmentScreenTxt.outofNwInsurenceSelected.localize())   \((self.insuranceBtn.titleLabel?.text ?? "").uppercased())"))
                }
                self.view.activityStopAnimating()
            }
        }
    }
    
    func uploadInsuranceCard()  {
        let queryItems = ["image": self.img.jpegData(compressionQuality: 0.6)! ,"FilePath":"InsuranceCards"] as [String : Any]
        self.view.activityStartAnimating(activityColor: #colorLiteral(red: 0.233, green: 0.816, blue: 0.538, alpha: 1), backgroundColor: UIColor.white)
        WebService.uploadInsuranceCard(queryItems: queryItems) { (result) in
            DispatchQueue.main.async {
                switch result {
                case .success(let response):
                    self.btnUploadCard.setTitle(response.resultString ?? "", for: .normal)
                    self.btnDeleteCard.isHidden = false
                    AlertManager.showAlert(type: .custom(response.message ?? ""))
                case .failure(let error):
                    AlertManager.showAlert(type: .custom(error.message))
                }
                self.view.activityStopAnimating()
            }
        }
    }
    
    func checkaddress(){
        self.view.activityStartAnimating(activityColor: .themeGreen, backgroundColor: UIColor.white)
        
        WebService.isCheckMemberAddress(queryItems: ["LoginKey": Authentication.token ?? "YXNob2ttaXR0YWxAZ21haWwuY29tOjEyMzQ1Ng=="]) { (result) in
            DispatchQueue.main.async {
                switch result {
                case .success(let response):
                    if self.btnUploadCard.titleLabel?.text == BookAppointmentScreenTxt.uploadInsurecardimage.localize(){
                        NavigationHandler.pushTo(.paymentVC(self.appointmentCheckOut!,self.doctor!,self.selectedDateTime ?? "",self.selectedTime ?? "",response.message!,self.apntType,"",""))
                    }else{
                        NavigationHandler.pushTo(.paymentVC(self.appointmentCheckOut!,self.doctor!,self.selectedDateTime ?? "",self.selectedTime ?? "",response.message!,self.apntType,self.btnUploadCard.titleLabel?.text ?? "",self.insuranceBtn.titleLabel?.text ?? ""))
                    }
                case .failure(let error):
                    print(error.message)
                    self.updateAddress()
                }
                self.view.activityStopAnimating()
            }
        }
    }
    func updateAddress(){
        
        NavigationHandler.pushTo(.addmemberAddress)
    }
    
    
    func getOrderId(amount:String,appId:String) -> Void {
        
        let queryItems = ["Amount": amount, "Currency": "INR", "Receipt": appId]
        self.view.activityStartAnimating(activityColor: .themeGreen, backgroundColor: UIColor.white)
        WebService.createRazorPayOrder(queryItems: queryItems) { (result) in
            DispatchQueue.main.async {
                switch result {
                case .success (let response):
                    print(response.message!)
                    NavigationHandler.pushTo(.paymentVC(self.appointmentCheckOut!,self.doctor!,self.selectedDateTime ?? "",self.selectedTime ?? "",response.message!,self.apntType,self.btnUploadCard.titleLabel?.text ?? "",self.insuranceBtn.titleLabel?.text ?? ""))
                case .failure(let error):
                    AlertManager.showAlert(type: .custom(error.message))
                }
                self.view.activityStopAnimating()
            }
        }
    }
    
    func getAge() -> Void {
        let queryItems = ["ProviderId": doctor?.ProviderID ?? "", "MemberId": Authentication.customerId!]
        self.view.activityStartAnimating(activityColor: .themeGreen, backgroundColor: UIColor.white)
        WebService.getAppointmentsAgeAndAppointNo(queryItems: queryItems) { (result) in
            DispatchQueue.main.async {
                switch result {
                case .success (let response):
                    if let user = response.object {
                        self.appointmentData = user
                        self.setupUI()
                    }
                case .failure(let error):
                    AlertManager.showAlert(type: .custom(error.message))
                }
                self.view.activityStopAnimating()
            }
        }
    }
    
    func setupUI() -> Void {
        self.ageTextfield.text = "\(appointmentData?.Age ?? 0)"
    }
    
    func isValid() -> Bool {
        if selectedTime == nil{
            AlertManager.showAlert(type: .custom(BookAppointmentScreenTxt.selectAptTime.localize()))
            return false
        }else if bookingForId == "2" && nameTF.text!.isEmpty{
            AlertManager.showAlert(type: .custom(BookAppointmentScreenTxt.enterPatientName.localize()))
            return false
        }else if reasonTextfield.text!.isEmpty {
            reasonTextfield.becomeFirstResponder()
            AlertManager.showAlert(type: .custom(BookAppointmentScreenTxt.reasonForApt.localize()))
            return false
        }else if bookingForId == "1" && ageTextfield.text!.isEmpty{
            ageTextfield.becomeFirstResponder()
            AlertManager.showAlert(type: .custom(BookAppointmentScreenTxt.enterAge.localize()))
            return false
        }else if bookingForId == "1" && Int(ageTextfield.text!) ?? 0 < 18{
            ageTextfield.becomeFirstResponder()
            AlertManager.showAlert(type: .custom(BookAppointmentScreenTxt.enterAgeBt.localize()))
            return false
        }else if bookingForId == "2" && ageTextfield.text!.isEmpty{
            ageTextfield.becomeFirstResponder()
            AlertManager.showAlert(type: .custom("\(BookAppointmentScreenTxt.pleaseenter.localize()) \(nameTF.text!)'s \(BookAppointmentScreenTxt.ageFirst.localize())"))
            return false
        }
        
        //        else if bookingForId == "2" && Int(ageTextfield.text!) ?? 0 <= 0{
        //            AlertManager.showAlert(type: .custom("Please enter \(nameTF.text!)'s age first!"))
        //            return false
        //        }
        
        return true
    }
    
    
}

extension BookAppointmentController{
    func setupCell(_ data: [String]) {
        selectedDayIndex = data.count > 0 ? 0 : -1
        if data.count > 0{
            self.getDate(data[selectedDayIndex])
            self.selectedDateTime = data[selectedDayIndex]
            
        }
        datasource.array = data
        datasource.identifier = DayCollectionCell.identifier
        dayCollectionCell.dataSource = datasource
        dayCollectionCell.delegate = datasource
        datasource.configure = {cell, index in
            guard let dayCell = cell as? DayCollectionCell else { return }
            
            dayCell.dayLabel.text = self.getFormattedDate(strDate: (self.datasource.array[index] as? String)!, currentFomat: "EEE MM/dd/yyyy", expectedFromat: "dd MMM\nEEEE").uppercased()
            dayCell.select = index == self.selectedDayIndex ? true : false
        }
        if datasource.array.count > 0 {
            let label = UILabel(frame: CGRect.zero)
            label.text = datasource.array[0] as? String
            label.sizeToFit()
            datasource.sizeItem = CGSize.init(width: label.frame.width, height: 60)
        }
        datasource.didSelect = { cell, index  in
            guard let _ = cell as? DayCollectionCell else { return }
            self.selectedDayIndex = index
            self.getDate(data[index])
            
            self.selectedDateTime = data[index]
            
            let myString = data[index]
            let myStringArr = myString.components(separatedBy: " ")
            // var day = myStringArr [0]
            let slctddate = myStringArr [1]
            
            self.selectedDate = slctddate
            
            print(self.getDayOfWeek(DateStr: /self.selectedDate))
            
            self.dayCollectionCell.reloadData()
            
            DispatchQueue.main.async {
                let queryItems = self.selectedDate! == self.currentDate() ? ["ProviderId": self.doctor?.ProviderID ?? "", "SelectedDate": self.selectedDate!, "currenttime": self.currentTime(),"PatientId":Authentication.customerId ?? ""] : ["ProviderId": self.doctor?.ProviderID ?? "", "SelectedDate":self.selectedDate!,"PatientId":Authentication.customerId ?? ""]
                
                self.viewModel.getTime(queryItems, completion: {
                    self.setupTimeCell(self.viewModel.time)
                    self.timeCollectionCell.reloadData()
                })
            }
        }
    }
    
    func setupTimeCell(_ data: [String]) {
        selectedTimeIndex = data.count > 0 ? 0 : -1
        if data.count > 0 {
            self.selectedTime = data[selectedTimeIndex]
        }else{
            self.selectedTime = nil
        }
        datasource1.array = data.count > 0 ? data : ["Not Available"]
        datasource1.identifier = TimeCollectionCell.identifier
        timeCollectionCell.dataSource = datasource1
        timeCollectionCell.delegate = datasource1
        datasource1.configure = {cell, index in
            guard let timeCell = cell as? TimeCollectionCell else { return }
            timeCell.timeLabel.text = self.datasource1.array[index] as? String
            timeCell.select = index == self.selectedTimeIndex ? true : false
        }
        if datasource1.array.count > 0 {
            let label = UILabel(frame: CGRect.zero)
            label.text = datasource1.array[0] as? String
            label.sizeToFit()
            datasource1.sizeItem = CGSize.init(width: label.frame.width+20, height: 40)
        }
        datasource1.didSelect = { cell, index  in
            guard let _ = cell as? TimeCollectionCell else { return }
            if data.count > 0 {
                self.selectedTimeIndex = index
                self.selectedTime = data[index]
                self.timeCollectionCell.reloadData()
            }
        }
    }
    
    
    
    func getSelectedDate(_ data: String) {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "EEE MM/dd/yyyy"
        dateFormatter.defaultDate = Date()
        let date = dateFormatter.date(from: data)
        dateFormatter.dateFormat = "MM/dd/yyyy"
        self.selectedDate = dateFormatter.string(from: date ?? Date())
    }
    func getDate(_ data: String) {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "EEE dd MMMM"
        dateFormatter.defaultDate = Date()
        let date = dateFormatter.date(from: data)
        dateFormatter.dateFormat = "MM/dd/yyyy"
        self.selectedDate = dateFormatter.string(from: date ?? Date())
    }
    func currentDate() -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "MM/dd/yyyy"
        return dateFormatter.string(from: Date())
    }
    func currentTime() -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "hh:mm a"
        return dateFormatter.string(from: Date())
    }
    
    func getDayOfWeek(DateStr:String) -> String? {
        let formatter  = DateFormatter()
        formatter.dateFormat = "MM/dd/yyyy"
        guard let todayDate = formatter.date(from: DateStr) else { return nil }
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "EEEE"
        return dateFormatter.string(from: todayDate)
        
    }
}
extension BookAppointmentController: UIPickerViewDelegate, UIPickerViewDataSource, UITextFieldDelegate {
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return relationArray.count
    }
    func pickerView(_ pickerView: UIPickerView, viewForRow row: Int, forComponent component: Int, reusing view: UIView?) -> UIView {
        var pickerLabel: UILabel? = (view as? UILabel)
        if pickerLabel == nil {
            pickerLabel = UILabel()
            //  pickerLabel?.font = .systemFont(ofSize: 014)
            pickerLabel?.textAlignment = .center
        }
        pickerLabel?.text = relationArray[row]
        return pickerLabel!
    }
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return relationArray[row]
    }
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        selectedStart = row
        self.relationTF.text = relationArray[row]
    }
    
}


extension BookAppointmentController:InsuranceSearchVCDelegate{
    func selectedInsurance(planName: String, planID: Int, providerID: Int, isAccepted: Bool) {
        self.insurancePlanID = planID
        self.insuranceBtn.setTitle(planName, for: .normal)
        self.clearInsuranceButton.setImage(UIImage(named: "cancel.png"), for: .normal)
        self.isCheckDoctorAcceptedInsurance(insurancePlanId: planID)
    }
    
}

