//
//  MeetingControllerViewController.swift
//  zoom_meeting
//
//  Created by Tommy on 2020/11/06.
//

import UIKit
import Alamofire

class MeetingControllerViewController: UIViewController {
    
    @IBOutlet var timerLabel: UILabel!
    @IBOutlet var titleLabel: UILabel!
    @IBOutlet var dateLabel: UILabel!
    @IBOutlet var topicLabel: UILabel!
    
    var meeting: Meeting!
    
    var timer: Timer!
    var count = 0
    var index = 0
    
    var isMuted = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        titleLabel.text = meeting.title
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy年MM月dd日HH:mm~"
        dateLabel.text = dateFormatter.string(from: meeting.start)
        topicLabel.text = meeting.agenda[index].title
        count = meeting.agenda[index].duration * 60
        timer = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(self.tik), userInfo: nil, repeats: true)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        let parameters = [
            "request": "start",
            "id": meeting.uuid,
            "meetingid": meeting.meetingId,
            "meetingpass": meeting.meetingPass,
            "title": meeting.agenda[index].title,
            "duration": meeting.agenda[index].duration * 60,
        ] as [String : Any]
        
        Alamofire.request("https://aika.lit-kansai-mentors.com/meetingaction",
                          method: .post,
                          parameters: parameters,
                          encoding: JSONEncoding.default, headers: nil)
            .responseJSON { response in
                if let result = response.result.value as? [String: Any] {
                    if result["status"] as! String == "error" {
                        self.showError()
                    }
                }
            }
    }
    
    @IBAction func plus() {
        showActionSheet(isPositive: true)
    }
    
    @IBAction func minus() {
        showActionSheet(isPositive: false)
    }
    
    func customEdit(isPositive: Bool) {
        let alert = UIAlertController(
            title: isPositive ? "何分追加しますか？" : "何分減らしますか？",
            message: nil,
            preferredStyle: .alert)
        
        let okAction = UIAlertAction(title: "OK", style: .default) { (action:UIAlertAction) in
            guard let textFields:[UITextField] = alert.textFields else {return}
            for textField in textFields {
                if textField.tag == 1 {
                    if let min = Int(textField.text ?? "") {
                        if isPositive {
                            self.count += min  * 60
                        } else {
                            self.count -= min  * 60
                        }
                    }
                }
            }
        }
        alert.addAction(okAction)
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        alert.addAction(cancelAction)
        
        alert.addTextField { (text: UITextField!) in
            text.placeholder = "(分)"
            text.keyboardType = .numberPad
            text.tag = 1
        }
        present(alert, animated: true, completion: nil)
    }
    
    func showActionSheet(isPositive: Bool) {
        let title = isPositive ? "時間を追加する" : "時間を減らす"
        let prefix = isPositive ? "+" : "-"
        let alert = UIAlertController(title: title, message: nil, preferredStyle: .actionSheet)
        
        let fiveButton = UIAlertAction(title: "\(prefix)5分", style: .default) { (action:UIAlertAction) in
            let additional = isPositive ? 5 : -5
            self.count += additional * 60
        }
        alert.addAction(fiveButton)
        
        let oneButton = UIAlertAction(title: "\(prefix)1分", style: .default) { (action:UIAlertAction) in
            let additional = isPositive ? 1 : -1
            self.count += additional  * 60
        }
        alert.addAction(oneButton)
        
        let customButton = UIAlertAction(title: "カスタム", style: .default) { (action:UIAlertAction) in
            self.customEdit(isPositive: isPositive)
        }
        alert.addAction(customButton)
        
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        alert.addAction(cancelAction)
        present(alert, animated: true, completion: nil)
    }
    
    @IBAction func nextTopic() {
        index += 1
        next()
    }
    
    @IBAction func finishTapped() {
        finish()
    }
    
    func finish() {
        let alert: UIAlertController = UIAlertController(title: "すべての議題が終了しました。", message: nil, preferredStyle: .alert)
        let okAction: UIAlertAction = UIAlertAction(title: "OK", style: .default) { (_) in
            let parameters = [
                "request": "finish",
                "id": self.meeting.uuid,
            ] as [String : Any]
            
            Alamofire.request("https://aika.lit-kansai-mentors.com/meetingaction",
                              method: .post,
                              parameters: parameters,
                              encoding: JSONEncoding.default, headers: nil)
                .responseJSON { response in
                    if let result = response.result.value as? [String: Any] {
                        if result["status"] as! String == "success" {
                            self.presentingViewController?.presentingViewController?.dismiss(animated: true, completion: nil)
                        } else {
                            self.showError()
                        }
                    }
                }
        }
        alert.addAction(okAction)
        self.present(alert, animated: true, completion: nil)
    }
    
    func next() {
        timer.invalidate()
        isMuted = false
        if index == meeting.agenda.count {
            timer.invalidate()
            finish()
        } else {
            let parameters = [
                "request": "next",
                "id": meeting.uuid,
                "duration": meeting.agenda[index].duration * 60,
                "title": meeting.agenda[index].title
            ] as [String : Any]
            
            Alamofire.request("https://aika.lit-kansai-mentors.com/meetingaction",
                              method: .post,
                              parameters: parameters,
                              encoding: JSONEncoding.default, headers: nil)
                .responseJSON { response in
                    if let result = response.result.value as? [String: Any] {
                        if result["status"] as! String == "error" {
                            self.showError()
                        }
                    }
                }
            count = meeting.agenda[index].duration * 60
            timerLabel.text = "\(Int(count / 60)):\(Int(count % 60))"
            topicLabel.text = meeting.agenda[index].title
            timer = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(self.tik), userInfo: nil, repeats: true)
        }
    }
    
    func mute() {
        timer.invalidate()
        isMuted = true
        let parameters = [
            "request": "mute",
            "id": meeting.uuid,
        ] as [String : Any]
        
        Alamofire.request("https://aika.lit-kansai-mentors.com/meetingaction",
                          method: .post,
                          parameters: parameters,
                          encoding: JSONEncoding.default, headers: nil)
            .responseJSON { response in
                if let result = response.result.value as? [String: Any] {
                    if result["status"] as! String == "error" {
                        self.showError()
                    }
                }
            }
        let alert: UIAlertController = UIAlertController(title: "時間になりました。", message: "次の議題に移るには「次の議題」を押してください。", preferredStyle: .alert)
        let okAction: UIAlertAction = UIAlertAction(title: "OK", style: .default, handler: nil)
        alert.addAction(okAction)
        self.present(alert, animated: true, completion: nil)
    }
    
    func showError() {
        let alert: UIAlertController = UIAlertController(title: "エラー", message: "エラーが発生しました", preferredStyle: .alert)
        let okAction: UIAlertAction = UIAlertAction(title: "OK", style: .default, handler: nil)
        alert.addAction(okAction)
        self.present(alert, animated: true, completion: nil)
    }
    
    @objc func tik() {
        count -= 1
        timerLabel.text = "\(Int(count / 60)):\(String(format: "%02d", Int(count % 60)))"
        timerLabel.font = .boldSystemFont(ofSize: 40)
        if count <= 0 && !isMuted {
            mute()
            timerLabel.text = "時間になりました"
            timerLabel.font = .boldSystemFont(ofSize: 30)
        }
    }
}
