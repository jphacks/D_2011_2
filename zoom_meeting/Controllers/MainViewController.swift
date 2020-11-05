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
    @IBOutlet var createMeetingButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        sharedAuthService = MobileRTC.shared().getAuthService()
        createMeetingButton.layer.cornerRadius = 10
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        if sharedAuthService?.isLoggedIn() ?? false {
            userInfo = sharedAuthService?.getAccountInfo()
            userNameLabel.text = (userInfo?.getUserName() ?? "") + " さん"
        }
    }
    
    @IBAction func logout() {
        sharedAuthService?.logoutRTC()
        self.dismiss(animated: true, completion: nil)
    }
}
