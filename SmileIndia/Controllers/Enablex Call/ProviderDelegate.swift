//
//  ProviderDelegate.swift
//  SmileIndia
//
//  Created by Sakshi on 31/07/20.
//  Copyright © 2020 Na. All rights reserved.
//

import UIKit
import AVFoundation
import CallKit
import Foundation

class ProviderDelegate: NSObject, CXProviderDelegate {
    let callManager : EnxCallManager
    private let provider : CXProvider
    var outgoingCall : EnxCall?
    var answerCall : EnxCall?
    
    init(callManager : EnxCallManager) {
        self.callManager = callManager
        provider = CXProvider(configuration: type(of: self).providerConfiguration)
        super.init()
        provider.setDelegate(self as? CXProviderDelegate, queue: nil)
    }
    static var providerConfiguration : CXProviderConfiguration{
        let providerConfiguration = CXProviderConfiguration(localizedName: "SmileIndia")
        providerConfiguration.supportsVideo = true
        providerConfiguration.includesCallsInRecents = true
        providerConfiguration.maximumCallsPerCallGroup = 1
        providerConfiguration.supportedHandleTypes = [.phoneNumber]
        let icon = UIImage(named: "smileindia_new")
        providerConfiguration.iconTemplateImageData = icon?.pngData()
        providerConfiguration.ringtoneSound = "callTone.caf"
        return providerConfiguration;
    }
    

    //MARK : Incoming Calls events
    
    func reportIncomingCalls(uuid: UUID , handle : String , hasVideo :Bool = true , completion: ((NSError?) -> Void)? = nil){
        let update = CXCallUpdate()
        update.remoteHandle = CXHandle(type: .phoneNumber, value: handle)
        update.hasVideo = hasVideo
        
        provider.reportNewIncomingCall(with: uuid, update: update) { error in
            
            print(error?.localizedDescription)
            if error == nil {
                let call = EnxCall(uuid: uuid)
                call.handle = handle
                self.callManager.addCall(call)
            }
            completion?(error as NSError?)
        }
    }
    func senddefaultAudioInterruptionNofificationToStartAudioResource(){
        var userInfo : [AnyHashable : Any] = [:]
        let intrepEndeRaw = AVAudioSession.InterruptionType.ended.rawValue
        userInfo[AVAudioSessionInterruptionTypeKey] = intrepEndeRaw
        NotificationCenter.default.post(name: AVAudioSession.interruptionNotification, object: self, userInfo: userInfo)
    }
    func configurAudioSession(){
        let session = AVAudioSession.sharedInstance()
        do{
            try session.setCategory(AVAudioSession.Category.playAndRecord, mode: .default)
            try session.setActive(true)
            try session.setMode(AVAudioSession.Mode.voiceChat)
            try session.setPreferredSampleRate(44100.0)
            try session.setPreferredIOBufferDuration(0.005)
        }catch{
            print(error)
        }
    }
}
// MARK : CXProviderDelegate

extension ProviderDelegate {
    func providerDidReset(_ provider: CXProvider) {
        for call in callManager.calls{
            call.endCall()
        }
        callManager.removeAllCalls()
    }
    func provider(_ provider: CXProvider, perform action: CXStartCallAction) {
        let call = EnxCall(uuid: action.callUUID, isOutgoing: true)
        call.handle = action.handle.value
        configurAudioSession()
        call.hasStartedConnectDidChange = { [weak self] in
            self?.provider.reportOutgoingCall(with: call.uuid, startedConnectingAt: call.connectData)
        }
        call.hasConnectDidChange = { [weak self] in
            self?.provider.reportOutgoingCall(with: call.uuid, startedConnectingAt: call.connectedData)
        }
        self.outgoingCall = call;
        action.fulfill()
    }
    func provider(_ provider: CXProvider, perform action: CXAnswerCallAction) {
        guard let call = callManager.callWithUUID(uuid: action.callUUID) else{
            action.fail()
            return
        }
        let appdel = UIApplication.shared.delegate as? AppDelegate
        NavigationHandler.pushTo(.enxVideoCalls((appdel?.object)!, NSString(string:appdel?.videoMuted ?? "false").boolValue))
        
        self.getRoomInfo(roomId: appdel?.object?.Room_Id ?? "")
        
        configurAudioSession()
        self.answerCall = call
        action.fulfill()
    }
    func provider(_ provider: CXProvider, perform action: CXEndCallAction) {
        self.deleteNotifications()
        guard let call = callManager.callWithUUID(uuid: action.callUUID) else {
            action.fail()
            return
        }
        call.endCall()
        action.fulfill()
        callManager.removeCall(call)
    }
    func provider(_ provider: CXProvider, perform action: CXSetHeldCallAction) {
        guard let call = callManager.callWithUUID(uuid: action.callUUID) else {
            action.fail()
            return
        }
        call.isOnHild = action.isOnHold
        call.isMuted = action.isOnHold
        action.fulfill()
    }
    func provider(_ provider: CXProvider, perform action: CXSetMutedCallAction) {
        guard let call = callManager.callWithUUID(uuid: action.callUUID) else {
            action.fail()
            return
        }
        call.isMuted = action.isMuted
        action.fulfill()
    }
    func provider(_ provider: CXProvider, timedOutPerforming action: CXAction) {
        print("Timed out Action")
    }

        
    func provider(_ provider: CXProvider, didActivate audioSession: AVAudioSession) {
        print("Receive \(#function)")
        if(answerCall?.hasConnected ?? false){
            senddefaultAudioInterruptionNofificationToStartAudioResource()
            return
        }
        if(outgoingCall?.hasConnected ?? false){
            senddefaultAudioInterruptionNofificationToStartAudioResource()
            return
        }
        outgoingCall?.startCall(withAudioSession: audioSession) {success in
            if success {
                self.callManager.addCall(self.outgoingCall!)
                self.outgoingCall?.startAudio()
            }
        }
        answerCall?.ansCall(withAudioSession: audioSession) { success in
            if success{
                self.answerCall?.startAudio()
            }
        }
    }
    func provider(_ provider: CXProvider, didDeactivate audioSession: AVAudioSession) {
        print("Deactivate \(#function)")
        if outgoingCall?.isOnHild ?? false || answerCall?.isOnHild ?? false{
            print("Call is on hold")
            return
        }
        outgoingCall?.endCall()
        if(outgoingCall != nil){
            outgoingCall = nil
        }
        answerCall?.endCall()
        if(answerCall != nil){
            answerCall = nil
        }
        callManager.removeAllCalls()
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
    
    func getRoomInfo(roomId:String) -> Void {
        let queryItems = ["RoomId": roomId]
                 WebService.getRoomInfo(queryItems: queryItems) { (result) in
                         DispatchQueue.main.async {
                             switch result {
                             case .success(let response):
                                print(response.resultString ?? "")
                             case .failure(let error):
                                 print(error.message)
                             }
                         }
                      }
    }
}
