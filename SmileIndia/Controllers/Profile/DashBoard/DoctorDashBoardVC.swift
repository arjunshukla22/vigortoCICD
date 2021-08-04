//
//  DoctorDashBoardVC.swift
//  SmileIndia
//
//  Created by Arjun  on 11/03/20.
//  Copyright © 2020 Na. All rights reserved.
//

import UIKit


class DoctorDashBoardVC: BaseViewController,UICollectionViewDataSource,UICollectionViewDelegate , UICollectionViewDelegateFlowLayout  {
    
    
    @IBOutlet weak var btnBack: UIButton!
    var doctor: DoctorData?
    var rewards: Rewards?
    var paymentStatus : Bool?
    var accountDetails = [AccountDetails]()


    @IBOutlet weak var rewardsBtn: UIButton!
    
    @IBOutlet weak var lblName: UILabel!
    @IBOutlet weak var dbCollection: UICollectionView!
    let dblArray = ["My Profile","Subscription","Appointments","My Calendar","Prescription Template","Find a Doctor","Manage Account","Client Ratings","Contact Us","Share","Change Password","About Us","SMILEi Credits","Logout"]
   
 
    let colorArray = [#colorLiteral(red: 0.9725490196, green: 0.8666666667, blue: 0.2352941176, alpha: 1),#colorLiteral(red: 0.9607843137, green: 0.7960784314, blue: 0.6549019608, alpha: 1),#colorLiteral(red: 0.6392156863, green: 0.9215686275, blue: 0.5647058824, alpha: 1),#colorLiteral(red: 0.9882352941, green: 0.6588235294, blue: 0.6588235294, alpha: 1),#colorLiteral(red: 0.537254902, green: 0.8862745098, blue: 1, alpha: 1),#colorLiteral(red: 0.5058823529, green: 0.7137254902, blue: 1, alpha: 1),#colorLiteral(red: 1, green: 0.9098039216, blue: 0.5803921569, alpha: 1),#colorLiteral(red: 0.9900509715, green: 0.6966494322, blue: 0.1693406701, alpha: 1),#colorLiteral(red: 0.8745098039, green: 0.8745098039, blue: 0.8745098039, alpha: 1),#colorLiteral(red: 0.3921568627, green: 0.9568627451, blue: 0.8156862745, alpha: 1),#colorLiteral(red: 0.6784313725, green: 0.7019607843, blue: 0.9960784314, alpha: 1),#colorLiteral(red: 0.8549019608, green: 0.968627451, blue: 0.6509803922, alpha: 1),#colorLiteral(red: 0.7254901961, green: 0.9568627451, blue: 0.9176470588, alpha: 1),#colorLiteral(red: 0.9921568627, green: 0.6980392157, blue: 0.9333333333, alpha: 1)]
    let imgArray = [#imageLiteral(resourceName: "doctor_prfile"),#imageLiteral(resourceName: "prescription"),#imageLiteral(resourceName: "appointsment"),#imageLiteral(resourceName: "mycalendar"),#imageLiteral(resourceName: "prescription"),#imageLiteral(resourceName: "find-doctor"),#imageLiteral(resourceName: "payments"),#imageLiteral(resourceName: "rating"),#imageLiteral(resourceName: "contact"),#imageLiteral(resourceName: "share"),#imageLiteral(resourceName: "changepassword"),#imageLiteral(resourceName: "AboutUs"),#imageLiteral(resourceName: "credit"),#imageLiteral(resourceName: "logout")]
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        setStatusBar(color: #colorLiteral(red: 0.233, green: 0.816, blue: 0.538, alpha: 1))
        getRewards()
        getAccountDetails()
        
        dbCollection.register(UINib(nibName: "DoctoDashBoardCell", bundle: nil), forCellWithReuseIdentifier: "DoctoDashBoardCell")
        
        if  Authentication.customerType == "Doctor"{
            btnBack.isHidden = true
        }
          
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        
        updateuserData()
        NotificationCenter.default.addObserver(self, selector: #selector(self.accountNotificationReceived(notification:)), name: Notification.Name("accountdetails"), object: nil)
        
//        DispatchQueue.main.asyncAfter(deadline: .now()+5.0) {
//            let appDelegate = UIApplication.shared.delegate! as! AppDelegate
//            weak var call = appDelegate.callKitProvider?.currentEstablishedCall()
//            if call != nil {
//              NavigationHandler.pushTo(.callVC(call))
//            }
//        }

    }

    
    @objc func accountNotificationReceived(notification: Notification){
        getAccountDetails()
    }
    
    //this method is for the size of items
        func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
            let width = collectionView.frame.width/3
         //   let height : CGFloat = 180.0
            return CGSize(width: width, height: width + 30)
        }
        //these methods are to configure the spacing between items

        func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
            return UIEdgeInsets(top: 0,left: 0,bottom: 0,right: 0)
        }

        func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
            return 0
        }

        func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
            return 0
        }
        

     func numberOfSections(in collectionView: UICollectionView) -> Int {
                   return 1
        }

     func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
               
         return dblArray.count
        }

            
            
      func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
           let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "DoctoDashBoardCell", for: indexPath) as! DoctoDashBoardCell
        cell.viewDb.backgroundColor = colorArray[indexPath.item]
        cell.lblDb.text = dblArray[indexPath.item]
        cell.imgDb.image = imgArray[indexPath.item]
        return cell;
               
       }
      
      func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if indexPath.item == 0 {
            
            if Authentication.customerType == "Hospital" {
                AlertManager.showAlert(type: .custom("Please visit https://www.smileindia.com to manage your profile."))
                return
            }
           NavigationHandler.pushTo(.doctorProfileOne)

        }else if indexPath.item == 1{
            PaidDoctorPlans()
        }else if indexPath.item == 2
            {
                if accountDetails.count == 0 {
                               AlertManager.showAlert(type: .custom("Update your account details first to receive payments.")) {
                               NavigationHandler.pushTo(.paymentViewController)
                               }
                           }else{
                               NavigationHandler.pushTo(.appointmentList("0"))
                           }
              
            }

        else if indexPath.item == 3{
            NavigationHandler.pushTo(.eAppointmentsList)
          

        }else if indexPath.item == 4{
             NavigationHandler.pushTo(.calendar)
           // NavigationHandler.pushTo(.referralVC)
        }else if indexPath.item == 5{
             NavigationHandler.pushTo(.prescriptionList)
          //  NavigationHandler.pushTo(.ratingList)
        }else if indexPath.item == 6{
              NavigationHandler.pushTo(.home)
          //  NavigationHandler.pushTo(.calendar)
        }else if indexPath.item == 7
        {
            NavigationHandler.pushTo(.paymentViewController)
        }
            else if indexPath.item == 8{
           
             NavigationHandler.pushTo(.ratingList)
            //NavigationHandler.pushTo(.changePassword)
        }else if indexPath.item == 9{
            NavigationHandler.pushTo(.contactUs)
        }else if indexPath.item == 10{
            NavigationHandler.pushTo(.referralVC)
           // NavigationHandler.pushTo(.prescriptionList)
        }else if indexPath.item == 11{
             NavigationHandler.pushTo(.changePassword)
          //  NavigationHandler.pushTo(.contactUs)
        }else if indexPath.item == 12{
             NavigationHandler.pushTo(.aboutus)
        
       }else{
            AlertManager.showAlert(type: .custom(HomeScreenTxt.HomeAlerts.LogoutAlert.localize()), actionTitle: AlertBtnTxt.okay.localize()) {
                Authentication.clearData()
                NavigationHandler.logOut()
                self.logOutSinchUser()
            }
        }
          
      }
 
    @IBAction func didTapRewards(_ sender: UIButton) {
    AlertManager.showAlert(type: .custom("You have earned  \(rewards?.Earnedpoints ?? 0) Reward Points"))
    }
    

    @IBAction func didTapBack(_ sender: UIButton) {
        NavigationHandler.pop()
    }
    func PaidDoctorPlans() -> Void {
           let queryItems = ["CustomerGuid": "\(Authentication.customerGuid!)"]
           self.view.activityStartAnimating(activityColor: .themeGreen, backgroundColor: UIColor.white)
           WebService.paidDoctorPlans(queryItems: queryItems) { (result) in
                    DispatchQueue.main.async {
                       switch result {
                               
                           case .success(let response):
                            //  print(response.object?.PaymentStatus)
                            if response.object?.SubscriptionStatus == true {
                                if
                                      response.object?.PaymentStatus == true{
                                        NavigationHandler.pushTo(.drPlanDetails("1"))
                                 
                                  }
                                  else {
                                  
                                  NavigationHandler.pushTo(.subscriptionPaymentVC)}
                            }
                            else{
                        NavigationHandler.pushTo(.subscriptionVC)
                        }
                             
                           case .failure:
                               NavigationHandler.pushTo(.subscriptionVC)
                            
                           }
                       self.view.activityStopAnimating()
                   }
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
    
    func updateuserData() -> Void {
        let queryItems = ["AuthKey": Constants.authKey,
                          "UserEmail": Authentication.customerEmail ?? "",
            "Password": Authentication.customerPassword ?? ""] as [String : Any]
        self.view.activityStartAnimating(activityColor: .themeGreen, backgroundColor: UIColor.white)
        WebService.loginUser(queryItems: queryItems) { (result) in
            DispatchQueue.main.async {
                switch result {
                case .success(let response):
                    if let user = response.object {
                        Authentication.authenticateUser(user,Authentication.customerPassword ?? "", user.CustomerGuid ?? "", Authentication.customerEmail ?? "", true)
                        self.saveToken(user.CustomerGuid ?? "")
                    } else { self.showError(message: response.message ?? "")  }
                case .failure(let error):
                    self.showError(message: error.message) }
                self.view.activityStopAnimating()
            }
        }
    }
    
   func saveToken(_ uid: String) {
       let queryItems = ["CustomerUID": uid,
                         "DeviceToken": Authentication.deviceToken ?? "", "DeviceType": "I"] as [String : Any]
    self.view.activityStartAnimating(activityColor: .themeGreen, backgroundColor: UIColor.white)
       WebService.saveToken(queryItems: queryItems) { (result) in
           DispatchQueue.main.async {
               switch result {
               case .success:
                DispatchQueue.main.async {
                    self.lblName.text = "Hi  \(Authentication.customerName ?? "") "
                }
               case .failure(let error):
                   self.showError(message: error.message) }
            self.view.activityStopAnimating()
           }
       }
   }
    
    
    func getRewards(){
        WebService.getrewardsData(queryItems: ["LoginKey": Authentication.token ?? "YXNob2ttaXR0YWxAZ21haWwuY29tOjEyMzQ1Ng=="]) { (result) in
            DispatchQueue.main.async {
                switch result {
                case .success(let response):
                    if let user = response.object {
                        self.rewards = user
                       self.setUI()
                    } else {
                    }
                case .failure(let error):
                    print(error.message)
                    self.showError(message: error.message)
                }
            }
        }
    }
    func setUI() {
        rewardsBtn.setTitle("  \(rewards?.Earnedpoints ?? 0) Points", for: .normal)
    }
    
    
    func logOutSinchUser() {
        let appDelegate = UIApplication.shared.delegate! as! AppDelegate
        if let client = appDelegate.client {
            client.stopListeningOnActiveConnection()
            client.unregisterPushNotificationDeviceToken()
            client.terminateGracefully()
        }
        appDelegate.client = nil

    }
    
    
    func getAccountDetails() -> Void {
        let queryItems = ["CustomerId": Authentication.customerId ?? "0"]
        WebService.getAccountDetails(queryItems: queryItems) { (result) in
         DispatchQueue.main.async {
                switch result {
                case .success (let response):
                    print(response.status!)
                    for account in response.objects! {
                        self.accountDetails.append(account)
                    }
                    if response.objects?.count == 0 {
                        AlertManager.showAlert(type: .custom("Update your account details first to receive payments.")) {
                                NavigationHandler.pushTo(.paymentViewController)
                        }
                    }
                case .failure(let error):
                    print(error)
                    AlertManager.showAlert(type: .custom("Update your account details first to receive payments.")) {
                            NavigationHandler.pushTo(.paymentViewController)
                    }
                }
            }
        }
    }
}
