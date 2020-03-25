//
//  Storage.swift
//  metronome
//
//  Created by Egor on 3/24/20.
//  Copyright © 2020 Egor. All rights reserved.
//

import Foundation

// MARK: - Protocols

protocol StorageProtocol {
    func getData() -> [StorageObjectProtocol]
    func setData(_ data: [StorageObjectProtocol])
}

protocol StorageObjectProtocol: NSObject, NSCoding {}

// MARK: - Main

class Storage<Object: StorageObjectProtocol>: StorageProtocol {
    
    // MARK: - Initialization
    
    var userDefaults = UserDefaults.standard
    var keySaving: String
    
    init(withKeySavingString keySaving: String) {
        self.keySaving = keySaving
    }
    
    func getData() -> [StorageObjectProtocol] {
        guard let decoded = userDefaults.data(forKey: keySaving),
              let presets = NSKeyedUnarchiver.unarchiveObject(with: decoded) as? [Object]
              else {
                return []
              }
        
        return presets
    }
    
    func setData(_ data: [StorageObjectProtocol]) {
        guard let data = data as? [Object] else { return }
        userDefaults.set(NSKeyedArchiver.archivedData(withRootObject: data), forKey: keySaving)
        userDefaults.synchronize()
    }
    
}
