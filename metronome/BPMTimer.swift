//
//  BPMTimer.swift
//  metronome
//
//  Created by Egor on 1/15/20.
//  Copyright © 2020 Egor. All rights reserved.
//

import Foundation

// MARK: - Main

class BPMTimer {

  // MARK: - Initialization

  weak var delegate: MetronomeDelegate?

  var paused: Bool
  var bpm: Double {
    didSet {
      changeBPM()
    }
  }
  var tickDuration: Double {
    return 60 / bpm
  }
  var timeToNextTick: Double {
    if paused {
      return tickDuration
    } else {
      return abs(elapsedTime - tickDuration)
    }
  }
  var percentageToNextTick: Double {
    if paused {
      return 0
    } else {
      return min(100, (timeToNextTick / tickDuration) * 100)
    }
  }

  init(bpm: Int) {
    self.bpm = Double(bpm)
    self.paused = true
    self.lastTickTimestamp = CFAbsoluteTimeGetCurrent()
    self.timer = createNewTimer()
  }

  // MARK: - Public

  func start() {
    if paused {
      paused = false
      DispatchQueue.main.async {
        self.lastTickTimestamp = CFAbsoluteTimeGetCurrent()
        self.timer.resume()
      }
    }
  }

  func stop() {
    if !paused {
      paused = true
      timer.suspend()
    }
  }

  // MARK: - Private

  private var timer: DispatchSourceTimer!
  private lazy var timerQueue = DispatchQueue.global(qos: .utility)
  private var lastTickTimestamp: CFAbsoluteTime
  private var tickCheckInterval: Double {
    return tickDuration / 50
  }
  private var timerTolerance: DispatchTimeInterval {
    return DispatchTimeInterval.milliseconds(Int(tickCheckInterval / 10 * 1000))
  }
  private var elapsedTime: Double {
    return CFAbsoluteTimeGetCurrent() - lastTickTimestamp
  }

  private func createNewTimer() -> DispatchSourceTimer {
    let timer = DispatchSource.makeTimerSource(queue: timerQueue)
    let deadline: DispatchTime = DispatchTime.now() + tickCheckInterval
    timer.schedule(deadline: deadline, repeating: tickCheckInterval, leeway: timerTolerance)
    timer.setEventHandler { [weak self] in
      self?.tickCheck()
    }
    timer.activate()

    if paused {
      timer.suspend()
    }

    return timer
  }

  private func cancelTimer() {
    timer.setEventHandler(handler: nil)
    timer.cancel()
    if paused {
      timer.resume()
    }
  }

  private func replaceTimer() {
    cancelTimer()
    timer = createNewTimer()
  }

  private func changeBPM() {
    replaceTimer()
  }

  @objc private func tickCheck() {
    if (elapsedTime > tickDuration) || (timeToNextTick < 0.003) {
      tick()
    }
  }

  private func tick() {
    lastTickTimestamp = CFAbsoluteTimeGetCurrent()
    DispatchQueue.main.sync {
      self.delegate?.ticked()
    }
  }

  // MARK: - Deinitialization

  deinit {
    cancelTimer()
  }
}
