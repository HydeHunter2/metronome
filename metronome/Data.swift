//
//  Data.swift
//  metronome
//
//  Created by Egor on 1/24/20.
//  Copyright © 2020 Egor. All rights reserved.
//

import Foundation

// MARK: - Main

protocol Data {
    func name() -> String
    static func getData(withName name: String) -> Data?
    static var all: [Data?] { get set }
}
