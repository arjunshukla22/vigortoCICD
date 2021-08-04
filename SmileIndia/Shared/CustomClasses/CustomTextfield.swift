//
//  CustomTextfield.swift
//  HandstandV2
//
//  Created by user on 17/01/19.
//  Copyright © 2019 Navjot Sharma. All rights reserved.
//

import Foundation
import UIKit

enum Type: String {
    case custom = "custom"
    case date = "date"
    case time = "time"
}
@IBDesignable class CustomTextfield: UITextField, UIPickerViewDelegate,UIPickerViewDataSource {
   
    var typePicker : Type = .custom
    @IBInspectable var type: String = "custom" {
        didSet {
            typePicker = Type.init(rawValue: type) ?? .custom
            switch typePicker {
            case .custom:
              //  picker.backgroundColor = .white
                self.inputView = picker
                self.inputAccessoryView = toolbar
            case .date:
                datePicker.datePickerMode = .date
                datePicker.maximumDate = Calendar.current.date(byAdding: .year, value: -18, to: Date())
               // datePicker.backgroundColor = .white
                self.inputView = datePicker
                self.inputAccessoryView = toolbar
            case .time:
                datePicker.datePickerMode = .time
               // datePicker.backgroundColor = .white
                self.inputView = datePicker
                self.inputAccessoryView = toolbar
            }
        }
    }

    override init(frame: CGRect) {
        super.init(frame: frame)
        sharedInit()
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        sharedInit()
    }

    override func prepareForInterfaceBuilder() {
        sharedInit()
    }

    func sharedInit() {
    }



    // pickers
    var selectedRow = Int()
    var array = [List](){
        didSet{
            picker.reloadAllComponents()
        }
    }
    lazy var picker : UIPickerView = {
        let picker = UIPickerView()
        picker.delegate = self
        picker.dataSource = self
        return picker
    }()

    let datePicker = UIDatePicker()

    lazy var toolbar: UIToolbar = {
        let toolbar = UIToolbar.init(frame: CGRect.init(x: 0, y: 0, width: UIScreen.main.bounds.width, height: 50))
        toolbar.barStyle = .default
       // toolbar.backgroundColor = UIColor.barBackground
        toolbar.tintColor = UIColor.darkText
        let cancelButton = UIBarButtonItem.init(title: AlertBtnTxt.cancel.localize() , style: .plain, target: self, action: #selector(didTapCancelButton))
        let doneButton = UIBarButtonItem.init(barButtonSystemItem: .done , target: self, action: #selector(didTapDoneButton))
        let spaceButton = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
        toolbar.setItems([cancelButton, spaceButton, doneButton], animated: false)
        toolbar.isUserInteractionEnabled = true
        return toolbar
    }()

    @objc func didTapCancelButton(){
        self.resignFirstResponder()
    }

    @objc func didTapDoneButton(){
        if array.count == 0 && typePicker == .custom {
            self.endEditing(true)
            self.resignFirstResponder()
            return
        }
        
        if array.indices.contains(selectedRow) {
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = typePicker == .date ? "yyyy-MM-dd" : "hh:mm a"
            let strDate = dateFormatter.string(from: datePicker.date)
            self.text = typePicker == .custom ? array[selectedRow].Text : strDate
            dateFormatter.dateFormat = typePicker == .date ? "dd/MM/yyyy" : "hh:mm:ss"
            self.accessibilityLabel = typePicker == .custom ?array[selectedRow].Value ?? "0" : dateFormatter.string(from: datePicker.date)
        }else{
            print("Index Not valid")
            print("Row :- \(selectedRow)---Array Count :- \(array.count)")
        }
        
        
      
        self.endEditing(true)
        self.resignFirstResponder()
    }

    //MARK:- Picker delegates
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }

    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return array.count
    }
    func pickerView(_ pickerView: UIPickerView, viewForRow row: Int, forComponent component: Int, reusing view: UIView?) -> UIView {
        var pickerLabel: UILabel? = (view as? UILabel)
        pickerLabel?.font = .systemFont(ofSize: 011)
        if pickerLabel == nil {
            pickerLabel = UILabel()
          pickerLabel?.font = .systemFont(ofSize: 011)
            pickerLabel?.textAlignment = .center
        }
        pickerLabel?.text = array[row].Text?.replacingOccurrences(of: "\r\n", with: "")
        return pickerLabel!
    }
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return array[row].Text?.replacingOccurrences(of: "\r\n", with: "")
    }

    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        selectedRow = row
    }

}
