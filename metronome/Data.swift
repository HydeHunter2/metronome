//
//  Data.swift
//  metronome
//
//  Created by Egor on 1/24/20.
//  Copyright © 2020 Egor. All rights reserved.
//

import Foundation

protocol Data {
    func name() -> String
    static var all: [Data?] { get set }
}
