//
//  Preset.swift
//  metronome
//
//  Created by Egor on 3/25/20.
//  Copyright © 2020 Egor. All rights reserved.
//

import Foundation

// MARK: - Main

class Preset: NSObject, NSCoding, StorageObjectProtocol {

  // MARK: - Initialization

  var title: String
  var beats: [(instruments: [Instrument?], notes: [Note?])]
  var instruments: [[Instrument?]] { beats.map { $0.instruments } }
  var notes: [[Note?]] { beats.map { $0.notes } }
  var BPM: Int

  init(title: String, beats: [(instruments: [Instrument?], notes: [Note?])], BPM: Int) {
    self.title = title
    self.beats = beats
    self.BPM = BPM
  }

  // MARK: - Public

  static let empty = Preset(title: GlobalSettings.NAME_OF_UNTITLED_PRESET,
                            beats: [],
                            BPM: GlobalSettings.MIN_BPM)

  // MARK: - Extensions

  func encode(with coder: NSCoder) {
    let beatsString = beats.map { tick in
      [tick.instruments, tick.notes].map { data in
        (data as! [Data?]).map {
          $0?.name() ?? GlobalSettings.STRING_OF_NILDATA
        }.joined(separator: ",")
      }.joined(separator: ":")
    }.joined(separator: "|")

    coder.encode(title, forKey: "title")
    coder.encode(beatsString, forKey: "beats")
    coder.encode(BPM, forKey: "BPM")
  }

  required convenience init?(coder: NSCoder) {
    let title = coder.decodeObject(forKey: "title") as! String
    let BPM = coder.decodeInteger(forKey: "BPM")
    let beatsString = coder.decodeObject(forKey: "beats") as! String

    var beats: [(instruments: [Instrument?], notes: [Note?])] = []
    for tick in beatsString.split(separator: "|") {
      let instruments = tick.split(separator: ":")[0]
                            .split(separator: ",")
                            .map { name in
        Instrument.getData(withName: String(name)) as! Instrument?
      }

      let notes = tick.split(separator: ":")[1]
                      .split(separator: ",")
                      .map { name in
        Note.getData(withName: String(name)) as! Note?
      }

      beats.append((instruments: instruments, notes: notes))
    }
    self.init(title: title, beats: beats, BPM: BPM)
  }
}
