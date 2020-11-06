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
    
    var meetings: Results<Meeting>!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        table.delegate = self
        table.dataSource = self
        
        // Realm
        realm = try! Realm()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        meetings = realm.objects(Meeting.self)
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
        dateFormatter.timeStyle = .medium

        let dateString = dateFormatter.string(from: meetings[indexPath.row].start)
        cell.detailTextLabel?.text = dateString
        return cell
    }
}
