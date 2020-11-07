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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        titleLabel.text = meeting.title
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy年MM月dd日HH:mm~"
        dateLabel.text = dateFormatter.string(from: meeting.start)
        topicLabel.text = meeting.agenda[0].title
        count = meeting.agenda[0].duration * 60
        timer = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(self.tik), userInfo: nil, repeats: true)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        let parameters = [
            "request": "start",
            "id": meeting.uuid,
            "meetingid": meeting.meetingId,
            "meetingpass": meeting.meetingPass,
            "title": meeting.agenda[0].title,
            "duration": meeting.agenda[0].duration * 60,
        ] as [String : Any]
        
        Alamofire.request("https://aika.lit-kansai-mentors.com/meetingaction",
                          method: .post,
                          parameters: parameters,
                          encoding: JSONEncoding.default, headers: nil)
            .responseJSON { response in
                if let result = response.result.value as? [String: Any] {
                    if result["status"] as! String == "error" {
                        self.showError(message: response.result.value as! String)
                    }
                }
            }
    }
    
    @IBAction func plusFive() {
        count += 300
    }
    
    @IBAction func minusFive() {
        count -= 300
    }
    
    @IBAction func editDetail() {
        //アラートコントローラー
        let alert = UIAlertController(title: "時間を追加/減らす", message: "例: 5分減らす場合: -5\n5分増やす場合: 5", preferredStyle: .alert)
        
        //OKボタンを生成
        let okAction = UIAlertAction(title: "OK", style: .default) { (action:UIAlertAction) in
            //複数のtextFieldのテキストを格納
            guard let textFields:[UITextField] = alert.textFields else {return}
            //textからテキストを取り出していく
            for textField in textFields {
                if textField.tag == 1 {
                    if let min = Int(textField.text ?? "") {
                        self.count -= min  * 60
                    }
                }
            }
        }
        alert.addAction(okAction)
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        alert.addAction(cancelAction)
        
        alert.addTextField { (text:UITextField!) in
            text.placeholder = "追加する時間 (分)"
            text.keyboardType = .decimalPad
            text.tag = 1
        }
        present(alert, animated: true, completion: nil)
    }
    
    @IBAction func nextTopic() {
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
                            self.showError(message: response.result.value as! String)
                        }
                    }
                }
        }
        alert.addAction(okAction)
        self.present(alert, animated: true, completion: nil)
    }
    
    func next() {
        timer.invalidate()
        index += 1
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
                            self.showError(message: response.result.value as! String)
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
                        self.showError(message: response.result.value as! String)
                    }
                }
            }
        let alert: UIAlertController = UIAlertController(title: "時間になりました。", message: "次の議題に移るには「次の議題」を押してください。", preferredStyle: .alert)
        let okAction: UIAlertAction = UIAlertAction(title: "OK", style: .default, handler: nil)
        alert.addAction(okAction)
        self.present(alert, animated: true, completion: nil)
    }
    
    func showError(message: String) {
//        "エラーが発生しました",
        let alert: UIAlertController = UIAlertController(title: "エラー", message: message, preferredStyle: .alert)
        let okAction: UIAlertAction = UIAlertAction(title: "OK", style: .default, handler: nil)
        alert.addAction(okAction)
        self.present(alert, animated: true, completion: nil)
    }
    
    @objc func tik() {
        count -= 1
        timerLabel.text = "\(Int(count / 60)):\(String(format: "%02d", Int(count % 60)))"
        timerLabel.font = .boldSystemFont(ofSize: 40)
        if count <= 0 {
            mute()
            timerLabel.text = "時間になりました"
            timerLabel.font = .boldSystemFont(ofSize: 30)
        }
    }
}
