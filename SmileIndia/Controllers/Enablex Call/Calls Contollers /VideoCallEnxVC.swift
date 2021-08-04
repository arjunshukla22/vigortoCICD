//
//  VideoCallEnxVC.swift
//  SmileIndia
//
//  Created by Arjun  on 14/07/20.
//  Copyright © 2020 Na. All rights reserved.
//

import UIKit
import EnxRTCiOS
import Foundation

class VideoCallEnxVC: UIViewController {

    var remoteRoom : EnxRoom!
    var objectJoin : EnxRtc!
    var localStream : EnxStream!
    @IBOutlet weak var localPlayerView: EnxPlayerView!
 
    var  object: Appointment?
    var appointments = [Appointment]()
    

    var timer: Timer?
    var totalTime = 0

    @IBOutlet weak var timerLabel: UILabel!
    
    @IBOutlet weak var imgAppIcon: UIImageView!
    @IBOutlet weak var typeSegment: UISegmentedControl!
    
    var callType : Bool?
    
    var permissionCheck = true

    @IBOutlet weak var btnMuteAudio: UIButton!
    @IBOutlet weak var btnMuteVideo: UIButton!
    @IBOutlet weak var btnCamSwitch: UIButton!
    @IBOutlet weak var btnSpeaker: UIButton!
    
    
    @IBOutlet weak var optionsView: UIView!
    @IBOutlet weak var optionsContainerView: UIView!
 //   var endCheck = "0"
    var  timeDifference: TimeDifference?

    var activeTalkerView :UIView!

    override func viewDidLoad() {
        super.viewDidLoad()
        
        //   print(self.object?.Id,self.object?.Room_Id,self.object?.Reason)


        self.timerLabel.text = ""
        
        localPlayerView.layer.cornerRadius = 8.0
        localPlayerView.layer.borderWidth = 2.0
        localPlayerView.layer.borderColor = UIColor.clear.cgColor
        localPlayerView.layer.masksToBounds = true
        objectJoin = EnxRtc()
        self.createToken()
        // Do any additional setup after loading the view.
        
        // Adding Pan Gesture for localPlayerView
        let localViewGestureRecognizer = UIPanGestureRecognizer(target: self, action: #selector(didChangePosition))
        localPlayerView.addGestureRecognizer(localViewGestureRecognizer)
        
        NotificationCenter.default.addObserver(self, selector: #selector(callEnd), name: NSNotification.Name("endCall"), object: nil)
        
        if Authentication.customerType == "Doctor"{
        self.sendVideoAudioCallMessage(type: "start")
        }else if Authentication.customerType == "Customer"{
            self.mintuesDifference(apntId: "\(self.object?.Id ?? 0)")
        }
        
        
        deleteNotifications()
        
        if self.callType == true{
            self.btnCamSwitch.isHidden = true
            self.btnMuteVideo.isHidden = true
            self.typeSegment.isHidden = true
        }
        
        let titleTextAttributes = [NSAttributedString.Key.foregroundColor: UIColor.white]
        typeSegment.setTitleTextAttributes(titleTextAttributes, for: .normal)
        typeSegment.setTitleTextAttributes(titleTextAttributes, for: .selected)
        
        getPrivacyAccess()
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        let seconds = 5.0
        DispatchQueue.main.asyncAfter(deadline: .now() + seconds) {
            self.checkCameraAccess()
            self.checkMicAccess()
        }

    }

    func checkMicAccess(){
        switch AVCaptureDevice.authorizationStatus(for: .audio) {
        case .denied:
            print("Denied, request permission from settings")
            self.permissionDenied(text: "Microphone")
            self.permissionCheck = false

        case .restricted:
            print("Restricted, device owner must approve")
            self.permissionDenied(text: "Microphone")
            self.permissionCheck = false

        case .authorized:
            print("Authorized, proceed")
        case .notDetermined:
            AVCaptureDevice.requestAccess(for: .video) { success in
                if success {
                    print("Permission granted, proceed")
                } else {
                    print("Permission denied")
                    self.permissionDenied(text: "Microphone")
                    self.permissionCheck = false

                }
            }
        }
    }
    
    func checkCameraAccess() {
        switch AVCaptureDevice.authorizationStatus(for: .video) {
        case .denied:
            print("Denied, request permission from settings")
            self.permissionDenied(text: "Camera")
            self.permissionCheck = false

        case .restricted:
            print("Restricted, device owner must approve")
            self.permissionDenied(text: "Camera")
            self.permissionCheck = false

        case .authorized:
            print("Authorized, proceed")
        case .notDetermined:
            AVCaptureDevice.requestAccess(for: .video) { success in
                if success {
                    print("Permission granted, proceed")
                } else {
                    print("Permission denied")
                    self.permissionDenied(text: "Camera")
                    self.permissionCheck = false

                }
            }
        }
    }
    
    func permissionDenied(text:String){
        DispatchQueue.main.async{
                var alertText = "It looks like your privacy settings are preventing us from accessing your \(text) permission for calling. You can fix this by doing the following:\n\n1. Click the Go button below to open the Vigorto Settings.\n\n2. Turn on all the permissions to enjoy limitless features of Vigorto"

                var alertButton = AlertBtnTxt.okay.localize()
                var goAction = UIAlertAction(title: alertButton, style: .default, handler: nil)

                if UIApplication.shared.canOpenURL(URL(string: UIApplication.openSettingsURLString)!){
                    alertText = "It looks like your privacy settings are preventing us from accessing your \(text) permission for calling. You can fix this by doing the following:\n\n1. Click the Go button below to open the Vigorto Settings.\n\n2. Turn on all the permissions to enjoy limitless features of Vigorto"
                    alertButton = "Go"

                    goAction = UIAlertAction(title: alertButton, style: .default, handler: {(alert: UIAlertAction!) -> Void in
                        UIApplication.shared.open(URL(string: UIApplication.openSettingsURLString)!, options: [:], completionHandler: nil)
                    })
                }

                let alert = UIAlertController(title: "Permission Error!", message: alertText, preferredStyle: .alert)
                alert.addAction(goAction)
                self.present(alert, animated: true, completion: nil)
        }
    }

    
    private func getPrivacyAccess(){
        let vStatus = AVCaptureDevice.authorizationStatus(for: .video)
        if(vStatus == AVAuthorizationStatus.notDetermined){
            AVCaptureDevice.requestAccess(for: .video, completionHandler: { (granted: Bool) in
            })
        }
        let aStatus = AVCaptureDevice.authorizationStatus(for: .audio)
        if(aStatus == AVAuthorizationStatus.notDetermined){
            AVCaptureDevice.requestAccess(for: .audio, completionHandler: { (granted: Bool) in
            })
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
    
    @objc func callEnd(){
        DispatchQueue.main.async {
        self.deleteNotifications()
        self.leaveRoom()
        }
    }
     // MARK: - didChangePosition
     /**
         This method will change the position of localPlayerView
      Input parameter :- UIPanGestureRecognizer
      **/
    @objc func didChangePosition(sender: UIPanGestureRecognizer) {
         let location = sender.location(in: view)
         if sender.state == .began {
         } else if sender.state == .changed {
             if(location.x <= (UIScreen.main.bounds.width - (self.localPlayerView.bounds.width/2)) && location.x >= self.localPlayerView.bounds.width/2) {
                 self.localPlayerView.frame.origin.x = location.x
                 localPlayerView.center.x = location.x
             }
             if(location.y <= (UIScreen.main.bounds.height - (self.localPlayerView.bounds.height + 40)) && location.y >= (self.localPlayerView.bounds.height/2)+20){
                 self.localPlayerView.frame.origin.y = location.y
                 localPlayerView.center.y = location.y
             }
            
         } else if sender.state == .ended {
             print("Gesture ended")
         }
     }
    
    @IBAction func didtapCalltype(_ sender: UISegmentedControl) {
        if sender.selectedSegmentIndex == 0 {
            self.imgAppIcon.isHidden = true
            self.btnCamSwitch.isHidden = false
            self.btnMuteVideo.isHidden = false
            self.remoteRoom.setAudioOnlyMode(false) // Video call
        }else{
            self.imgAppIcon.isHidden = false
            self.btnCamSwitch.isHidden = true
            self.btnMuteVideo.isHidden = true
            self.remoteRoom.setAudioOnlyMode(true) // Audio call
        }
    }
    
    
    @IBAction func muteUnMuteEvent(_ sender: UIButton) {
        guard remoteRoom != nil else {
            return
        }
        
        if localStream != nil{
            if sender.isSelected {
                localStream.muteSelfAudio(false)
            }
            else{
                localStream.muteSelfAudio(true)
            }
            sender.isSelected = !sender.isSelected
        }
    }
    
    @IBAction func cameraOnOffEvent(_ sender: UIButton) {
        guard remoteRoom != nil else {
            return
        }
        if localStream != nil{
            if sender.isSelected {
                localStream.muteSelfVideo(false)
             //   self.imgAppIcon.isHidden = true
            }
            else{
                localStream.muteSelfVideo(true)
              //  self.imgAppIcon.isHidden = false
            }
            sender.isSelected = !sender.isSelected
        }

    }
    
    @IBAction func changeCameraAngle(_ sender: UIButton) {
        if localStream != nil {
            localStream.switchCamera()
        }
    }
    
    @IBAction func speakerOnOffEvent(_ sender: UIButton) {
        guard remoteRoom != nil else {
            return
        }
        if localStream != nil{
            if sender.isSelected {
                remoteRoom.switchMediaDevice("EARPIECE")
            }
            else{
                remoteRoom.switchMediaDevice("Speaker")
            }
            sender.isSelected = !sender.isSelected
        }

    }
    @IBAction func endCallEvent(_ sender: Any) {
        self.deleteNotifications()
        self.leaveRoom()
        if Authentication.customerType == "Customer"{
            endCall()
        }
    }
    private func leaveRoom(){
        UIApplication.shared.isIdleTimerDisabled = false
        self.sendVideoAudioCallMessage(type: "end")
        if remoteRoom != nil {
            remoteRoom?.disconnect()
        }
    }
    
    
    /*
    // MARK: - Navigation
    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */
    func createToken(){
        guard let appdel = UIApplication.shared.delegate as? AppDelegate else {
            return
        }
        let inputParam : [String : String] = ["name" :(Authentication.customerType == "Doctor" ? self.object?.ProviderName ?? "" : self.object?.MemberName) ?? "" , "role" :  Authentication.customerType == "Doctor" ? "moderator" : "participant" ,"roomId" :(Authentication.customerType == "Doctor" ? self.object?.Room_Id ?? "" : appdel.room_Id).replacingOccurrences(of: " ", with: ""), "user_ref" : "\(self.object?.Id ?? 0)"]
        
        VCXServicesClass.featchToken(requestParam: inputParam, completion:{token  in
            DispatchQueue.main.async {
                //  Success Response from server
                let videoSize : NSDictionary =  ["minWidth" : 320 , "minHeight" : 180 , "maxWidth" : 640, "maxHeight" :480]
                
                let playerConfiguration : NSDictionary = ["avatar":false,"audiomute":false, "videomute":false,"bandwidht":false, "screenshot":false,"iconColor" :"#3DDFAF"]
                let roomInfo: [String : Any]   = ["allow_reconnect" : true , "number_of_attempts" : 3, "timeout_interval" : 30,"playerConfiguration":playerConfiguration,"activeviews" : "view"]

             //   let roomInfo : [String : Any] = ["allow_reconnect" :true , "number_of_attempts" : 3 ,"timeout_interval" : 30,"activeviews" : "view"]

                let localStreamInfo : NSDictionary = ["video" : true ,"audio" : true  ,"data" :true ,"name" :(Authentication.customerType == "Doctor" ? self.object?.ProviderName ?? "" : self.object?.MemberName) ?? "","type" : "public","audio_only" : false ,"maxVideoBW" : 200 ,"minVideoBW" : 80 , "videoSize" : videoSize,"videoMuted":self.callType ?? false]
                guard let steam = self.objectJoin.joinRoom(token, delegate: self, publishStreamInfo: (localStreamInfo as! [AnyHashable : Any]), roomInfo: roomInfo, advanceOptions: nil) else{
                        return
                    }
                self.localStream = steam
                self.localStream.delegate = self as EnxStreamDelegate
            }
        })
    }
    
    fileprivate func endCall(){
        guard let appdel = UIApplication.shared.delegate as? AppDelegate else {
            return
        }
        for call in appdel.callManager.calls{
            appdel.callManager.endCall(call: call)
        }
    }
    
    

}
/*
 // MARK: - Extension
 Delegates Methods
 */
extension VideoCallEnxVC : EnxRoomDelegate, EnxStreamDelegate {
    //Mark - EnxRoom Delegates
    /*
     This Delegate will notify to User Once he got succes full join Room
     */
    func room(_ room: EnxRoom?, didConnect roomMetadata: [AnyHashable : Any]?) {
//        hasConnected = true
//        startCallCompletion?(true)
//        answCallCompletion?(true)
        
        UIApplication.shared.isIdleTimerDisabled = true
        
        if self.callType == false{
        self.imgAppIcon.isHidden = true
        }
        
        remoteRoom = room
        if localStream != nil{
             remoteRoom.publish(localStream)
        }
        if remoteRoom.isRoomActiveTalker{
            localStream.attachRenderer(localPlayerView)
            localPlayerView.contentMode = UIView.ContentMode.scaleAspectFill
        }

    }
    
    
    
    /*
     This Delegate will notify to User Once he Getting error in joining room
     */
     func room(_ room: EnxRoom?, didError reason: [Any]?) {
      //  self.leaveRoom()
        print(String(describing: reason))
      //  AlertManager.showAlert(type: .custom("\(String(describing: reason))"))
    }
    /*
     This Delegate will notify to  User Once he Publisg Stream
     */
    func room(_ room: EnxRoom?, didPublishStream stream: EnxStream?) {
        //To Do
    }
    /*
     This Delegate will notify to  User Once he Unpublisg Stream
     */
    func room(_ room: EnxRoom?, didUnpublishStream stream: EnxStream?) {
        //To Do
    }
    /*
     This Delegate will notify to User if any new person added to room
     */
    func room(_ room: EnxRoom?, didAddedStream stream: EnxStream?) {
        if self.callType == false{
        self.imgAppIcon.isHidden = true
        }
        room!.subscribe(stream!)
    }
    /*
     This Delegate will notify to User if any new person Romove from room
     */
    func room(_ room: EnxRoom?, didRemovedStream stream: EnxStream?) {
        //To Do
    }
    /*
     This Delegate will notify to User to subscribe other user stream
     */
    func room(_ room: EnxRoom?, didSubscribeStream stream: EnxStream?) {
        //To Do
    }
    /*
     This Delegate will notify to User to Unsubscribe other user stream
     */
    func room(_ room: EnxRoom?, didUnSubscribeStream stream: EnxStream?) {
        //To Do
    }
    /*
     This Delegate will notify to User if Room Got discunnected
     */
    func didRoomDisconnect(_ response: [Any]?) {
        if Authentication.customerType == "Customer"{
            endCall()
        }
        NavigationHandler.pop()
    }
    func roomDidDisconnected(_ status: EnxRoomStatus) {

    }
    /*
     This Delegate will notify to User if any person join room
     */
    
    func room(_ room: EnxRoom?, userDidJoined Data: [Any]?) {
        //listOfParticipantInRoom.append(Data!)
        print("Start timer here.")
        self.mintuesDifference(apntId: "\(self.object?.AppointmentId ?? 0)")
    }
    /*
     This Delegate will notify to User if any person got discunnected
     */
    func room(_ room: EnxRoom?, userDidDisconnected Data: [Any]?) {
        self.deleteNotifications()
        self.leaveRoom()
    }
    /*
     This Delegate will notify to User if any person got discunnected
     */
    func room(_ room: EnxRoom?, didChange status: EnxRoomStatus) {
        //To Do
    }
    /*
     This Delegate will notify to User once any stream got publish
     */
    func room(_ room: EnxRoom?, didReceiveData data: [AnyHashable : Any]?, from stream: EnxStream?) {
        //To Do
    }
    /*
     This Delegate will notify to User to get updated attributes of particular Stream
     */
    func room(_ room: EnxRoom?, didUpdateAttributesOf stream: EnxStream?) {
        //To Do
    }
    /*
     This Delegate will notify to User if any new User Reconnect the room
     */
    func room(_ room: EnxRoom?, didReconnect reason: String?) {
        //To Do
    }
    /*
     This Delegate will notify to User with active talker list
     */
    func room(_ room: EnxRoom?, activeTalkerList Data: [Any]?) {
     //   self.view.addSubview(view!)
     //   self.view.sendSubviewToBack(view)
    }
    
    func room(_ room: EnxRoom?, didActiveTalkerView view: UIView?) {
        activeTalkerView = view!
        self.view.addSubview(activeTalkerView)
        bringSubViewToFront()
    }
    private func bringSubViewToFront(){
         if(activeTalkerView != nil){
         self.view.bringSubviewToFront(activeTalkerView)
        }
        self.view.bringSubviewToFront(localPlayerView)
        self.view.bringSubviewToFront(optionsContainerView)
        self.mintuesDifference(apntId: "\(self.object?.AppointmentId ?? 0)")
    }
    
    func room(_ room: EnxRoom?, didEventError reason: [Any]?) {
        //let resDict = reason![0] as! [String : Any]
        print(reason as Any)
    }
    
    //Mark- EnxStreamDelegate Delegate
    /*
     This Delegate will notify to current User If User will do Self Stop Video
     */
    func stream(_ stream: EnxStream?, didSelfMuteVideo data: [Any]?) {
        //To Do
    }
    func stream(_ stream: EnxStream?, didRemoteStreamVideoMute data: [Any]?) {
        //To Do
    }
    /*
     This Delegate will notify to current User If User will do Self Start Video
     */
    func stream(_ stream: EnxStream?, didSelfUnmuteVideo data: [Any]?) {
        //To Do
    }
    
    func stream(_ stream: EnxStream?, didRemoteStreamVideoUnMute data: [Any]?) {
        //To Do
    }
    /*
     This Delegate will notify to current User If User will do Self Mute Audio
     */
    func stream(_ stream: EnxStream?, didSelfMuteAudio data: [Any]?) {
        //To Do
    }
    func stream(_ stream: EnxStream?, didRemoteStreamAudioMute data: [Any]?) {
        //To Do
    }
    /*
     This Delegate will notify to current User If User will do Self UnMute Audio
     */
    func stream(_ stream: EnxStream?, didSelfUnmuteAudio data: [Any]?) {
        //To Do
    }
    func stream(_ stream: EnxStream?, didRemoteStreamAudioUnMute data: [Any]?) {
         //To Do
    }
    /*
     This Delegate will notify to current User If any user has stoped There Video or current user Video
     */
    func didVideoEvents(_ data: [AnyHashable : Any]?) {
        //To Do
    }
    /*
     This Delegate will notify to current User If any user has stoped There Audio or current user Video
     */
    func didAudioEvents(_ data: [AnyHashable : Any]?) {
        //To Do
    }
    
    func room(_ room: EnxRoom?, didConferencessExtended data: [Any]?) {
        // time extend
    }

    func room(_ room: EnxRoom?, didConferenceRemainingDuration data: [Any]?) {
        // time extend
//        if Authentication.customerType == "Doctor"{
//        self.deleteNotifications()
//        self.leaveRoom()
//        }
    }
    
    func sendVideoAudioCallMessage(type:String) -> Void {
        let queryItems = ["message": self.object?.Room_Id ?? "","type": type,"uuid":"\(UUID())","AppointmentId":"\(self.object?.Id ?? 0)","videoMuted":"\(self.callType ?? false)"] as [String : Any]
        WebService.sendVideoAudioCallMessage(queryItems: queryItems) { (result) in
                DispatchQueue.main.async {
                    switch result {
                    case .success(let response):
                        print(response.message ?? "")
//                        if type == "end"{
//                            self.endCheck = "1"
//                        }
                    case .failure(let error):
                        print(error.message)
                    }
                }
             }
    }
    
    func getMintuesDifference(currentTime:String,apntTime:String){
        let queryItems = ["CurrentTime":currentTime ,"AppointmentDateAndTime":apntTime]
           WebService.getMintuesDifference(queryItems: queryItems) { (result) in
               DispatchQueue.main.async {
                   switch result {
                   case .success(let response):
                    self.timeDifference = response.object
                    self.totalTime = -1800 + Int(response.object?.TotalSeconds ?? 0.0)
                    self.startOtpTimer()
                   case .failure:
                       self.timer?.invalidate()
                       self.deleteNotifications()
                       self.leaveRoom()
                }
               }
           }
       }
    
    func mintuesDifference(apntId:String){
        let queryItems = ["AppointmentId":apntId]
           WebService.mintuesDifference(queryItems: queryItems) { (result) in
               DispatchQueue.main.async {
                   switch result {
                   case .success(let response):
                    self.timeDifference = response.object
                    self.totalTime = -1800 + Int(response.object?.TotalSeconds ?? 0.0)
                    self.startOtpTimer()
                   case .failure:
                       self.timer?.invalidate()
                     /*  if Authentication.customerType == "Doctor"{
                        self.deleteNotifications()
                        self.leaveRoom()
                       } */
                }
               }
           }
       }
}


extension VideoCallEnxVC{
    
    private func startOtpTimer() {
    self.timer = Timer.scheduledTimer(timeInterval: 1.0, target: self, selector: #selector(updateTimer), userInfo: nil, repeats: true)
       }
    @objc func updateTimer() {
        self.timerLabel.text = "Your Call Ends In "+self.timeFormatted(self.totalTime)
            if totalTime < 0 {
                totalTime += 1
            } else {
                if let timer = self.timer {
                    DispatchQueue.main.async {
                        timer.invalidate()
                        self.deleteNotifications()
                        self.leaveRoom()
                    }
                }
            }
        }
    func timeFormatted(_ totalSeconds: Int) -> String {
        let seconds: Int = totalSeconds % 60
        let minutes: Int = (totalSeconds / 60) % 60
      //  let hours: Int = (totalSeconds / 3600)
        return String(format: "%02d:%02d",minutes, seconds).replacingOccurrences(of: "-", with: "")
    }
}

