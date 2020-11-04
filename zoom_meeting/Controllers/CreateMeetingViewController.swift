//
//  CreateMeetingViewController.swift
//  zoom_meeting
//
//  Created by Tommy on 2020/11/04.
//

import UIKit
import Eureka
import Floaty

class CreateMeetingViewController: FormViewController, FloatyDelegate {
    
    var index = 1
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        // Form
        form
            +++ Section("ミーティング情報")
            <<< TextRow("title") { row in
                row.title = "タイトル"
                row.placeholder = "定例会議"
            }
            <<< DateTimeInlineRow("date") { row in
                row.title = "開始時間"
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
    
    @IBAction func create() {
        for i in 1...index {
            let titleRow = form.rowBy(tag: "title\(i)") as! TextRow
            let title = titleRow.value!
            let timeRow = form.rowBy(tag: "time\(i)") as! IntRow
            let time = timeRow.value!
            print("\(title): \(time)")
        }
    }
}
