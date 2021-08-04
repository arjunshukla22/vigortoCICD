//
//  FindDoctorController.swift
//  SmileIndia
//
//  Created by Na on 12/02/19.
//  Copyright © 2019 Na. All rights reserved.
//


import UIKit
import DropDown

class FindDoctorController: UIViewController {
    
    
    @IBOutlet weak var searchVw: UIView!
    
    @IBOutlet weak var resultLabel: UILabel!
    
    @IBOutlet weak var backBtn: UIButton!
    @IBOutlet weak var specialityTextfield: CustomTextfield!
    // @IBOutlet weak var pincodeTextfield: UITextField!
    //  @IBOutlet weak var cityTextfield: CustomTextfield!
    @IBOutlet weak var nameTextfield: UITextField!
    @IBOutlet weak var doctorTableView: UITableView!
    @IBOutlet weak var noRecordLabel: UILabel!
    //  @IBOutlet weak var menuButton: UIButton!
    @IBOutlet weak var insuranceTF: UITextField!
    
    
    @IBOutlet weak var clearSearchBtn: UIButton!
    @IBOutlet weak var defaulterLabel: UILabel!
    
    var noResult : Bool = false {
        didSet{
            self.noRecordLabel.isHidden = !noResult
            self.doctorTableView.isHidden = noResult
        }
    }
    
    var datasource =  GenericDataSource()
    let viewModel = FindDoctorViewModel()
    var doctors = [Doctor]()
    var page = 0
    var totalPage = Int()
    var isNewDataLoading = false
    var spId = ""
    var spName = ""
    var nameId = ""
    var plan_name = ""
    var planID = 0
    
    var filteredParams :[String:Any]?
    var object: Doctor?
    
    
    var insuranceListforSearch = [InsuranceList]()
    var insurancePlanID = 0
    
    // Dr Search Data
    var DoctorListDataArr = [String]()
    var dataFiltered: [String] = []
    var dropButton = DropDown()
    
    // MARK:- View Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setStatusBar(color: .themeGreen)
        hideKeyboardWhenTappedAround()
        self.nameTextfield.text = nameId
        self.specialityTextfield.accessibilityLabel = spId
        self.specialityTextfield.text = spName
        self.insuranceTF.text = plan_name
        self.insurancePlanID = planID
        
        print(self.getParameters())
        viewModel.getSpecialities(){
            self.specialityTextfield.array = self.viewModel.speciality
            // self.cityTextfield.array = self.viewModel.cities
            
        }
        self.getDoctorList(self.getParameters())
        
        insuranceTF.delegate = self
        // getinsurancesProvidersList()
        
        insuranceTF.addTarget(self, action: #selector(myTargetFunction), for: .touchDown)
        
        self.defaulterLabel.text = ""
        
        getDoctorlistingApiHit(searchStr: "")
        
        // Dr Drop Down
        dataFiltered = DoctorListDataArr
        dropButton.anchorView = searchVw
        dropButton.bottomOffset = CGPoint(x: 0, y:(dropButton.anchorView?.plainView.bounds.height)!)
        dropButton.backgroundColor = .white
        dropButton.direction = .bottom

        dropButton.selectionAction = { [unowned self] (index: Int, drName: String) in
            print("Selected item: \(drName) at index: \(index)") //Selected item: code at index: 0
            
            self.nameTextfield.text = drName
            self.getDoctorList(getParameters())
            
        }
        nameTextfield.delegate = self
        nameTextfield.addTarget(self, action: #selector(FindDoctorController.textFieldDidChange(_:)), for: .editingChanged)
        specialityTextfield.delegate = self
        specialityTextfield.addTarget(self, action: #selector(FindDoctorController.textFieldDidChange(_:)), for: .editingChanged)
        insuranceTF.delegate = self
        insuranceTF.addTarget(self, action: #selector(FindDoctorController.textFieldDidChange(_:)), for: .editingChanged)
        
        // Setup to check Clear Button
        checkClearButtonHideShow()
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        if Authentication.customerType == EnumUserType.Doctor {
            self.customerInfo()
        }
        
        self.doctorTableView.reloadData()
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
    
    @objc func myTargetFunction(textField: UITextField) {
        self.nameTextfield.resignFirstResponder()
        self.specialityTextfield.resignFirstResponder()
        let showItemStoryboard = UIStoryboard(name: "insurance", bundle: nil)
        let showItemNavController = showItemStoryboard.instantiateViewController(withIdentifier: "InsuranceSearchVC") as! InsuranceSearchVC
        showItemNavController.insuranceList = self.insuranceListforSearch
        showItemNavController.delegate = self
        present(showItemNavController, animated: true, completion: nil)
    }
    
    @IBAction func didtapClearSearch(_ sender: Any) {
        self.nameTextfield.text = ""
        self.insuranceTF.text = ""
        self.specialityTextfield.text = ""
        self.insurancePlanID = 0
        self.specialityTextfield.accessibilityLabel = "0"
        self.plan_name = ""
        
        // Setup to check Clear Button
        checkClearButtonHideShow()
        
        NotificationCenter.default.post(name: Notification.Name("clear_search"), object: nil)
        
        if isValidSearch(){
            self.view.endEditing(true)
            doctors.removeAll()
            self.page = 0
            getDoctorList(getParameters())
        }
    }
    
    @IBAction func didTapBackButton(_ sender: Any) {
        NavigationHandler.pop()
    }
    
    @IBAction func didtapFilter(_ sender: Any) {
        NavigationHandler.pushTo(.feed)
        /* NavigationHandler.pushTo(.filterVC)
         let filterVC = self.storyboard?.instantiateViewController(withIdentifier: "FilterVC") as! FilterVC
         filterVC.delegate = self
         filterVC.filteredParams = self.filteredParams
         filterVC.modalPresentationStyle = UIModalPresentationStyle.overFullScreen
         self.present(filterVC, animated: true)*/
    }
    
    @IBAction func didTapPhone(_ sender: UIButton) {
        guard let number = URL(string: "tel://" + (sender.titleLabel?.text ?? "1")) else { return }
        UIApplication.shared.open(number, options: [:], completionHandler: nil)
    }
    @IBAction func didTapSearchButton(_ sender: Any) {
        
        if isValidSearch(){
            self.view.endEditing(true)
            doctors.removeAll()
            self.page = 0
            getDoctorList(getParameters())
        }
        
    }
    
    @IBAction func didTapProfileButton(_ sender: Any) {
        NavigationHandler.pushTo(Authentication.customerType == EnumUserType.Customer ? .memberDb : .doctorDb)
    }
    
    @IBAction func didTapLogoutButton(_ sender: UIButton) {
        AlertManager.showAlert(type: .custom(HomeScreenTxt.HomeAlerts.LogoutAlert.localize()), actionTitle: AlertBtnTxt.okay.localize()) {
            Authentication.clearData()
            NavigationHandler.logOut()
        }
    }
}
extension FindDoctorController {
    func getDoctorList(_ query: [String: Any]){
        self.view.activityStartAnimating(activityColor: .themeGreen, backgroundColor: UIColor.white)
        
        WebService.findDoctor(queryItems: query) { (result) in
            DispatchQueue.main.async {
                switch result {
                case .success(let response):
                    print(response)
                    if let user = response.object {
                        self.totalPage = user.TotalCount ?? 0
                        if self.page == 0 {
                            self.doctors = user.AvailableProviderDetailList ?? []
                        }else {
                            self.doctors.append(contentsOf: user.AvailableProviderDetailList ?? [])
                        }
                        self.setUpCell()
                        self.noResult = self.doctors.count == 0
                        self.doctorTableView.reloadData()
                        self.datasource.isScrolled = user.AvailableProviderDetailList?.count == 0 ? true : false
                        self.isNewDataLoading = user.AvailableProviderDetailList?.count == 0 ? false : true
                    } else {
                        self.noResult = true
                    }
                    
                case .failure(let error):
                    self.resultLabel.text = ""
                    //  AlertManager.showAlert(type: .custom(error.message), title: AlertBtnTxt.okay.localize(), action: {})
                    self.noResult = true
                }
                self.view.activityStopAnimating()
            }
        }
        
    }
    
    func setUpCell(){
        self.datasource.array = self.doctors
        self.datasource.identifier = DoctorCell.identifier
        self.doctorTableView.dataSource = self.datasource
        self.doctorTableView.delegate = self.datasource
        self.datasource.configure = {cell, index in
            if self.doctors.count == 0 {return}
            guard let doctorCell = cell as? DoctorCell else { return }
            
            self.resultLabel.text = FindDoctorScreenTxt.Showing.localize() + "\(self.doctors.count)" + FindDoctorScreenTxt.outOF.localize() + "\(self.totalPage)  \(FindDoctorScreenTxt.results.localize())"
            
            doctorCell.object = self.doctors[index]
            doctorCell.handler = { [self] arrayTiming in
                var strAddress = String()
                for i in arrayTiming {
                    strAddress.append("\(i.DayMasters?.Name ?? "")\n\(i.MorningTimeStart?.Timing ?? "")-\(i.MorningTimeEnd?.Timing ?? "")\n\(i.EveningTimeStart?.Timing ?? "")-\(i.EveningTimeEnd?.Timing ?? "")\n\n")
                }
                let controller = self.storyboard?.instantiateViewController(withIdentifier: "TimingsPopupViewController") as! TimingsPopupViewController
                controller.modalPresentationStyle = .overFullScreen
                controller.timingsArray = arrayTiming
                controller.timezone = doctorCell.object?.AvailableTimeZoneMsg ?? ""
                self.present(controller, animated: false, completion: nil)
            }
            doctorCell.handlingEvent = { event, object in
                switch event {
                case .appointment:
                    NavigationHandler.pushTo(.bookAppoinment(object,self.insuranceListforSearch,self.plan_name,self.insurancePlanID))
                    break
                case .rating:
                    break
                case .knowmore: NavigationHandler.pushTo(.knowMore(object))
                    break
                }
            }
        }
        self.datasource.didScroll = {
            if self.isNewDataLoading{
                let pageData = self.page == 0 ? 1 : self.page
                if pageData < self.totalPage{
                    self.page = self.page+1
                    
                    print(self.doctors.count , self.totalPage)
                    
                    if self.doctors.count < self.totalPage{
                        self.getDoctorList(self.getParameters())
                    }
                    self.isNewDataLoading = false
                }
            }
        }
    }
    
    func getParameters() -> [String: Any]{
        var queryItems = ["AuthKey": Constants.authKey, "PageSize": "10", "CustomerTypeId": "1", "PageNo": page] as [String : Any]
        if let name = self.nameTextfield.text , name.count > 0 {
            queryItems["Name"] = name
        }
        
        if let speciality = self.specialityTextfield.accessibilityLabel , speciality.count > 0 {
            queryItems["SpecialityId"] = speciality
        }
        
        if let insurance = self.insuranceTF.text , insurance.count > 0 {
            queryItems["InsurancePlanId"] = self.insurancePlanID
        }
        return queryItems
    }
    
    func isValidSearch() -> Bool {
        /* if !pincodeTextfield.text!.isEmpty && (pincodeTextfield.text?.count ?? 0) < 6{
         AlertManager.showAlert(type: .custom("Please Enter Valid Pincode."))
         return false
         }else if !pincodeTextfield.text!.prefix(1).allSatisfy(("1"..."9").contains) {
         AlertManager.showAlert(type: .custom("Please Enter Valid Pincode."))
         return false
         }*/
        if !nameTextfield.text!.prefix(1).allSatisfy(("ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz").contains){
            AlertManager.showAlert(type: .custom(FindDoctorScreenTxt.validName.localize()))
            return false
        }
        return true
    }
    
}

extension FindDoctorController: UITextFieldDelegate,FilterVCDelegate ,UIPopoverPresentationControllerDelegate ,InsuranceSearchVCDelegate{
    func selectedInsurance(planName: String, planID: Int, providerID: Int, isAccepted: Bool) {
        self.insuranceTF.text = planName
        self.insurancePlanID = planID
        self.plan_name = planName
        
        
        checkClearButtonHideShow()
        
    }
    
    func filterParams(selected: [String : Any]) {
        
        self.filteredParams = selected
        
        self.doctors.removeAll()
        self.page = 0
        
        self.nameTextfield.text = "\(selected["Name"] ?? "")"
        self.insuranceTF.text = "\(selected["InsurancePlanName"] ?? "")"
        self.insurancePlanID = Int("\(selected["InsurancePlanId"] ?? 0)") ?? 0
        //  self.pincodeTextfield.text = "\(selected["Pincode"] ?? "")"
        // self.cityTextfield.accessibilityLabel = "\(selected["CityId"] ?? 0)"
        self.specialityTextfield.accessibilityLabel = "\(selected["SpecialityId"] ?? 0)"
        /*
         if "\(selected["CityId"] ?? 0)" != "0" {
         if let object = self.viewModel.cities.filter({ $0.Value == cityTextfield.accessibilityLabel }).first {
         cityTextfield.text = object.Text
         }
         }else{cityTextfield.text = ""}
         */
        if "\(selected["SpecialityId"] ?? 0)" != "0" {
            if let object = self.viewModel.speciality.filter({ $0.Value == specialityTextfield.accessibilityLabel }).first {
                specialityTextfield.text = object.Text
            }
        }else{specialityTextfield.text = ""}
        
        print(selected["CityId"] ?? 0,selected["SpecialityId"] ?? 0)
        self.getDoctorList(selected)
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    func textFieldDidEndEditing(_ textField: UITextField) {
        checkClearButtonHideShow()
    }
    
    func checkClearButtonHideShow() {
        let nameTxtFld = self.nameTextfield.text?.trimmed()
        let speclityTxtFld = self.specialityTextfield.text?.trimmed()
        let insurenceTxtFld = self.insuranceTF.text?.trimmed()
           
        if nameTxtFld != "" || speclityTxtFld != "" ||  insurenceTxtFld != ""{
            self.clearSearchBtn.isHidden = false
        }
        else {
            self.clearSearchBtn.isHidden = true
        }
    }
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        if textField == insuranceTF{
            resignFirstResponder()
        }
        
        checkClearButtonHideShow()
        
    }
    // func getinsurancesProvidersList(){
    //     let queryItems = ["":""]
    //     self.view.activityStartAnimating(activityColor: .themeGreen, backgroundColor: UIColor.white)
    //          WebService.insurancesProvidersAndPlans(queryItems: queryItems) { (result) in
    //              DispatchQueue.main.async {
    //                  switch result {
    //                  case .success(let response):
    //                         self.insuranceListforSearch = response.objects?.filter({/$0.InsurancesPlansList?.count>0}) ?? []
    //                  case .failure(let error):
    //                      AlertManager.showAlert(type: .custom(error.message))
    //                  }
    //                self.view.activityStopAnimating()
    //              }
    //          }
    //      }
}


extension FindDoctorController{
    

    @objc func textFieldDidChange(_ textField: UITextField) {
        
        let drTxt = textField.text?.trimmed()
        print(/drTxt)
        
        if drTxt == "" {
            dataFiltered = DoctorListDataArr
            dropButton.dataSource = dataFiltered
            dropButton.hide()
        }else{
            dataFiltered = DoctorListDataArr.filter { $0.localizedCaseInsensitiveContains(/drTxt) }
            dropButton.dataSource = dataFiltered
            dropButton.show()
        }
        
        if nameTextfield.text != "" || self.specialityTextfield.text != "" || insuranceTF.text != ""{
            self.clearSearchBtn.isHidden = false
        }
        else {
            self.clearSearchBtn.isHidden = true
        }
    }
    
    func getDoctorlistingApiHit(searchStr:String) {
        let queryItems = ["AuthKey": Constants.authKey, "SearchName": searchStr] as [String : Any]
        WebService.GetDoctorNameList(queryItems: queryItems) { (result) in
            switch result {
            case .success(let response):
                if let user = response.objects {
                    
                    Authentication.docList = user.filter({$0.Text != "" && $0.Text != nil }).map({/$0.Text})
                    // print(/Authentication.docList?.count)
                    
                    // Update Doc List
                    self.updateDocList(isUpdate: false)
                    
                } else {
                }
            case .failure(let error):
                print(error.message)
                if error.message == "Login Key is invalid"{
                    //self.logoutUser()
                }else{
                    // self.showError(message: error.message)
                }
            }
        }
    }
    
    func updateDocList(isUpdate:Bool) {
        
        // assign Data
        self.DoctorListDataArr = Authentication.docList ?? []
        
        if isUpdate {
            // Call Api
            getDoctorlistingApiHit(searchStr: "")
        }
    }
    
    
}

extension FindDoctorController{
    override func traitCollectionDidChange(_ previousTraitCollection: UITraitCollection?) {
        // do whatever you want to do
        print("mode change")
        
        if #available(iOS 13.0, *) {
            self.doctorTableView.reloadData()
        } else {
            // Fallback on earlier versions
        }
        
        self.view.layoutIfNeeded()
    }
}

