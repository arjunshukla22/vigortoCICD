//
//  EAppointmentsVC.swift
//  SmileIndia
//
//  Created by Arjun  on 02/04/20.
//  Copyright © 2020 Na. All rights reserved.
//

import UIKit

import UserNotifications


class EAppointmentsVC: UIViewController {
    
    @IBOutlet weak var cntView: UIView!
    @IBOutlet weak var lblTimer: UILabel!
    
    @IBOutlet weak var userName: UILabel!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var apnmntDateLabel: UILabel!
    @IBOutlet weak var timeLabel: UILabel!
    @IBOutlet weak var bkngDateLabel: UILabel!
    @IBOutlet weak var reasonLabel: UILabel!
    
    @IBOutlet weak var emailLabel: UILabel!
    
    @IBOutlet weak var ageLabel: UILabel!
    @IBOutlet weak var btnAudioCall: UIButton!
    @IBOutlet weak var btnVideoCall: UIButton!
    
    @IBOutlet weak var relationLabel: UILabel!
    @IBOutlet weak var patientNameLabel: UILabel!
    
    var  object: Appointment?
    var callType : Bool?

    var  timeDifference: TimeDifference?

    var appointments = [Appointment]()
    var videoAppointments = [Appointment]()

    var destination = "smiletest02@gmail.com"
    
    var msg = AppointmentScreenTxt.emsg.localize()

    
    var timer: Timer?
    var totalTime = 0
    
    var appId = 0
    
    
    var permissionCheck = true
    

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        setStatusBar(color: .themeGreen)
        

         //   getMintuesDifference(currentTime: "\(Date().string(format: "M/d/yyyy h:mm:ss a"))", apntTime: self.object?.AppointmentDateTime ?? "")
            self.mintuesDifference(apntId: "\(self.object?.Id ?? 0)")
          //  self.getLatestAppointment()
        print("\(self.object?.Id ?? 0)" , "\(self.object?.AppointmentDateTime ?? "nothing")")
            self.updateButons(status: false, alpha: 0.5)
            self.cntView.isHidden = true
            self.btnVideoCall.isHidden = (Authentication.customerType == "Customer")
            self.btnAudioCall.isHidden = (Authentication.customerType == "Customer")
        

    }
    
    override func viewWillAppear(_ animated: Bool) {
//        self.checkCameraAccess()
//        self.checkMicAccess()
        self.checkNotificationsAccess()
    }

    func checkNotificationsAccess(){
        if #available(iOS 10.0, *) {
           let current = UNUserNotificationCenter.current()
           current.getNotificationSettings(completionHandler: { settings in

               switch settings.authorizationStatus {

               case .notDetermined:
                self.permissionDenied(text: "Notifications")
                self.permissionCheck = false
                   // Authorization request has not been made yet
               case .denied:
                self.permissionDenied(text: "Notifications")
                self.permissionCheck = false
                   // User has denied authorization.
                   // You could tell them to change this in Settings
               case .authorized:
                   // User has given authorization.
                print("Authorized, proceed")
               case .provisional:
                break
               case .ephemeral:
                break



            }
           })
        } else {
            // Fallback on earlier versions
            if UIApplication.shared.isRegisteredForRemoteNotifications {
                print("APNS-YES")
            } else {
                print("APNS-NO")
                self.permissionDenied(text: "Notifications")
                self.permissionCheck = false

            }
        }
    }
//    func checkMicAccess(){
//        switch AVCaptureDevice.authorizationStatus(for: .audio) {
//        case .denied:
//            print("Denied, request permission from settings")
//            self.permissionDenied(text: "Microphone")
//            self.permissionCheck = false
//
//        case .restricted:
//            print("Restricted, device owner must approve")
//            self.permissionDenied(text: "Microphone")
//            self.permissionCheck = false
//
//        case .authorized:
//            print("Authorized, proceed")
//        case .notDetermined:
//            AVCaptureDevice.requestAccess(for: .video) { success in
//                if success {
//                    print("Permission granted, proceed")
//                } else {
//                    print("Permission denied")
//                    self.permissionDenied(text: "Microphone")
//                    self.permissionCheck = false
//
//                }
//            }
//        }
//    }
    
//    func checkCameraAccess() {
//        switch AVCaptureDevice.authorizationStatus(for: .video) {
//        case .denied:
//            print("Denied, request permission from settings")
//            self.permissionDenied(text: "Camera")
//            self.permissionCheck = false
//
//        case .restricted:
//            print("Restricted, device owner must approve")
//            self.permissionDenied(text: "Camera")
//            self.permissionCheck = false
//
//        case .authorized:
//            print("Authorized, proceed")
//        case .notDetermined:
//            AVCaptureDevice.requestAccess(for: .video) { success in
//                if success {
//                    print("Permission granted, proceed")
//                } else {
//                    print("Permission denied")
//                    self.permissionDenied(text: "Camera")
//                    self.permissionCheck = false
//
//                }
//            }
//        }
//    }
    
    func permissionDenied(text:String){
        DispatchQueue.main.async{
                var alertText = "\(AppointmentScreenTxt.callpermissionAlertPart1.localize()) \(text)\(AppointmentScreenTxt.callpermissionAlertPart2.localize())"

                var alertButton = AlertBtnTxt.okay.localize()
                var goAction = UIAlertAction(title: alertButton, style: .default, handler: nil)

                if UIApplication.shared.canOpenURL(URL(string: UIApplication.openSettingsURLString)!){
                    alertText = "\(AppointmentScreenTxt.callpermissionAlertPart1.localize()) \(text)\(AppointmentScreenTxt.callpermissionAlertPart2.localize())"
                    alertButton = AppointmentScreenTxt.go.localize()


                    goAction = UIAlertAction(title: alertButton, style: .default, handler: {(alert: UIAlertAction!) -> Void in
                        UIApplication.shared.open(URL(string: UIApplication.openSettingsURLString)!, options: [:], completionHandler: nil)
                    })
                }

                let alert = UIAlertController(title: AppointmentScreenTxt.permissionAlertTitle.localize(), message: alertText, preferredStyle: .alert)
                alert.addAction(goAction)
                self.present(alert, animated: true, completion: nil)
        }
    }

    
//    private func getPrivacyAccess(){
//        let vStatus = AVCaptureDevice.authorizationStatus(for: .video)
//        if(vStatus == AVAuthorizationStatus.notDetermined){
//            AVCaptureDevice.requestAccess(for: .video, completionHandler: { (granted: Bool) in
//            })
//        }
//        let aStatus = AVCaptureDevice.authorizationStatus(for: .audio)
//        if(aStatus == AVAuthorizationStatus.notDetermined){
//            AVCaptureDevice.requestAccess(for: .audio, completionHandler: { (granted: Bool) in
//            })
//        }
//    }
    
 /*  override func viewWillAppear(_ animated: Bool) {
       NotificationCenter.default.addObserver(self, selector: #selector(self.callAppIdNotificationReceived(notification:)), name: Notification.Name("callAppId"), object: nil)
     }
        
   @objc func callAppIdNotificationReceived(notification: Notification){
    let userInfo = notification.object as! NSDictionary
    manageConfirmAppointment("\(userInfo["appId"] as! Int)")
    }
    
    func manageConfirmAppointment(_ appID: String)
    {
        let queryItems = ["id": appID] as [String: Any]
        activityIndicator.showLoaderOnWindow()
        WebService.manageConfirmedAppointments(queryItems: queryItems) { (result) in
            DispatchQueue.main.async {
                activityIndicator.hideLoader()
                switch result {
                case .success(let response):
                    AlertManager.showAlert(type: .custom("Appointment moved successfully to complete section.")) {
                            NavigationHandler.pop()
                    }
                    print(response)
                case .failure(let error):
                    AlertManager.showAlert(type: .custom(error.message)) {
                            NavigationHandler.pop()
                    }
                    
                }
            }
        }
    } */

    private func startOtpTimer() {
        if totalTime < 0
        {
            self.timer = Timer.scheduledTimer(timeInterval: 1.0, target: self, selector: #selector(updateTimer), userInfo: nil, repeats: true)
        }else{
            DispatchQueue.main.async {
                self.lblTimer.text = Authentication.customerType == "Doctor" ? AppointmentScreenTxt.appStartedPart1.localize() : "\(AppointmentScreenTxt.appStartedPart2.localize()) \(self.object?.AppointmentDateTime?.replacingOccurrences(of: "/", with: "-") ?? "") , \(self.object?.DoctorTimeZoneId ?? "")"
                self.updateButons(status: true, alpha: 1.0)
            }
        }
        
       }
    


    @objc func updateTimer() {
//        if Authentication.customerType == "Customer"{
//            self.lblTimer.text = "Please wait Doctor will call you at \(self.object?.AppointmentDateTime?.replacingOccurrences(of: "/", with: "-") ?? "") , \(self.object?.DoctorTimeZoneId ?? "")"
//        }else{
//            self.lblTimer.text = msg + self.timeFormatted(self.totalTime) // will show timer
//        }
        
        self.lblTimer.text = msg + self.timeFormatted(self.totalTime) // will show timer

            if totalTime != 0 {
                totalTime += 1
            } else {
                if let timer = self.timer {
                    DispatchQueue.main.async {
                        timer.invalidate()
                        self.timer = nil
                        self.lblTimer.text = Authentication.customerType == "Doctor" ? AppointmentScreenTxt.appStartedPart1.localize() : "\(AppointmentScreenTxt.appStartedPart2.localize()) \(self.object?.AppointmentDateTime?.replacingOccurrences(of: "/", with: "-") ?? "") , \(self.object?.DoctorTimeZoneId ?? "")"
                        self.updateButons(status: true, alpha: 1.0)
                    }
                }
            }
        }
    func timeFormatted(_ totalSeconds: Int) -> String {
        let seconds: Int = totalSeconds % 60
        let minutes: Int = (totalSeconds / 60) % 60
        let hours: Int = (totalSeconds / 3600)

        return String(format: "%02d:%02d:%02d",hours,minutes, seconds).replacingOccurrences(of: "-", with: "")
    }
    @IBAction func didTapBack(_ sender: Any) {
        timer?.invalidate()
        NavigationHandler.pop()
    }
    
    @IBAction func didTapAudioCall(_ sender: UIButton) {
//            if self.client.isStarted(){
//                 weak var call: SINCall? = client.call()?.callUser(withId: destination)
//                NavigationHandler.pushTo(.callingVC(call,appId))
//             }
        if permissionCheck == true{
            NavigationHandler.pushTo(.enxVideoCalls(self.object!, true))
        }else{
            self.permissionDenied(text: "Camera/Microphone/Notifications")
        }
    }
    
    @IBAction func didTapVideoCall(_ sender: UIButton) {
   //     let appdel = UIApplication.shared.delegate as? AppDelegate
  //      appdel?.callManager.startCall(handle: self.object?.MemberPhone ?? "", roomID: self.object?.Room_Id ?? "", local: self.object?.ProviderEmail ?? "", remote: self.object?.MemberEmail ?? "" ,obj : self.object)
        if permissionCheck == true{
            NavigationHandler.pushTo(.enxVideoCalls(self.object!,false))
        }else{
            self.permissionDenied(text: "Camera/Microphone/Notifications")
        }
        //Triger Call
//        if self.client.isStarted(){
//                 weak var call: SINCall? = client.call().callUserVideo(withId: destination)
//                 NavigationHandler.pushTo(.callingVC(call,appId))
//             }
    }
     
    func getLatestAppointment() -> Void {
        self.lblTimer.isHidden = false
        let apnmtDate = object?.AppointmentDateTime?.replacingOccurrences(of: "/", with: "-")
                
        let previousDate = convertDateFormat(inputDate: apnmtDate ?? "")
        let now = Date()
        let nowDate = Calendar.current.dateComponents([.day, .year, .month], from: now)
        let prevDate = Calendar.current.dateComponents([.day, .year, .month], from: previousDate)

            
        if nowDate == prevDate {
                    
                    let nowHour = Calendar.current.dateComponents([.minute,.hour,.day, .year, .month], from: now)
                    let prevHour = Calendar.current.dateComponents([.minute,.hour,.day, .year, .month], from: previousDate)
            
            print((nowHour.hour!-prevHour.hour!)*60 , (nowHour.minute! - prevHour.minute!))
            print((nowHour.hour!-prevHour.hour!)*60 + (nowHour.minute! - prevHour.minute!))
            
            totalTime = ((nowHour.hour!-prevHour.hour!)*60 + (nowHour.minute! - prevHour.minute!))*60
                    
            appId = object?.Id ?? 0
            DispatchQueue.main.async {
                self.setupUI(apnmt: self.object)
            }
            
        }else{
            cntView.isHidden = true
            self.lblTimer.text = ""
            AlertManager.showAlert(type: .custom(AppointmentScreenTxt.appointmentnotAvaliable.localize())){
                    NavigationHandler.pushTo(.contactUs)
            }
        }
    }
    
    func convertDateFormat(inputDate: String) -> Date {
         let olDateFormatter = DateFormatter()
         olDateFormatter.dateFormat = "M-d-yyyy h:mm:ss a"
         let convertDateFormatter = DateFormatter()
         convertDateFormatter.dateFormat = "M-d-yyyy h:mm:ss a"
         let newDate = convertDateFormatter.date(from: inputDate)
         return newDate ?? Date()
    }
    
    func setupUI(apnmt:Appointment?) -> Void {

        startOtpTimer()
        cntView.isHidden = false
        destination = Authentication.customerType == "Doctor" ? apnmt?.MemberEmail ?? "" : apnmt?.ProviderEmail ?? ""
        self.userName.text = Authentication.customerType == "Doctor" ? AppointmentScreenTxt.membersName.localize() : AppointmentScreenTxt.doctorsName.localize()
        self.nameLabel.text =  Authentication.customerType == "Doctor" ? apnmt?.MemberName ?? "" : apnmt?.ProviderName ?? ""
        self.apnmntDateLabel.text = "\(self.getFormattedDate(strDate: apnmt?.AppointmentDateTime?.components(separatedBy: " ").first ?? "", currentFomat: "MM/dd/yyyy", expectedFromat: "dd-MMM-yyyy"))" + " ,( " + "\(apnmt?.DoctorTimeZoneId ?? "")" + " )"
        self.timeLabel.text = apnmt?.AppointmentTime
        self.bkngDateLabel.text = self.getFormattedDate(strDate: apnmt?.BookingDate?.components(separatedBy: " ").first ?? "", currentFomat: "MM/dd/yyyy", expectedFromat: "dd-MMM-yyyy")
        self.ageLabel.text = "\(apnmt?.Age ?? 0)"

        self.attributingWithColorForVC(label: self.reasonLabel, boldTxt: AppointmentScreenTxt.reason.localize(), regTxt: apnmt?.Reason ?? "", color: #colorLiteral(red: 0.2329064608, green: 0.8156263828, blue: 0.5380559564, alpha: 1), fontSize: 12, firstFontWeight: .semibold, secFontWeight: .regular)

        if Authentication.customerType == "Doctor" {
            self.addAttributesToTextForVC(label: self.emailLabel, boldTxt: AppointmentScreenTxt.email.localize(), regTxt: apnmt?.MemberEmail ?? "", fontSize: 12, firstFontWeight: .semibold, secFontWeight: .regular)
         }else {
            self.addAttributesToTextForVC(label: self.emailLabel, boldTxt: AppointmentScreenTxt.email.localize(), regTxt: apnmt?.ProviderEmail ?? "", fontSize: 12, firstFontWeight: .semibold, secFontWeight: .regular)
         }
        
        self.patientNameLabel.text = self.object?.OtherPatinetName ?? self.object?.MemberName
        self.relationLabel.text = self.object?.OtherPatientRelation ?? "Self"
        
        if totalTime > 1800 {
            DispatchQueue.main.async {
                self.lblTimer.text = ""
                self.updateButons(status: false, alpha: 0.5)

                AlertManager.showAlert(type: .custom(AppointmentScreenTxt.appointmentnotAvaliable.localize())){
                    NavigationHandler.pushTo(.contactUs)
                }
            }
        }
    }
    
    func updateButons(status:Bool,alpha:CGFloat) -> Void {
        self.btnVideoCall.isEnabled=status
        self.btnVideoCall.alpha=alpha
        self.btnAudioCall.isEnabled=status
        self.btnAudioCall.alpha=alpha
    }
    
    func getMintuesDifference(currentTime:String,apntTime:String){
        let queryItems = ["CurrentTime":currentTime ,"AppointmentDateAndTime":apntTime]
           self.view.activityStartAnimating(activityColor: .themeGreen, backgroundColor: UIColor.white)
           WebService.getMintuesDifference(queryItems: queryItems) { (result) in
               DispatchQueue.main.async {
                   activityIndicator.hideLoader()
                   switch result {
                   case .success(let response):
                    self.timeDifference = response.object
                    self.totalTime = Int(response.object?.TotalSeconds ?? 0.0)
                    self.setupUI(apnmt: self.object)
                   case .failure:
                       AlertManager.showAlert(type: .custom(AppointmentScreenTxt.appointmentnotAvaliable.localize())){
                           NavigationHandler.pushTo(.contactUs)
                       }
                }
                self.view.activityStopAnimating()
               }
           }
       }
    
    func mintuesDifference(apntId:String){
        let queryItems = ["AppointmentId":apntId]
           self.view.activityStartAnimating(activityColor: .themeGreen, backgroundColor: UIColor.white)
           WebService.mintuesDifference(queryItems: queryItems) { (result) in
               DispatchQueue.main.async {
                   activityIndicator.hideLoader()
                   switch result {
                   case .success(let response):
                    self.timeDifference = response.object
                    self.totalTime = Int(response.object?.TotalSeconds ?? 0.0)
                    self.setupUI(apnmt: self.object)
                   case .failure:
                       AlertManager.showAlert(type: .custom(AppointmentScreenTxt.appointmentnotAvaliable.localize())){
                           NavigationHandler.pushTo(.contactUs)
                       }
                }
                self.view.activityStopAnimating()
               }
           }
       }

}


extension Date {
    func string(format: String) -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = format
        return formatter.string(from: self)
    }
}
