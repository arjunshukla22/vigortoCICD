//
//  PrescribeVC.swift
//  SmileIndia
//
//  Created by Arjun  on 15/06/20.
//  Copyright © 2020 Na. All rights reserved.
//

import UIKit
import BSImagePicker
import Photos
import OpalImagePicker
import MobileCoreServices

class PrescribeVC: UIViewController , UIPickerViewDelegate,UIPickerViewDataSource {
    
    @IBOutlet weak var lblslctdFiles: UILabel!
    @IBOutlet weak var selectTempTF: UITextField!
    @IBOutlet weak var templatetextTV: UITextView!
    @IBOutlet weak var emailsTF: UITextField!
    @IBOutlet weak var collectionFiles: UICollectionView!
    
    let picker = UIPickerView()
    var selected = 0
    
    
    
    var allowEditing = true
    lazy var pickerController: UIImagePickerController = {
        let controller = UIImagePickerController()
        controller.delegate = self
        controller.allowsEditing = self.allowEditing
        return controller
    }()
    
    var imageArray = [UIImage]()
    var selectedAssets = [PHAsset]()
    
    var templates = [PrescriptionTemplates]()
    var viewModel = PrescriptionViewModel()
    var drPrescriptionFiles = [DoctorPrescriptionFiles]()
    
    var  object: Appointment?
    var PrescriptionId = "0"
    
    var pdfUrl = ""
    
    var  prescriptionData: DrPrescription?
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        setStatusBar(color: #colorLiteral(red: 0.3803921569, green: 0.7333333333, blue: 0.2862745098, alpha: 1))
        
        
        getDoctorPrescription()
        getDoctorPrescriptionFiles()
        
        viewModel.getPrescriptionTemplates{
            self.pickerView()
        }
    }
    
    
    func getDoctorPrescription() -> Void {
        
        let queryItems = ["AppointmentId": "\(object?.Id ?? 0)"]
        self.view.activityStartAnimating(activityColor: #colorLiteral(red: 0.233, green: 0.816, blue: 0.538, alpha: 1), backgroundColor: UIColor.white)
        WebService.getDoctorPrescription(queryItems: queryItems) { (result) in
            DispatchQueue.main.async {
                switch result {
                case .success (let response):
                    if let prescription = response.object{
                        self.prescriptionData = prescription
                    }
                    
                    self.templatetextTV.text = self.prescriptionData?.PrescriptionText?.htmlToString
                    self.PrescriptionId = "2"
                case .failure(let error):
                    print(error)
                }
                self.view.activityStopAnimating()
            }
        }
    }
    
    func getDoctorPrescriptionFiles() -> Void {
        
        let queryItems = ["AppointmentId": "\(object?.Id ?? 0)"]
        self.view.activityStartAnimating(activityColor: #colorLiteral(red: 0.233, green: 0.816, blue: 0.538, alpha: 1), backgroundColor: UIColor.white)
        WebService.getDoctorPrescriptionFiles(queryItems: queryItems) { (result) in
            DispatchQueue.main.async {
                switch result {
                case .success (let response):
                    if let prescriptionFiles = response.objects {
                        self.drPrescriptionFiles = prescriptionFiles
                        DispatchQueue.main.async {
                            self.collectionFiles.reloadData()
                        }
                    }
                case .failure(let error):
                    print(error)
                }
                self.view.activityStopAnimating()
            }
        }
    }
    
    
    func uploadDoctorPrescriptionFiles()  {
        let queryItems = ["AppointmentId": "\(object?.Id ?? 0)","image": self.imageArray[0].jpegData(compressionQuality: 0.5) ?? UIImage()] as [String : Any]
        
        self.view.activityStartAnimating(activityColor: #colorLiteral(red: 0.233, green: 0.816, blue: 0.538, alpha: 1), backgroundColor: UIColor.white)
        WebService.uploadDoctorPrescriptionFiles(queryItems: queryItems) { (result) in
            DispatchQueue.main.async {
                switch result {
                case .success:
                    AlertManager.showAlert(type: .custom( "prescription uploaded successfully!"), title: AlertBtnTxt.okay.localize(), action: {
                        NavigationHandler.pop()
                    })
                case .failure(let error):
                    AlertManager.showAlert(type: .custom(error.message))
                }
                self.view.activityStopAnimating()
            }
        }
    }
    
    func deleteMemberFilebyId(fileId:Int) -> Void {
        
        let queryItems = ["FileId": fileId]
        self.view.activityStartAnimating(activityColor: #colorLiteral(red: 0.233, green: 0.816, blue: 0.538, alpha: 1), backgroundColor: UIColor.white)
        WebService.deleteMemberFilebyId(queryItems: queryItems) { (result) in
            DispatchQueue.main.async {
                switch result {
                case .success (let response):
                    print(response)
                    self.getDoctorPrescriptionFiles()
                case .failure(let error):
                    AlertManager.showAlert(on: self, type: .custom(error.message))
                }
                self.view.activityStopAnimating()
            }
        }
    }
    
    func addDoctorPrescription() -> Void {
        let queryItems = ["AppointmentId":"\(object?.Id ?? 0)","PrescriptionText": templatetextTV.text!.replacingOccurrences(of: "\n", with: "<br>"),"MultipleEmail": emailsTF.text!, "PrescriptionId": self.PrescriptionId ] as [String : Any]
        
        self.view.activityStartAnimating(activityColor: #colorLiteral(red: 0.233, green: 0.816, blue: 0.538, alpha: 1), backgroundColor: UIColor.white)
        WebService.addDoctorPrescription(queryItems: queryItems) { (result) in
            DispatchQueue.main.async {
                switch result {
                case .success:
                    if let template = self.object{
                        print(template)
                    }
                    self.uploadDoctorPrescriptionFiles()
                case .failure(let error):
                    AlertManager.showAlert(type: .custom(error.message))
                }
                self.view.activityStopAnimating()
            }
        }
    }
    
    
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
        self.imageArray.removeAll()
        
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
        //                    }
        //                    self.collectionFiles.reloadData()
        //                }
        //
        //                self.lblslctdFiles.text = "\(self.imageArray.count) file selected."
        //
        //            }, completion: {
        //                let finish = Date()
        //                print(finish.timeIntervalSince(start))
        //            })
        
        
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
                                                }
                                                self.collectionFiles.reloadData()
                                            }
                                            
                                            self.lblslctdFiles.text = "\(self.imageArray.count) file selected."
                                            
                                            self.dismiss(animated: true, completion: nil)
                                            
                                         }, cancel: {
                                            //Cancel
                                         })
        
        
        
    }
    
    func pickerView() {
        selectTempTF.rightViewMode = UITextField.ViewMode.always
        selectTempTF.rightView = UIImageView(image: UIImage(named: "dropdown"))
        picker.delegate = self
        selectTempTF.inputView = picker
        
        let toolBar = UIToolbar()
        toolBar.sizeToFit()
        
        let button = UIBarButtonItem(title: "Done", style: .done, target: self, action: #selector(self.action))
        button.tintColor = .lightGray
        toolBar.setItems([button], animated: true)
        toolBar.isUserInteractionEnabled = true
        
        selectTempTF.inputAccessoryView = toolBar
    }
    
    @objc func action() {
        if selectTempTF.isEditing == true {
            if viewModel.templates.count > 0{
                self.selectTempTF.text = viewModel.templates[selected].Title
                self.templatetextTV.text = viewModel.templates[selected].Body?.htmlToString
                self.view.endEditing(true)
            }else{
                self.view.endEditing(true)
                AlertManager.showAlert(type: .custom("Please First Create Your Prescription Template!"), actionTitle: AlertBtnTxt.okay.localize()) {
                    NavigationHandler.pushTo(.addPrescription)
                }
            }
        }
        
        view.endEditing(true)
    }
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return viewModel.templates.count
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return viewModel.templates[row].Title
        
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        self.selected = row
        self.selectTempTF.text = viewModel.templates[row].Title
        self.templatetextTV.text = viewModel.templates[row].Body?.htmlToString
    }
    
    
    @IBAction func didtapBack(_ sender: Any) {
        NavigationHandler.pop()
    }
    
    @IBAction func didtapSelectImage(_ sender: Any) {
        self.showOptions()
    }
    
    @IBAction func didtapPDF(_ sender: Any) {
        self.clickFunction()
    }
    
    @IBAction func didtapSave(_ sender: Any) {
        addDoctorPrescription()
    }
    
    @IBAction func didtapCancel(_ sender: Any) {
        NavigationHandler.pop()
    }
    
    
    
}


extension PrescribeVC: UIImagePickerControllerDelegate,UINavigationControllerDelegate {
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        picker.dismiss(animated: true) {
            DispatchQueue.main.async {
                self.imageArray.removeAll()
                
                if let image = info[UIImagePickerController.InfoKey.editedImage] as? UIImage {
                    self.imageArray.append(image)
                    self.collectionFiles.reloadData()
                    
                    self.lblslctdFiles.text = "\(self.imageArray.count) file selected."
                } else if let image = info[UIImagePickerController.InfoKey.originalImage] as? UIImage {
                    self.imageArray.append(image)
                    self.collectionFiles.reloadData()
                    
                    self.lblslctdFiles.text = "\(self.imageArray.count) file selected."
                }
            }
        }
    }
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        picker.dismiss(animated: true, completion: nil)
    }
}


extension PrescribeVC: UIDocumentMenuDelegate,UIDocumentPickerDelegate
{
    public func documentPicker(_ controller: UIDocumentPickerViewController, didPickDocumentsAt urls: [URL]) {
        guard let myURL = urls.first else {
            return
        }
        
        self.pdfUrl = "\(myURL)"
        print("import result : \(myURL)")
    }
    
    
    public func documentMenu(_ documentMenu:UIDocumentMenuViewController, didPickDocumentPicker documentPicker: UIDocumentPickerViewController) {
        documentPicker.delegate = self
        present(documentPicker, animated: true, completion: nil)
    }
    
    func documentPickerWasCancelled(_ controller: UIDocumentPickerViewController) {
        print("view was cancelled")
        dismiss(animated: true, completion: nil)
    }
    
    func clickFunction(){
        //   let importMenu = UIDocumentMenuViewController(documentTypes: ["com.microsoft.word.doc","org.openxmlformats.wordprocessingml.document", kUTTypePDF as String], in: .import)
        
        let importMenu = UIDocumentMenuViewController(documentTypes: [String(kUTTypePDF)], in: .import)
        importMenu.delegate = self
        importMenu.modalPresentationStyle = .formSheet
        self.present(importMenu, animated: true, completion: nil)
    }
    
    
}

extension PrescribeVC: UICollectionViewDataSource,UICollectionViewDelegate , UICollectionViewDelegateFlowLayout
{
    //this method is for the size of items
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let width = collectionView.frame.width/2
        //   let height : CGFloat = 180.0
        return CGSize(width: width, height: width - 20)
    }//these methods are to configure the spacing between items
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: 0,left: 0,bottom: 0,right: 0)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
    
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return drPrescriptionFiles.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "PrescribeCVCell", for: indexPath) as! PrescribeCVCell
        cell.imgFile.sd_setImage(with: URL(string: drPrescriptionFiles[indexPath.item].FilePath ?? "") ,placeholderImage: nil) //UIImage.init(named: "doctor-avtar")
        
        //cell.imgFile.image = imageArray[indexPath.item]
        cell.btnDelete.tag = indexPath.row
        cell.btnDelete.addTarget(self, action:  #selector(deleteBtnPressed(sender:)), for: .touchUpInside)
        cell.btnFullView.tag = indexPath.row
        cell.btnFullView.addTarget(self, action:  #selector(viewfullBtnPressed(sender:)), for: .touchUpInside)
        
        cell.btnFullView.isHidden = (Authentication.customerType == "Doctor")
        
        return cell
        
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
    }
    
    @objc func deleteBtnPressed(sender: UIButton) {
        self.deleteMemberFilebyId(fileId: drPrescriptionFiles[sender.tag].Id ?? 0)
        self.collectionFiles.reloadData()
    }
    
    @objc func viewfullBtnPressed(sender: UIButton) {
        
    }
    
}
