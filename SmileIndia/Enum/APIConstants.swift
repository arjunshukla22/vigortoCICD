//
//  API.swift
//  XRentY
//
//  Created by user on 25/06/18.
//  Copyright © 2018 user. All rights reserved.
//

import Foundation

enum APIConstants: String {
    static let pathLocal = "http://qa.smileindia.com/Api/"
    static let pathLive = "https://vigorto.com/"
    static let pathDigitech = "http://smileindia.digitech.in/Api/"
    static let pathTest = "http://qa.vigorto.com/"
    static let path82 = "http://vigorto.com:82/"
    
   static let mainUrl = path82 // for testing using this Url

  //  static let mainUrl = pathLive // for Live  using this Url
    // MARK:- API Constant Name
    case login = "userlogin"
    case register = "Signup"
    case forgotPassword = "ForgotPassword"
    case changePassword = "ChangePasswordDoctor"
    case title = "GetTitle"
    case gender = "GetGender"
    case speciality = "GetSpeciality"
    case degree = "GetDegree"
    case country = "GetCountries"
    case state = "GetStatebycountryId"
    case city = "GetCity"
    case allCity = "GetAllCities"
    case timezone = "GetAllTimeZone"
    case ustimezone = "GetAllDoctorTimeZone"
    case businessHours = "GetBusinessHours"
    case findDoctor = "Findadoctor"
    case getDoctor = "GetDoctorProfile"
    case uploadFile = "UploadFile"
    case updateDoctorProfile = "UpdateDoctorProfile"
    case verifyMembershipCard = "VerifyMembershipCard"
    case memberRegistration = "Save_Member_Api"
    case memberProfileDataView = "MemberProfileDataView"
    case memberProfileDataUpdate = "MemberProfileDataUpdate"
    case viewMemberCard = "ViewMemberCard"
    case familyMemberDataView = "FamilyMemberDataView"
    case familyMemberDataUpdate = "FamilyMemberDataUpdate"
    case changePasswordMember = "ChangePasswordMember"
    case getNextSevenDaysDates = "GetNextSevenDaysDates"
    case bookAppointment = "BookAppointment"
    case getBookAppointmentTiming = "GetBookAppointmentTiming"
    case manageMemberAppointment = "Managememberappointment"
    case cancelMemberAppointment = "Cancelmemberappointment"
    case canceldoctorappointment = "Canceldoctorappointment"
    case managePendingDoctorAppointments = "ManagePendingDoctorappointments"
    case manageConfirmedAppointments = "ManageConfirmedAppointments"
    case deleteMemberAppointment = "DeleteMemberAppointment"
    case deleteDoctorAppointment = "DeleteDoctorAppointment"
    case savedoctorNotes = "SavedoctorNotes"
    case manageDoctorAppointment = "ManageDoctorappointment"
    case manageMemberappointment = "ManageMemberappointment"
    case showrating = "Showrating"
    case rateproviders = "Rateproviders"
    case getRatedAppointments = "GetRatedAppointments"
    case SaveToekn = "SaveToekn"
    case getAppointmentNoAndAge = "GetAgeAndPastAppointmentIdByProviderId"
    case getRewards = "GetRewardPoints"
    case replyroviders = "DoctorReply"
    case doctorAppointmentdetails = "CheckDoctorAppointmentDetail"
    case createRazorPayOrder = "CreateRazorPayOrder"
    case savePaymentInformation = "SavePaymentInformation"
    case getAccountDetails = "GetAccountDetails"
    case saveBankAccount = "SaveBankAccount"
    case saveUPI = "SaveUPI"
    case myCalendar = "MYCalendar"
    case getIsCloseFullDay = "GetIsCloseFullDay"
    case saveIsCloseFullDay = "SaveIsCloseFullDay"
    case createPrescriptionTemplate = "InsertPrescriptionTemplates"
    case getPrescriptionTemplates = "GetPrescriptionTemplates"
    case deletePrescriptionTemplate = "DeletePrescriptionTemplate"
    case uploadMemberFiles = "UploadMemberFiles"
    case getMemberFiles = "GetMemberFiles"
    case deleteMemberFilebyId = "DeleteMemberFilebyId"
    case uploadSignature = "UploadSignature"
    case getSignature = "GetSignature"
    case contactus = "ContactUs"
    case uploadDoctorPrescriptionFiles = "UploadDoctorPrescriptionFiles"
    case addDoctorPrescription = "AddDoctorPrescription"
    case getDoctorPrescription = "GetDoctorPrescription"
    case getDoctorPrescriptionFiles = "GetDoctorPrescriptionFiles"
    case isExist = "IsExist"
    case plans = "Plans"
    case planDetail = "PlanDetail"
    case doctorPlanDetails = "DoctorPlanDetails"
    case cancelSubscription = "CancelSubscription"
    case buyplan = "Buyplan"
    case registerDevice = "RegisterDevice"
    case sendVideoAudioCallMessage = "SendVideoAudioCallMessage"
    case getAppointmentDataForIOSVideoCall = "GetAppointmentDataForIOSVideoCall"
    case PaidDoctorPlans = "PaidDoctorPlans"
    case patientNotAvailable = "PatientNotAvailable"
    case doctorNotAvailable = "DoctorNotAvailable"
    case enableX_CreateToken = "EnableX_CreateToken"
    case allowedRefundOption = "AllowedRefundOption"
    case initiateRefund = "InitiateRefund"
    case createPaymentIntent = "CreatePaymentIntent"
    case isCheckFreeAppointments = "IsCheckFreeAppointments"
    case isCheckMemberAddress = "IsCheckMemberAddress"
    case UploadLocalAddress = "UploadLocalAddress"
    case getRoomInfo = "GetRoomInfo"
    case UploadVerficationFile = "UploadVerficationFile"
    case insurancesProvidersList = "InsurancesProvidersList"
    case insuranceAddedOrRemove = "InsuranceAddedOrRemove"
    case deleteDeviceToken = "DeleteDeviceToken"
    case IsCheckVerificationDocumentsStatus = "IsCheckVerificationDocumentsStatus"
    case insurancesProvidersAndPlans = "InsurancesProvidersAndPlans"
    case getMintuesDifference = "GetMintuesDifference"
    case isCheckDoctorAcceptedInsurance = "IsCheckDoctorAcceptedInsurance"
    case uploadInsuranceCard = "UploadInsuranceCard"
    case enableAppointmentWithoutPayment = "EnableAppointmentWithoutPayment"
    case GenerateEphemeralKey = "GenerateEphemeralKey"
    case subscriptionCallbackAPI = "SubscriptionCallbackAPI"
    case subscriptionCancelAPI = "SubscriptionCancelAPI"
    case subscriptionUpgradeAPI = "SubscriptionUpgradeAPI"
    
    case getVigortoCredits = "GetSmileIndiaCredits"
    case mintuesDifference = "MintuesDifference"
    case addPost = "AddPost"
    case getAllBlogsList = "GetAllBlogsList"
    case GetSpecialityFoSocio = "GetSpecialityFoSocio"
    case customerInfo = "CustomerInfo"
    case AddPostLikeStatus = "AddPostLikeStatus"
    case DeletePost = "DeletePost"
    // Comments
    case BlogPostComments = "BlogPostComments"
    case AddBlogPostComment = "AddBlogPostComment"
    case DeleteComment = "DeleteComment"
    case socioProfile = "Profile"
    
    // Socio
    case AddFriend = "AddFriend"
    case AcceptRequest = "AcceptRequest"
    
    // new signup
    case DoctorRegister = "DoctorRegister"
    
    case GetDoctorNameList = "GetDoctorNameList"
    
    var url: String {
        if rawValue == "MYCalendar" || rawValue == "CreatePaymentIntent" || rawValue ==  "GetMintuesDifference" || rawValue ==  "GenerateEphemeralKey" || rawValue ==  "SubscriptionCallbackAPI" ||  rawValue == "SubscriptionCancelAPI" ||  rawValue == "SubscriptionUpgradeAPI" ||  rawValue == "MintuesDifference"{
            return APIConstants.mainUrl + "Customer/"+rawValue
        }
        else if rawValue == "Profile"{
           // return APIConstants.path82 + "Social/"+rawValue
            return APIConstants.mainUrl + "Social/"+rawValue
        }
        else {
          //  return APIConstants.path82 + "Api/"+rawValue
            return APIConstants.mainUrl + "Api/"+rawValue
        }
    
    }
}
