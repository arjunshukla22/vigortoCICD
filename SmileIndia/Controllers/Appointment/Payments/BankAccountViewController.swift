//
//  BankAccountViewController.swift
//  SmileIndia
//
//  Created by Sakshi Gothi on 24/11/20.
//  Copyright © 2020 Na. All rights reserved.
//

import UIKit


class BankAccountViewController: UIViewController {
    
    var calendarData: CalendarData?
    var datasource1 = GenericDataSource()
    var datasource2 = GenericDataSource()
    
    @IBOutlet weak var noteLabel: UILabel!
    @IBOutlet weak var vgCreditsLbl: UILabel!
    @IBOutlet weak var banknameSV: UIStackView!
    @IBOutlet weak var dobSV: UIStackView!
    @IBOutlet weak var ssnSV: UIStackView!
    @IBOutlet weak var confirmBankSV: UIStackView!
    @IBOutlet weak var bankNameTF: UITextField!
    @IBOutlet weak var editBTN: UIButton!
    @IBOutlet weak var nameTextField: UITextField!
    @IBOutlet weak var ssnTF: UITextField!
    @IBOutlet weak var dobTF: CustomTextfield!
    @IBOutlet weak var RoutingNoTF: UITextField!
    @IBOutlet weak var AccountNoTF: UITextField!
    @IBOutlet weak var confirmAccountNumber: UITextField!
    var accountDetails = [AccountDetails]()
    var bankAccount = [AccountDetails]()
    var dob: AccountDetails?
    var id = 0
    // let datePicker = DatePickerDialog()
    var accountNumber = ""
    
    
    @IBOutlet weak var accHolderNameLbl: UILabel!
    @IBOutlet weak var bankNameLbl: UILabel!
    @IBOutlet weak var accNoLbl: UILabel!
    @IBOutlet weak var confirmAccNoLbl: UILabel!
    @IBOutlet weak var routingLbl: UILabel!
    @IBOutlet weak var SSNTaxEINNumberLbl: UILabel!
    @IBOutlet weak var DOBLbl: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setStatusBar(color: .themeGreen)
        dobTF.rightViewMode = UITextField.ViewMode.always
        dobTF.rightView = UIImageView(image: UIImage(named: "cal"))
        getAccountDetails()
        dobTF.delegate = self
        if id == 0{
            editBTN.setTitle(AlertBtnTxt.save.localize(), for: .normal)
            self.nameTextField.isUserInteractionEnabled = true
            self.AccountNoTF.isUserInteractionEnabled = true
            self.confirmAccountNumber.isUserInteractionEnabled = true
            self.ssnTF.isUserInteractionEnabled = true
            self.RoutingNoTF.isUserInteractionEnabled = true
            self.dobTF.isUserInteractionEnabled = true
            self.bankNameTF.isUserInteractionEnabled = false
            dobSV.isHidden = false
            confirmBankSV.isHidden = false
            ssnSV.isHidden = false
            banknameSV.isHidden = true
        }
        else{
            editBTN.setTitle(AlertBtnTxt.edit.localize(), for: .normal)
            self.nameTextField.isUserInteractionEnabled = false
            self.AccountNoTF.isUserInteractionEnabled = false
            // self.confirmAccountNumber.isUserInteractionEnabled = false
            //self.ssnTF.isUserInteractionEnabled = false
            self.RoutingNoTF.isUserInteractionEnabled = false
            // self.dobTF.isUserInteractionEnabled = false
            self.bankNameTF.isUserInteractionEnabled = false
            dobSV.isHidden = true
            confirmBankSV.isHidden = true
            ssnSV.isHidden = true
            banknameSV.isHidden = false
        }
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        getAccountDetails()
        setupLbl()
    }
    
    func setupLbl()  {
        
        // Atrribute
        let attributes = [[NSAttributedString.Key.foregroundColor:UIColor.red]]
        
        // accHolderNameLbl
        accHolderNameLbl.attributedText = HeadingLblTxt.BankAccount.accHolderName.localize().highlightWordsIn(highlightedWords: "*", attributes: attributes)
        
        // bankNameLbl
        bankNameLbl.attributedText = HeadingLblTxt.BankAccount.bankName.localize().highlightWordsIn(highlightedWords: "*", attributes: attributes)
        
        // accNoLbl
        accNoLbl.attributedText = HeadingLblTxt.BankAccount.accNo.localize().highlightWordsIn(highlightedWords: "*", attributes: attributes)
        
        // confirmAccNoLbl
        confirmAccNoLbl.attributedText = HeadingLblTxt.BankAccount.conAccNo.localize().highlightWordsIn(highlightedWords: "*", attributes: attributes)
        
        // routingLbl
        routingLbl.attributedText = HeadingLblTxt.BankAccount.routingNo.localize().highlightWordsIn(highlightedWords: "*", attributes: attributes)
        
        // SSNTaxEINNumberLbl
        SSNTaxEINNumberLbl.attributedText = HeadingLblTxt.BankAccount.SSNTAXEIN.localize().highlightWordsIn(highlightedWords: "*", attributes: attributes)
        
        // DOBLbl
        DOBLbl.attributedText = HeadingLblTxt.BankAccount.DOB.localize().highlightWordsIn(highlightedWords: "*", attributes: attributes)
        // noteLabel
        noteLabel.attributedText = HeadingLblTxt.BankAccount.note.localize().highlightWordsIn(highlightedWords: "*", attributes: attributes)
        
    }
    
    @IBAction func didTapBack(_ sender: Any) {
        NavigationHandler.pushTo(.homeViewController)
    }
    
    @IBAction func didTapSave(_ sender: UIButton) {
        
        
        if sender.titleLabel?.text == AlertBtnTxt.edit.localize(){
            sender.setTitle(AlertBtnTxt.save.localize(), for: .normal)
            self.nameTextField.isUserInteractionEnabled = true
            self.AccountNoTF.isUserInteractionEnabled = true
            self.confirmAccountNumber.isUserInteractionEnabled = true
            self.ssnTF.isUserInteractionEnabled = true
            self.RoutingNoTF.isUserInteractionEnabled = true
            self.dobTF.isUserInteractionEnabled = true
            self.bankNameTF.isUserInteractionEnabled = false
            self.confirmAccountNumber.text = ""
            self.AccountNoTF.text = accountNumber
            dobSV.isHidden = false
            confirmBankSV.isHidden = false
            ssnSV.isHidden = false
            banknameSV.isHidden = true
        }
        else{
            if isValidAccount(){
                /*   self.nameTextField.isUserInteractionEnabled = false
                 self.AccountNoTF.isUserInteractionEnabled = false
                 self.confirmAccountNumber.isUserInteractionEnabled = false
                 self.ssnTF.isUserInteractionEnabled = false
                 self.RoutingNoTF.isUserInteractionEnabled = false
                 self.dobTF.isUserInteractionEnabled = false
                 self.bankNameTF.isUserInteractionEnabled = false
                 dobSV.isHidden = true
                 confirmBankSV.isHidden = true
                 ssnSV.isHidden = true
                 banknameSV.isHidden = false */
                saveAccount()
                
            }
        }
        
        
    }
    
    @IBAction func didTapProfile(_ sender: Any) {
        NavigationHandler.pushTo(.doctorProfileOne)
    }
    
    @IBAction func didTapDOB(_ sender: Any) {
        
    }
    
    @IBAction func didTapCancel(_ sender: Any) {
        NavigationHandler.pushTo(.homeViewController)
        
    }
    
    
    func getAccountDetails() -> Void {
        let queryItems = ["CustomerId": Authentication.customerId ?? "0"]
        self.view.activityStartAnimating(activityColor: #colorLiteral(red: 0.233, green: 0.816, blue: 0.538, alpha: 1), backgroundColor: UIColor.white)
        
        WebService.getAccountDetails(queryItems: queryItems) { (result) in
            
            DispatchQueue.main.async {
                switch result {
                case .success (let response):
                    //                    print("response.ta")
                    //                    print(response.TotalAmount)
                    self.dobTF.text = response.DateOfBirth
                    //  self.vgCreditsLbl.text = String(response.TotalAmount ?? 0)
                    self.attributingWithColorForVC2(label: self.vgCreditsLbl, boldTxt: BankAccountScreentxt.totalVigortoEarnings.localize(), regTxt: "$ \(String(response.TotalAmount ?? 0))\(".00")", color: .themeGreen, fontSize: 16, firstFontWeight: .bold, secFontWeight: .bold)
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
                    AlertManager.showAlert(type: .custom(BankAccountScreentxt.verifyDocProfileResubMit.localize()), actionTitle: BankAccountScreentxt.profile.localize()) {
                        NavigationHandler.pushTo(.doctorProfileOne)
                    }
                }
                
            }
            if let name = self.bankAccount[0].Name{
                self.nameTextField.text = name
            }
            if let accNo = self.bankAccount[0].MaskedAccountNumber{
                self.AccountNoTF.text = accNo
            }
            if let caccNo = self.bankAccount[0].MaskedAccountNumber{
                self.confirmAccountNumber.text = caccNo
            }
            if let ifsc = self.bankAccount[0].IFSC{
                self.RoutingNoTF.text = ifsc
            }
            if let ssn = self.bankAccount[0].SSN{
                self.ssnTF.text = ssn
            }
            if let an = self.bankAccount[0].AccountNumber{
                accountNumber = an
            }
            if let bn = self.bankAccount[0].BankName{
                self.bankNameTF.text = bn
            }
            if let idnumber = self.bankAccount[0].Id{
                id = idnumber
            }
            if id == 0 {
                editBTN.setTitle(AlertBtnTxt.save.localize(), for: .normal)
                self.nameTextField.isUserInteractionEnabled = true
                self.AccountNoTF.isUserInteractionEnabled = true
                self.confirmAccountNumber.isUserInteractionEnabled = true
                self.ssnTF.isUserInteractionEnabled = true
                self.RoutingNoTF.isUserInteractionEnabled = true
                self.dobTF.isUserInteractionEnabled = true
                self.bankNameTF.isUserInteractionEnabled = false
                dobSV.isHidden = false
                confirmBankSV.isHidden = false
                ssnSV.isHidden = false
                banknameSV.isHidden = true
                
            }
            else{
                editBTN.setTitle(AlertBtnTxt.edit.localize(), for: .normal)
                self.nameTextField.isUserInteractionEnabled = false
                self.AccountNoTF.isUserInteractionEnabled = false
                self.confirmAccountNumber.isUserInteractionEnabled = false
                self.ssnTF.isUserInteractionEnabled = false
                self.RoutingNoTF.isUserInteractionEnabled = false
                self.dobTF.isUserInteractionEnabled = false
                self.bankNameTF.isUserInteractionEnabled = false
                self.dobSV.isHidden = true
                self.confirmBankSV.isHidden = true
                self.ssnSV.isHidden = true
                banknameSV.isHidden = false
            }
            
        }
    }
    func datePickerTapped() {
        let currentDate = Date()
        var dateComponents = DateComponents()
        dateComponents.year = -18
        var maxdatecomponent = DateComponents()
        maxdatecomponent.year = -120
        let maxDate = Calendar.current.date(byAdding: dateComponents, to: currentDate)
        let minDate = Calendar.current.date(byAdding: maxdatecomponent, to: currentDate)
        //        datePicker.show("Date of Birth",
        //                        doneButtonTitle: "Done",
        //                        cancelButtonTitle: AlertBtnTxt.cancel.localize(),
        //                       minimumDate: years120Ago,
        //                        maximumDate: years18Ago,
        //                        datePickerMode: .date) { (date) in
        //            if let dt = date {
        //                let formatter = DateFormatter()
        //                formatter.dateFormat = "MM/dd/yyyy"
        //                self.dobTF.text = formatter.string(from: dt)
        //            }
        //        }
        //
        
        let selectedDate = Date()
        
        RPicker.selectDate(title: BankAccountScreentxt.selectDate.localize(), selectedDate: selectedDate, minDate: minDate, maxDate: maxDate) { [weak self] (selectedDate) in
            // TODO: Your implementation for date
            //            self?.outputLabel.text = selectedDate.dateString("MMM-dd-YYYY")
            //
            let formatter = DateFormatter()
            formatter.dateFormat = "MM/dd/yyyy"
            self?.dobTF.text = formatter.string(from: selectedDate)
            
        }
    }
    
    func isValidAccount() -> Bool {
        if nameTextField.text!.isEmpty {
            AlertManager.showAlert(type: .custom(BankAccountScreentxt.nameRequired.localize()))
            return false
        }else if nameTextField.text!.count < 2{
            AlertManager.showAlert(type: .custom(BankAccountScreentxt.nameLessThanTwoCharcters.localize()))
            return false
        } else if  AccountNoTF.text!.isEmpty {
            AlertManager.showAlert(type: .custom(BankAccountScreentxt.acoountNumberRequired.localize()))
            return false
        }else if  !(AccountNoTF.text!.isValidAccountNum()){
            AlertManager.showAlert(type: .custom(BankAccountScreentxt.validAccNumber.localize()))
            return false
        }else if  RoutingNoTF.text!.isEmpty {
            AlertManager.showAlert(type: .custom(BankAccountScreentxt.RoutingNumberRequired.localize()))
            return false
        }
        else if ssnTF.text!.isEmpty {
            AlertManager.showAlert(type: .custom(BankAccountScreentxt.SSDNTAXIDEIN.localize()))
            return false
        }
        else if dobTF.text!.isEmpty{
            AlertManager.showAlert(type: .custom(BankAccountScreentxt.dobRequired.localize()))
            return false
        }
        else if  AccountNoTF.text != confirmAccountNumber.text{
            AlertManager.showAlert(type: .custom(BankAccountScreentxt.accNOdidNtMatch.localize()))
            return false
        }
        return true
    }
    
    
    
    func saveAccount() -> Void {
        
        let queryItems = ["Name": self.nameTextField.text!, "AccountNumber": self.AccountNoTF.text!,"IFSC": self.RoutingNoTF.text!, "Id": "\(id)", "CustomerId": "\(Authentication.customerId!)","SSN": self.ssnTF.text!,"Dob": self.dobTF.text!]
        
        self.view.activityStartAnimating(activityColor:
                                            #colorLiteral(red: 0.233, green: 0.816, blue: 0.538, alpha: 1), backgroundColor: UIColor.white)
        WebService.saveBankAccount(queryItems: queryItems) { (result) in
            DispatchQueue.main.async {
                switch result {
                case .success(let response):
                    self.editBTN.setTitle(AlertBtnTxt.edit.localize(), for: .normal)
                    
                    AlertManager.showAlert(type: .custom(response.message ?? "")){
                        
                        NavigationHandler.pushTo(.homeViewController)
                    }
                case .failure(let error):
                    print(error.message)
                    
                    AlertManager.showAlert(type: .custom(error.message ?? "")){
                        //  NavigationHandler.pushTo(.homeViewController)
                    }
                /*  self.nameTextField.isUserInteractionEnabled = true
                 self.AccountNoTF.isUserInteractionEnabled = true
                 self.confirmAccountNumber.isUserInteractionEnabled = true
                 self.ssnTF.isUserInteractionEnabled = true
                 self.RoutingNoTF.isUserInteractionEnabled = true
                 self.dobTF.isUserInteractionEnabled = true
                 self.dobSV.isHidden = true
                 self.confirmBankSV.isHidden = true
                 self.ssnSV.isHidden = true*/
                }
                self.view.activityStopAnimating()
            }
        }
    }
    
}
extension BankAccountViewController: UITextFieldDelegate {
    
    func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
        if textField == self.dobTF {
            datePickerTapped()
            return false
        }
        
        return true
    }
}




