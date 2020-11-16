import UIKit
import Flutter
import MobileRTC
import MobileCoreServices

@UIApplicationMain
@objc class AppDelegate: FlutterAppDelegate, MobileRTCAuthDelegate, MobileRTCPremeetingDelegate {
    var _flutterResult: FlutterResult!
    var sharedAuthRTC: MobileRTCAuthService?
    var preMeetingService: MobileRTCPremeetingService?
    
    override func application(
        _ application: UIApplication,
        didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?
    ) -> Bool {
        GeneratedPluginRegistrant.register(with: self)
        
        let controller: FlutterViewController = window?.rootViewController as! FlutterViewController
        
        authZoomSDK()
        
        sharedAuthRTC = MobileRTC.shared().getAuthService()
        sharedAuthRTC?.delegate = self
        let methodChannel = FlutterMethodChannel(name: "flutter_zoom_sdk", binaryMessenger: controller.binaryMessenger)
        
        methodChannel.setMethodCallHandler({
            (call: FlutterMethodCall, result: @escaping FlutterResult) -> Void in
            self._flutterResult = result
            
            if call.method == "isLoggedIn" {
                result(self.sharedAuthRTC?.isLoggedIn() ?? false)
            } else if call.method == "login" {
                let arguments = call.arguments as! [String: Any]
                guard let email = arguments["email"] as? String,
                      let pass = arguments["password"] as? String,
                      let remember = arguments["remember"] as? Bool else {
                    result(FlutterMethodNotImplemented)
                    return
                }
                self.login(email: email, pass: pass, remember: remember)
            } else if call.method == "logout" {
                self.sharedAuthRTC?.logoutRTC()
            } else if call.method == "userName" {
                result(self.sharedAuthRTC?.getAccountInfo()?.getUserName())
            } else if call.method == "createMtg" {
                self.preMeetingService = MobileRTC.shared().getPreMeetingService()
                self.preMeetingService?.delegate = self
                let arguments = call.arguments as! [String: Any]
                guard let title = arguments["title"] as? String,
                      let date = arguments["date"] as? Int,
                      let beforeHost = arguments["beforeHost"] as? Bool,
                      let waitingRoom = arguments["waitingRoom"] as? Bool,
                      let duration = arguments["duration"] as? Int else {
                    result(FlutterMethodNotImplemented)
                    return
                }
                guard let email = self.sharedAuthRTC?.getAccountInfo()?.getEmailAddress() else {
                    result("error")
                    return
                }
                self.createMeeting(title: title, timeInUnix: date, beforeHost: beforeHost, waitingRoom: waitingRoom, duration: duration, email: email)
            } else {
                result(FlutterMethodNotImplemented)
            }
        })
        
        return super.application(application, didFinishLaunchingWithOptions: launchOptions)
    }
    
    func authZoomSDK() {
        let mainSDK = MobileRTCSDKInitContext.init()
        mainSDK.domain = "zoom.us"
        mainSDK.enableLog = true
        MobileRTC.shared().initialize(mainSDK)
        let authService = MobileRTC.shared().getAuthService()
        if let authService = authService {
            authService.delegate = self
            authService.clientKey = KeyManager().getValue(key: "clientKey")
            authService.clientSecret = KeyManager().getValue(key: "clientSecret")
            authService.sdkAuth()
        }
    }
    
    func login(email: String, pass: String, remember: Bool) {
        sharedAuthRTC?.login(withEmail: email, password: pass, rememberMe: remember)
    }
    
    func createMeeting(title: String, timeInUnix: Int, beforeHost: Bool, waitingRoom: Bool, duration: Int, email: String) {
        let date = Date(timeIntervalSince1970: TimeInterval(timeInUnix))
        guard let meetingService = preMeetingService,
              let meeting = meetingService.createMeetingItem()
        else {
            _flutterResult("error")
            return
        }
        
        meeting.setMeetingTopic(title)
        meeting.setStartTime(date)
        meeting.setDurationInMinutes(UInt(TimeInterval(duration)))
        meeting.setAllowJoinBeforeHost(beforeHost)
        meeting.enableWaitingRoom(waitingRoom)
        
        meetingService.scheduleMeeting(meeting, withScheduleFor: email)
        meetingService.destroy(meeting)
    }
    
    func onMobileRTCAuthReturn(_ returnValue: MobileRTCAuthError) {
        if returnValue != MobileRTCAuthError_Success {
            print("SDK authentication failed, error code: \(returnValue)")
        } else {
            print("SDK auth suceeded")
        }
    }
    
    
    func onMobileRTCLoginReturn(_ returnValue: Int) {
        self._flutterResult?(returnValue == 0)
    }
    
    func onMobileRTCLogoutReturn(_ returnValue: Int) {
        sharedAuthRTC = MobileRTC.shared().getAuthService()
    }
    
    func sinkSchedultMeeting(_ result: PreMeetingError, meetingUniquedID uniquedID: UInt64) {
        guard result.rawValue == 0 else {
            print("Zoom (User): Schedule meeting task failed, error code: \(result)")
            return
        }
        
        print("Zoom (User): Schedule meeting task completed.")
        let meeting = preMeetingService?.getMeetingItem(byUniquedID: uniquedID)
        guard let id = meeting?.getMeetingNumber(),
              let pass = meeting?.getMeetingPassword() else {
            return
        }
        
        _flutterResult("\(id),\(pass)")
    }
    
    func sinkEditMeeting(_ result: PreMeetingError, meetingUniquedID uniquedID: UInt64) {}
    
    func sinkDeleteMeeting(_ result: PreMeetingError) {}
    
    func sinkListMeeting(_ result: PreMeetingError, withMeetingItems array: [Any]) {}
}
