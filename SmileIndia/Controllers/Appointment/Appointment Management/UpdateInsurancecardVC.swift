//
//  UpdateInsurancecardVC.swift
//  SmileIndia
//
//  Created by Arjun  on 23/02/21.
//  Copyright © 2021 Na. All rights reserved.
//

import UIKit
import BSImagePicker
import Photos
import OpalImagePicker


class UpdateInsurancecardVC: UIViewController {
    
    @IBOutlet weak var selectedImg: UIImageView!
    @IBOutlet weak var chooseBtn: UIButton!
    @IBOutlet weak var uploadBtn: UIButton!
    
    
    var  objectApmnt: Appointment?
    var imgUrl : URL?

    
    var imageArray = [UIImage]()
    var selectedAssets = [PHAsset]()
    
    var allowEditing = true
    lazy var pickerController: UIImagePickerController = {
        let controller = UIImagePickerController()
        controller.delegate = self
        controller.allowsEditing = self.allowEditing
        return controller
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        selectedImg.sd_setImage(with: URL(string: "\(APIConstants.mainUrl)" + "\(self.objectApmnt?.InsuranceCardPic ?? "")")!, placeholderImage: UIImage.gif(name: "insurance_loader"))


    }
    
    

    
    @IBAction func didtapBack(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func didtapChoosefile(_ sender: Any) {
        self.showOptions()
    }
    
    @IBAction func didtapUploadcard(_ sender: Any) {
        if imageArray.count > 0 {
            self.uploadInsuranceCard()
        }else{
            let alert = UIAlertController(title: "Please choose your file first", message: "", preferredStyle: UIAlertController.Style.alert)
            alert.addAction(UIAlertAction(title: AlertBtnTxt.okay.localize(), style: UIAlertAction.Style.default, handler: nil))
            self.present(alert, animated: true, completion: nil)
        }
    }
    
    func uploadInsuranceCard()  {
        let queryItems = ["image": self.imageArray[0].jpegData(compressionQuality: 0.6)! ,"FilePath":"InsuranceCards" , "AppointmentId":"\(self.objectApmnt?.Id ?? 0)"] as [String : Any]
        self.view.activityStartAnimating(activityColor: .themeGreen, backgroundColor: UIColor.white)
        WebService.uploadInsuranceCard(queryItems: queryItems) { (result) in
            DispatchQueue.main.async {
                switch result {
                case .success(let response):
                    let alert = UIAlertController(title: response.message ?? "", message: "", preferredStyle: .alert)
                    alert.addAction(UIAlertAction(title: AlertBtnTxt.okay.localize(), style: .default, handler: { action in
                          switch action.style{
                          case .default:
                            NotificationCenter.default.post(name: Notification.Name("insurancecard"), object: nil)
                            self.dismiss(animated: true, completion: nil)
                          case .cancel:
                                print("cancel")
                          case .destructive:
                                print("destructive")
                    }}))
                    self.present(alert, animated: true, completion: nil)

                case .failure(let error):
                    AlertManager.showAlert(type: .custom(error.message))
                }
                self.view.activityStopAnimating()
            }
        }
    }

}


extension UpdateInsurancecardVC: UIImagePickerControllerDelegate,UINavigationControllerDelegate {
    
    func showOptions(){
        let alert:UIAlertController=UIAlertController(title: "Select Images From", message: nil, preferredStyle: UIAlertController.Style.actionSheet)
        let cameraAction = UIAlertAction(title: "Camera", style: UIAlertAction.Style.default)
        {
            UIAlertAction in
            self.openCamera()
        }
        let galleryAction = UIAlertAction(title: "Gallery", style: UIAlertAction.Style.default)
        {
            UIAlertAction in
            self.openMultipleImageSelector()
        }
        let cancelAction = UIAlertAction(title: AlertBtnTxt.cancel.localize(), style: UIAlertAction.Style.cancel)
        {
            UIAlertAction in
        }
        alert.addAction(cameraAction)
        alert.addAction(galleryAction)
        alert.addAction(cancelAction)
        self.present(alert, animated: true, completion: nil)
    }
    
    func openCamera() {
        let sourceType =  UIImagePickerController.SourceType.camera
        if  UIImagePickerController.isSourceTypeAvailable(sourceType)  {
            self.pickerController.sourceType = sourceType
            self.present(self.pickerController, animated: true, completion: nil)
        }
        else {
            AlertManager.showAlert(type: Prompt.custom("Don't have camera access"))
        }
    }
    
    func openMultipleImageSelector() -> Void {
        
        let imagePicker = OpalImagePickerController()
        imagePicker.maximumSelectionsAllowed = 1
        presentOpalImagePickerController(imagePicker, animated: true,
            select: { (assets) in
                //Select Assets
                
                self.selectedAssets = assets
                for i in 0...self.selectedAssets.count-1{
                    
                    let manager = PHImageManager.default()
                    let option = PHImageRequestOptions()
                    option.isSynchronous = true
                    option.deliveryMode = .highQualityFormat
                    option.resizeMode = .exact
                    
                    manager.requestImage(for: self.selectedAssets[i], targetSize: PHImageManagerMaximumSize, contentMode: .aspectFit, options: option) { (image, info) in
                        self.imageArray.append(image ?? UIImage())
                        self.selectedImg.image = image ?? UIImage()
                    }
                }
                
                self.dismiss(animated: true, completion: nil)
                
            }, cancel: {
                //Cancel
            })
        
        
        
//            let imagePicker = ImagePickerController()
//            imagePicker.settings.selection.max = 1
//            imagePicker.settings.theme.selectionStyle = .numbered
//            imagePicker.settings.fetch.assets.supportedMediaTypes = [.image]
//            imagePicker.settings.selection.unselectOnReachingMax = true
//
//            let start = Date()
//            self.presentImagePicker(imagePicker, select: { (asset) in
//                print("Selected: \(asset)")
//            }, deselect: { (asset) in
//                print("Deselected: \(asset)")
//            }, cancel: { (assets) in
//                print("Canceled with selections: \(assets)")
//            }, finish: { (assets) in
//                print("Finished with selections: \(assets)")
//                // Request the maximum size. If you only need a smaller size make sure to request that instead.
//                self.selectedAssets = assets
//                for i in 0...self.selectedAssets.count-1{
//
//                    let manager = PHImageManager.default()
//                    let option = PHImageRequestOptions()
//                    option.isSynchronous = true
//                    option.deliveryMode = .highQualityFormat
//                    option.resizeMode = .exact
//
//                    manager.requestImage(for: self.selectedAssets[i], targetSize: PHImageManagerMaximumSize, contentMode: .aspectFit, options: option) { (image, info) in
//                        self.imageArray.append(image ?? UIImage())
//                        self.selectedImg.image = image ?? UIImage()
//                    }
//                }
//
//            }, completion: {
//                let finish = Date()
//                print(finish.timeIntervalSince(start))
//            })

    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        picker.dismiss(animated: true) {
            DispatchQueue.main.async {
                if let image = info[UIImagePickerController.InfoKey.editedImage] as? UIImage {
                    self.selectedImg.image = image
                    self.imageArray.append(image)
                } else if let image = info[UIImagePickerController.InfoKey.originalImage] as? UIImage {
                    self.selectedImg.image = image
                    self.imageArray.append(image)
                }
            }
        }
    }
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        picker.dismiss(animated: true, completion: nil)
    }
}
