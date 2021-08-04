//
//  verificationDocsVC.swift
//  SmileIndia
//
//  Created by Sakshi  on 13/05/20.
//  Copyright © 2020 Na. All rights reserved.
//

import UIKit
import BSImagePicker
import Photos
import Localize

class verificationDocsVC: UIViewController {
    
    var  object: Appointment?
   
    var imageArray = [UIImage]()
    var selectedAssets = [PHAsset]()
    
    
    var img :UIImage?
    var img2 :UIImage?
    var allowEditing = true
    @IBOutlet weak var varFilesLabel: UILabel!
    
    lazy var picker: CustomImagePicker = {
        let imagePicker = CustomImagePicker()
        imagePicker.handler = { [self] in
            self.FrontImageView.isHidden = false
            let size = CGSize(width: 350, height: 350)
            self.FrontImageView.image = $0.crop(to: size)
            let frontsize = self.FrontImageView.image?.size
            print("front image size")
            print(frontsize)
            self.imageArray.append(self.FrontImageView.image!)
           
           
        }
        return imagePicker
    }()
    lazy var picker2: CustomImagePicker = {
        let imagePicker = CustomImagePicker()
        imagePicker.handler = { [self] in
            let size = CGSize(width: 350, height: 350)
            self.BackImageView.image = $0.crop(to: size)
            self.imageArray.append(self.BackImageView.image!)
            print("self.imageArray.count")
            print(self.imageArray.count)
            print(self.imageArray)
            
        }
        return imagePicker
    }()
  
    var currentView: UIViewController? {
        guard let delegate = UIApplication.shared.delegate as? AppDelegate else { return nil }
        return delegate.window?.rootViewController
    }

    var filePathUrl:URL?
    
    
    @IBOutlet weak var backBtn: UIButton!
    @IBOutlet weak var BackImageView: UIImageView!
    @IBOutlet weak var FrontImageView: UIImageView!
    @IBOutlet weak var viewFront: UIView!
    @IBOutlet weak var viewBack: UIView!
    //@IBOutlet weak var selectedImage: UIImageView!
    @IBOutlet weak var selectedLabel: UILabel!
    
    @IBOutlet weak var frontImageName: UILabel!
    
    @IBOutlet weak var backImageName: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        setStatusBar(color: .themeGreen)
       
       
        viewFront.isUserInteractionEnabled = true
        let tapGesture = UITapGestureRecognizer.init(target: self, action: #selector(didtapviewFront))
        viewFront.addGestureRecognizer(tapGesture)
        viewBack.isUserInteractionEnabled = true
        let tapback = UITapGestureRecognizer.init(target: self, action: #selector(didtapviewBack))
        viewBack.addGestureRecognizer(tapback)

        setupLbl()
    }
    func setupLbl()  {
        
        // Atrribute
        let attributes = [[NSAttributedString.Key.foregroundColor:UIColor.red]]
        
        // verification doc
        varFilesLabel.attributedText = BankAccountScreentxt.verificationDoc.localize().highlightWordsIn(highlightedWords: "*", attributes: attributes)
        
       
    }
    @objc func didtapviewFront(){
      print("select front side")
        picker.showOptions()
       
        
    }
    @objc func didtapviewBack(){
      print("seleck back side ")
        picker2.showOptions()
    }

    @IBAction func didTapBack(_ sender: Any) {
        NavigationHandler.pop()
    }
    
    @IBAction func didTapUpload(_ sender: Any) {
        if isValid(){
        self.uploadimage()
      //  UploadVerficationFile()
            
        }
        
    }
    
    func isValid() -> Bool {
        if FrontImageView.image == nil{
            AlertManager.showAlert(type: .custom(BankAccountScreentxt.uploadeFront.localize()))
             return false
       
        }
        else if BackImageView.image == nil{
            AlertManager.showAlert(type: .custom(BankAccountScreentxt.uplodeBack.localize()))
            return false
        }
        return true
    
    

    }
    
    
    func uploadimage() -> Void {
        
        self.view.activityStartAnimating(activityColor: #colorLiteral(red: 0.233, green: 0.816, blue: 0.538, alpha: 1), backgroundColor: UIColor.white)
        
        
        let currentTimeStamp = String(Int(NSDate().timeIntervalSince1970))

        let filename = "userId_\(Authentication.customerGuid ?? "0")_\(currentTimeStamp).png"

        let fieldName = "AuthKey"
        let fieldValue = "\(Constants.authKey ?? "0")"

        let fieldName2 = "CustomerId"
        let fieldValue2 = "\(Authentication.customerGuid!)"

        let filefront = "FileFront"
        let fileBack = "FileBack"
        let config = URLSessionConfiguration.default
        let session = URLSession(configuration: config)

        
        // Set the URLRequest to POST and to the specified URL

        var urlRequest = URLRequest(url: URL(string: "\(APIConstants.mainUrl)Api/UploadVerficationFile")!)

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
        print (Data())
        // 2
        data.append("\r\n--\(boundary)\r\n".data(using: .utf8)!)
        data.append("Content-Disposition: form-data; name=\"\(fieldName2)\"\r\n\r\n".data(using: .utf8)!)
        data.append("\(fieldValue2)".data(using: .utf8)!)
        print (Data())
        // 3
        
        data.append("\r\n--\(boundary)\r\n".data(using: .utf8)!)
        data.append("Content-Disposition: form-data; name=\"\(filefront)\"; filename=\"\(filename)\"\r\n".data(using: .utf8)!)
        data.append("Content-Type: image/png\r\n\r\n".data(using: .utf8)!)
        data.append((FrontImageView.image?.jpegData(compressionQuality: 0.6)!)!)
        print (Data())
        
        data.append("\r\n--\(boundary)\r\n".data(using: .utf8)!)
        data.append("Content-Disposition: form-data; name=\"\(fileBack)\"; filename=\"\(filename)\"\r\n".data(using: .utf8)!)
        data.append("Content-Type: image/png\r\n\r\n".data(using: .utf8)!)
        data.append((BackImageView.image?.jpegData(compressionQuality: 0.6)!)!)
        print (Data())
        
     /*   for img in imageArray {
            data.append("\r\n--\(boundary)\r\n".data(using: .utf8)!)
            data.append("Content-Disposition: form-data; name=\"fileToUpload\"; filename=\"\(filename)\"\r\n".data(using: .utf8)!)
            data.append("Content-Type: image/png\r\n\r\n".data(using: .utf8)!)
            data.append(img.jpegData(compressionQuality: 0.6)!)
            print (Data())
        }
        print(imageArray)*/
        

        data.append("\r\n--\(boundary)--\r\n".data(using: .utf8)!)

        // Send a POST request to the URL, with the data we created earlier
        session.uploadTask(with: urlRequest, from: data, completionHandler: { responseData, response, error in
            
            DispatchQueue.main.async {
                if(error != nil){
                    print("\(error!.localizedDescription)")
                    AlertManager.showAlert(type: .custom(error!.localizedDescription))
                }
                guard let responseData = responseData else {return}
                print(responseData)
                if let responseString = String(data: responseData, encoding: .utf8) {
                    print("uploaded to: \(responseString)")
                    AlertManager.showAlert(type: .custom(BankAccountScreentxt.uploadSuccess.localize())) {
                        NavigationHandler.pushTo(.BankAccount)
                    }
                }
                self.view.activityStopAnimating()

            }
        }).resume()
        

    }
}

  /*  func UploadVerficationFile() -> Void {
        guard let image = FrontImageView.image else { return  }
        let queryItems = ["AuthKey": Constants.authKey,"CustomerGuid": "\(Authentication.customerGuid ?? "")","FileFront": FrontImageView.image,"FileBack": BackImageView.image] as [String : Any]

        
        WebService.UploadVerficationFile(queryItems: queryItems) { (result) in
                DispatchQueue.main.async {
                    activityIndicator.hideLoader()
                    switch result {
                    case .success:
                        AlertManager.showAlert(type: .custom("Documents Uploaded Successfully!")) {
                               // NavigationHandler.pop()
                        }
                    case .failure(let error):
                        AlertManager.showAlert(type: .custom(error.message))
                    }
                }
            }
        }*/
    
    
 

