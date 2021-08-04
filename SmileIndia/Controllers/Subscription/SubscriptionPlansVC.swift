//
//  SubscriptionPlansVC.swift
//  SmileIndia
//
//  Created by Arjun  on 29/06/20.
//  Copyright © 2020 Na. All rights reserved.
//

import UIKit
import Localize

class SubscriptionPlansVC: BaseViewController {
    var duration = ""
    @IBOutlet weak var pageControl: UIPageControl!
    @IBOutlet weak var collectionPlans: UICollectionView!
    
    var subscriptionPlans = [SubscriptionPlans]()
    
    
    @IBOutlet weak var btnMonth: UIButton!
    @IBOutlet weak var btnAnual: UIButton!
    
    @IBOutlet weak var hippaImage: UIImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        setStatusBar(color: .themeGreen)
        if /Authentication.profileComplete == false{
            AlertManager.showAlert(type: .custom("Please purchase the Subscription Plan to Use Vigorto Services!."))
        }
        getSubscriptionPlans(duration: "4")
        self.duration = "Quarterly"
        pageControl.hidesForSinglePage = true
        
        
    }
    func moveHippaBanner(){
        
        self.hippaImage.transform = .identity
        UIView.animate(withDuration: 1, delay: 0, options: [.repeat, .autoreverse], animations: {
            
            self.hippaImage.transform = CGAffineTransform(translationX: -10, y: 0)
            
        }, completion: nil)
        
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        
        moveHippaBanner()
    }
    
    func getSubscriptionPlans(duration:String) -> Void {
        let queryItems = ["CustomerGuid": "\(/Authentication.customerGuid)", "DurationOfPlan": duration]
        self.view.activityStartAnimating(activityColor: .themeGreen, backgroundColor: UIColor.white)
        WebService.subscriptionPlans(queryItems: queryItems) { (result) in
            DispatchQueue.main.async {
                switch result {
                case .success(let response):
                    self.subscriptionPlans = response.objects ?? []
                    print(self.subscriptionPlans.count)
                    self.pageControl.currentPage = 0
                    
                    if self.subscriptionPlans.count > 0 {
                        self.collectionPlans.reloadData()
                        let index = NSIndexPath(item: 0, section: 0)
                        self.collectionPlans.scrollToItem(at: index as IndexPath, at: .centeredHorizontally, animated: true)
                    }
                    
                    
                case .failure(let error):
                    AlertManager.showAlert(type: .custom(error.message))
                }
                self.view.activityStopAnimating()
            }
        }
    }
    
    @IBAction func didtapInfo(_ sender: Any) {
        AlertManager.showAlert(type: .custom(SubscriptionScreenText.SubInfo.localize())){
            NavigationHandler.pushTo(.contactUs)
        }
        
    }
    
    
    @IBAction func didtapBack(_ sender: Any) {
       
        if /Authentication.profileComplete{
            NavigationHandler.pop()
        }else{
            NavigationHandler.popTo(WelcomeViewController.self)
        }
      
    }
    
    @IBAction func didtapMonth(_ sender: Any) {
        self.btnMonth.backgroundColor = #colorLiteral(red: 0.1921568627, green: 0.6666666667, blue: 0.5215686275, alpha: 1)
        self.btnAnual.backgroundColor = #colorLiteral(red: 0.3215686275, green: 0.8784313725, blue: 0.6823529412, alpha: 1)
        getSubscriptionPlans(duration: "4")
        self.duration = "Quarterly"
    }
    
    @IBAction func didtapAnual(_ sender: Any) {
        self.btnAnual.backgroundColor = #colorLiteral(red: 0.1921568627, green: 0.6666666667, blue: 0.5215686275, alpha: 1)
        self.btnMonth.backgroundColor = #colorLiteral(red: 0.3215686275, green: 0.8784313725, blue: 0.6823529412, alpha: 1)
        getSubscriptionPlans(duration: "2")
        self.duration = "Yearly"
    }
    
}



extension SubscriptionPlansVC: UICollectionViewDataSource,UICollectionViewDelegate , UICollectionViewDelegateFlowLayout
{
    //this method is for the size of items
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let width = collectionView.frame.width
        let height = collectionView.frame.height
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
        let count = subscriptionPlans.count
        pageControl.numberOfPages = count
        pageControl.isHidden = !(count > 1)
        return count
        
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "SubscriptionCell", for: indexPath) as! SubscriptionCell
        cell.plansLabel.text = self.subscriptionPlans[indexPath.item].SubscriptionPlansMaster?.subscriptionPlanName?.uppercased()
        cell.feeLabel.text = "\(self.subscriptionPlans[indexPath.item].SubscriptionPlansMaster?.cost ?? 0)"
        
        cell.object = self.subscriptionPlans[indexPath.item].FeaturesList
        cell.btnBuy.tag = indexPath.row
        cell.btnBuy.addTarget(self, action:  #selector(payBtnPressed(sender:)), for: .touchUpInside)
        // cell.durationLabel.text = self.duration
        // cell.cycleLabel.text = Description  "\(self.duration.replacingOccurrences(of: "/", with: ""))  "
        
        // Arjun Code
        cell.cycleLabel.text = "  \(/self.subscriptionPlans[indexPath.item].SubscriptionPlansMaster?.subscriptionPlansMasterDescription)   "
        cell.monthLbl.isHidden = self.subscriptionPlans[indexPath.item].SubscriptionPlansMaster?.isDisplayAlways == true ? true : false
        
        
        if self.subscriptionPlans[indexPath.item].SubscriptionPlansMaster?.isDiscountApply == true && self.subscriptionPlans[indexPath.item].SubscriptionPlansMaster?.duration == 2 {
            cell.discountImg.isHidden = false
            //  cell.trailImage.isHidden = false
        }else{
            cell.discountImg.isHidden = true
            //  cell.trailImage.isHidden = true
        }
        
        cell.trailDaysLbl.text = /self.subscriptionPlans[indexPath.item].SubscriptionPlansMaster?.trialDays?.toString + " DAYS"
        
        //        if self.subscriptionPlans[indexPath.item].SubscriptionPlansMaster?.isGivenTrial == true || /self.subscriptionPlans[indexPath.item].SubscriptionPlansMaster?.trialDays > 0  {
        //
        if  /self.subscriptionPlans[indexPath.item].SubscriptionPlansMaster?.trialDays > 0  {
            cell.trailImage.isHidden = false
            cell.trailDaysLbl.isHidden = false
        }else{
            
            cell.trailImage.isHidden = true
            cell.trailDaysLbl.isHidden = true
        }
        
        return cell
        
    }
    
    
    func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        //  self.pageControl.currentPage = indexPath.section
    }
    
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
    }
    
    @objc func payBtnPressed(sender: UIButton) {
        getPlanDetail(planId:"\(self.subscriptionPlans[sender.tag].SubscriptionPlansMaster?.id ?? 0)" , duration: "\(self.subscriptionPlans[sender.tag].PlanDuration ?? 0)", sender: sender )
        
    }
    func getPlanDetail(planId:String,duration:String,sender:UIButton) -> Void {
        let queryItems = ["CustomerGuid": "\(Authentication.customerGuid!)", "PlanId": planId,"PlanDuration":duration]
        self.view.activityStartAnimating(activityColor: #colorLiteral(red: 0.233, green: 0.816, blue: 0.538, alpha: 1), backgroundColor: UIColor.white)
        WebService.planDetail(queryItems: queryItems) { (result) in
            DispatchQueue.main.async {
                switch result {
                case .success:
                    self.paidDoctorPlans(rowId: sender.tag)
                case .failure(let error):
                    AlertManager.showAlert(type: .custom(error.message))
                    
                }
                self.view.activityStopAnimating()
            }
        }
    }
    func updatePageNumber(scrollView: UIScrollView) {
        // If not case to `Int` will give an error.
        let currentPage = Int(ceil(scrollView.contentOffset.x / scrollView.frame.size.width))
        pageControl.currentPage = currentPage
    }
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        // This will be call when you scrolls it manually.
        updatePageNumber(scrollView: scrollView)
    }
    func scrollViewDidEndScrollingAnimation(_ scrollView: UIScrollView) {
        // This will be call when you scrolls it programmatically.
        updatePageNumber(scrollView: scrollView)
    }
    
    func paidDoctorPlans(rowId : Int) -> Void {
        let queryItems = ["CustomerGuid": "\(Authentication.customerGuid!)"]
        self.view.activityStartAnimating(activityColor: .themeGreen, backgroundColor: UIColor.white)
        WebService.paidDoctorPlans(queryItems: queryItems) { (result) in
            DispatchQueue.main.async {
                switch result {
                case .success(let response):
                    if response.object?.SubscriptionStatus == true && response.object?.PaymentStatus == true{
                        NavigationHandler.pushTo(.planCheckout(self.subscriptionPlans[rowId]))
                    }else{
                        NavigationHandler.pushTo(.planCheckout(self.subscriptionPlans[rowId]))
                    }
                case .failure:
                    NavigationHandler.pushTo(.planCheckout(self.subscriptionPlans[rowId]))
                }
                self.view.activityStopAnimating()
            }
        }
    }
    
}


