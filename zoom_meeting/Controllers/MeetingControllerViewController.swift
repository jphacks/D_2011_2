//
//  MeetingControllerViewController.swift
//  zoom_meeting
//
//  Created by Tommy on 2020/11/06.
//

import UIKit

class MeetingControllerViewController: UIViewController {
    
    @IBOutlet var timerLabel: UILabel!
    @IBOutlet var titleLabel: UILabel!
    @IBOutlet var dateLabel: UILabel!
    @IBOutlet var topicLabel: UILabel!
    
    var meeting: Meeting!

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        titleLabel.text = meeting.title
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy年MM月dd日HH:mm~"
        dateLabel.text = dateFormatter.string(from: meeting.start)
        topicLabel.text = meeting.agenda[0].title
    }
    
    @IBAction func plusFive() {
        
    }
    
    @IBAction func minusFive() {
        
    }
    
    @IBAction func editDetail() {
        
    }
    
    @IBAction func nextTopic() {
        
    }
    
    @IBAction func finish() {
        
    }
}
