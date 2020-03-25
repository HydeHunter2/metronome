//
//  CollectionPresenterTest.swift
//  metronomeTests
//
//  Created by Egor on 3/23/20.
//  Copyright © 2020 Egor. All rights reserved.
//

import XCTest
@testable import metronome

// MARK: - Main

class CollectionPresenterTest: XCTestCase {

    // MARK: - Initialization
    
    var model: Collection! {
        get { presenter?.collection }
        set { presenter?.collection = newValue }
    }
    var view: MockCollectionView!
    var presenter: CollectionPresenter!
    
    var parentPresenter: MockParentOfCollectionPresenter!
    
    override func setUp() {
        view = MockCollectionView()
        presenter = CollectionPresenter(view: view, model: Collection())
        
        parentPresenter = MockParentOfCollectionPresenter()
        presenter.parentPresenter = parentPresenter
    }

    override func tearDown() {
        view = nil
        presenter = nil
    }
    
    //MARK: - Tests

    func testGettingNumberOfCells() {
        let _ = setupCollection()
        
        XCTAssertEqual(presenter.getNumberOfCells(), model.data.count)
    }
    
    func testSelectingCell() {
        let numberOfCells = setupCollection()
        let index = Int.random(in: 0..<numberOfCells)
        
        model.data[index] = MockData.Test
        presenter.selectCell(withIndex: index)
        
        XCTAssertEqual(parentPresenter.dataToUnwind, MockData.Test)
    }
    
    func testGettingImageName() {
        let numberOfCells = setupCollection()
        let index = Int.random(in: 0..<numberOfCells)
        
        model.data[index] = MockData.Test
        let name = presenter.getImageName(forIndex: index)
        
        XCTAssertEqual(name, "Test")
    }
    
    // MARK: - Private
    
    private func setupCollection() -> Int {
        let numberOfCells = Int.random(in: GlobalSettings.RANGE_OF_DATA_IN_TICK_TO_TEST)
        model.data = Array<MockData?>(repeating: nil, count: numberOfCells)
        
        return numberOfCells
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
    
    class MockCollectionView: CollectionViewProtocol {
        
        var updated = false
        
        func updateCollection() {
            updated = true
        }
    }
    
    class MockParentOfCollectionPresenter: ParentOfCollectionPresenterProtocol {
        
        var dataToUnwind: MockData? = nil
        
        func unwindFromCollection(data: metronome.Data?) {
            dataToUnwind = data as? CollectionPresenterTest.MockData
        }
    }
    
}
