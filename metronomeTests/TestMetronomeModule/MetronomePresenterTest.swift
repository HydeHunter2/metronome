//
//  MetronomePresenterTest.swift
//  metronomeTests
//
//  Created by Egor on 3/21/20.
//  Copyright © 2020 Egor. All rights reserved.
//

import XCTest
@testable import metronome

// MARK: - Main

class MetronomePresenterTest: XCTestCase {

    // MARK: - Initialization

    var model: Metronome! {
        get { presenter?.metronome }
        set { presenter?.metronome = newValue }
    }
    var view: MockMetronomeView!
    var presenter: MetronomePresenter!

    override func setUp() {
        view = MockMetronomeView()
        presenter = MetronomePresenter(view: view, model: Metronome())
    }

    override func tearDown() {
        view = nil
        presenter = nil
    }

    // MARK: - Tests

    func testPowerToggling() {
        let powerStateBefore = model.isOn
        let buttonImageBefore = view.buttonImage
        let idleTimerStateBefore = view.idleTimerIsOn

        presenter.togglePower()

        XCTAssertNotEqual(powerStateBefore, model.isOn)
        XCTAssertNotEqual(buttonImageBefore, view.buttonImage)
        XCTAssertNotEqual(idleTimerStateBefore, view.idleTimerIsOn)
    }

    func testChangingBpm() {
        let newBPM = Int.random(in: GlobalSettings.MIN_BPM...GlobalSettings.MAX_BPM)
        presenter.changeBPM(to: newBPM)

        XCTAssertEqual(model.BPM, newBPM)
        XCTAssertEqual(view.pickerValue, newBPM)
    }

    func testChangingBpmToValueLessThanMin() {
        let newBPM = Int.random(in: 0...GlobalSettings.MIN_BPM)
        presenter.changeBPM(to: newBPM)

        XCTAssertEqual(model.BPM, GlobalSettings.MIN_BPM)
        XCTAssertEqual(view.pickerValue, GlobalSettings.MIN_BPM)
    }

    func testChangingBpmToValueGreaterThanMax() {
        let newBPM = Int.random(in: GlobalSettings.MAX_BPM...2*GlobalSettings.MAX_BPM)
        presenter.changeBPM(to: newBPM)

        XCTAssertEqual(model.BPM, GlobalSettings.MAX_BPM)
        XCTAssertEqual(view.pickerValue, GlobalSettings.MAX_BPM)
    }

    func testChangingBpmByTapping() {
        let expect = expectation(description: "")

        let numberTaps = Int.random(in: GlobalSettings.MIN_TAPS...GlobalSettings.MAX_TAPS)
        let expectedBPM = Double(Int.random(in: GlobalSettings.MIN_BPM...GlobalSettings.MAX_BPM))
        let timeBetweenTicks = 60.0/expectedBPM

        var counterOfTaps = 0
        Timer.scheduledTimer(withTimeInterval: timeBetweenTicks, repeats: true) { timer in
            self.presenter.tempoTap()
            counterOfTaps += 1

            if counterOfTaps == numberTaps {
                expect.fulfill()
                timer.invalidate()
            }
        }

        waitForExpectations(timeout: timeBetweenTicks*Double(numberTaps)*1.05)
        XCTAssertTrue(Int(expectedBPM*0.95) < model.BPM && model.BPM < Int(expectedBPM*1.05))
    }

    // MARK: - Mocks

    class MockMetronomeView: MetronomeViewProtocol {

        enum ButtonImage {
            case Play
            case Pause
        }

        var pickerValue = 0
        var buttonImage = ButtonImage.Play
        var idleTimerIsOn = true

        func setValueOnPicker(to bpm: Int) {
            pickerValue = bpm
        }

        func putPauseImageOnPowerButton() {
            buttonImage = ButtonImage.Pause
        }
        func putPlayImageOnPowerButton() {
            buttonImage = ButtonImage.Play
        }
        func disableIdleTimer() {
            idleTimerIsOn = false
        }
        func enableIdleTimer() {
            idleTimerIsOn = true
        }
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
