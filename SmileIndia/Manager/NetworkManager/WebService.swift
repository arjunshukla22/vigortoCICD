//
//  ServiceRequest.swift
//  XRentY
//
//  Created by user on 25/06/18.
//  Copyright © 2018 user. All rights reserved.
//

import Foundation
import UIKit

class WebService: RequestHandler {
    
    //MARK:- Server Handler -- connect to server -- 
    private class func connectToServer(_ api: APIConstants, httpMethod method: HTTPMethod,query queryItems: Parameters? = nil, completion:@escaping (Result<Data,ErrorResult>)->Void) {
        
        // check rechability
        if !reachability.isReachable {
            self.showRetryAlert(message: "No Internet Connection", api: api, httpMethod: method, query: queryItems, completion: completion)
            activityIndicator.hideLoader()
            return
        }
        
        let cookieStore = HTTPCookieStorage.shared
        for cookie in cookieStore.cookies ?? [] {
            cookieStore.deleteCookie(cookie)
        }
        
        // url request
        let internalRequest = RequestBuilder.buildRequest(api: api,
                                                          method: method,
                                                          parameters: queryItems)
        // check request before session
        guard let request = internalRequest else {
            debugPrint("invalid request")
            return
        }
        
        // session
        let session = URLSession.shared
        let task = session.dataTask(with: request) { (data, response, error) in
            
            guard data != nil else {
                let serverError = "Unable to connect to server. please try again after sometime."
                self.showRetryAlert(message: error?.localizedDescription ?? serverError, api: api, httpMethod: method,query: queryItems, completion: completion)
                activityIndicator.hideLoader()
                return
            }
            
            completion(.success(data!))
        }
        
        task.resume()
    }
    
    // retry handler
    class func showRetryAlert(message: String, api: APIConstants, httpMethod method: HTTPMethod,query queryItems: Parameters? = nil, completion:@escaping (Result<Data,ErrorResult>)->Void) {
        
        DispatchQueue.main.async {
            guard let delegate = UIApplication.shared.delegate as? AppDelegate else { return }
            guard let controller = delegate.window?.rootViewController else { return }
            
            let alert = UIAlertController.init(title: nil, message: message, preferredStyle: .alert)
            //            let cancelAction = UIAlertAction.init(title: AlertBtnTxt.cancel.localize(), style: .cancel) { (_) in
            //                completion(Result.failure(ErrorResult.custom(string: "")))
            //            }
            let action = UIAlertAction.init(title: "Retry", style: .default) { (_) in
                self.connectToServer(api, httpMethod: method, query: queryItems, completion: completion)
            }
            alert.addAction(action)
            //      alert.addAction(cancelAction)
            
            controller.present(alert, animated: true, completion: nil)
        }
    }
    
    //MARK:- login user
    class func loginUser(queryItems: Parameters, completion:@escaping ((Result<Response<User>, ErrorResult>) -> Void)) {
        
        self.connectToServer(.login, httpMethod: .POST, query: queryItems, completion: self.networkResult(completion: completion))
    }
    
    //MARK:- register user
    class func registerUser(queryItems: Parameters, completion:@escaping ((Result<Response<User>, ErrorResult>) -> Void)) {
        
        self.connectToServer(.register, httpMethod: .POST, query: queryItems, completion: self.networkResult(completion: completion))
    }
    
    //MARK:- forgot password user
    class func forgotPassword(queryItems: Parameters, completion:@escaping ((Result<Response<User>, ErrorResult>) -> Void)) {
        
        self.connectToServer(.forgotPassword, httpMethod: .POST, query: queryItems, completion: self.networkResult(completion: completion))
    }
    
    //MARK:- change password user
    class func changePassword(queryItems: Parameters, completion:@escaping ((Result<Response<User>, ErrorResult>) -> Void)) {
        
        self.connectToServer(.changePassword, httpMethod: .POST, query: queryItems, completion: self.networkResult(completion: completion))
    }
    
    //MARK:- getTitle api
    class func getTitle(queryItems: Parameters, completion:@escaping ((Result<Response<List>, ErrorResult>) -> Void)) {
        
        self.connectToServer(.title, httpMethod: .POST, query: queryItems, completion: self.networkResult(completion: completion))
    }
    
    //MARK:- getGender api
    class func getGender(queryItems: Parameters, completion:@escaping ((Result<Response<List>, ErrorResult>) -> Void)) {
        
        self.connectToServer(.gender, httpMethod: .POST, query: queryItems, completion: self.networkResult(completion: completion))
    }
    //MARK:- getSpeciality api
    class func getSpeciality(queryItems: Parameters, completion:@escaping ((Result<Response<List>, ErrorResult>) -> Void)) {
        
        self.connectToServer(.speciality, httpMethod: .POST, query: queryItems, completion: self.networkResult(completion: completion))
    }
    //MARK:- getDegree api
    class func getDegree(queryItems: Parameters, completion:@escaping ((Result<Response<List>, ErrorResult>) -> Void)) {
        
        self.connectToServer(.degree, httpMethod: .POST, query: queryItems, completion: self.networkResult(completion: completion))
    }
    
    //MARK:- getState api
    class func getState(queryItems: Parameters, completion:@escaping ((Result<Response<List>, ErrorResult>) -> Void)) {
        self.connectToServer(.state, httpMethod: .POST, query: queryItems, completion: self.networkResult(completion: completion))
    }
    //MARK:- getCity api
    class func getCity(queryItems: Parameters, completion:@escaping ((Result<Response<List>, ErrorResult>) -> Void)) {
        self.connectToServer(.city, httpMethod: .POST, query: queryItems, completion: self.networkResult(completion: completion))
    }
    //MARK:- getCity api
    class func getAllCity(queryItems: Parameters, completion:@escaping ((Result<Response<List>, ErrorResult>) -> Void)) {
        self.connectToServer(.allCity, httpMethod: .POST, query: queryItems, completion: self.networkResult(completion: completion))
    }
    
    //MARK:- getBusinessHours api
    class func getBusinessHours(queryItems: Parameters, completion:@escaping ((Result<Response<BusinessHour>, ErrorResult>) -> Void)) {
        
        self.connectToServer(.businessHours, httpMethod: .POST, query: queryItems, completion: self.networkResult(completion: completion))
    }
    
    //MARK:- getBusinessHours api
    class func getRelationShip(queryItems: Parameters, completion:@escaping ((Result<Response<BusinessHour>, ErrorResult>) -> Void)) {
        
        self.connectToServer(.businessHours, httpMethod: .POST, query: queryItems, completion: self.networkResult(completion: completion))
    }
    
    //MARK:- findDoctor api
    class func findDoctor(queryItems: Parameters, completion:@escaping ((Result<Response<ListDoctor>, ErrorResult>) -> Void)) {
        
        self.connectToServer(.findDoctor, httpMethod: .POST, query: queryItems, completion: self.networkResult(completion: completion))
    }
    
    //MARK:- getDoctorProfile api
    class func getDoctorProfile(queryItems: Parameters, completion:@escaping ((Result<Response<DoctorData>, ErrorResult>) -> Void)) {
        self.connectToServer(.getDoctor, httpMethod: .POST, query: queryItems, completion: self.networkResult(completion: completion))
    }
    
    //MARK:- upload image
    class func uploadImage(queryItems: Parameters, completion:@escaping ((Result<Response<Empty>, ErrorResult>) -> Void)) {
        self.connectToServer(.uploadFile, httpMethod: .POST, query: queryItems, completion: self.networkResult(completion: completion))
    }
    
    //MARK:- update doctor profile
    class func updateDoctor(queryItems: Parameters, completion:@escaping ((Result<Response<User>, ErrorResult>) -> Void)) {
        self.connectToServer(.updateDoctorProfile , httpMethod: .POST, query: queryItems, completion: self.networkResult(completion: completion))
    }
    //MARK:- verify membership card
    class func verifyMembership(queryItems: Parameters, completion:@escaping ((Result<Response<Card>, ErrorResult>) -> Void)) {
        self.connectToServer(.verifyMembershipCard, httpMethod: .POST, query: queryItems, completion: self.networkResult(completion: completion))
    }
    
    //MARK:- Member registration
    class func memberRegistration(queryItems: Parameters, completion:@escaping ((Result<Response<Card>, ErrorResult>) -> Void)) {
        self.connectToServer(.memberRegistration, httpMethod: .POST, query: queryItems, completion: self.networkResult(completion: completion))
    }
    
    //MARK:- register member
    class func registerMember(queryItems: Parameters, completion:@escaping ((Result<Response<User>, ErrorResult>) -> Void)) {
        self.connectToServer(.memberRegistration, httpMethod: .POST, query: queryItems, completion: self.networkResult(completion: completion))
    }
    //MARK:- register member
    class func Save_Member_Api(queryItems: Parameters, completion:@escaping ((Result<Response<User>, ErrorResult>) -> Void)) {
        self.connectToServer(.memberRegistration, httpMethod: .POST, query: queryItems, completion: self.networkResult(completion: completion))
    }
    //MARK:- update member
    class func updateMember(queryItems: Parameters, completion:@escaping ((Result<Response<Member>, ErrorResult>) -> Void)) {
        self.connectToServer(.memberProfileDataUpdate, httpMethod: .POST, query: queryItems, completion: self.networkResult(completion: completion))
    }
    
    //MARK:- getDoctorProfile api
    class func getMemberProfile(queryItems: Parameters, completion:@escaping ((Result<Response<Member>, ErrorResult>) -> Void)) {
        self.connectToServer(.memberProfileDataView, httpMethod: .POST, query: queryItems, completion: self.networkResult(completion: completion))
    }
    //MARK:- verify membership card
    class func membership(queryItems: Parameters, completion:@escaping ((Result<Response<Card>, ErrorResult>) -> Void)) {
        self.connectToServer(.viewMemberCard, httpMethod: .POST, query: queryItems, completion: self.networkResult(completion: completion))
    }
    //MARK:- change password user
    class func changePasswordMember(queryItems: Parameters, completion:@escaping ((Result<Response<User>, ErrorResult>) -> Void)) {
        self.connectToServer(.changePasswordMember, httpMethod: .POST, query: queryItems, completion: self.networkResult(completion: completion))
    }
    
    //MARK:- family member data
    class func familyMemberData(queryItems: Parameters, completion:@escaping ((Result<Response<FamilyMember>, ErrorResult>) -> Void)) {
        self.connectToServer(.familyMemberDataView, httpMethod: .POST, query: queryItems, completion: self.networkResult(completion: completion))
    }
    
    //MARK:- Book appointment
    class func bookAppointment(queryItems: Parameters, completion:@escaping ((Result<Response<AppointmentCheckOut>, ErrorResult>) -> Void)) {
        self.connectToServer(.bookAppointment, httpMethod: .POST, query: queryItems, completion: self.networkResult(completion: completion))
    }
    
    //MARK:- getNextSevenDaysDates
    class func getNextSevenDaysDates(queryItems: Parameters, completion:@escaping ((Result<Response<Empty>, ErrorResult>) -> Void)) {
        
        self.connectToServer(.getNextSevenDaysDates, httpMethod: .GET, query: queryItems, completion: self.networkResult(completion: completion))
    }
    //MARK:- getBookAppointmentTiming
    class func getBookAppointmentTiming(queryItems: Parameters, completion:@escaping ((Result<Response<Empty>, ErrorResult>) -> Void)) {
        
        self.connectToServer(.getBookAppointmentTiming, httpMethod: .GET, query: queryItems, completion: self.networkResult(completion: completion))
    }
    //MARK:- manageMemberAppointment
    class func manageMemberAppointment(queryItems: Parameters, completion:@escaping ((Result<Response<Appointment>, ErrorResult>) -> Void)) {
        
        self.connectToServer(.manageMemberAppointment, httpMethod: .GET, query: queryItems, completion: self.networkResult(completion: completion))
    }
    //MARK:- cancelMemberAppointment
    class func cancelMemberAppointment(queryItems: Parameters, completion:@escaping ((Result<Response<Empty>, ErrorResult>) -> Void)) {
        
        self.connectToServer(.cancelMemberAppointment, httpMethod: .GET, query: queryItems, completion: self.networkResult(completion: completion))
    }
    //MARK:- canceldoctorappointment
    class func canceldoctorappointment(queryItems: Parameters, completion:@escaping ((Result<Response<Empty>, ErrorResult>) -> Void)) {
        
        self.connectToServer(.canceldoctorappointment, httpMethod: .GET, query: queryItems, completion: self.networkResult(completion: completion))
    }
    //MARK:- managePendingDoctorAppointments
    class func managePendingDoctorAppointments(queryItems: Parameters, completion:@escaping ((Result<Response<Empty>, ErrorResult>) -> Void)) {
        
        self.connectToServer(.managePendingDoctorAppointments, httpMethod: .GET, query: queryItems, completion: self.networkResult(completion: completion))
    }
    //MARK:- manageConfirmedAppointments
    class func manageConfirmedAppointments(queryItems: Parameters, completion:@escaping ((Result<Response<Empty>, ErrorResult>) -> Void)) {
        self.connectToServer(.manageConfirmedAppointments, httpMethod: .POST, query: queryItems, completion: self.networkResult(completion: completion))
    }
    //MARK:- deleteMemberAppointment
    class func deleteMemberAppointment(queryItems: Parameters, completion:@escaping ((Result<Response<Empty>, ErrorResult>) -> Void)) {
        
        self.connectToServer(.deleteMemberAppointment, httpMethod: .GET, query: queryItems, completion: self.networkResult(completion: completion))
    }
    //MARK:- deleteDoctorAppointment
    class func deleteDoctorAppointment(queryItems: Parameters, completion:@escaping ((Result<Response<Empty>, ErrorResult>) -> Void)) {
        
        self.connectToServer(.deleteDoctorAppointment, httpMethod: .GET, query: queryItems, completion: self.networkResult(completion: completion))
    }
    //MARK:- savedoctorNotes
    class func savedoctorNotes(queryItems: Parameters, completion:@escaping ((Result<Response<Empty>, ErrorResult>) -> Void)) {
        
        self.connectToServer(.savedoctorNotes, httpMethod: .GET, query: queryItems, completion: self.networkResult(completion: completion))
    }
    //MARK:- manageDoctorAppointment
    class func manageDoctorAppointment(queryItems: Parameters, completion:@escaping ((Result<Response<Appointment>, ErrorResult>) -> Void)) {
        
        self.connectToServer(.manageDoctorAppointment, httpMethod: .GET, query: queryItems, completion: self.networkResult(completion: completion))
    }
    
    //MARK:- Show rating
    class func showrating(queryItems: Parameters, completion:@escaping ((Result<Response<Rating>, ErrorResult>) -> Void)) {
        self.connectToServer(.showrating, httpMethod: .GET, query: queryItems, completion: self.networkResult(completion: completion))
    }
    
    //MARK:- rateproviders
    class func rateproviders(queryItems: Parameters, completion:@escaping ((Result<Response<Empty>, ErrorResult>) -> Void)) {
        
        self.connectToServer(.rateproviders, httpMethod: .POST, query: queryItems, completion: self.networkResult(completion: completion))
    }
    //MARK:- getRatedAppointments
    class func getRatedAppointments(queryItems: Parameters, completion:@escaping ((Result<Response<ReviewDetailsModel>, ErrorResult>) -> Void)) {
        
        self.connectToServer(.getRatedAppointments, httpMethod: .GET, query: queryItems, completion: self.networkResult(completion: completion))
    }
    //MARK:- saveToken
    class func saveToken(queryItems: Parameters, completion:@escaping ((Result<Response<Appointment>, ErrorResult>) -> Void)) {
        
        self.connectToServer(.SaveToekn, httpMethod: .POST, query: queryItems, completion: self.networkResult(completion: completion))
    }
    
    //MARK:- get appointments data
    class func getAppointmentsAgeAndAppointNo(queryItems: Parameters, completion:@escaping ((Result<Response<AppointmentIdAndAge>, ErrorResult>) -> Void)) {
        
        self.connectToServer(.getAppointmentNoAndAge, httpMethod: .GET, query: queryItems, completion: self.networkResult(completion: completion))
    }
    
    //MARK:- getDoctorProfile api
    class func getrewardsData(queryItems: Parameters, completion:@escaping ((Result<Response<Rewards>, ErrorResult>) -> Void)) {
        self.connectToServer(.getRewards, httpMethod: .POST, query: queryItems, completion: self.networkResult(completion: completion))
    }
    
    //MARK:- replyroviders
    class func replyproviders(queryItems: Parameters, completion:@escaping ((Result<Response<Empty>, ErrorResult>) -> Void)) {
        
        self.connectToServer(.replyroviders, httpMethod: .POST, query: queryItems, completion: self.networkResult(completion: completion))
    }
    
    //MARK:- doctorAppointmentdetails
    class func doctorAppointmentdetails(queryItems: Parameters, completion:@escaping ((Result<Response<Empty>, ErrorResult>) -> Void)) {
        self.connectToServer(.doctorAppointmentdetails, httpMethod: .POST, query: queryItems, completion: self.networkResult(completion: completion))
    }
    
    //MARK:- get appointments data
    class func createRazorPayOrder(queryItems: Parameters, completion:@escaping ((Result<Response<Empty>, ErrorResult>) -> Void)) {
        
        self.connectToServer(.createRazorPayOrder, httpMethod: .POST, query: queryItems, completion: self.networkResult(completion: completion))
    }
    
    //MARK:- get appointments data
    class func savePaymentInformation(queryItems: Parameters, completion:@escaping ((Result<Response<Empty>, ErrorResult>) -> Void)) {
        
        self.connectToServer(.savePaymentInformation, httpMethod: .POST, query: queryItems, completion: self.networkResult(completion: completion))
    }
    
    //MARK:- get appointments data
    class func getAccountDetails(queryItems: Parameters, completion:@escaping ((Result<Response<AccountDetails>, ErrorResult>) -> Void)) {
        
        self.connectToServer(.getAccountDetails, httpMethod: .POST, query: queryItems, completion: self.networkResult(completion: completion))
    }
    
    //MARK:- saveUPI data
    class func saveUPI(queryItems: Parameters, completion:@escaping ((Result<Response<Empty>, ErrorResult>) -> Void)) {
        
        self.connectToServer(.saveUPI, httpMethod: .POST, query: queryItems, completion: self.networkResult(completion: completion))
    }
    
    //MARK:- saveBankAccount data
    class func saveBankAccount(queryItems: Parameters, completion:@escaping ((Result<Response<Empty>, ErrorResult>) -> Void)) {
        
        self.connectToServer(.saveBankAccount, httpMethod: .POST, query: queryItems, completion: self.networkResult(completion: completion))
    }
    
    //MARK:- saveBankAccount data
    class func getMyCalendar(queryItems: Parameters, completion:@escaping ((Result<Response<CalendarData>, ErrorResult>) -> Void)) {
        
        self.connectToServer(.myCalendar, httpMethod: .GET, query: queryItems, completion: self.networkResult(completion: completion))
    }
    
    //MARK:- saveBankAccount data
    class func getIsCloseFullDay(queryItems: Parameters, completion:@escaping ((Result<Response<Empty>, ErrorResult>) -> Void)) {
        self.connectToServer(.getIsCloseFullDay, httpMethod: .POST, query: queryItems, completion: self.networkResult(completion: completion))
    }
    //MARK:- saveBankAccount data
    class func saveIsCloseFullDay(queryItems: Parameters, completion:@escaping ((Result<Response<Empty>, ErrorResult>) -> Void)) {
        
        self.connectToServer(.saveIsCloseFullDay, httpMethod: .POST, query: queryItems, completion: self.networkResult(completion: completion))
    }
    
    //MARK:- createPrescriptionTemplate 
    class func createPrescriptionTemplate(queryItems: Parameters, completion:@escaping ((Result<Response<Empty>, ErrorResult>) -> Void)) {
        
        self.connectToServer(.createPrescriptionTemplate, httpMethod: .POST, query: queryItems, completion: self.networkResult(completion: completion))
    }
    
    //MARK:- getPrescriptionTemplates
    class func getPrescriptionTemplates(queryItems: Parameters, completion:@escaping ((Result<Response<PrescriptionTemplates>, ErrorResult>) -> Void)) {
        
        self.connectToServer(.getPrescriptionTemplates, httpMethod: .GET, query: queryItems, completion: self.networkResult(completion: completion))
    }
    //MARK:- deletePrescriptionTemplate
    class func deletePrescriptionTemplate(queryItems: Parameters, completion:@escaping ((Result<Response<Empty>, ErrorResult>) -> Void)) {
        
        self.connectToServer(.deletePrescriptionTemplate, httpMethod: .POST, query: queryItems, completion: self.networkResult(completion: completion))
    }
    
    //MARK:- deletePrescriptionTemplate
    class func uploadMemberFiles(queryItems: Parameters, completion:@escaping ((Result<Response<Empty>, ErrorResult>) -> Void)) {
        
        self.connectToServer(.uploadMemberFiles, httpMethod: .POST, query: queryItems, completion: self.networkResult(completion: completion))
    }
    
    //MARK:- getMemberFiles
    class func getMemberFiles(queryItems: Parameters, completion:@escaping ((Result<Response<MemberFiles>, ErrorResult>) -> Void)) {
        
        self.connectToServer(.getMemberFiles, httpMethod: .GET, query: queryItems, completion: self.networkResult(completion: completion))
    }
    
    //MARK:- deleteMemberFilebyId
    class func deleteMemberFilebyId(queryItems: Parameters, completion:@escaping ((Result<Response<Empty>, ErrorResult>) -> Void)) {
        
        self.connectToServer(.deleteMemberFilebyId, httpMethod: .GET, query: queryItems, completion: self.networkResult(completion: completion))
    }
    
    //MARK:- upload Signature
    class func uploadSignature(queryItems: Parameters, completion:@escaping ((Result<Response<Empty>, ErrorResult>) -> Void)) {
        self.connectToServer(.uploadSignature, httpMethod: .POST, query: queryItems, completion: self.networkResult(completion: completion))
    }
    
    //MARK:- getSignature
    class func getSignature(queryItems: Parameters, completion:@escaping ((Result<Response<Signature>, ErrorResult>) -> Void)) {
        
        self.connectToServer(.getSignature, httpMethod: .GET, query: queryItems, completion: self.networkResult(completion: completion))
    }
    
    //MARK:- contactUs
    class func contactUs(queryItems: Parameters, completion:@escaping ((Result<Response<Empty>, ErrorResult>) -> Void)) {
        self.connectToServer(.contactus, httpMethod: .POST, query: queryItems, completion: self.networkResult(completion: completion))
    }
    
    //MARK:- uploadDoctorPrescriptionFiles
    class func uploadDoctorPrescriptionFiles(queryItems: Parameters, completion:@escaping ((Result<Response<Empty>, ErrorResult>) -> Void)) {
        self.connectToServer(.uploadDoctorPrescriptionFiles, httpMethod: .POST, query: queryItems, completion: self.networkResult(completion: completion))
    }
    
    //MARK:- addDoctorPrescription
    class func addDoctorPrescription(queryItems: Parameters, completion:@escaping ((Result<Response<Empty>, ErrorResult>) -> Void)) {
        self.connectToServer(.addDoctorPrescription, httpMethod: .POST, query: queryItems, completion: self.networkResult(completion: completion))
    }
    
    //MARK:- getDoctorPrescription
    class func getDoctorPrescription(queryItems: Parameters, completion:@escaping ((Result<Response<DrPrescription>, ErrorResult>) -> Void)) {
        self.connectToServer(.getDoctorPrescription, httpMethod: .GET, query: queryItems, completion: self.networkResult(completion: completion))
    }
    
    
    //MARK:- getDoctorPrescriptionFiles
    class func getDoctorPrescriptionFiles(queryItems: Parameters, completion:@escaping ((Result<Response<DoctorPrescriptionFiles>, ErrorResult>) -> Void)) {
        self.connectToServer(.getDoctorPrescriptionFiles, httpMethod: .GET, query: queryItems, completion: self.networkResult(completion: completion))
    }
    
    //MARK:- Email,Phone Check
    class func isExists(queryItems: Parameters, completion:@escaping ((Result<Response<Empty>, ErrorResult>) -> Void)) {
        self.connectToServer(.isExist, httpMethod: .GET, query: queryItems, completion: self.networkResult(completion: completion))
    }
    
    //MARK:- subscriptionPlans
    class func subscriptionPlans(queryItems: Parameters, completion:@escaping ((Result<Response<SubscriptionPlans>, ErrorResult>) -> Void)) {
        self.connectToServer(.plans, httpMethod: .GET, query: queryItems, completion: self.networkResult(completion: completion))
    }
    
    //MARK:- contactUs
    class func planDetail(queryItems: Parameters, completion:@escaping ((Result<Response<PlanDetailsModel>, ErrorResult>) -> Void)) {
        self.connectToServer(.planDetail, httpMethod: .POST, query: queryItems, completion: self.networkResult(completion: completion))
    }
    
    //MARK:- Doctor Plan Details
    class func doctorPlanDetails(queryItems: Parameters, completion:@escaping ((Result<Response<SubscribedPlan>, ErrorResult>) -> Void)) {
        self.connectToServer(.doctorPlanDetails, httpMethod: .GET, query: queryItems, completion: self.networkResult(completion: completion))
    }
    
    //MARK:- cancelSubscription
    class func cancelSubscription(queryItems: Parameters, completion:@escaping ((Result<Response<Empty>, ErrorResult>) -> Void)) {
        self.connectToServer(.cancelSubscription, httpMethod: .GET, query: queryItems, completion: self.networkResult(completion: completion))
    }
    
    //MARK:- buyplan
    class func buyplan(queryItems: Parameters, completion:@escaping ((Result<Response<Empty>, ErrorResult>) -> Void)) {
        self.connectToServer(.buyplan, httpMethod: .POST, query: queryItems, completion: self.networkResult(completion: completion))
    }
    
    //MARK:- PaidDoctorPlans
    class func paidDoctorPlans(queryItems: Parameters, completion:@escaping ((Result<Response<PaidDoctorsPlan>, ErrorResult>) -> Void)) {
        self.connectToServer(.PaidDoctorPlans, httpMethod: .GET, query: queryItems, completion: self.networkResult(completion: completion))
    }
    
    
    //MARK:- Register Device for calls push
    class func registerDevice(queryItems: Parameters, completion:@escaping ((Result<Response<Empty>, ErrorResult>) -> Void)) {
        self.connectToServer(.registerDevice, httpMethod: .POST, query: queryItems, completion: self.networkResult(completion: completion))
    }
    
    //MARK:- send push message
    class func sendVideoAudioCallMessage(queryItems: Parameters, completion:@escaping ((Result<Response<Empty>, ErrorResult>) -> Void)) {
        self.connectToServer(.sendVideoAudioCallMessage, httpMethod: .POST, query: queryItems, completion: self.networkResult(completion: completion))
    }
    
    
    //MARK:- getAppointmentDataForIOSVideoCall
    class func getAppointmentDataForIOSVideoCall(queryItems: Parameters, completion:@escaping ((Result<Response<Appointment>, ErrorResult>) -> Void)) {
        self.connectToServer(.getAppointmentDataForIOSVideoCall, httpMethod: .GET, query: queryItems, completion: self.networkResult(completion: completion))
    }
    
    //MARK:- doctorNotAvailable
    class func doctorNotAvailable(queryItems: Parameters, completion:@escaping ((Result<Response<Empty>, ErrorResult>) -> Void)) {
        self.connectToServer(.doctorNotAvailable, httpMethod: .GET, query: queryItems, completion: self.networkResult(completion: completion))
    }
    //MARK:- patientNotAvailable
    class func patientNotAvailable(queryItems: Parameters, completion:@escaping ((Result<Response<Empty>, ErrorResult>) -> Void)) {
        self.connectToServer(.patientNotAvailable, httpMethod: .GET, query: queryItems, completion: self.networkResult(completion: completion))
    }
    
    //MARK:- enableX_CreateToken
    class func enableX_CreateToken(queryItems: Parameters, completion:@escaping ((Result<Response<Empty>, ErrorResult>) -> Void)) {
        self.connectToServer(.enableX_CreateToken, httpMethod: .POST, query: queryItems, completion: self.networkResult(completion: completion))
    }
    
    //MARK:- allowedRefundOption
    class func allowedRefundOption(queryItems: Parameters, completion:@escaping ((Result<Response<RefundOptions>, ErrorResult>) -> Void)) {
        self.connectToServer(.allowedRefundOption, httpMethod: .GET, query: queryItems, completion: self.networkResult(completion: completion))
    }
    
    //MARK:- initiateRefund
    class func initiateRefund(queryItems: Parameters, completion:@escaping ((Result<Response<Empty>, ErrorResult>) -> Void)) {
        self.connectToServer(.initiateRefund, httpMethod: .POST, query: queryItems, completion: self.networkResult(completion: completion))
    }
    
    //MARK:- getCountries
    class func GetCountries(queryItems: Parameters, completion:@escaping ((Result<Response<List>, ErrorResult>) -> Void)) {
        
        self.connectToServer(.country, httpMethod: .POST, query: queryItems, completion: self.networkResult(completion: completion))
    }
    
    //MARK:- GetAllTimeZone
    class func GetAllTimeZone(queryItems: Parameters, completion:@escaping ((Result<Response<TimeZoneModel>, ErrorResult>) -> Void)) {
        
        self.connectToServer(.timezone, httpMethod: .GET, query: queryItems, completion: self.networkResult(completion: completion))
    }
    //MARK:- createPaymentIntent
    class func createPaymentIntent(queryItems: Parameters, completion:@escaping ((Result<Response<Empty>, ErrorResult>) -> Void)) {
        
        self.connectToServer(.createPaymentIntent, httpMethod: .POST, query: queryItems, completion: self.networkResult(completion: completion))
    }
    //MARK:- isCheckFreeAppointments
    class func isCheckFreeAppointments(queryItems: Parameters, completion:@escaping ((Result<Response<Empty>, ErrorResult>) -> Void)) {
        self.connectToServer(.isCheckFreeAppointments, httpMethod: .GET, query: queryItems, completion: self.networkResult(completion: completion))
    }
    
    //MARK:- CheckMemberAddress
    class func isCheckMemberAddress(queryItems: Parameters, completion:@escaping ((Result<Response<Member>, ErrorResult>) -> Void)) {
        self.connectToServer(.isCheckMemberAddress, httpMethod: .POST, query: queryItems, completion: self.networkResult(completion: completion))
    }
    
    //MARK:- CheckMemberAddress
    class func UploadLocalAddress(queryItems: Parameters, completion:@escaping ((Result<Response<Empty>, ErrorResult>) -> Void)) {
        self.connectToServer(.UploadLocalAddress, httpMethod: .POST, query: queryItems, completion: self.networkResult(completion: completion))
    }
    
    //MARK:- getSmileIndiaCredits
    class func getRoomInfo(queryItems: Parameters, completion:@escaping ((Result<Response<Empty>, ErrorResult>) -> Void)) {
        self.connectToServer(.getRoomInfo, httpMethod: .GET, query: queryItems, completion: self.networkResult(completion: completion))
    }
    
    //MARK:- UploadVerficationFile
    
    class func UploadVerficationFile(queryItems: Parameters, completion:@escaping ((Result<Response<Empty>, ErrorResult>) -> Void)) {
        
        self.connectToServer(.UploadVerficationFile, httpMethod: .POST, query: queryItems, completion: self.networkResult(completion: completion))
    }
    
    //MARK:- insurancesProvidersList
    class func insurancesProvidersList(queryItems: Parameters, completion:@escaping ((Result<Response<InsuranceList>, ErrorResult>) -> Void)) {
        self.connectToServer(.insurancesProvidersList, httpMethod: .POST, query: queryItems, completion: self.networkResult(completion: completion))
    }
    
    //MARK:- insuranceAddedOrRemove
    class func insuranceAddedOrRemove(queryItems: Parameters, completion:@escaping ((Result<Response<Empty>, ErrorResult>) -> Void)) {
        self.connectToServer(.insuranceAddedOrRemove, httpMethod: .POST, query: queryItems, completion: self.networkResult(completion: completion))
    }
    
    //MARK:- deleteDeviceToken
    class func deleteDeviceToken(queryItems: Parameters, completion:@escaping ((Result<Response<Empty>, ErrorResult>) -> Void)) {
        self.connectToServer(.deleteDeviceToken, httpMethod: .POST, query: queryItems, completion: self.networkResult(completion: completion))
    }
    
    
    //MARK:- IsCheckVerificationDocumentsStatus
    class func IsCheckVerificationDocumentsStatus(queryItems: Parameters, completion:@escaping ((Result<Response<Member>, ErrorResult>) -> Void)) {
        self.connectToServer(.IsCheckVerificationDocumentsStatus, httpMethod: .POST, query: queryItems, completion: self.networkResult(completion: completion))
    }
    //MARK:- insurancesProvidersAndPlans
    class func insurancesProvidersAndPlans(queryItems: Parameters, completion:@escaping ((Result<Response<InsuranceList>, ErrorResult>) -> Void)) {
        self.connectToServer(.insurancesProvidersAndPlans, httpMethod: .GET, query: queryItems, completion: self.networkResult(completion: completion))
    }
    
    //MARK:- GetAllTimeZoneus
    class func GetAllTimeZoneus(queryItems: Parameters, completion:@escaping ((Result<Response<TimeZoneModel>, ErrorResult>) -> Void)) {
        
        self.connectToServer(.ustimezone, httpMethod: .GET, query: queryItems, completion: self.networkResult(completion: completion))
    }
    
    //MARK:- getMintuesDifference
    class func getMintuesDifference(queryItems: Parameters, completion:@escaping ((Result<Response<TimeDifference>, ErrorResult>) -> Void)) {
        self.connectToServer(.getMintuesDifference, httpMethod: .GET, query: queryItems, completion: self.networkResult(completion: completion))
    }
    
    //MARK:- isCheckDoctorAcceptedInsurance
    class func isCheckDoctorAcceptedInsurance(queryItems: Parameters, completion:@escaping ((Result<Response<Empty>, ErrorResult>) -> Void)) {
        self.connectToServer(.isCheckDoctorAcceptedInsurance, httpMethod: .GET, query: queryItems, completion: self.networkResult(completion: completion))
    }
    
    //MARK:- uploadInsuranceCard
    class func uploadInsuranceCard(queryItems: Parameters, completion:@escaping ((Result<Response<Empty>, ErrorResult>) -> Void)) {
        self.connectToServer(.uploadInsuranceCard, httpMethod: .POST, query: queryItems, completion: self.networkResult(completion: completion))
    }
    
    //MARK:- uploadInsuranceCard
    class func enableAppointmentWithoutPayment(queryItems: Parameters, completion:@escaping ((Result<Response<Empty>, ErrorResult>) -> Void)) {
        self.connectToServer(.enableAppointmentWithoutPayment, httpMethod: .GET, query: queryItems, completion: self.networkResult(completion: completion))
    }
    
    //MARK:- GenerateEphemeralKey
    class func GenerateEphemeralKey(queryItems: Parameters, completion:@escaping ((Result<Response<Member>, ErrorResult>) -> Void)) {
        self.connectToServer(.GenerateEphemeralKey, httpMethod: .POST, query: queryItems, completion: self.networkResult(completion: completion))
    }
    
    //MARK:- subscriptionCallbackAPI
    class func subscriptionCallbackAPI(queryItems: Parameters, completion:@escaping ((Result<Response<Empty>, ErrorResult>) -> Void)) {
        self.connectToServer(.subscriptionCallbackAPI, httpMethod: .POST, query: queryItems, completion: self.networkResult(completion: completion))
    }
    //MARK:- subscriptionCancelAPI
    class func subscriptionCancelAPI(queryItems: Parameters, completion:@escaping ((Result<Response<Empty>, ErrorResult>) -> Void)) {
        self.connectToServer(.subscriptionCancelAPI, httpMethod: .POST, query: queryItems, completion: self.networkResult(completion: completion))
    }
    
    //MARK:- subscriptionUpgradeAPI
    class func subscriptionUpgradeAPI(queryItems: Parameters, completion:@escaping ((Result<Response<Empty>, ErrorResult>) -> Void)) {
        self.connectToServer(.subscriptionUpgradeAPI, httpMethod: .POST, query: queryItems, completion: self.networkResult(completion: completion))
    }
    
    //MARK:- getVigortoCredits
    class func getVigortoCredits(queryItems: Parameters, completion:@escaping ((Result<Response<Credits>, ErrorResult>) -> Void)) {
        self.connectToServer(.getVigortoCredits, httpMethod: .GET, query: queryItems, completion: self.networkResult(completion: completion))
    }
    
    //MARK:- mintuesDifference
    class func mintuesDifference(queryItems: Parameters, completion:@escaping ((Result<Response<TimeDifference>, ErrorResult>) -> Void)) {
        self.connectToServer(.mintuesDifference, httpMethod: .GET, query: queryItems, completion: self.networkResult(completion: completion))
    }
    
    //MARK:- AddPost
    
    class func AddPost(queryItems: Parameters, completion:@escaping ((Result<Response<Empty>, ErrorResult>) -> Void)) {
        self.connectToServer(.addPost, httpMethod: .POST, query: queryItems, completion: self.networkResult(completion: completion))
    }
    //MARK:- POSTLIST
    
    
    class func listPost(queryItems: Parameters, completion:@escaping ((Result<Response<ListPost>, ErrorResult>) -> Void)) {
        
        self.connectToServer(.getAllBlogsList, httpMethod: .GET, query: queryItems, completion: self.networkResult(completion: completion))
    }
    
    //MARK:- GetSpecialityFoSocio tags
    class func Gettags(queryItems: Parameters, completion:@escaping ((Result<Response<List>, ErrorResult>) -> Void)) {
        
        self.connectToServer(.GetSpecialityFoSocio, httpMethod: .POST, query: queryItems, completion: self.networkResult(completion: completion))
    }
    
    //MARK:- customerInfo
    class func customerInfo(queryItems: Parameters, completion:@escaping ((Result<Response<CustomerInfo>, ErrorResult>) -> Void)) {
        self.connectToServer(.customerInfo, httpMethod: .GET, query: queryItems, completion: self.networkResult(completion: completion))
    }
    
    //MARK:- Get Blogs Post Comment
    class func getBlogPostComments(queryItems: Parameters, completion:@escaping ((Result<Response<CommentModel>, ErrorResult>) -> Void)) {
        self.connectToServer(.BlogPostComments, httpMethod: .GET, query: queryItems, completion: self.networkResult(completion: completion))
    }
    
    
    //MARK:- Add Blog Post Comment
    class func AddBlogPostComment(queryItems: Parameters, completion:@escaping ((Result<Response<CommentDeleteModel>, ErrorResult>) -> Void)) {
        self.connectToServer(.AddBlogPostComment, httpMethod: .POST, query: queryItems, completion: self.networkResult(completion: completion))
    }
    
    //MARK:- Add Post Like Status
    class func AddPostLikeStatus(queryItems: Parameters, completion:@escaping ((Result<Response<AddLikePostModel>, ErrorResult>) -> Void)) {
        self.connectToServer(.AddPostLikeStatus, httpMethod: .POST, query: queryItems, completion: self.networkResult(completion: completion))
    }
    
    //MARK:- socioProfile
    class func getSocioProfile(queryItems: Parameters, completion:@escaping ((Result<Response<SocioData>, ErrorResult>) -> Void)) {
        self.connectToServer(.socioProfile, httpMethod: .GET, query: queryItems, completion: self.networkResult(completion: completion))
    }
    
}


extension WebService {
    
    //MARK:- Add Post Like Status
    class func DeleteComment(queryItems: Parameters, completion:@escaping ((Result<Response<CommentDeleteModel>, ErrorResult>) -> Void)) {
        self.connectToServer(.DeleteComment, httpMethod: .GET, query: queryItems, completion: self.networkResult(completion: completion))
    }
    
    //MARK:- Delete post
    class func DeletePost(queryItems: Parameters, completion:@escaping ((Result<Response<CommentDeleteModel>, ErrorResult>) -> Void)) {
        self.connectToServer(.DeletePost, httpMethod: .GET, query: queryItems, completion: self.networkResult(completion: completion))
    }
    
    //MARK:- Add Friend Api
    class func AddFriend(queryItems: Parameters, completion:@escaping ((Result<Response<AddFriendModel>, ErrorResult>) -> Void)) {
        self.connectToServer(.AddFriend, httpMethod: .POST, query: queryItems, completion: self.networkResult(completion: completion))
    }
    
    //MARK:- Accept Friend Api
    class func AcceptRequest(queryItems: Parameters, completion:@escaping ((Result<Response<AddFriendModel>, ErrorResult>) -> Void)) {
        self.connectToServer(.AcceptRequest, httpMethod: .POST, query: queryItems, completion: self.networkResult(completion: completion))
    }
    //MARK:- register Doctor
    class func registerDoctor(queryItems: Parameters, completion:@escaping ((Result<Response<NewDrSignUpUser>, ErrorResult>) -> Void)) {
        
        self.connectToServer(.DoctorRegister, httpMethod: .POST, query: queryItems, completion: self.networkResult(completion: completion))
    }
    
    //MARK:- GetDcotorNameList
    
    class func GetDoctorNameList(queryItems: Parameters, completion:@escaping ((Result<Response<DoctorListModel>, ErrorResult>) -> Void)) {
        
        self.connectToServer(.GetDoctorNameList, httpMethod: .POST, query: queryItems, completion: self.networkResult(completion: completion))
    }
        
}
