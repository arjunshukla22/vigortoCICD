//
//  EnterOtpVC.swift
//  SmileIndia
//
//  Created by Arjun  on 09/04/20.
//  Copyright © 2020 Na. All rights reserved.
//

import UIKit

class EnterOtpVC: UIViewController {
    
    @IBOutlet weak var otpView: UIView!
    
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var bookingDateLabel: UILabel!
    @IBOutlet weak var reasonLabel: UILabel!
    @IBOutlet weak var timeLabel: UILabel!
    
   // @IBOutlet weak var phoneLabel: UILabel!
    @IBOutlet weak var ageLabel: UILabel!
    
    
    @IBOutlet weak var otpLabel: UILabel!
    @IBOutlet weak var otpTf: UITextField!
    @IBOutlet weak var resendView: UIView!
    
    var reachability : Reachability {
        let reachability = Reachability()!
        return reachability
    }
    
    var otp = ""
    var  object: Appointment?
    
    var timer: Timer?
    var totalTime = 0
    
    var differeneceInTime = 0

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        setStatusBar(color: #colorLiteral(red: 0.233, green: 0.816, blue: 0.538, alpha: 1))
        hideKeyboardWhenTappedAround()

        setupUI(apnmt: object)
        
       // getTimeDifference()
        
    }
    
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        
        if self.object?.PaymentType == 3 || self.object?.PaymentType == 4{
            self.otpView.isHidden = true
            self.manageConfirmAppointment("\(self.object?.Id ?? 0)")
        }else{
            if self.object?.MeetType == 1{
                self.otpView.isHidden = false
                getOtp(apnmtId: "\(self.object?.Id ?? 0)", fromapp: "true")
            }else{
                self.otpView.isHidden = true
                self.manageConfirmAppointment("\(self.object?.Id ?? 0)")
            }
        }
    }
    
    @IBAction func didtapBack(_ sender: Any) {
        NavigationHandler.pop()
    }
    
    @IBAction func didtapSubmit(_ sender: Any) {
        
        if otpTf.text!.isEmpty || otpTf.text?.count != 4 {
            AlertManager.showAlert(type: .custom(AppointmentScreenTxt.otpRequired.localize()))
        }else if (otpTf.text?.count == 4) && (otpTf.text == otp)
        {
            manageConfirmAppointment("\(self.object?.Id ?? 0)")
        }else{
            AlertManager.showAlert(type: .custom(AppointmentScreenTxt.invalidOTP.localize()))
        }
    }
    
    @IBAction func didtapResend(_ sender: Any) {
        getOtp(apnmtId: "\(self.object?.Id ?? 0)", fromapp: "true")
    }
    
    
    func getTimeDifference() -> Void {
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
            
            differeneceInTime = ((nowHour.hour!-prevHour.hour!)*60 + (nowHour.minute! - prevHour.minute!))*60

            
        }else{
            // Compare them
            switch now.compare(previousDate) {
            case .orderedAscending:
                print("Date now is earlier than date prevdate")
                differeneceInTime = -100
            case .orderedSame:
                 print("The two dates are the same")
            case .orderedDescending:
                print("Date now is later than date prevdate")
                differeneceInTime = 100
            }
        }
        
    }
    
    func convertDateFormat(inputDate: String) -> Date {
         let olDateFormatter = DateFormatter()
         olDateFormatter.dateFormat = "M-d-yyyy HH:mm:ss a"
         let convertDateFormatter = DateFormatter()
         convertDateFormatter.dateFormat = "M-d-yyyy h:mm:ss a"
         let newDate = convertDateFormatter.date(from: inputDate)
        return newDate!
    }
    
    //MARK:// otp functionality
    func getdoctorAppointmentdetails(_ appId: String)
    {
        let queryItems = ["AppointmentID": appId,"FromApp":"true"] as [String: Any]
        self.view.activityStartAnimating(activityColor: .themeGreen, backgroundColor: UIColor.white)
        WebService.doctorAppointmentdetails(queryItems: queryItems) { (result) in
            DispatchQueue.main.async {
                switch result {
                case .success(let response):
                  //  AlertManager.showAlert(type: .custom("OTP Sent..."))
                    print(response)
                case .failure(let error):
                  //  AlertManager.showAlert(type: .custom(error.message))
                    print(error)
                }
                self.view.activityStopAnimating()
            }
        }
    }
    
     func currentTime() -> String {
        let date = Date()
        let calendar = Calendar.current
        let hour = calendar.component(.hour, from: date)
        let minutes = calendar.component(.minute, from: date)
        return "\(hour).\(minutes)"
    }
    
    func getOtp(apnmtId:String,fromapp:String) -> Void {
        
         if reachability.isReachable {
        let parameters = "AppointmentID=\(apnmtId)&FromApp=\(fromapp)"
        let postData =  parameters.data(using: .utf8)

        var request = URLRequest(url: URL(string: "\(APIConstants.mainUrl)Customer/CheckDoctorAppointmentDetail")!,timeoutInterval: Double.infinity)

        request.addValue("application/x-www-form-urlencoded", forHTTPHeaderField: "Content-Type")
        request.addValue("Nop.customer=664dd87a-398a-4ee8-8f39-236484c462b2", forHTTPHeaderField: "Cookie")

        request.httpMethod = "POST"
        request.httpBody = postData

        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            DispatchQueue.main.async {
                  guard let data = data else {
                    AlertManager.showAlert(type: .custom(String(describing: error)))
                    return
                  }
                  let responseDic  = try! JSONSerialization.jsonObject(with: data, options: .allowFragments) as! NSDictionary
                    
                    if "\(responseDic["status"] ?? 0)" == "1"{
                    self.otp = "\(responseDic["OTP"] ?? 0)"
                    self.totalTime = 40*60
                    DispatchQueue.main.async {
                        self.startOtpTimer()
                    }
                }else
                    {
                        AlertManager.showAlert(type: .custom("\(responseDic["Message"] ?? "")")) {
                            NotificationCenter.default.post(name: Notification.Name("appointment"), object: 2)
                                NavigationHandler.pop()
                        }
                        self.otp = "failed"

                    }
            }
        }

        task.resume()
        
    }else{
        AlertManager.showAlert(type: .custom(AppointmentScreenTxt.noInternet.localize())) {
                NotificationCenter.default.post(name: Notification.Name("appointment"), object: 2)
                    NavigationHandler.pop()
         }
            
        }
    }
    
    func manageConfirmAppointment(_ appId: String){
        let queryItems = ["id": appId] as [String: Any]
        self.view.activityStartAnimating(activityColor: .themeGreen, backgroundColor: UIColor.white)
        WebService.manageConfirmedAppointments(queryItems: queryItems) { (result) in
            DispatchQueue.main.async {
                switch result {
                case .success(let response):
                    AlertManager.showAlert(type: .custom(response.message ?? "")) {
                        NotificationCenter.default.post(name: Notification.Name("appointment"), object: 2)
                            NavigationHandler.pop()
                    }
                case .failure(let error):
                    AlertManager.showAlert(type: .custom(error.message)){
                        NotificationCenter.default.post(name: Notification.Name("appointment"), object: 2)
                        NavigationHandler.pop()
                    }
                }
                self.view.activityStopAnimating()
            }
        }
    }
    
    
    
     private func startOtpTimer() {
            self.timer = Timer.scheduledTimer(timeInterval: 1.0, target: self, selector: #selector(updateTimer), userInfo: nil, repeats: true)
        }

    @objc func updateTimer() {
            self.otpLabel.text = AppointmentScreenTxt.otpwillexpirein.localize() + self.timeFormatted(self.totalTime)  // will show timer
            if totalTime != 0 {
                totalTime -= 1  // decrease counter timer
                resendView.isHidden = true

            } else {
                if let timer = self.timer {
                    timer.invalidate()
                    self.timer = nil
                    self.otpLabel.text = AppointmentScreenTxt.otpexpired.localize()
                    resendView.isHidden = false
                }
            }
        }
    func timeFormatted(_ totalSeconds: Int) -> String {
        let seconds: Int = totalSeconds % 60
        let minutes: Int = (totalSeconds / 60) % 60
        return String(format: "%02d:%02d", minutes, seconds)
    }
    
    func setupUI(apnmt:Appointment?) -> Void {
        self.nameLabel.text =  apnmt?.MemberName
        self.dateLabel.text = self.getFormattedDate(strDate: apnmt?.AppointmentDateTime?.components(separatedBy: " ").first ?? "", currentFomat: "MM/dd/yyyy", expectedFromat: "dd-MMM-yyyy")
        self.timeLabel.text = apnmt?.AppointmentTime
        self.bookingDateLabel.text = self.getFormattedDate(strDate: apnmt?.BookingDate?.components(separatedBy: " ").first ?? "", currentFomat: "MM/dd/yyyy", expectedFromat: "dd-MMM-yyyy")
       // self.phoneLabel.text = apnmt?.MemberPhone
        self.ageLabel.text = "\(apnmt?.Age ?? 0)"
        
        self.attributingWithColorForVC(label: self.reasonLabel, boldTxt: AppointmentScreenTxt.reason.localize(), regTxt: apnmt?.Reason ?? "", color: .themeGreen, fontSize: 12, firstFontWeight: .semibold, secFontWeight: .regular)
    }
}
