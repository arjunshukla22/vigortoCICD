//
//  FaqViewController.swift
//  SmileIndia
//
//  Created by Sakshi Gothi on 17/06/21.
//  Copyright © 2021 Na. All rights reserved.
//

import Foundation
import UIKit
import Localize

class faqTVC : UITableViewCell {
    
    @IBOutlet weak var cellVw: UIView!
    @IBOutlet weak var LblQue: UILabel!
    @IBOutlet weak var LblAns: UILabel!
    
}


class FaqViewController: UIViewController {
    
    @IBOutlet weak var patientsBtn: UIButton!
    @IBOutlet weak var doctorBtn: UIButton!
    @IBOutlet weak var faqTabelView: UITableView!
    @IBOutlet weak var TitleLabel: UILabel!
    var SelectedType = "P"
    var DqusArray = [FaqScreenTxt.DqusArray.DQ1.localize(),FaqScreenTxt.DqusArray.DQ2.localize(),FaqScreenTxt.DqusArray.DQ3.localize(),FaqScreenTxt.DqusArray.DQ4.localize(),FaqScreenTxt.DqusArray.DQ5.localize(),FaqScreenTxt.DqusArray.DQ6.localize(),FaqScreenTxt.DqusArray.DQ7.localize(),FaqScreenTxt.DqusArray.DQ8.localize(),FaqScreenTxt.DqusArray.DQ9.localize(),FaqScreenTxt.DqusArray.DQ10.localize(),FaqScreenTxt.DqusArray.DQ11.localize()]
    
    var DansArray = [FaqScreenTxt.DansArray.DA1.localize(),FaqScreenTxt.DansArray.DA2.localize(),FaqScreenTxt.DansArray.DA3.localize(),FaqScreenTxt.DansArray.DA4.localize(),FaqScreenTxt.DansArray.DA5.localize(),FaqScreenTxt.DansArray.DA6.localize(),FaqScreenTxt.DansArray.DA7.localize(),FaqScreenTxt.DansArray.DA8.localize(),FaqScreenTxt.DansArray.DA9.localize(),FaqScreenTxt.DansArray.DA10.localize(),FaqScreenTxt.DansArray.DA11.localize()]
    
    var PqusArray = [FaqScreenTxt.PqusArray.PQ1.localize(),FaqScreenTxt.PqusArray.PQ2.localize(),FaqScreenTxt.PqusArray.PQ3.localize(),FaqScreenTxt.PqusArray.PQ4.localize(),FaqScreenTxt.PqusArray.PQ5.localize(),FaqScreenTxt.PqusArray.PQ6.localize(),FaqScreenTxt.PqusArray.PQ7.localize(),FaqScreenTxt.PqusArray.PQ8.localize(),FaqScreenTxt.PqusArray.PQ9.localize(),FaqScreenTxt.PqusArray.PQ10.localize(),FaqScreenTxt.PqusArray.PQ11.localize(),FaqScreenTxt.PqusArray.PQ12.localize(),FaqScreenTxt.PqusArray.PQ13.localize()]
    var PansArray = [FaqScreenTxt.PansArray.PA1.localize(),
                     FaqScreenTxt.PansArray.PA2.localize(),FaqScreenTxt.PansArray.PA3.localize(),FaqScreenTxt.PansArray.PA4.localize(),FaqScreenTxt.PansArray.PA5.localize(),FaqScreenTxt.PansArray.PA6.localize(),FaqScreenTxt.PansArray.PA7.localize(),FaqScreenTxt.PansArray.PA8.localize(),FaqScreenTxt.PansArray.PA9.localize(),FaqScreenTxt.PansArray.PA10.localize(),FaqScreenTxt.PansArray.PA11.localize(),FaqScreenTxt.PansArray.PA12.localize(),FaqScreenTxt.PansArray.PA13.localize()
    ]
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setStatusBar(color: .themeGreen)
        hideKeyboardWhenTappedAround()
        patientsBtn.backgroundColor = #colorLiteral(red: 0, green: 0.5764004588, blue: 0.4659079909, alpha: 1)
        doctorBtn.backgroundColor = .themeGreen
        TitleLabel.text = FaqScreenTxt.FAQStrings.PatientLbl.localize()
        }
        
    @IBAction func didtapBack(_ sender: Any) {
        NavigationHandler.pop()
    }
    @IBAction func didTapPatient(_ sender: Any) {
        SelectedType = "P"
        TitleLabel.text = FaqScreenTxt.FAQStrings.PatientLbl.localize()
        patientsBtn.backgroundColor = #colorLiteral(red: 0, green: 0.5327345729, blue: 0.4305962324, alpha: 1)
        doctorBtn.backgroundColor = .themeGreen
        faqTabelView.reloadData()
    }
    
    @IBAction func didTAPDoctor(_ sender: Any) {
        SelectedType = "D"
        TitleLabel.text = FaqScreenTxt.FAQStrings.docLbl.localize()
        doctorBtn.backgroundColor = #colorLiteral(red: 0, green: 0.5764004588, blue: 0.4659079909, alpha: 1)
        patientsBtn.backgroundColor = .themeGreen
        
        faqTabelView.reloadData()
    }
    override func viewWillAppear(_ animated: Bool) {
       
    }
    
}

extension FaqViewController : UITableViewDelegate,UITableViewDataSource{
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if SelectedType == "P"{
            return PqusArray.count
        }
        else{
            return DqusArray.count
        }
    }
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "faqTVC", for: indexPath as IndexPath) as! faqTVC
        if SelectedType == "P"{
            
        
        cell.LblQue.text = PqusArray[indexPath.row]
        
        let AnsStr = PansArray[indexPath.row]
            let font = UIFont.systemFont(ofSize: 72)
            let firstAttributes: [NSAttributedString.Key: Any] = [.foregroundColor: #colorLiteral(red: 0, green: 0.5764004588, blue: 0.4659079909, alpha: 1),.font : UIFont.boldSystemFont(ofSize: 16), NSAttributedString.Key.kern: 0]
        let secondAttributes = [NSAttributedString.Key.foregroundColor: UIColor.black]
            let firstString = NSMutableAttributedString(string: FaqScreenTxt.FAQStrings.string1.localize(), attributes: firstAttributes)
       
        let thirdSrting = NSMutableAttributedString(string: FaqScreenTxt.FAQStrings.string2.localize(), attributes: firstAttributes)
        let secondString = NSAttributedString(string: AnsStr, attributes: secondAttributes)
        let fourthString = NSMutableAttributedString(string: FaqScreenTxt.FAQStrings.string3.localize(), attributes: secondAttributes)
            
            if indexPath.row == 5{
                firstString.append(secondString)
                
                
                cell.LblAns.attributedText = firstString
            }
         else if indexPath.row == 11{
               
            firstString.append(secondString)
            firstString.append(thirdSrting)
            firstString.append(fourthString)
                cell.LblAns.attributedText = firstString
            }
            else{
                firstString.append(secondString)
                
            cell.LblAns.attributedText = firstString
            }
            
        }
        else{
            
        
        cell.LblQue.text = DqusArray[indexPath.row]
        
        let AnsStr = DansArray[indexPath.row]
            let firstAttributes: [NSAttributedString.Key: Any] = [.foregroundColor: #colorLiteral(red: 0, green: 0.5764004588, blue: 0.4659079909, alpha: 1),.font : UIFont.boldSystemFont(ofSize: 16), NSAttributedString.Key.kern: 0]
        let secondAttributes = [NSAttributedString.Key.foregroundColor: UIColor.black]
        let thirdAttributes = [NSAttributedString.Key.foregroundColor: UIColor.black,.font : UIFont.boldSystemFont(ofSize: 14)]
        
        let firstString = NSMutableAttributedString(string: FaqScreenTxt.FAQStrings.string1.localize(), attributes: firstAttributes)
        let secondString = NSAttributedString(string: AnsStr, attributes: secondAttributes)
        let thirdSrting = NSMutableAttributedString(string: FaqScreenTxt.FAQStrings.string4.localize(), attributes: firstAttributes)
        let fourthSrting = NSMutableAttributedString(string: FaqScreenTxt.FAQStrings.string5.localize(), attributes: firstAttributes)
        let fifthString = NSMutableAttributedString(string: FaqScreenTxt.FAQStrings.string6.localize(), attributes: thirdAttributes)
        let sixthString = NSMutableAttributedString(string: FaqScreenTxt.FAQStrings.string7.localize(), attributes: thirdAttributes)
            if indexPath.row == 0 {
                firstString.append(secondString)
                firstString.append(fifthString)
                cell.LblAns.attributedText = firstString
            }
           else if indexPath.row == 1 {
                firstString.append(secondString)
                firstString.append(sixthString)
                cell.LblAns.attributedText = firstString
            }
            else if indexPath.row == 5 {
                firstString.append(secondString)
                firstString.append(thirdSrting)
                cell.LblAns.attributedText = firstString
            }
           else if indexPath.row == 8{
                firstString.append(secondString)
                firstString.append(fourthSrting)
                cell.LblAns.attributedText = firstString
            }
            else{
                firstString.append(secondString)
                cell.LblAns.attributedText = firstString
            }
      
        }
        return cell
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if SelectedType == "P"{
           if indexPath.row == 11 {
                let termsVc = TermsVC.init(nibName: "TermsVC", bundle: nil)
                termsVc.modalPresentationStyle = .fullScreen
                termsVc.screentitle = "Terms & Conditions"
                termsVc.requestURLString = "https://www.vigorto.com/terms-and-conditions.pdf"
                
                self.present(termsVc, animated: true, completion: nil)
            }
            
    }
        else{
            if indexPath.row == 8  || indexPath.row == 5  {
                let termsVc = TermsVC.init(nibName: "TermsVC", bundle: nil)
                termsVc.modalPresentationStyle = .fullScreen
                termsVc.screentitle = "Terms & Conditions"
                termsVc.requestURLString = "https://www.vigorto.com/terms-and-conditions.pdf"
                
                self.present(termsVc, animated: true, completion: nil)
            }
        }
        

}
}




