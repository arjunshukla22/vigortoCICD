//
//  UpdateEvngHrsVC.swift
//  SmileIndia
//
//  Created by Arjun  on 16/03/20.
//  Copyright © 2020 Na. All rights reserved.
//

import UIKit
import Localize

class UpdateEvngHrsVC:  BaseViewController  , UIPickerViewDelegate, UIPickerViewDataSource, UITextFieldDelegate{

    var doctor: DoctorData?

    
    @IBOutlet weak var msTf: UITextField!
    @IBOutlet weak var meTf: UITextField!
    
    @IBOutlet weak var tusTF: UITextField!
    @IBOutlet weak var tueTf: UITextField!
    
    @IBOutlet weak var wsTf: UITextField!
    @IBOutlet weak var weTf: UITextField!
    
    @IBOutlet weak var thsTf: UITextField!
    @IBOutlet weak var theTf: UITextField!
    
    @IBOutlet weak var fsTf: UITextField!
    @IBOutlet weak var feTF: UITextField!
    
    @IBOutlet weak var sasTf: UITextField!
    @IBOutlet weak var saeTf: UITextField!
    
    @IBOutlet weak var susTf: UITextField!
    @IBOutlet weak var sueTf: UITextField!
    
    @IBOutlet weak var btnM: UIButton!
    @IBOutlet weak var btnTue: UIButton!
    @IBOutlet weak var btnWed: UIButton!
    @IBOutlet weak var btnThu: UIButton!
    @IBOutlet weak var btnFri: UIButton!
    @IBOutlet weak var btnSat: UIButton!
    @IBOutlet weak var btnSun: UIButton!
    
    
    
    var dict = [String: Any]()
    var customerType = String()
    var image: UIImage?
    var businessHour : BusinessHour?
    
    var array = [[String: Any]]()

    let dayArray = ["Monday", "Tuesday", "Wednesday", "Thursday", "Friday", "Saturday", "Sunday"]
    
    var selectedStart = 0
    var selectedEnd = 0
    
    var s1 = "0"
    var s2 = "0"
    var s3 = "0"
    var s4 = "0"
    var s5 = "0"
    var s6 = "0"
    var s7 = "0"

    var e1 = "0"
    var e2 = "0"
    var e3 = "0"
    var e4 = "0"
    var e5 = "0"
    var e6 = "0"
    var e7 = "0"
    

    var arr = [String]()

    
    let pvStart = UIPickerView()
    let pvEnd = UIPickerView()
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        setStatusBar(color: .themeGreen)

        setUpCheckBox()
        self.createPickerView()
        self.dismissPickerView()
        setPreviousTimings()
        
    }
    
    
    func setPreviousTimings() -> Void {
        
        if let object1 = doctor?.DoctorAddressTimmingList!.filter({ $0.DayId == 1 }).first {
            btnM.setImage(UIImage(named: "tick.png"), for: .normal)
            let morngStart = self.businessHour?.EveningStart!.filter({ $0.Value == "\(object1.EveningTimeStartId ?? 17)" }).first
            let morngEnd = self.businessHour?.EveningEnd!.filter({ $0.Value == "\(object1.EveningTimeEndId ?? 24)" }).first
            self.msTf.text = morngStart?.Text
            self.meTf.text = morngEnd?.Text
            
            resetImage(button: btnM, mrngStrt: self.msTf.text, mrngEnd: self.meTf.text, tf1: self.msTf, tf2: self.meTf)
        }
        
        if let object2 = doctor?.DoctorAddressTimmingList!.filter({ $0.DayId == 2 }).first {
            btnTue.setImage(UIImage(named: "tick.png"), for: .normal)
            let morngStart = self.businessHour?.EveningStart!.filter({ $0.Value == "\(object2.EveningTimeStartId ?? 17)" }).first
            let morngEnd = self.businessHour?.EveningEnd!.filter({ $0.Value == "\(object2.EveningTimeEndId ?? 24)" }).first
            self.tusTF.text = morngStart?.Text
            self.tueTf.text = morngEnd?.Text
            
            resetImage(button: btnTue, mrngStrt: self.tusTF.text, mrngEnd: self.tueTf.text, tf1: self.tusTF, tf2: self.tueTf)

        }
        
        if let object3 = doctor?.DoctorAddressTimmingList!.filter({ $0.DayId == 3 }).first {
            btnWed.setImage(UIImage(named: "tick.png"), for: .normal)
            let morngStart = self.businessHour?.EveningStart!.filter({ $0.Value == "\(object3.EveningTimeStartId ?? 17)" }).first
            let morngEnd = self.businessHour?.EveningEnd!.filter({ $0.Value == "\(object3.EveningTimeEndId ?? 24)" }).first
            self.wsTf.text = morngStart?.Text
            self.weTf.text = morngEnd?.Text
            
            resetImage(button: btnWed, mrngStrt: self.wsTf.text, mrngEnd: self.weTf.text, tf1: self.wsTf, tf2: self.weTf)

        }
        
        if let object4 = doctor?.DoctorAddressTimmingList!.filter({ $0.DayId == 4 }).first {
            btnThu.setImage(UIImage(named: "tick.png"), for: .normal)
            let morngStart = self.businessHour?.EveningStart!.filter({ $0.Value == "\(object4.EveningTimeStartId ?? 17)" }).first
            let morngEnd = self.businessHour?.EveningEnd!.filter({ $0.Value == "\(object4.EveningTimeEndId ?? 24)" }).first
            self.thsTf.text = morngStart?.Text
            self.theTf.text = morngEnd?.Text
            
            resetImage(button: btnThu, mrngStrt: self.thsTf.text, mrngEnd: self.theTf.text, tf1: self.thsTf, tf2: self.theTf)

        }
        
        if let object5 = doctor?.DoctorAddressTimmingList!.filter({ $0.DayId == 5 }).first {
            btnFri.setImage(UIImage(named: "tick.png"), for: .normal)
            let morngStart = self.businessHour?.EveningStart!.filter({ $0.Value == "\(object5.EveningTimeStartId ?? 17)" }).first
            let morngEnd = self.businessHour?.EveningEnd!.filter({ $0.Value == "\(object5.EveningTimeEndId ?? 24)" }).first
            self.fsTf.text = morngStart?.Text
            self.feTF.text = morngEnd?.Text
            
            resetImage(button: btnFri, mrngStrt: self.fsTf.text, mrngEnd: self.feTF.text, tf1: self.fsTf, tf2: self.feTF)

        }
        
        if let object6 = doctor?.DoctorAddressTimmingList!.filter({ $0.DayId == 6 }).first {
            btnSat.setImage(UIImage(named: "tick.png"), for: .normal)
            let morngStart = self.businessHour?.EveningStart!.filter({ $0.Value == "\(object6.EveningTimeStartId ?? 17)" }).first
            let morngEnd = self.businessHour?.EveningEnd!.filter({ $0.Value == "\(object6.EveningTimeEndId ?? 24)" }).first
            self.sasTf.text = morngStart?.Text
            self.saeTf.text = morngEnd?.Text
            
            resetImage(button: btnSat, mrngStrt: self.sasTf.text, mrngEnd: self.saeTf.text, tf1: self.sasTf, tf2: self.saeTf)

        }
        
        if let object7 = doctor?.DoctorAddressTimmingList!.filter({ $0.DayId == 7 }).first {
            btnSun.setImage(UIImage(named: "tick.png"), for: .normal)
            let morngStart = self.businessHour?.EveningStart!.filter({ $0.Value == "\(object7.EveningTimeStartId ?? 17)" }).first
            let morngEnd =  self.businessHour?.EveningEnd!.filter({ $0.Value == "\(object7.EveningTimeEndId ?? 24)" }).first
            self.susTf.text = morngStart?.Text
            self.sueTf.text = morngEnd?.Text
            
            resetImage(button: btnSun, mrngStrt: self.susTf.text, mrngEnd: self.sueTf.text, tf1: self.susTf, tf2: self.sueTf)

        }
    }
    
        func numberOfComponents(in pickerView: UIPickerView) -> Int {
             return 1
         }
         
         func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
             if pickerView == self.pvStart {
             return (self.businessHour?.EveningStart!.count)!

             }else
             {
                 return (self.businessHour?.EveningEnd!.count)!
             }
         }
         
         func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
             if pickerView == self.pvStart {
             return self.businessHour?.EveningStart![row].Text ?? ""
             }else
             {
                 return self.businessHour?.EveningEnd![row].Text ?? ""
             }
            
         }
         
         func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {

             if pickerView == self.pvStart {
                selectedStart = row
             }else
             {
                 selectedEnd = row
             }
         }
        
    
        func setUpCheckBox() -> Void {
            
            btnM.layer.cornerRadius = 5
            btnM.layer.borderWidth = 2
            btnM.layer.borderColor = UIColor.lightGray.cgColor
            
            btnTue.layer.cornerRadius = 5
            btnTue.layer.borderWidth = 2
            btnTue.layer.borderColor = UIColor.lightGray.cgColor
            
            btnWed.layer.cornerRadius = 5
            btnWed.layer.borderWidth = 2
            btnWed.layer.borderColor = UIColor.lightGray.cgColor
            
            btnThu.layer.cornerRadius = 5
            btnThu.layer.borderWidth = 2
            btnThu.layer.borderColor = UIColor.lightGray.cgColor
            
            btnFri.layer.cornerRadius = 5
            btnFri.layer.borderWidth = 2
            btnFri.layer.borderColor = UIColor.lightGray.cgColor
            
            btnSat.layer.cornerRadius = 5
            btnSat.layer.borderWidth = 2
            btnSat.layer.borderColor = UIColor.lightGray.cgColor
            
            btnSun.layer.cornerRadius = 5
            btnSun.layer.borderWidth = 2
            btnSun.layer.borderColor = UIColor.lightGray.cgColor

        }
        
        func applyAll() -> Void {
            
            btnSun.setImage(UIImage.init(named: "tick"), for: .normal)
            btnSat.setImage(UIImage.init(named: "tick"), for: .normal)
            btnFri.setImage(UIImage.init(named: "tick"), for: .normal)
            btnThu.setImage(UIImage.init(named: "tick"), for: .normal)
            btnWed.setImage(UIImage.init(named: "tick"), for: .normal)
            btnTue.setImage(UIImage.init(named: "tick"), for: .normal)
            btnM.setImage(UIImage.init(named: "tick"), for: .normal)
            
            arr = ["1","2","3","4","5","6","7"]
            
            
            
            var allStime = "17"
            var allEtime = "24"

            for i in 0..<(self.businessHour?.EveningStart?.count)!
            {
                if msTf.text == self.businessHour?.EveningStart![i].Text  {
                    allStime = self.businessHour?.EveningStart![i].Value ?? "17"
                }
            }
            
            for i in 0..<(self.businessHour?.EveningEnd?.count)!
               {
                   if meTf.text == self.businessHour?.EveningEnd![i].Text  {
                       allEtime = self.businessHour?.EveningEnd![i].Value ?? "24"
                   }
               }
            
             s1 = allStime
             s2 = allStime
             s3 = allStime
             s4 = allStime
             s5 = allStime
             s6 = allStime
             s7 = allStime

             e1 = allEtime
             e2 = allEtime
             e3 = allEtime
             e4 = allEtime
             e5 = allEtime
             e6 = allEtime
             e7 = allEtime
            
            msTf.text = msTf.text
            tusTF.text = msTf.text
            wsTf.text = msTf.text
            thsTf.text = msTf.text
            fsTf.text = msTf.text
            sasTf.text = msTf.text
            susTf.text = msTf.text

            meTf.text = meTf.text
            tueTf.text = meTf.text
            weTf.text = meTf.text
            theTf.text = meTf.text
            feTF.text = meTf.text
            saeTf.text = meTf.text
            sueTf.text = meTf.text
            
    //         for i in 0..<dayArray.count{
    //      array.append(["DayId": i+1, "EveningTimingIdStart": allStime , "EveningTimingIdEnd": allEtime])
    //        }
            
        }
        
        func createPickerView() {
            pvStart.delegate = self
            pvEnd.delegate = self
            
            msTf.rightViewMode = UITextField.ViewMode.always
            msTf.rightView = UIImageView(image: UIImage(named: "dropdown"))
            
            meTf.rightViewMode = UITextField.ViewMode.always
            meTf.rightView = UIImageView(image: UIImage(named: "dropdown"))
            
            tusTF.rightViewMode = UITextField.ViewMode.always
            tusTF.rightView = UIImageView(image: UIImage(named: "dropdown"))
            
            tueTf.rightViewMode = UITextField.ViewMode.always
            tueTf.rightView = UIImageView(image: UIImage(named: "dropdown"))
            
            wsTf.rightViewMode = UITextField.ViewMode.always
            wsTf.rightView = UIImageView(image: UIImage(named: "dropdown"))
            
            weTf.rightViewMode = UITextField.ViewMode.always
            weTf.rightView = UIImageView(image: UIImage(named: "dropdown"))
            
            thsTf.rightViewMode = UITextField.ViewMode.always
            thsTf.rightView = UIImageView(image: UIImage(named: "dropdown"))
            
            theTf.rightViewMode = UITextField.ViewMode.always
            theTf.rightView = UIImageView(image: UIImage(named: "dropdown"))
            
            fsTf.rightViewMode = UITextField.ViewMode.always
            fsTf.rightView = UIImageView(image: UIImage(named: "dropdown"))
            
            feTF.rightViewMode = UITextField.ViewMode.always
            feTF.rightView = UIImageView(image: UIImage(named: "dropdown"))
            
            sasTf.rightViewMode = UITextField.ViewMode.always
            sasTf.rightView = UIImageView(image: UIImage(named: "dropdown"))
            
            saeTf.rightViewMode = UITextField.ViewMode.always
            saeTf.rightView = UIImageView(image: UIImage(named: "dropdown"))
            
            susTf.rightViewMode = UITextField.ViewMode.always
            susTf.rightView = UIImageView(image: UIImage(named: "dropdown"))
            
            sueTf.rightViewMode = UITextField.ViewMode.always
            sueTf.rightView = UIImageView(image: UIImage(named: "dropdown"))

            msTf.inputView = pvStart
            tusTF.inputView = pvStart
            wsTf.inputView = pvStart
            thsTf.inputView = pvStart
            fsTf.inputView = pvStart
            sasTf.inputView = pvStart
            susTf.inputView = pvStart

            meTf.inputView = pvEnd
            tueTf.inputView = pvEnd
            weTf.inputView = pvEnd
            theTf.inputView = pvEnd
            feTF.inputView = pvEnd
            saeTf.inputView = pvEnd
            sueTf.inputView = pvEnd
        }
        
        func dismissPickerView() {
            let toolBar = UIToolbar()
            toolBar.sizeToFit()
            
            let button = UIBarButtonItem(title: "Done", style: .done, target: self, action: #selector(self.action))
            button.tintColor = .lightGray
            toolBar.setItems([button], animated: true)
            toolBar.isUserInteractionEnabled = true
            
            msTf.inputAccessoryView = toolBar
            meTf.inputAccessoryView = toolBar
            
            tusTF.inputAccessoryView = toolBar
            tueTf.inputAccessoryView = toolBar
            
            wsTf.inputAccessoryView = toolBar
            weTf.inputAccessoryView = toolBar

            thsTf.inputAccessoryView = toolBar
            theTf.inputAccessoryView = toolBar
            
            
            fsTf.inputAccessoryView = toolBar
            feTF.inputAccessoryView = toolBar
            
            saeTf.inputAccessoryView = toolBar
            sasTf.inputAccessoryView = toolBar
            
            susTf.inputAccessoryView = toolBar
            sueTf.inputAccessoryView = toolBar

        }
        
        @objc func action() {
            if msTf.isEditing == true {
                msTf.text = self.businessHour?.EveningStart![selectedStart].Text
                self.s1 = (self.businessHour?.EveningStart![selectedStart].Value)!
            }
            else if tusTF.isEditing == true {
            tusTF.text = self.businessHour?.EveningStart![selectedStart].Text
                self.s2 = (self.businessHour?.EveningStart![selectedStart].Value)!

            }
            else if wsTf.isEditing == true {
                wsTf.text = self.businessHour?.EveningStart![selectedStart].Text
                self.s3 = (self.businessHour?.EveningStart![selectedStart].Value)!

            }else if thsTf.isEditing == true {
                thsTf.text = self.businessHour?.EveningStart![selectedStart].Text
                self.s4 = (self.businessHour?.EveningStart![selectedStart].Value)!

            }else if fsTf.isEditing == true {
                fsTf.text = self.businessHour?.EveningStart![selectedStart].Text
                self.s5 = (self.businessHour?.EveningStart![selectedStart].Value)!

            }
            else if sasTf.isEditing == true {
                sasTf.text = self.businessHour?.EveningStart![selectedStart].Text
                self.s6 = (self.businessHour?.EveningStart![selectedStart].Value)!

            }else if susTf.isEditing == true {
                susTf.text = self.businessHour?.EveningStart![selectedStart].Text
                self.s7 = (self.businessHour?.EveningStart![selectedStart].Value)!

            }
            
             else if meTf.isEditing == true {
                 meTf.text = self.businessHour?.EveningEnd![selectedEnd].Text
                self.e1 = (self.businessHour?.EveningEnd![selectedEnd].Value)!

             }
            else if tueTf.isEditing == true {
                 tueTf.text = self.businessHour?.EveningEnd![selectedEnd].Text
                self.e2 = (self.businessHour?.EveningEnd![selectedEnd].Value)!

             }
             else if weTf.isEditing == true {
                 weTf.text = self.businessHour?.EveningEnd![selectedEnd].Text
                self.e3 = (self.businessHour?.EveningEnd![selectedEnd].Value)!

             }
            else if theTf.isEditing == true {
                 theTf.text = self.businessHour?.EveningEnd![selectedEnd].Text
                self.e4 = (self.businessHour?.EveningEnd![selectedEnd].Value)!

             }
             else if feTF.isEditing == true {
                 feTF.text = self.businessHour?.EveningEnd![selectedEnd].Text
                self.e5 = (self.businessHour?.EveningEnd![selectedEnd].Value)!

             }
            else if saeTf.isEditing == true {
                 saeTf.text = self.businessHour?.EveningEnd![selectedEnd].Text
                self.e6 = (self.businessHour?.EveningEnd![selectedEnd].Value)!

             }else
            {
                sueTf.text = self.businessHour?.EveningEnd![selectedEnd].Text
                self.e7 = (self.businessHour?.EveningEnd![selectedEnd].Value)!

            }
           view.endEditing(true)
        }
        
        @IBAction func didTapMonday(_ sender: UIButton) {
            if btnM.hasImage(named: "tick.png", for: .normal) {
                btnM.setImage(nil, for: .normal)
                
                self.e1 = "0"
                self.s1 = "0"
            } else {
                btnM.setImage(UIImage(named: "tick.png"), for: .normal)
                
                if s1 == "0" {
                    self.s1 = getStartTime(time: msTf.text ?? "02:00 PM")
                }
                
                if e1 == "0" {
                    self.e1 = getEndTime(time: meTf.text ?? "02:00 PM")
                }
            }
        }
        
        
        @IBAction func didTapTuesday(_ sender: UIButton) {
            if btnTue.hasImage(named: "tick.png", for: .normal) {
                btnTue.setImage(nil, for: .normal)

                self.e2 = "0"
                self.s2 = "0"
            } else {
                btnTue.setImage(UIImage(named: "tick.png"), for: .normal)
                
                if s2 == "0" {
                    self.s2 = getStartTime(time: tusTF.text ?? "02:00 PM")
                }
                
                if e2 == "0" {
                    self.e2 = getEndTime(time: tueTf.text ?? "02:00 PM")
                }

            }
            
        }
        
        @IBAction func didTapWed(_ sender: UIButton) {
            if btnWed.hasImage(named: "tick.png", for: .normal) {
                btnWed.setImage(nil, for: .normal)

                self.e3 = "0"
                self.s3 = "0"
            } else {
                btnWed.setImage(UIImage(named: "tick.png"), for: .normal)
                
                if s3 == "0" {
                    self.s3 = getStartTime(time: wsTf.text ?? "02:00 PM")
                }
                
                if e3 == "0" {
                    self.e3 = getEndTime(time: weTf.text ?? "02:00 PM")
                }

            }
        }
        
        @IBAction func didTapThursday(_ sender: UIButton) {
            if btnThu.hasImage(named: "tick.png", for: .normal) {
                btnThu.setImage(nil, for: .normal)

                self.e4 = "0"
                self.s4 = "0"
            } else {
                btnThu.setImage(UIImage(named: "tick.png"), for: .normal)
                if s4 == "0" {
                    self.s4 = getStartTime(time: thsTf.text ?? "02:00 PM")
                }
                
                if e4 == "0" {
                    self.e4 = getEndTime(time: theTf.text ?? "02:00 PM")
                }
            }
        }
        
        @IBAction func didTapFriday(_ sender: UIButton) {
            if btnFri.hasImage(named: "tick.png", for: .normal) {
                btnFri.setImage(nil, for: .normal)

                self.e5 = "0"
                self.s5 = "0"
            } else {
                btnFri.setImage(UIImage(named: "tick.png"), for: .normal)
                if s5 == "0" {
                    self.s5 = getStartTime(time: fsTf.text ?? "02:00 PM")
                }
                
                if e5 == "0" {
                    self.e5 = getEndTime(time: feTF.text ?? "02:00 PM")
                }
            }
        }
        @IBAction func didTapSaturday(_ sender: UIButton) {
            if btnSat.hasImage(named: "tick.png", for: .normal) {
                btnSat.setImage(nil, for: .normal)

                self.e6 = "0"
                self.s6 = "0"
            } else {
                btnSat.setImage(UIImage(named: "tick.png"), for: .normal)
                if s6 == "0" {
                    self.s6 = getStartTime(time: sasTf.text ?? "02:00 PM")
                }
                
                if e6 == "0" {
                    self.e6 = getEndTime(time: saeTf.text ?? "02:00 PM")
                }
            }
        }
        
        @IBAction func didTapSunday(_ sender: UIButton) {
            if btnSun.hasImage(named: "tick.png", for: .normal) {
                btnSun.setImage(nil, for: .normal)

                self.e7 = "0"
                self.s7 = "0"
            } else {
                btnSun.setImage(UIImage(named: "tick.png"), for: .normal)
                if s7 == "0" {
                    self.s7 = getStartTime(time: susTf.text ?? "02:00 PM")
                }
                
                if e7 == "0" {
                    self.e7 = getEndTime(time: sueTf.text ?? "02:00 PM")
                }
            }
        }
        
        
        
        
    @IBAction func didTapApplyAll(_ sender: UIButton) {
            applyAll()
    }
        
    
    @IBAction func didTapBack(_ sender: UIButton) {
        NavigationHandler.pop()
    }
    
        
        @IBAction func didTapNext(_ sender: UIButton) {
            
          //    array.removeAll()
              
              if isValid()
              {

                  if btnM.hasImage(named: "tick.png", for: .normal) {
                    
                    if let index = array.index(where: { $0["DayId"] as! Int == 1}) {
                        array[index]["EveningTimingIdStart"] = getStartTime(time: msTf.text ?? "02:00 PM")
                        array[index]["EveningTimingIdEnd"] = getEndTime(time: meTf.text ?? "02:00 PM")
                    }
                    else {
                    array.append(["DayId": 1, "EveningTimingIdStart": getStartTime(time: msTf.text ?? "02:00 PM") , "EveningTimingIdEnd": getEndTime(time: meTf.text ?? "02:00 PM")])
                    }
                  }
                  
                  if btnTue.hasImage(named: "tick.png", for: .normal) {
                    if let index = array.index(where: { $0["DayId"] as! Int == 2}) {
                        array[index]["EveningTimingIdStart"] =  getStartTime(time: tusTF.text ?? "02:00 PM")
                        array[index]["EveningTimingIdEnd"] = getEndTime(time: tueTf.text ?? "02:00 PM")
                    }
                    else {
                    array.append(["DayId": 2, "EveningTimingIdStart": getStartTime(time: tusTF.text ?? "02:00 PM") , "EveningTimingIdEnd": getEndTime(time: tueTf.text ?? "02:00 PM")])
                    }
                  }
                  
                  if btnWed.hasImage(named: "tick.png", for: .normal) {
                    if let index = array.index(where: { $0["DayId"] as! Int == 3}) {
                        array[index]["EveningTimingIdStart"] =  getStartTime(time: wsTf.text ?? "02:00 PM")
                        array[index]["EveningTimingIdEnd"] =  getEndTime(time: weTf.text ?? "02:00 PM")
                    }
                    else {
                    array.append(["DayId": 3, "EveningTimingIdStart": getStartTime(time: wsTf.text ?? "02:00 PM") , "EveningTimingIdEnd": getEndTime(time: weTf.text ?? "02:00 PM")])
                    }
                  }
                  
                  if btnThu.hasImage(named: "tick.png", for: .normal) {
                    if let index = array.index(where: { $0["DayId"] as! Int == 4}) {
                        array[index]["EveningTimingIdStart"] = getStartTime(time: thsTf.text ?? "02:00 PM")
                        array[index]["EveningTimingIdEnd"] =   getEndTime(time: theTf.text ?? "02:00 PM")
                    }
                    else {
                    array.append(["DayId": 4, "EveningTimingIdStart": getStartTime(time: thsTf.text ?? "02:00 PM") , "EveningTimingIdEnd": getEndTime(time: theTf.text ?? "02:00 PM")])
                    }
                  }

                  if btnFri.hasImage(named: "tick.png", for: .normal) {
                    if let index = array.index(where: { $0["DayId"] as! Int == 5}) {
                        array[index]["EveningTimingIdStart"] = getStartTime(time: fsTf.text ?? "02:00 AM")
                        array[index]["EveningTimingIdEnd"] =   getEndTime(time: feTF.text ?? "02:00 AM")
                    }
                    else {
                    array.append(["DayId": 5, "EveningTimingIdStart": getStartTime(time: fsTf.text ?? "02:00 PM") , "EveningTimingIdEnd": getEndTime(time: feTF.text ?? "02:00 PM")])
                    }
                  }
                  
                  if btnSat.hasImage(named: "tick.png", for: .normal) {
                    if let index = array.index(where: { $0["DayId"] as! Int == 6}) {
                        array[index]["EveningTimingIdStart"] = getStartTime(time: sasTf.text ?? "02:00 PM")
                        array[index]["EveningTimingIdEnd"] =   getEndTime(time: saeTf.text ?? "02:00 PM")
                    }
                    else {
                    array.append(["DayId": 6, "EveningTimingIdStart": getStartTime(time: sasTf.text ?? "02:00 PM") , "EveningTimingIdEnd": getEndTime(time: saeTf.text ?? "02:00 PM")])
                    }
                  }
                  
                  if btnSun.hasImage(named: "tick.png", for: .normal) {
                    if let index = array.index(where: { $0["DayId"] as! Int == 7}) {
                        array[index]["EveningTimingIdStart"] = getStartTime(time: susTf.text ?? "02:00 PM")
                        array[index]["EveningTimingIdEnd"] =   getEndTime(time: sueTf.text ?? "02:00 PM")
                    }
                    else {
                    array.append(["DayId": 7, "EveningTimingIdStart": getStartTime(time: susTf.text ?? "02:00 PM") , "EveningTimingIdEnd": getEndTime(time: sueTf.text ?? "02:00 PM")])
                    }
                  }
                  
                print(array)
                  if array.count > 0 {
                      array = array.sorted(by: {($0["DayId"] as! Int) < ($1["DayId"] as! Int)})
                  }
                print(array)

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
                 dict["LoginKey"] = Authentication.token
                
                if array.count <= 0
                {
                    AlertManager.showAlert(type: .custom(ProfileUpdate.selectOneDayWeek.localize()))
                }else
                {
                    AlertManager.showAlert(type: .custom(ProfileUpdate.areYouSureUpdateProfile.localize()), actionTitle: AlertBtnTxt.okay.localize()) {
                        self.update()
                        }
                    
                }

              }
              
        }
        
        
        func isValid() -> Bool {
            
            if modifyStartTimeConvert(text: msTf.text ?? "02:00 PM") >= modifyEndTimeConvert(text: meTf.text ?? "02:00 PM") && btnM.hasImage(named: "tick.png", for: .normal){
                AlertManager.showAlert(type: .custom(ProfileUpdate.evgTimeCanNot.localize()))
                return false
            }else if modifyStartTimeConvert(text: tusTF.text ?? "02:00 PM") >= modifyEndTimeConvert(text: tueTf.text ?? "02:00 PM") && btnTue.hasImage(named: "tick.png", for: .normal)
            {
                AlertManager.showAlert(type: .custom(ProfileUpdate.evgTimeCanNot.localize()))
                return false
                
            }else if modifyStartTimeConvert(text: wsTf.text ?? "02:00 PM") >= modifyEndTimeConvert(text: weTf.text ?? "02:00 PM") && btnWed.hasImage(named: "tick.png", for: .normal)
            {
                AlertManager.showAlert(type: .custom(ProfileUpdate.evgTimeCanNot.localize()))
                return false
                
            }else if modifyStartTimeConvert(text: thsTf.text ?? "02:00 PM") >= modifyEndTimeConvert(text: theTf.text ?? "02:00 PM") && btnThu.hasImage(named: "tick.png", for: .normal)
            {
                AlertManager.showAlert(type: .custom(ProfileUpdate.evgTimeCanNot.localize()))
                return false
                
            }else if modifyStartTimeConvert(text: fsTf.text ?? "02:00 PM") >= modifyEndTimeConvert(text: feTF.text ?? "02:00 PM") && btnFri.hasImage(named: "tick.png", for: .normal)
            {
                AlertManager.showAlert(type: .custom(ProfileUpdate.evgTimeCanNot.localize()))
                return false
                
            }else if modifyStartTimeConvert(text: sasTf.text ?? "02:00 PM") >= modifyEndTimeConvert(text: saeTf.text ?? "02:00 PM") && btnSat.hasImage(named: "tick.png", for: .normal)
            {
                AlertManager.showAlert(type: .custom(ProfileUpdate.evgTimeCanNot.localize()))
                return false
                
            }else if modifyStartTimeConvert(text: susTf.text ?? "02:00 PM") >= modifyEndTimeConvert(text: sueTf.text ?? "02:00 PM") && btnSun.hasImage(named: "tick.png", for: .normal)
            {
                AlertManager.showAlert(type: .custom(ProfileUpdate.evgTimeCanNot.localize()))
                return false
                
            }
            
            return true
        }
        
        func modifyStartTimeConvert(text:String) -> Int {
            
             var startTime = 0
             startTime = Int((text.replacingOccurrences(of: " PM", with: "")).replacingOccurrences(of: ":00", with: "")) ??  0
            return startTime
        }
            
        func modifyEndTimeConvert(text:String) -> Int {
            
             var endTime = 0
            if (text.contains(":30"))
            {
                endTime = Int((text.replacingOccurrences(of: " PM", with: "")).replacingOccurrences(of: ":30", with: "")) ?? 0
            }else
            {
                endTime = Int((text.replacingOccurrences(of: " PM", with: "")).replacingOccurrences(of: ":00", with: "")) ?? 0
            }

                 return endTime
        }
            
            
        func getStartTime(time:String) -> String {
                var startTime = "17"

                for i in 0..<(self.businessHour?.EveningStart?.count)!
                {
                    if time == self.businessHour?.EveningStart![i].Text  {
                        startTime = self.businessHour?.EveningStart![i].Value ?? "17"
                    }
                }
                return startTime
            }
            
        func getEndTime(time:String) -> String {
                var endTime = "24"

                        for i in 0..<(self.businessHour?.EveningEnd?.count)!
                   {
                       if time == self.businessHour?.EveningEnd![i].Text  {
                           endTime = self.businessHour?.EveningEnd![i].Value ?? "24"
                       }
                   }
                return endTime
        }

}


extension UpdateEvngHrsVC{
    func update() {
        self.view.endEditing(true)
        self.view.activityStartAnimating(activityColor: .themeGreen, backgroundColor: UIColor.white)
        WebService.updateDoctor(queryItems: dict) { (result) in
            
            DispatchQueue.main.async {
                switch result {
                case .success:
                    
                    if let data = self.image?.jpegData(compressionQuality: 0.5) {
                        let queryItems = ["AuthKey": Constants.authKey, "CustomerId": Authentication.customerGuid ?? 0, "image": self.image?.jpegData(compressionQuality: 0.5) ?? UIImage()] as [String : Any]
                        self.uploadImage(queryItems)
                    }
                    else{
                        let queryItems = ["AuthKey": Constants.authKey, "CustomerId": Authentication.customerGuid ?? 0, "image": ""] as [String : Any]
                        self.uploadImage(queryItems)
                    }
                 
                case .failure(let error):
                    AlertManager.showAlert(type: .custom(error.message), title: AlertBtnTxt.okay.localize(), action: {
                        
                    })
                }
                self.view.activityStopAnimating()
            }
           
        }
    }
    
    func uploadImage(_ query: [String: Any])  {
        self.view.endEditing(true)
        self.view.activityStartAnimating(activityColor:.themeGreen, backgroundColor: UIColor.white)
        WebService.uploadImage(queryItems: query) { (result) in
            DispatchQueue.main.async {
                switch result {
                case .success:
                    AlertManager.showAlert(type: .custom( ProfileUpdate.profileUpdateSucess.localize()), title: AlertBtnTxt.okay.localize(), action: {
                        // Profile Complete Succesfully
                        Authentication.profileComplete = true
                        Authentication.isUserLoggedIn = true
                      // Authentication.customerName = "\( self.dict["FirstName"] ?? "")" + " " + "\(self.dict["LastName"] ?? "")"
                        NavigationHandler.pushTo(.homeViewController)
                       // NavigationHandler.pushTo(HomeViewController.self)
                    })
                case .failure(let error):
                    AlertManager.showAlert(type: .custom(error.message))
                }
                self.view.activityStopAnimating()
            }
        }
    }
    

    func resetImage(button:UIButton , mrngStrt:String?,mrngEnd:String?,tf1:UITextField?,tf2:UITextField?) -> Void {
       if mrngStrt == "" && mrngEnd == ""
        {
            button.setImage(nil, for: .normal)
            tf1!.text = "02:00 PM"
            tf2!.text = "02:00 PM"
        }
    }
}

