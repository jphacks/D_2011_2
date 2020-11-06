//
//  CreateMeetingViewController.swift
//  zoom_meeting
//
//  Created by Tommy on 2020/11/04.
//

import UIKit
import Eureka
import Floaty
import MobileRTC
import MobileCoreServices
import PKHUD
import RealmSwift
import Alamofire

class CreateMeetingViewController: FormViewController, FloatyDelegate {
    
    struct MeetingInfo: Codable {
        let title: String
        let start: Int
        let link: String
        let agenda: [AgendaInfo]
    }
    
    struct AgendaInfo: Codable {
        let title: String
        let duration: Int
    }
    
    var index = 1
    var sharedAuthService:  MobileRTCAuthService?
    var preMeetingService: MobileRTCPremeetingService?
    var userInfo: MobileRTCAccountInfo?
    
    var meetingTitle = ""
    var meetingTime = ""
    var meetingUrl = ""
    var images: [String] = []
    
    var realm: Realm!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        // Zoom SDK
        sharedAuthService = MobileRTC.shared().getAuthService()
        preMeetingService = MobileRTC.shared().getPreMeetingService()
        preMeetingService?.delegate = self
        
        if sharedAuthService?.isLoggedIn() ?? false {
            userInfo = sharedAuthService?.getAccountInfo()
        }
        // Form
        form
            +++ Section("ミーティング情報")
            <<< TextRow("title") { row in
                row.title = "タイトル"
                row.placeholder = "定例会議"
            }
            <<< DateTimeInlineRow("date") { row in
                row.title = "開始時間"
                row.minimumDate = Date()
                row.value = Date()
            }
            <<< SwitchRow("beforeHost") { row in
                row.title = "ホストより前の入室を許可する"
            }
            +++ Section("アジェンダ")
            <<< TextRow("title\(index)") { row in
                row.title = "議題"
                row.placeholder = "議題を入力"
            }
            <<< IntRow("time\(index)") { row in
                row.title = "時間(分)"
                row.placeholder = "(分)"
            }
        
        // FAB
        let floaty = Floaty()
        floaty.fabDelegate = self
        floaty.plusColor = .white
        self.view.addSubview(floaty)
        
        // Realm
        realm = try! Realm()
    }
    
    @IBAction func create() {
        HUD.show(.progress)
        var totalTime = 0
        for i in 1...index {
            let timeRow = form.rowBy(tag: "time\(i)") as! IntRow
            totalTime += timeRow.value ?? 0
        }
        
        guard let meetingService = preMeetingService,
              let meeting = meetingService.createMeetingItem()
        else { return }
        let titleRow = form.rowBy(tag: "title") as! TextRow
        let startingDateRow = form.rowBy(tag: "date") as! DateTimeInlineRow
        let beforeHostRow = form.rowBy(tag: "beforeHost") as! SwitchRow
        meetingTitle = titleRow.value ?? "Untitled"
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy年MM月dd日HH:mm~"
        let date = startingDateRow.value ?? Date()
        meetingTime = dateFormatter.string(from: date)
        
        meeting.setMeetingTopic(meetingTitle)
        meeting.setStartTime(date)
        meeting.setDurationInMinutes(UInt(TimeInterval(totalTime)))
        meeting.setAllowJoinBeforeHost(beforeHostRow.value ?? false)
        
        meetingService.scheduleMeeting(meeting, withScheduleFor: userInfo?.getEmailAddress())
        meetingService.destroy(meeting)
    }
    
    func createMeetingInfo(title: String, startingDate: Date, link: String) {
        var agendaInfos: [AgendaInfo] = []
        
        for i in 1...index {
            let titleRow = form.rowBy(tag: "title\(i)") as! TextRow
            let agendaTitle = titleRow.value ?? "Untitled"
            let timeRow = form.rowBy(tag: "time\(i)") as! IntRow
            let time = timeRow.value ?? 0
            agendaInfos.append(AgendaInfo(title: agendaTitle, duration: time * 60))
            let newAgenda = Agenda()
            newAgenda.title = agendaTitle
            newAgenda.duration = time * 60
        }
        
        let timeInUnix = startingDate.timeIntervalSince1970
        
        let meetingInfo = MeetingInfo(title: title,
                                      start: Int(timeInUnix),
                                      link: link,
                                      agenda: agendaInfos)
        Alamofire.request("https://aika.lit-kansai-mentors.com/meetingaction",
                          method: .post,
                          parameters: makeParameters(info: meetingInfo),
                          encoding: JSONEncoding.default, headers: nil)
            .responseJSON { response in
                if let result = response.result.value as? [String: Any] {
                    do {
                        let stringVal = result["agenda"] as! String
                        let json = stringVal.data(using: .utf8)!
                        let decoder = JSONDecoder()
                        let objs = try decoder.decode([[String:String]].self, from: json)
                        for img in objs {
                            if let imgString = img["photo"] {
                                self.images.append(imgString)
                            }
                        }
                    } catch {
                        HUD.flash(.error, delay: 1.0)
                    }
                    let meeting = Meeting()
                    meeting.uuid = result["id"] as! String
                    meeting.title = title
                    self.meetingUrl = result["url"] as! String
                    meeting.link = self.meetingUrl
                    meeting.start = startingDate
                    for agendaInfo in meetingInfo.agenda {
                        let agenda = Agenda()
                        agenda.title = agendaInfo.title
                        agenda.duration = agendaInfo.duration
                        meeting.agenda.append(agenda)
                    }
                    try! self.realm.write {
                        self.realm.add(meeting)
                    }
                    HUD.flash(.success, delay: 1.0)
                    self.performSegue(withIdentifier: "toShare", sender: self)
                } else {
                    HUD.flash(.error, delay: 1.0)
                }
            }
    }
    
    func emptyFloatySelected(_ floaty: Floaty) {
        index += 1
        let titleRow = TextRow("title\(index)") {
            $0.title = "議題"
            $0.placeholder = "議題を入力"
        }
        let timeRow = IntRow("time\(index)") {
            $0.title = "時間(分)"
            $0.placeholder = "(分)"
        }
        let section = Section()
        section.append(titleRow)
        section.append(timeRow)
        form.append(section)
    }
    
    func makeParameters(info: MeetingInfo) -> Parameters {
        var agendas: [[String:Any]] = []
        for agenda in info.agenda {
            agendas.append(["title": agenda.title, "duration": agenda.duration * 60])
        }
        let params = [
            "request": "create",
            "title": info.title,
            "start": info.start,
            "link": info.link,
            "agenda": agendas
        ] as [String : Any]
        return params
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "toShare" {
            let nextVC = segue.destination as! ShareViewController
            nextVC.meetingTitle = self.meetingTitle
            nextVC.meetingTime = self.meetingTime
            nextVC.imgStrings = self.images
            nextVC.meetingUrl = self.meetingUrl
        }
    }
}

extension CreateMeetingViewController: MobileRTCPremeetingDelegate {
    func sinkSchedultMeeting(_ result: PreMeetingError, meetingUniquedID uniquedID: UInt64) {
        guard result.rawValue == 0 else {
            print("Zoom (User): Schedule meeting task failed, error code: \(result)")
            HUD.flash(.error, delay: 1.0)
            return
        }
        
        print("Zoom (User): Schedule meeting task completed.")
        let meeting = preMeetingService?.getMeetingItem(byUniquedID: uniquedID)
        guard let id = meeting?.getMeetingNumber(),
              let pass = meeting?.getMeetingPassword() else {
            HUD.flash(.error, delay: 1.0)
            return
        }
        
        createMeetingInfo(
            title: meeting?.getMeetingTopic() ?? "Untitled",
            startingDate: meeting?.getStartTime() ?? Date(),
            link: "zoommtg://zoom.us/join?confno=\(id)&pwd=\(pass)")
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
