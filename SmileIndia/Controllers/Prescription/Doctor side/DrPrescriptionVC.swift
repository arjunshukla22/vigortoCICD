//
//  DrPrescriptionVC.swift
//  SmileIndia
//
//  Created by Arjun  on 29/07/20.
//  Copyright © 2020 Na. All rights reserved.
//

import UIKit
import WebKit


class DrPrescriptionVC: UIViewController , WKUIDelegate, WKNavigationDelegate{

    @IBOutlet weak var viewForWebkit: UIView!
    @IBOutlet weak var collectionFiles: UICollectionView!
    
    var drPrescriptionFiles = [DoctorPrescriptionFiles]()
    var  object: Appointment?
    var requestURLString = ""

    var webView: WKWebView!


    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        setStatusBar(color: #colorLiteral(red: 0.3803921569, green: 0.7333333333, blue: 0.2862745098, alpha: 1))

        
        getDoctorPrescriptionFiles()
        
        let webConfiguration = WKWebViewConfiguration()

        let customFrame = CGRect.init(origin: CGPoint.zero, size: CGSize.init(width: 0.0, height: self.viewForWebkit.frame.size.height))
        self.webView = WKWebView (frame: customFrame , configuration: webConfiguration)
        webView.translatesAutoresizingMaskIntoConstraints = false
        self.viewForWebkit.addSubview(webView)
        webView.topAnchor.constraint(equalTo: viewForWebkit.topAnchor).isActive = true
        webView.rightAnchor.constraint(equalTo: viewForWebkit.rightAnchor).isActive = true
        webView.leftAnchor.constraint(equalTo: viewForWebkit.leftAnchor).isActive = true
        webView.bottomAnchor.constraint(equalTo: viewForWebkit.bottomAnchor).isActive = true
        webView.heightAnchor.constraint(equalTo: viewForWebkit.heightAnchor).isActive = true

        webView.uiDelegate = self
        webView.navigationDelegate = self
        webView.scrollView.bounces = false
        

        webView.loadHTMLString(requestURLString, baseURL:URL (string:"\(APIConstants.mainUrl)"))

    }
    
    func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
    title = webView.title
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
    
    @IBAction func didtapBack(_ sender: Any) {
        NavigationHandler.pop()
    }
    

}


extension DrPrescriptionVC: UICollectionViewDataSource,UICollectionViewDelegate , UICollectionViewDelegateFlowLayout
{
    //this method is for the size of items
     func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
             let width = collectionView.frame.width/2
             let height : CGFloat = 160.0
             return CGSize(width: width, height: height)
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
         cell.btnDelete.isHidden = true
      //   cell.btnFullView.isHidden = (Authentication.customerType == "Doctor")

         return cell
                
     }
       
     func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
         
     }
     
     @objc func deleteBtnPressed(sender: UIButton) {
        self.deleteMemberFilebyId(fileId: drPrescriptionFiles[sender.tag].Id ?? 0)
        self.collectionFiles.reloadData()
     }

     @objc func viewfullBtnPressed(sender: UIButton) {
        NavigationHandler.pushTo(.fullImage(URL(string: drPrescriptionFiles[sender.tag].FilePath ?? "")!, "Doctor Prescription Image"))
     }
    
}
