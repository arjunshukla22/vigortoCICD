//
//  CalendarViewController.swift
//  SmileIndia
//
//  Created by Arjun  on 23/04/20.
//  Copyright © 2020 Na. All rights reserved.
//

import UIKit

class CalendarViewController: UIViewController {
    
    var calendarData: CalendarData?
    var datasource1 = GenericDataSource()
    var datasource2 = GenericDataSource()

    var morningSlots = [MorningTimeSlots]()
    var eveningSlots = [EveningTimeSlots]()
    
    var mrngIndexes = [Int]()
    var evngIndexes = [Int]()
    
    var isClosedate = 0
    var resultCheck = 0

    @IBOutlet weak var tableMorning: UITableView!
    @IBOutlet weak var tableEvening: UITableView!
    @IBOutlet weak var switchFullday: UISwitch!
    @IBOutlet weak var switchMorning: UISwitch!
    @IBOutlet weak var switchEvening: UISwitch!
    @IBOutlet weak var btnSelectDate: UIButton!
    @IBOutlet weak var DateTextField: CustomTextfield!
    
    @IBOutlet weak var fulldayLabel: UILabel!
    
    @IBOutlet weak var defaulterLabel: UILabel!
    
    var selectedArray = [[String: Any]]()
   // var datePicker = DatePickerDialog()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        // Do any additional setup after loading the view.
        setStatusBar(color: .themeGreen)
        DateTextField.rightViewMode = UITextField.ViewMode.always
        DateTextField.rightView = UIImageView(image: UIImage(named: "cal25"))
        DateTextField.delegate = self
        setupUI()
        
        self.defaulterLabel.text = ""

    }
    override func viewWillAppear(_ animated: Bool) {
        getMyCalendar(selectedDate: self.getFormattedDate(strDate: "\(btnSelectDate.currentTitle ?? "")", currentFomat:"dd-MMM-yyyy" , expectedFromat:"yyyy-MM-dd" ))
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

    func datePickerTapped() {
        let currentDate = Date()
        var dateComponents = DateComponents()
        dateComponents.day = 15
        var maxdatecomponent = DateComponents()
        maxdatecomponent.day = -0
        let maxDate = Calendar.current.date(byAdding: dateComponents, to: currentDate)
        let minDate = Calendar.current.date(byAdding: maxdatecomponent, to: currentDate)
//        datePicker.show("Select Date",
//                        doneButtonTitle: "Done",
//                        cancelButtonTitle: AlertBtnTxt.cancel.localize(),
//                       minimumDate: years120Ago,
//                        maximumDate: years18Ago,
//                        datePickerMode: .date) { (date) in
//            if let dt = date {
//                let formatter = DateFormatter()
//                formatter.dateFormat = "dd-MMM-yyyy"
//                self.DateTextField.text = formatter.string(from: dt)
//            }
//        }
        
        let selectedDate = Date()
        
        RPicker.selectDate(title: BankAccountScreentxt.selectDate.localize(), selectedDate: selectedDate, minDate: minDate, maxDate: maxDate) { [weak self] (selectedDate) in
            // TODO: Your implementation for date
//            self?.outputLabel.text = selectedDate.dateString("MMM-dd-YYYY")
//
            let formatter = DateFormatter()
            formatter.dateFormat = "dd-MMM-yyyy"
            self?.DateTextField.text = formatter.string(from: selectedDate)
            
            self?.btnSelectDate.setTitle(formatter.string(from: selectedDate), for: .normal)
            
    
            let formateddate = self?.getFormattedDate(strDate: /self?.DateTextField.text, currentFomat: "dd-MMM-yyyy", expectedFromat: "yyyy-MM-dd")
            self?.getMyCalendar(selectedDate: /formateddate!)
            
        }
        
        
    }
    

    func getMyCalendar(selectedDate:String) -> Void {

        let queryItems = ["ProviderId": "\(Authentication.customerGuid!)", "CustomDate": selectedDate,"DeviceType": "m"]
        self.view.activityStartAnimating(activityColor: .themeGreen, backgroundColor: UIColor.white)
        WebService.getMyCalendar(queryItems: queryItems) { (result) in
         DispatchQueue.main.async {
                switch result {
                case .success (let response):
                    self.calendarData =  response.object

                    self.morningSlots = self.calendarData?.MorningTimeSlots ?? []
                    self.eveningSlots = self.calendarData?.EveningTimeSlots ?? []
                    
                    self.setUpMorningTableCell()
                    self.setUpEveningTableCell()
                    self.getIsCloseFullDay()
                case .failure(let error):
                    self.morningSlots = []
                    self.eveningSlots = []
                    self.setUpMorningTableCell()
                    self.setUpEveningTableCell()
                    self.tableMorning.reloadData()
                    self.tableEvening.reloadData()
                    AlertManager.showAlert(on: self, type: .custom(error.message))
              }
            self.view.activityStopAnimating()
            }
        }
    }
    
    func setUpMorningTableCell(){
        datasource1.array = morningSlots
        datasource1.identifier = CalMorningCell.identifier
        tableMorning.dataSource = datasource1
        tableMorning.delegate = datasource1
        tableMorning.tableFooterView = UIView()
        tableMorning.allowsMultipleSelection = true

        datasource1.configure = {cell, index in
            guard let morningCell = cell as? CalMorningCell else { return }
            morningCell.object = self.morningSlots[index]
            self.isClosedate = self.morningSlots[index].IsClosedDate ?? 0
            morningCell.select = self.mrngIndexes.contains(index) ? true : false
        }
        
        datasource1.didScroll = {
        }
        
    datasource1.didSelect = {cell, index in
    guard let _ = cell as? CalMorningCell else { return }
        
        if self.switchFullday.isOn || self.switchMorning.isOn{
            AlertManager.showAlert(on: self, type: .custom(MyCalenderScreenTxt.changeAvltimeSlots.localize())) 
        }else{
        if self.morningSlots.count > 0 {
            if self.mrngIndexes.contains(index) {
                if self.mrngIndexes.count == 1 {
                        let mrngAlert = UIAlertController(title: MyCalenderScreenTxt.areyouSureUnAvilableFirstHalf.localize(), message: nil, preferredStyle: UIAlertController.Style.alert)

                        mrngAlert.addAction(UIAlertAction(title: MyCalenderScreenTxt.CONFIRM.localize(), style: .default, handler: { (action: UIAlertAction!) in
                              self.resultCheck = 2
                              let dict = ["CustomDate": self.getFormattedDate(strDate: "\(self.btnSelectDate.currentTitle ?? "")", currentFomat:"dd-MMM-yyyy" , expectedFromat:"yyyy-MM-dd" ), "IsClosedDate": "2", "ProviderId": "\(Authentication.customerGuid!)", "DeviceType": "M","IsAnyHalfClosedFull":self.calendarData?.IsAnyHalfClosedFull ?? false] as [String : Any]
                              self.saveIsCloseFullDay(dict: dict)
                        }))

                        mrngAlert.addAction(UIAlertAction(title: MyCalenderScreenTxt.DECLINE.localize(), style: .cancel, handler: { (action: UIAlertAction!) in
                            self.getMyCalendar(selectedDate: self.getFormattedDate(strDate: "\(self.btnSelectDate.currentTitle ?? "")", currentFomat:"dd-MMM-yyyy" , expectedFromat:"yyyy-MM-dd" ))
                        }))

                    self.present(mrngAlert, animated: true, completion: nil)
                }
                self.mrngIndexes.remove(at: self.mrngIndexes.index(of: index)!)
                self.tableMorning.reloadData()
            }else{
                self.mrngIndexes.append(index)
                self.tableMorning.reloadData()
            }
          }
        }
        }
        

    }
    
        func setUpEveningTableCell(){
            datasource2.array = eveningSlots
            datasource2.identifier = CalEveningCell.identifier
            tableEvening.dataSource = datasource2
            tableEvening.delegate = datasource2
            tableEvening.tableFooterView = UIView()
            tableEvening.allowsMultipleSelection = true

            datasource2.configure = {cell, index in
                guard let evngCell = cell as? CalEveningCell else { return }
                evngCell.object = self.eveningSlots[index]
                self.isClosedate = self.eveningSlots[index].IsClosedDate ?? 0
                evngCell.select = self.evngIndexes.contains(index) ? true : false
            }
            datasource2.didScroll = {
            }
            datasource2.didSelect = {cell, index in
            guard let _ = cell as? CalEveningCell else { return }
                
                if self.switchFullday.isOn || self.switchEvening.isOn{
                    AlertManager.showAlert(on: self, type: .custom(MyCalenderScreenTxt.changeAvltimeSlots.localize()))
                }else{
                if self.eveningSlots.count > 0 {
                    if self.evngIndexes.contains(index) {
                        if self.evngIndexes.count == 1
                        {
                            let evngAlert = UIAlertController(title: MyCalenderScreenTxt.areYouSureUnAvlfor2ndhalf.localize(), message: nil, preferredStyle: UIAlertController.Style.alert)

                            evngAlert.addAction(UIAlertAction(title: MyCalenderScreenTxt.CONFIRM.localize(), style: .default, handler: { (action: UIAlertAction!) in
                                  self.resultCheck = 3
                                  let dict = ["CustomDate": self.getFormattedDate(strDate: "\(self.btnSelectDate.currentTitle ?? "")", currentFomat:"dd-MMM-yyyy" , expectedFromat:"yyyy-MM-dd" ), "IsClosedDate": "3", "ProviderId": "\(Authentication.customerGuid!)", "DeviceType": "M","IsAnyHalfClosedFull":self.calendarData?.IsAnyHalfClosedFull ?? false] as [String : Any]
                                  self.saveIsCloseFullDay(dict: dict)
                            }))

                            evngAlert.addAction(UIAlertAction(title: MyCalenderScreenTxt.DECLINE.localize(), style: .cancel, handler: { (action: UIAlertAction!) in
                                self.getMyCalendar(selectedDate: self.getFormattedDate(strDate: "\(self.btnSelectDate.currentTitle ?? "")", currentFomat:"dd-MMM-yyyy" , expectedFromat:"yyyy-MM-dd" ))
                            }))

                            self.present(evngAlert, animated: true, completion: nil)
                        }
                        self.evngIndexes.remove(at: self.evngIndexes.index(of: index)!)
                        self.tableEvening.reloadData()
                    }else{
                        self.evngIndexes.append(index)
                        self.tableEvening.reloadData()
                    }
                  }
            }
                }
        }
    
    func getIsCloseFullDay() -> Void {
        
        let queryItems = ["CustomDate": self.getFormattedDate(strDate: "\(btnSelectDate.currentTitle ?? "")", currentFomat:"dd-MMM-yyyy" , expectedFromat:"yyyy-MM-dd" ), "ProviderId": "\(Authentication.customerGuid!)", "DeviceType": "M"]
        
        self.view.activityStartAnimating(activityColor: .themeGreen, backgroundColor: UIColor.white)
        WebService.getIsCloseFullDay(queryItems: queryItems) { (result) in
                DispatchQueue.main.async {
                    switch result {
                    case .success(let response):
                        self.resultCheck = response.rslt ?? 0
                        if response.rslt == 0 {
                            self.switchMorning.isHidden = false
                            self.switchEvening.isHidden = false
                            self.switchFullday.setOn(false, animated: true)
                            self.switchMorning.setOn(false, animated: true)
                            self.switchEvening.setOn(false, animated: true)
                            self.fulldayLabel.textColor = .white

                            self.fullDayMonitor()
                            print("full day open")
                        } else if response.rslt == 1{
                            self.switchFullday.setOn(true, animated: true)
                            self.switchMorning.setOn(true, animated: true)
                            self.switchEvening.setOn(true, animated: true)
                            self.fulldayLabel.textColor = .red
                            
                            self.switchMorning.isHidden = true
                            self.switchEvening.isHidden = true
                            
                            self.fullDayMonitor()
                          print("full day close")
                        }else if response.rslt == 2
                        {
                            self.switchMorning.isHidden = false
                            self.switchEvening.isHidden = false
                            
                            self.switchFullday.setOn(false, animated: true)
                            self.switchMorning.setOn(true, animated: true)
                            
                            self.switchEvening.setOn(false, animated: true)
                            
                            self.firstHalfMonitor()
                            self.secHalfMonitor()
                            print("first half closed")
                            self.fulldayLabel.textColor = .white

                        }else if response.rslt == 3
                        {
                            self.switchMorning.isHidden = false
                            self.switchEvening.isHidden = false
                            
                            self.switchFullday.setOn(false, animated: true)
                            self.switchEvening.setOn(true, animated: true)
                            
                            self.switchMorning.setOn(false, animated: true)

                            
                            self.firstHalfMonitor()
                            self.secHalfMonitor()
                            print("sec half closed")
                            self.fulldayLabel.textColor = .white

                        }

                    case .failure(let error):
                        print(error.message)
                        AlertManager.showAlert(type: .custom(error.message))
                    }
                    self.view.activityStopAnimating()
                }
             }
    }
    
    func saveIsCloseFullDay(dict:[String : Any]) -> Void {
          
        let json = try? JSONSerialization.data(withJSONObject: dict, options: JSONSerialization.WritingOptions.prettyPrinted)
        let parameters = String(data: json ?? Data(), encoding: String.Encoding.utf8) ?? ""
        let postData = parameters.data(using: .utf8)

            var request = URLRequest(url: URL(string: "\(APIConstants.mainUrl)Api/SaveIsCloseFullDay")!,timeoutInterval: Double.infinity)

            request.addValue("application/json", forHTTPHeaderField: "Content-Type")
            request.addValue("text/plain", forHTTPHeaderField: "Content-Type")

            request.httpMethod = "POST"
            request.httpBody = postData

            let task = URLSession.shared.dataTask(with: request) { data, response, error in
              guard let data = data else {
                print(String(describing: error))
                return
              }
              print(String(data: data, encoding: .utf8)!)
                DispatchQueue.main.async {
                    self.getMyCalendar(selectedDate: self.getFormattedDate(strDate: "\(self.btnSelectDate.currentTitle ?? "")", currentFomat:"dd-MMM-yyyy" , expectedFromat:"yyyy-MM-dd" ))
                }

            }

            task.resume()
    }
    
    func fullDayMonitor() -> Void {
        if switchFullday.isOn {
            
            self.mrngIndexes.removeAll()
            self.evngIndexes.removeAll()
            self.tableMorning.reloadData()
            self.tableEvening.reloadData()
            
        } else {
            self.mrngIndexes.removeAll()
            self.evngIndexes.removeAll()
            
            if morningSlots.count > 0 {
                for index in 0...morningSlots.count-1 {
                  if morningSlots[index].IsAvailable == true {
                        self.mrngIndexes.append(index)
                    }
                }
            }else{
                self.switchMorning.isHidden = true
            }
            
            if eveningSlots.count > 0 {
                for index in 0...eveningSlots.count-1 {
                    if eveningSlots[index].IsAvailable == true {
                        self.evngIndexes.append(index)
                    }
                }
            }else{
                self.switchEvening.isHidden = true
            }
            
            if morningSlots.count <= 0 && eveningSlots.count <= 0{
                self.switchFullday.isHidden = true
                self.switchMorning.isHidden = true
                self.switchEvening.isHidden = true
            }

            self.tableMorning.reloadData()
            self.tableEvening.reloadData()
        }
        
    }

    func firstHalfMonitor() -> Void {
        self.mrngIndexes.removeAll()
        if switchMorning.isOn {
            self.mrngIndexes.removeAll()
            self.tableMorning.reloadData()
        }else{
            
            if morningSlots.count > 0 {
                for index in 0...morningSlots.count-1 {
                    if morningSlots[index].IsAvailable == true {
                    self.mrngIndexes.append(index)
                    }
                }
            }

            self.tableMorning.reloadData()
        }
    }
    
    func secHalfMonitor() -> Void {
        self.evngIndexes.removeAll()
        if switchEvening.isOn {
            self.evngIndexes.removeAll()
            self.tableEvening.reloadData()
        }else{
            
            if eveningSlots.count > 0{
                for index in 0...eveningSlots.count-1 {
                    if eveningSlots[index].IsAvailable == true {
                    self.evngIndexes.append(index)
                    }
                }
            }

            self.tableEvening.reloadData()
        }
    }
    

    
    @IBAction func fulldaySwitchTapped(_ sender: UISwitch) {
    self.resultCheck = 1
    if sender.isOn{
        
        let fulldayAlert = UIAlertController(title: MyCalenderScreenTxt.areYouSureUnAvlforwholeDay.localize(), message: nil, preferredStyle: UIAlertController.Style.alert)

        fulldayAlert.addAction(UIAlertAction(title: MyCalenderScreenTxt.CONFIRM.localize(), style: .default, handler: { (action: UIAlertAction!) in
              let dict = ["CustomDate": self.getFormattedDate(strDate: "\(self.btnSelectDate.currentTitle ?? "")", currentFomat:"dd-MMM-yyyy" , expectedFromat:"yyyy-MM-dd" ), "IsClosedDate": "1", "ProviderId": "\(Authentication.customerGuid!)", "DeviceType": "M"] as [String : Any]
              self.saveIsCloseFullDay(dict: dict)
        }))

        fulldayAlert.addAction(UIAlertAction(title: MyCalenderScreenTxt.DECLINE.localize(), style: .cancel, handler: { (action: UIAlertAction!) in
              print("Handle Cancel Logic here")
            sender.setOn(!sender.isOn, animated: true)
        }))

        present(fulldayAlert, animated: true, completion: nil)

    }else{
        
        let fulldayAlert = UIAlertController(title: MyCalenderScreenTxt.areYouSureAvlforwholeDay.localize(), message: nil, preferredStyle: UIAlertController.Style.alert)

        fulldayAlert.addAction(UIAlertAction(title: MyCalenderScreenTxt.CONFIRM.localize(), style: .default, handler: { (action: UIAlertAction!) in
              let dict = ["CustomDate": self.getFormattedDate(strDate: "\(self.btnSelectDate.currentTitle ?? "")", currentFomat:"dd-MMM-yyyy" , expectedFromat:"yyyy-MM-dd" ), "IsClosedDate": "0", "ProviderId": "\(Authentication.customerGuid!)", "DeviceType": "M"] as [String : Any]
              self.saveIsCloseFullDay(dict: dict)
        }))

        fulldayAlert.addAction(UIAlertAction(title: MyCalenderScreenTxt.DECLINE.localize(), style: .cancel, handler: { (action: UIAlertAction!) in
              print("Handle Cancel Logic here")
            sender.setOn(!sender.isOn, animated: true)
        }))

        present(fulldayAlert, animated: true, completion: nil)
    }
        
    }
    
    
    @IBAction func morningSwitchTapped(_ sender: UISwitch) {
        
        if sender.isOn {
            
            let mrngAlert = UIAlertController(title: MyCalenderScreenTxt.areyouSureUnAvilableFirstHalf.localize(), message: nil, preferredStyle: UIAlertController.Style.alert)

            mrngAlert.addAction(UIAlertAction(title: MyCalenderScreenTxt.CONFIRM.localize(), style: .default, handler: { (action: UIAlertAction!) in
                  self.resultCheck = 2
                  let dict = ["CustomDate": self.getFormattedDate(strDate: "\(self.btnSelectDate.currentTitle ?? "")", currentFomat:"dd-MMM-yyyy" , expectedFromat:"yyyy-MM-dd" ), "IsClosedDate": "2", "ProviderId": "\(Authentication.customerGuid!)", "DeviceType": "M","IsAnyHalfClosedFull":self.calendarData?.IsAnyHalfClosedFull ?? false] as [String : Any]
                  self.saveIsCloseFullDay(dict: dict)
            }))

            mrngAlert.addAction(UIAlertAction(title: MyCalenderScreenTxt.DECLINE.localize(), style: .cancel, handler: { (action: UIAlertAction!) in
                  print("Handle Cancel Logic here")
                sender.setOn(!sender.isOn, animated: true)
            }))

            present(mrngAlert, animated: true, completion: nil)

        }else{
            
            let mrngAlert = UIAlertController(title: MyCalenderScreenTxt.areyouSureAvlFirstHalf.localize(), message: nil, preferredStyle: UIAlertController.Style.alert)

            mrngAlert.addAction(UIAlertAction(title: MyCalenderScreenTxt.CONFIRM.localize(), style: .default, handler: { (action: UIAlertAction!) in
                  self.resultCheck = 2
                  let dict = ["CustomDate": self.getFormattedDate(strDate: "\(self.btnSelectDate.currentTitle ?? "")", currentFomat:"dd-MMM-yyyy" , expectedFromat:"yyyy-MM-dd" ), "IsClosedDate": "2", "ProviderId": "\(Authentication.customerGuid!)", "DeviceType": "M","IsAnyHalfClosedFull":self.calendarData?.IsAnyHalfClosedFull ?? false] as [String : Any]
                  self.saveIsCloseFullDay(dict: dict)
            }))

            mrngAlert.addAction(UIAlertAction(title: MyCalenderScreenTxt.DECLINE.localize(), style: .cancel, handler: { (action: UIAlertAction!) in
                  print("Handle Cancel Logic here")
                sender.setOn(!sender.isOn, animated: true)
            }))

            present(mrngAlert, animated: true, completion: nil)

        }
        

    }
    
    @IBAction func eveningSwitchTapped(_ sender: UISwitch) {
        
        if sender.isOn {
            let evngAlert = UIAlertController(title: MyCalenderScreenTxt.areYouSureUnAvlfor2ndhalf.localize(), message: nil, preferredStyle: UIAlertController.Style.alert)

            evngAlert.addAction(UIAlertAction(title: MyCalenderScreenTxt.CONFIRM.localize(), style: .default, handler: { (action: UIAlertAction!) in
                  self.resultCheck = 3
                  let dict = ["CustomDate": self.getFormattedDate(strDate: "\(self.btnSelectDate.currentTitle ?? "")", currentFomat:"dd-MMM-yyyy" , expectedFromat:"yyyy-MM-dd" ), "IsClosedDate": "3", "ProviderId": "\(Authentication.customerGuid!)", "DeviceType": "M","IsAnyHalfClosedFull":self.calendarData?.IsAnyHalfClosedFull ?? false] as [String : Any]
                  self.saveIsCloseFullDay(dict: dict)
            }))

            evngAlert.addAction(UIAlertAction(title: MyCalenderScreenTxt.DECLINE.localize(), style: .cancel, handler: { (action: UIAlertAction!) in
                  print("Handle Cancel Logic here")
                sender.setOn(!sender.isOn, animated: true)
            }))

            present(evngAlert, animated: true, completion: nil)
            
        } else {
            let evngAlert = UIAlertController(title: MyCalenderScreenTxt.areyouSureAvl2ndHalf.localize(), message: nil, preferredStyle: UIAlertController.Style.alert)

            evngAlert.addAction(UIAlertAction(title: MyCalenderScreenTxt.CONFIRM.localize(), style: .default, handler: { (action: UIAlertAction!) in
                  self.resultCheck = 3
                  let dict = ["CustomDate": self.getFormattedDate(strDate: "\(self.btnSelectDate.currentTitle ?? "")", currentFomat:"dd-MMM-yyyy" , expectedFromat:"yyyy-MM-dd" ), "IsClosedDate": "3", "ProviderId": "\(Authentication.customerGuid!)", "DeviceType": "M","IsAnyHalfClosedFull":self.calendarData?.IsAnyHalfClosedFull ?? false] as [String : Any]
                  self.saveIsCloseFullDay(dict: dict)
            }))

            evngAlert.addAction(UIAlertAction(title: MyCalenderScreenTxt.DECLINE.localize(), style: .cancel, handler: { (action: UIAlertAction!) in
                  print("Handle Cancel Logic here")
                sender.setOn(!sender.isOn, animated: true)
            }))
            present(evngAlert, animated: true, completion: nil)

        }

    }
    

    func monitorFulldaySwitch() -> Void {
        if switchMorning.isOn && switchEvening.isOn{
            self.switchFullday.setOn(true, animated: true)
        }else{
            self.switchFullday.setOn(false, animated: true)
        }
    }
    
    @IBAction func didtapCalendar(_ sender: Any) {
        let popOverVC = self.storyboard?.instantiateViewController(withIdentifier: "CalendarPopupVC") as! CalendarPopupVC
        popOverVC.delegate = self
        popOverVC.modalPresentationStyle = UIModalPresentationStyle.overFullScreen
        self.present(popOverVC, animated: true)
        
    }
    
    @IBAction func didtapBack(_ sender: Any) {
        NavigationHandler.pop()
    }
    
    @IBAction func didtapSave(_ sender: Any) {
        
        if self.switchFullday.isOn{
            AlertManager.showAlert(on: self, type: .custom(MyCalenderScreenTxt.changeAvltimeSlots.localize()))
        }else{
            
            AlertManager.showAlert(type: .custom(MyCalenderScreenTxt.wannaSaveChanges.localize()), actionTitle: MyCalenderScreenTxt.ConfirmSm.localize()) {
            self.selectedArray.removeAll()
            NavigationHandler.pop()
                if self.morningSlots.count > 0{
                    for index in 0...self.morningSlots.count-1 {
                        if self.mrngIndexes.contains(index) {
                            self.selectedArray.append(["Time": self.morningSlots[index].Time ?? "","isClosed": "true"])
                             NavigationHandler.popTo(HomeViewController.self)
                        } else {
                            self.selectedArray.append(["Time": self.morningSlots[index].Time ?? "","isClosed": "false"])
                            NavigationHandler.popTo(HomeViewController.self)
                        }
                    }                }

                if self.eveningSlots.count > 0 {
                    for index in 0...self.eveningSlots.count-1 {
                        if self.evngIndexes.contains(index) {
                            self.selectedArray.append(["Time": self.eveningSlots[index].Time ?? "","isClosed": "true"])
                        } else {
                            self.selectedArray.append(["Time": self.eveningSlots[index].Time ?? "","isClosed": "false"])
                        }
                    }
                     NavigationHandler.popTo(HomeViewController.self)
                }

            
            let dict = ["CustomDate": self.getFormattedDate(strDate: "\(self.btnSelectDate.currentTitle ?? "")", currentFomat:"dd-MMM-yyyy" , expectedFromat:"yyyy-MM-dd" ), "IsClosedDate": "\(self.resultCheck)", "ProviderId": "\(Authentication.customerGuid!)", "DeviceType": "M","TimeSlots":self.selectedArray,"IsAnyHalfClosedFull":self.calendarData?.IsAnyHalfClosedFull ?? false] as [String : Any]
            self.saveIsCloseFullDay(dict: dict)
            }

        }
      

        
    /*    for index in self.mrngIndexes {
            selectedArray.append(["Time": morningSlots[index].Time ?? "","isClosed": "false"])
        }
        for index in self.evngIndexes {
            selectedArray.append(["Time": eveningSlots[index].Time ?? "","isClosed": "false"])
        } */

    }
    
    func setupUI() -> Void {
        let date = Date()
        let formatter = DateFormatter()
        formatter.dateFormat = "dd-MMM-yyyy"
        let today = formatter.string(from: date)
        btnSelectDate.setTitle(today, for: .normal)
        DateTextField.text = today
        switchFullday.transform = CGAffineTransform(scaleX: 0.85, y: 0.85)
        switchMorning.transform = CGAffineTransform(scaleX: 0.85, y: 0.85)
        switchEvening.transform = CGAffineTransform(scaleX: 0.85, y: 0.85)
        
        
    }
    
}

extension CalendarViewController:CalendarPopupVCDelegate {
    func selectedDate(selected: String) {
        
        getMyCalendar(selectedDate: selected)
        self.tableEvening.reloadData()
        self.tableMorning.reloadData()

        let formateddate = self.getFormattedDate(strDate: selected, currentFomat: "yyyy-MM-dd", expectedFromat: "dd-MMM-yyyy")
        btnSelectDate.setTitle(formateddate, for: .normal)
    }
    
    
}
extension CalendarViewController: UITextFieldDelegate {
    
    func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
        if textField == self.DateTextField {
            datePickerTapped()
            return false
        }
        
        return true
    }
}


