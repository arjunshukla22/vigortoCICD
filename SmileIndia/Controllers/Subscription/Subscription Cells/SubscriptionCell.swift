//
//  SubscriptionCell.swift
//  SmileIndia
//
//  Created by Arjun  on 29/06/20.
//  Copyright © 2020 Na. All rights reserved.
//

import UIKit

class SubscriptionCell: UICollectionViewCell , UITableViewDataSource, UITableViewDelegate{
    
    @IBOutlet weak var featuresLabel: UILabel!
    @IBOutlet weak var plansLabel: UILabel!
    @IBOutlet weak var tablePlans: UITableView!
    @IBOutlet weak var feeLabel: UILabel!
    @IBOutlet weak var btnBuy: UIButton!
    @IBOutlet weak var cycleLabel: UILabel!
    
    @IBOutlet weak var monthLbl: UILabel!
    @IBOutlet weak var discountImg: UIImageView!
    
    @IBOutlet weak var trailImage: UIImageView!
    @IBOutlet weak var trailDaysLbl: UILabel!
  
    let screenSize: CGRect = UIScreen.main.bounds
    var featuresList = [FeaturesList]()
    var object: [FeaturesList]? {
                didSet {
                var fArray = [FeaturesList]()
                for item in object! {
                    self.featuresList.removeAll()
                    fArray.append(item)
                  

                }
                self.featuresList = fArray
                self.tablePlans.reloadData()
                }
               }
    let cellIdentifier: String = "tableCell"
    override func layoutSubviews() {
        super.layoutSubviews()

        tablePlans.delegate = self
        tablePlans.dataSource = self
        tablePlans.register(UITableViewCell.self, forCellReuseIdentifier: cellIdentifier)
        tablePlans.tableFooterView = UIView()
        tablePlans.separatorStyle = .none
    }

    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.featuresList.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {

        let cell: UITableViewCell = UITableViewCell(style: UITableViewCell.CellStyle.default, reuseIdentifier: cellIdentifier)
            cell.textLabel?.text = featuresList[indexPath.row].FeatureName
            cell.textLabel?.textAlignment = .center
            cell.textLabel?.numberOfLines = 0
            cell.textLabel?.lineBreakMode = .byWordWrapping
            cell.selectionStyle = .none

                 if indexPath.row % 2 == 0{
                    if #available(iOS 13.0, *) {
                        cell.backgroundColor = .systemBackground
                    } else {
                        cell.backgroundColor = .white
                    }
                    if #available(iOS 13.0, *) {
                        cell.textLabel?.textColor = .label
                    } else {
                        cell.backgroundColor = .black
                    }
        }
                 else{
                    if #available(iOS 13.0, *) {
                        cell.backgroundColor = .systemGray5
                    } else {
                        cell.backgroundColor = .gray
                    }
                    if #available(iOS 13.0, *) {
                        cell.textLabel?.textColor = .label
                    } else {
                        cell.backgroundColor = .black
                    }
                 }
        
        if featuresList[indexPath.row].FeatureName == SubscriptionScreenText.TopOnSearch.localize() {
            if  screenSize.height > 700{
                cell.textLabel?.font = UIFont.boldSystemFont(ofSize: 20.0)
            }
            else{
            cell.textLabel?.font = UIFont.boldSystemFont(ofSize: 12.0)
            }
        }else{
            if  screenSize.height > 700{
                cell.textLabel?.font = UIFont.systemFont(ofSize: 20.0)
            }
            else{
            cell.textLabel?.font = UIFont.systemFont(ofSize: 12.0)
            }
        }
        return cell
    }
}

