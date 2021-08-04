//
//  FamilyMemberController.swift
//  SmileIndia
//
//  Created by Na on 20/05/19.
//  Copyright © 2019 Na. All rights reserved.
//

import UIKit

class FamilyMemberController: BaseViewController {

    @IBOutlet weak var newMemberTableView: UITableView!
    @IBOutlet weak var constraintTableHeight: NSLayoutConstraint!
    var dict = [String: Any]()
    var memberArray = [FamilyMembers]()
    let viewmodel = SignupViewModel()
    var datasource = GenericDataSource()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        familyData(["LoginKey": Authentication.token ?? ""])
        //cardNumberTextfield.text = "SM201900000030"
        // Do any additional setup after loading the view.
    }
    @IBAction func didTapBackButton(_ sender: Any) {
        NavigationHandler.pop()
    }
    
    
}
extension FamilyMemberController{
    func familyData(_ query: [String: Any]){
        activityIndicator.showLoaderOnWindow()
        self.view.endEditing(true)
        WebService.familyMemberData(queryItems: query) { (result) in
            DispatchQueue.main.async {
                activityIndicator.hideLoader()
                switch result {
                case .success(let response):
                    self.memberArray = response.object?.FamilyMemberList ?? []
                    self.constraintTableHeight.constant = CGFloat(self.memberArray.count*80)
                        self.setUpCell()
                case .failure(let error):
                    self.constraintTableHeight.constant = 0
                    print(error.message)
                    self.showError(message: error.message)
                }
            }
        }
    }
    func setUpCell(){
        datasource.array = memberArray
        datasource.identifier = FamilyMemberCell.identifier
        newMemberTableView.dataSource = datasource
        newMemberTableView.delegate = datasource
        datasource.configure = {cell, index in
            guard let newMemberCell = cell as? FamilyMemberCell else { return }
            newMemberCell.object = self.memberArray[index]
//            if let object = self.viewmodel.gender.filter({ $0.Value == (self.memberArray[index]["GenderId"] as! String) }).first {
//                newMemberCell.genderLabel.text = object.Text
//            }
//            if let object = self.viewmodel.gender.filter({ $0.Value == (self.memberArray[index]["FamilyMemberRelationShipId"] as! String) }).first {
//                newMemberCell.relationLabel.text = object.Text
//            }
        }
        
    }
    
}
