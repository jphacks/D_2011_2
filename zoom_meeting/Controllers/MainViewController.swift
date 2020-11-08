//
//  MainViewController.swift
//  zoom_meeting
//
//  Created by Tommy on 2020/11/02.
//

import UIKit
import MobileRTC
import MobileCoreServices

class MainViewController: UIViewController {
    
    var sharedAuthService:  MobileRTCAuthService?
    var userInfo: MobileRTCAccountInfo?
    
    @IBOutlet var userNameLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        sharedAuthService = MobileRTC.shared().getAuthService()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.navigationBar.isHidden = false
        self.navigationController?.interactivePopGestureRecognizer?.isEnabled = true
        let userDefaults = UserDefaults.standard
        if !userDefaults.bool(forKey: "first") {
            userDefaults.setValue(true, forKey: "first")
            self.performSegue(withIdentifier: "toTutorial", sender: self)
        }
        if sharedAuthService?.isLoggedIn() ?? false {
            userInfo = sharedAuthService?.getAccountInfo()
            userNameLabel.text = (userInfo?.getUserName() ?? "") + " さん"
        }
    }
    
    @IBAction func moveToTutorial() {
        self.performSegue(withIdentifier: "toTutorial", sender: self)
    }
    
    @IBAction func logout() {
        sharedAuthService?.logoutRTC()
        self.dismiss(animated: true, completion: nil)
    }
}
