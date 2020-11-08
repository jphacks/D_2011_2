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
    var meetingUrl = ""
    var imgStrings: [String] = []
    var images: [UIImage] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        titleLabel.text = meetingTitle
        timeLabel.text = meetingTime
        
        // 画像エンコード
        for imgString in imgStrings {
            if let imageData = NSData(base64Encoded: imgString, options: .ignoreUnknownCharacters), let image = UIImage(data: imageData as Data) {
                images.append(image)
            }
        }
        agendaImageView.image = images.first
    }
    
    @IBAction func share() {
        let shareText = meetingTitle
        let shareWebsite = NSURL(string: meetingUrl)!
        var activityItems = [shareText, shareWebsite] as [Any]
        for img in images {
            activityItems.append(img)
        }
        let activityVC = UIActivityViewController(activityItems: activityItems, applicationActivities: nil)
        activityVC.popoverPresentationController?.sourceView = self.view
        activityVC.popoverPresentationController?.sourceRect = CGRect(x: self.view.bounds.size.width / 2, y: self.view.bounds.size.height / 2, width: 1, height: 1)
        self.present(activityVC, animated: true, completion: nil)
    }
    
    @IBAction func backToHome() {
        self.presentingViewController?.presentingViewController?.dismiss(animated: true, completion: nil)
    }
}
