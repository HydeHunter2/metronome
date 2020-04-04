//
//  MainTabBarPresenterTest.swift
//  metronomeTests
//
//  Created by Egor on 3/25/20.
//  Copyright © 2020 Egor. All rights reserved.
//

import XCTest
@testable import metronome

// MARK: - Main

class MainTabBarPresenterTest: XCTestCase {

    // MARK: - Initialization
    
    var storageManager: MockStorageManager!
    var soundManager: MockSoundManager!
    var vibrationManager: MockVibrationManager!
    
    var metronomePresenter: MockMetronomePresenter!
    var settingsPresenter: MockSettingsPresenter!
    var instrumentPresenter: MockEditableTablePresenter!
    var notePresenter: MockEditableTablePresenter!
    var collectionPresenter: MockCollectionPresenter!
    
    var controller: MockMainTabBarController!
    var presenter: MainTabBarPresenter!
    
    override func setUp() {
        storageManager = MockStorageManager()
        soundManager = MockSoundManager()
        vibrationManager = MockVibrationManager()
        
        metronomePresenter = MockMetronomePresenter()
        settingsPresenter = MockSettingsPresenter()
        instrumentPresenter = MockEditableTablePresenter()
        notePresenter = MockEditableTablePresenter()
        collectionPresenter = MockCollectionPresenter()
        
        controller = MockMainTabBarController()
        presenter = MainTabBarPresenter(controller: controller, metronome: metronomePresenter, settings: settingsPresenter, instrument: instrumentPresenter, note: notePresenter, collection: collectionPresenter, storageManager: storageManager, soundManager: soundManager, vibrationManager: vibrationManager)
    }

    override func tearDown() {
        storageManager = nil
        soundManager = nil
        vibrationManager = nil
        
        metronomePresenter = nil
        settingsPresenter = nil
        instrumentPresenter = nil
        notePresenter = nil
        collectionPresenter = nil
        
        controller = nil
        presenter = nil
    }
    
    //MARK: - Tests

    func testPassingDataToMetronomePresenter() {
        let numberOfTicks = Int.random(in: GlobalSettings.RANGE_OF_DATA_IN_TICK_TO_TEST)
        var instruments = [[Instrument?]]()
        var notes = [[Note?]]()
        for tick in 0..<numberOfTicks {
            let numberOfInstruments = Int.random(in: GlobalSettings.RANGE_OF_DATA_IN_TICK_TO_TEST)
            instruments.append([])
            for _ in 0..<numberOfInstruments {
                instruments[tick].append(Instrument.all.randomElement() as! Instrument?)
            }
            
            let numberOfNotes = Int.random(in: GlobalSettings.RANGE_OF_DATA_IN_TICK_TO_TEST)
            notes.append([])
            for _ in 0..<numberOfNotes {
                notes[tick].append(Note.all.randomElement() as! Note?)
            }
        }
        instrumentPresenter.table.data = instruments
        notePresenter.table.data = notes
        
        presenter.passDataToMetronomePresenter()
        
        XCTAssertEqual(metronomePresenter.metronome.beats.map{ $0.instruments }, instruments)
        XCTAssertEqual(metronomePresenter.metronome.beats.map{ $0.notes }, notes)
    }
    
    func testPassingDataToMetronomePresenterWhenNumberOfNotesIsLess() {
        let numberOfTicks = Int.random(in: GlobalSettings.RANGE_OF_DATA_IN_TICK_TO_TEST)
        let numberOfNotes = Int.random(in: 0..<numberOfTicks)
        var instruments = [[Instrument?]]()
        var notes = [[Note?]]()
        for tick in 0..<numberOfTicks {
            let numberOfInstruments = Int.random(in: GlobalSettings.RANGE_OF_DATA_IN_TICK_TO_TEST)
            instruments.append([])
            for _ in 0..<numberOfInstruments {
                instruments[tick].append(Instrument.all.randomElement() as! Instrument?)
            }
            
            if tick > numberOfNotes { continue }
            
            let numberOfNotes = Int.random(in: GlobalSettings.RANGE_OF_DATA_IN_TICK_TO_TEST)
            notes.append([])
            for _ in 0..<numberOfNotes {
                notes[tick].append(Note.all.randomElement() as! Note?)
            }
        }
        instrumentPresenter.table.data = instruments
        notePresenter.table.data = notes
        
        presenter.passDataToMetronomePresenter()
        
        notes += Array<[Note?]>(repeating: [], count: numberOfTicks - numberOfNotes - 1)
        XCTAssertEqual(metronomePresenter.metronome.beats.map{ $0.instruments }, instruments)
        XCTAssertEqual(metronomePresenter.metronome.beats.map{ $0.notes }, notes)
    }
    
    func testPassingDataToMetronomePresenterWhenNumberOfNotesIsGreater() {
        let numberOfTicks = Int.random(in: GlobalSettings.RANGE_OF_DATA_IN_TICK_TO_TEST)
        let numberOfNotes = Int.random(in: (numberOfTicks+1)...GlobalSettings.RANGE_OF_DATA_IN_TICK_TO_TEST.upperBound)
        var instruments = [[Instrument?]]()
        var notes = [[Note?]]()
        for tick in 0..<numberOfNotes {
            let numberOfNotes = Int.random(in: GlobalSettings.RANGE_OF_DATA_IN_TICK_TO_TEST)
            notes.append([])
            for _ in 0..<numberOfNotes {
                notes[tick].append(Note.all.randomElement() as! Note?)
            }
            
            if tick > numberOfTicks { continue }
            
            let numberOfInstruments = Int.random(in: GlobalSettings.RANGE_OF_DATA_IN_TICK_TO_TEST)
            instruments.append([])
            for _ in 0..<numberOfInstruments {
                instruments[tick].append(Instrument.all.randomElement() as! Instrument?)
            }
        }
        instrumentPresenter.table.data = instruments
        notePresenter.table.data = notes
        
        presenter.passDataToMetronomePresenter()
        
        notes = Array(notes[...numberOfTicks])
        XCTAssertEqual(metronomePresenter.metronome.beats.map{ $0.instruments }, instruments)
        XCTAssertEqual(metronomePresenter.metronome.beats.map{ $0.notes }, notes)
    }
    
    func testSyncingData() {
        let numberOfTicks = Int.random(in: GlobalSettings.RANGE_OF_DATA_IN_TICK_TO_TEST)
        var beats = [(instruments: [Instrument?], notes: [Note?])]()
        for _ in 0..<numberOfTicks {
            let numberOfInstruments = Int.random(in: GlobalSettings.RANGE_OF_DATA_IN_TICK_TO_TEST)
            var instrumentsTick: [Instrument?] = []
            for _ in 0..<numberOfInstruments {
                instrumentsTick.append(Instrument.all.randomElement() as! Instrument?)
            }
            
            let numberOfNotes = Int.random(in: GlobalSettings.RANGE_OF_DATA_IN_TICK_TO_TEST)
            var notesTick: [Note?] = []
            for _ in 0..<numberOfNotes {
                notesTick.append(Note.all.randomElement() as! Note?)
            }
            
            beats.append((instruments: instrumentsTick, notes: notesTick))
        }
        metronomePresenter.metronome.beats = beats
        metronomePresenter.metronome.isOn = true
        
        presenter.syncData()
        
        XCTAssertTrue(metronomePresenter.metronome.isOff)
        XCTAssertTrue(instrumentPresenter.tableIsUpdated)
        XCTAssertTrue(notePresenter.tableIsUpdated)
        XCTAssertEqual(instrumentPresenter.table.data.map{ $0 as! [Instrument?] }, metronomePresenter.metronome.beats.map{ $0.instruments })
        XCTAssertEqual(notePresenter.table.data.map{ $0 as! [Note?] }, metronomePresenter.metronome.beats.map{ $0.notes })
    }
    
    // MARK: - Mocks
    
    class MockMainTabBarController: MainTabBarControllerProtocol {
        func showCollection() {}
        func showSettings() {}
    }

    class MockMetronomePresenter: ChildMetronomePresenterProtocol {
        var parentPresenter: ParentOfMetronomePresenterProtocol?
        var metronome = Metronome()
        func togglePower() {
            metronome.isOn.toggle()
        }
    }

    class MockSettingsPresenter: ChildSettingsPresenterProtocol {
        var parentPresenter: ParentOfSettingsPresenterProtocol?
        var settings = Settings()
        func updateTable() {
            
        }
    }

    class MockEditableTablePresenter: ChildEditableTablePresenterProtocol {
        var parentPresenter: ParentOfEditableTablePresenterProtocol?
        var table = Table() as TableProtocol
        var tableIsUpdated = false
        func updateTable() {
            tableIsUpdated = true
        }
        
        struct Table: TableProtocol {
            var data = [[metronome.Data?]]()
        }
    }

    class MockCollectionPresenter: ChildCollectionPresenterProtocol {
        var parentPresenter: ParentOfCollectionPresenterProtocol?
        var collection = Collection()
        func updateCollection() {}
    }
    
    class MockStorageManager: StorageManagerProtocol {
        func getData() -> [StorageObjectProtocol] { return [Preset.empty] }
        func setData(_ data: [StorageObjectProtocol]) {}
    }
    
    class MockSoundManager: SoundManagerProtocol {
        func playIntro(withTickDuration tickDuration: Double) {}
        func off() {}
        func wipe() {}
        func playTick(withSounds sounds: [Sound], tickDuration: Double) {}
        func playSound(_ sound: Sound) {}
    }
    
    class MockVibrationManager: VibrationManagerProtocol {
        func selectionChanged() {}
        func successNotification() {}
        func errorNotification() {}
        func warningNotification() {}
        func heavyImpact() {}
        func mediumImpact() {}
        func lightImpact() {}
        func softImpact() {}
        func rigidImpact() {}
    }
    
}
