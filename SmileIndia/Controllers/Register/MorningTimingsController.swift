//
//  MorningTimingsController.swift
//  SmileIndia
//
//  Created by Na on 17/02/19.
//  Copyright © 2019 Na. All rights reserved.
//

import UIKit
import MapKit
import CoreLocation

class MorningTimingsController: UIViewController,CLLocationManagerDelegate,MKMapViewDelegate{
 
    
    var arr = [String]()

    var lat = String()
    var long = String()
    
    
    @IBOutlet weak var mapView: MKMapView!
    @IBOutlet weak var navTitle: UINavigationItem!
    @IBOutlet weak var timingTableView: UITableView!
    
    let locationManager = CLLocationManager()

    
    var datasource = GenericDataSource()
    var customerType = String()
    var viewModel = SignupViewModel()
    var dict = [String: Any]()
    var image: UIImage?
    var isApplyAll = false
    let dayArray = ["Monday", "Tuesday", "Wednesday", "Thursday", "Friday", "Saturday", "Sunday"]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.view.activityStartAnimating(activityColor: .themeGreen, backgroundColor: UIColor.white)

        navTitle.title = (customerType == "1" ? "DOCTOR REGISTRATION" : "HOSPITAL REGISTRATION")
        viewModel.getBusinessHours(){
            self.setUpCell()
            self.timingTableView.reloadData()
            self.view.activityStopAnimating()
        }
        
        // Do any additional setup after loading the view.
        
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
            
        }

    }
    
    @IBAction func didTapBackButton(_ sender: Any){
        NavigationHandler.pop()
    }
    
    @IBAction func didTapApplyAll(_ sender: Any) {
        isApplyAll = true
        timingTableView.reloadData()
        setUpCell()
       // applyAll()
    }
    
    @IBAction func didTapNextButton(_ sender: Any) {
        
        print(dict)

        arr.removeAll()
        
        var sTime = "0"
        var eTime = "0"
        
        var array = [[String: Any]]()
        for i in 0..<dayArray.count{
            guard let cell = timingTableView.cellForRow(at: IndexPath.init(row: i, section: 0)) as? TimingsCell else {return}
            if !cell.tickImageView.isHidden {
                
                if cell.startTimeTextfield.accessibilityLabel == nil{
                    sTime = "1"
                }else
                {
                    sTime = cell.startTimeTextfield.accessibilityLabel!
                }
                
                if cell.endTimeTextfield.accessibilityLabel == nil{
                    eTime = "8"
                }else
                {
                    eTime = cell.endTimeTextfield.accessibilityLabel!
                }
                
                var allsTime = "1"
                var alletime = "8"
                
                if i == 0{
                    if   !cell.tickImageView.isHidden {
                        for j in 0..<(self.viewModel.businessHours?.MorningStart?.count)!
                        {
                            if cell.startTimeTextfield.text == self.viewModel.businessHours?.MorningStart![j].Text  {
                                allsTime = self.viewModel.businessHours?.MorningStart![j].Value ?? "1"
                            }
                            
                            if cell.endTimeTextfield.text == self.viewModel.businessHours?.MorningEnd![j].Text  {
                                alletime = self.viewModel.businessHours?.MorningEnd![j].Value ?? "1"
                            }
                        }
                    }

                }
                
                if isApplyAll {
                   //   sTime = allsTime
                  //    eTime = alletime
                }
              
                
                print(sTime,eTime)

                    array.append(["DayId": i+1, "MorningTimingIdStart": isApplyAll ? sTime : sTime , "MorningTimingIdEnd": isApplyAll ? eTime : eTime])

                            var startTime = 0
                            let startT = cell.startTimeTextfield.text
                
                            if (startT?.contains(" AM"))!
                            {
                               startTime = Int((startT?.replacingOccurrences(of: " AM", with: ""))!.replacingOccurrences(of: ":00", with: "")) ?? 0
                             }else if (startT?.contains(" PM"))!
                            {
                            startTime = Int((startT?.replacingOccurrences(of: " PM", with: ""))!.replacingOccurrences(of: ":00", with: "")) ??  0
                            }
                
                        var endTime = 0
                        let endT = cell.endTimeTextfield.text
                        if (endT?.contains(" AM"))!
                        {
                        endTime = Int((endT?.replacingOccurrences(of: " AM", with: ""))!.replacingOccurrences(of: ":00", with: "")) ?? 0
                        }else if (endT?.contains(" PM"))!
                        {
                        endTime = ( Int((endT?.replacingOccurrences(of: " PM", with: ""))!.replacingOccurrences(of: ":00", with: "")) ?? 0 ) + 12
                        }
                
                        if startTime >= endTime  {
                        arr.append("1")
                        }

            }
            
        }
        
        guard let businessHours = viewModel.businessHours else {return}
        
            dict["Latitude"] = lat
            dict["Longitude"] = long
            
          NavigationHandler.pushTo(.eveningTiming(businessHours, dict, array, image, customerType))
            
    }
    
    @IBAction func didTapUpdateLocation(_ sender: UIButton) {
        //   let vc = MapSearchVC.init(nibName: "MapSearchVC", bundle: nil)
         //   vc.delegate = self
          //  self.present(vc, animated: true, completion: nil)
        
         let storyBoard : UIStoryboard = UIStoryboard(name: "map", bundle:nil)
               let nav = storyBoard.instantiateViewController(withIdentifier: "MapNav")
               nav.modalPresentationStyle = .fullScreen
               self.present(nav, animated: true, completion: nil)
    }

        

    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        let locValue:CLLocationCoordinate2D = manager.location!.coordinate
        mapView.mapType = MKMapType.standard
      
        let region = MKCoordinateRegion(center: locValue, span: MKCoordinateSpan(latitudeDelta: 0.01, longitudeDelta: 0.01))
        mapView.setRegion(region, animated: true)

        let annotation = MKPointAnnotation()
        annotation.coordinate = locValue
        annotation.title = "Current Location"
      //  annotation.subtitle = "current location"
        mapView.addAnnotation(annotation)

        let userLocation:CLLocation = locations[0] as CLLocation
        manager.stopUpdatingLocation()
        

        lat = "\(userLocation.coordinate.latitude)"
        long = "\(userLocation.coordinate.longitude)"
        
    }
    

      func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
            print("Error while updating location " + error.localizedDescription)
      }
    



}

extension MorningTimingsController{
    func setUpCell(){
        datasource.array = dayArray
        datasource.identifier = TimingsCell.identifier
        timingTableView.dataSource = datasource
        timingTableView.delegate = datasource
        datasource.configure = {cell, index in
            guard let timingsCell = cell as? TimingsCell else { return }
            timingsCell.isMorning = true
            timingsCell.object = self.viewModel.businessHours
            timingsCell.startTimeTextfield.text = self.viewModel.businessHours?.MorningStart![0].Text
            timingsCell.endTimeTextfield.text = self.viewModel.businessHours?.MorningEnd![0].Text
            timingsCell.dayLabel.text = self.dayArray[index]
            timingsCell.tickImageView.isHidden = !self.isApplyAll
        }
        datasource.didScroll = {
        }
        datasource.didSelect = {cell,_  in
            guard let timingsCell = cell as? TimingsCell else { return}
            timingsCell.tickImageView.isHidden = !timingsCell.tickImageView.isHidden
        }
    }
}
extension MorningTimingsController{

    func isValid() -> Bool {
 
        var flag = false
        for i in 0..<dayArray.count{
            guard let cell = timingTableView.cellForRow(at: IndexPath.init(row: i, section: 0)) as? TimingsCell else {return false}
            if !cell.tickImageView.isHidden{
                flag = true
            }
        }
        if !flag {
            AlertManager.showAlert(type: .custom("Please select morning timing."))
            return false
        }
        return true

    }
}
