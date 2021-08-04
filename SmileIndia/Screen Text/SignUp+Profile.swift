//
//  SignUp+Profile.swift
//  SmileIndia
//
//  Created by Arjun  on 29/06/21.
//  Copyright © 2021 Na. All rights reserved.
//

import Foundation

enum ProfileUpdate {
    
    enum Alert {
        static let completeProfile = "Complete your profile to use the Vigorto services!"
        static let defaulter = "You have been Temporarily blocked from the Vigorto Portal. Please contact Vigorto Support 1-844-844-6786"
        
        static let editMsg = "Are you sure you want to exit the edit profile ?"
        
    }
    
    static let firstName = "First Name Is Required."
    static let lastName = "Last Name Is Required."
    static let gender = "Gender Is Required."
    static let clinicPractice = "Clinic/Practice Name Is Required."
    static let specility = "Speciality Is Required."
    static let otherSpecility = "Other Speciality Is Required."
    static let registeration = "Registration Is Required."
    static let degree = "Degree Is Required."
    static let otherDegree = "Other Degree Is Required."
    static let Email = "Email Is Required."
    
    // Profile For 2 Screen
    static let pinCode = "Pin Code Is Required."
    static let NPIMINC = "NPI/MINC Number Is  Required."
    static let validDEA = "Please Enter Valid DEA No."
    static let country = "Country Is Required."
    static let timeZone = "TimeZone Is Required."
    static let State = "State Is Required."
    static let city = "City Is Required."
    static let address = "Address Is Required."
    static let address2 = "Address Line 2 Is Required."
    static let consultationFee = "Consultation Fee is required"
    static let consultFeeless = "Consultation Fee should not be less than 1$"
    static let insuredTreatment = "Please Enter Uninsured Treatment Discount Value Greater Than Or Equal To 1."
    static let UnisuredTreatDisc = "Please Enter Uninsured Treatment Discount Value Less Than Or Equal To 100."
    static let priceReq = "Price For Member is required"
    static let priceMember = "Price for Member should not be less than 1$"
    static let priceConsultFee = "Price for Member Should be Less Than Consultation fee."
    static let validurl = "Enter valid url for the website."
    static let mobilenumber = "Mobile No. Is Required."
    static let validPhnNumber = "Please Enter Valid Phone No."
    static let experience = "Experience Is Required."
    static let experValue = "Please Enter Experience Value Less Than Or Equal To 99."
    static let validZipPOCode = "Please Enter Valid Zip / PO Code"
    static let validUpdate = "Are you sure to update the profile?"
    
    
    // Morning Hours Screen
    
    static let mngEvgTimeLower = "Morning end timings cannot be lower than or similar to morning start timings"
    
    // Update Evg Hours Screen
    static let selectOneDayWeek = "Please select atleast one day of week."
    static let areYouSureUpdateProfile = "Are you sure to update the profile?"
    static let evgTimeCanNot = "Evening end timings cannot be lower than or similar to evening start timings."
    
    static let profileUpdateSucess = "Profile Updated Successfully"
    
    
    // New Doctor Sign Up
    
    static let aceeptTermsConditions = "Kindly accept terms and conditions."
    static let referralCode = "Please Enter a valid Referral Code"
    static let acceptHIPAA = "Kindly accept Vigorto's Hipaa Authorization."
    
    
    static let TcPrivacypolicy = "By clicking next, you agree to Vigorto's \(termsCondition) and \(PrivacyPolicy)"
    static let hipaaAuthorization = "By clicking next, you agree to Vigorto's \(HipaaTxt)"
    
    static let HipaaTxt = "HIPAA Authorization"
    static let termsCondition = "Terms & Conditions"
    static let PrivacyPolicy = "Privacy Policy"
    static let dobValidation = "Date of Birth Is Required."

}
