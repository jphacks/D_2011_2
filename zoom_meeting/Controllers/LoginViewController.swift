//
//  ViewController.swift
//  zoom_meeting
//
//  Created by Tommy on 2020/10/31.
//

import UIKit
import MobileRTC
import MobileCoreServices
import PKHUD

class LoginViewController: UIViewController, MobileRTCAuthDelegate {
    var sharedAuthRTC: MobileRTCAuthService?
    
    @IBOutlet var emailTextField: UITextField!
    @IBOutlet var passwordTextField: UITextField!
    @IBOutlet var rememberMeSwitch: UISwitch!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        emailTextField.layer.borderColor = UIColor.hex(string: "00013F", alpha: 1).cgColor
        emailTextField.layer.borderWidth = 2
        passwordTextField.layer.borderColor = UIColor.hex(string: "00013F", alpha: 1).cgColor
        passwordTextField.layer.borderWidth = 2
        
        sharedAuthRTC = MobileRTC.shared().getAuthService()
        sharedAuthRTC?.delegate = self
        
        // TextField
        emailTextField.delegate = self
        passwordTextField.delegate = self
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        HUD.show(.progress)
        if sharedAuthRTC?.isLoggedIn() ?? false {
            HUD.hide()
            self.performSegue(withIdentifier: "success", sender: self)
        } else {
            HUD.hide()
        }
    }
    
    @IBAction func login() {
        HUD.show(.progress)
        sharedAuthRTC?.login(withEmail: emailTextField.text ?? "", password: passwordTextField.text ?? "", rememberMe: rememberMeSwitch.isOn)
    }
    
    @IBAction func signup() {
        if let url = URL(string: "https://zoom.us/signup") {
            UIApplication.shared.open(url)
        }
    }
    
    func onMobileRTCAuthReturn(_ returnValue: MobileRTCAuthError) {
        print(returnValue)
    }
    
    func onMobileRTCLoginReturn(_ returnValue: Int) {
        print(returnValue)
        if returnValue == 0 {
            HUD.hide()
            passwordTextField.text = ""
            self.performSegue(withIdentifier: "success", sender: self)
        } else {
            HUD.flash(.error, delay: 1.0)
            let alert: UIAlertController = UIAlertController(title: "ログイン失敗", message: "メールアドレスとパスワードが正しいかご確認ください", preferredStyle: .alert)
            let okAction: UIAlertAction = UIAlertAction(title: "OK", style: .default, handler: nil)
            alert.addAction(okAction)
            self.present(alert, animated: true, completion: nil)
        }
    }
}

extension LoginViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
}
