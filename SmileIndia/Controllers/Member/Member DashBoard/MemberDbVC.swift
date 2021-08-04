//
//  MemberDbVC.swift
//  SmileIndia
//
//  Created by Arjun  on 11/03/20.
//  Copyright © 2020 Na. All rights reserved.
//

import UIKit
import Sinch

class MemberDbVC: BaseViewController ,UICollectionViewDataSource,UICollectionViewDelegate , UICollectionViewDelegateFlowLayout {
    
    var client: SINClient!

    
    var rewards: Rewards?

    @IBOutlet weak var rewardsBtn: UIButton!
    @IBOutlet weak var lblDb: UILabel!
    @IBOutlet weak var collectionDb: UICollectionView!
    
    let dblArray = ["My Profile","Find a Doctor","Appointments","Share","e-Appointments","Change Password","Contact Us","About Us","SMILEi Credits","Logout"]

    let colorArray = [#colorLiteral(red: 0.9725490196, green: 0.8666666667, blue: 0.2352941176, alpha: 1),#colorLiteral(red: 0.5058823529, green: 0.7137254902, blue: 1, alpha: 1),#colorLiteral(red: 1, green: 0.4392156863, blue: 0.3921568627, alpha: 1),#colorLiteral(red: 0.3921568627, green: 0.9568627451, blue: 0.8156862745, alpha: 1),#colorLiteral(red: 0.6392156863, green: 0.9215686275, blue: 0.5647058824, alpha: 1),#colorLiteral(red: 0.6784313725, green: 0.7019607843, blue: 0.9960784314, alpha: 1),#colorLiteral(red: 0.8745098039, green: 0.8745098039, blue: 0.8745098039, alpha: 1),#colorLiteral(red: 0.8549019608, green: 0.968627451, blue: 0.6509803922, alpha: 1),#colorLiteral(red: 0.7254901961, green: 0.9568627451, blue: 0.9176470588, alpha: 1),#colorLiteral(red: 0.9921568627, green: 0.6980392157, blue: 0.9333333333, alpha: 1)]
     let imgArray = [ #imageLiteral(resourceName: "userprofile"),#imageLiteral(resourceName: "find-doctor"),#imageLiteral(resourceName: "appointsment"),#imageLiteral(resourceName: "share"),#imageLiteral(resourceName: "e_appointments"),#imageLiteral(resourceName: "changepassword"),#imageLiteral(resourceName: "contact"),#imageLiteral(resourceName: "AboutUs"),#imageLiteral(resourceName: "credit"),#imageLiteral(resourceName: "logout")]
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        setStatusBar(color: #colorLiteral(red: 0.1, green: 0.9, blue: 0.4876, alpha: 1.0))
        getRewards()
        collectionDb.register(UINib(nibName: "DoctoDashBoardCell", bundle: nil), forCellWithReuseIdentifier: "DoctoDashBoardCell")

    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        lblDb.text = "Hi \(Authentication.customerName ?? "") "

    }
    
    //this method is for the size of items
        func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
            let width = collectionView.frame.width/3
         //   let height : CGFloat = 180.0
            return CGSize(width: width, height: width + 30)
        }
        //these methods are to configure the spacing between items

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
               
         return dblArray.count
               
           }

            
            
      func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
           let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "DoctoDashBoardCell", for: indexPath) as! DoctoDashBoardCell
        cell.viewDb.backgroundColor = colorArray[indexPath.item]
        cell.lblDb.text = dblArray[indexPath.item]
         cell.imgDb.image = imgArray[indexPath.item]
           return cell;
               
       }
      
      func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
          if indexPath.item == 0 {
               NavigationHandler.pushTo(.memberProfile)
           }else if indexPath.item == 1{
            NavigationHandler.pop()
           }else if indexPath.item == 2{
            NavigationHandler.pushTo(.appointmentList("0"))
           }else if indexPath.item == 3{
            NavigationHandler.pushTo(.referralVC)
           }else if indexPath.item == 4{
            NavigationHandler.pushTo(.eAppointmentsList)
           }else if indexPath.item == 5{
            NavigationHandler.pushTo(.memberChangePassword)
             // NavigationHandler.pushTo(.paymentViewController)
             //  AlertManager.showAlert(type: .custom("Functionality under development!"))
          }else if indexPath.item == 6{
            NavigationHandler.pushTo(.contactUs)
          }else if indexPath.item == 7{
            NavigationHandler.pushTo(.aboutus)
          }else if indexPath.item == 8{
               AlertManager.showAlert(type: .custom("You have earned  \(rewards?.Earnedpoints ?? 0) Reward Points"))
            //  NavigationHandler.pushTo(.contactUs)
          }else{
               AlertManager.showAlert(type: .custom(HomeScreenTxt.HomeAlerts.LogoutAlert.localize()), actionTitle: AlertBtnTxt.okay.localize()) {
                   Authentication.clearData()
                   NavigationHandler.logOut()
                   self.logOutSinchUser()
               }
           }
      }
 
 @IBAction func didTapRewards(_ sender: UIButton) {
     AlertManager.showAlert(type: .custom("You have earned  \(rewards?.Earnedpoints ?? 0) Reward Points"))
 }
    
    @IBAction func didTapBack(_ sender: UIButton) {
        NavigationHandler.pop()
    }
    

   func setUI() {
       rewardsBtn.setTitle("  \(rewards?.Earnedpoints ?? 0) Points", for: .normal)
   }
   
   func getRewards(){
    self.view.activityStartAnimating(activityColor: .themeGreen, backgroundColor: UIColor.white)

       WebService.getrewardsData(queryItems: ["LoginKey": Authentication.token ?? "YXNob2ttaXR0YWxAZ21haWwuY29tOjEyMzQ1Ng=="]) { (result) in
           DispatchQueue.main.async {
               switch result {
               case .success(let response):
                   if let user = response.object {
                       self.rewards = user
                      self.setUI()
                   } else {
                   }
               case .failure(let error):
                   print(error.message)
                   self.showError(message: error.message)
               }
            self.view.activityStopAnimating()
           }
       }
   }
    
    func logOutSinchUser() {
        let appDelegate = UIApplication.shared.delegate! as! AppDelegate
        if let client = appDelegate.client {
            client.stopListeningOnActiveConnection()
            client.unregisterPushNotificationDeviceToken()
            client.terminateGracefully()
        }
        appDelegate.client = nil


    }
    
}
