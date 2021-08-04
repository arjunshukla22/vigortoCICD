//
//  ProfileForTwo.swift
//  SmileIndia
//
//  Created by Arjun  on 16/03/20.
//  Copyright © 2020 Na. All rights reserved.
//

import UIKit
import Localize

class ProfileForTwo: UIViewController {
    
    var lat:String?
    var long:String?
    
    @IBOutlet weak var countryCodeLabel: UILabel!
    @IBOutlet weak var flagImageView: UIImageView!
    @IBOutlet weak var countryCodeView: UIView!
    @IBOutlet weak var phoneTF: UITextField!
    
    @IBOutlet weak var tdpTF: UITextField!
    @IBOutlet weak var altPhoneTF: UITextField!
    @IBOutlet weak var pincodeTF: UITextField!
    @IBOutlet weak var stateTF: CustomTextfield!
    @IBOutlet weak var cityTF: CustomTextfield!
    
    @IBOutlet weak var deaTF: UITextField!
    @IBOutlet weak var npiTF: UITextField!
    @IBOutlet weak var countryTF: CustomTextfield!
    @IBOutlet weak var TimeZoneTF: CustomTextfield!
    @IBOutlet weak var expTF: UITextField!
    @IBOutlet weak var adrsTF: UITextField!
    @IBOutlet weak var address2TF: UITextField!
    @IBOutlet weak var consultationfeeTF: UITextField!
    @IBOutlet weak var pForMemTF: UITextField!
    @IBOutlet weak var webSiteTF: UITextField!
    @IBOutlet weak var tellAboutSelfTF: UITextField!
    @IBOutlet weak var tellAboutSelfTV: UITextView!
    @IBOutlet weak var econsultFeeLabel: UITextField!
    @IBOutlet weak var imgProfile: UIImageView!
    
    
    // Heading Label
    @IBOutlet weak var phoneLbl: UILabel!
    @IBOutlet weak var address1Lbl: UILabel!
    @IBOutlet weak var address2Lbl: UILabel!
    @IBOutlet weak var zipPostalLbl: UILabel!
    @IBOutlet weak var countryLbl: UILabel!
    @IBOutlet weak var stateLbl: UILabel!
    @IBOutlet weak var cityLbl: UILabel!
    @IBOutlet weak var timezoneLbl: UILabel!
    @IBOutlet weak var experienceLbl: UILabel!
    @IBOutlet weak var npiMINCLbl: UILabel!
    @IBOutlet weak var DEALbl: UILabel!
    @IBOutlet weak var consultationFeeLbl: UILabel!
    @IBOutlet weak var priceForMemberLbl: UILabel!
    @IBOutlet weak var eCunsulatationLbl: UILabel!
    @IBOutlet weak var unInsuredTreatmentLbl: UILabel!
    @IBOutlet weak var websiteLbl: UILabel!
    @IBOutlet weak var tellAboutLbl: UILabel!
    
    
    var viewModel = ProfileViewModel()
    var doctor: DoctorData?
    var dict = [String: Any]()
    
    //  var touchState = 0
    
    
    var countryCodeName = "US"
    
    lazy var picker: CustomImagePicker = {
        let imagePicker = CustomImagePicker()
        imagePicker.handler = {
            self.imgProfile.image = $0
        }
        return imagePicker
    }()
    var touchState = 0
    let pvStart = UIPickerView()
    var selectedStart = 0
    var timeZoneId = ""
    
    
    var userstimeZone: String {
        return TimeZone.current.localizedName(for: TimeZone.current.isDaylightSavingTime() ?.daylightSaving :.standard,locale: .current) ?? ""
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        setStatusBar(color: .themeGreen)
        hideKeyboardWhenTappedAround()
        
        
        countryTF.rightViewMode = UITextField.ViewMode.always
        countryTF.rightView = UIImageView(image: UIImage(named: "dropdown"))
        stateTF.rightViewMode = UITextField.ViewMode.always
        stateTF.rightView = UIImageView(image: UIImage(named: "dropdown"))
        cityTF.rightViewMode = UITextField.ViewMode.always
        cityTF.rightView = UIImageView(image: UIImage(named: "dropdown"))
        
        /*  countryCodeView.isUserInteractionEnabled = true
         let tapGesture = UITapGestureRecognizer.init(target: self, action: #selector(countrycodeList))
         countryCodeView.addGestureRecognizer(tapGesture) */
        
        self.countryTF.array = self.viewModel.country
        viewModel.getCountry() {
            self.setUI()
        }
        viewModel.getTimeZone(){
            self.createPicker()
            self.dismissPickerView()
            self.getAutomaticTimeZoneAndId()
        }
        
        self.tellAboutSelfTV.delegate = self
        setupLbl()
    }
    
    func setupLbl()  {
        
        // Atrribute
        let attributes = [[NSAttributedString.Key.foregroundColor:UIColor.red]]
        
        // Phone
        phoneLbl.attributedText = HeadingLblTxt.DocProfileOne.phone.localize().highlightWordsIn(highlightedWords: "*", attributes: attributes)
        
        // Address 1
        address1Lbl.attributedText = HeadingLblTxt.DocProfileOne.address1.localize().highlightWordsIn(highlightedWords: "*", attributes: attributes)
        
        // Address 2
        address2Lbl.attributedText = HeadingLblTxt.DocProfileOne.address2.localize().highlightWordsIn(highlightedWords: "*", attributes: attributes)
        
        //  Zip / Postal Code
        zipPostalLbl.attributedText = HeadingLblTxt.DocProfileOne.zipPostal.localize().highlightWordsIn(highlightedWords: "*", attributes: attributes)
        
        
        //  Country
        countryLbl.attributedText = HeadingLblTxt.DocProfileOne.country.localize().highlightWordsIn(highlightedWords: "*", attributes: attributes)
        
        //  State
        stateLbl.attributedText = HeadingLblTxt.DocProfileOne.state.localize().highlightWordsIn(highlightedWords: "*", attributes: attributes)
        
        //  City
        cityLbl.attributedText = HeadingLblTxt.DocProfileOne.city.localize().highlightWordsIn(highlightedWords: "*", attributes: attributes)
        
        //  timezone
        timezoneLbl.attributedText = HeadingLblTxt.DocProfileOne.timeZone.localize().highlightWordsIn(highlightedWords: "*", attributes: attributes)
        
        //  experience
        experienceLbl.attributedText = HeadingLblTxt.DocProfileOne.experience.localize().highlightWordsIn(highlightedWords: "*", attributes: attributes)
        
        //  npiMNC
        npiMINCLbl.attributedText = HeadingLblTxt.DocProfileOne.NPIMINC.localize().highlightWordsIn(highlightedWords: "*", attributes: attributes)
        
        
        //  DEA
        DEALbl.text = HeadingLblTxt.DocProfileOne.DEA.localize()
        
        //  consultation
        consultationFeeLbl.attributedText = HeadingLblTxt.DocProfileOne.consultation.localize().highlightWordsIn(highlightedWords: "*", attributes: attributes)
        
        //  price For Members
        priceForMemberLbl.attributedText = HeadingLblTxt.DocProfileOne.priceMember.localize().highlightWordsIn(highlightedWords: "*", attributes: attributes)
        
        //  e Consulation
        eCunsulatationLbl.text = HeadingLblTxt.DocProfileOne.eConsulation.localize()
        
        //  Uninsured
        unInsuredTreatmentLbl.text = HeadingLblTxt.DocProfileOne.UninsuredTreatDisc.localize()
        
        //  website
        websiteLbl.text = HeadingLblTxt.DocProfileOne.Website.localize()
        
        //  tell us About Self
        tellAboutLbl.text = HeadingLblTxt.DocProfileOne.tellYourSelf.localize()

    }
    
    func createPicker() -> Void {
        pvStart.delegate = self
        TimeZoneTF.rightViewMode = UITextField.ViewMode.always
        TimeZoneTF.rightView = UIImageView(image: UIImage(named: "dropdown"))
        TimeZoneTF.inputView = pvStart
    }
    func dismissPickerView() {
        let toolBar = UIToolbar()
        toolBar.sizeToFit()
        
        let button = UIBarButtonItem(title: AlertBtnTxt.done.localize(), style: .done, target: self, action: #selector(self.action))
        button.tintColor = .lightGray
        toolBar.setItems([button], animated: true)
        toolBar.isUserInteractionEnabled = true
        TimeZoneTF.inputAccessoryView = toolBar
    }
    
    @objc func action() {
        if  TimeZoneTF.isEditing == true {
            TimeZoneTF.text = self.viewModel.timezoneModel[selectedStart].DisplayName
            self.timeZoneId = self.viewModel.timezoneModel[selectedStart].Id ?? ""
        }
        view.endEditing(true)
    }
    
    func getAutomaticTimeZoneAndId() -> Void {
        if let object = self.viewModel.timezoneModel.filter({ $0.Id ==  doctor?.TimeZoneId }).first {
            TimeZoneTF.text = object.DisplayName
            self.timeZoneId = object.Id ?? ""
        }
    }
    @objc func countrycodeList(){
        
        let countryView = CountrySelectView.shared
        countryView.barTintColor = .red
        countryView.displayLanguage = .english
        countryView.show()
        countryView.selectedCountryCallBack = { (countryDic) -> Void in
            self.flagImageView.image = countryDic["countryImage"] as? UIImage
            self.countryCodeLabel.text = "+\(countryDic["code"] as! NSNumber)"
            self.countryCodeName = "\(countryDic["locale"] ?? "US")"
            
        }
    }
    
    @IBAction func didTapCountryTextField(_ sender: Any) {
        self.countryTF.array = self.viewModel.country
        guard let countryid = countryTF.accessibilityLabel else {
            return
            
        }
        viewModel.getState(countryid){
            self.stateTF.array = self.viewModel.states
            
            if self.touchState == 1{
                self.stateTF.accessibilityLabel = "0"
                if let object = self.viewModel.states.filter({ $0.Value == self.stateTF.accessibilityLabel }).first {
                    self.stateTF.text = object.Text
                }
            }
            else{
                guard let stateid = self.doctor?.StateId else {
                    return
                }
                self.stateTF.accessibilityLabel = "\(stateid)"
                if let object = self.viewModel.states.filter({ $0.Value == self.stateTF.accessibilityLabel }).first {
                    self.stateTF.text = object.Text
                    self.didTapStateTextField(UIButton())
                }}}
        self.touchState = 0
        
    }
    
    @IBAction func didTapStateTextField(_ sender: Any) {
        guard let stateId = stateTF.accessibilityLabel else {
            return}
        viewModel.getCity(stateId){
            self.cityTF.array = self.viewModel.cities
            
            if self.touchState == 1{
                self.cityTF.accessibilityLabel = "0"
                if let object = self.viewModel.cities.filter({ $0.Value == self.cityTF.accessibilityLabel }).first {
                    self.cityTF.text = object.Text
                }
            }else{
                guard let cityId = self.doctor?.CityId  else {
                    return
                }
                self.cityTF.accessibilityLabel = "\(cityId)"
                if let object = self.viewModel.cities.filter({ $0.Value == self.cityTF.accessibilityLabel }).first {
                    self.cityTF.text = object.Text
                }else{
                    self.cityTF.text = self.viewModel.cities.first?.Text
                }
            }
            self.touchState = 0
        }
    }
    @IBAction func didTapUploadImage(_ sender: UIButton) {
        picker.showOptions()
    }
    
    @IBAction func didTapNext(_ sender: UIButton) {
        if isValid() {
            dict["Phone"] = phoneTF.text
            dict["TimeZoneId"] = self.timeZoneId
            dict["ZipCode"] = pincodeTF.text
            dict["CountryId"] = countryTF.accessibilityLabel
            dict["StateId"] = stateTF.accessibilityLabel
            dict["CityId"] = cityTF.accessibilityLabel
            dict["Address1"] = adrsTF.text
            dict["Address2"] = address2TF.text
            dict["DAA"] = deaTF.text
            dict["NPIno"] = npiTF.text
            dict["ConsultationFee"] = consultationfeeTF.text
            dict["DiscountOffered"] = pForMemTF.text
            dict["EConsultationFee"] = self.econsultFeeLabel.text
            dict["TellAboutYourSelf"] = tellAboutSelfTV.text
            dict["Experience"] = expTF.text
            dict["Website"] = webSiteTF.text
            dict["Latitude"] = lat
            dict["Longitude"] = long
            dict["CountryCode"] = "+1"
            self.dict["CountryNameCode"] = "US"
            dict["TreatmentDiscount"] = self.tdpTF.text
            
            
            let doctorImg = imgProfile.image == UIImage.init(named: "") ? nil : imgProfile.image
            //  let doctorImg = ""
            NavigationHandler.pushTo(.updateMrngHrsVC(dict, doctorImg ,doctor!))
        }
    }
    @IBAction func didTapBack(_ sender: UIButton) {
        NavigationHandler.pop()
    }
    
    @objc func countrycodeListsave(){
        
        let countryView = CountrySelectView.shared
        //countryView.barTintColor = .red
        // countryView.displayLanguage = .english
        // countryView.show()
        countryView.selectedCountryCallBack = { (countryDic) -> Void in
            self.countryCodeLabel.text = self.doctor?.CountryCode
            self.flagImageView.image = countryDic["locale"] as? UIImage
        }
    }
    
    
    
    func setUI() {
        phoneTF.text = doctor?.Phone
        pincodeTF.text = doctor?.ZipCode
        countryTF.accessibilityLabel = "\(doctor?.CountryId ?? 0)"
        if let object = self.viewModel.country.filter({ $0.Value == countryTF.accessibilityLabel }).first {
            countryTF.text = object.Text
            self.didTapCountryTextField(UIButton())
        }
        
        if let object = self.viewModel.timezoneModel.filter({ $0.Id ==  doctor?.TimeZoneId }).first {
            self.timeZoneId = object.Id ?? ""
            TimeZoneTF.text = object.DisplayName
        }
        
        countryCodeLabel.text = doctor?.CountryCode
        countrycodeListsave()
        deaTF.text = doctor?.DAA
        npiTF.text = doctor?.NPINo
        expTF.text = doctor?.Experience
        adrsTF.text = doctor?.Address1
        address2TF.text = doctor?.Address2
        consultationfeeTF.text = "\(doctor?.ConsultationFee ?? 0)"
        self.econsultFeeLabel.text = "\(doctor?.EConsultationFee ?? "")"
        pForMemTF.text = doctor?.DiscountOffered
        webSiteTF.text = doctor?.Website
        tellAboutSelfTV.text = doctor?.TellAboutYourSelf
        lat = doctor?.Latitude
        long = doctor?.Longitude
        self.tdpTF.text = self.doctor?.TreatmentDiscount ?? ""
        
        imgProfile.sd_setImage(with: doctor?.profileImageURL, placeholderImage: UIImage.init(named: "doctor-avtar"))
        
        let dict = CountryCodeJson.filter{$0["locale"] as? String == (doctor?.CountryNameCode ?? "IN").uppercased()}.first
        let locale = dict?["locale"] as! String
        self.flagImageView.image = UIImage(named:"CountryPicker.bundle/\(locale)")
        self.countryCodeLabel.text = doctor?.CountryCode ?? ""
        
    }
    
}

extension ProfileForTwo{
    func isValid() -> Bool {
        
        // Phone number
        if phoneTF.text?.isEmptyString() ?? false || phoneTF.text!.count < 10 {
            phoneTF.becomeFirstResponder()
            AlertManager.showAlert(type: .custom(ProfileUpdate.mobilenumber.localize()))
            return false
        }
        else if phoneTF.text!.isEmpty || !phoneTF.text!.prefix(1).allSatisfy(("1"..."9").contains) {
            phoneTF.becomeFirstResponder()
            AlertManager.showAlert(type: .custom(ProfileUpdate.validPhnNumber.localize()))
            return false
        }
        
        // Address - 1
        else if adrsTF.text?.isEmptyString() ?? false{
            adrsTF.becomeFirstResponder()
            AlertManager.showAlert(type: .custom(ProfileUpdate.address.localize()))
            return false
        }
        // Address - 2
        else if address2TF.text?.isEmptyString() ?? false{
            address2TF.becomeFirstResponder()
            AlertManager.showAlert(type: .custom(ProfileUpdate.address2.localize()))
            return false
        }
        // pin Code
        else if  pincodeTF.text?.isEmptyString() ?? false {
            pincodeTF.becomeFirstResponder()
            AlertManager.showAlert(type: .custom(ProfileUpdate.pinCode.localize()))
            return false
        }
        else if !pincodeTF.text!.prefix(1).allSatisfy(("1"..."9").contains) {
            pincodeTF.becomeFirstResponder()
            AlertManager.showAlert(type: .custom(ProfileUpdate.validZipPOCode.localize()))
            return false
        }
        
        // Country
        else if countryTF.text! == "None" || countryTF.text! == "Select Country" {
        AlertManager.showAlert(type: .custom(ProfileUpdate.country.localize()))
        return false
        }
        // State
        else if  stateTF.accessibilityLabel == "0" || stateTF.accessibilityLabel == nil {
            AlertManager.showAlert(type: .custom(ProfileUpdate.State.localize()))
            return false
        }
        else if  stateTF.accessibilityLabel == "0" || countryTF.accessibilityLabel == nil {
            AlertManager.showAlert(type: .custom(ProfileUpdate.country.localize()))
            return false
        }
        
        // City
        else if cityTF.text! == "None"{
            AlertManager.showAlert(type: .custom(ProfileUpdate.city.localize()))
            return false
        }
        else if cityTF.accessibilityLabel == "0" || cityTF.accessibilityLabel == nil {
            AlertManager.showAlert(type: .custom(ProfileUpdate.city.localize()))
            return false
        }
        
        // Time Zone
        else if  TimeZoneTF.text == "Select TimeZone" || TimeZoneTF.text == ""{
            AlertManager.showAlert(type: .custom(ProfileUpdate.timeZone.localize()))
            return false
        }
        // Experience
        else if expTF.text!.isEmpty || !expTF.text!.prefix(1).allSatisfy(("1"..."9").contains) {
            expTF.becomeFirstResponder()
            AlertManager.showAlert(type: .custom(ProfileUpdate.experience.localize()))
            return false
        }
        else if let exp  = Int(expTF.text ?? "0"), exp > 99 {
            expTF.becomeFirstResponder()
            AlertManager.showAlert(type: .custom(ProfileUpdate.experValue.localize()))
            return false
        }
    
        // NPI MNC number
        else if  npiTF.text?.isEmptyString() ?? false   {
            npiTF.becomeFirstResponder()
            AlertManager.showAlert(type: .custom(ProfileUpdate.NPIMINC.localize()))
            return false
        }
       
        // DEA number
        else if deaTF.text!.count < 9 && deaTF.text!.count > 0 {
            deaTF.becomeFirstResponder()
            AlertManager.showAlert(type: .custom(ProfileUpdate.validDEA.localize()))
            return false
        }
       // Consultation Fee
        else if consultationfeeTF.text!.isEmpty  {
            consultationfeeTF.becomeFirstResponder()
            AlertManager.showAlert(type: .custom(ProfileUpdate.consultationFee.localize()))
            return false
        }
        else if let ex  = Float(consultationfeeTF.text ?? "0"), ex < 1.00 {
            consultationfeeTF.becomeFirstResponder()
            AlertManager.showAlert(type: .custom(ProfileUpdate.consultFeeless.localize()))
            return false
        }
        
        // Price for members
        else if pForMemTF.text!.isEmpty {
            pForMemTF.becomeFirstResponder()
            AlertManager.showAlert(type: .custom(ProfileUpdate.priceReq.localize()))
            return false
        }
        else if let ex  = Float(pForMemTF.text ?? "0"), ex < 1.00 {
            pForMemTF.becomeFirstResponder()
            AlertManager.showAlert(type: .custom(ProfileUpdate.priceMember.localize()))
            return false
        }
        
        else if let memberprice  = Int(pForMemTF.text ?? "0"),memberprice > Int(consultationfeeTF.text ?? "0") ?? 0 {
            pForMemTF.becomeFirstResponder()
            AlertManager.showAlert(type: .custom(ProfileUpdate.priceConsultFee.localize()))
            return false
        }
        
        // Doctor Treatment Discount
        else if let ex  = Float(tdpTF.text ?? "0"), ex < 1.00 && !(self.tdpTF.text!.isEmpty){
            tdpTF.becomeFirstResponder()
            AlertManager.showAlert(type: .custom(ProfileUpdate.insuredTreatment.localize()))
            return false
        }
        else if let ex  = Float(tdpTF.text ?? "0"), ex > 100.00 && !(self.tdpTF.text!.isEmpty){
            tdpTF.becomeFirstResponder()
            AlertManager.showAlert(type: .custom(ProfileUpdate.UnisuredTreatDisc.localize()))
            return false
        }
       
        // Website
        else if !webSiteTF.text!.isEmpty && !webSiteTF.text!.isStringLink(){
            webSiteTF.becomeFirstResponder()
            AlertManager.showAlert(type: .custom(ProfileUpdate.validurl.localize()))
            return false
        }
        
       
        return true
    }
}

extension ProfileForTwo: UIPickerViewDelegate, UIPickerViewDataSource, UITextFieldDelegate {
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return self.viewModel.timezoneModel.count
    }
    func pickerView(_ pickerView: UIPickerView, viewForRow row: Int, forComponent component: Int, reusing view: UIView?) -> UIView {
        var pickerLabel: UILabel? = (view as? UILabel)
        if pickerLabel == nil {
            pickerLabel = UILabel()
            pickerLabel?.font = .systemFont(ofSize: 014)
            pickerLabel?.textAlignment = .center
        }
        pickerLabel?.text = self.viewModel.timezoneModel[row].DisplayName ?? ""
        return pickerLabel!
    }
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return self.viewModel.timezoneModel[row].DisplayName ?? ""
    }
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        selectedStart = row
    }
    
}

extension ProfileForTwo: UITextViewDelegate{
    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        let newText = (textView.text as NSString).replacingCharacters(in: range, with: text)
        let numberOfChars = newText.count
        // charactersCountLabel.text = "\(140-numberOfChars)"
        return numberOfChars < 200    // 10 Limit Value
    }
}


