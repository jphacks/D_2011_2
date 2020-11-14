import UIKit
import Flutter
import MobileRTC
import MobileCoreServices

@UIApplicationMain
@objc class AppDelegate: FlutterAppDelegate, MobileRTCAuthDelegate {
    var _flutterResult: FlutterResult!
    var sharedAuthRTC: MobileRTCAuthService?
    
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
        print("Called")
        sharedAuthRTC?.login(withEmail: email, password: pass, rememberMe: remember)
    }
    
    func onMobileRTCAuthReturn(_ returnValue: MobileRTCAuthError) {
        print(returnValue)
        if returnValue != MobileRTCAuthError_Success {
            print("SDK authentication failed, error code: \(returnValue)")
        } else {
            print("SDK auth suceeded")
        }
    }
    
    
    func onMobileRTCLoginReturn(_ returnValue: Int) {
        print("Success")
        self._flutterResult?(returnValue == 0)
    }
    
    func onMobileRTCLogoutReturn(_ returnValue: Int) {
        sharedAuthRTC = MobileRTC.shared().getAuthService()
    }
}
