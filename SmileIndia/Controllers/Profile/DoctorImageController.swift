//
//  DoctorImageController.swift
//  SmileIndia
//
//  Created by Na on 15/03/19.
//  Copyright © 2019 Na. All rights reserved.
//

import UIKit

class DoctorImageController: BaseViewController {
    
    @IBOutlet weak var priceTextField: UITextField!
    @IBOutlet weak var imageNameTextField: UITextField!
    @IBOutlet weak var doctorImageView: UIImageView!
    
    lazy var picker: CustomImagePicker = {
        let imagePicker = CustomImagePicker()
        imagePicker.handler = {
            self.doctorImageView.image = $0
        }
        return imagePicker
    }()
    
    var dict = [String: Any]()
    var viewModel = ProfileViewModel()
    var doctor: DoctorData?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setUI()
    }
    
    @IBAction func didTapBackButton(_ sender: Any) {
        NavigationHandler.pop()
    }
    
    @IBAction func didTapUpdateProfile(_ sender: Any) {
        if priceTextField.text?.isEmptyString() ?? false{
            AlertManager.showAlert(type: .custom("Please enter price for members."))
        } else if  let discount  = Int(priceTextField.text ?? "0"), let consultation  = Int( dict["ConsultationFee"] as! String) , Int(discount) > Int(consultation){
            AlertManager.showAlert(type: .custom("Please enter discount and it should be less than consultation fee."))
        }  else {
            dict["LoginKey"] = Authentication.token
            dict["DiscountOffered"] =  priceTextField.text
            print(dict)
            update()
        }
    }
    
    @IBAction func didTapSelectPhoto(_ sender: Any) {
        picker.showOptions()
    }
}

extension DoctorImageController{
    func update() {
        self.view.endEditing(true)
        self.view.activityStartAnimating(activityColor: .themeGreen, backgroundColor: UIColor.white)
        WebService.updateDoctor(queryItems: dict) { (result) in
            DispatchQueue.main.async {
                switch result {
                case .success:
                    let queryItems = ["AuthKey": Constants.authKey, "CustomerId": Authentication.customerGuid ?? 0, "image": self.doctorImageView.image?.jpegData(compressionQuality: 0.5) ?? UIImage()] as [String : Any]
                    self.uploadImage(queryItems)
                case .failure(let error):
                    AlertManager.showAlert(type: .custom(error.message), title: AlertBtnTxt.okay.localize(), action: {
                    })
                }
                self.view.activityStopAnimating()
            }
        }
    }
    
    func uploadImage(_ query: [String: Any])  {
        self.view.endEditing(true)
        self.view.activityStartAnimating(activityColor: .themeGreen, backgroundColor: UIColor.white)
        WebService.uploadImage(queryItems: query) { (result) in
            DispatchQueue.main.async {
                switch result {
                case .success:
                    AlertManager.showAlert(type: .custom( "Profile Updated Successfully"), title: AlertBtnTxt.okay.localize(), action: {
                        NavigationHandler.popTo(DoctorDashboardController.self)
                    })
                case .failure(let error):
                    AlertManager.showAlert(type: .custom(error.message))
                }
                self.view.activityStopAnimating()
            }
        }
    }
    
    func setUI() {
        priceTextField.text = doctor?.DiscountOffered
        doctorImageView.sd_setImage(with: doctor?.profileImageURL, placeholderImage: UIImage.init(named: "doctor-avtar"))
    }
}
