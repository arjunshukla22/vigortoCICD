//
//  CustomImagePicker.swift
//  HandstandV2
//
//  Created by user on 18/01/19.
//  Copyright © 2019 Navjot Sharma. All rights reserved.
//

import Foundation
import UIKit
import Localize
class CustomImagePicker: NSObject{
    var handler: ((UIImage)->Void)? = nil

    var allowEditing = true
    lazy var pickerController: UIImagePickerController = {
        let controller = UIImagePickerController()
        controller.delegate = self
        controller.allowsEditing = self.allowEditing
        return controller
    }()
    var currentView: UIViewController? {
        guard let delegate = UIApplication.shared.delegate as? AppDelegate else { return nil }
        return delegate.window?.rootViewController
    }

    func showOptions(){
        let alert:UIAlertController=UIAlertController(title: BankAccountScreentxt.chooseImag.localize(), message: nil, preferredStyle: UIAlertController.Style.actionSheet)
        let cameraAction = UIAlertAction(title: BankAccountScreentxt.camera.localize(), style: UIAlertAction.Style.default)
        {
            UIAlertAction in
            self.openCamera()
        }
        let galleryAction = UIAlertAction(title: BankAccountScreentxt.gallery.localize(), style: UIAlertAction.Style.default)
        {
            UIAlertAction in
            self.openGallery()
        }
        let cancelAction = UIAlertAction(title: AlertBtnTxt.cancel.localize(), style: UIAlertAction.Style.cancel)
        {
            UIAlertAction in
        }
        alert.addAction(cameraAction)
        alert.addAction(galleryAction)
        alert.addAction(cancelAction)
        guard let view = self.currentView else { return }
        view.present(alert, animated: true, completion: nil)
    }
    func openCamera() {
        let sourceType =  UIImagePickerController.SourceType.camera
        if  UIImagePickerController.isSourceTypeAvailable(sourceType)  {
            self.pickerController.sourceType = sourceType
            guard let view = self.currentView else { return }
            view.present(self.pickerController, animated: true, completion: nil)
        }
        else {
            AlertManager.showAlert(type: Prompt.custom(BankAccountScreentxt.cameraAccess.localize()))
        }
    }
    
    func openGallery() {
        let sourceType =  UIImagePickerController.SourceType.savedPhotosAlbum
        if  UIImagePickerController.isSourceTypeAvailable(sourceType)  {
            self.pickerController.sourceType = sourceType
            guard let view = self.currentView else { return }
            view.present(self.pickerController, animated: true, completion: nil)
        }
        else {
            AlertManager.showAlert(type: Prompt.custom(BankAccountScreentxt.galleryAccess.localize()))
        }
    }
}
extension CustomImagePicker: UIImagePickerControllerDelegate,UINavigationControllerDelegate {
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        picker.dismiss(animated: true) {
            DispatchQueue.main.async {

                if let image = info[UIImagePickerController.InfoKey.editedImage] as? UIImage {
                    guard self.handler != nil else { return }
                    self.handler!(image)
                } else if let image = info[UIImagePickerController.InfoKey.originalImage] as? UIImage {
                    guard self.handler != nil else { return }
                    self.handler!(image)
                }
            }
        }
    }
   
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        picker.dismiss(animated: true, completion: nil)
    }
}
