//
//  newDoctorSignUpVC.swift
//  SmileIndia
//
//  Created by Sakshi Gothi on 11/06/21.
//  Copyright © 2021 Na. All rights reserved.
//


import UIKit
import ActiveLabel
import Localize

class newDoctorSignUpVC: BaseViewController , UITextFieldDelegate{
    
    
    @IBOutlet weak var lblNav: UILabel!
    @IBOutlet var agreeHippaBtn: UIButton!
    @IBOutlet weak var agreeBtn: UIButton!
    @IBOutlet weak var titleStack: UIStackView!
    @IBOutlet weak var fNameStack: UIStackView!
    @IBOutlet weak var lnameStack: UIStackView!
    @IBOutlet weak var dStack: UIStackView!
    @IBOutlet weak var odStack: UIStackView!
    @IBOutlet weak var countryCodeLabel: UILabel!
    @IBOutlet weak var flagImageView: UIImageView!
    @IBOutlet weak var countryCodeView: UIView!
    @IBOutlet weak var doctorButton: UIButton!
    @IBOutlet weak var hospitalButton: UIButton!
    @IBOutlet weak var titleTextField: CustomTextfield!
    @IBOutlet weak var firstNameTextField: UITextField!
    @IBOutlet weak var lastNameTextField: UITextField!
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var osTextfiled: UITextField!
    @IBOutlet weak var phoneTextField: UITextField!
    
    @IBOutlet weak var referralCodeTF: UITextField!
    
    @IBOutlet weak var tcprivacypolicyLbl: ActiveLabel!
    @IBOutlet weak var hipaaAuthorisationLbl: ActiveLabel!
    
    
    // Heading Label
    @IBOutlet weak var selectTitleLbl: UILabel!
    @IBOutlet weak var firstNameLbl: UILabel!
    @IBOutlet weak var lastNameLbl: UILabel!
    @IBOutlet weak var emailLbl: UILabel!
    
    @IBOutlet weak var phoneNumberLbl: UILabel!
    @IBOutlet weak var referralCodeLbl: UILabel!
 
    
    var countryCodeName = "US"
    var dict = [String: Any]()
    var customerType = "1"
    let viewmodel = SignupViewModel()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setStatusBar(color: .themeGreen)
        hideKeyboardWhenTappedAround()
        setUpCheckBox()
        self.view.activityStartAnimating(activityColor: .themeGreen, backgroundColor: UIColor.white)
        
        
        
        
        titleTextField.text = "None"
        titleTextField.rightViewMode = UITextField.ViewMode.always
        titleTextField.rightView = UIImageView(image: UIImage(named: "dropdown"))
        
        
        viewmodel.hitApis{
            self.titleTextField.array = self.viewmodel.titles
            
            self.view.activityStopAnimating()
        }
        activityIndicator.hideLoader()
        
        tcprivacypolicyLbl.text = ProfileUpdate.TcPrivacypolicy.localize()
        hipaaAuthorisationLbl.text = ProfileUpdate.hipaaAuthorization.localize()
        
        setupTcPrivacyLbl()
        setupTermsConditionlbl()
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
        
        // Phone Number
        phoneNumberLbl.attributedText = HeadingLblTxt.DocProfileOne.phnNumber.localize().highlightWordsIn(highlightedWords: "*", attributes: attributes)
        
        // Referral Code
        referralCodeLbl.attributedText = HeadingLblTxt.DocProfileOne.referralCode.localize().highlightWordsIn(highlightedWords: "*", attributes: attributes)
        
        // Select Email
        emailLbl.attributedText = HeadingLblTxt.DocProfileOne.Email.localize().highlightWordsIn(highlightedWords: "*", attributes: attributes)
        
        
    }
    
    func setupTcPrivacyLbl()  {
        let customType1 = ActiveType.custom(pattern: ProfileUpdate.termsCondition.localize())
        let customType2 = ActiveType.custom(pattern: ProfileUpdate.PrivacyPolicy.localize())
        tcprivacypolicyLbl.enabledTypes = [customType1, customType2]
        tcprivacypolicyLbl.customize { label in
            //            label.configureLinkAttribute = { (type, attributes, isSelected) in
            //                var atts = attributes
            //                atts[NSAttributedString.Key.underlineStyle] = NSUnderlineStyle.single.rawValue
            //                return atts
            //            }
            //            label.highlightFontName = UIFont.Style.bold.name
            label.highlightFontSize = UIFont.Size.h6.floatValue
            label.customColor[customType1] = UIColor.themeGreen
            label.customSelectedColor[customType1] = UIColor.themeGreen
            
            label.customColor[customType2] = UIColor.themeGreen
            label.customSelectedColor[customType2] = UIColor.themeGreen
            
            label.handleCustomTap(for: customType1, handler: { element in
                let termsVc = TermsVC.init(nibName: "TermsVC", bundle: nil)
                termsVc.modalPresentationStyle = .fullScreen
                termsVc.screentitle = "Terms & Conditions"
                termsVc.requestURLString = "https://www.vigorto.com/terms-and-conditions.pdf"
                self.present(termsVc, animated: true, completion: nil)
            })
            label.handleCustomTap(for: customType2, handler: { element in
                let termsVc = TermsVC.init(nibName: "TermsVC", bundle: nil)
                termsVc.modalPresentationStyle = .fullScreen
                termsVc.screentitle = "Privacy Policy"
                termsVc.requestURLString = "https://www.vigorto.com/security-and-privacy.pdf"
                self.present(termsVc, animated: true, completion: nil)
            })
        }
    }
    
    func setupTermsConditionlbl()  {
        let customType1 = ActiveType.custom(pattern: ProfileUpdate.HipaaTxt.localize())
        hipaaAuthorisationLbl.enabledTypes = [customType1]
        hipaaAuthorisationLbl.customize { label in
            //            label.configureLinkAttribute = { (type, attributes, isSelected) in
            //                var atts = attributes
            //                atts[NSAttributedString.Key.underlineStyle] = NSUnderlineStyle.single.rawValue
            //                return atts
            //            }
            //            label.highlightFontName = UIFont.Style.bold.name
            label.highlightFontSize = UIFont.Size.h6.floatValue
            label.customColor[customType1] = UIColor.themeGreen
            label.customSelectedColor[customType1] = UIColor.themeGreen
            
            label.handleCustomTap(for: customType1, handler: { element in
                let termsVc = TermsVC.init(nibName: "TermsVC", bundle: nil)
                termsVc.modalPresentationStyle = .fullScreen
                termsVc.screentitle = "HIPAA authorization"
                termsVc.requestURLString = "https://vigorto.com/vigorto-hipaa-authorization.pdf"
                self.present(termsVc, animated: true, completion: nil)
            })
            
        }
    }
    
    
    func setUpCheckBox() -> Void {
        
        agreeBtn.layer.cornerRadius = 5
        agreeBtn.layer.borderWidth = 2
        agreeBtn.layer.borderColor = UIColor.darkGray.cgColor
        
        agreeHippaBtn.layer.cornerRadius = 5
        agreeHippaBtn.layer.borderWidth = 2
        agreeHippaBtn.layer.borderColor = UIColor.darkGray.cgColor
        
    }
    func registerUser(_ query: [String: Any])   {
        self.view.endEditing(true)
        self.view.activityStartAnimating(activityColor: .themeGreen, backgroundColor: UIColor.white)
        WebService.registerDoctor(queryItems: query) { (result) in
            DispatchQueue.main.async {
                switch result {
                case .success(let response):
                    if let user = response.object {
                        
                        Authentication.customerEmail = self.emailTextField.text
                        Authentication.customerGuid = user.token
                        
                        NavigationHandler.pushTo(.subscriptionPlans)
                        
                    }
                    else {
                        self.showError(message: response.message ?? "")  }
                case .failure(let error):
                    AlertManager.showAlert(type: .custom(error.message))
                // Invalid JSON primitive: ------WebKitFormBoundary7MA4YWxkTrZu0gW.
                }
                self.view.activityStopAnimating()
            }
        }
    }
    
    @objc func countrycodeList(){
        print("Country code list")
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
    
    @IBAction func didTapNextButton(_ sender: Any) {
        
        // referralCodeTF.text  = "460699"
        
        if isValid() {
            dict["AuthKey"] = Constants.authKey
            dict["FirstName"] = firstNameTextField.text
            dict["LastName"] = lastNameTextField.text
            dict["Email"] = emailTextField.text
            dict["Phone"] = phoneTextField.text
            dict["CountryCode"] = self.countryCodeLabel.text
            dict["CountryNameCode"] = self.countryCodeName
            dict["Password"] = 123456
            dict["CustomerTypeId"] = 6
            dict["Mrcode"] = referralCodeTF.text
            if titleTextField.text == "None"{
                dict["TitleId"] = 0
            }
            else{
                dict["TitleId"] = titleTextField.accessibilityLabel?.toInt()
            }
            registerUser(dict)
        }
    }
    @IBAction func didTapBackButton(_ sender: Any){
        NavigationHandler.pop()
    }
    
    @IBAction func didTapAgreeHippa(_ sender: Any) {
        if agreeHippaBtn.hasImage(named: "tick.png", for: .normal) {
            agreeHippaBtn.setImage(nil, for: .normal)
        } else {
            agreeHippaBtn.setImage(UIImage(named: "tick.png"), for: .normal)
        }
    }
    
    @IBAction func didTapAgree(_ sender: UIButton) {
        if agreeBtn.hasImage(named: "tick.png", for: .normal) {
            agreeBtn.setImage(nil, for: .normal)
        } else {
            agreeBtn.setImage(UIImage(named: "tick.png"), for: .normal)
        }
        
    }
    
    @IBAction func didTapPrivacy(_ sender: UIButton) {
        let termsVc = TermsVC.init(nibName: "TermsVC", bundle: nil)
        termsVc.modalPresentationStyle = .fullScreen
        termsVc.screentitle = "Privacy Policy"
        termsVc.requestURLString = "https://www.vigorto.com/security-and-privacy.pdf"
        self.present(termsVc, animated: true, completion: nil)
    }
    
    @IBAction func didTapTerms(_ sender: UIButton) {
        let termsVc = TermsVC.init(nibName: "TermsVC", bundle: nil)
        termsVc.modalPresentationStyle = .fullScreen
        termsVc.screentitle = "Terms & Conditions"
        termsVc.requestURLString = "https://www.vigorto.com/terms-and-conditions.pdf"
        self.present(termsVc, animated: true, completion: nil)
    }
    
    
    @IBAction func didtapHippa(_ sender: Any) {
        let termsVc = TermsVC.init(nibName: "TermsVC", bundle: nil)
        termsVc.modalPresentationStyle = .fullScreen
        termsVc.screentitle = "HIPAA authorization"
        termsVc.requestURLString = "https://vigorto.com/vigorto-hipaa-authorization.pdf"
        self.present(termsVc, animated: true, completion: nil)
    }
    
    
    @IBAction func didTapRadioButtons(_ sender: UIButton) {
        //   constraintViewHeight.constant = sender.tag == 1 ? 780 : 400
        titleStack.isHidden = sender.tag == 2
        fNameStack.isHidden = sender.tag == 2
        lnameStack.isHidden = sender.tag == 2
        
        dStack.isHidden = sender.tag == 2
        odStack.isHidden = sender.tag == 2
        
        
        hospitalButton.setImage(UIImage.init(named: sender.tag == 1 ? "radio" : "radioSelected"), for: .normal)
        doctorButton.setImage(UIImage.init(named: sender.tag == 1 ?  "radioSelected" : "radio"), for: .normal)
        customerType = sender.tag == 1 ? "1" : "4"
        
    }
    
    
}
extension newDoctorSignUpVC{
    func isValid() -> Bool {
        if firstNameTextField.text?.isEmptyString() ?? false && customerType == "1" {
            firstNameTextField.becomeFirstResponder()
            AlertManager.showAlert(type: .custom(ProfileUpdate.firstName.localize()))
            
            return false
        } else if  lastNameTextField.text?.isEmptyString() ?? false && customerType == "1" {
            lastNameTextField.becomeFirstResponder()
            AlertManager.showAlert(type: .custom(ProfileUpdate.lastName.localize()))
            return false
        }  else if emailTextField.text?.isEmptyString() ?? false || !(emailTextField.text?.isValidEmail() ?? false) {
            emailTextField.becomeFirstResponder()
            AlertManager.showAlert(type: .custom(ProfileUpdate.Email.localize()))
            return false
        }
        
        else if phoneTextField.text?.isEmptyString() ?? false {
            phoneTextField.becomeFirstResponder()
            AlertManager.showAlert(type: .custom(ProfileUpdate.mobilenumber.localize()))
            return false
            
        }
        else if phoneTextField.text!.isEmpty || !phoneTextField.text!.prefix(1).allSatisfy(("1"..."9").contains) {
            phoneTextField.becomeFirstResponder()
            AlertManager.showAlert(type: .custom(ProfileUpdate.mobilenumber.localize()))
            return false
        }
        else if phoneTextField.text!.count < 10 {
            phoneTextField.becomeFirstResponder()
            AlertManager.showAlert(type: .custom(ProfileUpdate.mobilenumber.localize()))
            return false
            
        }
        else if referralCodeTF.text!.count < 5 && referralCodeTF.text!.count > 0{
            referralCodeTF.becomeFirstResponder()
            AlertManager.showAlert(type: .custom(ProfileUpdate.referralCode.localize()))
            return false
        }
        else if !agreeBtn.hasImage(named: "tick.png", for: .normal) {
            AlertManager.showAlert(type: .custom(ProfileUpdate.aceeptTermsConditions.localize()))
            return false
        }
        else if !agreeHippaBtn.hasImage(named: "tick.png", for: .normal) {
            AlertManager.showAlert(type: .custom(ProfileUpdate.acceptHIPAA.localize()))
            return false
        }
        return true
        
    }
    
    func isExists() -> Void {
        
        let queryItems = ["Email":emailTextField.text!] as [String : Any]
        
        self.view.activityStartAnimating(activityColor: .themeGreen, backgroundColor: UIColor.white)
        WebService.isExists(queryItems: queryItems) { (result) in
            
            DispatchQueue.main.async {
                switch result {
                case .success(let response):print(response)
                    NavigationHandler.pushTo(.personalDetail(self.dict, self.customerType))
                case .failure(let error):
                    AlertManager.showAlert(type: .custom(error.message))
                }
                self.view.activityStopAnimating()
            }
        }
    }
    
}


