//
//  EAppointmentsListVC.swift
//  SmileIndia
//
//  Created by Arjun  on 08/04/20.
//  Copyright © 2020 Na. All rights reserved.
//

import UIKit
import Localize

class EAppointmentsListVC: UIViewController {
    
    @IBOutlet weak var apnmntsTableview: UITableView!
    
    @IBOutlet weak var defaulterLabel: UILabel!
    
    var sort = "true"
    var datasourceTable = GenericDataSource()
    var appointments = [Appointment]()
    
    var refreshControl: UIRefreshControl!
    
    var permissionCheck = true


    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        setStatusBar(color: .themeGreen)

        Authentication.customerType == "Doctor" ? self.getAppointments(2, sort: self.sort, refreshing: "0") : self.getMemberAppointments(2, sort: self.sort, refreshing: "0")
                refreshControl = UIRefreshControl()
                refreshControl.attributedTitle = NSAttributedString(string: "Refreshing...")
                refreshControl.addTarget(self, action: #selector(refresh), for: .valueChanged)
                apnmntsTableview.addSubview(refreshControl)
        self.defaulterLabel.text = ""

     }

    @objc func refresh(_ sender: Any) {
            Authentication.customerType == "Doctor" ? self.getAppointments(2, sort: self.sort, refreshing: "1") : self.getMemberAppointments(2, sort: self.sort, refreshing: "1")
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        self.checkCameraAccess()
        self.checkMicAccess()
        self.checkNotificationsAccess()
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

    @IBAction func didtapInfo(_ sender: Any) {
        if self.permissionCheck == false{
            self.checkCameraAccess()
            self.checkMicAccess()
            self.checkNotificationsAccess()
        }else{
            AlertManager.showAlert(type: .custom(AppointmentScreenTxt.callalert.localize())){
                    UIApplication.shared.open(URL(string: UIApplication.openSettingsURLString)!, options: [:], completionHandler: nil)
            }
        }
    }
    
    @IBAction func didtapBack(_ sender: Any) {
        NavigationHandler.pop()
    }
    
    @IBAction func didtapSort(_ sender: Any) {
        if self.sort == "false"{
            self.sort = "true"
            Authentication.customerType == "Doctor" ? self.getAppointments(2, sort: self.sort, refreshing: "0") : self.getMemberAppointments(2, sort: self.sort, refreshing: "0")
        }else{
        self.sort = "false"
            Authentication.customerType == "Doctor" ? self.getAppointments(2, sort: self.sort, refreshing: "0") : self.getMemberAppointments(2, sort: self.sort, refreshing: "0")
        }
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
    func checkMicAccess(){
        switch AVCaptureDevice.authorizationStatus(for: .audio) {
        case .denied:
            print("Denied, request permission from settings")
            self.permissionDenied(text: "Microphone")
            self.permissionCheck = false

        case .restricted:
            print("Restricted, device owner must approve")
            self.permissionDenied(text: "Microphone")
            self.permissionCheck = false

        case .authorized:
            print("Authorized, proceed")
        case .notDetermined:
            AVCaptureDevice.requestAccess(for: .video) { success in
                if success {
                    print("Permission granted, proceed")
                } else {
                    print("Permission denied")
                    self.permissionDenied(text: "Microphone")
                    self.permissionCheck = false

                }
            }
        }
    }
    
    func checkCameraAccess() {
        switch AVCaptureDevice.authorizationStatus(for: .video) {
        case .denied:
            print("Denied, request permission from settings")
            self.permissionDenied(text: "Camera")
            self.permissionCheck = false

        case .restricted:
            print("Restricted, device owner must approve")
            self.permissionDenied(text: "Camera")
            self.permissionCheck = false

        case .authorized:
            print("Authorized, proceed")
        case .notDetermined:
            AVCaptureDevice.requestAccess(for: .video) { success in
                if success {
                    print("Permission granted, proceed")
                } else {
                    print("Permission denied")
                    self.permissionDenied(text: "Camera")
                    self.permissionCheck = false
                }
            }
        }
    }
    
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

    
    private func getPrivacyAccess(){
        let vStatus = AVCaptureDevice.authorizationStatus(for: .video)
        if(vStatus == AVAuthorizationStatus.notDetermined){
            AVCaptureDevice.requestAccess(for: .video, completionHandler: { (granted: Bool) in
            })
        }
        let aStatus = AVCaptureDevice.authorizationStatus(for: .audio)
        if(aStatus == AVAuthorizationStatus.notDetermined){
            AVCaptureDevice.requestAccess(for: .audio, completionHandler: { (granted: Bool) in
            })
        }
    }
    
}


extension EAppointmentsListVC {
    
    func setUpTableCell(){
        datasourceTable.array = self.appointments
        datasourceTable.identifier = EAppointmentCell.identifier
        apnmntsTableview.dataSource = datasourceTable
        apnmntsTableview.delegate = datasourceTable
        apnmntsTableview.tableFooterView = UIView()
        datasourceTable.configure = {cell, index in
            guard let pendingCell = cell as? EAppointmentCell else { return }
            pendingCell.object = self.appointments[index]
        }
        datasourceTable.didScroll = {
        }
        datasourceTable.didSelect = {cell, index in
            guard let pendingCell = cell as? EAppointmentCell else { return }
            NavigationHandler.pushTo(.eAppointments(pendingCell.object!))
        }
    }
    
    func getAppointments(_ status: Int,sort:String,refreshing:String){
        var eappointments = [Appointment]()
        
        let queryItems = ["providerId": Authentication.customerGuid!, "status": status,"sortByOrder":sort] as [String : Any]
        if refreshing == "0"{
        self.view.activityStartAnimating(activityColor: .themeGreen, backgroundColor: UIColor.white)
        }
        WebService.manageDoctorAppointment(queryItems: queryItems) { (result) in
            DispatchQueue.main.async {
                switch result {
                case .success(let response):
                  //  self.appointments = response.objects ?? []
                    for eApnmt in response.objects ?? [] {
                        if eApnmt.MeetType == 2{
                        eappointments.append(eApnmt)
                        }
                    }
                    self.appointments = eappointments
                        self.setUpTableCell()
                        self.apnmntsTableview.reloadData()
                case .failure(let error):
                    print(error)
                    self.appointments = []
                    self.setUpTableCell()
                    self.apnmntsTableview.reloadData()
                }
                if refreshing == "0"{
                self.view.activityStopAnimating()
                }
                if refreshing == "1" {
                    self.refreshControl.endRefreshing()
                }
                
            }
        }
    }
    func getMemberAppointments(_ status: Int,sort:String,refreshing:String){
        var eappointments = [Appointment]()

        let queryItems = ["memberId": Authentication.customerId!, "status": status,"sortByOrder":sort] as [String : Any]
        if refreshing == "0"{
        self.view.activityStartAnimating(activityColor: .themeGreen, backgroundColor: UIColor.white)
        }
        WebService.manageMemberAppointment(queryItems: queryItems) { (result) in
            DispatchQueue.main.async {
                switch result {
                case .success(let response):
                  //  self.appointments = response.objects ?? []
                    for eApnmt in response.objects ?? [] {
                        if eApnmt.MeetType == 2{
                        eappointments.append(eApnmt)
                        }
                    }
                    self.appointments = eappointments
                    self.setUpTableCell()
                    self.apnmntsTableview.reloadData()
                case .failure(let error):
                    print(error)
                    self.appointments = []
                    self.setUpTableCell()
                    self.apnmntsTableview.reloadData()
                    // AlertManager.showAlert(type: .custom(error.message))
                }
                if refreshing == "0"{
                self.view.activityStopAnimating()
                }
                if refreshing == "1" {
                    self.refreshControl.endRefreshing()
                }

            }
        }
    }
}
