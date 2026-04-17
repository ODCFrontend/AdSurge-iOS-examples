//
//  SettingManager.swift
//  AdSurgeDemo-Swift
//
//  Created by katie on 2025/6/6.
//

import Foundation

class SettingManager {
    static let shared = SettingManager()

    var isMuted: Bool = false
    
    private init() {}
}
