//
//  Table.swift
//  metronome
//
//  Created by Egor on 3/18/20.
//  Copyright © 2020 Egor. All rights reserved.
//

import Foundation

// MARK: - Protocols

protocol TableProtocol {
  var data: [[Data?]] { get set }
}

// MARK: - Main

struct Table: TableProtocol {
  var data: [[Data?]] = []
}
