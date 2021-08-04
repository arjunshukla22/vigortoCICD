//
//  CreditsViewController.swift
//  SmileIndia
//
//  Created by Sakshi Gothi on 19/12/20.
//  Copyright © 2020 Na. All rights reserved.

import UIKit

class CreditsViewController: UIViewController {

    @IBOutlet weak var creditsLabel: UILabel!
    @IBOutlet weak var tableCredits: UITableView!
    
    
    @IBOutlet weak var defaulterLabel: UILabel!
    
    var datasourceTable = GenericDataSource()

    
    var  credits: Credits?

    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        setStatusBar(color: .themeGreen)
        self.getSmileIndiaCredits(Authentication.customerId ?? "")
        
        self.defaulterLabel.text = ""
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
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
    
    func getSmileIndiaCredits(_ customerId: String){
        let queryItems = ["CustomerId": customerId] as [String: Any]
        self.view.activityStartAnimating(activityColor: .orange, backgroundColor: UIColor.white)
        WebService.getVigortoCredits(queryItems: queryItems) { (result) in
            DispatchQueue.main.async {
                switch result {
                case .success(let response):
                    self.credits = response.object
                    self.attributingWithColorForVC2(label: self.creditsLabel, boldTxt: CreditsInfoScreenTxt.totalCredits.localize(), regTxt: "$ \(response.object?.TotalCredits ?? 0)\(".00")", color: .themeGreen, fontSize: 16, firstFontWeight: .medium, secFontWeight: .medium)
                    self.setUpTableCell()
                    self.tableCredits.reloadData()
                case .failure(let error):
                    AlertManager.showAlert(type: .custom(error.message))
                }
                self.view.activityStopAnimating()
            }
        }
    }
    @IBAction func didtapBack(_ sender: Any) {
        NavigationHandler.pop()
    }
    
}


extension CreditsViewController {
    func setUpTableCell(){
        datasourceTable.array = self.credits?.CreditHistory ?? []
        datasourceTable.identifier = CreditsCell.identifier
        tableCredits.dataSource = datasourceTable
        tableCredits.delegate = datasourceTable
        tableCredits.tableFooterView = UIView()
        datasourceTable.configure = {cell, index in
            guard let pendingCell = cell as? CreditsCell else { return }
            pendingCell.object = self.credits?.CreditHistory![index]
        }
        datasourceTable.didScroll = {
        }
        datasourceTable.didSelect = {cell, index in
            guard let _ = cell as? CreditsCell else { return}
        }
    }
}


