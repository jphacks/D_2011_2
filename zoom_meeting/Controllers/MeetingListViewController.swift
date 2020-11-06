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
        print(realmData.count)
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
}
