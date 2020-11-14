//
//  keyManager.swift
//  zoom_meeting
//
//  Created by Tommy on 2020/11/02.
//

import Foundation

struct KeyManager {
    private let keyFilePath = Bundle.main.path(forResource: "keys", ofType: "plist")

    func getKeys() -> NSDictionary? {
        guard let keyFilePath = keyFilePath else {
            return nil
        }
        return NSDictionary(contentsOfFile: keyFilePath)
    }

    func getValue(key: String) -> String {
        guard let keys = getKeys() else {
            return ""
        }
        return keys[key] as! String
    }

}
