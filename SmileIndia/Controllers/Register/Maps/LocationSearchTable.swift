//
//  LocationSearchTable.swift
//  SmileIndia
//
//  Created by Arjun  on 09/03/20.
//  Copyright © 2020 Na. All rights reserved.
//

import UIKit
import MapKit

class LocationSearchTable: UITableViewController {

        weak var handleMapSearchDelegate: HandleMapSearch?
        var matchingItems: [MKMapItem] = []
        var mapView: MKMapView?
        
        
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
        
    }

    extension LocationSearchTable : UISearchResultsUpdating {
        func updateSearchResults(for searchController: UISearchController) {
            guard let mapView = mapView,
                let searchBarText = searchController.searchBar.text else { return }

            let request = MKLocalSearch.Request()
            request.naturalLanguageQuery = searchBarText
            request.region = mapView.region
            let search = MKLocalSearch(request: request)

            search.start { response, _ in
                guard let response = response else {
                    return
                }
                self.matchingItems = response.mapItems
                self.tableView.reloadData()
            }
        }
    }

    extension LocationSearchTable {
        
        override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
            return matchingItems.count
        }
        
         override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {

             let cell = tableView.dequeueReusableCell(withIdentifier: "cell")!
            if #available(iOS 13.0, *) {
                cell.backgroundColor = .systemBackground
            } else {
                // Fallback on earlier versions
            }
             let selectedItem = matchingItems[indexPath.row].placemark
            
            cell.textLabel?.textColor = .none
            cell.detailTextLabel?.textColor = .none
             cell.textLabel?.text = selectedItem.title
             cell.detailTextLabel?.text = parseAddress(selectedItem: selectedItem)
             return cell
         }
        
        override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
            let selectedItem = matchingItems[indexPath.row].placemark
            handleMapSearchDelegate?.dropPinZoomIn(placemark: selectedItem)
            dismiss(animated: true, completion: nil)
        }

        
    }

