//
//  SettingsPresenterTest.swift
//  metronomeTests
//
//  Created by Egor on 3/25/20.
//  Copyright © 2020 Egor. All rights reserved.
//

import XCTest
@testable import metronome

// MARK: - Main

class SettingsPresenterTest: XCTestCase {

    // MARK: - Initialization
    
    var model: Settings! {
        get { presenter?.settings }
        set { presenter?.settings = newValue }
    }
    var view: MockSettingsView!
    var presenter: SettingsPresenter!
    
    var parentPresenter: MockParentOfSettingsPresenter!
    
    override func setUp() {
        view = MockSettingsView()
        presenter = SettingsPresenter(view: view, model: Settings())
        
        parentPresenter = MockParentOfSettingsPresenter()
        presenter.parentPresenter = parentPresenter
    }

    override func tearDown() {
        view = nil
        presenter = nil
        
        parentPresenter = nil
    }

    //MARK: - Tests

    func testGettingNumberOfPresets() {
        let numberOfPresets = Int.random(in: GlobalSettings.RANGE_OF_PRESETS_TO_TEST)
        model.presets = Array<Preset>(repeating: Preset.empty, count: numberOfPresets)
        
        XCTAssertEqual(presenter.getNumberOfPresets(), numberOfPresets)
    }
    
    func testSelectingRow() {
        model.presets = [Preset.empty]
        presenter.selectRow(withIndex: 0)
        
        XCTAssertTrue(parentPresenter.unwinded)
    }
    
    func testDeletingRow() {
        model.presets = [Preset.empty]
        presenter.deleteRow(withIndex: 0)
        
        XCTAssertEqual(model.presets.count, 0)
        XCTAssertTrue(view.tableUpdated)
    }
    
    func testSaving() {
        model.activePreset = Preset.empty
        
        presenter.save()
        
        XCTAssertEqual(model.presets.count, 1)
        XCTAssertTrue(view.tableUpdated)
    }
    
    func testGettingNameOfRow() {
        let preset = Preset.empty
        let title = "TEST_NAME"
        preset.title = title
        model.presets = [preset]
        
        XCTAssertEqual(presenter.getNameOfRow(withIndex: 0), title)
    }
    
    func testGettingNumberOfTicks() {
        let preset = Preset.empty
        let numberOfTicks = Int.random(in: GlobalSettings.RANGE_OF_TICKS_TO_TEST)
        preset.beats = Array<(instruments: [Instrument?], notes: [Note?])>(repeating: (instruments: [], notes: []), count: numberOfTicks)
        model.presets = [preset]
        
        XCTAssertEqual(presenter.getNumberOfTicks(inRowWithIndex: 0), numberOfTicks)
    }
    
    // MARK: - Mocks
    
    class MockStorageManager: StorageManagerProtocol {
        var presets: [Preset] = []
        func getData() -> [StorageObjectProtocol] {
            return presets
        }
        func setData(_ data: [StorageObjectProtocol]) {
            presets = data as! [Preset]
        }
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
    
    class MockParentOfSettingsPresenter: ParentOfSettingsPresenterProtocol {
        var storageManager: StorageManagerProtocol = MockStorageManager()
        var vibrationManager: VibrationManagerProtocol = MockVibrationManager()
        var unwinded = false
        func unwindFromSettings(withData data: Preset) {
            unwinded = true
        }
    }
        
    class MockSettingsView: SettingsViewProtocol {
        var tableUpdated = false
        
        func removeTableRow(withIndex index: Int) { }
        func getNameOfActivePreset() -> String {
            return "TestName"
        }
        
        func updateTable() {
            tableUpdated = true
        }
    }
    
}
