//
//  UpdateBusinessHrsVC.swift
//  SmileIndia
//
//  Created by Arjun  on 16/03/20.
//  Copyright © 2020 Na. All rights reserved.
//

import UIKit
import MapKit
import Localize

class UpdateMrngHrsVC: UIViewController , UIPickerViewDelegate, UIPickerViewDataSource, UITextFieldDelegate ,CLLocationManagerDelegate,MKMapViewDelegate{
    
    var doctor: DoctorData?

    
    var dict = [String: Any]()
    var image: UIImage?
    var customerType = String()
    
    var lat = String()
    var long = String()
    
    let locationManager = CLLocationManager()


    
    var array = [[String: Any]]()

    let dayArray = ["Monday", "Tuesday", "Wednesday", "Thursday", "Friday", "Saturday", "Sunday"]

    var viewModel = SignupViewModel()
    
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

    @IBOutlet weak var mapView: MKMapView!

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
    


    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        setStatusBar(color: .themeGreen)

        setUpCheckBox()
        
        viewModel.getBusinessHours {
            self.createPickerView()
            self.dismissPickerView()
            self.setPreviousTimings()
        }
        // map methods
        self.locationManager.requestAlwaysAuthorization()

        // For use in foreground
        self.locationManager.requestWhenInUseAuthorization()

        if CLLocationManager.locationServicesEnabled() {
            locationManager.delegate = self
            locationManager.desiredAccuracy = kCLLocationAccuracyBest
            locationManager.startUpdatingLocation()
        }

        mapView.delegate = self
        mapView.mapType = .standard
        mapView.isZoomEnabled = true
        mapView.isScrollEnabled = true

        if let coor = mapView.userLocation.location?.coordinate{
            mapView.setCenter(coor, animated: true)
        }
        lat = "\(doctor?.Latitude ?? "0.0")"
        long = "\(doctor?.Longitude ?? "0.0")"
        
        
        showUserLocation(latitude: lat, longitude: long)
    }
    
    
    func showUserLocation(latitude:String,longitude:String) -> Void {
        lat = latitude
        long = longitude
        
        self.mapView.removeAnnotations(self.mapView.annotations)
        self.mapView.annotations.forEach {
          if !($0 is MKUserLocation) {
            self.mapView.removeAnnotation($0)
          }
        }
        
        
        
        
        let annotation = MKPointAnnotation()
        annotation.coordinate = CLLocationCoordinate2D(latitude: /lat.toDouble(), longitude: /long.toDouble())
        mapView.addAnnotation(annotation)
        self.mapView.showAnnotations(self.mapView.annotations, animated: true)
    }
    
    func setPreviousTimings() -> Void {
        
        if let object1 = doctor?.DoctorAddressTimmingList!.filter({ $0.DayId == 1 }).first {
            btnM.setImage(UIImage(named: "tick.png"), for: .normal)
            let morngStart = viewModel.businessHours?.MorningStart!.filter({ $0.Value == "\(object1.MorningTimeStartId ?? 1)" }).first
            let morngEnd = viewModel.businessHours?.MorningEnd!.filter({ $0.Value == "\(object1.MorningTimeEndId ?? 8)" }).first
            self.msTf.text = morngStart?.Text
            self.meTf.text = morngEnd?.Text
            
            resetImage(button: btnM, mrngStrt: self.msTf.text , mrngEnd: self.meTf.text , tf1: self.msTf, tf2: self.meTf)
        }
        
        if let object2 = doctor?.DoctorAddressTimmingList!.filter({ $0.DayId == 2 }).first {
            btnTue.setImage(UIImage(named: "tick.png"), for: .normal)
            let morngStart = viewModel.businessHours?.MorningStart!.filter({ $0.Value == "\(object2.MorningTimeStartId ?? 1)" }).first
            let morngEnd = viewModel.businessHours?.MorningEnd!.filter({ $0.Value == "\(object2.MorningTimeEndId ?? 8)" }).first
            self.tusTF.text = morngStart?.Text
            self.tueTf.text = morngEnd?.Text
            
            resetImage(button: btnTue, mrngStrt: self.tusTF.text, mrngEnd: self.tueTf.text, tf1: self.tusTF, tf2: self.tueTf)

        }
        
        if let object3 = doctor?.DoctorAddressTimmingList!.filter({ $0.DayId == 3 }).first {
            btnWed.setImage(UIImage(named: "tick.png"), for: .normal)
            let morngStart = viewModel.businessHours?.MorningStart!.filter({ $0.Value == "\(object3.MorningTimeStartId ?? 1)" }).first
            let morngEnd = viewModel.businessHours?.MorningEnd!.filter({ $0.Value == "\(object3.MorningTimeEndId ?? 8)" }).first
            self.wsTf.text = morngStart?.Text
            self.weTf.text = morngEnd?.Text
            
            resetImage(button: btnWed, mrngStrt: self.wsTf.text, mrngEnd: self.weTf.text, tf1: self.wsTf, tf2: self.weTf)

        }
        
        if let object4 = doctor?.DoctorAddressTimmingList!.filter({ $0.DayId == 4 }).first {
            btnThu.setImage(UIImage(named: "tick.png"), for: .normal)
            let morngStart = viewModel.businessHours?.MorningStart!.filter({ $0.Value == "\(object4.MorningTimeStartId ?? 1)" }).first
            let morngEnd = viewModel.businessHours?.MorningEnd!.filter({ $0.Value == "\(object4.MorningTimeEndId ?? 8)" }).first
            self.thsTf.text = morngStart?.Text
            self.theTf.text = morngEnd?.Text
            
            resetImage(button: btnThu, mrngStrt: self.thsTf.text, mrngEnd: self.theTf.text, tf1: self.thsTf, tf2: self.theTf)
        }
        
        if let object5 = doctor?.DoctorAddressTimmingList!.filter({ $0.DayId == 5 }).first {
            btnFri.setImage(UIImage(named: "tick.png"), for: .normal)
            let morngStart = viewModel.businessHours?.MorningStart!.filter({ $0.Value == "\(object5.MorningTimeStartId ?? 1)" }).first
            let morngEnd = viewModel.businessHours?.MorningEnd!.filter({ $0.Value == "\(object5.MorningTimeEndId ?? 8)" }).first
            self.fsTf.text = morngStart?.Text
            self.feTF.text = morngEnd?.Text
            
            resetImage(button: btnFri, mrngStrt: self.fsTf.text, mrngEnd: self.feTF.text, tf1: self.fsTf, tf2: self.feTF)

        }
        
        if let object6 = doctor?.DoctorAddressTimmingList!.filter({ $0.DayId == 6 }).first {
            btnSat.setImage(UIImage(named: "tick.png"), for: .normal)
            let morngStart = viewModel.businessHours?.MorningStart!.filter({ $0.Value == "\(object6.MorningTimeStartId ?? 1)" }).first
            let morngEnd = viewModel.businessHours?.MorningEnd!.filter({ $0.Value == "\(object6.MorningTimeEndId ?? 8)" }).first
            self.sasTf.text = morngStart?.Text
            self.saeTf.text = morngEnd?.Text
            
            resetImage(button: btnSat, mrngStrt: self.sasTf.text, mrngEnd: self.saeTf.text, tf1: self.sasTf, tf2: self.saeTf)

        }
        
        if let object7 = doctor?.DoctorAddressTimmingList!.filter({ $0.DayId == 7 }).first {
            btnSun.setImage(UIImage(named: "tick.png"), for: .normal)
            let morngStart = viewModel.businessHours?.MorningStart!.filter({ $0.Value == "\(object7.MorningTimeStartId ?? 1)" }).first
            let morngEnd = viewModel.businessHours?.MorningEnd!.filter({ $0.Value == "\(object7.MorningTimeEndId ?? 8)" }).first
            self.susTf.text = morngStart?.Text
            self.sueTf.text = morngEnd?.Text
            
            resetImage(button: btnSun, mrngStrt: self.susTf.text, mrngEnd: self.sueTf.text, tf1: self.susTf, tf2: self.sueTf)

        }
    }
    
    
        override func viewWillAppear(_ animated: Bool) {
            NotificationCenter.default.addObserver(self, selector: #selector(self.locNotificationReceived(notification:)), name: Notification.Name("location"), object: nil)
        }
        
        @objc func locNotificationReceived(notification: Notification)
        {
            let userInfo = notification.object as! NSDictionary
            
            if userInfo["lat"]  as! String != "" &&  userInfo["long"]  as! String != ""{
                lat = userInfo["lat"]  as! String
                long = userInfo["long"]  as! String
                
                print(lat,long)

                self.mapView.removeAnnotations(self.mapView.annotations)
                self.mapView.annotations.forEach {
                  if !($0 is MKUserLocation) {
                    self.mapView.removeAnnotation($0)
                  }
                }
                
                let annotation = MKPointAnnotation()
                annotation.coordinate = CLLocationCoordinate2D(latitude:Double(lat)!, longitude: Double(long)!)
                mapView.addAnnotation(annotation)
                self.mapView.showAnnotations(self.mapView.annotations, animated: true)
                
            }else
            {
                    locationManager.delegate = self
                    locationManager.desiredAccuracy = kCLLocationAccuracyBest
                    locationManager.requestAlwaysAuthorization()
                    if CLLocationManager.locationServicesEnabled() {
                        locationManager.startUpdatingLocation()
                    }
               
            }

        }
        


        func numberOfComponents(in pickerView: UIPickerView) -> Int {
            return 1
        }
        
        func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
            if pickerView == self.pvStart {
            return (viewModel.businessHours?.MorningStart!.count)!

            }else
            {
                return (viewModel.businessHours?.MorningEnd!.count)!
            }
        }
        
        func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
            if pickerView == self.pvStart {
            return viewModel.businessHours?.MorningStart![row].Text ?? ""
            }else
            {
                return viewModel.businessHours?.MorningEnd![row].Text ?? ""
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
            array.removeAll()
            
            btnSun.setImage(UIImage.init(named: "tick"), for: .normal)
            btnSat.setImage(UIImage.init(named: "tick"), for: .normal)
            btnFri.setImage(UIImage.init(named: "tick"), for: .normal)
            btnThu.setImage(UIImage.init(named: "tick"), for: .normal)
            btnWed.setImage(UIImage.init(named: "tick"), for: .normal)
            btnTue.setImage(UIImage.init(named: "tick"), for: .normal)
            btnM.setImage(UIImage.init(named: "tick"), for: .normal)
            
            arr = ["1","2","3","4","5","6","7"]
            
            
            
            var allStime = "1"
            var allEtime = "8"

            for i in 0..<(self.viewModel.businessHours?.MorningStart?.count)!
            {
                if msTf.text == self.viewModel.businessHours?.MorningStart![i].Text  {
                    allStime = self.viewModel.businessHours?.MorningStart![i].Value ?? "1"
                }
            }
            
            for i in 0..<(self.viewModel.businessHours?.MorningEnd?.count)!
               {
                   if meTf.text == self.viewModel.businessHours?.MorningEnd![i].Text  {
                       allEtime = self.viewModel.businessHours?.MorningEnd![i].Value ?? "8"
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
            
             for i in 0..<dayArray.count{
            array.append(["DayId": i+1, "MorningTimingIdStart": allStime , "MorningTimingIdEnd": allEtime])
            }
            
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
                msTf.text = self.viewModel.businessHours?.MorningStart![selectedStart].Text
                self.s1 = (self.viewModel.businessHours?.MorningStart![selectedStart].Value)!
            }
            else if tusTF.isEditing == true {
            tusTF.text = self.viewModel.businessHours?.MorningStart![selectedStart].Text
                self.s2 = (self.viewModel.businessHours?.MorningStart![selectedStart].Value)!

            }
            else if wsTf.isEditing == true {
                wsTf.text = self.viewModel.businessHours?.MorningStart![selectedStart].Text
                self.s3 = (self.viewModel.businessHours?.MorningStart![selectedStart].Value)!

            }else if thsTf.isEditing == true {
                thsTf.text = self.viewModel.businessHours?.MorningStart![selectedStart].Text
                self.s4 = (self.viewModel.businessHours?.MorningStart![selectedStart].Value)!

            }else if fsTf.isEditing == true {
                fsTf.text = self.viewModel.businessHours?.MorningStart![selectedStart].Text
                self.s5 = (self.viewModel.businessHours?.MorningStart![selectedStart].Value)!

            }
            else if sasTf.isEditing == true {
                sasTf.text = self.viewModel.businessHours?.MorningStart![selectedStart].Text
                self.s6 = (self.viewModel.businessHours?.MorningStart![selectedStart].Value)!

            }else if susTf.isEditing == true {
                susTf.text = self.viewModel.businessHours?.MorningStart![selectedStart].Text
                self.s7 = (self.viewModel.businessHours?.MorningStart![selectedStart].Value)!

            }
            
             else if meTf.isEditing == true {
                 meTf.text = self.viewModel.businessHours?.MorningEnd![selectedEnd].Text
                self.e1 = (self.viewModel.businessHours?.MorningEnd![selectedEnd].Value)!

             }
            else if tueTf.isEditing == true {
                 tueTf.text = self.viewModel.businessHours?.MorningEnd![selectedEnd].Text
                self.e2 = (self.viewModel.businessHours?.MorningEnd![selectedEnd].Value)!

             }
             else if weTf.isEditing == true {
                 weTf.text = self.viewModel.businessHours?.MorningEnd![selectedEnd].Text
                self.e3 = (self.viewModel.businessHours?.MorningEnd![selectedEnd].Value)!

             }
            else if theTf.isEditing == true {
                 theTf.text = self.viewModel.businessHours?.MorningEnd![selectedEnd].Text
                self.e4 = (self.viewModel.businessHours?.MorningEnd![selectedEnd].Value)!

             }
             else if feTF.isEditing == true {
                 feTF.text = self.viewModel.businessHours?.MorningEnd![selectedEnd].Text
                self.e5 = (self.viewModel.businessHours?.MorningEnd![selectedEnd].Value)!

             }
            else if saeTf.isEditing == true {
                 saeTf.text = self.viewModel.businessHours?.MorningEnd![selectedEnd].Text
                self.e6 = (self.viewModel.businessHours?.MorningEnd![selectedEnd].Value)!

             }else
            {
                sueTf.text = self.viewModel.businessHours?.MorningEnd![selectedEnd].Text
                self.e7 = (self.viewModel.businessHours?.MorningEnd![selectedEnd].Value)!

            }
           view.endEditing(true)
        }

    
    @IBAction func didTapBack(_ sender: UIButton) {
        NavigationHandler.pop()
    }
    

        
        @IBAction func didTapUpdate(_ sender: UIButton) {
            let storyBoard : UIStoryboard = UIStoryboard(name: "map", bundle:nil)
                  let nav = storyBoard.instantiateViewController(withIdentifier: "MapNav")
                  nav.modalPresentationStyle = .fullScreen
                  self.present(nav, animated: true, completion: nil)
            
        }
        
        @IBAction func btnApplyAll(_ sender: UIButton) {
           applyAll()
        }
        
        @IBAction func didTapNext(_ sender: UIButton) {
            
            array.removeAll()
            
            if isValid()
            {

                if btnM.hasImage(named: "tick.png", for: .normal) {
                    array.append(["DayId": 1, "MorningTimingIdStart": getStartTime(time: msTf.text ?? "07:00 AM") , "MorningTimingIdEnd": getEndTime(time: meTf.text ?? "08:00 AM")])
                }
                
                if btnTue.hasImage(named: "tick.png", for: .normal) {
                    array.append(["DayId": 2, "MorningTimingIdStart": getStartTime(time: tusTF.text ?? "07:00 AM") , "MorningTimingIdEnd": getEndTime(time: tueTf.text ?? "08:00 AM")])
                }
                
                if btnWed.hasImage(named: "tick.png", for: .normal) {
                    array.append(["DayId": 3, "MorningTimingIdStart": getStartTime(time: wsTf.text ?? "07:00 AM") , "MorningTimingIdEnd": getEndTime(time: weTf.text ?? "08:00 AM")])
                }
                
                if btnThu.hasImage(named: "tick.png", for: .normal) {
                    array.append(["DayId": 4, "MorningTimingIdStart": getStartTime(time: thsTf.text ?? "07:00 AM") , "MorningTimingIdEnd": getEndTime(time: theTf.text ?? "08:00 AM")])
                }

                if btnFri.hasImage(named: "tick.png", for: .normal) {
                    array.append(["DayId": 5, "MorningTimingIdStart": getStartTime(time: fsTf.text ?? "07:00 AM") , "MorningTimingIdEnd": getEndTime(time: feTF.text ?? "08:00 AM")])
                }
                
                if btnSat.hasImage(named: "tick.png", for: .normal) {
                    array.append(["DayId": 6, "MorningTimingIdStart": getStartTime(time: sasTf.text ?? "07:00 AM") , "MorningTimingIdEnd": getEndTime(time: saeTf.text ?? "08:00 AM")])
                }
                
                if btnSun.hasImage(named: "tick.png", for: .normal) {
                    array.append(["DayId": 7, "MorningTimingIdStart": getStartTime(time: susTf.text ?? "07:00 AM") , "MorningTimingIdEnd": getEndTime(time: sueTf.text ?? "08:00 AM")])
                }

                dict["Latitude"] = lat
                dict["Longitude"] = long

                guard let businessHours = viewModel.businessHours else {return}
                NavigationHandler.pushTo(.updateEvngHrsVC(businessHours, dict, array, image,doctor!))

            }else
            {
                AlertManager.showAlert(type: .custom(ProfileUpdate.mngEvgTimeLower.localize()))
            }
        }
        
        @IBAction func didTapMon(_ sender: UIButton) {
            if btnM.hasImage(named: "tick.png", for: .normal) {
                btnM.setImage(nil, for: .normal)
                if let index = arr.index(of: "1") {
                    arr.remove(at: index)
                }
                
                let index = array.index(where: { dictionary in
                  guard let value = dictionary["DayId"] as? Int
                    else { return false }
                  return value == 1
                })
                if let index = index {
                  array.remove(at: index)
                }
                
                self.e1 = "0"
                self.s1 = "0"
            } else {
                btnM.setImage(UIImage(named: "tick.png"), for: .normal)
                
                if s1 == "0" {
                    self.s1 = getStartTime(time: msTf.text ?? "07:00 AM")
                }
                
                if e1 == "0" {
                    self.e1 = getEndTime(time: meTf.text ?? "08:00 AM")
                }
                arr.append("1")
            }
        }
        
        @IBAction func didTapTue(_ sender: UIButton) {
            if btnTue.hasImage(named: "tick.png", for: .normal) {
                btnTue.setImage(nil, for: .normal)
                if let index = arr.index(of: "2") {
                    arr.remove(at: index)
                }
                
                let index = array.index(where: { dictionary in
                  guard let value = dictionary["DayId"] as? Int
                    else { return false }
                  return value == 2
                })
                if let index = index {
                  array.remove(at: index)
                }
                self.e2 = "0"
                self.s2 = "0"
            } else {
                btnTue.setImage(UIImage(named: "tick.png"), for: .normal)
                
                if s2 == "0" {
                    self.s2 = getStartTime(time: tusTF.text ?? "07:00 AM")
                }
                
                if e2 == "0" {
                    self.e2 = getEndTime(time: tueTf.text ?? "08:00 AM")
                }
                arr.append("2")

            }
            
        }
        
        @IBAction func didTapWed(_ sender: UIButton) {
            if btnWed.hasImage(named: "tick.png", for: .normal) {
                btnWed.setImage(nil, for: .normal)
                if let index = arr.index(of: "3") {
                    arr.remove(at: index)
                }
                
                let index = array.index(where: { dictionary in
                  guard let value = dictionary["DayId"] as? Int
                    else { return false }
                  return value == 3
                })
                if let index = index {
                  array.remove(at: index)
                }
                self.e3 = "0"
                self.s3 = "0"
            } else {
                btnWed.setImage(UIImage(named: "tick.png"), for: .normal)
                
                if s3 == "0" {
                    self.s3 = getStartTime(time: wsTf.text ?? "07:00 AM")
                }
                
                if e3 == "0" {
                    self.e3 = getEndTime(time: weTf.text ?? "08:00 AM")
                }
                arr.append("3")

            }
        }
        
        @IBAction func didTapThu(_ sender: UIButton) {
            if btnThu.hasImage(named: "tick.png", for: .normal) {
                btnThu.setImage(nil, for: .normal)
                if let index = arr.index(of: "4") {
                    arr.remove(at: index)
                }
                
                let index = array.index(where: { dictionary in
                  guard let value = dictionary["DayId"] as? Int
                    else { return false }
                  return value == 4
                })
                if let index = index {
                  array.remove(at: index)
                }
                self.e4 = "0"
                self.s4 = "0"
            } else {
                btnThu.setImage(UIImage(named: "tick.png"), for: .normal)
                if s4 == "0" {
                    self.s4 = getStartTime(time: thsTf.text ?? "07:00 AM")
                }
                
                if e4 == "0" {
                    self.e4 = getEndTime(time: theTf.text ?? "08:00 AM")
                }
                arr.append("4")
            }
        }
        
        @IBAction func didTapFri(_ sender: UIButton) {
            if btnFri.hasImage(named: "tick.png", for: .normal) {
                btnFri.setImage(nil, for: .normal)
                if let index = arr.index(of: "5") {
                    arr.remove(at: index)
                }
                
                let index = array.index(where: { dictionary in
                  guard let value = dictionary["DayId"] as? Int
                    else { return false }
                  return value == 5
                })
                if let index = index {
                  array.remove(at: index)
                }
                self.e5 = "0"
                self.s5 = "0"
            } else {
                btnFri.setImage(UIImage(named: "tick.png"), for: .normal)
                if s5 == "0" {
                    self.s5 = getStartTime(time: fsTf.text ?? "07:00 AM")
                }
                
                if e5 == "0" {
                    self.e5 = getEndTime(time: feTF.text ?? "08:00 AM")
                }
                arr.append("5")
            }
        }
        
        @IBAction func didTapSat(_ sender: UIButton) {
            if btnSat.hasImage(named: "tick.png", for: .normal) {
                btnSat.setImage(nil, for: .normal)
                if let index = arr.index(of: "6") {
                    arr.remove(at: index)
                }
                
                let index = array.index(where: { dictionary in
                  guard let value = dictionary["DayId"] as? Int
                    else { return false }
                  return value == 6
                })
                if let index = index {
                  array.remove(at: index)
                }
                self.e6 = "0"
                self.s6 = "0"
            } else {
                btnSat.setImage(UIImage(named: "tick.png"), for: .normal)
                if s6 == "0" {
                    self.s6 = getStartTime(time: sasTf.text ?? "07:00 AM")

                }
                
                if e6 == "0" {
                    self.e6 = getEndTime(time: saeTf.text ?? "08:00 AM")

                }
                arr.append("6")
            }
        }
        
        @IBAction func didTapSun(_ sender: UIButton) {
            if btnSun.hasImage(named: "tick.png", for: .normal) {
                btnSun.setImage(nil, for: .normal)
                if let index = arr.index(of: "7") {
                    arr.remove(at: index)
                }
                
                let index = array.index(where: { dictionary in
                  guard let value = dictionary["DayId"] as? Int
                    else { return false }
                  return value == 7
                })
                if let index = index {
                  array.remove(at: index)
                }
                self.e7 = "0"
                self.s7 = "0"
            } else {
                btnSun.setImage(UIImage(named: "tick.png"), for: .normal)
                if s7 == "0" {
                    self.s7 = getStartTime(time: susTf.text ?? "07:00 AM")
                }
                
                if e7 == "0" {
                    self.e7 = getEndTime(time: sueTf.text ?? "08:00 AM")
                }
                arr.append("7")
            }
        }
        
        func isValid() -> Bool {
            
            if modifyStartTimeConvert(text: msTf.text ?? "07:00 AM") >= modifyEndTimeConvert(text: meTf.text ?? "08:00 AM") {
                return false
            }else if modifyStartTimeConvert(text: tusTF.text ?? "07:00 AM") >= modifyEndTimeConvert(text: tueTf.text ?? "08:00 AM")
            {
                return false
                
            }else if modifyStartTimeConvert(text: wsTf.text ?? "07:00 AM") >= modifyEndTimeConvert(text: weTf.text ?? "08:00 AM")
            {
                return false
                
            }else if modifyStartTimeConvert(text: thsTf.text ?? "07:00 AM") >= modifyEndTimeConvert(text: theTf.text ?? "08:00 AM")
            {
                return false
                
            }else if modifyStartTimeConvert(text: fsTf.text ?? "07:00 AM") >= modifyEndTimeConvert(text: feTF.text ?? "08:00 AM")
            {
                return false
                
            }else if modifyStartTimeConvert(text: sasTf.text ?? "07:00 AM") >= modifyEndTimeConvert(text: saeTf.text ?? "08:00 AM")
            {
                return false
                
            }else if modifyStartTimeConvert(text: susTf.text ?? "07:00 AM") >= modifyEndTimeConvert(text: sueTf.text ?? "08:00 AM")
            {
                return false
            }
            
            return true
        }
        
    func modifyStartTimeConvert(text:String) -> Int {
            var startTime = 0
       if (text.contains(" AM"))
            {
               startTime = Int((text.replacingOccurrences(of: " AM", with: "")).replacingOccurrences(of: ":00", with: "")) ?? 0
             }else if (text.contains(" PM"))
            {
            startTime = Int((text.replacingOccurrences(of: " PM", with: "")).replacingOccurrences(of: ":00", with: "")) ??  0
            }
            return startTime
        }
        
    func modifyEndTimeConvert(text:String) -> Int {
        var endTime = 0
        if (text.contains(" AM"))
        {
        endTime = Int((text.replacingOccurrences(of: " AM", with: "")).replacingOccurrences(of: ":00", with: "")) ?? 0
        }else if (text.contains(" PM"))
        {
        endTime = ( Int((text.replacingOccurrences(of: " PM", with: "")).replacingOccurrences(of: ":00", with: "")) ?? 0 ) + 12
        }
             return endTime
    }
        
        
        func getStartTime(time:String) -> String {
            var startTime = "1"

            for i in 0..<(self.viewModel.businessHours?.MorningStart?.count)!
            {
                if time == self.viewModel.businessHours?.MorningStart![i].Text  {
                    startTime = self.viewModel.businessHours?.MorningStart![i].Value ?? "1"
                }
            }
            

            return startTime
        }
        
        func getEndTime(time:String) -> String {
            var endTime = "8"

                    for i in 0..<(self.viewModel.businessHours?.MorningEnd?.count)!
               {
                   if time == self.viewModel.businessHours?.MorningEnd![i].Text  {
                       endTime = self.viewModel.businessHours?.MorningEnd![i].Value ?? "8"
                   }
               }
            
            return endTime
        }
    
    
    func resetImage(button:UIButton , mrngStrt:String?,mrngEnd:String?,tf1:UITextField?,tf2:UITextField?) -> Void {
       if mrngStrt == "" && mrngEnd == ""
        {
            button.setImage(nil, for: .normal)
            tf1!.text = "07:00 AM"
            tf2!.text = "08:00 AM"
        }
    }
        

}
