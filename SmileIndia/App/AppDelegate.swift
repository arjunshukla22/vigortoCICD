//
//  AppDelegate.swift
//  SmileIndia
//
//  Created by Na on 07/02/19.
//  Copyright © 2019 Na. All rights reserved.
//

import UIKit
import IQKeyboardManager
import Firebase
import UserNotifications
import CallKit
import PushKit
import Sinch
import Stripe
import Localize
import EZSwiftExtensions

@UIApplicationMain

class AppDelegate: UIResponder, UIApplicationDelegate, MessagingDelegate, UNUserNotificationCenterDelegate ,SINClientDelegate,SINCallClientDelegate,SINManagedPushDelegate{
    
    var window: UIWindow?
    var client: SINClient!
    var player: AVAudioPlayer?
    
    var push: SINManagedPush?
    var callKitProvider: SINCallKitProvider?
    
    var object: Appointment?
    
    var isComingDeeplinkApStatus = ""
    
    var userId = ""
    
    var room_Id : String = ""
    var remoteUser : String = "iOS Client"
    var videoMuted = "false"
    
    let callManager = EnxCallManager()
    var providerDelegate : ProviderDelegate?
    let pushRegistry = PKPushRegistry(queue: DispatchQueue.main)
    
    var isApplicationActive:Bool {
        get {return UIApplication.shared.applicationState == .active}
    }
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        // Configure Keyboard Manager
        
        // Update App Language
        UpdateAppLanguage()
        
        providerDelegate = ProviderDelegate(callManager: callManager)
        pushRegistry.delegate = self as? PKPushRegistryDelegate
        pushRegistry.desiredPushTypes = [.voIP]
        IQKeyboardManager.shared().isEnabled = true
        IQKeyboardManager.shared().shouldShowToolbarPlaceholder = false
        
        FirebaseApp.configure()
        Messaging.messaging().delegate = self
        if #available(iOS 10.0, *) {
            // For iOS 10 display notification (sent via APNS)
            UNUserNotificationCenter.current().delegate = self
            let authOptions: UNAuthorizationOptions = [.alert, .badge, .sound]
            UNUserNotificationCenter.current().requestAuthorization(
                options: authOptions,
                completionHandler: {_, _ in })
        } else {
            let settings: UIUserNotificationSettings =
                UIUserNotificationSettings(types: [.alert, .badge, .sound], categories: nil)
            application.registerUserNotificationSettings(settings)
        }
        
        application.registerForRemoteNotifications()
        application.statusBarStyle = .lightContent // .default
        
        // for Live Mode
//    Stripe.setDefaultPublishableKey("pk_live_51HCP7UKdHFfrLGzovspqbEb3DDsYZtdckfmWZGOzGK7ZmWwxWRUxlpmvwlzYoRCz882cGM8tw4zm1POp7KhRmRPZ008TzNydJX")
        // for Test Mode

   Stripe.setDefaultPublishableKey("pk_test_51HCP7UKdHFfrLGzosU0mKbFtL1rwcznbzQQYq9xY7RXB9OodXJJc5HzSAAX8DAVznrT5BCQ6Gge1re3GTY7NVs2W00AtzJpn53")
        
        
        /*         Sinch.setLogCallback { (severity, area, message, timestamp) in
         print(area,message)
         }
         
         self.push = Sinch.managedPush(with: .development)
         // self.push = Sinch.managedPush(with: .production)
         self.push?.delegate = self
         self.push?.setDesiredPushType(SINPushTypeVoIP)
         self.callKitProvider = SINCallKitProvider()
         
         NotificationCenter.default.addObserver(forName: Notification.Name("UserDidLoginNotification"), object: nil, queue: nil, using: {(_ note: Notification) -> Void in
         let userId = note.userInfo!["userId"] as? String
         self.initSinchClient(withUserId: userId ?? "")
         self.client.call().delegate = self
         
         self.userId = userId ?? ""
         })
         
         
         if let userId = Authentication.customerEmail{
         self.initSinchClient(withUserId: userId)
         self.client.call().delegate = self
         
         self.userId = userId
         } */
        
        return true
    }
    
    // MARK: Deeplink Open
    
    func application(_ app: UIApplication, open url: URL, options: [UIApplication.OpenURLOptionsKey : Any] = [:]) -> Bool {
        
        print("Url is :- \(url.absoluteURL)")
        
        let urlStr : String = url.absoluteString
        let arrUrl = urlStr.components(separatedBy: "://")
        if arrUrl.count > 1 {
           // print("Deeplink :- \(arrUrl)")
         //   let param = url.queryParameters
            OpenScreenViaDeepLink(Deeplink: arrUrl[1])
        }
        
        return true
    }
    
    func OpenScreenViaDeepLink(Deeplink:String) {
        
        if Authentication.isUserLoggedIn! {
            if Authentication.customerType == EnumUserType.Customer {
                
                // User login
                let arrUrl = Deeplink.components(separatedBy: "/")
//                print("Deeplink Data :- \(arrUrl)")
                
                if arrUrl.count > 0 {
                    let recCustomerID = arrUrl[0]
                    
                    if Authentication.customerId == recCustomerID{
                        let screenName = arrUrl[1].uppercased()
                        if screenName == EnumDeepLinkScreenName.Rating{ // For Open Rating Screen
                            
                            if arrUrl.count > 3{ // Need 2 params - Appointement ID & Provider ID
                                
                                // Set Enum Complete Status
                                isComingDeeplinkApStatus = EnumAppointmentStatus.Completed
                                
                                let apointementId = arrUrl[2].toInt()
                                let providerId = arrUrl[3]
                                
                                let ap = Appointment.init(Id: apointementId, AppointmentId: nil, Memeberid: nil, ProviderId: providerId, MemberId: nil, Status: nil, MemberName: nil, MemberEmail: nil, PastappointmentId: nil, ProviderName: nil, ProviderEmail: nil, Reason: nil, Age: nil, AppointmentTime: nil, CreateDate: nil, BookingDate: nil, UpdateDate: nil, AppointmentDateTime: nil, DoctorNotes: nil, Rating: nil, Reviews: nil, MemberPhone: nil, IsRescheduleBtn: nil, DoctorReply: nil, MeetType: nil, AppointmentMessage: nil, DoctorTimeZoneId: nil, PatientTimeZoneId: nil, Latitude: nil, Longitude: nil, AppointmentFor: nil, OtherPatientRelation: nil, OtherPatinetName: nil, IsRefundAllowed: nil, IsDeleteAllowed: nil, IsNotAvailable: nil, RefundTakenAction: nil, InsurancePlanId: nil, InsurancePlanName: nil, InsuranceCardPic: nil, PaymentType: nil, CreateDateForApi: nil, CreatedDate: nil, Room_Id: nil, Review: nil)
                                
                                // Screen Name
                                NavigationHandler.pushTo(.rating(ap))
                                
                            }else{print("Some Params is Missing in URl ")}
                        }
                        else {
                            print("ScreenName :- \(screenName)")
                        }
                    }
                    else{
                        print("Invalid Customer")
                        let alert = UIAlertController(title: "", message:"Invalid Customer", preferredStyle: UIAlertController.Style.alert)
                                
                        // add an action (button)
                        alert.addAction(UIAlertAction(title: AlertBtnTxt.okay.localize(), style: UIAlertAction.Style.default, handler: nil))
                               
                        // show the alert
                        self.window?.rootViewController?.present(alert, animated: true, completion: nil)
                    }
                }
            }
            else{
                print("Doctor has Service ")
                let alert = UIAlertController(title: "", message:"Invalid Member", preferredStyle: UIAlertController.Style.alert)
                        
                // add an action (button)
                alert.addAction(UIAlertAction(title: AlertBtnTxt.okay.localize(), style: UIAlertAction.Style.default, handler: nil))
                       
                // show the alert
                self.window?.rootViewController?.present(alert, animated: true, completion: nil)
                
            }
            
        }
        else {
            // User not Login
            //  NavigationHandler.pushTo(.welcome)
        }
    }
    

    // MARK: - MessagingDelegate
    func messaging(_ messaging: Messaging, didReceiveRegistrationToken fcmToken: String?) {
        print("Firebase registration token: \(/fcmToken)")
        Authentication.deviceToken = fcmToken
        
        let dataDict:[String: String] = ["token": fcmToken!]
        NotificationCenter.default.post(name: Notification.Name("FCMToken"), object: nil, userInfo: dataDict)
        // TODO: If necessary send token to application server.
        // Note: This callback is fired at each app startup and whenever a new token is generated.
        //  self.registerDevice(userId: self.userId, token: fcmToken)
    }
    func application(_ application: UIApplication, didRegisterForRemoteNotificationsWithDeviceToken deviceToken: Data) {
        let token = deviceToken.map { String(format: "%.2hhx", $0) }.joined()
        print("devicetoken")
        print(token)
        Messaging.messaging().apnsToken = deviceToken
    }
    func application(
        _ application: UIApplication,
        didFailToRegisterForRemoteNotificationsWithError error: Error) {
        print("Failed to register: \(error)")
    }
    
    func application(_ application: UIApplication, didReceiveRemoteNotification userInfo: [AnyHashable: Any]) {
        print(userInfo)
        
        let payLoadValue =  userInfo["aps"] as! NSDictionary
        let alert = payLoadValue["alert"] as! NSDictionary
        
        
        if alert["body"] as! String == "Call Ended" || alert["body"] as! String == "Calling..."{
            
            let roomId = userInfo["message"]
            let handle = userInfo["calltype"] as! String
            
            self.videoMuted = userInfo["videoMuted"] as! String
            
            self.getAppointmentDataForIOSVideoCall(apntmtId: userInfo["AppointmentId"] as! String)
            
            if(roomId != nil){
                room_Id = userInfo["message"] as! String
                
                if let uuidString = userInfo["uuid"], let uuid = UUID(uuidString: uuidString as! String){
                    if(handle == "start"){
                        let backGroundTaskIndet = UIApplication.shared.beginBackgroundTask(expirationHandler: nil)
                        self.displayIncomingCall(uuid: uuid, handle: alert["title"] as! String, hasVideo: true){ _ in
                            UIApplication.shared.endBackgroundTask(backGroundTaskIndet)
                        }
                    }
                }
                if(handle == "end"){
                    for call in callManager.calls{
                        callManager.endCall(call: call)
                    }
                }
                
            }
        }
        // If you are receiving a notification message while your app is in the background,
        // this callback will not be fired till the user taps on the notification launching the application.
        // TODO: Handle data of notification
        
        // With swizzling disabled you must let Messaging know about the message, for Analytics
        // Messaging.messaging().appDidReceiveMessage(userInfo)
        
        // Print message ID.
        if let messageID = userInfo["gcmMessageIDKey"] {
            print("Message ID: \(messageID)")
        }
        
    }
    @available(iOS 10, *)
    // Receive displayed notifications for iOS 10 devices.
    func userNotificationCenter(_ center: UNUserNotificationCenter,
                                willPresent notification: UNNotification,
                                withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void) {
        
        let userInfo = notification.request.content.userInfo
        print(userInfo)
        let payLoadValue =  userInfo["aps"] as! NSDictionary
        let alert = payLoadValue["alert"] as! NSDictionary
        if alert["body"] as! String == "Call Ended" || alert["body"] as! String == "Calling..."{
            
            /* print(userInfo)
             print(userInfo as NSDictionary)
             print(userInfo["type"] as! String)
             print(userInfo["localphoneNumber"] as! String)
             print(userInfo["message"] as! String)
             print(userInfo["uuid"] as! String)
             print(userInfo["detail1"] as! String)
             print(userInfo["body"] as! String)
             print(alert["body"] as! String)
             print(alert["title"] as! String)
             */
            
            let roomId = userInfo["message"]
            let handle = userInfo["calltype"] as! String
            self.videoMuted = userInfo["videoMuted"] as! String
            
            self.getAppointmentDataForIOSVideoCall(apntmtId: userInfo["AppointmentId"] as! String)
            
            if(roomId != nil){
                room_Id = userInfo["message"] as! String
                
                if let uuidString = userInfo["uuid"], let uuid = UUID(uuidString: uuidString as! String){
                    if(handle == "start"){
                        let backGroundTaskIndet = UIApplication.shared.beginBackgroundTask(expirationHandler: nil)
                        self.displayIncomingCall(uuid: uuid, handle: alert["title"] as! String, hasVideo: true){ _ in
                            UIApplication.shared.endBackgroundTask(backGroundTaskIndet)
                        }
                    }
                }
                if(handle == "end"){
                    for call in callManager.calls{
                        callManager.endCall(call: call)
                    }
                }
            }
        }else{
            completionHandler([.alert, .badge, .sound])
        }
        // With swizzling disabled you must let Messaging know about the message, for Analytics
        // Messaging.messaging().appDidReceiveMessage(userInfo)
        
        // Print message ID.
        if let messageID = userInfo["gcmMessageIDKey"] {
            print("Message ID: \(messageID)")
        }
        
        // Print full message.
        UNUserNotificationCenter.current().getDeliveredNotifications(completionHandler: {deliveredNotifications -> () in
            print("\(deliveredNotifications.count) Delivered notifications-------")
            for notification in deliveredNotifications{
                print(notification.request.identifier)
            }
        })
        
        // Change this to your preferred presentation option
        //   completionHandler([.alert, .badge, .sound])
    }
    
    func displayIncomingCall(uuid: UUID, handle: String, hasVideo: Bool = true, completion: ((NSError?) -> Void)? = nil) {
        providerDelegate?.reportIncomingCalls(uuid: uuid, handle: handle, hasVideo: hasVideo, completion: completion)
    }
    
    // This method is called when user CLICKED on the notification
    func userNotificationCenter(_ center: UNUserNotificationCenter, didReceive response: UNNotificationResponse, withCompletionHandler completionHandler: @escaping () -> Void){
        print("user clicked on the notification")
        let userInfo = response.notification.request.content.userInfo
        print(userInfo)
        let payLoadValue =  userInfo["aps"] as! NSDictionary
        let alert = payLoadValue["alert"] as! NSDictionary
        
        if alert["body"] as! String == "Call Ended" || alert["body"] as! String == "Calling..."{
            
            let roomId = userInfo["message"]
            let handle = userInfo["calltype"] as! String
            self.videoMuted = userInfo["videoMuted"] as! String
            
            
            self.getAppointmentDataForIOSVideoCall(apntmtId: userInfo["AppointmentId"] as! String)
            
            if(roomId != nil){
                room_Id = userInfo["message"] as! String
                
                if let uuidString = userInfo["uuid"], let uuid = UUID(uuidString: uuidString as! String){
                    if(handle == "start"){
                        let backGroundTaskIndet = UIApplication.shared.beginBackgroundTask(expirationHandler: nil)
                        self.displayIncomingCall(uuid: uuid, handle: alert["title"] as! String, hasVideo: true){ _ in
                            UIApplication.shared.endBackgroundTask(backGroundTaskIndet)
                        }
                    }
                }
                if(handle == "end"){
                    
                    for call in callManager.calls{
                        callManager.endCall(call: call)
                    }
                }
            }
        }else{
            NavigationHandler.pushTo(.appointmentList("0"))
        }
        
        completionHandler()
    }
    
    
    func didReceive(
        _ request: UNNotificationRequest,
        withContentHandler contentHandler:
            @escaping (UNNotificationContent) -> Void)
    {
        
        let userInfo = request.content.userInfo
        
        let customID = userInfo["custom-payload-id"] as? String
        UNUserNotificationCenter.current()
            .getDeliveredNotifications { notifications in
                let matching = notifications.first(where: { notify in
                    let existingUserInfo = notify.request.content.userInfo
                    let id = existingUserInfo["custom-payload-id"] as? String
                    return id == customID
                })
                
                if let matchExists = matching {
                    UNUserNotificationCenter.current().removeDeliveredNotifications(
                        withIdentifiers: [matchExists.request.identifier]
                    )
                }
            }
    }
    
    func applicationWillResignActive(_ application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
        //        weak var call = callKitProvider?.currentEstablishedCall()
        //
        //          if call != nil {
        //              NavigationHandler.pushTo(.callVC(call))
        //          }
        //   self.initSinchClient(withUserId: Authentication.customerEmail ?? "")
        
       // print ("applicationWillResignActive")
        
    }
    
    func applicationDidEnterBackground(_ application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
       // print ("applicationDidEnterBackground")
        
       // UpdateAppLanguage()
        
    }
    
    func applicationWillEnterForeground(_ application: UIApplication) {
        // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
        // If there is one established call, show the callView of the current call when
        // the App is brought to foreground. This is mainly to handle the UI transition
        // when clicking the App icon on the lockscreen CallKit UI.
        
      //  print ("applicationWillEnterForeground")
        
        weak var call = callKitProvider?.currentEstablishedCall()
        
        if call != nil {
            var top = self.window?.rootViewController
            while ((top?.presentedViewController) != nil) {
                top = top?.presentedViewController
            }
            
            // When entering the application via the App button on the CallKit lockscreen,
            // and unlocking the device by PIN code/Touch ID, applicationWillEnterForeground:
            // will be invoked twice, and "top" will be CallViewController already after
            // the first invocation.
            if !(top!.isMember(of: CallViewController.self))  {
                NavigationHandler.pushTo(.callVC(call))
            }
        }
        
    }
    
    func applicationDidBecomeActive(_ application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
        
        //  self.initSinchClient(withUserId: Authentication.customerEmail ?? "")
        //   self.client.call().delegate = self
       // print ("applicationDidBecomeActive")
        
    }
    
    func applicationWillTerminate(_ application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
        
        //  self.initSinchClient(withUserId: Authentication.customerEmail ?? "")
    }
    
    
    
    // MARK: - sinch methods
    
    func initSinchClient(withUserId userId: String) {
        
        if client == nil {
            print("initializing client 2")
            client = Sinch.client(withApplicationKey: "233c322f-01c7-4253-b972-9097fddd473d",
                                  applicationSecret: "5k8y9B40QE+jH4HhRen0nw==",
                                  environmentHost: "clientapi.sinch.com",
                                  userId: userId)
            self.client.delegate = self
            self.client.call().delegate = self
            self.client.setSupportCalling(true)
            self.client.enableManagedPushNotifications()
            self.callKitProvider?.client = self.client
            
            self.client.start()
            self.client.startListeningOnActiveConnection()
        }
    }
    
    func handleRemoteNotification(_ userInfo: [AnyHashable : Any]?) {
        if self.client == nil {
            let userId = Authentication.customerEmail
            if userId != nil {
                initSinchClient(withUserId: userId!)
            }
        }
        DispatchQueue.main.async {
            self.client?.relayRemotePushNotification(userInfo)
        }
    }
    
    func managedPush(_ managedPush: SINManagedPush?,didReceiveIncomingPushWithPayload payload: [AnyHashable : Any]?,forType pushType:String?) {
        print("didReceiveIncomingPushWithPayload: \(payload?.description ?? "")")
        
        // Since iOS 13 the application must report an incoming call to CallKit if a
        // VoIP push notification was used, and this must be done within the same run
        // loop as the push is received (i.e. GCD async dispatch must not be used).
        // See https://developer.apple.com/documentation/pushkit/pkpushregistrydelegate/2875784-pushregistry .
        
        callKitProvider?.didReceivePush(withPayload: payload)
        
        DispatchQueue.main.async {
            self.handleRemoteNotification(payload)
            self.push?.didCompleteProcessingPushPayload(payload)
        }
    }
    
    // MARK: - SINCallClientDelegate
    
    func client(_ client: SINCallClient!, didReceiveIncomingCall call: SINCall!) {
        let state = UIApplication.shared.applicationState
        if state == .active{
            NavigationHandler.pushTo(.callVC(call))
        }
    }
    
    func client(_ client: SINCallClient!, willReceiveIncomingCall call: SINCall!) {
        self.callKitProvider?.willReceiveIncomingCall(call)
    }
    
    //SINCallClient delegates
    
    func clientDidStart(_ client: SINClient!) {
        print("Sinch client started successfully (version: \(Sinch.version()) with userid \(client.userId)")
    }
    
    func clientDidFail(_ client: SINClient!, error: Error!) {
        print("Sinch client error: \(String(describing: error?.localizedDescription))")
    }
    
    func client(_ client: SINClient, logMessage message: String, area: String, severity: SINLogSeverity, timestamp: Date) {
        
        print("\(message)")
    }
    
    
    func registerDevice(userId:String,token:String) -> Void {
        let queryItems = ["phone_number": userId,"Token": token,"DeviceType": "I"]
        WebService.registerDevice(queryItems: queryItems) { (result) in
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
    
    func getAppointmentDataForIOSVideoCall(apntmtId:String) -> Void {
        let queryItems = ["AppointmentID": apntmtId]
        print(queryItems)
        WebService.getAppointmentDataForIOSVideoCall(queryItems: queryItems) { (result) in
            DispatchQueue.main.async {
                switch result {
                case .success(let response):
                    self.object = response.object
                case .failure(let error):
                    print(error.message)
                }
            }
        }
    }
    
}


extension AppDelegate {
    
    func UpdateAppLanguage() {
        
        if Authentication.appLanguage != ""  {
            let localize = Localize.shared
            // Set your localize provider.
            localize.update(provider: .json)
            // Set your file name
            localize.update(fileName: "lang")
            // Set your default languaje.
            localize.update(defaultLanguage: /Authentication.appLanguage)
            // If you want change a user language, different to default in phone use thimethod.
            localize.update(language: /Authentication.appLanguage)
                    
        }else{
           // print( Locale.preferredLanguages.first?.components(separatedBy: "-").first?.lowercased() )
            let locale = Locale.preferredLanguages.first?.components(separatedBy: "-").first?.lowercased() ?? "en"
            let localize = Localize.shared
            // Set your localize provider.
            localize.update(provider: .json)
            // Set your file name
            localize.update(fileName: "lang")
            // Set your default languaje.
            localize.update(defaultLanguage: locale)
            // If you want change a user language, different to default in phone use thimethod.
            localize.update(language: locale)
        }
        
    }
    
}
