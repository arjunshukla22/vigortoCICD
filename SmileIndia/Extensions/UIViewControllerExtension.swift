//
//  UIViewControllerExtension.swift
//  HandstandV2
//
//  Created by user on 24/12/18.
//  Copyright © 2018 Navjot Sharma. All rights reserved.
//

import Foundation
import UIKit
import TTGSnackbar
extension UIViewController{
    func ShowLoader()  {
        guard let delegate = UIApplication.shared.delegate as? AppDelegate else { return }
        delegate.window? .activityStartAnimating(activityColor: .themeGreen, backgroundColor: UIColor.white)
    }
    
    func HideLoader()  {
        guard let delegate = UIApplication.shared.delegate as? AppDelegate else { return }
        delegate.window?.activityStopAnimating()
    }
    
    class var storyboardId: String{
        return "\(self)"
    }
    
    static func instantiateFromAppStoryboard(_ appStoryboard: AppStoryboard) -> Self{
        return appStoryboard.viewController(self)
    }
    
    func setStatusBar(color: UIColor) {
        let tag = 12321
        if let taggedView = self.view.viewWithTag(tag){
            taggedView.removeFromSuperview()
        }
        let overView = UIView()
        overView.frame = UIApplication.shared.statusBarFrame
        overView.backgroundColor = color
        overView.tag = tag
        self.view.addSubview(overView)
    }
    
    // MARK: background image to view
    func setBackGroundImage(name:String,viewSource:UIView)
    {
        let backgroundImage = UIImageView(frame: UIScreen.main.bounds)
        backgroundImage.image = UIImage(named: name)
        backgroundImage.contentMode =  UIView.ContentMode.scaleAspectFit
        viewSource.insertSubview(backgroundImage, at: 0)
    } // usage setBackGroundImage(name:"tick.png")
    
    
    // MARK: Alert with textfiled

    func showInputDialog(title:String? = nil,
                         subtitle:String? = nil,
                         actionTitle:String? = "Add",
                         cancelTitle:String? = AlertBtnTxt.cancel.localize(),
                         inputPlaceholder:String? = nil,
                         inputKeyboardType:UIKeyboardType = UIKeyboardType.default,
                         cancelHandler: ((UIAlertAction) -> Swift.Void)? = nil,
                         actionHandler: ((_ text: String?) -> Void)? = nil) {

        let alert = UIAlertController(title: title, message: subtitle, preferredStyle: .alert)
        alert.addTextField { (textField:UITextField) in
            textField.placeholder = inputPlaceholder
            textField.keyboardType = inputKeyboardType
        }
        
        alert.addAction(UIAlertAction(title: actionTitle, style: .default, handler: { (action:UIAlertAction) in
                   guard let textField =  alert.textFields?.first else {
                       actionHandler?(nil)
                       return
                   }
                   actionHandler?(textField.text)
               }))
        
        alert.addAction(UIAlertAction(title: cancelTitle, style: .destructive, handler: cancelHandler))
        
       
        self.present(alert, animated: true, completion: nil)
    } // usage
    /* showInputDialog(title: "Add A Meal",
                          subtitle: "Please enter the meal below.",
                          actionTitle: "DONE",
                          cancelTitle: "CLOSE",
                          inputPlaceholder: "Your Meal Name",
                          inputKeyboardType: .default)
          { (input:String?) in
              print("The new meal is \(input ?? "")")
          } */
    
    
    
    // MARK: Hide keyboard
       func hideKeyboardWhenTappedAround() {
           let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(UIViewController.dismissKeyboard))
           tap.cancelsTouchesInView = false
           view.addGestureRecognizer(tap)
       }
       @objc func dismissKeyboard() {
           view.endEditing(true)
       } // uasge  hideKeyboardWhenTappedAround()
    
    
    func getFormattedDate(strDate: String , currentFomat:String, expectedFromat: String) -> String{
        let dateFormatterGet = DateFormatter()
        dateFormatterGet.dateFormat = currentFomat

        let date : Date = dateFormatterGet.date(from: strDate)!

        dateFormatterGet.dateFormat = expectedFromat
        return dateFormatterGet.string(from: date)
    }// usage self.getFormattedDate(strDate: (self.datasource.array[index] as? String)!, currentFomat: "EEE MM/dd/yyyy", expectedFromat: "dd MMM\nEEEE")
    
    
    func addAttributesToTextForVC(label:UILabel,boldTxt:String,regTxt:String,fontSize:CGFloat,firstFontWeight:UIFont.Weight,secFontWeight:UIFont.Weight) -> Void {
        let test1Attributes:[NSAttributedString.Key: Any] = [.font : UIFont.systemFont(ofSize: fontSize, weight: firstFontWeight)]
        let test2Attributes:[NSAttributedString.Key: Any] = [.font : UIFont.systemFont(ofSize: fontSize, weight: secFontWeight)]
        let test1 = NSAttributedString(string: boldTxt, attributes:test1Attributes)
        let test2 = NSAttributedString(string: regTxt, attributes:test2Attributes)
        let text = NSMutableAttributedString()
        text.append(test1)
        text.append(test2)
        label.attributedText = text
    }
    
    func attributingWithColorForVC(label:UILabel,boldTxt:String,regTxt:String,color:UIColor,fontSize:CGFloat,firstFontWeight:UIFont.Weight,secFontWeight:UIFont.Weight) -> Void {
        var test1Attributes:[NSAttributedString.Key: Any] = [.font : UIFont.systemFont(ofSize: fontSize, weight: firstFontWeight)]
        test1Attributes[.foregroundColor] = color
        
        let test2Attributes:[NSAttributedString.Key: Any] = [.font : UIFont.systemFont(ofSize: fontSize, weight: secFontWeight)]
        let test1 = NSAttributedString(string: boldTxt, attributes:test1Attributes)
        let test2 = NSAttributedString(string: regTxt, attributes:test2Attributes)
        let text = NSMutableAttributedString()
        text.append(test1)
        text.append(test2)
        label.attributedText = text
    }
    
    func attributingWithColorForVC2(label:UILabel,boldTxt:String,regTxt:String,color:UIColor,fontSize:CGFloat,firstFontWeight:UIFont.Weight,secFontWeight:UIFont.Weight) -> Void {
        let test1Attributes:[NSAttributedString.Key: Any] = [.font : UIFont.systemFont(ofSize: fontSize, weight: firstFontWeight)]
        
        var test2Attributes:[NSAttributedString.Key: Any] = [.font : UIFont.systemFont(ofSize: fontSize, weight: secFontWeight)]
        test2Attributes[.foregroundColor] = color

        let test1 = NSAttributedString(string: boldTxt, attributes:test1Attributes)
        let test2 = NSAttributedString(string: regTxt, attributes:test2Attributes)
        let text = NSMutableAttributedString()
        text.append(test1)
        text.append(test2)
        label.attributedText = text
    }
    
    func presentAlertWithImageAndMessageForSubscription(msg:String , img:UIImage) -> Void {
        let imageView = UIImageView(frame: CGRect(x: 60, y: 120, width: 150, height: 150))
        imageView.image = img
      
        let message = msg
        let showAlert = UIAlertController(title: nil , message: message, preferredStyle: .alert)
        showAlert.view.addSubview(imageView)
        let height = NSLayoutConstraint(item: showAlert.view, attribute: .height, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1, constant: 350)
        let width = NSLayoutConstraint(item: showAlert.view, attribute: .width, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1, constant: 250)
        showAlert.view.addConstraint(height)
        showAlert.view.addConstraint(width)
        showAlert.addAction(UIAlertAction(title: AlertBtnTxt.okay.localize(), style: .default, handler: { action in
            NavigationHandler.pushTo(.subscriptionVC)
        }))
        self.present(showAlert, animated: true, completion: nil)
    }
    
    func attributingWithColorWithFontSizeForVC(label:UILabel,boldTxt:String,regTxt:String,color:UIColor , fontSize : CGFloat) -> Void {
        var test1Attributes:[NSAttributedString.Key: Any] = [.font : UIFont.systemFont(ofSize: fontSize, weight: .semibold)]
        test1Attributes[.foregroundColor] = color

        let test2Attributes:[NSAttributedString.Key: Any] = [.font : UIFont.systemFont(ofSize: fontSize, weight: .regular)]
        let test1 = NSAttributedString(string: boldTxt, attributes:test1Attributes)
        let test2 = NSAttributedString(string: regTxt, attributes:test2Attributes)
        let text = NSMutableAttributedString()
        text.append(test1)
        text.append(test2)
        label.attributedText = text
    }
    
}


extension UITableViewCell{
    // MARK: Alert with textfiled

    func showInputDialog(title:String? = nil,
                         subtitle:String? = nil,
                         actionTitle:String? = "Add",
                         cancelTitle:String? = AlertBtnTxt.cancel.localize(),
                         inputPlaceholder:String? = nil,
                         inputKeyboardType:UIKeyboardType = UIKeyboardType.default,
                         cancelHandler: ((UIAlertAction) -> Swift.Void)? = nil,
                         actionHandler: ((_ text: String?) -> Void)? = nil) {

        let alert = UIAlertController(title: title, message: subtitle, preferredStyle: .alert)
        alert.addTextField { (textField:UITextField) in
            textField.placeholder = inputPlaceholder
            textField.keyboardType = inputKeyboardType
        }
        
        alert.addAction(UIAlertAction(title: actionTitle, style: .default, handler: { (action:UIAlertAction) in
                   guard let textField =  alert.textFields?.first else {
                       actionHandler?(nil)
                       return
                   }
                   actionHandler?(textField.text)
               }))
        
        alert.addAction(UIAlertAction(title: cancelTitle, style: .destructive, handler: cancelHandler))
        
        DispatchQueue.main.async {
            self.getTopMostViewController()?.present(alert, animated: true, completion: nil)
        }
    } // usage
    /* showInputDialog(title: "Add A Meal",
                          subtitle: "Please enter the meal below.",
                          actionTitle: "DONE",
                          cancelTitle: "CLOSE",
                          inputPlaceholder: "Your Meal Name",
                          inputKeyboardType: .default)
          { (input:String?) in
              print("The new meal is \(input ?? "")")
          } */
    func getTopMostViewController() -> UIViewController? {
        var topMostViewController = UIApplication.shared.keyWindow?.rootViewController

        while let presentedViewController = topMostViewController?.presentedViewController {
            topMostViewController = presentedViewController
        }

        return topMostViewController
    }
    
    
    func getFormattedDateForCell(strDate: String , currentFomat:String, expectedFromat: String) -> String{
        let dateFormatterGet = DateFormatter()
        dateFormatterGet.dateFormat = currentFomat

        let date : Date = dateFormatterGet.date(from: /strDate) ?? Date()

        dateFormatterGet.dateFormat = expectedFromat
        return dateFormatterGet.string(from: date)
    }// usage self.getFormattedDate(strDate: (self.datasource.array[index] as? String)!, currentFomat: "EEE MM/dd/yyyy", expectedFromat: "dd MMM\nEEEE")
    
    func addAttributesToText(label:UILabel,boldTxt:String,regTxt:String) -> Void {
        let test1Attributes:[NSAttributedString.Key: Any] = [.font : UIFont.systemFont(ofSize: 15, weight: .semibold)]
        let test2Attributes:[NSAttributedString.Key: Any] = [.font : UIFont.systemFont(ofSize: 15, weight: .regular)]
        let test1 = NSAttributedString(string: boldTxt, attributes:test1Attributes)
        let test2 = NSAttributedString(string: regTxt, attributes:test2Attributes)
        let text = NSMutableAttributedString()
        text.append(test1)
        text.append(test2)
        label.attributedText = text
    }
    
    func attributingWithColor(label:UILabel,boldTxt:String,regTxt:String,color:UIColor) -> Void {
        var test1Attributes:[NSAttributedString.Key: Any] = [.font : UIFont.systemFont(ofSize: 14, weight: .semibold)]
        test1Attributes[.foregroundColor] = color

        let test2Attributes:[NSAttributedString.Key: Any] = [.font : UIFont.systemFont(ofSize: 14, weight: .regular)]
        let test1 = NSAttributedString(string: boldTxt, attributes:test1Attributes)
        let test2 = NSAttributedString(string: regTxt, attributes:test2Attributes)
        let text = NSMutableAttributedString()
        text.append(test1)
        text.append(test2)
        label.attributedText = text
    }
    
    func attributingWithColorWithFontSize(label:UILabel,boldTxt:String,regTxt:String,color:UIColor , fontSize : CGFloat) -> Void {
        var test1Attributes:[NSAttributedString.Key: Any] = [.font : UIFont.systemFont(ofSize: fontSize, weight: .semibold)]
        test1Attributes[.foregroundColor] = color

        let test2Attributes:[NSAttributedString.Key: Any] = [.font : UIFont.systemFont(ofSize: fontSize, weight: .regular)]
        let test1 = NSAttributedString(string: boldTxt, attributes:test1Attributes)
        let test2 = NSAttributedString(string: regTxt, attributes:test2Attributes)
        let text = NSMutableAttributedString()
        text.append(test1)
        text.append(test2)
        label.attributedText = text
    }
    
    
    
}



//MARK:- ======== Common Fuctions ========
extension UIViewController
{
    func popVC(_ animated: Bool = true) {
        self.navigationController?.popViewController(animated: animated)
    }
    
    func pushVC(_ vc: UIViewController, _ animated: Bool = true) {
        self.navigationController?.pushViewController(vc, animated: animated)
    }
    
    func present(_ vc: UIViewController, _ animated: Bool = true) {
        self.present(vc, animated: animated, completion: nil)
    }
}

extension UIViewController {
    
    func ShowBottomSnackBarAlert(text:String) {
        
        let snackbar = TTGSnackbar(message: text, duration: .middle)
        snackbar.backgroundColor = UIColor.themeGreen
        snackbar.messageTextColor =  UIColor.white
       // snackbar.messageTextFont = /UIFont(name: Fonts.NunitoSans.Bold, size: 14.0)
        snackbar.leftMargin = 0
        snackbar.rightMargin = 0
        snackbar.bottomMargin = 0
       // snackbar.cornerRadius = 0
        snackbar.show()
    }
    
    func setSpacingButtonTextColor( _ button:UIButton , color:UIColor , spacing: CGFloat,font: UIFont ) {
        if let str = button.titleLabel?.attributedText {
            let attributedString = NSMutableAttributedString( attributedString: str  )
           // attributedString.removeAttribute(.foregroundColor, range: NSRange.init(location: 0, length: attributedString.length))
            attributedString.addAttributes(
                [.foregroundColor : color,
                 .kern : spacing,
                 .font:font
                ],
                range: NSRange.init(location: 0, length: attributedString.length)
            )
            button.setAttributedTitle(attributedString, for: .normal)
        }
    }
}


