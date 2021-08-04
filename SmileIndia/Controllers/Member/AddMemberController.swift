//
//  AddMemberController.swift
//  SmileIndia
//
//  Created by Na on 19/05/19.
//  Copyright © 2019 Na. All rights reserved.
//

import UIKit

class AddMemberController: UIViewController {
    
    @IBOutlet weak var firstNameTextField: UITextField!
    @IBOutlet weak var lastNameTextField: UITextField!
    @IBOutlet weak var dobTextField: CustomTextfield!
    @IBOutlet weak var genderTextField: CustomTextfield!
    @IBOutlet weak var relationTextField: CustomTextfield!
    let viewmodel = SignupViewModel()
    var dict = [String: Any]()
    typealias NavigationHandler = ([String: Any])->()
    var handler : NavigationHandler?
    var relation = [["Text": "Select Relationship", "Value": "0"],["Text": "Father", "Value": "1"],["Text": "Mother", "Value": "2"],["Text": "Wife", "Value": "3"],["Text": "Son", "Value": "4"],["Text": "Daughter", "Value": "5"],["Text": "Brother", "Value": "6"],["Text": "Sister", "Value": "7"],["Text": "Grand Father", "Value": "8"],["Text": "Grand Mother", "Value": "9"],["Text": "Uncle", "Value": "10"],["Text": "Aunt", "Value": "11"]]

    override func viewDidLoad() {
        super.viewDidLoad()
        do{
            let json = try JSONSerialization.data(withJSONObject: relation)
            let decoder = JSONDecoder()
            decoder.keyDecodingStrategy = .convertFromSnakeCase
            let decoded = try decoder.decode([List].self, from: json)
            decoded.forEach{print($0)}
            self.relationTextField.array = decoded
        } catch {
            print(error)
        }
        viewmodel.getGender() {
            self.genderTextField.array = self.viewmodel.gender
        }
    }
    @IBAction func didTapBackButton(_ sender: Any){
       self.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func didTapSubmitButton(_ sender: Any) {
        if isValid() {
            dict["FamilyMemberFirstName"] = firstNameTextField.text
            dict["FamilyMemberLastName"] = lastNameTextField.text
            dict["GenderId"] = genderTextField.accessibilityLabel
            dict["DOB"] = dobTextField.accessibilityLabel
            dict["FamilyMemberRelationShipId"] = relationTextField.accessibilityLabel
            self.dismiss(animated: true) {
                self.handler?(self.dict)
            }
        }
    }
}
extension AddMemberController{
    func isValid() -> Bool {
        if  firstNameTextField.text?.isEmptyString() ?? false  {
            AlertManager.showAlert(type: .custom("Please enter first name."))
            return false
        } else if  lastNameTextField.text?.isEmptyString() ?? false  {
            AlertManager.showAlert(type: .custom("Please enter last name."))
            return false
        }  else if (dobTextField.accessibilityLabel == "0" || dobTextField.accessibilityLabel == nil) {
            AlertManager.showAlert(type: .custom("Please select date of birth."))
            return false
        }else if (genderTextField.accessibilityLabel == "0" || genderTextField.accessibilityLabel == nil) {
            AlertManager.showAlert(type: .custom("Please select gender."))
            return false
        } else if (relationTextField.accessibilityLabel == "0" || relationTextField.accessibilityLabel == nil) {
            AlertManager.showAlert(type: .custom("Please select relation."))
            return false
        }
        return true
        
    }
}

