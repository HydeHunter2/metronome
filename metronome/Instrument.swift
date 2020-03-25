//
//  Instrument.swift
//  metronome
//
//  Created by Egor on 1/19/20.
//  Copyright © 2020 Egor. All rights reserved.
//

import Foundation

// MARK: - Main

enum Instrument: Data {
    
    case snare
    case bass
    case hi_hat
    
    func name() -> String {
        switch self {
            case .snare: return "Snare"
            case .bass: return "Bass"
            case .hi_hat: return "Hi-hat"
        }
    }
    
    static func getData(withName name: String) -> Data? {
        switch name {
            case "Snare": return Instrument.snare
            case "Bass": return Instrument.bass
            case "Hi-hat": return Instrument.hi_hat
            default: return nil
        }
    }
    
    static var all: [Data?] = [nil, Instrument.snare, Instrument.bass, Instrument.hi_hat]
}
