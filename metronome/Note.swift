//
//  Note.swift
//  metronome
//
//  Created by Egor on 1/24/20.
//  Copyright © 2020 Egor. All rights reserved.
//

import Foundation

// MARK: - Main

enum Note: Data {
  case C
  case D
  case Db
  case E
  case Eb
  case F
  case G
  case Gb
  case A
  case Ab
  case B
  case Bb

  func name() -> String {
    switch self {
      case .C:
        return "C"
      case .D:
        return "D"
      case .Db:
        return "Db"
      case .E:
        return "E"
      case .Eb:
        return "Eb"
      case .F:
        return "F"
      case .G:
        return "G"
      case .Gb:
        return "Gb"
      case .A:
        return "A"
      case .Ab:
        return "Ab"
      case .B:
        return "B"
      case .Bb:
        return "Bb"
    }
  }

  static func getData(withName name: String) -> Data? {
    switch name {
      case "C":
        return Note.C
      case "D":
        return Note.D
      case "Db":
        return Note.Db
      case "E":
        return Note.E
      case "Eb":
        return Note.Eb
      case "F":
        return Note.F
      case "G":
        return Note.G
      case "Gb":
        return Note.Gb
      case "A":
        return Note.A
      case "Ab":
        return Note.Ab
      case "B":
        return Note.B
      case "Bb":
        return Note.Bb
      default:
        return nil
    }
  }

  static var all: [Data?] = [nil, Note.C, Note.D, Note.Db, Note.E, Note.Eb, Note.F, Note.G, Note.Gb, Note.A, Note.Ab, Note.B, Note.Bb]
}
