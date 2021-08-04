//
//  UITextFieldExtension.swift
//  HandstandV2
//
//  Created by user on 18/12/18.
//  Copyright © 2018 Navjot Sharma. All rights reserved.
//

import UIKit
private var maxLengths = [UITextField: Int]()
private var allowChars = [UITextField: String]()

extension UITextField {
    
    @discardableResult func addMargins(left: CGFloat, right: CGFloat) -> UITextField {
        
        let leftmarginView = UIView(frame: CGRect(x: 0, y: 0, width: left, height: self.frame.height))
        let rightMarginView = UIView(frame: CGRect(x: 0, y: 0, width: right, height: self.frame.height))
        
        leftView = leftmarginView
        leftViewMode = .always
        rightView = rightMarginView
        rightViewMode = .always
        return self
    }
    @IBInspectable var maxLength: Int
        {
        get
        {
            guard let length = maxLengths[self] else {
                return Int.max
            }
            return length
        }
        set
        {
            maxLengths[self] = newValue
            addTarget(
                self,
                action: #selector(limitLength),
                for: UIControl.Event.editingChanged)
        }
    }
    
    @objc func limitLength(textField: UITextField) {
        guard let prospectiveText = textField.text
            , prospectiveText.count > maxLength else {
                return
        }
        let selection = selectedTextRange
        text = prospectiveText.substring(to: prospectiveText.index(prospectiveText.startIndex, offsetBy: maxLength))
        selectedTextRange = selection
    }
    
    @IBInspectable var AllowedChars: String {
        get {
            return self.AllowedChars
        }
        set
        {
            allowChars[self] = newValue
            addTarget(self, action: #selector(limitChars), for: .editingChanged)
        }
    }
    
    @objc func limitChars()
    {
        let inverseSet = NSCharacterSet(charactersIn:allowChars[self]!).inverted
        let components = self.text?.components(separatedBy: inverseSet)
        let filtered = components?.joined(separator: "")
        self.text = filtered
    }
    
    @IBInspectable var padding :CGFloat {
        
        set {  let paddingView = UIView(frame: CGRect(x: 0, y: 0, width: newValue, height: frame.height))
            leftView = paddingView
            leftViewMode = .always
        }
        get {
            return layer.cornerRadius
        }
    }
    
    @IBInspectable var placeHolderColor: UIColor? {
        get {
            return self.placeHolderColor
        }
        set {
            self.attributedPlaceholder = NSAttributedString(string:placeholder ?? "", attributes:[NSAttributedString.Key.foregroundColor: newValue!])
        }
    }
    
}


