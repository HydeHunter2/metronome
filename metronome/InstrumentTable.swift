//
//  InstrumentTable.swift
//  metronome
//
//  Created by Egor on 3/19/20.
//  Copyright © 2020 Egor. All rights reserved.
//

import Foundation

// MARK: - Main

struct InstrumentTable: TableProtocol {
  var data: [[Data?]] = GlobalSettings.STANDART_INSTRUMENTS
}
