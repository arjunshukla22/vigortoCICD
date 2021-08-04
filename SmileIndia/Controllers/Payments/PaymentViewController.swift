//
//  PaymentViewController.swift
//  SmileIndia
//
//  Created by Arjun  on 16/04/20.
//  Copyright © 2020 Na. All rights reserved.
//

import UIKit

class PaymentViewController: UIViewController {
    
    var img :UIImage?
    lazy var picker: CustomImagePicker = {
        let imagePicker = CustomImagePicker()
        imagePicker.handler = {
            let size = CGSize(width: 350, height: 100)
            let croppedImage = $0.crop(to: size)
            self.img = croppedImage
            self.signatureImgview.image = croppedImage
            
        }
        return imagePicker
    }()
    
    var fileName = ""
    var signature : Signature?
    var bankAccount = [AccountDetails]()
    var upiAccount = [AccountDetails]()

    @IBOutlet weak var earningsLabel: UILabel!
    
    @IBOutlet weak var upiSwitch: UISwitch!
    @IBOutlet weak var accountSwitch: UISwitch!
    
    @IBOutlet weak var segment: UISegmentedControl!
    
    @IBOutlet weak var accountView: UIView!
    @IBOutlet weak var upiView: UIView!
    
    @IBOutlet weak var nameAccountTf: UITextField!
    @IBOutlet weak var bankAccountTf: UITextField!
    @IBOutlet weak var accnoTf: UITextField!
    @IBOutlet weak var confirmAccnoTf: UITextField!
    @IBOutlet weak var ifscTf: UITextField!
    
    
    @IBOutlet weak var nameUpiTf: UITextField!
    @IBOutlet weak var upiTf: UITextField!
    @IBOutlet weak var confirmUpiTf: UITextField!
    
    @IBOutlet weak var signatureView: UIView!
    @IBOutlet weak var signatureImgview: UIImageView!
    
    @IBOutlet weak var defaulterLabel: UILabel!
    
    var accountDetails = [AccountDetails]()
    
    let bankArray = ["Select Your Banks","Andhra Bank","Axis Bank","Bank of America","Bank of India","Bank of Baroda","Canara Bank","Citi Bank","Corporation Bank","HDFC Bank","HSBC Bank","ICICI Bank","IDBI Bank","IndusInd Bank","Indian Overseas Bank","Kotak Mahindra Bank","Punjab National Bank","RBL","State Bank of India","Standard Chartered Bank","Syndicate Bank","Union Bank of India","Yes Bank"]

    let bankPicker = UIPickerView()
    var selectedBank = 0
    
    var accId = 0
    var upiId = 0

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        setStatusBar(color: .themeGreen)
        hideKeyboardWhenTappedAround()
        
        bankAccountTf.rightViewMode = UITextField.ViewMode.always
        bankAccountTf.rightView = UIImageView(image: UIImage(named: "dropdown"))
        
        let titleTextAttributes = [NSAttributedString.Key.foregroundColor: UIColor.white]
        segment.setTitleTextAttributes(titleTextAttributes, for: .selected)
        
        self.segment.addTarget(self, action: #selector(segmentSelected(sender:)), for: .valueChanged)
        upiView.isHidden = true
        accountView.isHidden = false
        signatureView.isHidden = true
        
        bankPicker.delegate = self
        bankAccountTf.inputView = bankPicker
        self.bankAccountTf.delegate = self
        self.dismissPickerView()
        
        accountSwitch.transform = CGAffineTransform(scaleX: 0.90, y: 0.90)
        upiSwitch.transform = CGAffineTransform(scaleX: 0.90, y: 0.90)

        getAccountDetails()
        
        ifscTf.delegate = self
        
        self.defaulterLabel.text = ""

        getSignature()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        if Authentication.customerType == "Doctor" {
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
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        ifscTf.text = (ifscTf.text! as NSString).replacingCharacters(in: range, with: string.uppercased())

        return false
    }
    
    @objc func segmentSelected(sender: UISegmentedControl)
    {
        switch(sender.selectedSegmentIndex){
        case 0:
            upiView.isHidden = true
            accountView.isHidden = false
            signatureView.isHidden = true

        case 1:
            upiView.isHidden = false
            accountView.isHidden = true
            signatureView.isHidden = true

        case 2:
            upiView.isHidden = true
            accountView.isHidden = true
            signatureView.isHidden = false

        default:
            break
        }
    }
    
    
    func getAccountDetails() -> Void {
        let queryItems = ["CustomerId": Authentication.customerId ?? "0"]
        self.view.activityStartAnimating(activityColor: #colorLiteral(red: 0.233, green: 0.816, blue: 0.538, alpha: 1), backgroundColor: UIColor.white)
        WebService.getAccountDetails(queryItems: queryItems) { (result) in
         DispatchQueue.main.async {
                switch result {
                case .success (let response):
                        for account in response.objects! {
                            self.accountDetails.append(account)
                            
                        }
                        
                       
                        self.setupUI()
                        
                case .failure(let error):
                    print(error)
                  //  AlertManager.showAlert(type: .custom(error.message))
                }
            self.view.activityStopAnimating()
            }
        }
    }
    
    func setupUI() -> Void {
        
        for account in self.accountDetails {
            if account.AccountType == "Bank Account"{
                bankAccount.append(account)
            }else{
                upiAccount.append(account)
            }
        }
        
        
        print(self.accountDetails,self.bankAccount.count,self.upiAccount.count)
        
            if self.bankAccount.count > 0 {
                
                if let name = self.bankAccount[0].Name{
                self.nameAccountTf.text = name
                }
                if let bank = self.bankAccount[0].BankName{
                self.bankAccountTf.text = bank
                }
                if let accNo = self.bankAccount[0].AccountNumber{
                self.accnoTf.text = accNo
                }
                if let ifsc = self.bankAccount[0].IFSC{
                self.ifscTf.text = ifsc
                }
                
                if let Id = self.bankAccount[0].Id{
                    self.accId = Id
                }
                
                if self.bankAccount[0].IsDefault == false{
                    self.accountSwitch.setOn(false, animated: true)
                }else
                {
                    self.accountSwitch.setOn(true, animated: true)
                }
            }

            if self.upiAccount.count > 0 {
                if let name = self.upiAccount[0].Name{
                self.nameUpiTf.text = name
                }
                if let upi = self.upiAccount[0].VPA{
                self.upiTf.text = upi
                }
                if let Id = self.upiAccount[0].Id{
                    self.upiId = Id
                }
                
                if self.upiAccount[0].IsDefault == false{
                    self.upiSwitch.setOn(false, animated: true)
                }else
                {
                    self.upiSwitch.setOn(true, animated: true)
                }
            }
            
    }
    
    @IBAction func didtapBack(_ sender: Any) {
        NavigationHandler.pop()
    }
    
    @IBAction func didtapSaveAccount(_ sender: Any) {
       if isValidAccount(){
            saveAccount()
        }
    }
    
    @IBAction func didtapCancelAccount(_ sender: Any) {
        NavigationHandler.pop()
    }
    
    @IBAction func didtapSaveUPI(_ sender: Any) {
       if isValidUPI(){
            saveUPI()
        }
    }
    
    @IBAction func didtapCancelUPI(_ sender: Any) {
        NavigationHandler.pop()
    }
    
    
    @IBAction func btnSelectImage(_ sender: Any) {
        picker.showOptions()
    }
    @IBAction func didtapUploadSignature(_ sender: Any) {
        
        if self.img != nil{
            uploadSignature()
        }else {
            AlertManager.showAlert(type: .custom("Please select signature first!"))
        }
    }
    
    func saveAccount() -> Void {
        
        let queryItems = ["Name": self.nameAccountTf.text!, "BankName": self.bankAccountTf.text!, "AccountNumber": self.accnoTf.text!,"IFSC": self.ifscTf.text!, "Id": "\(accId)", "CustomerId": "\(Authentication.customerId!)", "IsDefault": "\(accountSwitch.isOn)"]
        
            self.view.activityStartAnimating(activityColor:
                #colorLiteral(red: 0.233, green: 0.816, blue: 0.538, alpha: 1), backgroundColor: UIColor.white)
        WebService.saveBankAccount(queryItems: queryItems) { (result) in
                DispatchQueue.main.async {
                    switch result {
                    case .success(let response):
                        AlertManager.showAlert(type: .custom(response.message ?? "")){
                            NotificationCenter.default.post(name: Notification.Name("accountdetails"), object: self.index)
                            NavigationHandler.pop()
                        }
                    case .failure(let error):
                        print(error.message)
                        AlertManager.showAlert(type: .custom("Please enter valid bank details."))
                    }
                    self.view.activityStopAnimating()
                }
             }
    }
    
    func saveUPI() -> Void {
        
        let queryItems = ["Name": self.nameUpiTf.text!, "VPA": self.upiTf.text!, "Id": "\(upiId)", "CustomerId": "\(Authentication.customerId!)", "IsDefault": "\(upiSwitch.isOn)"]
        
        self.view.activityStartAnimating(activityColor: #colorLiteral(red: 0.233, green: 0.816, blue: 0.538, alpha: 1), backgroundColor: UIColor.white)
        WebService.saveUPI(queryItems: queryItems) { (result) in
                DispatchQueue.main.async {
                    switch result {
                    case .success(let response):
                        AlertManager.showAlert(type: .custom(response.message ?? "")){
                            NotificationCenter.default.post(name: Notification.Name("accountdetails"), object: self.index)
                            NavigationHandler.pop()
                        }
                    case .failure(let error):
                        print(error.message)
                        AlertManager.showAlert(type: .custom("Please enter valid UPI details."))
                    }
                    self.view.activityStopAnimating()
                }
             }
    }
    
    
    
        func isValidAccount() -> Bool {
            if nameAccountTf.text!.isEmpty {
                AlertManager.showAlert(type: .custom("Name Is Required."))
                return false
            }else if nameAccountTf.text!.count < 2{
                AlertManager.showAlert(type: .custom("Name should not less than two characters"))
                return false
            } else if  bankAccountTf.text!.isEmpty || bankAccountTf.text! == "Select Your Banks"{
                AlertManager.showAlert(type: .custom("Bank Name Is Required."))
                return false
            }else if  accnoTf.text!.isEmpty {
                AlertManager.showAlert(type: .custom("Account Number Is Required."))
                return false
            }else if  !(accnoTf.text!.isValidAccountNum()){
                AlertManager.showAlert(type: .custom("Please enter valid Account Number."))
                return false
            }else if  ifscTf.text!.isEmpty {
                AlertManager.showAlert(type: .custom("IFSC Is Required."))
                return false
            }else if  !(ifscTf.text!.isValidIfsc()){
                AlertManager.showAlert(type: .custom("Please enter valid IFSC."))
                return false
            }else if  accnoTf.text != confirmAccnoTf.text{
                AlertManager.showAlert(type: .custom("Account Number Didn't Match."))
                return false
            }
            return true
        }
    
        func isValidUPI() -> Bool {

            if nameUpiTf.text!.isEmpty {
                AlertManager.showAlert(type: .custom("Name Is Required."))
                return false
            } else if nameUpiTf.text!.count < 2{
                AlertManager.showAlert(type: .custom("Name should not less than two characters"))
                return false
            } else if  upiTf.text!.isEmpty{
                AlertManager.showAlert(type: .custom("UPI Is Required."))
                return false
            }else if  !(upiTf.text?.isValidUpi())!{
                AlertManager.showAlert(type: .custom("Please enter valid UPI."))
                return false
            }else if  upiTf.text != confirmUpiTf.text{
                AlertManager.showAlert(type: .custom("UPI Didn't Match."))
                return false
            }

            return true
        }
    
    
    func uploadSignature()  {
        let queryItems = ["CustomerGuid": "\(Authentication.customerGuid ?? "")","image": self.signatureImgview.image?.jpegData(compressionQuality: 0.5) ?? UIImage()] as [String : Any]

        self.view.activityStartAnimating(activityColor: #colorLiteral(red: 0.233, green: 0.816, blue: 0.538, alpha: 1), backgroundColor: UIColor.white)
        WebService.uploadSignature(queryItems: queryItems) { (result) in
            DispatchQueue.main.async {
                switch result {
                case .success:
                    AlertManager.showAlert(type: .custom( "Signature uploaded successfully!"), title: AlertBtnTxt.okay.localize(), action: {
                        self.img = nil
                        NavigationHandler.pop()
                    })
                case .failure(let error):
                    AlertManager.showAlert(type: .custom(error.message))
                }
                self.view.activityStopAnimating()
            }
        }
    }
    
    func getSignature() -> Void {

        let queryItems = ["CustomerGuid": Authentication.customerGuid ?? ""]
        self.view.activityStartAnimating(activityColor: #colorLiteral(red: 0.233, green: 0.816, blue: 0.538, alpha: 1), backgroundColor: UIColor.white)
        WebService.getSignature(queryItems: queryItems) { (result) in
         DispatchQueue.main.async {
                switch result {
                case .success (let response):
                    self.signature = response.object
                    self.signatureImgview.sd_setImage(with: URL(string:"\(self.signature?.FilePath ?? "")")! , placeholderImage: nil)
                    self.fileName = self.signature?.FileName ?? ""
                case .failure(let error):
                    AlertManager.showAlert(on: self, type: .custom(error.message))
              }
            self.view.activityStopAnimating()
            }
        }
    }
    
    
    
    
} // class end


extension PaymentViewController: UIPickerViewDelegate, UIPickerViewDataSource, UITextFieldDelegate
{
func numberOfComponents(in pickerView: UIPickerView) -> Int {
    return 1
}

func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
    return bankArray.count
}

func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
return bankArray[row]
}

func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
    selectedBank = row
print(bankArray[row])
}
    
    func dismissPickerView() {
        let toolBar = UIToolbar()
        toolBar.sizeToFit()
        
        let button = UIBarButtonItem(title: "Done", style: .done, target: self, action: #selector(self.action))
        button.tintColor = .lightGray
        toolBar.setItems([button], animated: true)
        toolBar.isUserInteractionEnabled = true
        
        bankAccountTf.inputAccessoryView = toolBar
    }
    
    @objc func action() {
        if bankAccountTf.isEditing == true {
            bankAccountTf.text = self.bankArray[selectedBank]
        }
       view.endEditing(true)
    }

}


/*    let cgimage = signatureImgview.image?.cgImage
    //Get image width, height in pixel
    let pixelsWide = cgimage!.width
    let pixelsHigh = cgimage!.height
    print(pixelsWide,pixelsHigh)   */
