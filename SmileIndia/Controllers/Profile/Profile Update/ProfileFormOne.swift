//
//  ProfileFormOne.swift
//  SmileIndia
//
//  Created by Arjun  on 16/03/20.
//  Copyright © 2020 Na. All rights reserved.
//

import UIKit
import Localize
import ActiveLabel

class ProfileFormOne: BaseViewController {
    
    @IBOutlet weak var titleTF: CustomTextfield!
    @IBOutlet weak var fNameTF: UITextField!
    @IBOutlet weak var LNameTF: UITextField!
    @IBOutlet weak var genderTF: CustomTextfield!
    @IBOutlet weak var hospTF: UITextField!
    @IBOutlet weak var specTF: CustomTextfield!
    @IBOutlet weak var oSpecTF: UITextField!
    @IBOutlet weak var regNoTF: UITextField!
    @IBOutlet weak var degreeTF: CustomTextfield!
    @IBOutlet weak var oDegreeTF: UITextField!
    @IBOutlet weak var emailTF: UITextField!
    
    @IBOutlet weak var defaulterLabel: UILabel!
    
    // Heading Label
    @IBOutlet weak var selectTitleLbl: UILabel!
    @IBOutlet weak var firstNameLbl: UILabel!
    @IBOutlet weak var lastNameLbl: UILabel!
    @IBOutlet weak var selectGenderLbl: UILabel!
    @IBOutlet weak var clinicPracticeLbl: UILabel!
    @IBOutlet weak var selectSpecilityLbl: UILabel!
    @IBOutlet weak var otherSpecilityLbl: UILabel!
    @IBOutlet weak var registerationLicenseNoLbl: UILabel!
    @IBOutlet weak var selectDegreeLbl: UILabel!
    @IBOutlet weak var otherDegreeLbl: UILabel!
    @IBOutlet weak var emailLbl: UILabel!
    
    
    var viewModel = ProfileViewModel()
    var dict = [String: Any]()
    var doctor: DoctorData?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        setStatusBar(color: .themeGreen)
        if /Authentication.profileComplete == false{
            AlertManager.showAlert(type: .custom(ProfileUpdate.Alert.completeProfile.localize() ))
        }
        hideKeyboardWhenTappedAround()
        self.view.activityStartAnimating(activityColor: .themeGreen, backgroundColor: UIColor.white)
        
        
        
        emailTF.isUserInteractionEnabled = false
        
        
        titleTF.rightViewMode = UITextField.ViewMode.always
        titleTF.rightView = UIImageView(image: UIImage(named: "dropdown"))
        genderTF.rightViewMode = UITextField.ViewMode.always
        genderTF.rightView = UIImageView(image: UIImage(named: "dropdown"))
        specTF.rightViewMode = UITextField.ViewMode.always
        specTF.rightView = UIImageView(image: UIImage(named: "dropdown"))
        degreeTF.rightViewMode = UITextField.ViewMode.always
        degreeTF.rightView = UIImageView(image: UIImage(named: "dropdown"))
        
        viewModel.getTitles() {
            
            self.titleTF.array = self.viewModel.titles
            self.genderTF.array = self.viewModel.gender
            self.specTF.array = self.viewModel.speciality
            self.getprofile()
        }
        
        viewModel.getDegree() {
            self.degreeTF.array = self.viewModel.degree
            self.setUI()
        }
        
        self.defaulterLabel.text = ""
        
        setupLbl()
    }
    
    func setupLbl()  {
        
        // Atrribute
        let attributes = [[NSAttributedString.Key.foregroundColor:UIColor.red]]
        

        // Select title
        selectTitleLbl.text =  HeadingLblTxt.DocProfileOne.selectTitle.localize()
        
        // First Name
        firstNameLbl.attributedText = HeadingLblTxt.DocProfileOne.firstName.localize().highlightWordsIn(highlightedWords: "*", attributes: attributes)
        
        // Last Name
        lastNameLbl.attributedText = HeadingLblTxt.DocProfileOne.LastName.localize().highlightWordsIn(highlightedWords: "*", attributes: attributes)
        
        // Select gender
        selectGenderLbl.attributedText = HeadingLblTxt.DocProfileOne.gender.localize().highlightWordsIn(highlightedWords: "*", attributes: attributes)
        
        // Clinic Practice
        clinicPracticeLbl.attributedText = HeadingLblTxt.DocProfileOne.clinicPractice.localize().highlightWordsIn(highlightedWords: "*", attributes: attributes)
        
        
        // Select Specility
        selectSpecilityLbl.attributedText = HeadingLblTxt.DocProfileOne.specility.localize().highlightWordsIn(highlightedWords: "*", attributes: attributes)
        
        // Other Specility
        otherSpecilityLbl.text = HeadingLblTxt.DocProfileOne.otherSpecility.localize()
        
        
        // Select Registeration Number
        registerationLicenseNoLbl.attributedText = HeadingLblTxt.DocProfileOne.regLicenceNo.localize().highlightWordsIn(highlightedWords: "*", attributes: attributes)
        
        
        // Select Degrree
        selectDegreeLbl.attributedText = HeadingLblTxt.DocProfileOne.selectDegree.localize().highlightWordsIn(highlightedWords: "*", attributes: attributes)
        
        // Other Degree
        otherDegreeLbl.text = HeadingLblTxt.DocProfileOne.otherDegree.localize()
        
        
        // Select Email
        emailLbl.attributedText = HeadingLblTxt.DocProfileOne.Email.localize().highlightWordsIn(highlightedWords: "*", attributes: attributes)
        

    }
    
    override func viewWillAppear(_ animated: Bool) {
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
    func getprofile(){
        
        WebService.getDoctorProfile(queryItems: ["LoginKey": Authentication.token ?? "YXNob2ttaXR0YWxAZ21haWwuY29tOjEyMzQ1Ng=="]) { (result) in
            DispatchQueue.main.async {
                switch result {
                case .success(let response):
                    if let user = response.object {
                        self.doctor = user
                        self.setUI()
                    } else {
                    }
                case .failure(let error):
                    print(error.message)
                    self.showError(message: error.message)
                }
                self.view.activityStopAnimating()
            }
        }
    }
    
    func setUI() {
        titleTF.accessibilityLabel = "\(doctor?.TitleId ?? 0)"
        if let object = self.viewModel.titles.filter({ $0.Value == titleTF.accessibilityLabel }).first {
            titleTF.text = object.Text
        }
        fNameTF.text = doctor?.FirstName
        LNameTF.text = doctor?.LastName
        genderTF.accessibilityLabel = "\(doctor?.GenderId ?? 0)"
        if let object = self.viewModel.gender.filter({ $0.Value == genderTF.accessibilityLabel }).first {
            genderTF.text = object.Text
        }
        specTF.accessibilityLabel = "\(doctor?.SpecialityId ?? 0)"
        if let object = self.viewModel.speciality.filter({ $0.Value == specTF.accessibilityLabel }).first {
            specTF.text = object.Text
        }
        hospTF.text = doctor?.HospitalName
        oSpecTF.text = doctor?.Otherspeciality
        
        regNoTF.text = doctor?.RegNo
        
        degreeTF.accessibilityLabel = "\(doctor?.DegreeId ?? 0)"
        if let object = self.viewModel.degree.filter({ $0.Value == degreeTF.accessibilityLabel }).first {
            degreeTF.text = object.Text
        }
        oDegreeTF.text = doctor?.OtherDegreeName
        emailTF.text = doctor?.Email
        
        
    }
    
    @IBAction func didTapNext(_ sender: UIButton) {
        
        if isValid()
        {
            dict["AuthKey"] = Constants.authKey
            dict["CustomerTypeId"] = 1
            dict["TitleId"] = titleTF.accessibilityLabel
            dict["FirstName"] = fNameTF.text
            dict["LastName"] = LNameTF.text
            dict["GenderId"] = genderTF.accessibilityLabel
            dict["HospitalName"] = hospTF.text
            dict["SpecialityId"] = specTF.accessibilityLabel
            dict["Otherspeciality"] = oSpecTF.text
            dict["RegNo"] = regNoTF.text
            dict["DegreeId"] = degreeTF.accessibilityLabel
            dict["OtherDegreeName"] = oDegreeTF.text
            dict["Email"] = emailTF.text
            
            NavigationHandler.pushTo(.doctorProfileTwo(dict, doctor!))
            
        }
    }
    
    
    @IBAction func didTapBack(_ sender: UIButton) {
        
        if /Authentication.profileComplete {
            NavigationHandler.pop()
        }else{
            let alert = UIAlertController(title: "", message: ProfileUpdate.Alert
                                            .editMsg.localize(), preferredStyle: UIAlertController.Style.alert)
            
            let EditActionButton = UIAlertAction(title: AlertBtnTxt.cancel.localize(), style: .default) { _ in
            }
            EditActionButton.titleTextColor = UIColor.themeGreen
            alert.addAction(EditActionButton)
            
            
            let ContinueActionButton = UIAlertAction(title: "Okay", style: .default)
            { _ in
                NavigationHandler.pop()
            }
            ContinueActionButton.titleTextColor = UIColor.themeGreen
            alert.addAction(ContinueActionButton)
            
            self.present(alert, animated: true, completion: nil)
            
        }
    }
    
}

extension ProfileFormOne{
    func isValid() -> Bool {
        // first name
        if fNameTF.text?.isEmptyString() ?? false{
            fNameTF.becomeFirstResponder()
            AlertManager.showAlert(type: .custom(ProfileUpdate.firstName.localize()))
            return false
        }
        // Last name
        else if  LNameTF.text?.isEmptyString() ?? false {
            LNameTF.becomeFirstResponder()
            AlertManager.showAlert(type: .custom(ProfileUpdate.lastName.localize()))
            return false
        }
        // Gender
        else if (genderTF.accessibilityLabel == "0" || genderTF.accessibilityLabel == nil)  {
            AlertManager.showAlert(type: .custom(ProfileUpdate.gender.localize()))
            return false
        }
        // Clinic Practice Name
        else if  hospTF.text?.isEmptyString() ?? false{
            hospTF.becomeFirstResponder()
            AlertManager.showAlert(type: .custom(ProfileUpdate.clinicPractice.localize()))
            return false
        }
        // Speclitity
        else if specTF.accessibilityLabel == "0" || specTF.accessibilityLabel == nil {
            AlertManager.showAlert(type: .custom(ProfileUpdate.specility.localize()))
            return false
        }
        // other Specility
        else if specTF.text == "Others" && oSpecTF.text!.isEmpty {
            specTF.becomeFirstResponder()
            AlertManager.showAlert(type: .custom(ProfileUpdate.otherSpecility.localize()))
            return false
        }
        // Reg Number
        else if  regNoTF.text?.isEmptyString() ?? false{
            regNoTF.becomeFirstResponder()
            AlertManager.showAlert(type: .custom(ProfileUpdate.registeration.localize()))
            return false
        }
        // Degree
        else if (degreeTF.accessibilityLabel == "0"  || degreeTF.accessibilityLabel == nil)  {
            AlertManager.showAlert(type: .custom(ProfileUpdate.degree.localize()))
            return false
        }
        // other Degree
        else if degreeTF.text == "Others" && oDegreeTF.text!.isEmpty {
            AlertManager.showAlert(type: .custom(ProfileUpdate.otherDegree.localize()))
            return false
        }
        // Email
        else if emailTF.text?.isEmptyString() ?? false || !(emailTF.text?.isValidEmail() ?? false) {
            emailTF.becomeFirstResponder()
            AlertManager.showAlert(type: .custom(ProfileUpdate.Email.localize()))
            return false
        }
        return true
        
    }
}



extension String {
    
    func highlightWordsIn(highlightedWords: String, attributes: [[NSAttributedString.Key: Any]]) -> NSMutableAttributedString {
        let range = (self as NSString).range(of: highlightedWords)
        let result = NSMutableAttributedString(string: self)
        
        for attribute in attributes {
            result.addAttributes(attribute, range: range)
        }
        
        return result
    }
}
