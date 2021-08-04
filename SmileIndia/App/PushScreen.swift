
//
//  PushScreen.swift
//  HandstandV2
//
//  Created by user on 31/12/18.
//  Copyright © 2018 Navjot Sharma. All rights reserved.
//

import Foundation
import UIKit
import Sinch

enum PushScreen {
    
    case welcome
    case login
    case signup
    case forgot
    case home
    case personalDetail([String: Any], String)
    case morningTiming([String: Any], UIImage?, String)
    case eveningTiming(BusinessHour, [String: Any], [[String: Any]], UIImage?, String)
    case doctorAccount
    case doctorDashboard
    case doctorDegree([String: Any], DoctorData)
    case doctorAddress([String: Any], DoctorData)
    case doctorImage([String: Any], DoctorData)
    case membership
    case changePassword
    case member
    case memberAddress([String: Any])
    case memberProfile
    case memberDashboard
    case memberChangePassword
    case familyMember
    case seeMembership
    case bookAppoinment(Doctor,[InsuranceList],String,Int)
    case knowMore(Doctor)
    case appointmentList(String)
    case rating(Appointment)
    case ratingList
    case mapView
    case doctorDb
    case memberDb
    case morninTimingsVC([String: Any], UIImage?, String)
    case eveningTimingsVC(BusinessHour, [String: Any], [[String: Any]], UIImage?, String)
    case doctorProfileOne
    case doctorProfileTwo([String: Any], DoctorData)
    case updateMrngHrsVC([String: Any], UIImage?, DoctorData)
    case updateEvngHrsVC(BusinessHour, [String: Any], [[String: Any]], UIImage?, DoctorData)
    case referralVC
    case eAppointments(Appointment)
    case callingVC(SINCall?,Int)
    case callVC(SINCall?)
    case replyVC(ReviewDetailsModel)
    case eAppointmentsList
    case enterOtpVC(Appointment)
    case paymentVC(AppointmentCheckOut,Doctor,String,String,String,String,String,String)
    case paymentViewController
    case calendar
    case calPopupVC
    case addPrescription
    case prescriptionList
    case addPscrpn(PrescriptionTemplates)
    case uploadfile(Appointment)
    case uploadedfiles(Appointment)
    case fullImage(URL?,String)
    case contactUs
    case prescribeVC(Appointment)
    case filterVC
    case subscriptionPlan
    case subscriptionPlans
    case planCheckout(SubscriptionPlans)
    case drPlanDetails(String)
    case subscriptionPaymentVC
    case subscriptionVC
    case paySubscription(String)
    case aboutus
    case enxVideoCalls(Appointment,Bool)
    case enxVideoCall
    case drPrescription(String,Appointment)
    case appointmentDetails(Appointment)
    case homeViewController
    case stripeCheckout(AppointmentCheckOut)
    case homeWithParam(String,[InsuranceList])
    case homeWithNameandSp(String,String,String,String,Int,[InsuranceList])
    case rewards
    case addmemberAddress
    case verificationsDocs
    case insurance
    case BankAccount
    case insuranceSearch([InsuranceList])
    case homeWithInsurance([InsuranceList])
    case refundtype(String)
    case credits
    case feed
    case createFeed
    case allTime(Doctor)
    case GetAllBlogsList
    case tagList
    case tagSearch([InsuranceList])
    case socioProfile
    case howitworks
    case aboutusvc
    case socioFriendList
    case newSignUp
    case faq
    var controller: UIViewController{
        switch self {
        case .welcome:
            let controller = WelcomeViewController.instantiateFromAppStoryboard(.login)
            return controller
        case .login:
            let controller = LoginViewController.instantiateFromAppStoryboard(.login)
            return controller
        case .signup:
            let controller = SignUpViewController.instantiateFromAppStoryboard(.register)
            return controller
        case .personalDetail(let dict, let type):
            let controller = SignupPersonalDetailController.instantiateFromAppStoryboard(.register)
            controller.dict = dict
            controller.customerType = type
            return controller
        case .forgot:
            let controller = ForgotPasswordController.instantiateFromAppStoryboard(.login)
            return controller
        case .home:
            let controller = FindDoctorController.instantiateFromAppStoryboard(.home)
            return controller
        case .morningTiming(let dict, let image, let type):
            let controller = MorningTimingsController.instantiateFromAppStoryboard(.register)
            controller.dict = dict
            controller.customerType = type
            controller.image = image ?? nil
            return controller
        case .eveningTiming(let businessHour, let dict, let arr, let image, let type):
            let controller = EveningTimingsController.instantiateFromAppStoryboard(.register)
            controller.dict = dict
            controller.customerType = type
            controller.businessHour = businessHour
            controller.array = arr
            controller.image = image ?? nil
            return controller
        case .doctorAccount:
            let controller = DoctorAccountDetailsController.instantiateFromAppStoryboard(.profile)
            return controller
        case .doctorDashboard:
            let controller = DoctorDashboardController.instantiateFromAppStoryboard(.profile)
            return controller
        case .doctorDegree(let dict, let doctor):
            let controller = DoctorDegreeController.instantiateFromAppStoryboard(.profile)
            controller.dict = dict
            controller.doctor = doctor
            return controller
        case .doctorAddress(let dict, let doctor):
            let controller = DoctorAddressController.instantiateFromAppStoryboard(.profile)
            controller.dict = dict
            controller.doctor = doctor
            return controller
        case .doctorImage(let dict, let doctor):
            let controller = DoctorImageController.instantiateFromAppStoryboard(.profile)
            controller.dict = dict
            controller.doctor = doctor
            return controller
        case .membership:
            let controller = VerifyMembershipController.instantiateFromAppStoryboard(.profile)
            return controller
        case .changePassword:
            let controller = ChangePasswordController.instantiateFromAppStoryboard(.profile)
            return controller
        case .member:
            let controller = MemberRegistrationController.instantiateFromAppStoryboard(.member)
            return controller
        case .memberAddress(let dict):
            let controller = MemberAddressController.instantiateFromAppStoryboard(.member)
            controller.dict = dict
            return controller
        case .memberProfile:
            let controller = MemberProfileController.instantiateFromAppStoryboard(.member)
            return controller
        case .memberDashboard:
            let controller = MemberDashboardController.instantiateFromAppStoryboard(.member)
            return controller
        case .memberChangePassword:
            let controller = MemberChangePasswordController.instantiateFromAppStoryboard(.member)
            return controller
        case .seeMembership:
            let controller = MemberShipController.instantiateFromAppStoryboard(.member)
            return controller
        case .familyMember:
            let controller = FamilyMemberController.instantiateFromAppStoryboard(.member)
            return controller
        case .bookAppoinment(let doctor ,let insuranceLists , let plan_name, let planId):
            let controller = BookAppointmentController.instantiateFromAppStoryboard(.appointment)
            controller.doctor = doctor
            controller.insuranceListforSearch = insuranceLists
            controller.planName = plan_name
            controller.insurancePlanID = planId
            return controller
          case .knowMore(let doctor):
            let controller = KnowMoreController.instantiateFromAppStoryboard(.appointment)
            controller.object = doctor
            return controller
        case .appointmentList(let navFlag):
            let controller = AppointmentListingController.instantiateFromAppStoryboard(.appointment)
            controller.navFlag = navFlag
            return controller
        case .rating(let appointment):
            let controller = RatingViewController.instantiateFromAppStoryboard(.rating)
            controller.object = appointment
            return controller
        case .ratingList:
            let controller = RatingListViewController.instantiateFromAppStoryboard(.rating)
            return controller
        case .mapView:
            let controller = MapVC.instantiateFromAppStoryboard(.map)
            return controller
        case .doctorDb:
            let controller = DoctorDashBoardVC.instantiateFromAppStoryboard(.profile)
            return controller
        case .memberDb:
            let controller = MemberDbVC.instantiateFromAppStoryboard(.member)
            return controller
        case .morninTimingsVC(let dict, let image, let type):
            let controller = MorningTimingsVC.instantiateFromAppStoryboard(.register)
            controller.dict = dict
            controller.customerType = type
            controller.image = image ?? nil
            return controller
        case .eveningTimingsVC(let businessHour, let dict, let arr, let image, let type):
            let controller = EveningTimingsVC.instantiateFromAppStoryboard(.register)
            controller.dict = dict
            controller.customerType = type
            controller.businessHour = businessHour
            controller.array = arr
            controller.image = image ?? nil
            return controller
        case .doctorProfileOne:
            let controller = ProfileFormOne.instantiateFromAppStoryboard(.profile)
            return controller
            
        case .doctorProfileTwo(let dict, let doctor):
            let controller = ProfileForTwo.instantiateFromAppStoryboard(.profile)
            controller.dict = dict
            controller.doctor = doctor
            return controller
            
        case .updateMrngHrsVC(let dict, let image, let doctor):
            let controller = UpdateMrngHrsVC.instantiateFromAppStoryboard(.profile)
            controller.dict = dict
            controller.image = image ?? nil
            controller.doctor = doctor
            return controller
            
        case .updateEvngHrsVC(let businessHour, let dict, let arr, let image, let doctor):
            let controller = UpdateEvngHrsVC.instantiateFromAppStoryboard(.profile)
            controller.dict = dict
            controller.businessHour = businessHour
            controller.array = arr
            controller.doctor = doctor
            controller.image = image ?? nil
            return controller
        case .referralVC:
            let controller = ReferralVC.instantiateFromAppStoryboard(.member)
            return controller
        case .eAppointments(let appointment):
            let controller = EAppointmentsVC.instantiateFromAppStoryboard(.appointment)
            controller.object = appointment
            return controller
        case .callingVC(let call,let appId):
            let controller = CallViewController.instantiateFromAppStoryboard(.login)
            controller.call = call
            controller.appId = appId
            return controller
        case .callVC(let call):
            let controller = CallViewController.instantiateFromAppStoryboard(.login)
            controller.call = call
            return controller
        case .replyVC(let appointment):
            let controller = ReplyViewController.instantiateFromAppStoryboard(.rating)
            controller.object = appointment
            return controller
        case .eAppointmentsList:
            let controller = EAppointmentsListVC.instantiateFromAppStoryboard(.appointment)
            return controller
        case .enterOtpVC(let appointment):
           let controller = EnterOtpVC.instantiateFromAppStoryboard(.appointment)
           controller.object = appointment
           return controller
        case .paymentVC(let appointmentCheckout, let doctor, let date, let time,let orderId,let type,let cardID ,let planName):
            let controller = PaymentsVC.instantiateFromAppStoryboard(.appointment)
            controller.appointmentCheckOut = appointmentCheckout
            controller.doctor = doctor
            controller.date = date
            controller.time = time
            controller.orderId = orderId
            controller.apntType = type
            controller.cardId = cardID
            controller.plan_name = planName
            return controller
        case .paymentViewController:
            let controller = PaymentViewController.instantiateFromAppStoryboard(.payments)
            return controller
        case .calendar:
            let controller = CalendarViewController.instantiateFromAppStoryboard(.calendar)
            return controller
        case .calPopupVC:
            let controller = CalendarPopupVC.instantiateFromAppStoryboard(.calendar)
            return controller
        case .addPrescription:
            let controller = AddPrescriptionVC.instantiateFromAppStoryboard(.prescription)
            return controller
        case .prescriptionList:
            let controller = PrescriptionListVC.instantiateFromAppStoryboard(.prescription)
            return controller
        case .addPscrpn(let template):
            let controller = AddPrescriptionVC.instantiateFromAppStoryboard(.prescription)
            controller.object = template
            return controller
        case .uploadfile(let appointment):
            let controller = UploadFileVC.instantiateFromAppStoryboard(.prescription)
            controller.object = appointment
            return controller
        case .uploadedfiles(let appointment):
            let controller = MemberUploadedFileVC.instantiateFromAppStoryboard(.prescription)
            controller.object = appointment
            return controller
        case .fullImage(let image , let titleString):
            let controller = FullImageVC.instantiateFromAppStoryboard(.prescription)
            controller.image = image ?? nil
            controller.titleStr = titleString
            return controller
        case .prescribeVC(let appointment):
            let controller = PrescribeVC.instantiateFromAppStoryboard(.prescription)
            controller.object = appointment
            return controller
       case .contactUs:
           let controller = ContactUsVC.instantiateFromAppStoryboard(.contactus)
           return controller
       case .filterVC:
           let controller = FilterVC.instantiateFromAppStoryboard(.home)
           return controller
       case .subscriptionPlan:
           let controller = SubscriptionPlanVC.instantiateFromAppStoryboard(.subscription)
           return controller
       case .subscriptionPlans:
           let controller = SubscriptionPlansVC.instantiateFromAppStoryboard(.subscription)
           return controller
       case .planCheckout(let plan):
           let controller = PlanCheckoutDetailsVC.instantiateFromAppStoryboard(.subscription)
           controller.object = plan
           return controller
       case .drPlanDetails(let navFlag):
           let controller = SubscribedPlanDetailsVC.instantiateFromAppStoryboard(.subscription)
           controller.nav_flag = navFlag
           return controller
            case .subscriptionVC: let controller = SubscriptionVC.instantiateFromAppStoryboard(.subscription)
                
            return controller
    case .subscriptionPaymentVC:
                       let controller = SubscriptionPaymentVC.instantiateFromAppStoryboard(.subscription)
                          return controller
                     
                   case .paySubscription(let url):
                        let controller = PaymentVC.instantiateFromAppStoryboard(.subscription)
                        controller.requestURLString = url
                           return controller
                       
                       
                   case .aboutus:
                                   let controller = AboutUsViewController.instantiateFromAppStoryboard(.contactus)
                                   
                                      return controller
                   
       case .enxVideoCalls(let appointment,let callType):
           let controller = VideoCallEnxVC.instantiateFromAppStoryboard(.calls)
           controller.object = appointment
           controller.callType = callType
           return controller
       case .enxVideoCall:
           let controller = VideoCallEnxVC.instantiateFromAppStoryboard(.calls)
           return controller
       case .drPrescription(let urlLink , let appointment):
           let controller = DrPrescriptionVC.instantiateFromAppStoryboard(.prescription)
           controller.requestURLString = urlLink
           controller.object = appointment
           return controller
       case .appointmentDetails(let appointment):
           let controller = AppointmentDetailsVC.instantiateFromAppStoryboard(.appointment)
           controller.object = appointment
           return controller
      case .homeViewController:
            let controller = HomeViewController.instantiateFromAppStoryboard(.home)
           return controller
       case .stripeCheckout(let apntCheckOut):
            let controller = StripeCheckOutVC.instantiateFromAppStoryboard(.payments)
            controller.appointmentCheckOut = apntCheckOut
            return controller
            
       case .homeWithParam(let spId,let insuranceLists):
            let controller = FindDoctorController.instantiateFromAppStoryboard(.home)
            controller.spId = spId
            controller.insuranceListforSearch = insuranceLists
            return controller
       case .homeWithNameandSp(let spId, let spName, let nameId,let planName , let planId,let insuranceLists):
            let controller = FindDoctorController.instantiateFromAppStoryboard(.home)
            controller.spId = spId
            controller.spName = spName
            controller.nameId = nameId
            controller.plan_name = planName
            controller.planID = planId
            controller.insuranceListforSearch = insuranceLists
            return controller
       case .rewards:
            let controller = RewardsViewController.instantiateFromAppStoryboard(.rewards)
            return controller
       
       case .addmemberAddress:
            let controller = memberAddressVC.instantiateFromAppStoryboard(.appointment)
            return controller
                
       case .verificationsDocs:
            let controller = verificationDocsVC.instantiateFromAppStoryboard(.payments)
            return controller
       case .insurance:
            let controller = InsuranceViewController.instantiateFromAppStoryboard(.insurance)
            return controller
        
        case .BankAccount:
             let controller = BankAccountViewController.instantiateFromAppStoryboard(.payments)
             return controller
        case .insuranceSearch(let insuranceLists):
            let controller = InsuranceSearchVC.instantiateFromAppStoryboard(.insurance)
            controller.insuranceList = insuranceLists
            return controller
        case .homeWithInsurance(let insuranceLists):
                let controller = FindDoctorController.instantiateFromAppStoryboard(.home)
                controller.insuranceListforSearch = insuranceLists
                return controller
        case .refundtype(let appid):
            let controller = refundtypeViewController.instantiateFromAppStoryboard(.appointment)
            controller.appid = appid
            return controller
        case .credits:
            let controller = CreditsViewController.instantiateFromAppStoryboard(.credits)
            return controller
        case .feed:
            let controller = socioFeedViewController.instantiateFromAppStoryboard(.socio)
            return controller
        case .createFeed:
            let controller = createPostViewController.instantiateFromAppStoryboard(.home)
            return controller
        case .allTime(let doctor):
          let controller = TimingsPopupViewController.instantiateFromAppStoryboard(.home)
          controller.object = doctor
          return controller
        case .GetAllBlogsList:
                let controller = socioFeedViewController.instantiateFromAppStoryboard(.socio)
                return controller
        case .tagList:
                let controller = tagListViewController.instantiateFromAppStoryboard(.home)
                return controller
        case .tagSearch(let insuranceLists):
            let controller = tagSearchVC.instantiateFromAppStoryboard(.insurance)
            controller.insuranceList = insuranceLists
            return controller
            
            
        case .socioProfile:
            let controller = socioProfileViewController.instantiateFromAppStoryboard(.socioProfile)
            return controller
            
        case .howitworks:
            let controller = howitworksViewController.instantiateFromAppStoryboard(.howitworks)
            return controller
        case .aboutusvc:
            let controller = aboutusViewController.instantiateFromAppStoryboard(.howitworks)
            return controller
            
            
        case .socioFriendList:
            let controller = friendsListViewController.instantiateFromAppStoryboard(.socioFriendList)
            return controller
            
            
        case .newSignUp:
            let controller = newDoctorSignUpVC.instantiateFromAppStoryboard(.register)
            return controller
            
        case .faq:
            let controller = FaqViewController.instantiateFromAppStoryboard(.howitworks)
            return controller
         }
        
    }
}
