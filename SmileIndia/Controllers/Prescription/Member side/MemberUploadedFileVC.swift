//
//  MemberUploadedFileVC.swift
//  SmileIndia
//
//  Created by Arjun  on 18/05/20.
//  Copyright © 2020 Na. All rights reserved.
//

import UIKit

class MemberUploadedFileVC: UIViewController ,UICollectionViewDataSource,UICollectionViewDelegate , UICollectionViewDelegateFlowLayout{
    var  object: Appointment?
    
    var memberFiles = [MemberFiles]()
    
    
    
    @IBOutlet weak var collectionfiles: UICollectionView!
    

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        setStatusBar(color: .themeGreen)
        getMemberFiles()
        
    }
    
    @IBAction func didtapBack(_ sender: Any) {
        NavigationHandler.pop()
    }
    
    
    func getMemberFiles() -> Void {

        let queryItems = ["Appid": "\(object?.Id ?? 0)", "MemberId":"\(object?.MemberId ?? 0)"]
        self.view.activityStartAnimating(activityColor: .themeGreen, backgroundColor: UIColor.white)
        WebService.getMemberFiles(queryItems: queryItems) { (result) in
         DispatchQueue.main.async {
                switch result {
                case .success (let response):
                    self.memberFiles =  response.objects ?? []
                    self.collectionfiles.reloadData()
                case .failure(let error):
                    AlertManager.showAlert(type: .custom(error.message)) {
                            NavigationHandler.pop()
                    }
              }
            self.view.activityStopAnimating()
            }
        }
    }
    
    //this method is for the size of items
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
            let width = collectionView.frame.width/2
         //   let height : CGFloat = 180.0
            return CGSize(width: width, height: width + 40)
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
        return self.memberFiles.count
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let memberFiles = self.memberFiles[indexPath.item]
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "MemberFilesCell", for: indexPath) as! MemberFilesCell

        cell.img.sd_setImage(with: URL(string: "\(APIConstants.mainUrl)Content/PrescriptionFiles/" + "\(memberFiles.UniqueFileName ?? "")")! , placeholderImage: nil) //UIImage.init(named: "doctor-avtar")

        cell.deleteBtn.tag = indexPath.row
        cell.deleteBtn.addTarget(self, action:  #selector(deleteBtnPressed(sender:)), for: .touchUpInside)
        cell.viewfullBtn.tag = indexPath.row
        cell.viewfullBtn.addTarget(self, action:  #selector(viewfullBtnPressed(sender:)), for: .touchUpInside)
        
        cell.deleteBtn.isHidden = (Authentication.customerType == EnumUserType.Doctor)

        return cell
               
    }
      
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
    }
    
    @objc func deleteBtnPressed(sender: UIButton) {
        AlertManager.showAlert(type: .custom(AppointmentScreenTxt.suretoDeleteFile.localize()), actionTitle: AlertBtnTxt.okay.localize()) {
            let memberFiles = self.memberFiles[sender.tag]
            self.deleteMemberFilebyId(fileId: memberFiles.Id ?? 0)
        }
    }
    func deleteMemberFilebyId(fileId:Int) -> Void {

        let queryItems = ["FileId": fileId]
        self.view.activityStartAnimating(activityColor: .themeGreen, backgroundColor: UIColor.white)
        WebService.deleteMemberFilebyId(queryItems: queryItems) { (result) in
         DispatchQueue.main.async {
                switch result {
                case .success (let response):
                    print(response)
                    self.getMemberFiles()
                case .failure(let error):
                    AlertManager.showAlert(on: self, type: .custom(error.message))
              }
            self.view.activityStopAnimating()
            }
        }
    }
    @objc func viewfullBtnPressed(sender: UIButton) {
        let memberFiles = self.memberFiles[sender.tag]
        print(memberFiles.Id ?? 0)
        NavigationHandler.pushTo(.fullImage(URL(string: "\(APIConstants.mainUrl)Content/PrescriptionFiles/" + "\(memberFiles.UniqueFileName ?? "")")!, AppointmentScreenTxt.memberfile.localize()))

    }
}
