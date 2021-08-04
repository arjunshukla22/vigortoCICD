//
//  MapVC.swift
//  SmileIndia
//
//  Created by Arjun  on 09/03/20.
//  Copyright © 2020 Na. All rights reserved.
//

import UIKit
import MapKit

protocol HandleMapSearch: class {
    func dropPinZoomIn(placemark:MKPlacemark)
}

protocol MapVCDelegate
{
    func selectedLocation( lat : String , long : String)
}

class MapVC: UIViewController {
    
    var lat = String()
    var long = String()
    
    var delegate : MapVCDelegate?

    @IBOutlet weak var mapView: MKMapView!
    
    var selectedPin: MKPlacemark?
    var resultSearchController: UISearchController!
    let locationManager = CLLocationManager()

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        setStatusBar(color: .themeGreen)

        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.requestWhenInUseAuthorization()
        locationManager.requestLocation()
        
        let locationSearchTable = storyboard!.instantiateViewController(withIdentifier: "LocationSearchTable") as! LocationSearchTable
        resultSearchController = UISearchController(searchResultsController: locationSearchTable)
        resultSearchController.searchResultsUpdater = locationSearchTable
        
        let searchBar = resultSearchController!.searchBar
        searchBar.backgroundColor = .none
        searchBar.sizeToFit()
        searchBar.placeholder = "Search for places"
        navigationItem.titleView = resultSearchController?.searchBar
        resultSearchController.hidesNavigationBarDuringPresentation = false
        resultSearchController.dimsBackgroundDuringPresentation = true
        definesPresentationContext = true
        locationSearchTable.mapView = mapView
        locationSearchTable.handleMapSearchDelegate = self
    }
    
    
    @objc func getDirections(){
        guard let selectedPin = selectedPin else { return }
        let mapItem = MKMapItem(placemark: selectedPin)
        let launchOptions = [MKLaunchOptionsDirectionsModeKey: MKLaunchOptionsDirectionsModeDriving]
        mapItem.openInMaps(launchOptions: launchOptions)
    }
    
    
    func parseAddress(selectedItem:MKPlacemark) -> String {
        
        // put a space between "4" and "Melrose Place"
        let firstSpace = (selectedItem.subThoroughfare != nil &&
                            selectedItem.thoroughfare != nil) ? " " : ""
        
        // put a comma between street and city/state
        let comma = (selectedItem.subThoroughfare != nil || selectedItem.thoroughfare != nil) &&
                    (selectedItem.subAdministrativeArea != nil || selectedItem.administrativeArea != nil) ? ", " : ""
        
        // put a space between "Washington" and "DC"
        let secondSpace = (selectedItem.subAdministrativeArea != nil &&
                            selectedItem.administrativeArea != nil) ? " " : ""
        
        let addressLine = String(
            format:"%@%@%@%@%@%@%@",
            // street number
            selectedItem.title ?? "",
            firstSpace,
            // street name
            selectedItem.subLocality ?? "",
            comma,
            // city
            selectedItem.locality ?? "",
            secondSpace,
            // state
            selectedItem.administrativeArea ?? ""
        )
        
        return addressLine
    }
    
    @IBAction func didtapCancel(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func didTapUpdate(_ sender: UIButton) {
        self.dismiss(animated: true, completion: nil)
        delegate?.selectedLocation( lat : lat , long : long)
        let userInfo = ["lat" :lat ,"long":long]
        NotificationCenter.default.post(name: Notification.Name("location"), object: userInfo)

    }
    
}


extension MapVC : CLLocationManagerDelegate {
    
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        if status == .authorizedWhenInUse {
            locationManager.requestLocation()
        }
    }
    
     func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let location = locations.first else { return }
        let span = MKCoordinateSpan(latitudeDelta: 0.05, longitudeDelta: 0.05)
        let region = MKCoordinateRegion(center: location.coordinate, span: span)
        
        let userLocation:CLLocation = locations[0] as CLLocation
        lat = "\(userLocation.coordinate.latitude)"
        long = "\(userLocation.coordinate.longitude)"

        mapView.setRegion(region, animated: true)
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error){
        print("error:: \(error)")
    }

}

extension MapVC: HandleMapSearch {
    
    func dropPinZoomIn(placemark: MKPlacemark){
        // cache the pin
        selectedPin = placemark
        // clear existing pins
        mapView.removeAnnotations(mapView.annotations)
        let annotation = MKPointAnnotation()
        annotation.coordinate = placemark.coordinate
        annotation.title = placemark.name
        
        if let city = placemark.locality,
            let state = placemark.administrativeArea {
                annotation.subtitle = "\(city) \(state)"

        }
        
        resultSearchController!.searchBar.text = parseAddress(selectedItem: placemark)

        self.lat = "\(placemark.coordinate.latitude)"
        self.long = "\(placemark.coordinate.longitude)"

        print(placemark.coordinate.latitude)
        print(placemark.coordinate.longitude)
        mapView.addAnnotation(annotation)
        let span = MKCoordinateSpan(latitudeDelta: 0.05, longitudeDelta: 0.05)
        let region = MKCoordinateRegion(center: placemark.coordinate, span: span)
        mapView.setRegion(region, animated: true)
        
        func mapView(_ mapView: MKMapView, annotationView view: MKAnnotationView, didChange newState: MKAnnotationView.DragState, fromOldState oldState: MKAnnotationView.DragState)
        {
            if (newState == MKAnnotationView.DragState.ending)
            {
                let droppedAt = view.annotation?.coordinate
                print("dropped at : ", droppedAt?.latitude ?? 0.0, droppedAt?.longitude ?? 0.0);
                view.setDragState(.none, animated: true)
            }
            if (newState == .canceling )
            {
                view.setDragState(.none, animated: true)
            }
        }
    }
 
    
}

extension MapVC : MKMapViewDelegate {
    
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView?{
        if annotation is MKUserLocation {
                return nil
            }

            let reuseId = "pin"
            var pinView = mapView.dequeueReusableAnnotationView(withIdentifier: reuseId) as? MKPinAnnotationView
            if pinView == nil {
                pinView = MKPinAnnotationView(annotation: annotation, reuseIdentifier: reuseId)
                pinView?.animatesDrop = true
                pinView?.canShowCallout = true
                pinView?.isDraggable = true
                pinView?.pinTintColor = .themeGreen

                let rightButton: AnyObject! = UIButton(type: UIButton.ButtonType.detailDisclosure)
                pinView?.rightCalloutAccessoryView = rightButton as? UIView
            }
            else {
                pinView?.annotation = annotation
            }
            
            return pinView
        }
    
    
    
  

      func mapView(_ mapView: MKMapView, annotationView view: MKAnnotationView, didChange newState: MKAnnotationView.DragState, fromOldState oldState: MKAnnotationView.DragState) {
          if newState == MKAnnotationView.DragState.ending {
              let droppedAt = view.annotation?.coordinate
        
              print(droppedAt.debugDescription)
            self.lat = "\(view.annotation?.coordinate.latitude ?? 0.0)"
            self.long = "\(view.annotation?.coordinate.longitude ?? 0.0)"
            let annotation = MKPointAnnotation()
            annotation.title = (view.annotation?.title!!)
            resultSearchController!.searchBar.text = view.annotation?.title!!
            
            
          }
      }
    @IBAction func didReturnToMapViewController(_ segue: UIStoryboardSegue) {
           print(#function)
       }
}

