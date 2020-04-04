//
//  Builder.swift
//  metronome
//
//  Created by Egor on 3/18/20.
//  Copyright © 2020 Egor. All rights reserved.
//

import UIKit

// MARK: - Main

class Builder {
    static func createMainTabBarModule() -> UITabBarController {
        
        let storageManager = StorageManager<Preset>(withKeySavingString: GlobalSettings.STRING_OF_PRESETS_KEY_SAVING)
        let soundManager = SoundManager()
        let vibrationManager = VibrationManager()
        
        let metronomeModule = createMetronomeModule()
        let settingsModule = createSettingsModule()
        let instrumentModule = createInstrumentModule()
        let noteModule = createNoteModule()
        let collectionModule = createCollectionModule()
        
        let controller = MainTabBarController()
        controller.metronomeVC = metronomeModule.view
        controller.settingsVC = settingsModule.view
        controller.instrumentVC = instrumentModule.view
        controller.noteVC = noteModule.view
        controller.collectionVC = collectionModule.view
        controller.setupUI()
        
        let presenter = MainTabBarPresenter(controller: controller, metronome: metronomeModule.presenter, settings: settingsModule.presenter, instrument: instrumentModule.presenter, note: noteModule.presenter, collection: collectionModule.presenter, storageManager: storageManager, soundManager: soundManager, vibrationManager: vibrationManager)
        controller.presenter = presenter
        
        return controller
    }
    static func createMetronomeModule() -> (presenter: MetronomePresenter, view: MetronomeViewController) {
        var model = Metronome()
        for tick in 0..<GlobalSettings.STANDART_NUMBER_OF_TICKS {
            model.beats += [(instruments: GlobalSettings.STANDART_INSTRUMENTS[tick], notes: GlobalSettings.STANDART_NOTES[tick])]
        }
        let view = MetronomeViewController()
        let presenter = MetronomePresenter(view: view, model: model)
        view.presenter = presenter
        return (presenter: presenter, view: view)
    }
    static func createSettingsModule() -> (presenter: SettingsPresenter, view: SettingsViewController) {
        let model = Settings()
        let view = SettingsViewController()
        let presenter = SettingsPresenter(view: view, model: model)
        view.presenter = presenter
        return (presenter: presenter, view: view)
    }
    static func createInstrumentModule() -> (presenter: InstrumentTablePresenter, view: InstrumentTableViewController) {
        let model = InstrumentTable()
        let view = InstrumentTableViewController()
        let presenter = InstrumentTablePresenter(view: view, model: model)
        view.presenter = presenter
        return (presenter: presenter, view: view)
    }
    static func createNoteModule() -> (presenter: NoteTablePresenter, view: NoteTableViewController) {
        let model = NoteTable()
        let view = NoteTableViewController()
        let presenter = NoteTablePresenter(view: view, model: model)
        view.presenter = presenter
        return (presenter: presenter, view: view)
    }
    static func createCollectionModule() -> (presenter: CollectionPresenter, view: CollectionViewController) {
        let model = Collection()
        let view = CollectionViewController(collectionViewLayout: UICollectionViewFlowLayout())
        let presenter = CollectionPresenter(view: view, model: model)
        view.presenter = presenter
        return (presenter: presenter, view: view)
    }
}
