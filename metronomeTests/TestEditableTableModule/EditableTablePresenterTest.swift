//
//  EditableTablePresenterTest.swift
//  metronomeTests
//
//  Created by Egor on 3/22/20.
//  Copyright © 2020 Egor. All rights reserved.
//

import XCTest
@testable import metronome

// MARK: - Main

class EditableTablePresenterTest: XCTestCase {
    
    // MARK: - Initialization
    
    var soundManager: MockSoundManager!
    
    var model: TableProtocol! {
        get { presenter?.table }
        set { presenter?.table = newValue }
    }
    var view: MockEditableTableView!
    var presenter: EditableTablePresenter!
    
    var parentPresenter: MockParentOfEditableTablePresenter!
    
    override func setUp() {
        soundManager = MockSoundManager()
        
        view = MockEditableTableView()
        presenter = EditableTablePresenter(view: view, model: Table(), soundManager: soundManager)
        
        parentPresenter = MockParentOfEditableTablePresenter()
        presenter.parentPresenter = parentPresenter
    }

    override func tearDown() {
        soundManager = nil
        
        view = nil
        presenter = nil
    }
    
    //MARK: - Tests
    
    func testAddingSection() {
        let configure = setupModelWithEmptyTicks()
        
        presenter.addSection()
        
        XCTAssertEqual(model.data.count, configure.sections + 1)
        XCTAssertTrue(view.updated)
    }
    
    func testAddingRow() {
        let configure = setupModelWithEmptyTicks()
        
        let section = Int.random(in: 0..<configure.sections)
        
        presenter.addRow(inSection: section)
        
        XCTAssertEqual(model.data[section].count, 1)
        XCTAssertTrue(view.updated)
    }
    
    func testGettingNumberOfSections() {
        let configure = setupModelWithEmptyTicks()
        
        XCTAssertEqual(presenter.getNumberOfSections(), configure.sections)
    }
    
    func testGettingNumberOfRowInSection() {
        let configure = setupModelWithEmptyTicks()
        let section = Int.random(in: 0..<configure.sections)
        
        XCTAssertEqual(presenter.getNumberOfRowInSection(withIndex: section), model.data[section].count)
    }
    
    func testDeletingRow() {
        let configure = setupModelWithNilTicks()
        view.table = model.data as! [[MockData?]]
        
        let section = Int.random(in: 0..<configure.sections)
        let row = Int.random(in: 0..<configure.rows)
        
        presenter.deleteRow(withPath: IndexPath(row: row, section: section))
        
        XCTAssertEqual(model.data[section].count, configure.rows - 1)
        XCTAssertEqual(view.table[section].count, configure.rows - 1)
        XCTAssertTrue(view.updated)
    }
    
    func testDeletingRowWithRemovingSection() {
        let configure = setupModelWithOneNilInTicks()
        view.table = model.data as! [[MockData?]]
        
        let section = Int.random(in: 0..<configure.sections)
        
        presenter.deleteRow(withPath: IndexPath(row: 0, section: section))
        
        XCTAssertEqual(model.data.count, configure.sections - 1)
        XCTAssertEqual(view.table.count, configure.sections - 1)
        XCTAssertTrue(view.updated)
    }
    
    func testMovingRowToAnotherSection() {
        let configure = setupModelWithNilTicks()
        
        let fromSection = Int.random(in: 0..<configure.sections)
        let fromRow = Int.random(in: 0..<configure.rows)
        
        model.data[fromSection][fromRow] = MockData.Test
        
        var toSection = Int.random(in: 0..<configure.sections)
        while toSection == fromSection {
            toSection = Int.random(in: 0..<configure.sections)
        }
        let toRow = Int.random(in: 0..<configure.rows)
        
        presenter.moveRow(from: IndexPath(row: fromRow, section: fromSection), to: IndexPath(row: toRow, section: toSection))
        
        XCTAssertEqual(model.data[fromSection].count, configure.rows - 1)
        XCTAssertNotNil(model.data[toSection][toRow])
        XCTAssertTrue(view.updated)
    }
    
    func testMovingRowToSameSection() {
        let configure = setupModelWithNilTicks()
        
        let fromSection = Int.random(in: 0..<configure.sections)
        let fromRow = Int.random(in: 0..<configure.rows)
        
        model.data[fromSection][fromRow] = MockData.Test
        
        let toSection = fromSection
        var toRow = Int.random(in: 0..<configure.rows)
        while toRow == fromRow {
            toRow = Int.random(in: 0..<configure.rows)
        }
        
        presenter.moveRow(from: IndexPath(row: fromRow, section: fromSection), to: IndexPath(row: toRow, section: toSection))
        
        XCTAssertEqual(model.data[fromSection].count, configure.rows)
        XCTAssertNotNil(model.data[toSection][toRow])
        XCTAssertTrue(view.updated)
    }
    
    func testMovingRowWithRemovingSection() {
        let configure = setupModelWithOneNilInTicks()
        view.table = model.data as! [[MockData?]]
        
        let fromSection = Int.random(in: 0..<configure.sections)
        
        model.data[fromSection][0] = MockData.Test

        var toSection = Int.random(in: 0..<configure.sections)
        while fromSection == toSection {
            toSection = Int.random(in: 0..<configure.sections)
        }
        
        presenter.moveRow(from: IndexPath(row: 0, section: fromSection), to: IndexPath(row: 0, section: toSection))
        
        XCTAssertEqual(model.data.count, configure.sections - 1)
        XCTAssertEqual(view.table.count, configure.sections - 1)
        XCTAssertNotNil(model.data[fromSection > toSection ? toSection : toSection - 1][0])
        XCTAssertTrue(view.updated)
    }
    
    func testGettingNameOfCell() {
        model.data = [[MockData.Test, nil]]
        let name = presenter.getNameForCell(withPath: IndexPath(row: 0, section: 0))
        let nilName = presenter.getNameForCell(withPath: IndexPath(row: 1, section: 0))
        
        XCTAssertEqual(name, "Test")
        XCTAssertEqual(nilName, nil)
    }
    
    func testParentPresenterUnwindingData() {
        let configure = setupModelWithNilTicks()
        let section = Int.random(in: 0..<configure.sections)
        let row = Int.random(in: 0..<configure.rows)
        
        presenter.openCollection(forEditingCellWithPath: IndexPath(row: row, section: section))
        
        XCTAssertNotNil(model.data[section][row])
        XCTAssertTrue(view.updated)
    }
    
    // MARK: - Private
    
    private func setupModel(withNumberOfNilsInTicks numberOfNils: Int) -> (sections: Int, rows: Int) {
        let numberOfTicks = Int.random(in: GlobalSettings.RANGE_OF_TICKS_TO_TEST)
        let nilTick = Array<MockData?>(repeating: nil, count: numberOfNils)
        model.data = Array<[MockData?]>(repeating: nilTick, count: numberOfTicks)
        
        return (sections: numberOfTicks, rows: numberOfNils)
    }
    
    private func setupModelWithNilTicks() -> (sections: Int, rows: Int) {
        return setupModel(withNumberOfNilsInTicks: Int.random(in: GlobalSettings.RANGE_OF_DATA_IN_TICK_TO_TEST))
    }
    
    private func setupModelWithOneNilInTicks() -> (sections: Int, rows: Int) {
        return setupModel(withNumberOfNilsInTicks: 1)
    }
    
    private func setupModelWithEmptyTicks() -> (sections: Int, rows: Int) {
        return setupModel(withNumberOfNilsInTicks: 0)
    }

    // MARK: - Mocks

    enum MockData: metronome.Data {
        
        case Test
        
        func name() -> String { return "Test" }
        
        static func getData(withName name: String) -> metronome.Data? {
            if name == "Test" { return MockData.Test }
            else { return nil }
        }
        
        static var all: [metronome.Data?] = [nil]
    }

    class MockEditableTableView: EditableTableViewProtocol {
        var table: [[MockData?]] = []
        var updated = false
        
        func updateTable() {
            updated = true
        }
        
        func removeTableSection(withIndex section: Int) {
            table.remove(at: section)
        }
        
        func removeTableRow(withPath path: IndexPath) {
            table[path.section].remove(at: path.row)
        }
    }

    class MockParentOfEditableTablePresenter: ParentOfEditableTablePresenterProtocol {
        var unwindFunctionFromCollection: ((metronome.Data?) -> ())?
        
        func moveToCollection(withData data: [metronome.Data?]) {
            guard let unwind = unwindFunctionFromCollection else { return }
            unwind(MockData.Test)
        }
    }
    
    class MockSoundManager: SoundManagerProtocol {
        func playIntro(withTickDuration tickDuration: Double) {}
        func off() {}
        func wipe() {}
        func playTick(withSounds sounds: [Sound], tickDuration: Double) {}
        func playSound(_ sound: Sound) {}
    }
    
}
