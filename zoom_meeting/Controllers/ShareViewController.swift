//
//  ShareViewController.swift
//  zoom_meeting
//
//  Created by Tommy on 2020/11/05.
//

import UIKit

class ShareViewController: UIViewController {
    
    @IBOutlet var titleLabel: UILabel!
    @IBOutlet var timeLabel: UILabel!
    @IBOutlet var agendaImageView: UIImageView!
    
    var meetingTitle = ""
    var meetingTime = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        titleLabel.text = meetingTitle
        timeLabel.text = meetingTime
    }
    
    @IBAction func share() {
        let shareText = meetingTitle
        let shareWebsite = NSURL(string: "https://life-is-tech.com/")!
        var activityItems = [shareText, shareWebsite] as [Any]
        if agendaImageView.image != nil {
            activityItems.append(agendaImageView.image!)
        }
        let activityVC = UIActivityViewController(activityItems: activityItems, applicationActivities: nil)
        self.present(activityVC, animated: true, completion: nil)
    }
    
    @IBAction func backToHome() {
        navigationController?.popToRootViewController(animated: true)
    }
}
