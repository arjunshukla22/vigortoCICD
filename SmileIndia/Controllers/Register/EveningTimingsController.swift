//
//  EveningTimingsController.swift
//  SmileIndia
//
//  Created by Na on 17/02/19.
//  Copyright © 2019 Na. All rights reserved.
//

import UIKit
import ActiveLabel

class EveningTimingsController: BaseViewController {
    
    var arr = [String]()
    
    @IBOutlet weak var screenTitleLabel: UIButton!
    @IBOutlet weak var termsPolicyLabel: ActiveLabel!
    @IBOutlet weak var tickImageView: UIImageView!
    @IBOutlet weak var timingTableView: UITableView!
    var isApplyAll = false
    var customerType = String()
    var image: UIImage?
    var businessHour : BusinessHour?
    var datasource = GenericDataSource()
    var dict = [String: Any]()
    var array = [[String: Any]]()
    let dayArray = ["Monday", "Tuesday", "Wednesday", "Thursday", "Friday", "Saturday", "Sunday"]
    var isSubmit = Bool(){
        didSet{
            tickImageView.isHidden = !isSubmit
        }
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        screenTitleLabel.setTitle(customerType == "1" ? "DOCTOR REGISTRATION" : "HOSPITAL REGISTRATION", for: .normal)
        setUpCell()
        setFonts()
        
        
    }
    
    @IBAction func didTapBackButton(_ sender: Any) {
        NavigationHandler.pop()
    }
    
    @IBAction func didTapApplyAll(_ sender: Any) {
        isApplyAll = true
        timingTableView.reloadData()
        setUpCell()
    }
    
    @IBAction func didTapAcceptButton(_ sender: Any) {
        isSubmit = tickImageView.isHidden
    }
    @IBAction func didTapSubmitButton(_ sender: Any) {
        
        arr.removeAll()
        
        if isValid() {
            for i in 0..<dayArray.count{
                guard let cell = timingTableView.cellForRow(at: IndexPath.init(row: i, section: 0)) as? TimingsCell else {return}
                var start = "17"
                var end = "24"
                if isApplyAll && i == 1 {
                    start = cell.startTimeTextfield.accessibilityLabel ?? "17"
                    end = cell.endTimeTextfield.accessibilityLabel ?? "24"
                }
                if !cell.tickImageView.isHidden{
                    if let index = array.index(where: { $0["DayId"] as! Int == i+1}) {
                        array[index]["EveningTimingIdStart"] = isApplyAll ? start : cell.startTimeTextfield.accessibilityLabel ?? "17"
                        array[index]["EveningTimingIdEnd"] = isApplyAll ? end : cell.endTimeTextfield.accessibilityLabel ?? "24"
                    }
                    else {
                            array.append(["DayId": i+1, "EveningTimingIdStart": isApplyAll ? start : cell.startTimeTextfield.accessibilityLabel ?? start , "EveningTimingIdEnd": isApplyAll ? end : cell.endTimeTextfield.accessibilityLabel ?? end])
                    }
                    
                    
                     var startTime = 0
                     let startT = cell.startTimeTextfield.text
                     startTime = Int((startT?.replacingOccurrences(of: " PM", with: ""))!.replacingOccurrences(of: ":00", with: "")) ??  0
                                        
                     var endTime = 0
                     let endT = cell.endTimeTextfield.text
                    if (endT?.contains(":30"))!
                    {
                        endTime = Int((endT?.replacingOccurrences(of: " PM", with: ""))!.replacingOccurrences(of: ":30", with: "")) ?? 0
                    }else
                    {
                        endTime = Int((endT?.replacingOccurrences(of: " PM", with: ""))!.replacingOccurrences(of: ":00", with: "")) ?? 0
                    }
                    if startTime >= endTime  {
                    arr.append("1")
                    }

                }
            }
            
            if array.count > 0 {
                array = array.sorted(by: {($0["DayId"] as! Int) < ($1["DayId"] as! Int)})
            }
            


            let json = try? JSONSerialization.data(withJSONObject: array, options: JSONSerialization.WritingOptions.prettyPrinted)
            dict["BussinessModelArray"] = String(data: json ?? Data(), encoding: String.Encoding.utf8)
            dict["OtherHospitalName"] = ""
            dict["OtherAddress1"] = ""
            dict["OtherAddress2"] = ""
            dict["OtherCityId"] = "0"
            dict["OtherStatesId"] = "0"
            dict["OtherZipCode"] = "0"
            dict["OtherBussinessModelArray"] = "[]"
           // dict["TellAboutYourSelf"] = ""
            dict["Otherdetails"] = false
            dict["OtherLatitude"] = ""
            dict["OtherLongitude"] = ""
            dict["Password"] =  ""
            
            if arr.count > 0
            {
                AlertManager.showAlert(type: .custom("Evening end timings cannot be lower than or similar to evening start timings."))
            }else
            {
                registerUser(dict)
            }
            
        }
        
    }
}
extension EveningTimingsController{
    
    func setUpCell(){
        datasource.array = dayArray
        datasource.identifier = TimingsCell.identifier
        timingTableView.dataSource = datasource
        timingTableView.delegate = datasource
        datasource.configure = {cell, index in
            guard let timingsCell = cell as? TimingsCell else { return }
            timingsCell.isMorning = false
            timingsCell.object = self.businessHour
            timingsCell.dayLabel.text = self.dayArray[index]
            timingsCell.startTimeTextfield.text = self.businessHour?.EveningStart![0].Text
            timingsCell.endTimeTextfield.text = self.businessHour?.EveningEnd![0].Text
            timingsCell.tickImageView.isHidden = !self.isApplyAll
        }
        datasource.didScroll = {
        }
        datasource.didSelect = {cell,_  in
            guard let timingsCell = cell as? TimingsCell else { return }
            timingsCell.tickImageView.isHidden = !timingsCell.tickImageView.isHidden
        }
    }
    
    func registerUser(_ query: [String: Any])  {
        self.view.endEditing(true)
        self.view.activityStartAnimating(activityColor: .themeGreen, backgroundColor: UIColor.white)
        WebService.registerUser(queryItems: query) { (result) in
            DispatchQueue.main.async {
                switch result {
                case .success(let response):
                    if let user = response.object {
                        if self.image != nil {
                            let queryItems = ["AuthKey": Constants.authKey, "CustomerId": user.token ?? "", "image": self.image?.jpegData(compressionQuality: 0.5) ?? UIImage()] as [String : Any]
                            self.uploadImage(queryItems)
                        } else {
                            AlertManager.showAlert(type: .custom( "Registration done successfully."), title: AlertBtnTxt.okay.localize(), action: {
                                NavigationHandler.setRoot(.welcome)
                            })
                        }
                    } else { self.showError(message: response.message ?? "")  }
                case .failure(let error):
                    AlertManager.showAlert(type: .custom(error.message))
                }
                self.view.activityStopAnimating()
            }
        }
    }
    func uploadImage(_ query: [String: Any])  {
        self.view.endEditing(true)
        self.view.activityStartAnimating(activityColor: .themeGreen, backgroundColor: UIColor.white)
        WebService.uploadImage(queryItems: query) { (result) in
            DispatchQueue.main.async {
                switch result {
                case .success:
                    AlertManager.showAlert(type: .custom( "Registration done successfully."), title: AlertBtnTxt.okay.localize(), action: {
                        NavigationHandler.setRoot(.welcome)
                    })
                case .failure(let error):
                    AlertManager.showAlert(type: .custom(error.message))
                }
                self.view.activityStopAnimating()
            }
        }
    }
}
extension EveningTimingsController{
    func isValid() -> Bool {
        
        if array.count <= 0 {
            AlertManager.showAlert(type: .custom("Please select atleast one day of week."))
            return false
        }else  if !isSubmit{
            AlertManager.showAlert(type: .custom("Please agree to terms and conditions of Smile India."))
            return false
       }
        return true
    }
    //MARK:- Set Fonts
    func  setFonts()  {
        let customType1 = ActiveType.custom(pattern: "\\sTerms\\s&\\sConditions\\b")
         let customType2 = ActiveType.custom(pattern: "\\sPrivacy\\sPolicy\\b")
        termsPolicyLabel.enabledTypes = [customType1, customType2]
        termsPolicyLabel.customize { label in
            label.configureLinkAttribute = { (type, attributes, isSelected) in
                var atts = attributes
                atts[NSAttributedString.Key.underlineStyle] = NSUnderlineStyle.single.rawValue
                return atts
            }
            label.highlightFontName = UIFont.Style.bold.name
            label.highlightFontSize = UIFont.Size.h6.floatValue
            label.customColor[customType1] = UIColor.themeGreen
            label.customSelectedColor[customType1] = UIColor.themeGreen
            label.handleCustomTap(for: customType1, handler: { element in
                if let url = URL(string: "https://www.smileindia.com/terms-and-conditions.pdf") {
                    UIApplication.shared.open(url, options: [:])
                }
            })
            label.customColor[customType2] = UIColor.themeGreen
            label.customSelectedColor[customType2] = UIColor.themeGreen
            label.handleCustomTap(for: customType2, handler: { element in
                if let url = URL(string: "https://www.smileindia.com/security-and-privacy.pdf") {
                    UIApplication.shared.open(url, options: [:])
                }
            })
        }
    }
}

