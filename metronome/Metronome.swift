//
//  Metronome.swift
//  metronome
//
//  Created by Egor on 3/17/20.
//  Copyright © 2020 Egor. All rights reserved.
//

import Foundation

// MARK: - Protocols

protocol MetronomeDelegate: class {
  func ticked()
}

// MARK: - Main

struct Metronome {
  typealias Tick = (instruments: [Instrument?], notes: [Note?])
  private var timer = BPMTimer(bpm: GlobalSettings.MIN_BPM)

  weak var delegate: MetronomeDelegate? {
    get {
      return timer.delegate
    }
    set {
      timer.delegate = newValue
    }
  }

  mutating func increaseTick() {
    tick += 1
    if tick >= maxTick {
      tick = 0
    }
  }

  var title: String = GlobalSettings.NAME_OF_UNTITLED_PRESET
  var BPM: Int {
    get {
      Int(timer.bpm)
    }
    set {
      timer.bpm = Double(newValue)
    }
  }
  var isOn: Bool {
    get {
      !timer.paused
    }
    set {
      if newValue {
        timer.start()
      } else {
        timer.stop()
      }
    }
  }
  var isOff: Bool {
    get {
      !isOn
    }
    set {
      isOn = !newValue
    }
  }
  var tick: Int = 0
  var maxTick: Int {
    beats.count
  }
  var tickDuration: Double {
    timer.tickDuration
  }
  var beats: [Tick] = []
}
