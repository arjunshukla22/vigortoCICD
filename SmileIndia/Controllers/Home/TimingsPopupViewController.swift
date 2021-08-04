//
//  TimingsPopupViewController.swift
//  SmileIndia
//
//  Created by Na on 22/03/19.
//  Copyright © 2019 Na. All rights reserved.
//

import UIKit
import EZSwiftExtensions

class TimingsPopupViewController: UIViewController {
    
    let colorArray = [#colorLiteral(red: 0.6901960784, green: 0.4431372549, blue: 0.9803921569, alpha: 1),#colorLiteral(red: 1, green: 0.6117647059, blue: 0.3098039216, alpha: 1),#colorLiteral(red: 0.1019607843, green: 0.7176470588, blue: 0.3882352941, alpha: 1),#colorLiteral(red: 0.9882352941, green: 0.8196078431, blue: 0.0862745098, alpha: 1),#colorLiteral(red: 0.9960784314, green: 0.3764705882, blue: 0.462745098, alpha: 1),#colorLiteral(red: 0.3333333333, green: 0.6666666667, blue: 0.9333333333, alpha: 1),#colorLiteral(red: 0.0862745098, green: 0.8392156863, blue: 0.007843137255, alpha: 1)]


    @IBOutlet weak var TimeZoneLabel: UILabel!
    @IBOutlet weak var tableTimings: UITableView!
    @IBOutlet weak var timingLabel: UILabel!
    var address = String()
    var timezone = ""
    var timingsArray = [AddressTiming]()
    var objcTimeZone: Doctor?
    var datasourceTable = GenericDataSource()
    var object: Doctor?
    
    var tableViewHeight: CGFloat {
        tableTimings.reloadData()
        tableTimings.layoutIfNeeded()

        return tableTimings.contentSize.height
    }
    
    @IBOutlet weak var popupHeight: NSLayoutConstraint!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        TimeZoneLabel.text = timezone
        
        
       
        
//        if timingsArray.count == 0{
//            popupHeight.constant = CGFloat((74*1) + 110)
//        }else{
//            popupHeight.constant = CGFloat((74*timingsArray.count) + 110)
//        }
    }
  
    override func viewWillAppear(_ animated: Bool) {
        TimeZoneLabel.text = timezone
        setUpTableCell()
        
        print(tableViewHeight)
        
        if tableViewHeight > ez.screenHeight - 170 {
            popupHeight.constant = ez.screenHeight - 170
        }else{
            popupHeight.constant = tableViewHeight + 140
        }
    
    }
    

    @IBAction func didTapCloseButton(_ sender: Any) {
        self.dismiss(animated: false, completion: nil)
    }
    
    
   func setUpTableCell(){
        datasourceTable.array = timingsArray
        datasourceTable.identifier = SeeTimingsCell.identifier
        tableTimings.dataSource = datasourceTable
        tableTimings.delegate = datasourceTable
        tableTimings.tableFooterView = UIView()
        datasourceTable.configure = {cell, index in
            guard let timingCell = cell as? SeeTimingsCell else { return }
            timingCell.object = self.timingsArray[index]
            timingCell.viewDay.backgroundColor = self.colorArray[index]}
        datasourceTable.didScroll = {
        }
        datasourceTable.didSelect = {cell, index in
        }
    }
}
