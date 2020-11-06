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
    @IBOutlet var shareButton: UIButton!
    @IBOutlet var backToTopButton: UIButton!
    
    var meetingTitle = ""
    var meetingTime = ""
    var encodedImageData = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // 角丸
        shareButton.layer.cornerRadius =  10
        backToTopButton.layer.cornerRadius = 10
        
        titleLabel.text = meetingTitle
        timeLabel.text = meetingTime
        
        // 画像エンコード
        if let imageData = NSData(base64Encoded: encodedImageData, options: .ignoreUnknownCharacters) {
            let image = UIImage(data: imageData as Data)
            agendaImageView.image = image
        }
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
        self.presentingViewController?.presentingViewController?.dismiss(animated: true, completion: nil)
    }
}