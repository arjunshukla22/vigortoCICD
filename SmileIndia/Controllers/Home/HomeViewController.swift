//
//  HomeViewController.swift
//  SmileIndia
//
//  Created by Sakshi on 30/07/20.
//  Copyright © 2020 Na. All rights reserved.
//

import UIKit
import DropDown
import Localize
import EZSwiftExtensions

protocol searchDrDelegate{
    func filterParams(selected : [String: Any])
}

class HomeViewController: BaseViewController, UITableViewDelegate, UITableViewDataSource, UIGestureRecognizerDelegate {
    var delegate : searchDrDelegate?
    @IBOutlet weak var shareButton: UIButton!
    @IBOutlet weak var specialityTextfield: CustomTextfield!
    @IBOutlet weak var pageControl: UIPageControl!
    @IBOutlet weak var nameTextfield: UITextField!
    @IBOutlet weak var SymptomCollectionView: UICollectionView!
    @IBOutlet weak var SpecialitiesCollectionView: UICollectionView!
    @IBOutlet weak var BannerCollectionView: UICollectionView!
    @IBOutlet weak var smallsideview: UIView!
    @IBOutlet weak var CloseSideBarBtn: UIButton!
    @IBOutlet weak var sideView: UIView!
    @IBOutlet weak var sideDBTableView: UITableView!
    @IBOutlet var searchDoctorTF: UITextField!
    @IBOutlet weak var infoLabel: PaddingLabel!
    
    @IBOutlet weak var insuranceTF: UITextField!
    
    @IBOutlet weak var logoutVw: UIView!
    @IBOutlet weak var hippaImg: UIImageView!
    
    @IBOutlet weak var searchVw: UIView!
    
    var timer = Timer()
    var counter = 0
    var insuranceListforSearch = [InsuranceList]()
    var insurancePlanID = 0
    let topBorder = CALayer()
    let bottomBorder = CALayer()
    var isSubscribed = false
    
    let SwipeLeft = UISwipeGestureRecognizer()
    let SwipeRight = UISwipeGestureRecognizer()
    let screenSize: CGRect = UIScreen.main.bounds
    let statusbarheight = UIApplication.shared.statusBarFrame.height
    var speciality = 0
    var userimage: User?
    var rewards: Rewards?
    var doctors = [Doctor]()
    var doctor: DoctorData?
    var paymentStatus : Bool?
    var accountDetails = [AccountDetails]()
    var isSideViewOpen: Bool = false
    var selectedIndex = 0
    var datasource = GenericCollectionDataSource()
    var datasourceTable = GenericDataSource()
    var page = 0
    var guestUserLabel = [[HomeScreenTxt.guestUserArr.LoginSignUp],[HomeScreenTxt.guestUserArr.SocioConn,HomeScreenTxt.guestUserArr.FindaDoc,HomeScreenTxt.guestUserArr.Contactus,HomeScreenTxt.guestUserArr.FAQ]]
    var guestUserImg = [[#imageLiteral(resourceName: "white")],[#imageLiteral(resourceName: "socio"),#imageLiteral(resourceName: "findadoc"),#imageLiteral(resourceName: "contactus"),#imageLiteral(resourceName: "faq")]]

    var doctorDBArray = [[HomeScreenTxt.UserArr.SocialConnection,HomeScreenTxt.UserArr.MyAccount,HomeScreenTxt.UserArr.MyAppointments,HomeScreenTxt.UserArr.eAppointments,HomeScreenTxt.UserArr.MyCalendar,HomeScreenTxt.UserArr.ManageAccount,HomeScreenTxt.UserArr.ReferVigorto,HomeScreenTxt.UserArr.MyReviews,HomeScreenTxt.guestUserArr.FindaDoc,HomeScreenTxt.UserArr.Subscriptions,HomeScreenTxt.UserArr.Insurance,HomeScreenTxt.UserArr.VigortoCredits,HomeScreenTxt.guestUserArr.Contactus],[HomeScreenTxt.UserSectionTwo.ChangePassword,HomeScreenTxt.UserSectionTwo.TermsConditions,HomeScreenTxt.UserSectionTwo.PrivacyPolicy,HomeScreenTxt.UserSectionTwo.HIPAA,HomeScreenTxt.UserSectionTwo.AboutVigorto,HomeScreenTxt.UserSectionTwo.HowitWorks,HomeScreenTxt.guestUserArr.FAQ,HomeScreenTxt.guestUserArr.changeLanguage]]
    var memberDBArray = [[HomeScreenTxt.UserArr.SocialConnection,HomeScreenTxt.UserArr.MyAccount,HomeScreenTxt.guestUserArr.FindaDoc,HomeScreenTxt.UserArr.MyAppointments,HomeScreenTxt.UserArr.eAppointments,HomeScreenTxt.UserArr.ReferVigorto,HomeScreenTxt.UserArr.VigortoCredits,HomeScreenTxt.UserArr.Rewards,HomeScreenTxt.guestUserArr.Contactus],[HomeScreenTxt.UserSectionTwo.ChangePassword,HomeScreenTxt.UserSectionTwo.TermsConditions,HomeScreenTxt.UserSectionTwo.PrivacyPolicy,HomeScreenTxt.UserSectionTwo.HIPAA,HomeScreenTxt.UserSectionTwo.AboutVigorto,HomeScreenTxt.UserSectionTwo.HowitWorks,HomeScreenTxt.guestUserArr.FAQ,HomeScreenTxt.guestUserArr.changeLanguage]]
        
    let viewModel = FindDoctorViewModel()
    var viewModelimg = ProfileViewModel()
    var dict = [String: Any]()
    var tabelImg = [[#imageLiteral(resourceName: "socio"),#imageLiteral(resourceName: "myaccount"),#imageLiteral(resourceName: "appointment"),#imageLiteral(resourceName: "eapp"),#imageLiteral(resourceName: "mycalendar"),#imageLiteral(resourceName: "maccount"),#imageLiteral(resourceName: "refer"),#imageLiteral(resourceName: "rateus"),#imageLiteral(resourceName: "findadoc"),#imageLiteral(resourceName: "sub"),#imageLiteral(resourceName: "insurance"),#imageLiteral(resourceName: "vgcredit"),#imageLiteral(resourceName: "contactus")],[#imageLiteral(resourceName: "white"),#imageLiteral(resourceName: "white"),#imageLiteral(resourceName: "white"),#imageLiteral(resourceName: "white"),#imageLiteral(resourceName: "white"),#imageLiteral(resourceName: "white"),#imageLiteral(resourceName: "white")]]
    var tabelImg1 = [[#imageLiteral(resourceName: "socio"),#imageLiteral(resourceName: "myaccount"),#imageLiteral(resourceName: "findadoc"),#imageLiteral(resourceName: "appointment"),#imageLiteral(resourceName: "eapp"),#imageLiteral(resourceName: "refer"),#imageLiteral(resourceName: "vgcredit"),#imageLiteral(resourceName: "rewards-icon"),#imageLiteral(resourceName: "contactus")],[#imageLiteral(resourceName: "white"),#imageLiteral(resourceName: "white"),#imageLiteral(resourceName: "white"),#imageLiteral(resourceName: "white"),#imageLiteral(resourceName: "white"),#imageLiteral(resourceName: "white"),#imageLiteral(resourceName: "white")]]
    
    var SymptomImg = [#imageLiteral(resourceName: "fever"),#imageLiteral(resourceName: "cough"),#imageLiteral(resourceName: "Headache"),#imageLiteral(resourceName: "backpain"),#imageLiteral(resourceName: "acidity"),#imageLiteral(resourceName: "constipation"),#imageLiteral(resourceName: "tp"),#imageLiteral(resourceName: "anxity"),#imageLiteral(resourceName: "weightloss"),#imageLiteral(resourceName: "hairfall"),#imageLiteral(resourceName: "diabities"),#imageLiteral(resourceName: "skincare")]
    var SpImg = [#imageLiteral(resourceName: "gc"),#imageLiteral(resourceName: "derma"),#imageLiteral(resourceName: "dentist"),#imageLiteral(resourceName: "childcare"),#imageLiteral(resourceName: "eyecare"),#imageLiteral(resourceName: "ENT"),#imageLiteral(resourceName: "gastro"),#imageLiteral(resourceName: "gyno")]
    var bannerImg = [#imageLiteral(resourceName: "slider1"),#imageLiteral(resourceName: "slider2"),#imageLiteral(resourceName: "slider3")]
    var bannerBgColor = [#colorLiteral(red: 0.9098039216, green: 0.4862745098, blue: 0.1254901961, alpha: 1),#colorLiteral(red: 0, green: 0.7854699492, blue: 0.7984265685, alpha: 1),#colorLiteral(red: 0.8323305249, green: 0.05832160264, blue: 0.440990746, alpha: 1)]
    var bannerTopLabel = [HomeScreenTxt.BannerTop.topFirst,HomeScreenTxt.BannerTop.topSecond,HomeScreenTxt.BannerTop.topThird]
    var bannerBottomLabel = [HomeScreenTxt.BannerBottom.bottomfirst,HomeScreenTxt.BannerBottom.bottomSecond,HomeScreenTxt.BannerBottom.bottomThird]
    var spearr = [List]()
    var arrSp =  [String]()
    var SpValue = ["50","230","229","183","143","232","70","125"]
    var CsValue = ["50","50","50","17","70","70","50","50","233","230","69","230"]
    var SpLabel = [ HomeScreenTxt.SpecialitiesArr.Generalcare,HomeScreenTxt.SpecialitiesArr.Dermatologist,HomeScreenTxt.SpecialitiesArr.Dentist,HomeScreenTxt.SpecialitiesArr.Childcare,HomeScreenTxt.SpecialitiesArr.EyeCare,HomeScreenTxt.SpecialitiesArr.ENT,HomeScreenTxt.SpecialitiesArr.Gastroenterology,HomeScreenTxt.SpecialitiesArr.Gynecologist]
    var SymptomLabel = [HomeScreenTxt.SymptomsArr.Fever,HomeScreenTxt.SymptomsArr.cough,HomeScreenTxt.SymptomsArr.Headache,HomeScreenTxt.SymptomsArr.Backpain,HomeScreenTxt.SymptomsArr.Acidity,HomeScreenTxt.SymptomsArr.Constipation,HomeScreenTxt.SymptomsArr.ThroatPain,HomeScreenTxt.SymptomsArr.Anxiety,HomeScreenTxt.SymptomsArr.WeightLoss,HomeScreenTxt.SymptomsArr.Hairfall,HomeScreenTxt.SymptomsArr.Diabetes,HomeScreenTxt.SymptomsArr.SkinCare]
    var SpetialityImg = [#imageLiteral(resourceName: "doctor_prfile"),#imageLiteral(resourceName: "prescription"),#imageLiteral(resourceName: "appointsment"),#imageLiteral(resourceName: "mycalendar"),#imageLiteral(resourceName: "share"),#imageLiteral(resourceName: "find-doctor")]
    
    var thisWidth : CGFloat = 0
    var object: Doctor?
    var dpurl = ""
    
    
    // Dr Search Data
    var DoctorListDataArr = [String]()
    var dataFiltered: [String] = []
    var dropButton = DropDown()
    
    
    override func viewDidLoad(){
        super.viewDidLoad()
        pageControl.hidesForSinglePage = true
        if !(Authentication.isUserLoggedIn ?? false) {
            shareButton.isHidden = true
        }
        infoLabel.text = HomeScreenTxt.InfoTexts.infoLabel.localize()
        
        infoLabel.padding(10, 10, 10, 10)
        infoLabel.layer.cornerRadius = 5.0
        setStatusBar(color: .themeGreen)
        sideView.isHidden = true
        isSideViewOpen = false
        hideKeyboardWhenTappedAround()
        SwipeLeft.direction = .left
        SwipeRight.direction = .right
        viewModel.getSpecialities(){
            self.specialityTextfield.array = self.viewModel.speciality
            
            self.SpecialitiesCollectionView.reloadData()
            print(self.viewModel.speciality.count,self.SpLabel.count)
        }
        self.sideView.addGestureRecognizer(SwipeRight)
        self.sideView.addGestureRecognizer(SwipeLeft)
        SwipeRight.addTarget(self, action: #selector(Swipe(sender:)))
        SwipeLeft.addTarget(self, action: #selector(Swipe(sender:)))
        insuranceTF.delegate = self
        getinsurancesProvidersList()
        insuranceTF.addTarget(self, action: #selector(myTargetFunction), for: .touchDown)
        nameTextfield.clearButtonMode = .whileEditing
        
        NotificationCenter.default.addObserver(self, selector: #selector(self.clearSearchNotificationReceived(notification:)), name: Notification.Name("clear_search"), object: nil)
        
        startTimer()
        
        
        // Dr Drop Down
        dataFiltered = DoctorListDataArr
        dropButton.anchorView = searchVw
        dropButton.bottomOffset = CGPoint(x: 0, y:(dropButton.anchorView?.plainView.bounds.height)!)
        dropButton.backgroundColor = .white
        dropButton.direction = .bottom

        dropButton.selectionAction = { [unowned self] (index: Int, drName: String) in
            print("Selected item: \(drName) at index: \(index)") //Selected item: code at index: 0
            
            NavigationHandler.pushTo(.homeWithNameandSp(self.specialityTextfield.accessibilityLabel ?? "", /self.specialityTextfield.text, /drName , self.insuranceTF.text ?? "" , self.insurancePlanID,self.insuranceListforSearch))
        }
        
        nameTextfield.addTarget(self, action: #selector(HomeViewController.textFieldDidChange(_:)), for: .editingChanged)
        
    }

    
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
    }
    
    func getDoctorlistingApiHit(searchStr:String) {
        let queryItems = ["AuthKey": Constants.authKey, "SearchName": searchStr] as [String : Any]
        WebService.GetDoctorNameList(queryItems: queryItems) { (result) in
            switch result {
            case .success(let response):
                if let user = response.objects {
                    
                    Authentication.docList = user.filter({$0.Text != "" && $0.Text != nil }).map({/$0.Text})
                    print(/Authentication.docList?.count)
                    
                    // Update Doc List
                    self.updateDocList(isUpdate: false)
                    
                } else {
                }
            case .failure(let error):
                print(error.message)
                if error.message == "Login Key is invalid"{
                    self.logoutUser()
                }else{
                    self.showError(message: error.message)
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
    
    @objc func clearSearchNotificationReceived(notification: Notification) {
        self.nameTextfield.text = ""
        self.insuranceTF.text = ""
        self.specialityTextfield.text = ""
        self.insurancePlanID = 0
    }
    
    @objc func myTargetFunction(textField: UITextField) {
        let showItemStoryboard = UIStoryboard(name: "insurance", bundle: nil)
        let showItemNavController = showItemStoryboard.instantiateViewController(withIdentifier: "InsuranceSearchVC") as! InsuranceSearchVC
        showItemNavController.insuranceList = self.insuranceListforSearch
        showItemNavController.delegate = self
        present(showItemNavController, animated: true, completion: nil)
    }
    func getprofile(){
        WebService.getDoctorProfile(queryItems: ["LoginKey": Authentication.token ?? "YXNob2ttaXR0YWxAZ21haWwuY29tOjEyMzQ1Ng=="]) { (result) in
            DispatchQueue.main.async {
                switch result {
                case .success(let response):
                    if let user = response.object {
                        self.doctor = user
                        self.dpurl = user.ProfileImage ?? ""
                        
                        print(self.dpurl)
                    } else {
                    }
                case .failure(let error):
                    print(error.message)
                    if error.message == "Login Key is invalid"{
                        self.logoutUser()
                    }else{
                        self.showError(message: error.message)
                    }
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
        if !nameTextfield.text!.prefix(1).allSatisfy(("ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz").contains){
            AlertManager.showAlert(type: .custom("Please Enter Valid Name."))
            return false
        }
        return true
    }
    
    
    func moveHippaBanner(){
        /*  UIView.animate(withDuration: 1, delay: 0, options: [.repeat, .autoreverse], animations: {
         self.hippaImg.transform = CGAffineTransform(translationX: -10, y: 0)
         }, completion: nil)*/
        self.hippaImg.transform = .identity
        
        UIView.animate(withDuration: 1, delay: 0, options: [.repeat, .autoreverse], animations: {
            
            self.hippaImg.transform = CGAffineTransform(translationX: -10, y: 0)
            
        }, completion: nil)
        
    }
    
    @IBAction func logoutBtnAction(_ sender: Any) {
        AlertManager.showAlert(type: .custom(HomeScreenTxt.HomeAlerts.LogoutAlert.localize()), actionTitle: AlertBtnTxt.okay.localize()) {
            self.logoutUser()
        }
        
    }
    
    
    @IBAction func didTapSearchButton(_ sender: Any) {
        NavigationHandler.pushTo(.homeWithNameandSp(self.specialityTextfield.accessibilityLabel ?? "",/self.specialityTextfield.text, nameTextfield.text ?? "" , self.insuranceTF.text ?? "" , self.insurancePlanID,self.insuranceListforSearch))
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
       
        
        updateDocList(isUpdate: true)
        
        // Hide Show Logout button
        logoutVw.isHidden = /Authentication.isUserLoggedIn ? false : true
        
        moveHippaBanner()
       
        hidesideBar()
        if Authentication.customerType == EnumUserType.Doctor{
            self.PaidDoctorPlans()
            self.getprofile()
        }
        if Authentication.customerType == "Customer"{
            self.getprofile()
        }
        
        //updateuserData()
        specialityTextfield.text = ""
        nameTextfield.text = ""
        insuranceTF.text = ""
        NotificationCenter.default.addObserver(self, selector: #selector(self.accountNotificationReceived(notification:)), name: Notification.Name("accountdetails"), object: nil)
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        UIView.animate(withDuration: 1, delay: 0, options: [.repeat, .autoreverse], animations: {
            self.hippaImg.transform = CGAffineTransform(translationX: -10, y: 0)
        }, completion: nil)
    }
    @objc func accountNotificationReceived(notification: Notification){
        getAccountDetails()
    }
    
    func logoutUser() -> Void {
        self.deleteToken()
        Authentication.clearData()
        NavigationHandler.logOut()
        self.logOutSinchUser()
    }
    func deleteToken() -> Void {
        self.view.activityStartAnimating(activityColor: .orange, backgroundColor: UIColor.white)
        WebService.deleteDeviceToken(queryItems: ["LoginKey": Authentication.token ?? "YXNob2ttaXR0YWxAZ21haWwuY29tOjEyMzQ1Ng=="]) { (result) in
            DispatchQueue.main.async {
                switch result {
                case .success(let response):
                    print(response.message ?? "")
                case .failure(let error):
                    print(error.message)
                }
                self.view.activityStopAnimating()
            }
        }
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {

        if section == 0 {
            return UITableView.automaticDimension
        }
        return 1
    }
    
    // DashBoard Table
    func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        
        let headerCell = tableView.dequeueReusableCell(withIdentifier: "HeaderCell") as! SideTableViewCell
        
        if section == 0 {
            if !(Authentication.isUserLoggedIn ?? false) {
                headerCell.sideBarLbl.text = HomeScreenTxt.InfoTexts.welcomText.localize()
                headerCell.sideBarImg.sd_setImage(with: doctor?.profileImageURL, placeholderImage: UIImage.init(named: "doctor-avtar"))
                
            }else{
                
                headerCell.sideBarLbl.text = "\(Authentication.customerName ?? "") "
                //                            viewModelimg.getTitles() {
                //                                self.getprofile()
                //                            }
                headerCell.sideBarImg.sd_setImage(with: doctor?.profileImageURL, placeholderImage: UIImage.init(named: "doctor-avtar"))
            }
            
            headerCell.contentView.backgroundColor = .themeGreen
        }else{
            headerCell.sideBarLbl.text = ""
            headerCell.sideBarImg.image = nil
            
                headerCell.contentView.backgroundColor = .systemGray
           
        }
        
        
        return headerCell.contentView
    }

    
//    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
//        let view = UIView()
//        if section == 0 {
//            view.backgroundColor = .themeGreen
//            let Displayimage = UIImageView()
//            // image.frame = CGRect(x: 10, y: 30, width: 60, height: 60)
//            view.addSubview(Displayimage)
//            let label = UILabel()
//            label.sizeToFit()
//            if !(Authentication.isUserLoggedIn ?? false) {
//                label.text = "Welcome to \n VIGORTO"
//                Displayimage.sd_setImage(with: doctor?.profileImageURL, placeholderImage: UIImage.init(named: "doctor-avtar"))
//
//            }else{
//
//                label.text = "\(Authentication.customerName ?? "") "
//                //                            viewModelimg.getTitles() {
//                //                                self.getprofile()
//                //                            }
//
//                Displayimage.sd_setImage(with: doctor?.profileImageURL, placeholderImage: UIImage.init(named: "doctor-avtar"))
//
//            }
//            label.textColor = .white
//            label.lineBreakMode = .byWordWrapping
//            label.numberOfLines = 0HeaderCell
//            if screenSize.height < 900
//            {
//                Displayimage.cornerRadius = 30
//                Displayimage.frame = CGRect(x: 10, y: 20, width: 60, height: 60)
//                label.font = UIFont.boldSystemFont(ofSize: 14.0)
//                label.frame = CGRect(x: 80, y: 20, width: 150, height: 60)
//            }
//
//            else{
//                Displayimage.cornerRadius = 40
//                Displayimage.frame = CGRect(x: 20, y: 40, width: 80, height: 80)
//                label.font = UIFont.boldSystemFont(ofSize: 22.0)
//                label.frame = CGRect(x: 120, y: 40, width: 300, height: 100)
//            }
//            view.addSubview(label)
//        }else{
//            let label = UILabel()
//
//            label.frame = CGRect(x: 5, y: 5, width: 300, height: 0.5)
//            if #available(iOS 13.0, *) {
//                label.backgroundColor = .label
//            } else {
//                // Fallback on earlier versions
//                label.backgroundColor = .lightGray
//            }
//            view.addSubview(label)
//            view.backgroundColor = .clear
//        }
//        return view
//    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if !(Authentication.isUserLoggedIn ?? false) {
            if section == 0 {
                return guestUserLabel[0].count
            }
            
            else {
                return guestUserLabel[1].count
            }
        }
        else  if Authentication.customerType == EnumUserType.Doctor{
            if section == 0 {
                return doctorDBArray[0].count
            }
            else {
                return doctorDBArray[1].count
                
            }
        }
        else {
            if section == 0 {
                return memberDBArray[0].count
                
            }
            else {
                return memberDBArray[1].count
            }
        }
        
        
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.section == 0
        {
            
            let cell:SideTableViewCell = tableView.dequeueReusableCell(withIdentifier: "cell") as! SideTableViewCell
            
            if !(Authentication.isUserLoggedIn ?? false) {
                
                cell.sideBarLbl.text  = guestUserLabel[indexPath.section][indexPath.row].localize()
                cell.sideBarImg.frame = CGRect(x: 0,y: 0,width: 0,height: 0)
                cell.sideBarImg.image = guestUserImg[indexPath.section][indexPath.row]
                cell.sideBarImg.isHidden = true
            }
            else if  Authentication.customerType == EnumUserType.Doctor{
                
                cell.sideBarLbl.text = doctorDBArray[indexPath.section][indexPath.row].localize()
                cell.sideBarImg.image = tabelImg[indexPath.section][indexPath.row]
                cell.sideBarImg.isHidden = false
            }
            else{
                cell.sideBarLbl.text = memberDBArray[indexPath.section][indexPath.row].localize()
                cell.sideBarImg.image = tabelImg1[indexPath.section][indexPath.row]
                cell.sideBarImg.isHidden = false
            }
            return cell
        }
        else{
            let cell:SideTableViewCell = tableView.dequeueReusableCell(withIdentifier: "othercell") as! SideTableViewCell
            
            if !(Authentication.isUserLoggedIn ?? false) {
                cell.sideBarLbl.text  = guestUserLabel[indexPath.section][indexPath.row].localize()
                cell.sideBarImg.frame = CGRect(x: 0,y: 0,width: 40,height: 40)
                cell.sideBarImg.image = guestUserImg[indexPath.section][indexPath.row]
                cell.sideBarImg.isHidden = false
            }
            else{
                cell.sideBarLbl.text = doctorDBArray[indexPath.section][indexPath.row].localize()
                    cell.sideBarImg.frame = CGRect(x: 0,y: 0,width: 0,height: 0)
                   
                    cell.sideBarImg.isHidden = true
            }
            
            return cell
        }

    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
    
        // Comment-UnComment Below  Code to hide Show/ Hide Social
        if /Authentication.isUserLoggedIn { // Real User
            if indexPath.section == 0 && indexPath.row == 0{return 0}
        }else{// Guest User
            if indexPath.section == 1 && indexPath.row == 0{return 0}
        }
        
        if indexPath.section == 1 && /Authentication.isUserLoggedIn {
            return 30
        }
        
        return UITableView.automaticDimension
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if (indexPath.section == 1){
            if !(Authentication.isUserLoggedIn ?? false){
                if indexPath.row == 0{
                    NavigationHandler.pushTo(.feed)
                    
                }
                if indexPath.row == 1{
                    NavigationHandler.pushTo(.homeWithInsurance(self.insuranceListforSearch))
                }
                if indexPath.row == 2{
                    NavigationHandler.pushTo(.contactUs)
                }
                if indexPath.row == 3{
                    NavigationHandler.pushTo(.faq)
                }
            }
            else {
                
                if indexPath.row == 0 {
                    NavigationHandler.pushTo(.changePassword)
                    
                }
                if indexPath.row == 1{
                    let termsVc = TermsVC.init(nibName: "TermsVC", bundle: nil)
                    termsVc.modalPresentationStyle = .fullScreen
                    termsVc.screentitle = "Terms & Conditions"
                    termsVc.requestURLString = "https://www.vigorto.com/terms-and-conditions.pdf"
                    
                    self.present(termsVc, animated: true, completion: nil)
                }
                if indexPath.row == 2{
                    
                    let termsVc = TermsVC.init(nibName: "TermsVC", bundle: nil)
                    termsVc.modalPresentationStyle = .fullScreen
                    termsVc.screentitle = "Privacy Policy"
                    termsVc.requestURLString = "https://www.vigorto.com/security-and-privacy.pdf"
                    self.present(termsVc, animated: true, completion: nil)
                }
                if indexPath.row == 3{
                    
                    let termsVc = TermsVC.init(nibName: "TermsVC", bundle: nil)
                    termsVc.modalPresentationStyle = .fullScreen
                    termsVc.screentitle = "HIPAA authorization"
                   
                    termsVc.requestURLString = "https://vigorto.com/vigorto-hipaa-authorization.pdf"
                    self.present(termsVc, animated: true, completion: nil)
                }
                if indexPath.row == 4{
                    NavigationHandler.pushTo(.aboutusvc)
                }
                if indexPath.row == 5{
                    NavigationHandler.pushTo(.howitworks)

                }
                if indexPath.row == 6{
                    NavigationHandler.pushTo(.faq)

                }
                if indexPath.row == 7{ // Change Language
                    
                    hidesideBar()
                    ChangeLanguageApp()
                    
                }
    
            }}
        else {
            if !(Authentication.isUserLoggedIn ?? false) {
                NavigationHandler.pushTo(.login)
            }
            else if  Authentication.customerType == EnumUserType.Doctor{
                if indexPath.row == 0{
                    NavigationHandler.pushTo(.feed)
                    
                }
                if indexPath.row == 1{
                    NavigationHandler.pushTo(.doctorProfileOne)
                    
                }
                else if indexPath.row == 2{
                    if isSubscribed {
                        NavigationHandler.pushTo(.appointmentList("0"))
                    }else{
                        self.presentAlertWithImageAndMessageForSubscription(msg: HomeScreenTxt.HomeAlerts.SubAlert.localize(), img: #imageLiteral(resourceName: "subscription_vg"))
                    }
                    
                }
                else if indexPath.row == 3 {
                    if isSubscribed {
                        NavigationHandler.pushTo(.eAppointmentsList)
                    }else{
                        self.presentAlertWithImageAndMessageForSubscription(msg: HomeScreenTxt.HomeAlerts.SubAlert.localize(), img: #imageLiteral(resourceName: "subscription_vg"))
                    }
                    
                }
                else if indexPath.row == 4 {
                    if isSubscribed {
                        NavigationHandler.pushTo(.calendar)
                    }else{
                        self.presentAlertWithImageAndMessageForSubscription(msg: HomeScreenTxt.HomeAlerts.SubAlert.localize(), img: #imageLiteral(resourceName: "subscription_vg"))
                    }
                    
                }
                else if indexPath.item == 5{
                    if isSubscribed {
                        checkdocs()
                    }else{
                        self.presentAlertWithImageAndMessageForSubscription(msg: HomeScreenTxt.HomeAlerts.SubAlert.localize(), img: #imageLiteral(resourceName: "subscription_vg"))
                    }
                    
                }
                else if indexPath.item == 6{if isSubscribed {
                    NavigationHandler.pushTo(.referralVC)
                }else{
                    self.presentAlertWithImageAndMessageForSubscription(msg: HomeScreenTxt.HomeAlerts.SubAlert.localize(), img: #imageLiteral(resourceName: "subscription_vg"))
                    
                }
                }
                else if indexPath.item == 7{
                    
                    if isSubscribed {
                        NavigationHandler.pushTo(.ratingList)
                    }else{
                        self.presentAlertWithImageAndMessageForSubscription(msg: HomeScreenTxt.HomeAlerts.SubAlert.localize(), img: #imageLiteral(resourceName: "subscription_vg"))
                    }
                    
                }
                else if indexPath.item == 8{
                    if isSubscribed {
                        NavigationHandler.pushTo(.homeWithInsurance(self.insuranceListforSearch))
                    }else{
                        self.presentAlertWithImageAndMessageForSubscription(msg: HomeScreenTxt.HomeAlerts.SubAlert.localize(), img: #imageLiteral(resourceName: "subscription_vg"))
                    }
                    
                }
                else if indexPath.item == 9{
                    if self.isSubscribed == true{
                        NavigationHandler.pushTo(.drPlanDetails("1"))
                    }else {
                        NavigationHandler.pushTo(.subscriptionVC)
                    }
                    
                }
                else if indexPath.item == 10{
                    if isSubscribed {
                        NavigationHandler.pushTo(.insurance)
                    }else{
                        self.presentAlertWithImageAndMessageForSubscription(msg: HomeScreenTxt.HomeAlerts.SubAlert.localize(), img: #imageLiteral(resourceName: "subscription_vg"))
                    }
                    
                }
                else if indexPath.item == 11{
                    if isSubscribed {
                        NavigationHandler.pushTo(.credits)
                    }else{
                        self.presentAlertWithImageAndMessageForSubscription(msg: HomeScreenTxt.HomeAlerts.SubAlert.localize(), img: #imageLiteral(resourceName: "subscription_vg"))
                    }
                    
                }
                else if indexPath.item == 12{
                    NavigationHandler.pushTo(.contactUs)
                }
            }
            else{
                if indexPath.row == 0{
                    NavigationHandler.pushTo(.feed)
                }
                else
                if indexPath.row == 1{
                    NavigationHandler.pushTo(.memberProfile)
                }
                
                else if indexPath.row == 2{
                    NavigationHandler.pushTo(.homeWithInsurance(self.insuranceListforSearch))
                }else if indexPath.row == 3{
                    NavigationHandler.pushTo(.appointmentList("0"))
                }
                else if indexPath.row == 4{
                    NavigationHandler.pushTo(.eAppointmentsList)
                }else if indexPath.item == 5{
                    NavigationHandler.pushTo(.referralVC)
                }
                else if indexPath.item == 6{
                    // AlertManager.showAlert(type: .custom("Coming soon")) {
                    //  }
                    NavigationHandler.pushTo(.credits)
                }else if indexPath.item == 7{
                    NavigationHandler.pushTo(.rewards)
                }
                else if indexPath.item == 8{
                    NavigationHandler.pushTo(.contactUs)
                }
                
            }}
    }
    
    func ChangeLanguageApp() {
        let actionSheet = UIAlertController(
            title: nil,
            message: AlertBtnTxt.selectLanguage.localize(),
            preferredStyle: UIAlertController.Style.actionSheet
        )
        
        for language in Localize.availableLanguages {
            
            print(language)
            
            let displayName = (language == "en") ? "English" : Localize.displayNameForLanguage(language)
            let languageAction = UIAlertAction(
                title: displayName,
                style: .default,
                handler: { (_: UIAlertAction!) -> Void in
                    
                    //                    Localize.update(fileName: "lang")
                    // Set your default languaje.
                    Localize.update(defaultLanguage: language)
                    // If you want change a user language, different to default in phone use thimethod.
                    Localize.update(language: language)
                    
                    Authentication.appLanguage = language
                    // appdelegate?.UpdateAppLanguage(Lang: language)
                    self.setUpDataReload()
                })
            actionSheet.addAction(languageAction)
        }
        let cancelAction = UIAlertAction(
            title: AlertBtnTxt.cancel.localize(),
            style: UIAlertAction.Style.cancel,
            handler: nil
        )
        
        actionSheet.addAction(cancelAction)
        self.present(actionSheet, animated: true, completion: nil)
        
      
    }
    
    func setUpDataReload(){
        ez.dispatchDelay(0) {
            self.infoLabel.text = HomeScreenTxt.InfoTexts.infoLabel.localize()
            self.SymptomCollectionView.reloadData()
            self.SpecialitiesCollectionView.reloadData()
            self.BannerCollectionView.reloadData()

        }
    }
    
    func getDoctorPlanDetails() -> Void {
        let queryItems = ["CustomerId": "\(Authentication.customerGuid!)"]
        WebService.doctorPlanDetails(queryItems: queryItems) { (result) in
            DispatchQueue.main.async {
                switch result {
                case .success(let response):
                    if response.object?.PaymentStatus == true{
                        NavigationHandler.pushTo(.drPlanDetails("1"))
                    }else {
                        NavigationHandler.pushTo(.subscriptionPaymentVC)
                    }
                case .failure:
                    NavigationHandler.pushTo(.subscriptionVC)
                    
                }
            }
        }
    }
    
    func PaidDoctorPlans() -> Void {
        let queryItems = ["CustomerGuid": "\(Authentication.customerGuid!)"]
        WebService.paidDoctorPlans(queryItems: queryItems) { (result) in
            DispatchQueue.main.async {
                switch result {
                case .success(let response):
                    if response.object?.SubscriptionStatus == true && response.object?.PaymentStatus == true{
                        self.isSubscribed = true
                        // NavigationHandler.pushTo(.drPlanDetails)
                    }else{
                        self.isSubscribed = false
                    }
                case .failure:
                    self.isSubscribed = false
                // NavigationHandler.pushTo(.subscriptionVC)
                }
            }
        }
    }
    
    @objc func Swipe(sender: UISwipeGestureRecognizer)
    {
        switch sender.direction{
        case .right:
            showsideBar()
        case .left:
            hidesideBar()
        default:
            hidesideBar()
        }
    }
    
    @IBAction func didtapDashbord(_ sender: Any) {
        
        sideDBTableView.isHidden = false
        sideView.isHidden = false
        
        self.view.bringSubviewToFront(sideView)
        if !isSideViewOpen{
            showsideBar()
        }else{
            hidesideBar()
        }
        sideDBTableView.reloadData()
        
    }
    func showsideBar(){
        
        var tablewidth = screenSize.width * 0.7
        var closesidebarWidth = screenSize.width * 0.3
        if screenSize.width > 700{
            tablewidth = screenSize.width * 0.5
            
            closesidebarWidth = screenSize.width * 0.5
        }
        else{
            tablewidth = screenSize.width * 0.7
            closesidebarWidth = screenSize.width * 0.3
        }
        isSideViewOpen = true//0
        sideView.frame = CGRect(x: 0, y: screenSize.minY + statusbarheight, width: screenSize.width, height: screenSize.height)
        smallsideview.frame = CGRect(x: 0, y: screenSize.minY , width: 0, height: screenSize.height - 50)
        sideDBTableView.frame = CGRect(x: 0, y: 0 + statusbarheight, width: tablewidth, height: screenSize.height)
        
        CloseSideBarBtn.frame = CGRect(x: screenSize.minX + tablewidth, y: screenSize.minY , width: closesidebarWidth, height: screenSize.height)
        
        UIView.setAnimationDuration(0.3)
        UIView.setAnimationDelegate(self)
        UIView.beginAnimations("TableAnimation", context: nil)//1
        sideView.frame = CGRect(x: 0, y: screenSize.minY + statusbarheight, width:screenSize.width, height: screenSize.height)
        smallsideview.frame = CGRect(x: 0, y:screenSize.minY , width: tablewidth, height: screenSize.height)
        sideDBTableView.frame = CGRect(x: 0, y: 0 + statusbarheight, width: tablewidth, height: screenSize.height)
        CloseSideBarBtn.frame = CGRect(x: screenSize.minX + tablewidth, y: screenSize.minY , width: closesidebarWidth, height: screenSize.height)
        
        UIView.commitAnimations()
        
    }
    
    func hidesideBar() {
        sideDBTableView.isHidden = true
        sideView.isHidden = true
        isSideViewOpen = false
        sideView.frame = CGRect(x: 0, y: screenSize.minY, width: screenSize.width , height: 499)
        smallsideview.frame = CGRect(x: 0, y: screenSize.minY , width: screenSize.width * 0.7, height: screenSize.height)
        sideDBTableView.frame = CGRect(x: 0, y: 0, width: screenSize.width * 0.7, height: screenSize.height)
        CloseSideBarBtn.frame = CGRect(x: screenSize.minX - screenSize.width * 0.7 , y: screenSize.minY , width: screenSize.width * 0.3, height: screenSize.height)
        
        UIView.setAnimationDuration(0.3)
        UIView.setAnimationDelegate(self)
        
        
        UIView.beginAnimations("TableAnimation", context: nil)
        sideView.frame = CGRect(x: 0, y: screenSize.minY, width: 0, height: 499)
        smallsideview.frame = CGRect(x: 0, y: screenSize.minY , width: 0, height: screenSize.height)
        sideDBTableView.frame = CGRect(x: 0, y: 0, width: screenSize.width * 0.7, height: screenSize.height)
        CloseSideBarBtn.frame = CGRect(x: screenSize.minX - screenSize.width * 0.7 , y: screenSize.minY , width: 0, height: screenSize.height)
        UIView.commitAnimations()
    }
    
    func logOutSinchUser() {
        let appDelegate = UIApplication.shared.delegate! as! AppDelegate
//        if let client = appDelegate.client {
//            client.stopListeningOnActiveConnection()
//            client.unregisterPushNotificationDeviceToken()
//            client.terminateGracefully()
//        }
//        appDelegate.client = nil
        
    }
    func checkdocs(){
        
        WebService.IsCheckVerificationDocumentsStatus(queryItems: ["LoginKey": Authentication.token ?? "YXNob2ttaXR0YWxAZ21haWwuY29tOjEyMzQ1Ng=="]) { (result) in
            DispatchQueue.main.async {
                switch result {
                case .success(let response):
                    print(response.message)
                    NavigationHandler.pushTo(.BankAccount)
                case .failure(let error):
                    print(error.message)
                    NavigationHandler.pushTo(.verificationsDocs)
                    
                }
            }
        }
    }
    
    func getAccountDetails() -> Void {
        let queryItems = ["CustomerId": Authentication.customerId ?? "0"]
        WebService.getAccountDetails(queryItems: queryItems) { (result) in
            DispatchQueue.main.async {
                switch result {
                case .success(let response):
                    print(response.message)
                    NavigationHandler.pushTo(.BankAccount)
                case .failure(let error):
                    print(error.message)
                    NavigationHandler.pushTo(.verificationsDocs)
                    
                    
                }
            }
        }
    }
    @IBAction func didTapCloseSideBar(_ sender: Any) {
        hidesideBar()
    }
    
    @IBAction func didTapAboutUs(_ sender: Any) {
    }
    @IBAction func didTapTermsConditions(_ sender: Any) {
    }
    @IBAction func didtapLogout(_ sender: Any) {
        AlertManager.showAlert(type: .custom(HomeScreenTxt.HomeAlerts.LogoutAlert), actionTitle: AlertBtnTxt.okay.localize()) {
            self.logoutUser()
        }
    }
    @IBAction func didtapShare(_ sender: Any) {
        if  Authentication.customerType == EnumUserType.Doctor{
            if isSubscribed {
                NavigationHandler.pushTo(.referralVC)
            }else{
                self.presentAlertWithImageAndMessageForSubscription(msg: HomeScreenTxt.HomeAlerts.SubAlert, img: #imageLiteral(resourceName: "subscription_vg"))
            }
        }else{
            NavigationHandler.pushTo(.referralVC)
        }
        
    }
    
    @IBAction func didtapNotification(_ sender: Any) {
    }

    @IBAction func didtapReffer(_ sender: Any) {
    }
    @IBAction func didtapSharebutton(_ sender: Any) {
        
    }
    
    
    
    
}

// collection view

extension HomeViewController: UICollectionViewDelegate, UICollectionViewDataSource{
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if collectionView == self.SymptomCollectionView{
            return SymptomLabel.count
        }
        else if collectionView == self.SpecialitiesCollectionView{
            return SpLabel.count
            
        }
        else {
            let count = bannerImg.count
            pageControl.numberOfPages = count
            pageControl.isHidden = !(count > 1)
            return count
        }
        
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "Cell", for: indexPath) as! CommonSymptomsCollectionView
        if collectionView == SymptomCollectionView{
            
            cell.symptomImage.image = SymptomImg[indexPath.row]
            cell.symptomLabel.text = SymptomLabel[indexPath.row].localize()
            return cell
        }else if collectionView == SpecialitiesCollectionView{
            
            cell.spImage.image = SpImg[indexPath.row]
            cell.spLabel.text = self.SpLabel[indexPath.row].localize()
//            cell.spLabel.font = UIFont.systemFont(ofSize: Authentication.appLanguage == EnumAppLanguage.English ? 10 : 6)
            return cell
        }
        else
        {
            
            cell.bannerView.backgroundColor = bannerBgColor[indexPath.row]
            cell.BannerImg.image = bannerImg[indexPath.row]
            cell.topLabelBanner.text = bannerTopLabel[indexPath.row].localize()
            cell.bottomLabelBanner.text = bannerBottomLabel[indexPath.row].localize()
        }
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        if collectionView == BannerCollectionView{
            self.pageControl.currentPage = indexPath.item
            
        }
    }
    
    
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if collectionView == SpecialitiesCollectionView {
//            print(self.SpValue[indexPath.row])
//            print(self.insuranceListforSearch)
            NavigationHandler.pushTo(.homeWithParam(self.SpValue[indexPath.row],self.insuranceListforSearch))
        }
        else if collectionView == SymptomCollectionView {
//            print(self.CsValue[indexPath.row])
//            print(self.insuranceListforSearch)
            NavigationHandler.pushTo(.homeWithParam(self.CsValue[indexPath.row],self.insuranceListforSearch))
        }
        else{
            NavigationHandler.pushTo(.homeWithInsurance(self.insuranceListforSearch))
        }
        
    }
}

extension HomeViewController: UICollectionViewDelegateFlowLayout{
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        if collectionView == SymptomCollectionView{
            if collectionView.frame.width > 400{
                let width = collectionView.frame.width/6
                return CGSize(width: width - 2, height: 120 )
            }
            else{
                let width = collectionView.frame.width/5
                let height = collectionView.frame.height/2
                return CGSize(width: width - 2, height: 100 )
            }
        }
        else if collectionView == SpecialitiesCollectionView{
            let height = collectionView.frame.height
            let width = collectionView.frame.width/4.2
            return CGSize(width: width - 2, height: height)
        }
        else   {
            
            func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
                
                var PageNumber = scrollView.contentOffset.x / scrollView.frame.width
                pageControl.currentPage = Int(PageNumber)
                
                
            }
            func updatePageNumber(scrollView: UIScrollView) {
                // If not case to `Int` will give an error.
                updatePageNumber(scrollView: scrollView)
            }
            func scrollViewDidEndScrollingAnimation(_ scrollView: UIScrollView) {
                // This will be call when you scrolls it programmatically.
                updatePageNumber(scrollView: scrollView)
            }
            let collectionwidth = collectionView.bounds.width
            let collectionheight = collectionView.bounds.height
            return CGSize(width: collectionwidth - 2, height: collectionheight - 2)
        }
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: 0,left: 0,bottom: 10,right: 0)
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 2
    }
    
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 2
    }
    
}

extension UICollectionView {
    
    
    
    func scrollToNextItem() {
        let contentOffset = CGFloat(floor(self.contentOffset.x + self.bounds.size.width))
        self.moveToFrame(contentOffset: contentOffset)
        
        
    }
    
    func scrollToPreviousItem() {
        let contentOffset = CGFloat(floor(self.contentOffset.x - self.bounds.size.width))
        self.moveToFrame(contentOffset: contentOffset)
    }
    
    func moveToFrame(contentOffset : CGFloat) {
        self.setContentOffset(CGPoint(x: contentOffset, y: self.contentOffset.y), animated: true)
    }
}

//Insurance extention

extension HomeViewController : UIPopoverPresentationControllerDelegate ,InsuranceSearchVCDelegate ,UITextFieldDelegate{
    func selectedInsurance(planName: String, planID: Int, providerID: Int, isAccepted: Bool) {
        self.insuranceTF.text = planName
        self.insurancePlanID = planID
    }
    func textFieldDidBeginEditing(_ textField: UITextField) {
        if textField == insuranceTF{
            resignFirstResponder()
        }
        else if textField == nameTextfield {
            
        }
    }
    func getinsurancesProvidersList(){
        let queryItems = ["":""]
        self.view.activityStartAnimating(activityColor: .themeGreen, backgroundColor: UIColor.white)
        WebService.insurancesProvidersAndPlans(queryItems: queryItems) { (result) in
            DispatchQueue.main.async {
                switch result {
                case .success(let response):
                    self.insuranceListforSearch = response.objects?.filter({/$0.InsurancesPlansList?.count>0}) ?? []
                case .failure(let error):
                    AlertManager.showAlert(type: .custom(error.message))
                }
                self.view.activityStopAnimating()
            }
        }
    }
}

extension HomeViewController {
    
    func startTimer() {
        _ =  Timer.scheduledTimer(timeInterval: 3.0, target: self, selector: #selector(self.scrollAutomatically), userInfo: nil, repeats: true)
        
    }
    
    @objc func scrollAutomatically(_ timer1: Timer) {
        
        if let coll  = BannerCollectionView {
            
            for cell in coll.visibleCells {
                
                let indexPath: IndexPath? = coll.indexPath(for: cell)
                
                if ((indexPath?.row)! < bannerImg.count - 1){
                    
                    let indexPath1: IndexPath?
                    
                    indexPath1 = IndexPath.init(row: (indexPath?.row)! + 1, section: (indexPath?.section)!)
                    
                    coll.scrollToItem(at: indexPath1!, at: .centeredHorizontally, animated: true)
                    
                }
                
                else{
                    
                    let indexPath1: IndexPath?
                    
                    indexPath1 = IndexPath.init(row: 0, section: (indexPath?.section)!)
                    
                    coll.scrollToItem(at: indexPath1!, at: .centeredHorizontally, animated: true)
                    
                }
                
            }
            
        }
        
    }
    
}






