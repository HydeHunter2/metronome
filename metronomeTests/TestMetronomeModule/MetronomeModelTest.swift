//
//  MetronomeModelTest.swift
//  metronomeTests
//
//  Created by Egor on 3/22/20.
//  Copyright © 2020 Egor. All rights reserved.
//

import XCTest
@testable import metronome

// MARK: - Main

class MetronomeModelTest: XCTestCase {
    
    // MARK: - Initialization
    
    var model: Metronome! {
        get { presenter?.metronome }
        set { presenter?.metronome = newValue }
    }
    var presenter: MockMetronomePresenter!

    override func setUp() {
        presenter = MockMetronomePresenter(model: Metronome())
    }

    override func tearDown() {
        presenter = nil
    }
    
    //MARK: - Tests
    
    private let emptyTick: Metronome.Tick = (instruments: [nil], notes: [nil])
    
    func testMaxTick() {
        setupModel()
        
        XCTAssertEqual(model.maxTick, model.beats.count)
    }
    
    func testTickIncreasing() {
        setupModel()
        
        let expectedTick = Int.random(in: 1..<model.maxTick)
        
        for _ in 0..<expectedTick {
            model.increaseTick()
        }
        
        XCTAssertEqual(model.tick, expectedTick)
    }
    
    func testTickIncreasingWhenMaxTickIsZero() {
        model.beats = []
        
        for _ in 0..<Int.random(in: 1...2*GlobalSettings.STANDART_NUMBER_OF_TICKS) {
            model.increaseTick()
        }
        
        XCTAssertEqual(model.tick, 0)
    }
    
    func testTickIncreasingByValueGreaterThanMaxTick() {
        setupModel()
        
        let tickIncreasingValue = Int.random(in: model.maxTick..<4*model.maxTick)
        
        for _ in 0..<tickIncreasingValue {
            model.increaseTick()
        }
        
        XCTAssertEqual(model.tick, tickIncreasingValue % model.beats.count)
    }
    
    func testTurningOnAndOff() {
        model.isOn = true
        XCTAssertFalse(model.isOff)
        
        model.isOff = true
        XCTAssertFalse(model.isOn)
    }
    
    func testMetronomeDelegate() {
        setupModel()
        
        model.BPM = Int.random(in: GlobalSettings.MIN_BPM...GlobalSettings.MAX_BPM)
        
        let expectedTick = Int.random(in: 1..<model.maxTick)
        presenter.expect = expectation(description: "")
        presenter.expectedTick = expectedTick
        
        model.isOn = true
        
        waitForExpectations(timeout: Double(expectedTick)*model.tickDuration*1.1)
        XCTAssertEqual(model.tick, expectedTick)
    }
    
    // MARK: - Private
    
    private func setupModel() {
        let numberOfTicks = Int.random(in: GlobalSettings.RANGE_OF_TICKS_TO_TEST)
        model.beats = Array<Metronome.Tick>(repeating: emptyTick, count: numberOfTicks)
    }
 
    // MARK: - Mocks

    class MockMetronomePresenter: MetronomeDelegate {
        
        var expect: XCTestExpectation?
        var expectedTick = 0
        
        var metronome: Metronome
        init(model: Metronome) {
            self.metronome = model
            
            self.metronome.delegate = self
        }
        
        func ticked() {
            metronome.increaseTick()
            
            if metronome.tick == expectedTick {
                metronome.isOff = true
                expect?.fulfill()
            }
        }
    }
    
}
