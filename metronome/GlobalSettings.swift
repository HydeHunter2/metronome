//
//  GlobalSettings.swift
//  metronome
//
//  Created by Egor on 3/18/20.
//  Copyright © 2020 Egor. All rights reserved.
//

import Foundation

// MARK: - Main

struct GlobalSettings {
    static let MIN_BPM = 60
    static let MAX_BPM = 240
    static let MIN_TAPS = 3
    static let MAX_TAPS = 6
    static let STRING_OF_NILDATA = "None"
    static let NAME_OF_UNTITLED_PRESET = "Metronome"
    static let STRING_OF_PRESETS_KEY_SAVING = "METRONOME_STORAGE_OF_PRESETS"
    static let STANDART_NUMBER_OF_TICKS = 4
    static let STANDART_NUMBER_OF_DATA_IN_TICK = 4
    static let STANDART_INSTRUMENTS: [[Instrument?]] = [
            [.bass, .hi_hat],
            [.bass],
            [.bass, .snare],
            [.bass],
        ]
    static let STANDART_NOTES: [[Note?]] = [
            [nil],
            [nil],
            [nil],
            [nil],
        ]
    
    static let RANGE_OF_TICKS_TO_TEST = (GlobalSettings.STANDART_NUMBER_OF_TICKS..<4*GlobalSettings.STANDART_NUMBER_OF_TICKS)
    static let RANGE_OF_DATA_IN_TICK_TO_TEST = (GlobalSettings.STANDART_NUMBER_OF_DATA_IN_TICK..<4*GlobalSettings.STANDART_NUMBER_OF_DATA_IN_TICK)
    static let RANGE_OF_PRESETS_TO_TEST = 4..<8
}
