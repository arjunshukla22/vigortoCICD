//
//  InsuranceViewController.swift
//  SmileIndia
//
//  Created by Arjun  on 19/11/20.
//  Copyright © 2020 Na. All rights reserved.
//

import UIKit

class SelectedInsurances {
    var planID: Int
    var providerID: Int
    var isAccepted: Bool

    init(planID: Int, providerID: Int, isAccepted: Bool) {
        self.planID = planID
        self.providerID = providerID
        self.isAccepted = isAccepted
    }
}

class InsuranceViewController: UIViewController , UITableViewDelegate, UITableViewDataSource  {

    let kHeaderSectionTag: Int = 6900;
    var hiddenSections = Set<Int>()
    var insuranceList = [InsuranceList]()

    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var searchTF: UITextField!
    @IBOutlet weak var searchPlan: UITextField!
    @IBOutlet weak var defaulterLabel: UILabel!
    
    
    var searching:Bool = false
    var searchedList = [InsuranceList]()
    var searchTxt = ""
    var expandedSectionHeaderNumber: Int = -1
    var expandedSectionHeader: UITableViewHeaderFooterView!
    
    var timer: Timer?
    var totalTime = 0
    
    var arraySelected = [SelectedInsurances]()


    override func viewDidLoad() {
        super.viewDidLoad()
        setStatusBar(color: .themeGreen)

        self.tableView!.tableFooterView = UIView()
        
        self.getinsurancesProvidersList()
        
        searchTF.delegate = self
        self.defaulterLabel.text = ""

    }
    
    override func viewWillAppear(_ animated: Bool){
        super.viewWillAppear(animated)
        if Authentication.customerType == EnumUserType.Doctor {
            self.customerInfo()
        }
    }

    func customerInfo(){
        let queryItems = ["Email": Authentication.customerEmail ?? ""] as [String: Any]
        WebService.customerInfo(queryItems: queryItems) { (result) in
            DispatchQueue.main.async {
                switch result {
                case .success(let response):
                    if response.object?.IsDefaulter ?? false{
                        self.defaulterLabel.text = ProfileUpdate.Alert.defaulter.localize()
                        AlertManager.showAlert(type: .custom(ProfileUpdate.Alert.defaulter.localize()))
                    }else{
                        self.defaulterLabel.text = ""
                    }
                case .failure(let error):
                    AlertManager.showAlert(type: .custom(error.message))
                }
            }
        }
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func didtapSearch(_ sender: Any) {
        self.searchTF.resignFirstResponder()
    }
    
    
    @IBAction func didtapInfo(_ sender: Any) {
        AlertManager.showAlert(type: .custom(InsurenceScreenTxt.QueriesContactVigorto.localize())){
                NavigationHandler.pushTo(.contactUs)
        }
    }
    
    func getinsurancesProvidersList(){
        let queryItems = ["LoginKey":Authentication.token ?? ""]
             self.view.activityStartAnimating(activityColor: .themeGreen, backgroundColor: UIColor.white)
             WebService.insurancesProvidersList(queryItems: queryItems) { (result) in
                 DispatchQueue.main.async {
                     switch result {
                     case .success(let response):
                        if self.searching == false{
                            self.insuranceList = response.objects ?? []
                            self.tableView.reloadData()
                        }else{
                            self.insuranceList = response.objects ?? []
                            self.searchedList = self.insuranceList.filter( { $0.InsuranceProvider?.range(of: self.searchTxt,options: .caseInsensitive) != nil})
                            self.tableView.reloadData()
                        }

                     case .failure(let error):
                         AlertManager.showAlert(type: .custom(error.message))
                     }
                    self.view.activityStopAnimating()
                 }
             }
         }
    
    @IBAction func didtapBack(_ sender: Any) {
        NavigationHandler.pop()
//        AlertManager.showAlert(type: .custom("Selected Insurance's are added succesfully.")){
//                NavigationHandler.pop()
//        }
    }
    
    @IBAction func didtapPreview(_ sender: Any) {
        AlertManager.showAlert(type: .custom(InsurenceScreenTxt.InsAddedSucessfully.localize())){
                NavigationHandler.pop()
        }
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
            self.tableView.backgroundView = messageLabel;
        }
        return 0
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {

        if self.hiddenSections.contains(section) {
            return 0
        }
        
        if searching == false{
            let insurancesPlansList = self.insuranceList[section].InsurancesPlansList ?? []
            if insurancesPlansList.count > 1{
                return insurancesPlansList.count + 1
            }else{
                return insurancesPlansList.count
            }
        }else{
            let insurancesPlansList = self.searchedList[section].InsurancesPlansList ?? []
            if insurancesPlansList.count > 1{
                return insurancesPlansList.count + 1
            }else{
                return insurancesPlansList.count
            }
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
        return 54.0;
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

        
 /*       let myView1 = UIView(frame: CGRect(x: 5, y: header.frame.height+10, width: headerFrame.width-10, height: headerFrame.height-10))
        myView1.layer.masksToBounds = true
        myView1.layer.cornerRadius = 5
        myView1.layer.borderColor = UIColor.themeGreen.cgColor
        myView1.layer.borderWidth = 1.0
        header.addSubview(myView1) */
        
        theImageView.tag = kHeaderSectionTag + section
        header.addSubview(theImageView)
        
        let myView = UIView(frame: CGRect(x: 7, y: 3, width: 4, height: 44))
        myView.backgroundColor = .themeGreen
        header.addSubview(myView)

        // make headers touchable
        header.tag = section
        let headerTapGesture = UITapGestureRecognizer()
        headerTapGesture.addTarget(self, action: #selector(InsuranceViewController.sectionHeaderWasTouched(_:)))
        header.addGestureRecognizer(headerTapGesture)
    }
    
    @objc func buttonTapped(sender : UIButton) {
        //Write button action here
        self.insuranceAddedOrRemove(planID: -1, providerID: self.insuranceList[sender.tag].Id ?? 0, isAccepted: (self.insuranceList[sender.tag].IsSelectAll ?? false))
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "tableCell", for: indexPath) as UITableViewCell
        cell.textLabel?.textColor = .none
        cell.textLabel?.numberOfLines = 0
        cell.textLabel?.lineBreakMode = .byWordWrapping
        
        if searching == false{
            let insuranceList = self.insuranceList[indexPath.section]
            if insuranceList.InsurancesPlansList!.count > 1 {
                if indexPath.row == 0{
                    cell.textLabel?.text = InsurenceScreenTxt.selectAllPlan.localize()
                    if insuranceList.IsSelectAll == true{
                        cell.accessoryType = .checkmark
                    }else{
                        cell.accessoryType = .none
                     }
                }else if indexPath.row > 0{
                    cell.textLabel?.text = insuranceList.InsurancesPlansList?[indexPath.row-1].InsurancePlanName ?? ""
                        if insuranceList.IsSelectAll == true{
                            cell.accessoryType = .checkmark
                        }else{
                            if insuranceList.InsurancesPlansList?[indexPath.row-1].IsAccepted == true{
                                    cell.accessoryType = .checkmark
                                }else{
                                    cell.accessoryType = .none
                                  }
                         }
                }
            }else{
                cell.textLabel?.text = insuranceList.InsurancesPlansList?[indexPath.row].InsurancePlanName ?? ""
                
                    if insuranceList.IsSelectAll == true{
                        cell.accessoryType = .checkmark
                    }else{
                        if insuranceList.InsurancesPlansList?[indexPath.row].IsAccepted == true{
                                cell.accessoryType = .checkmark
                            }else{
                                cell.accessoryType = .none
                            }
                }

            }
        }else{
            let insuranceList = self.searchedList[indexPath.section]
            
            
            if insuranceList.InsurancesPlansList!.count > 1 {
                if indexPath.row == 0{
                    cell.textLabel?.text = InsurenceScreenTxt.selectAllPlan.localize()
                    if insuranceList.IsSelectAll == true{
                        cell.accessoryType = .checkmark
                    }else{
                        if insuranceList.InsurancesPlansList?[indexPath.row].IsAccepted == true{
                                cell.accessoryType = .checkmark
                            }else{
                                cell.accessoryType = .none
                              }
                     }
                }else if indexPath.row > 0{
                    cell.textLabel?.text = insuranceList.InsurancesPlansList?[indexPath.row-1].InsurancePlanName ?? ""
                        if insuranceList.IsSelectAll == true{
                            cell.accessoryType = .checkmark
                        }else{
                            if insuranceList.InsurancesPlansList?[indexPath.row-1].IsAccepted == true{
                                    cell.accessoryType = .checkmark
                                }else{
                                    cell.accessoryType = .none
                                  }
                         }
                }
            }else{
                cell.textLabel?.text = insuranceList.InsurancesPlansList?[indexPath.row].InsurancePlanName ?? ""
                    if insuranceList.IsSelectAll == true{
                        cell.accessoryType = .checkmark
                    }else{
                        if insuranceList.InsurancesPlansList?[indexPath.row].IsAccepted == true{
                                cell.accessoryType = .checkmark
                            }else{
                                cell.accessoryType = .none
                            }
                }

            }
        }

        return cell
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {

        if searching == false{

             let insuranceList = self.insuranceList[indexPath.section]
            if insuranceList.InsurancesPlansList!.count > 1 {
             if indexPath.row == 0{
              //  arraySelected.append(SelectedInsurances(planID: -1, providerID: insuranceList.Id ?? 0, isAccepted: !(insuranceList.IsSelectAll ?? false)))

                 self.insuranceAddedOrRemove(planID: -1, providerID: insuranceList.Id ?? 0, isAccepted: !(insuranceList.IsSelectAll ?? false))
             }else{
              //  arraySelected.append(SelectedInsurances(planID: insuranceList.InsurancesPlansList?[indexPath.row-1].Id ?? 0, providerID: insuranceList.InsurancesPlansList?[indexPath.row-1].InsuranceId ?? 0, isAccepted: !(insuranceList.InsurancesPlansList?[indexPath.row-1].IsAccepted ?? false)))

                 self.insuranceAddedOrRemove(planID: insuranceList.InsurancesPlansList?[indexPath.row-1].Id ?? 0, providerID: insuranceList.InsurancesPlansList?[indexPath.row-1].InsuranceId ?? 0, isAccepted: !(insuranceList.InsurancesPlansList?[indexPath.row-1].IsAccepted ?? false))
             }
            }else{
              //  arraySelected.append(SelectedInsurances(planID: insuranceList.InsurancesPlansList?[indexPath.row].Id ?? 0, providerID: insuranceList.InsurancesPlansList?[indexPath.row].InsuranceId ?? 0, isAccepted: !(insuranceList.InsurancesPlansList?[indexPath.row].IsAccepted ?? false)))

             self.insuranceAddedOrRemove(planID: insuranceList.InsurancesPlansList?[indexPath.row].Id ?? 0, providerID: insuranceList.InsurancesPlansList?[indexPath.row].InsuranceId ?? 0, isAccepted: !(insuranceList.InsurancesPlansList?[indexPath.row].IsAccepted ?? false))
             }
        }else{
             let insuranceList = self.searchedList[indexPath.section]
            if insuranceList.InsurancesPlansList!.count > 1 {
             if indexPath.row == 0{
                 self.insuranceAddedOrRemove(planID: -1, providerID: insuranceList.Id ?? 0, isAccepted: !(insuranceList.IsSelectAll ?? false))
             }else{
                 self.insuranceAddedOrRemove(planID: insuranceList.InsurancesPlansList?[indexPath.row-1].Id ?? 0, providerID: insuranceList.InsurancesPlansList?[indexPath.row-1].InsuranceId ?? 0, isAccepted: !(insuranceList.InsurancesPlansList?[indexPath.row-1].IsAccepted ?? false))
             }
            }else{
             self.insuranceAddedOrRemove(planID: insuranceList.InsurancesPlansList?[indexPath.row].Id ?? 0, providerID: insuranceList.InsurancesPlansList?[indexPath.row].InsuranceId ?? 0, isAccepted: !(insuranceList.InsurancesPlansList?[indexPath.row].IsAccepted ?? false))
             }
        }

    }
    func tableView(_ tableView: UITableView, didDeselectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }
    func insuranceAddedOrRemove(planID:Int,providerID:Int,isAccepted:Bool){

        let parameters = [
        ] as [[String : Any]]

        let boundary = "Boundary-\(UUID().uuidString)"
        var body = ""
        var error: Error? = nil
        for param in parameters {
          if param["disabled"] == nil {
            let paramName = param["key"]!
            body += "--\(boundary)\r\n"
            body += "Content-Disposition:form-data; name=\"\(paramName)\""
            let paramType = param["type"] as! String
            if paramType == "text" {
              let paramValue = param["value"] as! String
              body += "\r\n\r\n\(paramValue)\r\n"
            } else {
              let paramSrc = param["src"] as! String
              let fileData = try! NSData(contentsOfFile:paramSrc, options:[]) as Data
              let fileContent = String(data: fileData, encoding: .utf8)!
              body += "; filename=\"\(paramSrc)\"\r\n"
                + "Content-Type: \"content-type header\"\r\n\r\n\(fileContent)\r\n"
            }
          }
        }
        body += "--\(boundary)--\r\n";
        let postData = body.data(using: .utf8)

        var request = URLRequest(url: URL(string: "\(APIConstants.mainUrl)Api/InsuranceAddedOrRemove?InsurancePlanId=\(planID)&InsuranceProviderId=\(providerID)&IsAccepted=\(isAccepted)&DoctorId=\(Authentication.customerId ?? "0")")!,timeoutInterval: Double.infinity)

        request.addValue("Nop.customer=f17cd61a-3c9e-4b38-be6f-85e119e72d88", forHTTPHeaderField: "Cookie")
        request.addValue("multipart/form-data; boundary=\(boundary)", forHTTPHeaderField: "Content-Type")

        request.httpMethod = "POST"
        request.httpBody = postData

        let task = URLSession.shared.dataTask(with: request) { data, response, error in
          guard let data = data else {
            print(String(describing: error))
            return
          }
          print(String(data: data, encoding: .utf8)!)
            DispatchQueue.main.async {
            self.getinsurancesProvidersList()
            }
        }

        task.resume()
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
            if rowCount > 1{
                for row in 0..<rowCount+1{
                    indexPaths.append(IndexPath(row: row,
                                                section: section))
                }
            }else{
                for row in 0..<(rowCount) {
                    indexPaths.append(IndexPath(row: row,
                                                section: section))
                }
            }

            return indexPaths
        }
        

        if self.hiddenSections.contains(section) {
            UIView.animate(withDuration: 0.4, animations: {
              //  imageView.transform = CGAffineTransform(rotationAngle: (0.0 * CGFloat(Double.pi)) / 180.0)
            })
            self.hiddenSections.remove(section)
            self.tableView.insertRows(at: indexPathsForSection(),
                                      with: .fade)
        } else {
            UIView.animate(withDuration: 0.4, animations: {
             //   imageView.transform = CGAffineTransform(rotationAngle: (180.0 * CGFloat(Double.pi)) / 180.0)
            })

            self.hiddenSections.insert(section)
            self.tableView.deleteRows(at: indexPathsForSection(),
                                      with: .fade)
        }
    }

}

extension InsuranceViewController : UITextFieldDelegate {
    
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

         tableView.reloadData()

         return true
     }
}



/*        let button = UIButton(frame: CGRect(x: headerFrame.width-85, y: 7, width: 80, height: 30))
        button.setTitle("Select All", for: .normal)
        button.backgroundColor = .themeGreen
        button.setTitleColor(UIColor.white, for: .normal)
        button.addTarget(self, action: #selector(self.buttonTapped), for: .touchUpInside)
        button.titleLabel?.font = .boldSystemFont(ofSize: 15)
        button.layer.cornerRadius = 5
        button.layer.borderWidth = 1
        button.layer.borderColor = UIColor.white.cgColor
        button.tag = section
        header.addSubview(button) */
        
