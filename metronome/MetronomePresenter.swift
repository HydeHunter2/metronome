//
//  MetronomePresenter.swift
//  metronome
//
//  Created by Egor on 3/18/20.
//  Copyright © 2020 Egor. All rights reserved.
//

import Foundation

// MARK: - Protocols

protocol MetronomeViewProtocol: class {
    func setValueOnPicker(to bpm: Int)
    func putPauseImageOnPowerButton()
    func putPlayImageOnPowerButton()
    func disableIdleTimer()
    func enableIdleTimer()
}

protocol MetronomePresenterProtocol {
    init(view: MetronomeViewProtocol, model: Metronome, vibrationManager: VibrationManagerProtocol, soundManager: SoundManagerProtocol)
    func togglePower()
    func tempoTap()
    func changeBPM(to bpm: Int)
    func openSettings()
}

protocol ParentOfMetronomePresenterProtocol {
    var unwindFunctionFromSettings: ((_ data: Preset) -> ())? { get set }
    func moveToSettings(withData data: Preset)
}

protocol ChildMetronomePresenterProtocol {
    var parentPresenter: ParentOfMetronomePresenterProtocol? { get set }
    var metronome: Metronome { get set }
    func togglePower()
}

// MARK: - Main

class MetronomePresenter: MetronomePresenterProtocol, ChildMetronomePresenterProtocol, TapTempoDelegate {
    
    // MARK: - Initialization
    
    var parentPresenter: ParentOfMetronomePresenterProtocol?
    
    unowned let view: MetronomeViewProtocol
    var metronome: Metronome
    let vibrationManager: VibrationManagerProtocol
    let soundManager: SoundManagerProtocol
    
    let tempoCreator = TempoCreator()
    
    required init(view: MetronomeViewProtocol, model: Metronome, vibrationManager: VibrationManagerProtocol, soundManager: SoundManagerProtocol) {
        self.view = view
        self.metronome = model
        self.vibrationManager = vibrationManager
        self.soundManager = soundManager
        
        tempoCreator.delegate = self
        metronome.delegate = self
    }
    
    // MARK: - Public
    
    func togglePower() {
        vibrationManager.selectionChanged()
        if metronome.isOff {
            turnOnMetronome()
        }
        else if metronome.isOn {
            turnOffMetronome()
        }
    }
    
    func changeBPM(to bpm: Int) {
        turnOffMetronome()
        metronome.BPM = validateBPM(bpm)
        view.setValueOnPicker(to: metronome.BPM)
    }
    
    func tempoTap() {
        tempoCreator.tap()
        vibrationManager.softImpact()
    }
    
    func openSettings() {
        parentPresenter?.unwindFunctionFromSettings = { data in
            self.metronome.beats = data.beats
            self.metronome.BPM = data.BPM
        }
        parentPresenter?.moveToSettings(withData: Preset(title: GlobalSettings.NAME_OF_UNTITLED_PRESET, beats: metronome.beats, BPM: metronome.BPM))
    }
    
    // MARK: - Private
    
    private func validateBPM(_ bpm: Int) -> Int {
        if bpm > GlobalSettings.MAX_BPM {
            return GlobalSettings.MAX_BPM
        } else if bpm < GlobalSettings.MIN_BPM {
            return GlobalSettings.MIN_BPM
        }
        return bpm
    }
    
    private func turnOnMetronome() {
        view.putPauseImageOnPowerButton()
        view.disableIdleTimer()
        
        soundManager.wipe()
        metronome.tick = 0
        metronome.isOn = true
        
        soundManager.playIntro(withTickDuration: metronome.tickDuration)
    }
    
    private func turnOffMetronome() {
        view.putPlayImageOnPowerButton()
        view.enableIdleTimer()
        
        metronome.isOff = true
        soundManager.off()
    }
    
}

// MARK: - Extensions

extension MetronomePresenter: MetronomeDelegate {
    
    func ticked() {
        if metronome.beats.count == 0 { return }
        
        let tickInstruments = metronome.beats[metronome.tick].instruments.map{Sound(name: $0?.name() ?? GlobalSettings.STRING_OF_NILDATA)}
        let tickNotes = metronome.beats[metronome.tick].notes.map{Sound(name: $0?.name() ?? GlobalSettings.STRING_OF_NILDATA)}
        soundManager.playTick(withSounds: tickInstruments + tickNotes, tickDuration: metronome.tickDuration)
        metronome.increaseTick()
    }
    
}
