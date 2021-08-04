//
//  AddPrescriptionVC.swift
//  SmileIndia
//
//  Created by Arjun  on 13/05/20.
//  Copyright © 2020 Na. All rights reserved.
//

import UIKit

class PrescriptionListVC: UIViewController {
    
    var datasourceTable = GenericDataSource()
    var templates = [PrescriptionTemplates]()

    @IBOutlet weak var prescriptionTable: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        setStatusBar(color: .themeGreen)

    }
    
    override func viewWillAppear(_ animated: Bool) {
        getPrescriptionTemplates()
        NotificationCenter.default.addObserver(self, selector: #selector(self.deleteTemplateNotificationReceived(notification:)), name: Notification.Name("deleteTemplate"), object: nil)
    }
    @objc func deleteTemplateNotificationReceived(notification: Notification){
        getPrescriptionTemplates()
    }
    
    @IBAction func didtapBack(_ sender: Any) {
        NavigationHandler.pop()
    }
    
    @IBAction func didtapAdd(_ sender: Any) {
        NavigationHandler.pushTo(.addPrescription)
    }
    
    func getPrescriptionTemplates() -> Void {

        let queryItems = ["CustomerId": Authentication.customerId!]
        self.view.activityStartAnimating(activityColor: #colorLiteral(red: 0.233, green: 0.816, blue: 0.538, alpha: 1), backgroundColor: UIColor.white)
        WebService.getPrescriptionTemplates(queryItems: queryItems) { (result) in
         DispatchQueue.main.async {
                switch result {
                case .success (let response):
                     print(response)
                    if let templates = response.objects {
                        self.templates = templates
                        DispatchQueue.main.async {
                            self.setUpTableCell(templates)
                            self.prescriptionTable.reloadData()
                        }
                    }
                case .failure(let error):
                    AlertManager.showAlert(type: .custom(error.message)){
                            NavigationHandler.pop()
                    }
              }
            self.view.activityStopAnimating()
            }
        }
    }
    
    func setUpTableCell(_ templates: [PrescriptionTemplates]){
        datasourceTable.array = templates
        datasourceTable.identifier = PrescriptonTemplateCell.identifier
        prescriptionTable.dataSource = datasourceTable
        prescriptionTable.delegate = datasourceTable
        prescriptionTable.tableFooterView = UIView()
        datasourceTable.configure = {cell, index in
            guard let templatesCell = cell as? PrescriptonTemplateCell else { return }
            templatesCell.object = templates[index]
            templatesCell.deleteBtn.tag = index
            templatesCell.deleteBtn.addTarget(self, action:  #selector(self.deleteBtnPressed(sender:)), for: .touchUpInside)
        }
        datasourceTable.didScroll = {
        }
        datasourceTable.didSelect = {cell, index in
         //   guard let _ = cell as? PendingTableCell else { return}
        }
    }
    
    @objc func deleteBtnPressed(sender: UIButton) {
        AlertManager.showAlert(type: .custom("Are you sure to delete this template?"), actionTitle: AlertBtnTxt.okay.localize()) {
            let template = self.templates[sender.tag]
            self.deleteTemplate(tempId: "\(template.Id ?? 0)")
        }
    }
    func deleteTemplate(tempId:String) -> Void {
        
        let queryItems =  ["TemplateId": tempId]
        activityIndicator.showLoaderOnWindow()
        WebService.deletePrescriptionTemplate(queryItems: queryItems) { (result) in
                DispatchQueue.main.async {
                    activityIndicator.hideLoader()
                    switch result {
                    case .success:
                        self.getPrescriptionTemplates()
                        AlertManager.showAlert(type: .custom(("Template deleted successfully!")))
                    case .failure(let error):
                        AlertManager.showAlert(type: .custom(error.message))
                    }
                }
            }
        }
}
