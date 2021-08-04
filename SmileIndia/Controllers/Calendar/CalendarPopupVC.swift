//
//  CalendarPopupVC.swift
//  SmileIndia
//
//  Created by Arjun  on 24/04/20.
//  Copyright © 2020 Na. All rights reserved.
//

import UIKit

protocol CalendarPopupVCDelegate{
    func selectedDate(selected : String)
}


class CalendarPopupVC: UIViewController {
    
    var delegate : CalendarPopupVCDelegate?
    
    var selectedDate = ""

    
    @IBOutlet weak var datepicker: UIDatePicker!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        datepickerSettings()
    }
    
    @IBAction func didtapDismiss(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func didtapOk(_ sender: Any) {
        delegate?.selectedDate(selected: selectedDate)
        self.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func didtapCancel(_ sender: Any) {
        let date = Date()
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd"
        let today = formatter.string(from: date)
        delegate?.selectedDate(selected: today)
        self.dismiss(animated: true, completion: nil)
    }
    
    func datepickerSettings() -> Void {
        
        datepicker.datePickerMode = .date
        let calendar = Calendar(identifier: .gregorian)
        var comps = DateComponents()
        comps.day = 15
        let maxDate = calendar.date(byAdding: comps, to: Date())
        comps.day = 0
        let minDate = calendar.date(byAdding: comps, to: Date())
        datepicker.maximumDate = maxDate
        datepicker.minimumDate = Date()
        datepicker.addTarget(self, action: #selector(datePickerChanged(sender:)), for: .valueChanged)
        
        let date = Date()
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd"
        let today = formatter.string(from: date)
        selectedDate = today
        print(selectedDate)

    }
    
    @objc func datePickerChanged(sender:UIDatePicker) {
      let dateFormatter = DateFormatter()
      dateFormatter.dateFormat = "yyyy-MM-dd"
      let strDate = dateFormatter.string(from: sender.date)
      selectedDate = strDate
      print(selectedDate)
    }
}
