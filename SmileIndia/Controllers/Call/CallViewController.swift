////
////  CallViewController.swift
////  SmileIndia
////
////  Created by Arjun  on 02/04/20.
////  Copyright © 2020 Na. All rights reserved.
////
//
//import UIKit
//import Sinch
//
//enum EButtonsBar: Int {
//    case decline
//    case hangup
//}
//
//
//class CallViewController: UIViewController ,SINCallDelegate{
//
//@IBOutlet weak var localVideo: UIView!
//@IBOutlet weak var remoteVideo: UIView!
//
//@IBOutlet weak var remoteUserName: UILabel!
//@IBOutlet var callStateLabel: UILabel!
//@IBOutlet var declineButton: UIButton!
//@IBOutlet var answerButton: UIButton!
//@IBOutlet var endCallBUtton: UIButton!
//    @IBOutlet weak var btnSpeaker: UIButton!
//
//    @IBOutlet weak var btnCameraSwap: UIButton!
//
//
//    var durationTimer: Timer?
//    var call: SINCall!
//    var appId = 0
//    var durartion = "0"
//
//    var callEstablish = 0
//
//    var audioController:SINAudioController {
//        let appDelegate = UIApplication.shared.delegate! as! AppDelegate
//        return (appDelegate.client?.audioController())!
//    }
//
//
//    var speakerEnabled = false
//
//    // MARK: - UIViewController Cycle
//    override func viewDidLoad() {
//        super.viewDidLoad()
//
//        setStatusBar(color: #colorLiteral(red: 0.233, green: 0.816, blue: 0.538, alpha: 1))
//
//        btnCameraSwap.isHidden = true
//
//        call.delegate = self
//
//        if call.direction == .incoming
//        {
//            let appDelegate = UIApplication.shared.delegate! as! AppDelegate
//            if (appDelegate.callKitProvider?.callExists(self.call.callId))!{
//                if self.call.state == .established{
//                    startCallDurationTimerWithSelector(#selector(CallViewController.onDurationTimer(_:)))
//                    showButtons(.hangup)
//                   // audioController.stopPlayingSoundFile()
//                    remoteVideo.addSubview(videoController().remoteView())
//                }else{
//                    setCallStatus("")
//                    self.endCallBUtton.isHidden = true
//                    self.answerButton.isHidden = true
//                    self.declineButton.isHidden = true
//                    remoteVideo.addSubview(videoController().remoteView())
//                }
//
//            }else{
//                setCallStatus("")
//                showButtons(.decline)
//                self.audioController.enableSpeaker()
//                self.audioController.startPlayingSoundFile(self.pathForSound("incoming.wav"), loop: true)
//            }
//        }
//        else{
//            // setCallStatus.text = "calling..."
//            setCallStatus("calling...")
//            showButtons(.hangup)
//        }
//
//        if call.details.isVideoOffered {
//            btnCameraSwap.isHidden = false
//            localVideo.addSubview(videoController().localView())
//            self.videoController().localView().contentMode = .scaleToFill
//        }
//
//        let localViewTap = UITapGestureRecognizer(target: self, action: #selector(self.handleTap(_:)))
//        videoController().localView().addGestureRecognizer(localViewTap)
//
//        let remoteViewTap = UITapGestureRecognizer(target: self, action: #selector(self.handleTap(_:)))
//        videoController().remoteView().addGestureRecognizer(remoteViewTap)
//    }
//
//    override func viewWillAppear(_ animated: Bool) {
//        super.viewWillAppear(animated)
//
//        remoteUserName.text = call?.remoteUserId!
//    }
//
//    @objc func handleTap(_ sender: UITapGestureRecognizer? = nil) {
//
//        let viewGestured = sender?.view
//        if (viewGestured?.sin_isFullscreen())! {
//            viewGestured?.contentMode = .scaleAspectFit
//            viewGestured?.sin_disableFullscreen(true)
//        }else
//        {
//            viewGestured?.contentMode = .scaleAspectFill
//            viewGestured?.sin_enableFullscreen(true)
//        }
//    }
//
//
//
//    @IBAction func didtapSpeaker(_ sender: Any) {
//
//        if speakerEnabled == false {
//            speakerEnabled = true
//            audioController.enableSpeaker()
//            btnSpeaker.setImage(#imageLiteral(resourceName: "loud-speaker"), for: .normal)
//        }else{
//            speakerEnabled = false
//            audioController.disableSpeaker()
//            btnSpeaker.setImage(#imageLiteral(resourceName: "mute-speaker"), for: .normal)
//        }
//    }
//
//    @IBAction func didtapCamera(_ sender: Any) {
//        if self.videoController().captureDevicePosition == .front {
//            self.videoController().captureDevicePosition = .back
//        }else
//        {
//            self.videoController().captureDevicePosition = .front
//        }
//    }
//
//    // MARK: - Call Actions
//    @IBAction func accept(_ sender: Any) {
//        self.audioController.disableSpeaker()
//        self.audioController.stopPlayingSoundFile()
//        call.answer()
//    }
//
//    @IBAction func decline(_ sender: Any) {
//        self.audioController.disableSpeaker()
//        call.hangup()
//        NavigationHandler.pop()
//    }
//
//    @IBAction func hangup(_ sender: Any) {
//
//        DispatchQueue.main.async {
//         //   let userInfo = ["appId" :self.appId ,"duration":self.durartion] as [String : Any]
//         //   NotificationCenter.default.post(name: Notification.Name("callAppId"), object: userInfo)
//            self.call.hangup()
//        }
//
//
//   /*     if callEstablish == 1 {
//            hangupCall()
//        }else
//        {
//            call.hangup()
//        } */
//    }
//
//    func hangupCall() -> Void {
//        if (Int(durartion) ?? 0 ) > 4
//        {
//        let userInfo = ["appId" :appId ,"duration":durartion] as [String : Any]
//        NotificationCenter.default.post(name: Notification.Name("callAppId"), object: userInfo)
//        call.hangup()
//        }else
//        {
//            AlertManager.showAlert(type: .custom("Appointment duration cannot be shorter than 5 minutes."))
//        }
//    }
//
//
//    @objc func onDurationTimer(_ unused: Timer) {
//        let duration = Int(Date().timeIntervalSince(call.details.establishedTime))
//
//        DispatchQueue.main.async {
//            self.setDuration(duration)
//        }
//
//    }
//
//    // MARK: - SINCallDelegate
//
//    func callDidProgress(_ call: SINCall)
//    {
//        callStateLabel.text = "ringing..."
//        audioController.startPlayingSoundFile(pathForSound("ringback.wav"), loop: true)
//    }
//
//    func callDidEstablish(_ call: SINCall)
//    {
//        callEstablish = 1
//        startCallDurationTimerWithSelector(#selector(CallViewController.onDurationTimer(_:)))
//        showButtons(.hangup)
//        audioController.stopPlayingSoundFile()
//    }
//
//    func callDidEnd(_ call: SINCall)
//    {
//        audioController.stopPlayingSoundFile()
//        stopCallDurationTimer()
//        NavigationHandler.pop()
///*        if callEstablish == 1
//        {
//            if (Int(durartion) ?? 0 ) > 4
//            {
//            audioController.stopPlayingSoundFile()
//            stopCallDurationTimer()
//            NavigationHandler.pop()
//
//            }else
//            {
//                AlertManager.showAlert(type: .custom("Appointment duration cannot be shorter than 5 minutes."))
//            }
//        }else
//        {
//            audioController.stopPlayingSoundFile()
//            stopCallDurationTimer()
//            NavigationHandler.pop()
//        } */
//    }
//
//    // MARK: - Sounds
//    func pathForSound(_ soundName: String) -> String {
//        let resourcePath = Bundle.main.resourcePath! as NSString
//        return resourcePath.appendingPathComponent(soundName)
//    }
//
//    func videoController() -> SINVideoController {
//        let appDelegate = UIApplication.shared.delegate! as! AppDelegate
//        return appDelegate.client.videoController()
//    }
//    func callDidAddVideoTrack(_ call: SINCall?) {
//        self.remoteVideo.addSubview(videoController().remoteView())
//      self.videoController().remoteView().contentMode = .scaleToFill
//    }
//    func callDidPauseVideoTrack(_ call: SINCall!) {
//    //    self.remoteVideo.isHidden = true
//    }
//    func callDidResumeVideoTrack(_ call: SINCall!) {
//     //   self.remoteVideo.isHidden = false
//    }
//}
//
//
//// MARK: - This extension contains UI helper methods for CallViewController
//
//extension CallViewController {
//
//    // MARK: - Call Status
//
//    func setCallStatusText(_ text: String) {
//        callStateLabel.text = text
//    }
//
//    func setCallStatus(_ text: String) {
//        self.callStateLabel.text = text
//    }
//
//    // MARK: - Buttons
//
//    func showButtons(_ buttons: EButtonsBar) {
//        if buttons == .decline {
//            answerButton.isHidden = false
//            declineButton.isHidden = false
//            endCallBUtton.isHidden = true
//        }
//        else if buttons == .hangup {
//            endCallBUtton.isHidden = false
//            answerButton.isHidden = true
//            declineButton.isHidden = true
//        }
//    }
//
//    // MARK: - Duration
//
//    func setDuration(_ seconds: Int)
//    {
//        setCallStatusText(String(format: "%02d:%02d", arguments: [Int(seconds / 60), Int(seconds % 60)]))
//        durartion = String(format: "%d", arguments: [Int(seconds / 60)])
//    }
//
//    @objc func internal_updateDurartion(_ timer: Timer)
//    {
//
//        let selector:Selector = NSSelectorFromString(timer.userInfo as! String)
//
//        if self.responds(to: selector)
//        {
//            self.performSelector(inBackground: selector, with: timer)
//        }
//
//    }
//
//    func startCallDurationTimerWithSelector(_ selector: Selector) {
//        let selectorString  = NSStringFromSelector(selector)
//        durationTimer = Timer.scheduledTimer(timeInterval: 0.5, target: self, selector: #selector(CallViewController.internal_updateDurartion(_:)), userInfo: selectorString, repeats: true)
//    }
//
//    func stopCallDurationTimer() {
//        durationTimer?.invalidate()
//        durationTimer = nil
//    }
//
//}
//
