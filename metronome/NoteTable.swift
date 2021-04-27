//
//  NoteTable.swift
//  metronome
//
//  Created by Egor on 3/19/20.
//  Copyright © 2020 Egor. All rights reserved.
//

import Foundation

// MARK: - Main

struct NoteTable: TableProtocol {
  var data: [[Data?]] = GlobalSettings.STANDART_NOTES
}
