//
//  InstrumentTablePresenter.swift
//  metronome
//
//  Created by Egor on 3/19/20.
//  Copyright © 2020 Egor. All rights reserved.
//

import Foundation

// MARK: - Main

class InstrumentTablePresenter: EditableTablePresenter {
    
    required init(view: EditableTableViewProtocol, model: TableProtocol, vibrationManager: VibrationManagerProtocol, soundManager: SoundManagerProtocol) {
        super.init(view: view, model: model, vibrationManager: vibrationManager, soundManager: soundManager)
        
        dataForCollection = Instrument.all
    }
    
}
