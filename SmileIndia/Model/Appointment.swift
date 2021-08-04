//
//  Appointment.swift
//  SmileIndia
//
//  Created by Na on 17/07/19.
//  Copyright © 2019 Na. All rights reserved.
//

import Foundation
final class Appointment: NSObject, Decodable {
//    var imageURL: URL? {
//        guard let urlString = ImageName else { return nil }
//        return URL(string: urlString.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) ?? "")
//    }
    let  Id,AppointmentId, MemberId, Memeberid, PastappointmentId ,MeetType,Age,AppointmentFor,RefundTakenAction, InsurancePlanId ,PaymentType: Int?
    let AppointmentDateTime, AppointmentTime, CreateDate, CreatedDate, DoctorNotes, MemberEmail,MemberPhone, MemberName, ProviderEmail, ProviderId, ProviderName, Reason, UpdateDate, Review,Reviews,Status, Rating,BookingDate,DoctorReply,AppointmentMessage,Room_Id ,Latitude,Longitude,OtherPatientRelation,OtherPatinetName,InsuranceCardPic,InsurancePlanName,DoctorTimeZoneId,PatientTimeZoneId,CreateDateForApi : String?
    let  IsNotAvailable,IsRefundAllowed, IsRescheduleBtn,IsDeleteAllowed : Bool?
    
    
    init(Id: Int?, AppointmentId: Int?,Memeberid:Int?, ProviderId: String?, MemberId: Int?, Status: String?, MemberName: String?, MemberEmail: String?, PastappointmentId: Int?, ProviderName: String?, ProviderEmail: String?, Reason: String?, Age: Int?, AppointmentTime: String?, CreateDate: String?, BookingDate: String?, UpdateDate: String?, AppointmentDateTime: String?, DoctorNotes: String?, Rating: String?, Reviews: String?, MemberPhone: String?, IsRescheduleBtn: Bool?, DoctorReply: String?, MeetType: Int?, AppointmentMessage: String?, DoctorTimeZoneId: String?, PatientTimeZoneId: String?, Latitude: String?, Longitude: String?, AppointmentFor: Int?, OtherPatientRelation: String?, OtherPatinetName: String?, IsRefundAllowed: Bool?, IsDeleteAllowed: Bool?, IsNotAvailable: Bool?, RefundTakenAction: Int?, InsurancePlanId: Int?, InsurancePlanName: String?, InsuranceCardPic: String?, PaymentType: Int?, CreateDateForApi: String?,CreatedDate:String?,Room_Id:String?,Review:String?) {
        
        
        self.Id = Id
        self.AppointmentId = AppointmentId
        self.Memeberid = Memeberid
        self.ProviderId = ProviderId
        self.MemberId = MemberId
        self.Status = Status
        self.MemberName = MemberName
        self.MemberEmail = MemberEmail
        self.PastappointmentId = PastappointmentId
        self.ProviderName = ProviderName
        self.ProviderEmail = ProviderEmail
        self.Reason = Reason
        self.Age = Age
        self.AppointmentTime = AppointmentTime
        self.CreateDate = CreateDate
        self.BookingDate = BookingDate
        self.UpdateDate = UpdateDate
        self.AppointmentDateTime = AppointmentDateTime
        self.DoctorNotes = DoctorNotes
        self.Rating = Rating
        self.Reviews = Reviews
        self.MemberPhone = MemberPhone
        self.IsRescheduleBtn = IsRescheduleBtn
        self.DoctorReply = DoctorReply
        self.MeetType = MeetType
        self.AppointmentMessage = AppointmentMessage
        self.DoctorTimeZoneId = DoctorTimeZoneId
        self.PatientTimeZoneId = PatientTimeZoneId
        self.Latitude = Latitude
        self.Longitude = Longitude
        self.AppointmentFor = AppointmentFor
        self.OtherPatientRelation = OtherPatientRelation
        self.OtherPatinetName = OtherPatinetName
        self.IsRefundAllowed = IsRefundAllowed
        self.IsDeleteAllowed = IsDeleteAllowed
        self.IsNotAvailable = IsNotAvailable
        self.RefundTakenAction = RefundTakenAction
        self.InsurancePlanId = InsurancePlanId
        self.InsurancePlanName = InsurancePlanName
        self.InsuranceCardPic = InsuranceCardPic
        self.PaymentType = PaymentType
        self.CreateDateForApi = CreateDateForApi
        self.CreatedDate = CreatedDate
        self.Room_Id = Room_Id
        self.Review = Review
    }

}
extension Appointment: Parceable {
    
    static func parseObject(dictionary: [String : AnyObject]) -> Appointment? {
        
        let data = try? JSONSerialization.data(withJSONObject: dictionary, options: .prettyPrinted)
        guard data != nil else {
            debugPrint("unable to parse: Appointment")
            return nil
        }
        do {
            let decoder = JSONDecoder()
            let user = try decoder.decode(Appointment.self, from: data!)
            return user
        }
        catch {
            print("unable to decode model: Appointment")
            return nil
        }
    }
}




final class AppointmentIdAndAge: NSObject, Decodable {

    let PastAppointmentId, Age : Int?
}
extension AppointmentIdAndAge: Parceable {
    
    static func parseObject(dictionary: [String : AnyObject]) -> AppointmentIdAndAge? {
        let data = try? JSONSerialization.data(withJSONObject: dictionary, options: .prettyPrinted)
        guard data != nil else {
            debugPrint("unable to parse: Appointment")
            return nil
        }
        do {
            let decoder = JSONDecoder()
            let user = try decoder.decode(AppointmentIdAndAge.self, from: data!)
            return user
        }
        catch {
            print("unable to decode model: Appointment")
            return nil
        }
    }
}


final class AppointmentCheckOut: NSObject, Decodable {

    let AppointmentId, TotalAmount,ConsultationAmount,TaxAmount,SmileIndiaCredits : Int?
}
extension AppointmentCheckOut: Parceable {
    
    static func parseObject(dictionary: [String : AnyObject]) -> AppointmentCheckOut? {
        let data = try? JSONSerialization.data(withJSONObject: dictionary, options: .prettyPrinted)
        print(data as Any)
        print(dictionary as Any)

        guard data != nil else {
            debugPrint("unable to parse: AppointmentCheckOut")
            return nil
        }
        do {
            let decoder = JSONDecoder()
            let user = try decoder.decode(AppointmentCheckOut.self, from: data!)
            return user
        }
        catch {
            print("unable to decode model: AppointmentCheckOut")
            return nil
        }
    }
}


