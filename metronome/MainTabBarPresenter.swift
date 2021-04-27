//
//  MainTabBarPresenter.swift
//  metronome
//
//  Created by Egor on 3/20/20.
//  Copyright © 2020 Egor. All rights reserved.
//

import Foundation

// MARK: - Protocols

protocol MainTabBarControllerProtocol: class {
  func showCollection()
  func showSettings()
}

protocol MainTabBarPresenterProtocol {
  init(controller: MainTabBarControllerProtocol,
       metronome: ChildMetronomePresenterProtocol,
       settings: ChildSettingsPresenterProtocol,
       instrument: ChildEditableTablePresenterProtocol,
       note: ChildEditableTablePresenterProtocol,
       collection: ChildCollectionPresenterProtocol,
       storageManager: StorageManagerProtocol,
       soundManager: SoundManagerProtocol,
       vibrationManager: VibrationManagerProtocol)
  func passDataToMetronomePresenter()
  func syncData()
}

// MARK: - Main

class MainTabBarPresenter: MainTabBarPresenterProtocol,
                           ParentOfEditableTablePresenterProtocol,
                           ParentOfCollectionPresenterProtocol,
                           ParentOfMetronomePresenterProtocol,
                           ParentOfSettingsPresenterProtocol {

  // MARK: - Initialization

  var storageManager: StorageManagerProtocol
  var soundManager: SoundManagerProtocol
  var vibrationManager: VibrationManagerProtocol

  unowned let controller: MainTabBarControllerProtocol

  var metronomePresenter: ChildMetronomePresenterProtocol
  var settingsPresenter: ChildSettingsPresenterProtocol
  var instrumentPresenter: ChildEditableTablePresenterProtocol
  var notePresenter: ChildEditableTablePresenterProtocol
  var collectionPresenter: ChildCollectionPresenterProtocol

  required init(controller: MainTabBarControllerProtocol,
                metronome: ChildMetronomePresenterProtocol,
                settings: ChildSettingsPresenterProtocol,
                instrument: ChildEditableTablePresenterProtocol,
                note: ChildEditableTablePresenterProtocol,
                collection: ChildCollectionPresenterProtocol,
                storageManager: StorageManagerProtocol,
                soundManager: SoundManagerProtocol,
                vibrationManager: VibrationManagerProtocol) {
    self.storageManager = storageManager
    self.soundManager = soundManager
    self.vibrationManager = vibrationManager

    self.controller = controller

    self.metronomePresenter = metronome
    self.settingsPresenter = settings
    self.instrumentPresenter = instrument
    self.notePresenter = note
    self.collectionPresenter = collection

    metronomePresenter.parentPresenter = self
    settingsPresenter.parentPresenter = self
    instrumentPresenter.parentPresenter = self
    notePresenter.parentPresenter = self
    collectionPresenter.parentPresenter = self
  }

  // MARK: - Public

  func passDataToMetronomePresenter() {
    var data = [(instruments: [Instrument?], notes: [Note?])]()

    for index in 0..<instrumentPresenter.table.data.count {
      let instumentTick: [Instrument?] = instrumentPresenter.table.data[index] as! [Instrument?]
      var noteTick: [Note?] = []

      if index < notePresenter.table.data.count {
        noteTick = notePresenter.table.data[index] as! [Note?]
      }

      data += [(instruments: instumentTick, notes: noteTick)]
    }

    metronomePresenter.metronome.beats = data
    syncData()
  }

  func syncData() {
    let instrumentData = metronomePresenter.metronome.beats.map { $0.instruments }
    let noteData =  metronomePresenter.metronome.beats.map { $0.notes }

    instrumentPresenter.table.data = instrumentData
    notePresenter.table.data = noteData

    instrumentPresenter.updateTable()
    notePresenter.updateTable()

    stopMetronome()
  }

  // MARK: - Private

  private func stopMetronome() {
    if metronomePresenter.metronome.isOn {
      metronomePresenter.togglePower()
    }
  }

  // MARK: - Extensions

  func moveToSettings(withData data: Preset) {
    settingsPresenter.settings.activePreset = data
    settingsPresenter.updateTitle()
    settingsPresenter.updateTable()
    controller.showSettings()

    stopMetronome()
  }
  var unwindFunctionFromSettings: ((_ data: Preset) -> Void)?
  func unwindFromSettings(withData data: Preset) {
    guard let unwind = unwindFunctionFromSettings else {
      return
    }
    unwind(data)
  }

  func moveToCollection(withData data: [Data?]) {
    collectionPresenter.collection.data = data
    collectionPresenter.updateCollection()
    controller.showCollection()
  }
  var unwindFunctionFromCollection: ((_ data: Data?) -> Void)?
  func unwindFromCollection(data: Data?) {
    guard let unwind = unwindFunctionFromCollection else {
      return
    }
    unwind(data)
  }
}
