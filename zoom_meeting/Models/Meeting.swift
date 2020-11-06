//
//  Meeting.swift
//  zoom_meeting
//
//  Created by Tommy on 2020/11/06.
//

import Foundation
import RealmSwift

class Meeting: Object {
    @objc dynamic var uuid = ""
    @objc dynamic var title = ""
    @objc dynamic var start: Date = Date()
    @objc dynamic var link = ""
    let agenda = List<Agenda>()
}

class Agenda: Object {
    @objc dynamic var title = ""
    @objc dynamic var duration = 0
}
