//
//  EnxCallManager.swift
//  SmileIndia
//
//  Created by Sakshi on 31/07/20.
//  Copyright © 2020 Na. All rights reserved.
//

import UIKit
import CallKit

import UserNotifications


class EnxCallManager: NSObject {
    
    var localNum = ""
    var remoteNum = ""
    
    var  object: Appointment?

    
    let callContr = CXCallController()
    func startCall(handle : String , roomID : String, video : Bool = true , local:String,remote:String ,obj:Appointment?) {
        
        self.localNum = local
        self.remoteNum = remote
        self.object = obj
        
        let handle = CXHandle(type: .phoneNumber, value: handle)
        let roomID = roomID;
        let startCall = CXStartCallAction(call: UUID(), handle: handle)
        startCall.isVideo = video
        let callTransaction = CXTransaction()
        callTransaction.addAction(startCall)
        requestCall(callTransaction, action: "startCall" , RoomId: roomID)
    }
    func endCall(call : EnxCall){
        let endCall = CXEndCallAction(call: call.uuid)
        let callTransaction = CXTransaction()
        callTransaction.addAction(endCall)
        requestCall(callTransaction, action: "endCall")
    }
    func setHeld(call : EnxCall , onHold : Bool){
        let handleCall = CXSetHeldCallAction(call: call.uuid, onHold: onHold)
        let callTransaction = CXTransaction()
        callTransaction.addAction(handleCall)
        requestCall(callTransaction, action: "holdCall")
    }
    private func requestCall(_ callTrans : CXTransaction , action : String = "" , RoomId : String = ""){
        callContr.request(callTrans){ error in
            if let error = error {
                print("Error requesting transaction: \(error)")
            } else {
                if(action == "startCall"){
                    // Handle Push Notification for start Call here and pass roomID through push notification to join the same room
                   //   print(self.object?.Id,self.object?.Room_Id,self.object?.Reason)
                  //  self.sendVideoAudioCallMessage(type: "start")
                    self.deleteNotifications()
                }
                else if(action == "endCall"){
                    // Handle Push Notification for End Call here
                   // self.deleteNotifications()
                  // self.sendVideoAudioCallMessage(type: "end")
                    NotificationCenter.default.post(name: NSNotification.Name("endCall"), object: nil)
                }
                print("Requested transaction \(action) successfully")
            }
        }
    }
    //Mark : Call Managment
    static let callsChangedNotification = Notification.Name("CallsChangedNotification")
    private(set) var calls = [EnxCall]()
    func callWithUUID(uuid : UUID) -> EnxCall?{
        if calls.count > 0 {
            return calls[0]
        }
        return nil
    }
    func addCall(_ call : EnxCall){
        calls.append(call)
        call.stateDidChange = {[weak self] in
            self?.postCallNotification()
        }
        postCallNotification()
    }
    func removeCall(_ Call : EnxCall){
        let index = calls.firstIndex(where: {
            $0 === Call
        })
        calls.remove(at: index!)
        postCallNotification()
    }
    func removeAllCalls(){
        calls.removeAll()
        postCallNotification()
    }
    private func postCallNotification(){
        NotificationCenter.default.post(name: type(of: self).callsChangedNotification, object: self)
    }
    
 func sendVideoAudioCallMessage(type:String) -> Void {
    guard let appdel = UIApplication.shared.delegate as? AppDelegate else {
        return
    }
    self.object = appdel.object
    
    let queryItems = ["message": self.object?.Room_Id ?? "","type": type,"uuid":"\(UUID())","AppointmentId":"\(self.object?.Id ?? 0)"]
    print(queryItems)
     WebService.sendVideoAudioCallMessage(queryItems: queryItems) { (result) in
             DispatchQueue.main.async {
                 switch result {
                 case .success(let response):
                     print(response.message ?? "")
                 case .failure(let error):
                     print(error.message)
                 }
             }
          }
 }
    
    func deleteNotifications() -> Void {
        if #available(iOS 10.0, *) {
            let center = UNUserNotificationCenter.current()
            center.removeAllPendingNotificationRequests() // To remove all pending notifications which are not delivered yet but scheduled.
            center.removeAllDeliveredNotifications() // To remove all delivered notifications
        } else {
            UIApplication.shared.cancelAllLocalNotifications()
        }
    }
    
}

