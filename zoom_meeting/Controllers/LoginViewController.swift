//
//  ViewController.swift
//  zoom_meeting
//
//  Created by Tommy on 2020/10/31.
//

import UIKit
import MobileRTC
import MobileCoreServices

class LoginViewController: UIViewController, MobileRTCAuthDelegate {
    var sharedAuthRTC: MobileRTCAuthService?
    
    @IBOutlet var emailTextField: UITextField!
    @IBOutlet var passwordTextField: UITextField!
    @IBOutlet var rememberMeSwitch: UISwitch!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        sharedAuthRTC = MobileRTC.shared().getAuthService()
        sharedAuthRTC?.delegate = self
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        if sharedAuthRTC?.isLoggedIn() ?? false {
            self.performSegue(withIdentifier: "success", sender: self)
        }
    }
    
    @IBAction func login() {
        sharedAuthRTC?.login(withEmail: emailTextField.text ?? "", password: passwordTextField.text ?? "", rememberMe: rememberMeSwitch.isOn)
    }
    
    func onMobileRTCAuthReturn(_ returnValue: MobileRTCAuthError) {
        print(returnValue)
    }
    
    func onMobileRTCLoginReturn(_ returnValue: Int) {
        print(returnValue)
        if returnValue == 0 {
            passwordTextField.text = ""
            self.performSegue(withIdentifier: "success", sender: self)
        } else {
            let alert: UIAlertController = UIAlertController(title: "ログイン失敗", message: "メールアドレスとパスワードが正しいかご確認ください", preferredStyle: .alert)
            let okAction: UIAlertAction = UIAlertAction(title: "OK", style: .default, handler: nil)
            alert.addAction(okAction)
            self.present(alert, animated: true, completion: nil)
        }
    }
}

