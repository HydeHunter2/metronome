//
//  Instrument.swift
//  metronome
//
//  Created by Egor on 1/19/20.
//  Copyright © 2020 Egor. All rights reserved.
//

import Foundation

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
    
    
    static var all: [Data?] = [nil, Instrument.snare, Instrument.bass, Instrument.hi_hat]
}
