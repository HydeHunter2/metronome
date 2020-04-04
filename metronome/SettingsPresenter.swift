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
    func removeTableRow(withIndex index: Int)
    func getNameOfActivePreset() -> String
    func updateTable()
}

protocol SettingsPresenterProtocol {
    init(view: SettingsViewProtocol, model: Settings)
    func getNumberOfPresets() -> Int
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
        parentPresenter?.unwindFromSettings(withData: settings.presets[index])
        parentPresenter?.vibrationManager.successNotification()
    }
    
    func deleteRow(withIndex index: Int) {
        settings.presets.remove(at: index)
        view.removeTableRow(withIndex: index)
        updateTable()
    }
    
    func save() {
        
        let title = view.getNameOfActivePreset()
        // do some checks
        
        if settings.presets.map({ $0.title }).contains(title) {
            parentPresenter?.vibrationManager.errorNotification()
            return
        } else {
            parentPresenter?.vibrationManager.successNotification()
        }
        
        settings.activePreset.title = title
        settings.presets.append(settings.activePreset)
        
        syncStorage()
        updateTable()
    }
    
    func updateTable() {
        view.updateTable()
        parentPresenter?.vibrationManager.selectionChanged()
    }
    
    // MARK: - Private
    
    private func syncStorage() {
        parentPresenter?.storageManager.setData(settings.presets)
    }
    
}
