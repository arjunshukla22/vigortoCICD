//
//  PrescriptionVC.swift
//  SmileIndia
//
//  Created by Arjun  on 13/05/20.
//  Copyright © 2020 Na. All rights reserved.
//

import UIKit

class AddPrescriptionVC: UIViewController {
    
    @IBOutlet weak var titleTF: UITextField!
    @IBOutlet weak var descTextview: UITextView!
    
    var object: PrescriptionTemplates?

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        setStatusBar(color: .themeGreen)
        hideKeyboardWhenTappedAround()
        
        if let template = object{
            self.titleTF.text = template.Title
            self.descTextview.text = object?.Body?.htmlToString
        }

    }
    
    @IBAction func didtapBack(_ sender: Any) {
        NavigationHandler.pop()
    }
    
    @IBAction func didtapSave(_ sender: Any) {
        if isValidTemplate() {
            self.addTemplate()
        }
    }
    
    @IBAction func didtapCancel(_ sender: Any) {
        NavigationHandler.pop()
    }
    
    func addTemplate() -> Void {
        var queryItems = [String : Any]()
        if let template = object{
            queryItems = ["Id":"\(template.Id ?? 0)","CustomerId": Authentication.customerId ?? "0","Title": titleTF.text!, "Body": descTextview.text!.replacingOccurrences(of: "\n", with: "<br>")] as [String : Any]
        }else{
            queryItems = ["CustomerId": Authentication.customerId ?? "0","Title": titleTF.text!, "Body": descTextview.text!.replacingOccurrences(of: "\n", with: "<br>")] as [String : Any]
        }
        
        self.view.activityStartAnimating(activityColor: .themeGreen, backgroundColor: UIColor.white)
        WebService.createPrescriptionTemplate(queryItems: queryItems) { (result) in
                DispatchQueue.main.async {
                    switch result {
                    case .success:
                        if let template = self.object{
                            print(template)
                            AlertManager.showAlert(type: .custom("Template updated successfully!")){
                                    NavigationHandler.pop()
                            }
                        }else{
                            AlertManager.showAlert(type: .custom("Template saved successfully!")){
                                    NavigationHandler.pop()
                            }
                        }

                    case .failure(let error):
                        AlertManager.showAlert(type: .custom(error.message))
                    }
                    self.view.activityStopAnimating()
                }
             }
    }
    
    func isValidTemplate() -> Bool {

        if titleTF.text!.isEmpty {
            AlertManager.showAlert(type: .custom("Title Is Required."))
            return false
        } else if descTextview.text!.isEmpty{
            AlertManager.showAlert(type: .custom("Template Text Is Required."))
            return false
        }
        return true
    }
}
