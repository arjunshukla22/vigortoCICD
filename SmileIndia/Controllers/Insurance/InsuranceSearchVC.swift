//
//  InsuranceSearchVC.swift
//  SmileIndia
//
//  Created by Arjun  on 02/12/20.
//  Copyright © 2020 Na. All rights reserved.
//

import UIKit

protocol InsuranceSearchVCDelegate{
    func selectedInsurance(planName:String ,planID : Int ,providerID : Int , isAccepted :Bool)
}
class InsuranceSearchVC: UIViewController, UITableViewDelegate, UITableViewDataSource   {
    
    
    @IBOutlet weak var tableInsurance: UITableView!
    @IBOutlet weak var searchTF: UITextField!
    
    let kHeaderSectionTag: Int = 6900;
    var hiddenSections = Set<Int>()
    var insuranceList = [InsuranceList]()
    
    
    var searching:Bool = false
    var searchedList = [InsuranceList]()
    var searchTxt = ""
    
    var expandedSectionHeaderNumber: Int = -1
    var expandedSectionHeader: UITableViewHeaderFooterView!
    
    var timer: Timer?
    var totalTime = 0
    
    var arraySelected = [SelectedInsurances]()
    
    var delegate : InsuranceSearchVCDelegate?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        self.tableInsurance!.tableFooterView = UIView()
        searchTF.delegate = self
        
    }
    
    
    @IBAction func didtapDone(_ sender: Any) {
        self.searchTF.resignFirstResponder()
    }
    
    @IBAction func didtapClose(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    
    // MARK: - Tableview Methods
    
    func numberOfSections(in tableView: UITableView) -> Int {
        if insuranceList.count > 0 {
            tableView.backgroundView = nil
            if searching == false{
                return insuranceList.count
            }else{
                return searchedList.count
            }
        } else {
            let messageLabel = UILabel(frame: CGRect(x: 0, y: 0, width: view.bounds.size.width, height: view.bounds.size.height))
            messageLabel.text = "\n\n\n\(InsurenceScreenTxt.retrievingData.localize())\n \(InsurenceScreenTxt.pleaseWait.localize())"
            messageLabel.numberOfLines = 0;
            messageLabel.textAlignment = .center;
            messageLabel.font = UIFont(name: "HelveticaNeue", size: 20.0)!
            messageLabel.sizeToFit()
            self.tableInsurance.backgroundView = messageLabel;
        }
        return 0
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        if self.hiddenSections.contains(section) {
            return 0
        }
        
        if searching == false{
            let insurancesPlansList = self.insuranceList[section].InsurancesPlansList ?? []
            return insurancesPlansList.count
        }else{
            let insurancesPlansList = self.searchedList[section].InsurancesPlansList ?? []
            return insurancesPlansList.count
        }
        
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        
        if searching == false{
            if (self.insuranceList.count != 0) {
                return self.insuranceList[section].InsuranceProvider ?? ""
            }
            return ""
        }else{
            if (self.searchedList.count != 0) {
                return self.searchedList[section].InsuranceProvider ?? ""
            }
            return ""
        }
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 50.0;
    }
    
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat{
        return 0;
    }
    
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        let cornerRadius: CGFloat = 2.0
        cell.backgroundColor = UIColor.clear
        let layer: CAShapeLayer = CAShapeLayer()
        let pathRef: CGMutablePath = CGMutablePath()
        //dx leading an trailing margins
        let bounds: CGRect = cell.bounds.insetBy(dx: 10, dy: 0)
        var addLine: Bool = false
        
        if indexPath.row == 0 && indexPath.row == tableView.numberOfRows(inSection: indexPath.section) - 1 {
            pathRef.__addRoundedRect(transform: nil, rect: bounds, cornerWidth: cornerRadius, cornerHeight: cornerRadius)
        } else if indexPath.row == 0 {
            pathRef.move(to: CGPoint(x: bounds.minX, y: bounds.maxY))
            pathRef.addArc(tangent1End: CGPoint(x: bounds.minX, y: bounds.minY),
                           tangent2End: CGPoint(x: bounds.midX, y: bounds.minY),
                           radius: cornerRadius)
            
            pathRef.addArc(tangent1End: CGPoint(x: bounds.maxX, y: bounds.minY),
                           tangent2End: CGPoint(x: bounds.maxX, y: bounds.midY),
                           radius: cornerRadius)
            pathRef.addLine(to: CGPoint(x: bounds.maxX, y: bounds.maxY))
            addLine = true
        } else if indexPath.row == tableView.numberOfRows(inSection: indexPath.section) - 1 {
            pathRef.move(to: CGPoint(x: bounds.minX, y: bounds.minY))
            pathRef.addArc(tangent1End: CGPoint(x: bounds.minX, y: bounds.maxY),
                           tangent2End: CGPoint(x: bounds.midX, y: bounds.maxY),
                           radius: cornerRadius)
            
            pathRef.addArc(tangent1End: CGPoint(x: bounds.maxX, y: bounds.maxY),
                           tangent2End: CGPoint(x: bounds.maxX, y: bounds.midY),
                           radius: cornerRadius)
            pathRef.addLine(to: CGPoint(x: bounds.maxX, y: bounds.minY))
        } else {
            pathRef.move(to: CGPoint(x: bounds.minX, y: bounds.minY))
            pathRef.addArc(tangent1End: CGPoint(x: bounds.minX, y: bounds.maxY),
                           tangent2End: CGPoint(x: bounds.midX, y: bounds.maxY),
                           radius: cornerRadius)
            
            pathRef.move(to: CGPoint(x: bounds.maxX, y: bounds.maxY))
            pathRef.addArc(tangent1End: CGPoint(x: bounds.maxX, y: bounds.maxY),
                           tangent2End: CGPoint(x: bounds.maxX, y: bounds.midY),
                           radius: cornerRadius)
            pathRef.addLine(to: CGPoint(x: bounds.maxX, y: bounds.minY))
            addLine = true
        }
        
        layer.path = pathRef
        layer.strokeColor = UIColor.themeGreen.cgColor
        layer.lineWidth = 1.0
        layer.fillColor = UIColor.clear.cgColor
        
        if addLine == true {
            let lineLayer: CALayer = CALayer()
            let lineHeight: CGFloat = (1 / UIScreen.main.scale)
            lineLayer.frame = CGRect(x: bounds.minX, y: bounds.size.height - lineHeight, width: bounds.size.width, height: lineHeight)
            lineLayer.backgroundColor = UIColor.clear.cgColor
            layer.addSublayer(lineLayer)
        }
        
        let backgroundView: UIView = UIView(frame: bounds)
        backgroundView.layer.insertSublayer(layer, at: 0)
        backgroundView.backgroundColor = .clear
        cell.backgroundView = backgroundView
        
    }
    func tableView(_ tableView: UITableView, willDisplayHeaderView view: UIView, forSection section: Int) {
        //recast your view as a UITableViewHeaderFooterView
        let header: UITableViewHeaderFooterView = view as! UITableViewHeaderFooterView
        header.contentView.backgroundColor = .white
        header.textLabel?.textColor = .black
        header.textLabel?.numberOfLines = 0
        header.textLabel?.lineBreakMode = .byWordWrapping
        
        if let viewWithTag = self.view.viewWithTag(kHeaderSectionTag + section) {
            viewWithTag.removeFromSuperview()
        }
        let headerFrame = self.view.frame.size
        
        let theImageView = UIImageView(frame: CGRect(x: headerFrame.width - 50, y: 13, width: 14, height: 10));
        theImageView.image = UIImage(named: "downArrow")
        
        theImageView.tag = kHeaderSectionTag + section
        header.addSubview(theImageView)
        
        let myView = UIView(frame: CGRect(x: 5, y: 3, width: 4, height: 44))
        myView.backgroundColor = .themeGreen
        header.addSubview(myView)
        
        // make headers touchable
        header.tag = section
        let headerTapGesture = UITapGestureRecognizer()
        headerTapGesture.addTarget(self, action: #selector(InsuranceViewController.sectionHeaderWasTouched(_:)))
        header.addGestureRecognizer(headerTapGesture)
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "tableCell", for: indexPath) as UITableViewCell
        cell.textLabel?.textColor = .none
        cell.textLabel?.numberOfLines = 0
        cell.textLabel?.lineBreakMode = .byWordWrapping
        
        if searching == false{
            let insuranceList = self.insuranceList[indexPath.section]
            cell.textLabel?.text = insuranceList.InsurancesPlansList?[indexPath.row].InsurancePlanName ?? ""
        }else{
            let insuranceList = self.searchedList[indexPath.section]
            cell.textLabel?.text = insuranceList.InsurancesPlansList?[indexPath.row].InsurancePlanName ?? ""
        }
        
        return cell
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if searching == false{
            let insuranceList = self.insuranceList[indexPath.section]
            delegate?.selectedInsurance(planName: insuranceList.InsurancesPlansList?[indexPath.row].InsurancePlanName ?? "", planID: insuranceList.InsurancesPlansList?[indexPath.row].Id ?? 0, providerID: insuranceList.Id ?? 0, isAccepted: insuranceList.InsurancesPlansList?[indexPath.row].IsAccepted ?? false)
            self.dismiss(animated: true, completion: nil)
        }else{
            let insuranceList = self.searchedList[indexPath.section]
            delegate?.selectedInsurance(planName: insuranceList.InsurancesPlansList?[indexPath.row].InsurancePlanName ?? "", planID: insuranceList.InsurancesPlansList?[indexPath.row].Id ?? 0, providerID: insuranceList.Id ?? 0, isAccepted: insuranceList.InsurancesPlansList?[indexPath.row].IsAccepted ?? false)
            self.dismiss(animated: true, completion: nil)
        }
        
    }
    func tableView(_ tableView: UITableView, didDeselectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    // MARK: - Expand / Collapse Methods
    @objc func sectionHeaderWasTouched(_ sender: UITapGestureRecognizer) {
        let headerView = sender.view as! UITableViewHeaderFooterView
        let section    = headerView.tag
        let eImageView = headerView.viewWithTag(kHeaderSectionTag + section) as? UIImageView
        
        hideSection(section: section, imageView: eImageView!)
    }
    
    @objc
    private func hideSection(section: Int, imageView: UIImageView) {
        let section = section
        var rowCount = 0
        func indexPathsForSection() -> [IndexPath] {
            var indexPaths = [IndexPath]()
            if searching == true{
                rowCount = self.searchedList[section].InsurancesPlansList?.count ?? 0
            }else{
                rowCount = self.insuranceList[section].InsurancesPlansList?.count ?? 0
            }
            for row in 0..<(rowCount) {
                indexPaths.append(IndexPath(row: row,
                                            section: section))
            }
            return indexPaths
        }
        
        
        if self.hiddenSections.contains(section) {
            UIView.animate(withDuration: 0.4, animations: {
                //  imageView.transform = CGAffineTransform(rotationAngle: (0.0 * CGFloat(Double.pi)) / 180.0)
            })
            self.hiddenSections.remove(section)
            self.tableInsurance.insertRows(at: indexPathsForSection(),
                                           with: .fade)
        } else {
            UIView.animate(withDuration: 0.4, animations: {
                //   imageView.transform = CGAffineTransform(rotationAngle: (180.0 * CGFloat(Double.pi)) / 180.0)
            })
            self.hiddenSections.insert(section)
            self.tableInsurance.deleteRows(at: indexPathsForSection(),
                                           with: .fade)
        }
    }
    
}

extension InsuranceSearchVC : UITextFieldDelegate {
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
    public func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool{
        //input text
        let searchText  = textField.text! + string
        self.searchTxt = searchText
        
        let userEnteredString = textField.text
        let newString = (userEnteredString! as NSString).replacingCharacters(in: range, with: string) as NSString
        if  newString != ""{
            searchedList = insuranceList.filter( { $0.InsuranceProvider?.range(of: searchText,options: .caseInsensitive) != nil})
            if(self.searchedList.count == 0){
                searching = false
            }else{
                searching = true
            }
            
        } else {
            searching = false
        }
        
        tableInsurance.reloadData()
        
        return true
    }
}


