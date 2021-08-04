//
//  UploadFileVC.swift
//  SmileIndia
//
//  Created by Arjun  on 18/05/20.
//  Copyright © 2020 Na. All rights reserved.
//

import UIKit
import BSImagePicker
import Photos
import OpalImagePicker

class UploadFileVC: UIViewController {
    
    var  object: Appointment?
    var imageArray = [UIImage]()
    var selectedAssets = [PHAsset]()
    
    var allowEditing = true
    lazy var pickerController: UIImagePickerController = {
        let controller = UIImagePickerController()
        controller.delegate = self
        controller.allowsEditing = self.allowEditing
        return controller
    }()
    
    
    var filePathUrl:URL?
    
    
    @IBOutlet weak var selectedImage: UIImageView!
    @IBOutlet weak var
        selectedLabel: UILabel!
    
    
    lazy var picker: CustomImagePicker = {
        let imagePicker = CustomImagePicker()
        imagePicker.handler = {
            self.selectedImage.image = $0
        }
        return imagePicker
    }()

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        setStatusBar(color: .themeGreen)

    }

    @IBAction func didtapBack(_ sender: Any) {
        NavigationHandler.pop()
    }
    
    @IBAction func didtapUpload(_ sender: Any) {
       // picker.showOptions()
        self.showOptions()
    }
    
    @IBAction func didtapSave(_ sender: Any) {
      //  self.uploadMemberFiles()
        if imageArray.count > 0{
            self.uploadimage()
        }else{
            AlertManager.showAlert(type: Prompt.custom(AppointmentScreenTxt.chooseFile.localize()))
        }
    }
    
    func showOptions(){
        let alert:UIAlertController=UIAlertController(title: AppointmentScreenTxt.selectImgFrom.localize(), message: nil, preferredStyle: UIAlertController.Style.actionSheet)
        let cameraAction = UIAlertAction(title: AppointmentScreenTxt.camera.localize(), style: UIAlertAction.Style.default)
        {
            UIAlertAction in
            self.openCamera()
        }
        let galleryAction = UIAlertAction(title: AppointmentScreenTxt.Gallery.localize(), style: UIAlertAction.Style.default)
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
            AlertManager.showAlert(type: Prompt.custom(AppointmentScreenTxt.acessCameraDont.localize()))
        }
    }
    
    func openMultipleImageSelector() -> Void {
        
//            let imagePicker = ImagePickerController()
//            imagePicker.settings.selection.max = 2
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
//                    }
//                }
//
//                self.selectedLabel.text = "You have selected \(self.imageArray.count) files"
//
//            }, completion: {
//                let finish = Date()
//                print(finish.timeIntervalSince(start))
//            })

        
        
        let imagePicker = OpalImagePickerController()
        imagePicker.maximumSelectionsAllowed = 2
        imagePicker.allowedMediaTypes = Set([PHAssetMediaType.image])
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
                    }
                }
                
                self.selectedLabel.text = "\(AppointmentScreenTxt.selected.localize()) \(self.imageArray.count) \(AppointmentScreenTxt.files.localize())"

                
                self.dismiss(animated: true, completion: nil)
                
            }, cancel: {
                //Cancel
            })
        
        
    }
    
    func uploadMemberFiles() -> Void {
        guard let image = selectedImage.image else { return  }

        let queryItems =  ["AppointmentId": "\(object?.Id ?? 0)","ProviderId": "\(Authentication.customerGuid!)","MemberId": "\(object?.MemberId ?? 0)","fileInput": image.pngData()!] as [String : Any]
        
        activityIndicator.showLoaderOnWindow()
        WebService.uploadMemberFiles(queryItems: queryItems) { (result) in
                DispatchQueue.main.async {
                    activityIndicator.hideLoader()
                    switch result {
                    case .success:
                        AlertManager.showAlert(type: .custom(AppointmentScreenTxt.fileuploadSucessFully.localize())) {
                                NavigationHandler.pop()
                        }
                    case .failure(let error):
                        AlertManager.showAlert(type: .custom(error.message))
                    }
                }
            }
        }

    
    
    func uploadimage() -> Void {
        
        self.view.activityStartAnimating(activityColor: #colorLiteral(red: 0.233, green: 0.816, blue: 0.538, alpha: 1), backgroundColor: UIColor.white)
        
        guard let image = selectedImage.image else { return  }
        let currentTimeStamp = String(Int(NSDate().timeIntervalSince1970))

        let filename = "userId_\(object?.MemberId ?? 0)_\(currentTimeStamp).png"

        let fieldName = "AppointmentId"
        let fieldValue = "\(object?.Id ?? 0)"

        let fieldName2 = "ProviderId"
        let fieldValue2 = "\(Authentication.customerGuid!)"

        let fieldName3 = "MemberId"
        let fieldValue3 = "\(object?.MemberId ?? 0)"
        
        let config = URLSessionConfiguration.default
        let session = URLSession(configuration: config)

        
        // Set the URLRequest to POST and to the specified URL
        var urlRequest = URLRequest(url: URL(string: "\(APIConstants.mainUrl)Api/UploadMemberFiles")!)

        urlRequest.httpMethod = "POST"

        // generate boundary string using a unique per-app string
        let boundary = UUID().uuidString

        // Set Content-Type Header to multipart/form-data, this is equivalent to submitting form data with file upload in a web browser
        // And the boundary is also set here
        urlRequest.setValue("multipart/form-data; boundary=\(boundary)", forHTTPHeaderField: "Content-Type")

        // start forming data from here
        var data = Data()
        // 1
        data.append("\r\n--\(boundary)\r\n".data(using: .utf8)!)
        data.append("Content-Disposition: form-data; name=\"\(fieldName)\"\r\n\r\n".data(using: .utf8)!)
        data.append("\(fieldValue)".data(using: .utf8)!)

        // 2
        data.append("\r\n--\(boundary)\r\n".data(using: .utf8)!)
        data.append("Content-Disposition: form-data; name=\"\(fieldName2)\"\r\n\r\n".data(using: .utf8)!)
        data.append("\(fieldValue2)".data(using: .utf8)!)
        
        // 3
        data.append("\r\n--\(boundary)\r\n".data(using: .utf8)!)
        data.append("Content-Disposition: form-data; name=\"\(fieldName3)\"\r\n\r\n".data(using: .utf8)!)
        data.append("\(fieldValue3)".data(using: .utf8)!)

        // 4
        for img in imageArray {
            data.append("\r\n--\(boundary)\r\n".data(using: .utf8)!)
            data.append("Content-Disposition: form-data; name=\"fileToUpload\"; filename=\"\(filename)\"\r\n".data(using: .utf8)!)
            data.append("Content-Type: image/png\r\n\r\n".data(using: .utf8)!)
            data.append(img.jpegData(compressionQuality: 0.6)!)
        }
        
//        data.append("\r\n--\(boundary)\r\n".data(using: .utf8)!)
//        data.append("Content-Disposition: form-data; name=\"fileToUpload\"; filename=\"\(filename)\"\r\n".data(using: .utf8)!)
//        data.append("Content-Type: image/png\r\n\r\n".data(using: .utf8)!)
//        data.append(image.jpegData(compressionQuality: 0.6)!)

        // End the raw http request data, note that there is 2 extra dash ("-") at the end, this is to indicate the end of the data
        // According to the HTTP 1.1 specification https://tools.ietf.org/html/rfc7230
        data.append("\r\n--\(boundary)--\r\n".data(using: .utf8)!)

        // Send a POST request to the URL, with the data we created earlier
        session.uploadTask(with: urlRequest, from: data, completionHandler: { responseData, response, error in
            
            DispatchQueue.main.async {
                if(error != nil){
                    print("\(error!.localizedDescription)")
                    AlertManager.showAlert(type: .custom(error!.localizedDescription))
                }
                guard let responseData = responseData else {return}
                
                if let responseString = String(data: responseData, encoding: .utf8) {
                   // print("uploaded to: \(responseString)")
                    AlertManager.showAlert(type: .custom(AppointmentScreenTxt.fileuploadSucessFully.localize())) {
                            NavigationHandler.pop()
                    }
                }
                self.view.activityStopAnimating()

            }
        }).resume()
        

    }
}

extension UploadFileVC: UIImagePickerControllerDelegate,UINavigationControllerDelegate {
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        picker.dismiss(animated: true) {
            DispatchQueue.main.async {
                if let image = info[UIImagePickerController.InfoKey.editedImage] as? UIImage {
                    self.imageArray.append(image)
                    self.selectedLabel.text = "\(AppointmentScreenTxt.selected.localize()) \(self.imageArray.count) \(AppointmentScreenTxt.files.localize())"
                } else if let image = info[UIImagePickerController.InfoKey.originalImage] as? UIImage {
                    self.imageArray.append(image)
                    self.selectedLabel.text = "\(AppointmentScreenTxt.selected.localize()) \(self.imageArray.count) \(AppointmentScreenTxt.files.localize())"
                }
            }
        }
    }
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        picker.dismiss(animated: true, completion: nil)
    }
}
