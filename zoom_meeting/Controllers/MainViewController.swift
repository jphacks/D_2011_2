//
//  MainViewController.swift
//  zoom_meeting
//
//  Created by Tommy on 2020/11/02.
//

import UIKit
import MobileRTC
import MobileCoreServices

class MainViewController: UIViewController, MobileRTCPremeetingDelegate {
    
    var sharedAuthService:  MobileRTCAuthService?
    var preMeetingService: MobileRTCPremeetingService?
    var userInfo: MobileRTCAccountInfo?
    
    @IBOutlet var userNameLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        sharedAuthService = MobileRTC.shared().getAuthService()
        preMeetingService = MobileRTC.shared().getPreMeetingService()
        
        preMeetingService?.delegate = self
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        if sharedAuthService?.isLoggedIn() ?? false {
            userInfo = sharedAuthService?.getAccountInfo()
            userNameLabel.text = (userInfo?.getUserName() ?? "") + " さん"
        }
    }
    
    @IBAction func createMeeting() {
//        guard let meetingService = preMeetingService,
//              let meeting = meetingService.createMeetingItem()
//        else { return }
//        meeting.setMeetingTopic("Test")
//        meeting.setStartTime(Date())
//        meeting.setDurationInMinutes(UInt(TimeInterval(60)))
//
//        meetingService.scheduleMeeting(meeting, withScheduleFor: userInfo?.getEmailAddress())
//        meetingService.destroy(meeting)
    }
    
    @IBAction func logout() {
        sharedAuthService?.logoutRTC()
        self.dismiss(animated: true, completion: nil)
    }
    
    func sinkSchedultMeeting(_ result: PreMeetingError, meetingUniquedID uniquedID: UInt64) {
        guard result.rawValue == 0 else {
            print("Zoom (User): Schedule meeting task failed, error code: \(result)")
            return
        }
        
        print("Zoom (User): Schedule meeting task completed.")
        let meeting = preMeetingService?.getMeetingItem(byUniquedID: uniquedID)
        let id = meeting?.getMeetingNumber() ?? 0
        let pass = meeting?.getMeetingPassword() ?? ""
        
        print("zoommtg://zoom.us/join?confno=\(id)&pwd=\(pass)")
    }
    
    func sinkEditMeeting(_ result: PreMeetingError, meetingUniquedID uniquedID: UInt64) {
        print(result)
    }
    
    func sinkDeleteMeeting(_ result: PreMeetingError) {
        print(result)
    }
    
    func sinkListMeeting(_ result: PreMeetingError, withMeetingItems array: [Any]) {
        print(result)
    }
}
