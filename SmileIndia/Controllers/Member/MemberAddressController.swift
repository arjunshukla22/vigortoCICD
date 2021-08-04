//
//  MemberAddressController.swift
//  SmileIndia
//
//  Created by Na on 19/05/19.
//  Copyright © 2019 Na. All rights reserved.
//

import UIKit

class MemberAddressController: BaseViewController {
    
    @IBOutlet weak var addressTextfield: UITextField!
    @IBOutlet weak var address2Textfield: UITextField!
    @IBOutlet weak var stateTextfield: CustomTextfield!
    @IBOutlet weak var cityTextfield: CustomTextfield!
    @IBOutlet weak var pincodeTextfield: UITextField!
    @IBOutlet weak var newMemberTableView: UITableView!
    @IBOutlet weak var constraintViewHeight: NSLayoutConstraint!
    @IBOutlet weak var constraintTableHeight: NSLayoutConstraint!
    
    var dict = [String: Any]()
    var relation = [["Text": "Select Relationship", "Value": "0"],["Text": "Father", "Value": "1"],["Text": "Mother", "Value": "2"],["Text": "Wife", "Value": "3"],["Text": "Son", "Value": "4"],["Text": "Daughter", "Value": "5"],["Text": "Brother", "Value": "6"],["Text": "Sister", "Value": "7"],["Text": "Grand Father", "Value": "8"],["Text": "Grand Mother", "Value": "9"],["Text": "Uncle", "Value": "10"],["Text": "Aunt", "Value": "11"]]
    var relations = [List]()
    var memberArray = [[String: Any]]()
    let viewmodel = SignupViewModel()
    var datasource = GenericDataSource()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        do{
            let json = try JSONSerialization.data(withJSONObject: relation)
            let decoder = JSONDecoder()
            decoder.keyDecodingStrategy = .convertFromSnakeCase
            let decoded = try decoder.decode([List].self, from: json)
            decoded.forEach{print($0)}
            relations = decoded
        } catch {
            print(error)
        }
        viewmodel.getGender(completion: nil)
       // viewmodel.getState(coun) {
     //       self.stateTextfield.array = self.viewmodel.states
     //   }
        activityIndicator.hideLoader()
        self.setUpCell()
    }
    
    @IBAction func didTapAddMemberButton(_ sender: Any) {
        let popOverVC = self.storyboard?.instantiateViewController(withIdentifier: "AddMemberController") as! AddMemberController
        popOverVC.modalPresentationStyle = UIModalPresentationStyle.overFullScreen
        popOverVC.handler = { data in
            DispatchQueue.main.async {
                self.memberArray.append(data)
                self.constraintTableHeight.constant = CGFloat(self.memberArray.count * 70)
                self.constraintViewHeight.constant = CGFloat(self.memberArray.count * 70)+460
                self.setUpCell()
                self.newMemberTableView.reloadData()
            }
        }
        self.present(popOverVC, animated: true)
    }
    
    @IBAction func didTapStateTextField(_ sender: Any) {
        guard let stateId = stateTextfield.accessibilityLabel else {
            return}
        viewmodel.getCity(stateId){
            self.cityTextfield.array = self.viewmodel.cities
        }
    }
    @IBAction func didTapBackButton(_ sender: Any){
        NavigationHandler.pop()
    }
    
    @IBAction func didTapNextButton(_ sender: Any) {
        if isValid() {
            dict["ZipCode"] = pincodeTextfield.text
            dict["StateProvinceId"] = stateTextfield.accessibilityLabel
            dict["CityId"] = cityTextfield.accessibilityLabel
            dict["Address1"] = addressTextfield.text
            dict["Address2"] = address2Textfield.text
            if memberArray.count > 0 {
                let json = try? JSONSerialization.data(withJSONObject: memberArray, options: JSONSerialization.WritingOptions.prettyPrinted)
                dict["FamilyMembersList"] = String(data: json ?? Data(), encoding: String.Encoding.utf8)
            }
            
            registerMember(dict)
        }
    }
    
}
extension MemberAddressController{
    func registerMember(_ query: [String: Any])  {
        self.view.endEditing(true)
        self.view.activityStartAnimating(activityColor:
            .themeGreen, backgroundColor: UIColor.white)
        WebService.registerMember(queryItems: query) { (result) in
            DispatchQueue.main.async {
                switch result {
                case .success(let response):
                    AlertManager.showAlert(type: .custom( response.message ?? ""), title: AlertBtnTxt.okay.localize(), action: {
                        NavigationHandler.setRoot(.welcome)
                    })
                case .failure(let error):
                    AlertManager.showAlert(type: .custom(error.message))
                }
                self.view.activityStopAnimating()
            }
        }
    }
    func isValid() -> Bool {
        if addressTextfield.text?.isEmptyString() ?? false{
            AlertManager.showAlert(type: .custom("Please enter address line 1."))
            return false
        } else  if  stateTextfield.accessibilityLabel == "0" || stateTextfield.accessibilityLabel == nil {
            AlertManager.showAlert(type: .custom("Please select state."))
            return false
        }else if cityTextfield.accessibilityLabel == "0" || cityTextfield.accessibilityLabel == nil {
            AlertManager.showAlert(type: .custom("Please select city."))
            return false
        }  else if  pincodeTextfield.text?.isEmptyString() ?? false || pincodeTextfield.text?.count ?? 0 < 6 {
            AlertManager.showAlert(type: .custom("Please enter zipcode."))
            return false
        }
        return true
    }
    
    func setUpCell(){
       
        datasource.array = memberArray
        datasource.identifier = AddNewMemberCell.identifier
        newMemberTableView.dataSource = datasource
        newMemberTableView.delegate = datasource
        datasource.configure = {cell, index in
            guard let newMemberCell = cell as? AddNewMemberCell else { return }
            newMemberCell.object = self.memberArray[index]
            if let object = self.viewmodel.gender.filter({ $0.Value == (self.memberArray[index]["GenderId"] as! String) }).first {
                newMemberCell.genderLabel.text = object.Text
            }
            if let object = self.relations.filter({ $0.Value == (self.memberArray[index]["FamilyMemberRelationShipId"] as! String) }).first {
                newMemberCell.relationLabel.text = object.Text
            }
            newMemberCell.handler = {
                self.memberArray.remove(at: index)
                self.constraintTableHeight.constant = CGFloat(self.memberArray.count * 70)
                self.constraintViewHeight.constant = CGFloat(self.memberArray.count * 70)+460
                self.setUpCell()
            }
        }
        
    }
    
}

