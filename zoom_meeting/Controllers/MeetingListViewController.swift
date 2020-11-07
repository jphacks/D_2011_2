//
//  MeetingListViewController.swift
//  zoom_meeting
//
//  Created by Tommy on 2020/11/06.
//

import UIKit
import RealmSwift

class MeetingListViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    @IBOutlet var table: UITableView!
    var realm: Realm!
    var meetings: [Meeting] = []
    
    var selectedMeeting: Meeting?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        table.delegate = self
        table.dataSource = self
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        // Realm
        realm = try! Realm()
        let realmData = realm.objects(Meeting.self)
        meetings = Array(realmData).filter { $0.start >= Date() }
        table.reloadData()
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return meetings.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell: UITableViewCell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        cell.textLabel?.text = meetings[indexPath.row].title
        let dateFormatter = DateFormatter()
        dateFormatter.dateStyle = .medium
        dateFormatter.timeStyle = .short
        
        let dateString = dateFormatter.string(from: meetings[indexPath.row].start)
        cell.detailTextLabel?.text = dateString
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        table.deselectRow(at: indexPath, animated: true)
        let alert: UIAlertController = UIAlertController(title: "ミーティングを開始してもよろしいですか？", message: "アプリを開始する前にミーティングさせてください", preferredStyle: .alert)
        let okAction: UIAlertAction = UIAlertAction(title: "OK", style: .default) { (_) in
            self.selectedMeeting = self.meetings[indexPath.row]
            self.performSegue(withIdentifier: "toStart", sender: self)
        }
        let cancelAction: UIAlertAction = UIAlertAction(title: "キャンセル", style: .cancel, handler: nil)
        alert.addAction(okAction)
        alert.addAction(cancelAction)
        self.present(alert, animated: true, completion: nil)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "toStart", let targetMeeting = selectedMeeting {
            let nextVC = segue.destination as! MeetingControllerViewController
            nextVC.meeting = targetMeeting
        }
    }
}
