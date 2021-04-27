//
//  TempoCreator.swift
//  metronome
//
//  Created by Egor on 3/18/20.
//  Copyright © 2020 Egor. All rights reserved.
//

import Foundation
import UIKit

// MARK: - Protocols

protocol TapTempoDelegate: class {
  func changeBPM(to bpm: Int)
}

// MARK: - Main

class TempoCreator {

  // MARK: - Public

  weak var delegate: TapTempoDelegate?

  func tap() {
    taps.append(Tap(time: CACurrentMediaTime()))

    if taps.count < 2 {
      return
    }

    if taps[taps.count - 1].time - taps[taps.count - 2].time >= discardTimeout {
      taps = [taps[taps.count - 1]]
    }

    if taps.count < GlobalSettings.MIN_TAPS {
      return
    }

    if taps.count > GlobalSettings.MAX_TAPS {
      taps.remove(at: 0)
    }

    var timeIntervals = [Double]()

    for i in 1..<taps.count {
      timeIntervals.append(taps[i].time - taps[i - 1].time)
    }

    let bpm = Int(60.0 / (timeIntervals.reduce(0, +) / Double(timeIntervals.count)))

    delegate?.changeBPM(to: bpm)
  }

  // MARK: - Private

  private struct Tap {
    var time: Double
  }

  private let discardTimeout = 1.5
  private var taps = [Tap]()

}
