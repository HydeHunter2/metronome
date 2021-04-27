//
//  InstrumentTableViewCell.swift
//  metronome
//
//  Created by Egor on 1/12/20.
//  Copyright © 2020 Egor. All rights reserved.
//

import UIKit
import AVFoundation

// MARK: - Main

class EditableTableCell: UITableViewCell {
  static let reuseID = String(describing: EditableTableCell.self) + "View"
  static let nib = UINib(nibName: reuseID, bundle: nil)

  @IBOutlet weak var soundButton: UIButton!
  @IBOutlet weak var selectButton: UIButton!

  var indexPath = IndexPath(row: 0, section: 0)
}
