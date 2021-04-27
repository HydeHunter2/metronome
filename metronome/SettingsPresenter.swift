//
//  SettingsPresenter.swift
//  metronome
//
//  Created by Egor on 3/23/20.
//  Copyright © 2020 Egor. All rights reserved.
//

import Foundation

// MARK: - Protocols

protocol SettingsViewProtocol: class {
  func close()
  func showAlert(withTitle title: String,
                 message: String,
                 okayString: String,
                 okayFunction: (() -> Void)?,
                 cancelString: String,
                 cancelFunction: (() -> Void)?)
  func removeTableRow(withIndex index: Int)
  func getTitle() -> String
  func setTitle(_ title: String)
  func updateTable()
}

protocol SettingsPresenterProtocol {
  init(view: SettingsViewProtocol, model: Settings)
  func getNumberOfPresets() -> Int
  func getTitleOfActivePreset() -> String
  func selectRow(withIndex index: Int)
  func deleteRow(withIndex index: Int)
  func save()
  func getNameOfRow(withIndex index: Int) -> String
  func getNumberOfTicks(inRowWithIndex index: Int) -> Int
}

protocol ParentOfSettingsPresenterProtocol {
  var storageManager: StorageManagerProtocol { get set }
  var vibrationManager: VibrationManagerProtocol { get set }
  func unwindFromSettings(withData data: Preset)
}

protocol ChildSettingsPresenterProtocol {
  var parentPresenter: ParentOfSettingsPresenterProtocol? { get set }
  var settings: Settings { get set }
  func updateTable()
  func updateTitle()
}

// MARK: - Main

class SettingsPresenter: SettingsPresenterProtocol, ChildSettingsPresenterProtocol {

  // MARK: - Initialization

  var parentPresenter: ParentOfSettingsPresenterProtocol? {
    didSet {
      settings.presets = parentPresenter?.storageManager.getData() as! [Preset]
    }
  }

  unowned let view: SettingsViewProtocol
  var settings: Settings

  required init(view: SettingsViewProtocol, model: Settings) {
    self.view = view
    self.settings = model
  }

  // MARK: - Public

  func getTitleOfActivePreset() -> String {
    settings.activePreset.title
  }

  func updateTitle() {
    view.setTitle(getTitleOfActivePreset())
  }

  func getNameOfRow(withIndex index: Int) -> String {
    settings.presets[index].title
  }

  func getNumberOfTicks(inRowWithIndex index: Int) -> Int {
    settings.presets[index].beats.count
  }

  func getNumberOfPresets() -> Int {
    settings.presets.count
  }

  func selectRow(withIndex index: Int) {
    parentPresenter?.vibrationManager.successNotification()
    unwind(withPreset: settings.presets[index])
  }

  func deleteRow(withIndex index: Int) {
    settings.presets.remove(at: index)
    view.removeTableRow(withIndex: index)
    updateTable()
  }

  func save() {
    settings.activePreset.title = view.getTitle()
    let title = settings.activePreset.title

    if settings.presets.map({ $0.title }).contains(title) {
      parentPresenter?.vibrationManager.errorNotification()

      view.showAlert(withTitle: "Preset called \(settings.activePreset.title) already exists",
                     message: "Do you want to overwrite it?",
                     okayString: "Yes", okayFunction: {
                       let index = self.settings.presets.map({ $0.title }).firstIndex(of: title)!
                       self.overwritePreset(withIndex: index, on: self.settings.activePreset)
                     },
                     cancelString: "No",
                     cancelFunction: nil)

      return
    } else {
      parentPresenter?.vibrationManager.successNotification()
    }

    settings.presets.append(settings.activePreset)

    syncStorage()
    updateTable()

    unwind(withPreset: settings.activePreset)
  }

  func updateTable() {
    view.updateTable()
    parentPresenter?.vibrationManager.selectionChanged()
  }

  // MARK: - Private

  private func syncStorage() {
    parentPresenter?.storageManager.setData(settings.presets)
  }

  private func unwind(withPreset preset: Preset) {
    parentPresenter?.unwindFromSettings(withData: preset)
    view.close()
  }

  private func overwritePreset(withIndex index: Int, on preset: Preset) {
    settings.presets[index] = preset

    syncStorage()
    updateTable()

    unwind(withPreset: settings.activePreset)
  }
}
